Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Aug 2007 14:12:30 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.181])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l79LCQbm021601
	for <linux-xfs@oss.sgi.com>; Thu, 9 Aug 2007 14:12:27 -0700
Received: by wa-out-1112.google.com with SMTP id k22so726550waf
        for <linux-xfs@oss.sgi.com>; Thu, 09 Aug 2007 14:12:30 -0700 (PDT)
Message-ID: <5d96567b0708091412y2ea0df38x9a73da6dcac3e962@mail.gmail.com>
Date: Fri, 10 Aug 2007 00:12:30 +0300
From: Raz <raziebe@gmail.com>
Subject: corruption of xfs over sw raid5
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

We are getting xfs corruption ( see bellow ) when deleting from a file system.
deletion is done while the file system is filling other files and
deleting other files.
the bellow is the block device configuration and xfs_info conf.
Question: I am using 2.6.17.7 , should I upgrade to 2.6.2x.x  ?

# cat /proc/mdstat
Personalities : [raid5] [raid4] [raid1] [raid0]
md1 : active raid5 sda3[0] sdd3[3] sdc3[2] sdb3[1]
      1462380288 blocks level 5, 256k chunk, algorithm 2 [4/4] [UUUU]

md0 : active raid5 sda2[0] sdd2[3] sdc2[2] sdb2[1]
      1589760 blocks level 5, 256k chunk, algorithm 2 [4/4] [UUUU]

# xfs_info /d1
meta-data=/dev/md1               isize=256    agcount=349,
agsize=1048572 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=365595072,
imaxpct=25
         =                       sunit=4      swidth=32 blks,
unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=786432 blocks=0, rtextents=0


[4305465.579000] XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1590
of file fs/xfs/xfs_alloc.c.  Caller 0xc10c3eba [4305465.601000]
<c10c2ab8> xfs_free_ag_extent+0x372/0x73d  <c10c3eba>
xfs_free_extent+0x10d/0x111 [4305465.618000]  <c10c3eba>
xfs_free_extent+0x10d/0x111  <c1126634> kmem_zone_alloc+0x57/0xc5
[4305465.636000]  <c111a133> xfs_trans_get_efd+0x38/0x46  <c10d6f03>
xfs_bmap_finish+0x146/0x1e5 [4305465.653000]  <c11005a3>
xfs_itruncate_finish+0x22a/0x453  <c1120c31> xfs_inactive+0x559/0x5c0
[4305465.671000]  <c1130da3> xfs_fs_clear_inode+0x8a/0x98  <c1075087>
clear_inode+0xa8/0xeb [4305465.687000]  <c1075ff8>
generic_delete_inode+0x106/0x115  <c1076206> iput+0x62/0x7c
[4305465.703000]  <c106bc3c> do_unlinkat+0xf7/0x121  <c12125bc>
sys_socketcall+0x163/0x280 [4305465.720000]  <c106bcaf>
sys_unlink+0x17/0x1b  <c100300f> syscall_call+0x7/0xb [4305465.735000]
xfs_force_shutdown(md1,0x8) called from line 4091 of file
fs/xfs/xfs_bmap.c.  Return address = 0xc1131b5c [4305465.763000]
Filesystem "md1": Corruption of in-memory data detected.  Shutting down
filesystem: md1 [4305465.782000] Please umount the filesystem, and
rectify the problem(s) [4305529.751000] xfs_force_shutdown(md1,0x1)
called from line 338 of file fs/xfs/xfs_rw.c.  Return address =
0xc1131b5c [4305535.773000] xfs_force_shutdown(md1,0x1) called from line
338 of file fs/xfs/xfs_rw.c.  Return address = 0xc1131b5c

-- 
Raz
