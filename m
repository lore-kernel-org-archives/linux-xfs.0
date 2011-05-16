Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4G3KP88112552 for <xfs@oss.sgi.com>; Sun, 15 May 2011 22:20:26 -0500
Received: from mprobst.securesites.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F2A7457489
	for <xfs@oss.sgi.com>; Sun, 15 May 2011 20:20:23 -0700 (PDT)
Received: from mprobst.securesites.net (mprobst2.securesites.net
	[198.173.85.114]) by cuda.sgi.com with ESMTP id
	1PkHREMxhtVqhJWo for <xfs@oss.sgi.com>;
	Sun, 15 May 2011 20:20:23 -0700 (PDT)
Received: from [192.168.102.101] (photos.bigmama.probst.org [71.195.218.88])
	(authenticated bits=0)
	by mprobst.securesites.net (8.14.4/8.14.4) with ESMTP id p4G3KJvF050323
	for <xfs@oss.sgi.com>; Sun, 15 May 2011 21:20:22 -0600 (MDT)
	(envelope-from mprobst@zmcconsulting.com)
Message-ID: <4DD097F9.6070205@zmcconsulting.com>
Date: Sun, 15 May 2011 21:20:25 -0600
From: "Matthew J. Probst" <mprobst@zmcconsulting.com>
MIME-Version: 1.0
Subject: XFS_WANT_CORRUPTED_GOTO on repair of large myisam (mysql) table
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
To: xfs@oss.sgi.com

Hi,
I've run into the infamous XFS_WANT_CORRUPTED_GOTO error.... twice in
the same day.... with an xfs_repair in-between.
Both time I hit this error, I was doing a myisamchk  to repair a large
corrupted mysql table (with a 20GB data file and a 17GB index file).
I've run this database for years on this file system without a
problem..... then in one day, both times when I attempted to repair this
table.
xfs crashed on me. 

I believe this is the largest table I've attempted to repair on this
file system.

After the first crash, the file system refused to mount....  The repair
was refused as well, saying that there were entries in the metadata log
that needed replaying...  Given the problem mounting the file system, I
ended up clearing the metadata log (xfs_repair -L).
The system came back online....  but when I attempted to repair the same
table, the same XFS_WANT_CORRUPTED_GOTO error occured.  This time, I was
able to simply remount the fs w/o clearing the log and w/o an explicit
repair... Since then I've avoided repairing this table.. and instead I
restored a backup from a replication slave.   The system has been stable
in the two days since the crash (though I've avoided all myisamchk
attempts).

Any guidance would greatly be appreciated....  Given how mission
critical this db is, I need to either find a root cause for the error or
consider migration to an alternate filesystem.

Below is information on:
The storage hardware.
The software used
The kernel error seen (from dmesg).
The output of the xfs_repair -L command (the one time I was forced to
run it).
Output of xfs_info.



##############################################################
Storage hardware:
##############################################################
Multipath 3Gbps sas connection to a redundant external sas array (dual
HA controllers), Raid-10 on 10x 15Krpm sas drives.
8GB of ram.  I've run a memtest over it after the failure for 12+ hours
and did not find any problems.


##########################
Software:
##########################
xfs on lvm2 on dm-multipath

Kernel: 2.6.18-238.9.1.el5 (from RH/Centos 5.6)
kmod-xfs version 0.4-2
xfsprogs version 2.9.4-1
lvm2 version: 2.02.74-5
device mapper multipath verson: 0.4.7-42
Mysql version 5.1 56


##############################################################
Text of kernel error:
##############################################################
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1572 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff88730969

Call Trace:
 [<ffffffff8872ee2f>] :xfs:xfs_free_ag_extent+0x19e/0x67e
 [<ffffffff88730969>] :xfs:xfs_free_extent+0xa9/0xc9
 [<ffffffff8876abc8>] :xfs:xfs_trans_log_efd_extent+0x1c/0x48
 [<ffffffff8876128b>] :xfs:xlog_recover_process_efi+0x112/0x16c
 [<ffffffff8877adf4>] :xfs:xfs_fs_fill_super+0x0/0x3dc
 [<ffffffff8876247e>] :xfs:xlog_recover_process_efis+0x4f/0x8d
 [<ffffffff887624d0>] :xfs:xlog_recover_finish+0x14/0xad
 [<ffffffff8877adf4>] :xfs:xfs_fs_fill_super+0x0/0x3dc
 [<ffffffff88766fd4>] :xfs:xfs_mountfs+0x498/0x5e2
 [<ffffffff887676f6>] :xfs:xfs_mru_cache_create+0x113/0x143
 [<ffffffff8877aff7>] :xfs:xfs_fs_fill_super+0x203/0x3dc
 [<ffffffff800e6bb9>] get_sb_bdev+0x10a/0x16c
 [<ffffffff8012fe73>] selinux_sb_copy_data+0x1a1/0x1c5
 [<ffffffff800e6556>] vfs_kern_mount+0x93/0x11a
 [<ffffffff800e661f>] do_kern_mount+0x36/0x4d
 [<ffffffff800f0ec8>] do_mount+0x6a9/0x719
 [<ffffffff8000c7d8>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8002cbec>] mntput_no_expire+0x19/0x89
 [<ffffffff80007691>] find_get_page+0x21/0x51
 [<ffffffff8001398c>] filemap_nopage+0x193/0x360
 [<ffffffff80008d5c>] __handle_mm_fault+0x5f3/0x1039
 [<ffffffff800ce6b2>] zone_statistics+0x3e/0x6d
 [<ffffffff8000f41e>] __alloc_pages+0x78/0x308
 [<ffffffff8004c742>] sys_mount+0x8a/0xcd
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0

Filesystem "dm-1": XFS internal error xfs_trans_cancel at line 1164 of
file fs/xfs/xfs_trans.c.  Caller 0xffffffff887612d7


Call Trace:
 [<ffffffff887696eb>] :xfs:xfs_trans_cancel+0x55/0xfa
 [<ffffffff887612d7>] :xfs:xlog_recover_process_efi+0x15e/0x16c
 [<ffffffff8877adf4>] :xfs:xfs_fs_fill_super+0x0/0x3dc
 [<ffffffff8876247e>] :xfs:xlog_recover_process_efis+0x4f/0x8d
 [<ffffffff887624d0>] :xfs:xlog_recover_finish+0x14/0xad
 [<ffffffff8877adf4>] :xfs:xfs_fs_fill_super+0x0/0x3dc
 [<ffffffff88766fd4>] :xfs:xfs_mountfs+0x498/0x5e2
 [<ffffffff887676f6>] :xfs:xfs_mru_cache_create+0x113/0x143
 [<ffffffff8877aff7>] :xfs:xfs_fs_fill_super+0x203/0x3dc
 [<ffffffff800e6bb9>] get_sb_bdev+0x10a/0x16c
 [<ffffffff8012fe73>] selinux_sb_copy_data+0x1a1/0x1c5
 [<ffffffff800e6556>] vfs_kern_mount+0x93/0x11a
 [<ffffffff800e661f>] do_kern_mount+0x36/0x4d
 [<ffffffff800f0ec8>] do_mount+0x6a9/0x719
 [<ffffffff8000c7d8>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8002cbec>] mntput_no_expire+0x19/0x89
 [<ffffffff80007691>] find_get_page+0x21/0x51
 [<ffffffff8001398c>] filemap_nopage+0x193/0x360
 [<ffffffff80008d5c>] __handle_mm_fault+0x5f3/0x1039
 [<ffffffff800ce6b2>] zone_statistics+0x3e/0x6d
 [<ffffffff8000f41e>] __alloc_pages+0x78/0x308
 [<ffffffff8004c742>] sys_mount+0x8a/0xcd
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0

xfs_force_shutdown(dm-1,0x8) called from line 1165 of file
fs/xfs/xfs_trans.c.  Return address = 0xffffffff88769704
Filesystem "dm-1": Corruption of in-memory data detected.  Shutting down
filesystem: dm-1
Please umount the filesystem, and rectify the problem(s)


###########################################################################
output from: "xfs_repair -L -v /dev/primary_vg/master"
############################################################################
Phase 1 - find and verify superblock...
        - block cache size set to 763768 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 28095 tail block 26697
ALERT: The filesystem has valuable metadata changes in a log which is being
destroyed because the -L option was used.
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
44334940: Badness in key lookup (length)
bp=(bno 167738016, len 16384 bytes) key=(bno 167738016, len 8192 bytes)
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
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
        - agno = 9
        - agno = 6
        - agno = 7
        - agno = 10
        - agno = 8
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 20
        - agno = 19
        - agno = 22
        - agno = 21
Phase 5 - rebuild AG headers and trees...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 335476063, moving to lost+found
Phase 7 - verify and correct link counts...

        XFS_REPAIR Summary    Sat May 14 07:38:17 2011

Phase           Start           End             Duration
Phase 1:        05/14 07:38:06  05/14 07:38:06 
Phase 2:        05/14 07:38:06  05/14 07:38:07  1 second
Phase 3:        05/14 07:38:07  05/14 07:38:17  10 seconds
Phase 4:        05/14 07:38:17  05/14 07:38:17 
Phase 5:        05/14 07:38:17  05/14 07:38:17 
Phase 6:        05/14 07:38:17  05/14 07:38:17 
Phase 7:        05/14 07:38:17  05/14 07:38:17 

Total run time: 11 seconds
done
##############################################################################
xfs_info /dev/primary_vg/master
##############################################################################
# xfs_info  /dev/primary_vg/master
meta-data=/dev/primary_vg/master isize=256    agcount=23, agsize=2097152
blks
         =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=46661632, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096 
log      =internal               bsize=4096   blocks=16384, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
