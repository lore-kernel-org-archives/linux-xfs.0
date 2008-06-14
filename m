Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jun 2008 09:42:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5EGgF21022296
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:42:16 -0700
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDBAFFCBBEB
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:43:12 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.179]) by cuda.sgi.com with ESMTP id WbGgx7b8YawjDiLv for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:43:12 -0700 (PDT)
Received: by wa-out-1112.google.com with SMTP id j5so4037342wah.18
        for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:43:12 -0700 (PDT)
Message-ID: <dd599fe00806140943g13c790dfo9b3a84d7f9841641@mail.gmail.com>
Date: Sat, 14 Jun 2008 12:43:12 -0400
From: Simon <simonjj@gmail.com>
Subject: xfs_repair trouble
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello all,


I have a corrupted xfs filesystem on top of a RAID 5 (1TB in size).
The RAID is still fully intact but the filesystem was damaged. When
trying to repair the filesystem xfs_repair fails. I have tried various
versions of xfs_repair, the latest stable (2.9.8) and the latest trunk
(from CVS). I'd love to investigate and/or fix the issue further but I
am a bit confused about some of my xfs_repair runs (both done with
trunk).
Could someone shed some light on where the problem could be, I'd be
happy to continue digging if I would only know where roughly

Run 1 ============================================
./xfs_repair -P -m 170 /dev/evms/monster_evms
... more output ...
bad hash table for directory inode 4842 (no data entry): rebuilding
rebuilding directory inode 4842
entry ".." in directory inode 27930072 points to free inode 2013274702
bad hash table for directory inode 27930072 (no data entry): rebuilding
rebuilding directory inode 27930072
bad hash table for directory inode 28776251 (no data entry): rebuilding
rebuilding directory inode 28776251
fixing i8count in inode 29111010
xfs_repair: phase6.c:3411: shortform_dir2_entry_check: Assertion
`bytes_deleted > 0' failed.
Aborted
=================================================
Exits with an Assert, it would be interesting to know why this Assert
is there and what it means for bytes_deleted to be 0.


Run 2 ============================================
./xfs_repair -P -m 166 /dev/evms/monster_evms
... more output ...
bad hash table for directory inode 2013274673 (no data entry): rebuilding
rebuilding directory inode 2013274673
bad hash table for directory inode 2029477400 (no data entry): rebuilding
rebuilding directory inode 2029477400
bad hash table for directory inode 2037825112 (no data entry): rebuilding
rebuilding directory inode 2037825112

fatal error -- malloc failed in longform_dir2_entry_check (2585598792 bytes)
=================================================
Exists with an malloc failed, even though I am using the -m option
which I think was created to avoid exactly this scenario. Run 3


Run 3 ============================================
./xfs_repair -P -m 200 /dev/evms/monster_evms
... more output ...
       - agno = 38
       - agno = 39
Phase 5 - rebuild AG headers and trees...
       - reset superblock...
Phase 6 - check inode connectivity...
       - resetting contents of realtime bitmap and summary inodes
       - traversing filesystem ...
bad hash table for directory inode 4842 (no data entry): rebuilding
rebuilding directory inode 4842
bad hash table for directory inode 28776251 (no data entry): rebuilding
rebuilding directory inode 28776251
fixing i8count in inode 29111010
corrupt block 0 in directory inode 321685982: junking block
Segmentation fault
=================================================
Exists with a Seg Fault. I found this one interesting especially since
it happens at the exact same inode as Run 1


All comments appreciated.
Simon
