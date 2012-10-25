Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PDhRVk122752
	for <linux-xfs@oss.sgi.com>; Thu, 25 Oct 2012 08:43:27 -0500
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id WFunnCWVPJorb7ll
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<linux-xfs@oss.sgi.com>; Thu, 25 Oct 2012 06:45:12 -0700 (PDT)
Received: by mail-la0-f53.google.com with SMTP id l5so1654207lah.26
	for <linux-xfs@oss.sgi.com>; Thu, 25 Oct 2012 06:45:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Oct 2012 09:45:10 -0400
Message-ID: <CAC=U0a2T_J9Y6WzvWyFfbBSDy__Pr7f4gfQBie2o0VhAm2jCaQ@mail.gmail.com>
Subject: xfs filesystem corruption with kernel 2.6.37
From: Kamal Dasu <kdasu.kdev@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

I am trying to understand how to get out of a failing  mount
gracefully to be able to repair the disk.
(dev/sda2 is log parition and dev/sda/3 is used as  rt subvolume partition)
I have a corrupted disk that is used for recording video constantly.
Using xfs on 2.6.37 kernel with all the knwn rt subvolume patches, the
mount appears to hang, however it gets  into an infinite loop in
xfs_itruncate_finish():xfs_inode.c.  :

#4  0x801bd180 in xfs_bunmapi (tp=0xe83476cf, ip=0x80a386cf,
bno=4278648832, len=72057594054705152, flags=0, nexts=33554432,
firstblock=0xb0bbcdcf, flist=0xb8bbcdcf, done=0xa8bbcdcf)
    at fs/xfs/xfs_bmap.c:5266
#5  0x801dd3f8 in xfs_itruncate_finish (tp=0x1cbccdcf, ip=0x80a386cf,
new_size=<optimized out>, fork=0, sync=16777216) at
fs/xfs/xfs_inode.c:1585                        <=== never gets done
..
..

with  "CONFIG_XFS_DEBUG=y" I get the following assertion:

Assertion failed: prev.br_state == XFS_EXT_NORM, file:
fs/xfs/xfs_bmap.c, line: 5192
 ...
Call Trace:
[<80234c04>] assfail+0x28/0x2c
[<801cb57c>] xfs_bunmapi+0x1234/0x144c
[<801f6540>] xfs_itruncate_finish+0x3e8/0x7f4
[<8021deb4>] xfs_inactive+0x47c/0x4f0
[<800dcd64>] evict+0x28/0xd0
[<800dd310>] iput+0x19c/0x2d8
[<8020e27c>] xlog_recover_process_one_iunlink+0x150/0x198
[<8020e36c>] xlog_recover_process_iunlinks+0xa8/0x108
[<8020f3f8>] xlog_recover_finish+0x58/0x110
[<80213944>] xfs_mountfs+0x478/0x69c
[<80232ae8>] xfs_fs_fill_super+0x1dc/0x304
[<800c5fe8>] mount_bdev+0x21c/0x258
[<8022ff64>] xfs_fs_mount+0x18/0x24
[<800c4860>] vfs_kern_mount+0x64/0x1b8
[<800c4a08>] do_kern_mount+0x44/0x120
[<800e3f08>] do_mount+0x1b0/0x7cc
[<800e49d0>] sys_mount+0x84/0xf0
[<80011ebc>] stack_done+0x20/0x40

xfs_check, xfs_repair

# xfs_check /dev/sda2
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

sh-3.1# xfs_repair -n /dev/sda2 -r /dev/sda3
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
agi unlinked bucket 33 is 743329 in ag 2 (inode=34297761)
sb_icount 5184, counted 39040
sb_ifree 1315, counted 86
sb_fdblocks 3836812, counted 3644217
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
inode 6776 - bad rt extent start block number 3518437212496384, offset 4216781
bad data fork in inode 6776
would have cleared inode 6776
        - agno = 1
771a3500: Badness in key lookup (length)
bp=(bno 16107312, len 16384 bytes) key=(bno 16107312, len 8192 bytes)
        - agno = 2
bad nblocks 5120 for inode 33701135, would reset to 4096
inode 34297761 - bad rt extent start block number 2392537303836672,
offset 6627188
bad data fork in inode 34297761
would have cleared inode 34297761
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
inode 6776 - bad rt extent start block number 3518437212496384, offset 4216781
bad data fork in inode 6776
would have cleared inode 6776
        - agno = 1
        - agno = 2
entry "0000000000754974720" at block 0 offset 1488 in directory inode
33700909 references free inode 6776
        would clear inode number in entry at offset 1488...
bad nblocks 5120 for inode 33701135, would reset to 4096
inode 34297761 - bad rt extent start block number 2392537303836672,
offset 6627188
bad data fork in inode 34297761
would have cleared inode 34297761
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "0000000000754974720" in directory inode 33700909 points to free
inode 6776, would junk entry
bad hash table for directory inode 33700909 (no data entry): would rebuild
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
#

Currently would like to know how to gracefully get out of this
situation with error returned to mount so that we can repair the disk
also if there is something that can be done to avoid this situation in
the first place.

Thanks
Kamal

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
