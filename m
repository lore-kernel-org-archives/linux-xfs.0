Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Mar 2008 16:33:43 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m220XL3X032309
	for <xfs@oss.sgi.com>; Sat, 1 Mar 2008 16:33:24 -0800
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E5CDE2360B
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2008 16:33:49 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.188]) by cuda.sgi.com with ESMTP id eUfSGQFv5o2zqkxQ for <xfs@oss.sgi.com>; Sat, 01 Mar 2008 16:33:49 -0800 (PST)
Message-ID: <47C9F5E9.70703@mathtm.de>
Date: Sun, 02 Mar 2008 01:33:45 +0100
From: =?ISO-8859-15?Q?Thomas_M=FCller?= <thomas@mathtm.de>
MIME-Version: 1.0
Subject: Re: Kernel oops / XFS filesystem corruption
References: <47C93C32.40006@mathtm.de> <47C9C44D.8080400@sandeen.net>
In-Reply-To: <47C9C44D.8080400@sandeen.net>
Content-Type: multipart/mixed;
 boundary="------------080300090103030503010006"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080300090103030503010006
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Eric Sandeen wrote:
> Did you also happen to save the xfs_repair output?
No, but I made a complete copy of the file system before
repairing it, so I can easily recreate it... :)


Thomas

--------------080300090103030503010006
Content-Type: text/plain;
 name="xfs_repair"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_repair"

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
data fork in ino 128638 claims free block 19018
        - agno = 1
        - agno = 2
b5ac7b90: Badness in key lookup (length)
bp=(bno 11701280, len 32768 bytes) key=(bno 11701280, len 8192 bytes)
b5ac7b90: Badness in key lookup (length)
bp=(bno 11708896, len 32768 bytes) key=(bno 11708896, len 8192 bytes)
b5ac7b90: Badness in key lookup (length)
bp=(bno 11739296, len 32768 bytes) key=(bno 11739296, len 8192 bytes)
b5ac7b90: Badness in key lookup (length)
bp=(bno 11751440, len 32768 bytes) key=(bno 11751440, len 8192 bytes)
b5ac7b90: Badness in key lookup (length)
bp=(bno 11754176, len 32768 bytes) key=(bno 11754176, len 8192 bytes)
b5ac7b90: Badness in key lookup (length)
bp=(bno 12026592, len 32768 bytes) key=(bno 12026592, len 8192 bytes)
        - agno = 3
b50c6b90: Badness in key lookup (length)
bp=(bno 15569728, len 32768 bytes) key=(bno 15569728, len 8192 bytes)
b50c6b90: Badness in key lookup (length)
bp=(bno 15626080, len 32768 bytes) key=(bno 15626080, len 8192 bytes)
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
b41ffb90: Badness in key lookup (length)
bp=(bno 31116224, len 32768 bytes) key=(bno 31116224, len 8192 bytes)
b41ffb90: Badness in key lookup (length)
bp=(bno 31117856, len 32768 bytes) key=(bno 31117856, len 8192 bytes)
b41ffb90: Badness in key lookup (length)
bp=(bno 31128704, len 32768 bytes) key=(bno 31128704, len 8192 bytes)
b41ffb90: Badness in key lookup (length)
bp=(bno 31239104, len 32768 bytes) key=(bno 31239104, len 8192 bytes)
b41ffb90: Badness in key lookup (length)
bp=(bno 31261408, len 32768 bytes) key=(bno 31261408, len 8192 bytes)
        - agno = 8
local inode 33609156 attr too small (size = 0, min size = 4)
bad attribute fork in inode 33609156, clearing attr fork
clearing inode 33609156 attributes
cleared inode 33609156
        - agno = 9
b50c6b90: Badness in key lookup (length)
bp=(bno 38861808, len 32768 bytes) key=(bno 38861808, len 8192 bytes)
        - agno = 10
b41ffb90: Badness in key lookup (length)
bp=(bno 42752032, len 32768 bytes) key=(bno 42752032, len 8192 bytes)
        - agno = 11
        - agno = 12
b50c6b90: Badness in key lookup (length)
bp=(bno 50475360, len 32768 bytes) key=(bno 50475360, len 8192 bytes)
b50c6b90: Badness in key lookup (length)
bp=(bno 50629312, len 32768 bytes) key=(bno 50629312, len 8192 bytes)
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
bad bmap btree ptr 0xc3a0000100000000 in ino 33609156
bad data fork in inode 33609156
cleared inode 33609156
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
entry "locking.tdb" in directory inode 33585205 points to free inode 33609156
bad hash table for directory inode 33585205 (no data entry): rebuilding
rebuilding directory inode 33585205
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 12636191, moving to lost+found
disconnected inode 12643748, moving to lost+found
disconnected inode 12643751, moving to lost+found
disconnected inode 12674162, moving to lost+found
disconnected inode 12674190, moving to lost+found
disconnected inode 12686342, moving to lost+found
disconnected inode 12689047, moving to lost+found
disconnected inode 12689059, moving to lost+found
disconnected inode 12961449, moving to lost+found
disconnected inode 16816212, moving to lost+found
disconnected inode 16872569, moving to lost+found
disconnected inode 33609179, moving to lost+found
disconnected inode 33609189, moving to lost+found
disconnected inode 33610799, moving to lost+found
disconnected inode 33610824, moving to lost+found
disconnected inode 33610838, moving to lost+found
disconnected inode 33610839, moving to lost+found
disconnected inode 33621664, moving to lost+found
disconnected inode 33621671, moving to lost+found
disconnected inode 33621672, moving to lost+found
disconnected inode 33732053, moving to lost+found
disconnected inode 33754372, moving to lost+found
disconnected inode 41977984, moving to lost+found
disconnected inode 46179860, moving to lost+found
disconnected inode 54526415, moving to lost+found
disconnected inode 54680382, moving to lost+found
Phase 7 - verify and correct link counts...
done

--------------080300090103030503010006--
