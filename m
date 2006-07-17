Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Jul 2006 18:15:42 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.de [213.165.64.21])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6H1FVDW023245
	for <xfs@oss.sgi.com>; Sun, 16 Jul 2006 18:15:32 -0700
Message-ID: <44BAD692.8070402@gmx.de>
Date: Mon, 17 Jul 2006 02:15:14 +0200
From: Michel <lomik@gmx.de>
MIME-Version: 1.0
Subject: XFS failure
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello dear developer,

almost every week on checking my fs i get
*
livecd root # xfs_check /dev/sda3
bad free block nused 2 should be 8 for dir ino 220115 block 16777216
bad free block nused 0 should be 6 for dir ino 34171444 block 16777216
bad free block nvalid/nused 5/-1 for dir ino 35644249 block 16777216
missing free index for data block 0 in dir ino 35644249
missing free index for data block 1 in dir ino 35644249
missing free index for data block 2 in dir ino 35644249
missing free index for data block 3 in dir ino 35644249
missing free index for data block 4 in dir ino 35644249*


when i run xfs_repair ... here is the output

*livecd / # xfs_repair /dev/sda3
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
free block 16777216 for directory inode 35644249 bad nused
rebuilding directory inode 35644249
free block 16777216 for directory inode 34171444 bad nused
rebuilding directory inode 34171444
free block 16777216 for directory inode 220115 bad nused
rebuilding directory inode 220115
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done*


After repairing, xfs_check reports no more errors. I always unmounting
my devices cleanly ... and i never had any power failure! But every week
i get the same errors. My HDD is 1 month old and i already tested it for
bad sectors.

Regards

Michel


[[HTML alternate version deleted]]
