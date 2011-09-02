Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82CNB4i070202 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 07:23:11 -0500
Received: from camel.cissme.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C38512ED99
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2011 05:23:09 -0700 (PDT)
Received: from camel.cissme.com (camel.cissme.com [94.228.69.77]) by
	cuda.sgi.com with ESMTP id jqEXqUmz182zY9XN for
	<xfs@oss.sgi.com>; Fri, 02 Sep 2011 05:23:09 -0700 (PDT)
Received: from sheep.cissme.com ([94.228.69.11])
	by camel.cissme.com with esmtp (Exim 4.71)
	(envelope-from <sean@ci-info.com>) id 1QzSm0-0004JO-Bx
	for xfs@oss.sgi.com; Fri, 02 Sep 2011 12:23:06 +0000
From: Sean Purdy <sean@ci-info.com>
Subject: nginx blocked task when XFS partition is very full
Date: Fri, 2 Sep 2011 13:23:03 +0100
Message-Id: <3972BA0F-0E95-4758-9DDB-BC6197621C87@ci-info.com>
Mime-Version: 1.0 (Apple Message framework v1084)
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


This is on 2.6.32-32-server from Ubuntu Lucid 10.04 LTS

We have nginx fileserving from four disks on a machine.  We're using mogilefs as a distributed file system.  We've come across an issue where when the filesystem is very full, and nginx tries to write to it, we get "task blocked for more than 120 seconds" messages from the kernel, nginx hangs and we can no longer access the fs.  When a file is uploaded via nginx, nginx writes to a .tmp directory on the disk before moving the file to its destination.  nginx can't be kill -9ed, it needs a reboot.

Has this sort of issue been fixed since 2.6.32?


Thanks,

Sean


Here's the gory details:

[340381.743426] INFO: task flush-8:48:506 blocked for more than 120 seconds.
[340381.743802] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[340381.750570] flush-8:48    D 0000000000000000     0   506      2 0x00000000
[340381.750576]  ffff880126ea59b0 0000000000000046 0000000000015f00 0000000000015f00
[340381.750581]  ffff880126c5c8d0 ffff880126ea5fd8 0000000000015f00 ffff880126c5c500
[340381.750585]  0000000000015f00 ffff880126ea5fd8 0000000000015f00 ffff880126c5c8d0
[340381.750589] Call Trace:
[340381.750599]  [<ffffffff810f6410>] ? sync_page+0x0/0x50
[340381.750607]  [<ffffffff81558013>] io_schedule+0x73/0xc0
[340381.750610]  [<ffffffff810f644d>] sync_page+0x3d/0x50
[340381.750615]  [<ffffffff8155850a>] __wait_on_bit_lock+0x5a/0xc0
[340381.750618]  [<ffffffff810f63e7>] __lock_page+0x67/0x70
[340381.750624]  [<ffffffff810860d0>] ? wake_bit_function+0x0/0x40
[340381.750629]  [<ffffffff81100a15>] ? pagevec_lookup_tag+0x25/0x40
[340381.750632]  [<ffffffff810ffa87>] write_cache_pages+0x2f7/0x3e0
[340381.750637]  [<ffffffff810fe7d0>] ? __writepage+0x0/0x40
[340381.750641]  [<ffffffff810ffb94>] generic_writepages+0x24/0x30
[340381.750664]  [<ffffffffa0237afd>] xfs_vm_writepages+0x5d/0x80 [xfs]
[340381.750668]  [<ffffffff810ffbc1>] do_writepages+0x21/0x40
[340381.750673]  [<ffffffff81168db6>] writeback_single_inode+0xf6/0x3d0
[340381.750677]  [<ffffffff811694e5>] writeback_sb_inodes+0x195/0x280
[340381.750680]  [<ffffffff81169d00>] writeback_inodes_wb+0xa0/0x1b0
[340381.750684]  [<ffffffff8116a04b>] wb_writeback+0x23b/0x2a0
[340381.750688]  [<ffffffff81077bec>] ? lock_timer_base+0x3c/0x70
[340381.750692]  [<ffffffff8116a22c>] wb_do_writeback+0x17c/0x190
[340381.750696]  [<ffffffff81077d00>] ? process_timeout+0x0/0x10
[340381.750700]  [<ffffffff8116a293>] bdi_writeback_task+0x53/0xf0
[340381.750704]  [<ffffffff81111636>] bdi_start_fn+0x86/0x100
[340381.750708]  [<ffffffff811115b0>] ? bdi_start_fn+0x0/0x100
[340381.750711]  [<ffffffff81085d16>] kthread+0x96/0xa0
[340381.750716]  [<ffffffff810141ea>] child_rip+0xa/0x20
[340381.750719]  [<ffffffff81085c80>] ? kthread+0x0/0xa0
[340381.750723]  [<ffffffff810141e0>] ? child_rip+0x0/0x20

[340381.750732] INFO: task nginx:3581 blocked for more than 120 seconds.
[340381.755178] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[340381.765161] nginx         D 0000000000000000     0  3581   3580 0x00000000
[340381.765166]  ffff880128a27d38 0000000000000082 0000000000015f00 0000000000015f00
[340381.765170]  ffff88012742b1d0 ffff880128a27fd8 0000000000015f00 ffff88012742ae00
[340381.765174]  0000000000015f00 ffff880128a27fd8 0000000000015f00 ffff88012742b1d0
[340381.765178] Call Trace:
[340381.765184]  [<ffffffff81558d47>] __mutex_lock_slowpath+0x107/0x190
[340381.765189]  [<ffffffff811517c1>] ? path_put+0x31/0x40
[340381.765193]  [<ffffffff81558743>] mutex_lock+0x23/0x50
[340381.765197]  [<ffffffff81155139>] do_filp_open+0x3d9/0xba0
[340381.765203]  [<ffffffff810397f9>] ? default_spin_lock_flags+0x9/0x10
[340381.765209]  [<ffffffff81160aca>] ? alloc_fd+0x10a/0x150
[340381.765214]  [<ffffffff81144789>] do_sys_open+0x69/0x170
[340381.765217]  [<ffffffff811448d0>] sys_open+0x20/0x30
[340381.765223]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b

... a couple of similar ones for nginx:3582, nginx:3583, nginx:3584, followed by ...

[340381.838307] INFO: task nginx:3585 blocked for more than 120 seconds.
[340381.849329] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[340381.872639] nginx         D 0000000000000000     0  3585   3580 0x00000000
[340381.872643]  ffff88012b3f9098 0000000000000086 0000000000015f00 0000000000015f00
[340381.872648]  ffff88012a3c03d0 ffff88012b3f9fd8 0000000000015f00 ffff88012a3c0000
[340381.872652]  0000000000015f00 ffff88012b3f9fd8 0000000000015f00 ffff88012a3c03d0
[340381.872656] Call Trace:
[340381.872660]  [<ffffffff8155837d>] schedule_timeout+0x22d/0x300
[340381.872676]  [<ffffffffa01fea12>] ? xfs_btree_is_lastrec+0x52/0x70 [xfs]
[340381.872691]  [<ffffffffa0203d04>] ? xfs_btree_insrec+0x2e4/0x5a0 [xfs]
[340381.872695]  [<ffffffff815592ae>] __down+0x7e/0xc0
[340381.872699]  [<ffffffff8108b021>] down+0x41/0x50
[340381.872714]  [<ffffffffa023b1f3>] xfs_buf_lock+0x23/0x60 [xfs]
[340381.872732]  [<ffffffffa023b375>] _xfs_buf_find+0x145/0x240 [xfs]
[340381.872749]  [<ffffffffa023b4d0>] xfs_buf_get_flags+0x60/0x170 [xfs]
[340381.872768]  [<ffffffffa02307eb>] xfs_trans_get_buf+0xeb/0x140 [xfs]
[340381.872786]  [<ffffffffa01ff74e>] xfs_btree_get_bufs+0x3e/0x40 [xfs]
[340381.872801]  [<ffffffffa01ec380>] xfs_alloc_fix_freelist+0x110/0x480 [xfs]
[340381.872821]  [<ffffffffa022ae5f>] ? xfs_icsb_disable_counter+0x1f/0x150 [xfs]
[340381.872829]  [<ffffffff812c1d90>] ? __bitmap_weight+0x50/0xb0
[340381.872847]  [<ffffffffa022afcb>] ? xfs_icsb_balance_counter_locked+0x3b/0xd0 [xfs]
[340381.872864]  [<ffffffffa01ec958>] xfs_alloc_vextent+0x178/0x490 [xfs]
[340381.872880]  [<ffffffffa01fa856>] xfs_bmap_btalloc+0x176/0x9f0 [xfs]
[340381.872897]  [<ffffffffa01fbfb1>] xfs_bmap_alloc+0x21/0x40 [xfs]
[340381.872914]  [<ffffffffa01fcb6f>] xfs_bmapi+0xb9f/0x1290 [xfs]
[340381.872933]  [<ffffffffa0217ba8>] ? xfs_iext_get_ext+0x38/0x80 [xfs]
[340381.872952]  [<ffffffffa021e055>] xfs_iomap_write_allocate+0x1c5/0x3c0 [xfs]
[340381.872972]  [<ffffffffa021edab>] xfs_iomap+0x2ab/0x2e0 [xfs]
[340381.872989]  [<ffffffffa023745d>] xfs_map_blocks+0x2d/0x40 [xfs]
[340381.873007]  [<ffffffffa023886a>] xfs_page_state_convert+0x3da/0x720 [xfs]
[340381.873025]  [<ffffffffa0238d0a>] xfs_vm_writepage+0x7a/0x130 [xfs]
[340381.873034]  [<ffffffff8110f91e>] ? __dec_zone_page_state+0x2e/0x30
[340381.873041]  [<ffffffff810fe7e7>] __writepage+0x17/0x40
[340381.873046]  [<ffffffff810ff967>] write_cache_pages+0x1d7/0x3e0
[340381.873053]  [<ffffffff810fe7d0>] ? __writepage+0x0/0x40
[340381.873059]  [<ffffffff810ffb94>] generic_writepages+0x24/0x30
[340381.873076]  [<ffffffffa0237afd>] xfs_vm_writepages+0x5d/0x80 [xfs]
[340381.873083]  [<ffffffff810ffbc1>] do_writepages+0x21/0x40
[340381.873089]  [<ffffffff810f6beb>] __filemap_fdatawrite_range+0x5b/0x60
[340381.873096]  [<ffffffff810f6f1f>] filemap_fdatawrite+0x1f/0x30
[340381.873113]  [<ffffffffa023bf79>] xfs_flush_pages+0xa9/0xc0 [xfs]
[340381.873130]  [<ffffffffa0240448>] xfs_write+0x838/0x9f0 [xfs]
[340381.873137]  [<ffffffff81077bec>] ? lock_timer_base+0x3c/0x70
[340381.873154]  [<ffffffffa023bde2>] xfs_file_aio_write+0x62/0x70 [xfs]
[340381.873162]  [<ffffffff8114679a>] do_sync_write+0xfa/0x140
[340381.873169]  [<ffffffff81086090>] ? autoremove_wake_function+0x0/0x40
[340381.873177]  [<ffffffff812552b6>] ? security_file_permission+0x16/0x20
[340381.873184]  [<ffffffff81146a98>] vfs_write+0xb8/0x1a0
[340381.873190]  [<ffffffff81147402>] sys_pwrite64+0x82/0xa0
[340381.873197]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b

[340381.912512] INFO: task nginx:3587 blocked for more than 120 seconds.
[340381.926794] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[340381.956631] nginx         D 0000000000000000     0  3587   3580 0x00000000
[340381.956635]  ffff88012a28da38 0000000000000086 0000000000015f00 0000000000015f00
[340381.956639]  ffff88012a3c31d0 ffff88012a28dfd8 0000000000015f00 ffff88012a3c2e00
[340381.956643]  0000000000015f00 ffff88012a28dfd8 0000000000015f00 ffff88012a3c31d0
[340381.956647] Call Trace:
[340381.956652]  [<ffffffff8155837d>] schedule_timeout+0x22d/0x300
[340381.956656]  [<ffffffff8105f022>] ? enqueue_entity+0x132/0x1b0
[340381.956660]  [<ffffffff8105f0fb>] ? enqueue_task_fair+0x5b/0xa0
[340381.956664]  [<ffffffff815574f6>] wait_for_common+0xd6/0x180
[340381.956668]  [<ffffffff8105df00>] ? default_wake_function+0x0/0x20
[340381.956671]  [<ffffffff8105df55>] ? wake_up_process+0x15/0x20
[340381.956675]  [<ffffffff8155765d>] wait_for_completion+0x1d/0x20
[340381.956690]  [<ffffffffa0243a27>] xfs_flush_inodes+0x67/0x90 [xfs]
[340381.956706]  [<ffffffffa0233348>] xfs_create+0x328/0x5f0 [xfs]
[340381.956725]  [<ffffffffa022f749>] ? xfs_trans_unlocked_item+0x39/0x60 [xfs]
[340381.956742]  [<ffffffffa023eb97>] xfs_vn_mknod+0xa7/0x1c0 [xfs]
[340381.956759]  [<ffffffffa023ece0>] xfs_vn_create+0x10/0x20 [xfs]
[340381.956766]  [<ffffffff81151f34>] vfs_create+0xb4/0xe0
[340381.956772]  [<ffffffff81152024>] __open_namei_create+0xc4/0x110
[340381.956779]  [<ffffffff811557cb>] do_filp_open+0xa6b/0xba0
[340381.956786]  [<ffffffff810397f9>] ? default_spin_lock_flags+0x9/0x10
[340381.956793]  [<ffffffff81160aca>] ? alloc_fd+0x10a/0x150
[340381.956799]  [<ffffffff81144789>] do_sys_open+0x69/0x170
[340381.956805]  [<ffffffff811448d0>] sys_open+0x20/0x30
[340381.956811]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
