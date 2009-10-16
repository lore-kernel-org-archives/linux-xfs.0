Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9G37vxG057387 for <xfs@oss.sgi.com>; Thu, 15 Oct 2009 22:07:57 -0500
Received: from mail-px0-f195.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3036CDD96
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2009 20:09:27 -0700 (PDT)
Received: from mail-px0-f195.google.com (mail-px0-f195.google.com
	[209.85.216.195]) by cuda.sgi.com with ESMTP id
	wCubVuItwRJjQZ3n for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2009 20:09:27 -0700 (PDT)
Received: by pxi33 with SMTP id 33so1301642pxi.20
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2009 20:09:27 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 16 Oct 2009 11:09:27 +0800
Message-ID: <389deec70910152009i7656aaf2s9d929b8b68e4e740@mail.gmail.com>
Subject: XFS mount failuer on RAID5
From: hank peng <pengxihan@gmail.com>
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
Cc: linux-raid <linux-raid@vger.kernel.org>

Hi, all:
I have a self-built board, cpu is MPC8548(PPC arch), kernel is based
on MPC8548CDS demo board, version is 2.6.23.
A SATA controller is conected to CPU via PCIX, and I have 3 disks
attached to it.

root@Storage:~# mdadm -C /dev/md0 -l5 -n3 /dev/sd{b,c,d}
root@Storage:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md0 : active raid5 sdd[3] sdc[1] sdb[0]
      490234624 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
      [>....................]  recovery =  0.8% (1990404/245117312)
finish=83.3min speed=48603K/sec

unused devices: <none>
root@Storage:~# pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created
root@Storage:~# vgcreate vg /dev/md0
  Volume group "vg" successfully created
root@Storage:~# lvcreate -L 100G -n lvtest vg
  Logical volume "lvtest" created
root@Storage:~# mkfs.xfs -f -ssize=4k /dev/vg/lvtest
Warning - device mapper device, but no dmsetup(8) found
Warning - device mapper device, but no dmsetup(8) found
meta-data=/dev/vg/lvtest         isize=256    agcount=4, agsize=6553600 blks
         =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
root@Storage:~# mkdir tmp
root@Storage:~# mount -t xfs /dev/vg/lvtest ./tmp/
Filesystem "dm-0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-0
XFS: totally zeroed log
Filesystem "dm-0": XFS internal error xlog_clear_stale_blocks(2) at
line 1252 of file fs/xfs/xfs_log_recover.c.  Caller 0xc018ec88
Call Trace:
[e8ab9a60] [c00091ec] show_stack+0x3c/0x1a0 (unreliable)
[e8ab9a90] [c017559c] xfs_error_report+0x50/0x60
[e8ab9aa0] [c018e84c] xlog_clear_stale_blocks+0xe4/0x1c8
[e8ab9ad0] [c018ec88] xlog_find_tail+0x358/0x494
[e8ab9b20] [c0190ba0] xlog_recover+0x20/0xf4
[e8ab9b40] [c018993c] xfs_log_mount+0x104/0x148
[e8ab9b60] [c01930f0] xfs_mountfs+0x8d4/0xd14
[e8ab9c00] [c0183f88] xfs_ioinit+0x38/0x4c
[e8ab9c20] [c019bf24] xfs_mount+0x458/0x470
[e8ab9c60] [c01b087c] vfs_mount+0x38/0x48
[e8ab9c70] [c01b052c] xfs_fs_fill_super+0x98/0x1f8
[e8ab9cf0] [c0076cec] get_sb_bdev+0x164/0x1a8
[e8ab9d40] [c01af3bc] xfs_fs_get_sb+0x1c/0x2c
[e8ab9d50] [c00769f8] vfs_kern_mount+0x58/0xe0
[e8ab9d70] [c0076ad0] do_kern_mount+0x40/0xf8
[e8ab9d90] [c008ee0c] do_mount+0x158/0x600
[e8ab9f10] [c008f344] sys_mount+0x90/0xe8
[e8ab9f40] [c0002320] ret_from_syscall+0x0/0x3c
XFS: failed to locate log tail
XFS: log mount/recovery failed: error 117
XFS: log mount failed
mount: mounting /dev/vg/lvtest on ./tmp/ failed: Structure needs cleaning


Interestingly, if remove "-ssize=4k" option in mkfs.xfs command, it is OK
root@Storage:~# mkfs.xfs -f  /dev/vg/lvtest
Warning - device mapper device, but no dmsetup(8) found
Warning - device mapper device, but no dmsetup(8) found
meta-data=/dev/vg/lvtest         isize=256    agcount=4, agsize=6553600 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
root@Storage:~# mount -t xfs /dev/vg/lvtest ./tmp/
Filesystem "dm-0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-0

I don't know when "-ssize=4k" option is added, what is difference?


-- 
The simplest is not all best but the best is surely the simplest!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
