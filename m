Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6B1429w164785 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 20:04:02 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3B0717AC82F
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 18:03:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Nfer2aAZE7bWgFi2 for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 18:03:59 -0700 (PDT)
Date: Mon, 11 Jul 2011 11:03:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [regression, 3.0-rc] xfs: freeze hang in 068
Message-ID: <20110711010357.GD23038@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: hch@lst.de
Cc: xfs@oss.sgi.com

Christoph,

The recent changes to the active transaction accounting to close a
race on freeze can hang the freeze process and hence the filesystem.

SysRq : Show Blocked State
  task                        PC stack   pid father
xfs_io          D ffff88005b7a0f00  5592 32539  32535 0x00020000
 ffff88005bc9dd88 0000000000000082 ffff88005bc9dd28 0000000000000296
 ffff88005bc9c010 ffff88005bff4fe0 0000000000010f80 ffff88005bc9dfd8
 ffff88005bc9dfd8 0000000000010f80 ffff88005cd1dfc0 ffff88005bff4fe0
Call Trace:
 [<ffffffff8150c184>] schedule_timeout+0x97/0xbb
 [<ffffffff81072766>] ? lock_timer_base+0x4d/0x4d
 [<ffffffff8150c1c1>] schedule_timeout_uninterruptible+0x19/0x1b
 [<ffffffff81269786>] xfs_quiesce_attr+0x1d/0x7f
 [<ffffffff81266bb2>] xfs_fs_freeze+0x20/0x2e
 [<ffffffff8110db00>] freeze_super+0x8b/0xca
 [<ffffffff81118abc>] do_vfs_ioctl+0x1d0/0x45c
 [<ffffffff812a97b7>] ? do_raw_spin_unlock+0x8f/0x98
 [<ffffffff81102846>] ? virt_to_head_page+0x9/0x2c
 [<ffffffff81143cb0>] compat_sys_ioctl+0x33c/0x368
 [<ffffffff8110a0f3>] ? do_sys_open+0xee/0x100
 [<ffffffff81514960>] sysenter_dispatch+0x7/0x2e

This is waiting for mp->m_active_trans to reach zero.

fsstress        D 0000000000000000  5376 32541  32540 0x00020000
 ffff88005b68dd48 0000000000000086 ffff88005b68dce8 ffffffff812a97b7
 ffff88005b68c010 ffff88005cf8d7d0 0000000000010f80 ffff88005b68dfd8
 ffff88005b68dfd8 0000000000010f80 ffffffff81a0b020 ffff88005cf8d7d0
Call Trace:
 [<ffffffff812a97b7>] ? do_raw_spin_unlock+0x8f/0x98
 [<ffffffff81080c73>] ? prepare_to_wait+0x71/0x7c
 [<ffffffff81262d5d>] xfs_file_aio_write+0x10a/0x245
 [<ffffffff81080a31>] ? wake_up_bit+0x25/0x25
 [<ffffffff8110b52b>] do_sync_write+0xc6/0x103
 [<ffffffff810eec9e>] ? handle_mm_fault+0xff/0x111
 [<ffffffff8110be64>] vfs_write+0xa9/0x105
 [<ffffffff8110b055>] ? vfs_llseek+0x2e/0x30
 [<ffffffff8110bf79>] sys_write+0x45/0x6c
 [<ffffffff81514960>] sysenter_dispatch+0x7/0x2e

This is waiting for the filesystem to unfreeze.

fsstress        D 0000000000000000  5040 32542  32540 0x00020000
 ffff88005b62fc78 0000000000000082 ffff88005b62fc18 ffffffff812a97b7
 ffff88005b62e010 ffff88005be9c000 0000000000010f80 ffff88005b62ffd8
 ffff88005b62ffd8 0000000000010f80 ffff88005cf8efa0 ffff88005be9c000
Call Trace:
 [<ffffffff812a97b7>] ? do_raw_spin_unlock+0x8f/0x98
 [<ffffffff81080c73>] ? prepare_to_wait+0x71/0x7c
 [<ffffffff81255843>] _xfs_trans_alloc+0x89/0xee
 [<ffffffff81080a31>] ? wake_up_bit+0x25/0x25
 [<ffffffff8125875b>] xfs_trans_alloc+0x13/0x15
 [<ffffffff8125abcb>] xfs_change_file_space+0x1f9/0x2f0
 [<ffffffff81122dda>] ? mntput+0x21/0x23
 [<ffffffff81113e7c>] ? path_put+0x1d/0x21
 [<ffffffff81263301>] xfs_ioc_space+0xc2/0xd3
 [<ffffffff81208f92>] xfs_file_compat_ioctl+0x2e1/0x49b
 [<ffffffff81122cc8>] ? mntput_no_expire+0x50/0x141
 [<ffffffff81122dda>] ? mntput+0x21/0x23
 [<ffffffff8110efd8>] ? vfs_fstat+0x3b/0x45
 [<ffffffff81143b15>] compat_sys_ioctl+0x1a1/0x368
 [<ffffffff81514960>] sysenter_dispatch+0x7/0x2e

This has an active transaction reference (i.e. keeping
mp->m_active_trans > 0) and is waiting for the freeze to complete.

Basically the problem is this:

thread 1				freeze
					SB_FREEZE_WRITE
					sync_filesystem()
					SB_FREEZE_TRANS
					->freeze
xfs_trans_alloc
  atomic_inc(mp->m_active_trans)
  wait on (SB_FREEZE_TRANS)
					xfs_quiese_attr()
					  while (mp->m_active_trans > 0)
						delay(1);

So effective we cannot sleep waiting for SB_FREEZE_TRANS to go away
while holding an active transaction reference because the freeze
process does not set and check SB_FREEZE_TRANS/mp->m_active_trans
atomically.

I haven't put any thought into how to solve this problem yet, so I'd
suggest that at this late stage we need to revert 315fdfa (xfs: fix
filesystsem freeze race in xfs_trans_alloc) because the race it
fixes is far less critical (i.e. doesn't hang the filesystem) and
harder to hit than the regression introduced here.

I've reproduced this a coupe lof times now on a 1p/1.5GB x86_64
kernel/i686 userspace VM.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
