local probability = 30 -- by default
function Initialize(Plugin)
    Plugin:SetName("Meteors")
    Plugin:SetVersion(2)
    cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATED, OnChunkGenerated)
    cPluginManager:BindCommand("/meteors", "meteors.probability", ChangeProb, "- Change the probability of meteor in chunk. Usage: /meteors prob [number]")

    LOG("Hello from " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
    return true
end

function ChangeProb(Split, Player)
	if (#Split ~= 3) then
		Player:SendMessage("Usage: /meteors prob [number]")
		return true
	end
	if Split[2] == "prob" then
		if type(tonumber(Split[3])) == "number" then
			probability = tonumber(Split[3])
			return true
		else
			Player:SendMessageFailure("Not a number!")
			return true
		end
	end
end

function OnChunkGenerated(g_World, g_ChunkX, g_ChunkZ, g_ChunkData)
    -- facing east, 0/0 (x/z) is left-top corner. grid is limited by 0-15.
    -- chest spawning only not in current chunk. WTFFF
    local rX = g_ChunkX * 16 + 16 -- another chunk
    local rY = 80
    local rZ = g_ChunkZ * 16 + 16 -- another chunk

    if math.random(0, probability) == 1 then
        rX = math.random(rX, rX + 16)
        rZ = math.random(rZ, rZ + 16)
        for i = 255, 0, -1 do
            local currBlock = g_World:GetBlock(Vector3i(rX, i, rZ))
            if currBlock ~= 0 then
                rY = i
                break
            end
        end
        -- facing east, working chunk is top-right.
        g_World:SetBlock(Vector3i(rX + 1, rY, rZ + 1), E_BLOCK_CHEST, 3)
        -- g_ChunkData:SetBlockTypeMeta(1, 70, 1, 54, 0)
        g_World:DoWithChestAt(rX + 1, rY, rZ + 1, function(ChestEntity)
            -- DIAMONDS
            ChestEntity:SetSlot(4, 1, cItem(264, 2))
            -- IRON
            ChestEntity:SetSlot(0, 0, cItem(15, 1))
            ChestEntity:SetSlot(1, 1, cItem(15, 1))
            ChestEntity:SetSlot(8, 0, cItem(15, 1))
            ChestEntity:SetSlot(8, 1, cItem(15, 1))
            ChestEntity:SetSlot(8, 2, cItem(15, 1))
            -- COBBLESTONE
            ChestEntity:SetSlot(2, 0, cItem(4, 1))
            ChestEntity:SetSlot(3, 0, cItem(4, 1))
            ChestEntity:SetSlot(5, 0, cItem(4, 1))
            ChestEntity:SetSlot(6, 0, cItem(4, 1))
            ChestEntity:SetSlot(0, 1, cItem(4, 1))
            ChestEntity:SetSlot(3, 1, cItem(4, 1))
            ChestEntity:SetSlot(7, 1, cItem(4, 1))
            ChestEntity:SetSlot(1, 2, cItem(4, 1))
            ChestEntity:SetSlot(5, 2, cItem(4, 1))
            ChestEntity:SetSlot(6, 2, cItem(4, 1))
            -- GUNPOWDER
            ChestEntity:SetSlot(4, 0, cItem(289, 1))
            ChestEntity:SetSlot(2, 1, cItem(289, 1))
            ChestEntity:SetSlot(6, 1, cItem(289, 1))
            ChestEntity:SetSlot(3, 2, cItem(289, 1))
            ChestEntity:SetSlot(4, 2, cItem(289, 1))
            -- GLASS
            ChestEntity:SetSlot(1, 0, cItem(20, 1))
            ChestEntity:SetSlot(7, 0, cItem(20, 1))
            ChestEntity:SetSlot(5, 1, cItem(20, 1))
            ChestEntity:SetSlot(0, 2, cItem(20, 1))
            ChestEntity:SetSlot(2, 2, cItem(20, 1))
            ChestEntity:SetSlot(7, 2, cItem(20, 1))
        end)
        g_World:SetBlock(Vector3i(rX + 1, rY, rZ), 49, 0)
        g_World:SetBlock(Vector3i(rX + 1, rY - 1, rZ + 1), 49, 0)
        g_World:SetBlock(Vector3i(rX + 2, rY, rZ + 1), 49, 0)
        g_World:SetBlock(Vector3i(rX + 1, rY + 1, rZ + 1), 87, 0)
        g_World:SetBlock(Vector3i(rX + 1, rY + 2, rZ + 1), 51, 0)
        g_World:SetBlock(Vector3i(rX + 1, rY, rZ + 2), 49, 0)
        g_World:SetBlock(Vector3i(rX, rY, rZ + 1), 49, 0)
        g_World:CastThunderbolt(Vector3i(rX, rY, rZ))
        LOG("Meteor spawned! Chest: (" .. rX + 1 .. ", " .. rY .. ", " .. rZ + 1 .. "), Chunk: (" .. g_ChunkX .. ", " .. g_ChunkZ .. ").")
    end
end

function OnDisable() 
	LOG("Nah, you're safe today. (Disabled)") 
end
