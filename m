Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:38196 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755179AbeE0SoO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 27 May 2018 14:44:14 -0400
Date: Sun, 27 May 2018 11:36:47 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: xfs_repair: Invalid inode number 0x0 / couldn't map inode
Message-ID: <alpine.DEB.2.21.999.1805271107250.6371@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: eflorac@intellique.com

Hi,

so, after some months of stable service, this Raspberry Pi 3B acted up 
again and logged some XFS errors:

kernel: XFS (dm-1): Metadata corruption detected at xfs_inode_buf_verify+0x94/0x140, xfs_inode block 0x1b4b1c5b0
kernel: XFS (dm-1): Unmount and run xfs_repair
kernel: XFS (dm-1): First 128 bytes of corrupted metadata buffer:

This dm-1 is a dm-crypt device, backed by a 2 TB disk in an USB-attached 
disk enclosure. I've been told that this RPI (1 GB RAM) may be a bit weak 
to handle disks that large, but I just won't listen :-)

Now the interesting part: I ran xfs_repair 4.15.1 on that same RPI, and 
although it was not killed by any out-of-memory mechanisms this time, it 
always ended with:

=================================
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - agno = 0
entry "libsystemd-238.76-1.0" in dir ino 399463 doesn't have a .. entry, will set it in ino 5905743567.
        - agno = 1
Invalid inode number 0x0
xfs_dir_ino_validate: XFS_ERROR_REPORT

fatal error -- couldn't map inode 268555554, err = 117
=================================


I've then attached the storage to a Thinkpad laptop (x86-64, 32 GB RAM) 
but xfs_repair 4.15.1 reported just the same. Only a freshly compiled 
xfs_repair 4.16.1 was able to repair the file system. Nothing was moved to 
lost+found. Please note that I was able to mount the file system at all 
times, i.e. even after a failed repair attempt.

This "Invalid inode number 0x0" was reported last year on this list, but 
it seems to be a different issue (I did not see any "Badness in key 
lookup" messages):

  > Re: Weird xfs_repair error
  > https://www.spinics.net/lists/linux-xfs/msg08593.html

The file system appears to be repaired now and is running again on that 
RPI, but I thought I report that incident anyways. Here are the full logs 
of all that:

   http://nerdbynature.de/bits/4.16/xfs/

So, thanks for maintaining and developing xfsprogs, v4.16.1 really did the 
trick here! :-)

Christian.
-- 
BOFH excuse #81:

Please excuse me, I have to circuit an AC line through my head to get this database working.
