Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:36016 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751216AbdGPSKR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 16 Jul 2017 14:10:17 -0400
Received: from localhost (localhost [IPv6:::1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by trent.utfs.org (Postfix) with ESMTPS id 787EE5F869
        for <linux-xfs@vger.kernel.org>; Sun, 16 Jul 2017 20:01:37 +0200 (CEST)
Date: Sun, 16 Jul 2017 11:01:37 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Metadata corruption detected at xfs_inode_buf_verify
Message-ID: <alpine.DEB.2.21.1.1707161018130.22141@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

so, the disk enclosure attached to my RaspberryPi[0] had "some" kind of 
failure last night: one of the disks appears to have some kind of hardware 
problem, the other is fine, but the XFS file system cannot be mounted. 
Instead of using the RPI to try the repair, I attached the enclosure to an 
Intel i7 machine (16 GB RAM) and attempted to mount:

====================================================
# uname -r
4.9.0-3-amd64

# mount -t xfs /dev/mapper/owc1 /mnt/
mount: mount /dev/mapper/owc1 on /mnt/ failed: Structure needs cleaning

# dmesg
XFS (dm-1): Mounting V5 Filesystem
XFS (dm-1): Starting recovery (logdev: internal)
XFS (dm-1): Metadata corruption detected at xfs_inode_buf_verify+0x6e/0xf0 [xfs], xfs_inode block 0x5a48d610
XFS (dm-1): Unmount and run xfs_repair 
XFS (dm-1): First 64 bytes of corrupted metadata buffer:
ffff9cb8cc428000: dc 70 f3 22 07 71 ab 49 6c a6 5c 23 c9 b1 31 37  .p.".q.Il.\#..17
ffff9cb8cc428010: 3f db 62 33 54 87 4d 7d 1e 09 cc 4b fb 2c b0 22  ?.b3T.M}...K.,."
ffff9cb8cc428020: a9 54 91 1a 41 40 fe e1 16 7e 82 e1 56 b4 a8 9a  .T..A@...~..V...
ffff9cb8cc428030: 29 67 de c0 75 01 75 77 3a 1b af 5a 60 1c 4c c7  )g..u.uw:..Z`.L.
XFS (dm-1): Metadata corruption detected at xfs_inode_buf_verify+0x6e/0xf0 [xfs], xfs_inode block 0x5a48d610
XFS (dm-1): Unmount and run xfs_repair 
XFS (dm-1): First 64 bytes of corrupted metadata buffer:
[...]
====================================================

But it cannot be repaired either:

====================================================
# xfs_repair -V
xfs_repair version 4.11.0

# time xfs_repair -v /dev/mapper/owc1; echo $?
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
        - block cache size set to 1425416 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 3282156 tail block 3268500
ERROR: The filesystem has valuable metadata changes in a log which needs 
to be replayed.  Mount the filesystem to replay the log, and unmount it 
before re-running xfs_repair.  If you are unable to mount the filesystem, 
then use the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a 
mount of the filesystem before doing this.

real    0m21.893s
user    0m0.004s
sys     0m0.008s
2
====================================================


I saved the outputs of xfs_logprint, xfs_logprint -t and xfs_metadump and 
then used the -L option to attempt the repair, but this failed (after 
Phase 6) with:


====================================================
# time xfs_repair -v /dev/mapper/owc1; echo $?
[...]
entry ".." in directory inode 4574814913 points to free inode 268568894, 
marking entry to be junked
bad hash table for directory inode 4574814913 (no data entry): rebuilding
rebuilding directory inode 4574814913
Invalid inode number 0x0
xfs_dir_ino_validate: XFS_ERROR_REPORT

fatal error -- couldn't map inode 4574814915, err = 117

real    37m25.619s
user    0m41.780s
sys     0m14.852s
1
====================================================

Full dmesg and command outputs: http://nerdbynature.de/bits/4.12.0-rc7/

The logprint and metadump outputs could be provided at request, I guess.

Any ideas on how to tackle this?

Thanks,
Christian.

[0] https://www.spinics.net/lists/linux-xfs/msg05618.html
-- 
BOFH excuse #183:

filesystem not big enough for Jumbo Kernel Patch
