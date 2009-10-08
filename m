Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9873fbV247360
	for <linux-xfs@oss.sgi.com>; Thu, 8 Oct 2009 02:03:44 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6797A4ADF03
	for <linux-xfs@oss.sgi.com>; Thu,  8 Oct 2009 00:05:07 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id dyCQjCZDndUO0dsG for <linux-xfs@oss.sgi.com>;
	Thu, 08 Oct 2009 00:05:07 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.50) id 1Mvn3i-0000PZ-17
	for linux-xfs@oss.sgi.com; Thu, 08 Oct 2009 09:05:06 +0200
Received: from c-76-22-14-176.hsd1.wa.comcast.net ([76.22.14.176])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 08 Oct 2009 09:05:06 +0200
Received: from tneumann by c-76-22-14-176.hsd1.wa.comcast.net with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 08 Oct 2009 09:05:06 +0200
From: Thomas Neumann <tneumann@users.sourceforge.net>
Subject: deadlocks with fallocate
Date: Thu, 08 Oct 2009 08:59:45 +0200
Message-ID: <hak2l2$ko2$1@ger.gmane.org>
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
To: linux-xfs@oss.sgi.com

Hi,

I currently observe frequent deadlocks in XFS on an I/O intensive workload 
that uses posix_fallocate. This is very annoying, as I have to power down 
the machine (in an unclean state) afterwards.
I observed this with multiple kernel versions including 2.6.32rc1, the 
symptoms are shown in the dmesg extract below.

I am willing to help to debug the problem, although it is probably a race 
condition, as it does not occur all of the time. Is there anything I should 
do to pinpoint the problem?
It always seems to occur when the user space calls fallocate (100% of my log 
entries contained this function call), but otherwise I am not sure what 
triggers it.

Thomas



INFO: task xfsconvertd/0:411 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsconvertd/0 D 0000000000000000     0   411      2 0x00000000
 ffff88007b21d3e0 0000000000000046 ffff88007d4e8c40 ffff88007b21dfd8
 ffff88007adfdb40 0000000000015980 0000000000015980 ffff88007b21dfd8
 0000000000015980 ffff88007b21dfd8 0000000000015980 ffff88007adfdf00
Call Trace:
 [<ffffffff81526162>] io_schedule+0x42/0x60
 [<ffffffff810df6d5>] sync_page+0x35/0x50
 [<ffffffff815268e5>] __wait_on_bit+0x55/0x80
 [<ffffffff810df6a0>] ? sync_page+0x0/0x50
 [<ffffffff810df7f0>] wait_on_page_bit+0x70/0x80
 [<ffffffff8107afb0>] ? wake_bit_function+0x0/0x30
 [<ffffffff810ecce8>] shrink_page_list+0x3d8/0x550
 [<ffffffff8107b0de>] ? finish_wait+0x5e/0x80
 [<ffffffff810f85da>] ? congestion_wait+0x7a/0x90
 [<ffffffff8107af70>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff810ed7e6>] shrink_inactive_list+0x6b6/0x700
 [<ffffffff81044250>] ? wake_affine+0x220/0x240
 [<ffffffff81048210>] ? __enqueue_entity+0x80/0x90
 [<ffffffff810ed881>] shrink_list+0x51/0xb0
 [<ffffffff810eddea>] shrink_zone+0x1ea/0x200
 [<ffffffff810ee823>] shrink_zones+0x63/0xf0
 [<ffffffff810ee920>] do_try_to_free_pages+0x70/0x280
 [<ffffffff810eec9c>] try_to_free_pages+0x9c/0xc0
 [<ffffffff810ed0e0>] ? isolate_pages_global+0x0/0x50
 [<ffffffff810e6342>] __alloc_pages_slowpath+0x232/0x520
 [<ffffffff810e6776>] __alloc_pages_nodemask+0x146/0x180
 [<ffffffff811143f7>] alloc_pages_current+0x87/0xd0
 [<ffffffff8111939c>] allocate_slab+0x11c/0x1b0
 [<ffffffff8111945b>] new_slab+0x2b/0x190
 [<ffffffff8111b641>] __slab_alloc+0x121/0x230
 [<ffffffffa009b57d>] ? kmem_zone_alloc+0x5d/0xd0 [xfs]
 [<ffffffffa009b57d>] ? kmem_zone_alloc+0x5d/0xd0 [xfs]
 [<ffffffff8111b980>] kmem_cache_alloc+0xf0/0x130
 [<ffffffffa009b57d>] kmem_zone_alloc+0x5d/0xd0 [xfs]
 [<ffffffffa009b609>] kmem_zone_zalloc+0x19/0x50 [xfs]
 [<ffffffffa009368f>] _xfs_trans_alloc+0x2f/0x70 [xfs]
 [<ffffffffa0093832>] xfs_trans_alloc+0x92/0xa0 [xfs]
 [<ffffffff810f7710>] ? __dec_zone_page_state+0x30/0x40
 [<ffffffffa0083691>] xfs_iomap_write_unwritten+0x71/0x200 [xfs]
 [<ffffffff810e1ad2>] ? mempool_free_slab+0x12/0x20
 [<ffffffff810e1b6a>] ? mempool_free+0x8a/0xa0
 [<ffffffffa009c3d0>] ? xfs_end_bio_unwritten+0x0/0x80 [xfs]
 [<ffffffffa009c435>] xfs_end_bio_unwritten+0x65/0x80 [xfs]
 [<ffffffff81075c47>] run_workqueue+0xb7/0x190
 [<ffffffff81076fa6>] worker_thread+0x96/0xf0
 [<ffffffff8107af70>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81076f10>] ? worker_thread+0x0/0xf0
 [<ffffffff8107ab8e>] kthread+0x8e/0xa0
 [<ffffffff81012f8a>] child_rip+0xa/0x20
 [<ffffffff8107ab00>] ? kthread+0x0/0xa0
 [<ffffffff81012f80>] ? child_rip+0x0/0x20
INFO: task dataload:3947 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
dataload     D 0000000000000001     0  3947   2121 0x00000000
 ffff880074f37ce8 0000000000000082 0000000000000086 ffff880074f37fd8
 ffff88007b0316d0 0000000000015980 0000000000015980 ffff880074f37fd8
 0000000000015980 ffff880074f37fd8 0000000000015980 ffff88007b031a90
Call Trace:
 [<ffffffffa009c0e5>] xfs_ioend_wait+0x85/0xc0 [xfs]
 [<ffffffff8107af70>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa0097d1d>] xfs_setattr+0x85d/0xb20 [xfs]
 [<ffffffffa0094aa8>] ? xfs_trans_unlocked_item+0x38/0x50 [xfs]
 [<ffffffffa00a2ebd>] xfs_vn_fallocate+0xed/0x100 [xfs]
 [<ffffffff810334a9>] ? default_spin_lock_flags+0x9/0x10
 [<ffffffff81527ecf>] ? _spin_lock_irqsave+0x2f/0x50
 [<ffffffff8112556d>] do_fallocate+0xfd/0x110
 [<ffffffff811255c9>] sys_fallocate+0x49/0x70
 [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
