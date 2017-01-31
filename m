Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:36937 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbdAaINf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jan 2017 03:13:35 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Tue, 31 Jan 2017 09:03:02 +0100
Message-ID: <2761160.nkKuazU1Dh@libor-nb>
In-Reply-To: <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com> <2626665.Hsx8YazNWY@libor-nb> <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Hello,
sorry for late reply. It didn't crash since than and i forgot and moved on to another tasks.

Yesterday it crashed on one of machines (running 4.8.11)
-------------------------
Jan 30 07:18:13 vps2 kernel: [5881831.379547] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x12f63f40
Jan 30 07:18:13 vps2 kernel: [5881831.381721] XFS (dm-2): Unmount and run xfs_repair
Jan 30 07:18:13 vps2 kernel: [5881831.382750] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Jan 30 07:18:13 vps2 kernel: [5881831.387810] XFS (dm-2): metadata I/O error: block 0x12f63f40 ("xfs_trans_read_buf_map") error 117 numblks 8
Jan 30 07:26:02 vps2 kernel: [5882300.524528] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x12645ef8
Jan 30 07:26:02 vps2 kernel: [5882300.525993] XFS (dm-2): Unmount and run xfs_repair
Jan 30 07:26:02 vps2 kernel: [5882300.526539] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Jan 30 07:26:02 vps2 kernel: [5882300.529224] XFS (dm-2): metadata I/O error: block 0x12645ef8 ("xfs_trans_read_buf_map") error 117 numblks 8
Jan 30 10:00:27 vps2 kernel: [5891564.682483] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe8/0x100 [xfs], xfs_attr3_leaf block 0x127b5578
Jan 30 10:00:27 vps2 kernel: [5891564.683962] XFS (dm-2): Unmount and run xfs_repair
Jan 30 10:00:27 vps2 kernel: [5891564.684536] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Jan 30 10:00:27 vps2 kernel: [5891564.687223] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1250 of file /build/linux-lVEVrl/linux-4.7.8/fs/xfs/xfs_buf.c.  Return address = 0xffffffffc06747f2
Jan 30 10:00:27 vps2 kernel: [5891564.687230] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
Jan 30 10:00:27 vps2 kernel: [5891564.687778] XFS (dm-2): Please umount the filesystem and rectify the problem(s)

and later 
Jan 30 21:10:31 vps2 kernel: [39747.917831] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x24c17ba8
Jan 30 21:10:31 vps2 kernel: [39747.918130] XFS (dm-2): metadata I/O error: block 0x24c17ba8 ("xfs_trans_read_buf_map") error 117 numblks 8
-------------------------

I have scheduled repair on today, all these blocks were repaired using xfsprogs 4.9.0
Kernel is now 4.8.15

-------------------------
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
Metadata corruption detected at xfs_attr3_leaf block 0x12645ef8/0x1000
bad attribute count 0 in attr block 0, inode 1074268922
problem with attribute contents in inode 1074268922
clearing inode 1074268922 attributes
correcting nblocks for inode 1074268922, was 1 - counted 0
Metadata corruption detected at xfs_attr3_leaf block 0x127b5578/0x1000
bad attribute count 0 in attr block 0, inode 1077334032
problem with attribute contents in inode 1077334032
clearing inode 1077334032 attributes
correcting nblocks for inode 1077334032, was 1 - counted 0
Metadata corruption detected at xfs_attr3_leaf block 0x12f63f40/0x1000
bad attribute count 0 in attr block 0, inode 1093437859
problem with attribute contents in inode 1093437859
clearing inode 1093437859 attributes
correcting nblocks for inode 1093437859, was 1 - counted 0
        - agno = 2
Metadata corruption detected at xfs_attr3_leaf block 0x24c17ba8/0x1000
bad attribute count 0 in attr block 0, inode 2147673775
problem with attribute contents in inode 2147673775
clearing inode 2147673775 attributes
correcting nblocks for inode 2147673775, was 1 - counted 0
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
bad attribute format 1 in inode 1074268922, resetting value
bad attribute format 1 in inode 1077334032, resetting value
bad attribute format 1 in inode 1093437859, resetting value
        - agno = 2
bad attribute format 1 in inode 2147673775, resetting value
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
-------------------------

Thank you very much for patch, it has done it's work

Libor

