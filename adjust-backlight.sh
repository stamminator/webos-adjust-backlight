#!/bin/sh

direction=$1
changeValue=$2

if [[ $direction != "up" && $direction != "down" ]]; then
    echo "Error: Argument 1 must have either the value 'up' or 'down'."
    exit 1
fi

if ! echo "$changeValue" | grep -q '^[0-9][0-9]*$'; then
    echo "Error: Argument 2 must be numeric."
    exit 1
fi

if [ "$changeValue" -lt 0 ] || [ "$changeValue" -gt 100 ]; then
    echo "Error: Argument 2 must be within the range of 0 to 100."
    exit 1
fi

backlightVal=$(luna-send -f -n 1 "luna://com.webos.settingsservice/getSystemSettings" '{"category":"picture", "key": "backlight"}' -q "settings.backlight" | fgrep -e "settings.backlight" | cut -d':' -f2 | xargs)

if [[ $direction == "up" ]]; then
    newBacklightVal=$(( (backlightVal + $changeValue) <= 100 ? backlightVal + $changeValue : 100 ))
else
    newBacklightVal=$(( (backlightVal - $changeValue) >= 0 ? backlightVal - $changeValue : 0 ))
fi

echo "Brightness set to "$newBacklightVal

luna-send -n 1 "luna://com.webos.settingsservice/setSystemSettings" '{"category":"picture","settings":{"backlight":'"$newBacklightVal"'},"notifySelf":false}'