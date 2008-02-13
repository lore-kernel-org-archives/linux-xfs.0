Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Feb 2008 02:58:51 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1DAwiGU016267
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 02:58:47 -0800
Received: from rn-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2166F5CEC1F
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 02:59:08 -0800 (PST)
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.189]) by cuda.sgi.com with ESMTP id CJ9bLC7cDArTyKCv for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 02:59:08 -0800 (PST)
Received: by rn-out-0910.google.com with SMTP id a43so2838065rne.5
        for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 02:59:07 -0800 (PST)
Message-ID: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
Date: Wed, 13 Feb 2008 11:51:51 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Over the past month I've been hit with two cases of "xfs_trans_cancel
at line 1150"
The two errors occurred on different raid sets. In both cases the
error happened during
rsync from a remote server to this server, and the local partition
which reported
the error was 99% full (as reported by df -k, see below for details).

System: Dell 2850
Mem: 4GB RAM
OS: Debian 3 (32-bit)
Kernel: 2.6.17.7 (custom compiled)

I've been running this kernel since Aug 2006 without any of these
problems, until a month ago.

I've not used any of the previous kernel in the 2.6.17 series.

/usr/src/linux-2.6.17.7# grep 4K .config
# CONFIG_4KSTACKS is not set


Are there any known XFS problems with this kernel version and nearly
full partitions ?

I'm thinking about upgrading the kernel to a newer version, to see if
it fixes this problem.
Are there any known XFS problems with version 2.6.24.2 ?

Thanks

Christian

--

case logs:

case 1:
Filesystem "sdb1": XFS internal error xfs_trans_cancel at line 1150 of
file fs/xfs/xfs_trans.c.  Caller 0xc0208467
 <c0201cb8> xfs_trans_cancel+0x54/0xe1  <c0208467> xfs_create+0x527/0x563
 <c0208467> xfs_create+0x527/0x563  <c0211d5f> xfs_vn_mknod+0x1a9/0x3bd
 <c01df2ad> xfs_dir2_leafn_lookup_int+0x49/0x452  <c020dbfc>
xfs_buf_free+0x7f/0x84
 <c01d874d> xfs_da_state_free+0x54/0x5a  <c01e0c57>
xfs_dir2_node_lookup+0x95/0xa0
 <c01da14d> xfs_dir2_lookup+0xf5/0x125  <c0163fcc> mntput_no_expire+0x14/0x71
 <c02123f6> xfs_vn_permission+0x1b/0x21  <c0211f86> xfs_vn_create+0x13/0x17
 <c01592ff> vfs_create+0xc2/0xf8  <c01596a1> open_namei+0x16d/0x5b3
 <c014b794> do_filp_open+0x26/0x3c  <c014b8f3> get_unused_fd+0x5a/0xb0
 <c014ba1a> do_sys_open+0x40/0xb6  <c014baa3> sys_open+0x13/0x17
 <c0102697> syscall_call+0x7/0xb
xfs_force_shutdown(sdb1,0x8) called from line 1151 of file
fs/xfs/xfs_trans.c.  Return address = 0xc0214e7d
Filesystem "sdb1": Corruption of in-memory data detected.  Shutting
down filesystem: sdb1
Please umount the filesystem, and rectify the problem(s)

mount options:
/dev/sdb1 on /data type xfs (rw,noatime)

df -k
/dev/sdb1            286380096 283256112   3123984  99% /data

sdb1 is an internal raid. Case 1 occurred last night, and I'm now
about to run repair on that partition.

case2:

Filesystem "sdd1": XFS internal error xfs_trans_cancel at line 1150 of
file fs/xfs/xfs_trans.c.  Caller 0xc0208467
 <c0201cb8> xfs_trans_cancel+0x54/0xe1  <c0208467> xfs_create+0x527/0x563
 <c0208467> xfs_create+0x527/0x563  <c0211d5f> xfs_vn_mknod+0x1a9/0x3bd
 <c03155be> qdisc_restart+0x13/0x152  <c01248bb> in_group_p+0x26/0x2d
 <c01efc86> xfs_iaccess+0xad/0x15b  <c0206f21> xfs_access+0x2b/0x33
 <c01da0fd> xfs_dir2_lookup+0xa5/0x125  <c0163fcc> mntput_no_expire+0x14/0x71
 <c02123f6> xfs_vn_permission+0x1b/0x21  <c0211f86> xfs_vn_create+0x13/0x17
 <c01592ff> vfs_create+0xc2/0xf8  <c01596a1> open_namei+0x16d/0x5b3
 <c014b794> do_filp_open+0x26/0x3c  <c014b8f3> get_unused_fd+0x5a/0xb0
 <c014ba1a> do_sys_open+0x40/0xb6  <c014baa3> sys_open+0x13/0x17
 <c0102697> syscall_call+0x7/0xb
xfs_force_shutdown(sdd1,0x8) called from line 1151 of file
fs/xfs/xfs_trans.c.  Return address = 0xc0214e7d
Filesystem "sdd1": Corruption of in-memory data detected.  Shutting
down filesystem: sdd1
Please umount the filesystem, and rectify the problem(s)

mount options:
/dev/sdd1 on /content/raid03 type xfs (rw,noatime,logbufs=8,nobarrier)

df -k:
/dev/sdd1            1951266816 1925560144  25706672  99% /content/raid03

sdd1 is an external raid. In case 2 I rebooted, then ran xfs_repair
from xfsprogs 2.9.4. And then remounted
the partition, and the partition was ok.

xfs_repair /dev/sdd1
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
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
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
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
