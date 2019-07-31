local register_on_receive = minetest.register_on_receiving_chat_message or minetest.register_on_receiving_chat_messages

local copy_on = false
local command_output

minetest.register_chatcommand("copycmd", {
    description = "toggle on/off",
    params = "",
    func = function()
      copy_on = not copy_on
    end
  })

if register_on_receive then
  register_on_receive(function(message)

      if copy_on == true then
        command_output = minetest.strip_colors(message)    

        -- ignore messages/PMs /me's etc
        if string.sub(command_output, 1, 1) == '<' or string.match(command_output, "PM from") or string.match(command_output, "Message sent.") or string.sub(command_output, 1, 1) == '*' or string.match(command_output, "is not online.") then return end

        local form  =
        "size[9.5,9.5]" ..  -- width, height
        "bgcolor[#080808BB; false]" ..
        "textarea[0.5,0.5;9,9.5;pass;Output from command: ;"..command_output.."]"..
        "button_exit[3,8.75;3,1;Log;Log]"

        minetest.show_formspec("copy_command", form)          
      end

    end)
else
end

minetest.register_on_formspec_input(function(formname, fields)
    if formname ~= "copy_command" then return false end

    if fields.Log then
      minetest.log("command output: " ..command_output)
    end
  end)