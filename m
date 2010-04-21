Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3LBADSv107391 for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 06:10:14 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B1162E11F7
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 04:12:11 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id qAxXkZqxHRkJqaAQ for
	<xfs@oss.sgi.com>; Wed, 21 Apr 2010 04:12:11 -0700 (PDT)
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by smtp4-g21.free.fr (Postfix) with ESMTP id BC2094C810E
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 13:12:05 +0200 (CEST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id B321D4C8152
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 13:12:02 +0200 (CEST)
Date: Wed, 21 Apr 2010 13:12:07 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: xfs crash forensics
Message-ID: <20100421131207.3c845ba9@harpe.intellique.com>
Mime-Version: 1.0
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


Hello everyone,
I'm trying to understand what happened here (xfs utils 2.8.11, 64 bits). 


First we had a crash while defragmenting (fragmention is explosive on
this system, and harms performance badly):


Apr 18 14:15:47 storiq-c1-n3 -- MARK --
Apr 18 14:35:48 storiq-c1-n3 -- MARK --
Apr 18 14:40:30 storiq-c1-n3 kernel: Pid: 3079, comm: xfs_fsr Not tainted 2.6.24.7-storiq64-opteron #1
Apr 18 14:40:30 storiq-c1-n3 kernel: 
Apr 18 14:40:30 storiq-c1-n3 kernel: Call Trace:
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8036824d>] xfs_iread_extents+0x7d/0x100
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff80343f91>] xfs_bmap_read_extents+0xe1/0x380
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8029cedf>] do_lookup+0x8f/0x210
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8036824d>] xfs_iread_extents+0x7d/0x100
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8034a4dd>] xfs_bmapi+0x16d/0x1290
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff802a7c07>] __d_lookup+0x97/0x120
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff802a718f>] dput+0x1f/0x130
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8029cc89>] __follow_mount+0x29/0xa0
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8029cedf>] do_lookup+0x8f/0x210
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff80502522>] __down_write_nested+0x12/0xb0
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8034b885>] xfs_getbmap+0x285/0x690
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8029f720>] link_path_walk+0x80/0xf0
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8026e503>] __pagevec_free+0x23/0x30
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff80272931>] release_pages+0x171/0x1b0
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8038ea14>] xfs_ioc_getbmap+0x94/0xc0
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8038f93b>] xfs_ioctl+0xbb/0x750
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff802842cd>] free_pages_and_swap_cache+0x8d/0xb0
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8038dd8b>] xfs_file_ioctl_invis+0x2b/0x70
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff802a1f2f>] do_ioctl+0x2f/0xa0
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff802a2014>] vfs_ioctl+0x74/0x2d0
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff803b9b61>] __up_write+0x21/0x130
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff802a22b9>] sys_ioctl+0x49/0x80
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8027e5c5>] sys_munmap+0x55/0x80
Apr 18 14:40:30 storiq-c1-n3 kernel:  [<ffffffff8020bc1e>] system_call+0x7e/0x83
Apr 18 14:40:30 storiq-c1-n3 kernel: 
Apr 18 14:40:30 storiq-c1-n3 fsr[3079]: failed reading extents: inode 33778765
Apr 18 14:55:48 storiq-c1-n3 -- MARK --
Apr 18 15:15:48 storiq-c1-n3 -- MARK --

OK, so the inode 33778765 is apparently lost, too bad. What file may it be?
Any way to know afterwards?
Today it got worse :

Apr 21 10:41:55 storiq-c1-n3 kernel: Pid: 7167, comm: smbd Not tainted 2.6.24.7-storiq64-opteron #1
Apr 21 10:41:56 storiq-c1-n3 kernel: 
Apr 21 10:41:56 storiq-c1-n3 kernel: Call Trace:
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff8036824d>] xfs_iread_extents+0x7d/0x100
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff80343f91>] xfs_bmap_read_extents+0xe1/0x380
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff8036824d>] xfs_iread_extents+0x7d/0x100
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff803492eb>] xfs_bunmapi+0x93b/0xc20
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff8037d79c>] _xfs_trans_commit+0x32c/0x3b0
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff80367f0b>] xfs_itruncate_finish+0x1cb/0x320
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff80388214>] xfs_inactive+0x364/0x490
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff80392534>] xfs_fs_clear_inode+0xa4/0xf0
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff802a9f69>] clear_inode+0x99/0x150
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff802aa141>] generic_delete_inode+0x121/0x130
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff802a007a>] do_unlinkat+0x14a/0x1c0
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff80226652>] ia32_sysret+0x0/0xa
Apr 21 10:41:56 storiq-c1-n3 kernel: 
Apr 21 10:41:56 storiq-c1-n3 kernel: Pid: 7167, comm: smbd Not tainted 2.6.24.7-storiq64-opteron #1
Apr 21 10:41:56 storiq-c1-n3 kernel: 
Apr 21 10:41:56 storiq-c1-n3 kernel: Call Trace:
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff8038822b>] xfs_inactive+0x37b/0x490
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff8037d0f6>] xfs_trans_cancel+0x126/0x150
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff8038822b>] xfs_inactive+0x37b/0x490
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff80392534>] xfs_fs_clear_inode+0xa4/0xf0
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff802a9f69>] clear_inode+0x99/0x150
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff802aa141>] generic_delete_inode+0x121/0x130
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff802a007a>] do_unlinkat+0x14a/0x1c0
Apr 21 10:41:56 storiq-c1-n3 kernel:  [<ffffffff80226652>] ia32_sysret+0x0/0xa
Apr 21 10:41:56 storiq-c1-n3 kernel: 
Apr 21 10:41:56 storiq-c1-n3 kernel: xfs_force_shutdown(dm-0,0x8) called from line 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8037d10f
Apr 21 10:57:20 storiq-c1-n3 -- MARK --

The filesystem went offline. At reboot I have this (dmesg output) :

3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
ACPI: PCI Interrupt Link [LNEC] enabled at IRQ 19
ACPI: PCI Interrupt 0000:06:00.0[A] -> Link [LNEC] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:06:00.0 to 64
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54500741.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54500C1F.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450104C.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x545010D8.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450110D.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54501A23.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54501B91.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54501F10.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x545023FC.
3w-9xxx: scsi6: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=11.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502400.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450256E.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x545028EB.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502F77.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450259E.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502DE0.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502A3B.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502A89.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54503430.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450388C.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450394E.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54503D78.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54503EE6.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x545075ED.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54507AD8.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54507FC7.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54508001.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450DB37.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450DE7E.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450DE86.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450FCE8.
3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5451082F.
3w-9xxx: scsi6: ERROR: (0x06:0x0022): AEN drain failed during reset sequence.
3w-9xxx: scsi6: AEN: INFO (0x04:0x0001): Controller reset occurred:resets=1.

Does that smell of on-disk corruption? Hmmm. Then the remount failed
again :

Apr 21 11:01:34 storiq-c1-n3 kernel: XFS mounting filesystem dm-0
Apr 21 11:01:34 storiq-c1-n3 kernel: Starting XFS recovery on filesystem: dm-0 (logdev: internal)
Apr 21 11:01:34 storiq-c1-n3 kernel: Pid: 2890, comm: mount Not tainted 2.6.24.7-storiq64-opteron #1
Apr 21 11:01:34 storiq-c1-n3 kernel: 
Apr 21 11:01:34 storiq-c1-n3 kernel: Call Trace:
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8036824d>] xfs_iread_extents+0x7d/0x100
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80343f91>] xfs_bmap_read_extents+0xe1/0x380
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8036824d>] xfs_iread_extents+0x7d/0x100
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff803492eb>] xfs_bunmapi+0x93b/0xc20
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8028e217>] kmem_getpages+0xe7/0x170
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8028eb54>] cache_alloc_refill+0xd4/0x220
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80367f0b>] xfs_itruncate_finish+0x1cb/0x320
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80388214>] xfs_inactive+0x364/0x490
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8038ce19>] xfs_buf_offset+0x39/0x50
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80392534>] xfs_fs_clear_inode+0xa4/0xf0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802a9f69>] clear_inode+0x99/0x150
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802aa141>] generic_delete_inode+0x121/0x130
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff803742d2>] xlog_recover_process_iunlinks+0x302/0x330
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80374768>] xlog_recover_finish+0xa8/0xb0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8037a28f>] xfs_mountfs+0x8ff/0xa70
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8035eca0>] xfs_fstrm_free_func+0x0/0x90
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80382088>] xfs_mount+0x388/0x3c0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff803931b8>] xfs_fs_fill_super+0xc8/0x250
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80502522>] __down_write_nested+0x12/0xb0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff803ba20e>] strlcpy+0x4e/0x80
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296330>] test_bdev_super+0x0/0x10
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296988>] sget+0x378/0x380
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296320>] set_bdev_super+0x0/0x10
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802974de>] get_sb_bdev+0x14e/0x180
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff803930f0>] xfs_fs_fill_super+0x0/0x250
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296df6>] vfs_kern_mount+0x56/0xc0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296ec3>] do_kern_mount+0x53/0x110
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802adc3a>] do_mount+0x55a/0x770
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026904d>] find_lock_page+0x3d/0xc0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026b388>] filemap_fault+0x1d8/0x3e0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026d835>] __rmqueue_smallest+0xc5/0x140
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026d8df>] __rmqueue+0x2f/0x230
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026db35>] rmqueue_bulk+0x55/0xb0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80276dfd>] zone_statistics+0x7d/0x80
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026f6ab>] __get_free_pages+0x1b/0x40
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802c7f1f>] compat_sys_mount+0xbf/0x2a0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80226652>] ia32_sysret+0x0/0xa
Apr 21 11:01:34 storiq-c1-n3 kernel: 
Apr 21 11:01:34 storiq-c1-n3 kernel: Pid: 2890, comm: mount Not tainted 2.6.24.7-storiq64-opteron #1
Apr 21 11:01:34 storiq-c1-n3 kernel: 
Apr 21 11:01:34 storiq-c1-n3 kernel: Call Trace:
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8038822b>] xfs_inactive+0x37b/0x490
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8037d0f6>] xfs_trans_cancel+0x126/0x150
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8038822b>] xfs_inactive+0x37b/0x490
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8038ce19>] xfs_buf_offset+0x39/0x50
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80392534>] xfs_fs_clear_inode+0xa4/0xf0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802a9f69>] clear_inode+0x99/0x150
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802aa141>] generic_delete_inode+0x121/0x130
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff803742d2>] xlog_recover_process_iunlinks+0x302/0x330
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80374768>] xlog_recover_finish+0xa8/0xb0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8037a28f>] xfs_mountfs+0x8ff/0xa70
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8035eca0>] xfs_fstrm_free_func+0x0/0x90
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80382088>] xfs_mount+0x388/0x3c0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff803931b8>] xfs_fs_fill_super+0xc8/0x250
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80502522>] __down_write_nested+0x12/0xb0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff803ba20e>] strlcpy+0x4e/0x80
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296330>] test_bdev_super+0x0/0x10
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296988>] sget+0x378/0x380
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296320>] set_bdev_super+0x0/0x10
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802974de>] get_sb_bdev+0x14e/0x180
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff803930f0>] xfs_fs_fill_super+0x0/0x250
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296df6>] vfs_kern_mount+0x56/0xc0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80296ec3>] do_kern_mount+0x53/0x110
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802adc3a>] do_mount+0x55a/0x770
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026904d>] find_lock_page+0x3d/0xc0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026b388>] filemap_fault+0x1d8/0x3e0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026d835>] __rmqueue_smallest+0xc5/0x140
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026d8df>] __rmqueue+0x2f/0x230
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026db35>] rmqueue_bulk+0x55/0xb0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80276dfd>] zone_statistics+0x7d/0x80
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff8026f6ab>] __get_free_pages+0x1b/0x40
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff802c7f1f>] compat_sys_mount+0xbf/0x2a0
Apr 21 11:01:34 storiq-c1-n3 kernel:  [<ffffffff80226652>] ia32_sysret+0x0/0xa
Apr 21 11:01:34 storiq-c1-n3 kernel: 
Apr 21 11:01:34 storiq-c1-n3 kernel: xfs_force_shutdown(dm-0,0x8) called from line 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8037d10f
Apr 21 11:01:34 storiq-c1-n3 kernel: Ending XFS recovery on filesystem: dm-0 (logdev: internal)

I proceeded to repair using the dreaded "-L" option :

# xfs_repair -L /dev/vg0/lv0 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is being
destroyed because the -L option was used.
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad magic # 0x25070565 in inode 33778765 (data fork) bmbt block 336578544
bad data fork in inode 33778765
cleared inode 33778765
        - agno = 1
<snip>

Apparently all went well. I've started a RAID scrub... Do you have any
suggestions to some more tests to do ?

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
