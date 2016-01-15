Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A06A67F47
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 03:08:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3E50AC004
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 01:08:02 -0800 (PST)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id lWxOPM5evZ8Zi4Ki (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2016 01:07:53 -0800 (PST)
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: xfs deadlocks since upgrading to 4.1.15
Message-ID: <5698B6EE.4000502@profihost.ag>
Date: Fri, 15 Jan 2016 10:07:58 +0100
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>

Hello,

since we upgraded from 3.18 to 4.1.15 i've seen many deadlocks. Alle 
call traces show xfs.

Attention all those are down top instead of top down (sorry for the 
wrong order).

NR 1:

2016-01-14 00:17:23     [<ffffffff93501ca5>] rtnl_lock+0x15/0x20
2016-01-14 00:17:23     [<ffffffff93501cf6>] rtnetlink_rcv+0x16/0x40
2016-01-14 00:17:23     [<ffffffff935252aa>] netlink_unicast+0x13a/0x1d0
2016-01-14 00:17:23     [<ffffffff9352554a>] netlink_sendmsg+0x20a/0x600
2016-01-14 00:17:23     [<ffffffff934d7d61>] SYSC_sendto+0x111/0x170
2016-01-14 00:17:23     [<ffffffff9314e263>] ? 
context_tracking_user_exit+0x13/0x20
2016-01-14 00:17:23     [<ffffffff930134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-14 00:17:23     [<ffffffff934d82ae>] SyS_sendto+0xe/0x10
2016-01-14 00:17:23     [<ffffffff936403ae>] system_call_fastpath+0x12/0x71
2016-01-14 00:17:22     [<ffffffff932e449f>] xlog_cil_push+0x22f/0x3f0
2016-01-14 00:17:22     [<ffffffff932e4675>] xlog_cil_push_work+0x15/0x20
2016-01-14 00:17:22     [<ffffffff930986bf>] process_one_work+0x14f/0x410
2016-01-14 00:17:22     [<ffffffff930989ac>] 
process_scheduled_works+0x2c/0x40
2016-01-14 00:17:22     [<ffffffff93098c4a>] worker_thread+0x28a/0x510
2016-01-14 00:17:22     [<ffffffff9363bbd1>] ? __schedule+0x4f1/0x990
2016-01-14 00:17:22     [<ffffffff930989c0>] ? 
process_scheduled_works+0x40/0x40
2016-01-14 00:17:22     [<ffffffff9309f1f9>] kthread+0xc9/0xe0
2016-01-14 00:17:22     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:22     [<ffffffff936407a2>] ret_from_fork+0x42/0x70
2016-01-14 00:17:22     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:22     INFO: task qpsmtpd p:25 :::12850 blocked for 
more than 120 seconds.
2016-01-14 00:17:22     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:22     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:22     qpsmtpd p:25 :: D ffff88071f807c48 0 12850 6124 
0x00000000
2016-01-14 00:17:22     ffff88071f807c48 ffff8805aabf0000 
ffff8806c5780000 ffff88083ffd7000
2016-01-14 00:17:22     ffff88071f808000 ffffffff93ce6444 
ffff8806c5780000 00000000ffffffff
2016-01-14 00:17:22     ffffffff93ce6448 ffff88071f807c68 
ffffffff9363c167 ffff88042b9f0000
2016-01-14 00:17:22     Call Trace:
2016-01-14 00:17:22     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:22     [<ffffffff9363c3de>] 
schedule_preempt_disabled+0xe/0x10
2016-01-14 00:17:22     [<ffffffff9363dfd5>] 
__mutex_lock_slowpath+0x95/0x110
2016-01-14 00:17:22     [<ffffffff9363e06b>] mutex_lock+0x1b/0x2f
2016-01-14 00:17:21     [<ffffffff931a7617>] __kmalloc+0x1c7/0x240
2016-01-14 00:17:21     [<ffffffff931e0224>] alloc_fdmem+0x24/0x40
2016-01-14 00:17:21     [<ffffffff931e02b7>] alloc_fdtable+0x77/0x100
2016-01-14 00:17:21     [<ffffffff931e0af2>] dup_fd+0x262/0x330
2016-01-14 00:17:21     [<ffffffff9307ec9a>] 
copy_process.part.37+0x76a/0x1a80
2016-01-14 00:17:21     [<ffffffff931190ec>] ? 
acct_account_cputime+0x1c/0x20
2016-01-14 00:17:21     [<ffffffff9308014c>] do_fork+0xbc/0x350
2016-01-14 00:17:21     [<ffffffff930134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-14 00:17:21     [<ffffffff9314e243>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-14 00:17:21     [<ffffffff93080466>] SyS_clone+0x16/0x20
2016-01-14 00:17:21     [<ffffffff936403ae>] system_call_fastpath+0x12/0x71
2016-01-14 00:17:21     INFO: task kworker/7:0:23773 blocked for more 
than 120 seconds.
2016-01-14 00:17:21     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:21     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:21     kworker/7:0 D ffff8805243bbb38 0 23773 2 0x00000000
2016-01-14 00:17:21     Workqueue: xfs-cil/sdb1 xlog_cil_push_work
2016-01-14 00:17:21     ffff8805243bbb38 ffff88082d941d50 
ffff880790560000 0000000000000000
2016-01-14 00:17:21     ffff8805243bc000 ffff88010af7c0b8 
ffff88042c067d28 ffff880790560000
2016-01-14 00:17:21     ffff88042c067d00 ffff8805243bbb58 
ffffffff9363c167 ffff88042c067c00
2016-01-14 00:17:21     Call Trace:
2016-01-14 00:17:21     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:21     [<ffffffff932e241b>] 
xlog_state_get_iclog_space+0xdb/0x2e0
2016-01-14 00:17:21     [<ffffffff932dfe14>] ? xlog_bdstrat+0x34/0x70
2016-01-14 00:17:21     [<ffffffff930ad330>] ? try_to_wake_up+0x330/0x330
2016-01-14 00:17:21     [<ffffffff932e291e>] xlog_write+0x18e/0x700
2016-01-14 00:17:20     [<ffffffff93095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-14 00:17:20     [<ffffffff932e4c3e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-14 00:17:20     [<ffffffffc03efb24>] ? aac_fib_send+0x2c4/0x4f0 
[aacraid]
2016-01-14 00:17:20     [<ffffffff932e3338>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-14 00:17:20     [<ffffffff932b4b87>] ? 
xfs_iext_bno_to_ext+0x97/0x170
2016-01-14 00:17:20     [<ffffffff932e35db>] xfs_log_force_lsn+0x3b/0xa0
2016-01-14 00:17:20     [<ffffffff932ca610>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-14 00:17:20     [<ffffffff932d595e>] xfs_iunpin_wait+0xae/0x140
2016-01-14 00:17:20     [<ffffffff930c2be0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-14 00:17:20     [<ffffffff932ca610>] xfs_reclaim_inode+0xd0/0x330
2016-01-14 00:17:20     [<ffffffff932caae7>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-14 00:17:20     [<ffffffff932cb673>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-14 00:17:20     [<ffffffff932da169>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-14 00:17:20     [<ffffffff931c7313>] super_cache_scan+0x1a3/0x1b0
2016-01-14 00:17:20     [<ffffffff9315fb06>] shrink_slab+0x216/0x3d0
2016-01-14 00:17:20     [<ffffffff93164399>] shrink_zone+0x2b9/0x2d0
2016-01-14 00:17:20     [<ffffffff9316470a>] 
do_try_to_free_pages+0x16a/0x400
2016-01-14 00:17:20     [<ffffffff93164baa>] try_to_free_pages+0xda/0x160
2016-01-14 00:17:20     [<ffffffff93635ceb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-14 00:17:20     [<ffffffff931581e0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-14 00:17:20     [<ffffffff9319cc0c>] alloc_pages_current+0x9c/0x110
2016-01-14 00:17:20     [<ffffffff931a59cb>] new_slab+0x32b/0x450
2016-01-14 00:17:20     [<ffffffff9316d468>] ? zone_statistics+0x98/0xc0
2016-01-14 00:17:20     [<ffffffff936376f8>] __slab_alloc+0x2de/0x433
2016-01-14 00:17:20     [<ffffffff931e0224>] ? alloc_fdmem+0x24/0x40
2016-01-14 00:17:19     [<ffffffff93355fa9>] ida_pre_get+0x69/0x100
2016-01-14 00:17:19     [<ffffffff93356d9e>] ida_simple_get+0x4e/0xf0
2016-01-14 00:17:19     [<ffffffff930a7c9e>] ? 
finish_task_switch+0x11e/0x1a0
2016-01-14 00:17:19     [<ffffffff93097adb>] create_worker+0x4b/0x1f0
2016-01-14 00:17:19     [<ffffffff930e1e0a>] ? mod_timer+0x14a/0x1c0
2016-01-14 00:17:19     [<ffffffff93098daf>] worker_thread+0x3ef/0x510
2016-01-14 00:17:19     [<ffffffff9363bbd1>] ? __schedule+0x4f1/0x990
2016-01-14 00:17:19     [<ffffffff930989c0>] ? 
process_scheduled_works+0x40/0x40
2016-01-14 00:17:19     [<ffffffff9309f1f9>] kthread+0xc9/0xe0
2016-01-14 00:17:19     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:19     [<ffffffff936407a2>] ret_from_fork+0x42/0x70
2016-01-14 00:17:19     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:19     INFO: task httpd:22880 blocked for more than 120 
seconds.
2016-01-14 00:17:19     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:19     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:19     httpd D ffff88005557b108 0 22880 22644 0x00000000
2016-01-14 00:17:19     ffff88005557b108 ffff88042dbdbaa0 
ffff8807e65a57f0 ffff88005557b1b8
2016-01-14 00:17:19     ffff88005557c000 ffff88005557b270 
7fffffffffffffff ffff8807e65a57f0
2016-01-14 00:17:19     ffffffffffffffff ffff88005557b128 
ffffffff9363c167 0000000000000292
2016-01-14 00:17:19     Call Trace:
2016-01-14 00:17:19     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:19     [<ffffffff9363ee7c>] schedule_timeout+0x1fc/0x260
2016-01-14 00:17:19     [<ffffffff933506b5>] ? cfq_set_request+0xa5/0x4c0
2016-01-14 00:17:19     [<ffffffff9363cc9f>] wait_for_completion+0x9f/0x170
2016-01-14 00:17:19     [<ffffffff930ad330>] ? try_to_wake_up+0x330/0x330
2016-01-14 00:17:19     [<ffffffff93099b7f>] flush_work+0xff/0x1d0
2016-01-14 00:17:18     [<ffffffff9334c148>] ? 
__cfq_set_active_queue+0xf8/0x230
2016-01-14 00:17:18     [<ffffffff932e3338>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-14 00:17:18     [<ffffffff932e35db>] xfs_log_force_lsn+0x3b/0xa0
2016-01-14 00:17:18     [<ffffffff932ca610>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-14 00:17:18     [<ffffffff932d595e>] xfs_iunpin_wait+0xae/0x140
2016-01-14 00:17:18     [<ffffffff930c2be0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-14 00:17:18     [<ffffffff932ca610>] xfs_reclaim_inode+0xd0/0x330
2016-01-14 00:17:18     [<ffffffff932caae7>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-14 00:17:18     [<ffffffff932cb673>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-14 00:17:18     [<ffffffff932da169>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-14 00:17:18     [<ffffffff931c7313>] super_cache_scan+0x1a3/0x1b0
2016-01-14 00:17:18     [<ffffffff9315fb06>] shrink_slab+0x216/0x3d0
2016-01-14 00:17:18     [<ffffffff93164399>] shrink_zone+0x2b9/0x2d0
2016-01-14 00:17:18     [<ffffffff9316470a>] 
do_try_to_free_pages+0x16a/0x400
2016-01-14 00:17:18     [<ffffffff93164baa>] try_to_free_pages+0xda/0x160
2016-01-14 00:17:18     [<ffffffff93635ceb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-14 00:17:18     [<ffffffff931581e0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-14 00:17:18     [<ffffffff9319cc0c>] alloc_pages_current+0x9c/0x110
2016-01-14 00:17:18     [<ffffffff931a59cb>] new_slab+0x32b/0x450
2016-01-14 00:17:18     [<ffffffff930ad1f3>] ? try_to_wake_up+0x1f3/0x330
2016-01-14 00:17:18     [<ffffffff936376f8>] __slab_alloc+0x2de/0x433
2016-01-14 00:17:18     [<ffffffff93355fa9>] ? ida_pre_get+0x69/0x100
2016-01-14 00:17:18     [<ffffffff930c2f43>] ? __wake_up+0x53/0x70
2016-01-14 00:17:18     [<ffffffff931a7f53>] kmem_cache_alloc+0x193/0x1f0
2016-01-14 00:17:18     [<ffffffff930b42f0>] ? pick_next_entity+0x90/0x170
2016-01-14 00:17:17     [<ffffffff93098daf>] worker_thread+0x3ef/0x510
2016-01-14 00:17:17     [<ffffffff9363bbd1>] ? __schedule+0x4f1/0x990
2016-01-14 00:17:17     [<ffffffff930989c0>] ? 
process_scheduled_works+0x40/0x40
2016-01-14 00:17:17     [<ffffffff9309f1f9>] kthread+0xc9/0xe0
2016-01-14 00:17:17     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:17     [<ffffffff936407a2>] ret_from_fork+0x42/0x70
2016-01-14 00:17:17     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:17     INFO: task kworker/7:0H:7845 blocked for more 
than 120 seconds.
2016-01-14 00:17:17     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:17     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:17     kworker/7:0H D ffff8806ec7ff108 0 7845 2 0x00000000
2016-01-14 00:17:17     ffff8806ec7ff108 ffff88044840d7f0 
ffff88082762baa0 ffff88044840d7f0
2016-01-14 00:17:17     ffff8806ec800000 ffff8806ec7ff270 
7fffffffffffffff ffff88082762baa0
2016-01-14 00:17:17     ffffffffffffffff ffff8806ec7ff128 
ffffffff9363c167 ffff8806ec7ff148
2016-01-14 00:17:17     Call Trace:
2016-01-14 00:17:17     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:17     [<ffffffff9363ee7c>] schedule_timeout+0x1fc/0x260
2016-01-14 00:17:17     [<ffffffff930a98b6>] ? 
ttwu_do_activate.constprop.91+0x66/0x70
2016-01-14 00:17:17     [<ffffffff930ad1f3>] ? try_to_wake_up+0x1f3/0x330
2016-01-14 00:17:17     [<ffffffff9335090f>] ? cfq_set_request+0x2ff/0x4c0
2016-01-14 00:17:17     [<ffffffff9363cc9f>] wait_for_completion+0x9f/0x170
2016-01-14 00:17:17     [<ffffffff930ad330>] ? try_to_wake_up+0x330/0x330
2016-01-14 00:17:17     [<ffffffff93099b7f>] flush_work+0xff/0x1d0
2016-01-14 00:17:17     [<ffffffff93095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-14 00:17:17     [<ffffffff932e4c3e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-14 00:17:16     [<ffffffff932d595e>] xfs_iunpin_wait+0xae/0x140
2016-01-14 00:17:16     [<ffffffff930c2be0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-14 00:17:16     [<ffffffff932ca610>] xfs_reclaim_inode+0xd0/0x330
2016-01-14 00:17:16     [<ffffffff932caae7>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-14 00:17:16     [<ffffffff932cb673>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-14 00:17:16     [<ffffffff932da169>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-14 00:17:16     [<ffffffff931c7313>] super_cache_scan+0x1a3/0x1b0
2016-01-14 00:17:16     [<ffffffff9315fb06>] shrink_slab+0x216/0x3d0
2016-01-14 00:17:16     [<ffffffff93164399>] shrink_zone+0x2b9/0x2d0
2016-01-14 00:17:16     [<ffffffff9316470a>] 
do_try_to_free_pages+0x16a/0x400
2016-01-14 00:17:16     [<ffffffff93164baa>] try_to_free_pages+0xda/0x160
2016-01-14 00:17:16     [<ffffffff93635ceb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-14 00:17:16     [<ffffffff931581e0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-14 00:17:16     [<ffffffff9319cc0c>] alloc_pages_current+0x9c/0x110
2016-01-14 00:17:16     [<ffffffff931a59cb>] new_slab+0x32b/0x450
2016-01-14 00:17:16     [<ffffffff936376f8>] __slab_alloc+0x2de/0x433
2016-01-14 00:17:16     [<ffffffff93355fa9>] ? ida_pre_get+0x69/0x100
2016-01-14 00:17:16     [<ffffffff931a7f53>] kmem_cache_alloc+0x193/0x1f0
2016-01-14 00:17:16     [<ffffffff9300d775>] ? native_sched_clock+0x35/0x80
2016-01-14 00:17:16     [<ffffffff93355fa9>] ida_pre_get+0x69/0x100
2016-01-14 00:17:16     [<ffffffff93356d9e>] ida_simple_get+0x4e/0xf0
2016-01-14 00:17:16     [<ffffffff930a7c9e>] ? 
finish_task_switch+0x11e/0x1a0
2016-01-14 00:17:16     [<ffffffff93097adb>] create_worker+0x4b/0x1f0
2016-01-14 00:17:16     [<ffffffff930e1e0a>] ? mod_timer+0x14a/0x1c0
2016-01-14 00:17:15     [<ffffffff931f4c58>] do_fsync+0x38/0x70
2016-01-14 00:17:15     [<ffffffff9314e243>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-14 00:17:15     [<ffffffff93013805>] ? syscall_trace_leave+0x95/0xf0
2016-01-14 00:17:15     [<ffffffff931f4ef3>] SyS_fdatasync+0x13/0x20
2016-01-14 00:17:15     [<ffffffff936403ae>] system_call_fastpath+0x12/0x71
2016-01-14 00:17:15     INFO: task kworker/7:2:22195 blocked for more 
than 120 seconds.
2016-01-14 00:17:15     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:15     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:15     kworker/7:2 D ffff88009ac93108 0 22195 2 0x00000000
2016-01-14 00:17:15     ffff88009ac93108 ffff88082d941d50 
ffff88044840d7f0 0000000950d64c61
2016-01-14 00:17:15     ffff88009ac94000 ffff88009ac93270 
7fffffffffffffff ffff88044840d7f0
2016-01-14 00:17:15     ffffffffffffffff ffff88009ac93128 
ffffffff9363c167 74612e656e6f6568
2016-01-14 00:17:15     Call Trace:
2016-01-14 00:17:15     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:15     [<ffffffff9363ee7c>] schedule_timeout+0x1fc/0x260
2016-01-14 00:17:15     [<ffffffff9363cc9f>] wait_for_completion+0x9f/0x170
2016-01-14 00:17:15     [<ffffffff930ad330>] ? try_to_wake_up+0x330/0x330
2016-01-14 00:17:15     [<ffffffff93099b7f>] flush_work+0xff/0x1d0
2016-01-14 00:17:15     [<ffffffff93095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-14 00:17:15     [<ffffffff932e4c3e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-14 00:17:15     [<ffffffff932e3338>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-14 00:17:15     [<ffffffff932b4b87>] ? 
xfs_iext_bno_to_ext+0x97/0x170
2016-01-14 00:17:15     [<ffffffff932e35db>] xfs_log_force_lsn+0x3b/0xa0
2016-01-14 00:17:15     [<ffffffff932ca610>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-14 00:17:14     [<ffffffff9354d671>] ? tcp_write_xmit+0x2b1/0xda0
2016-01-14 00:17:14     [<ffffffff934da9a1>] 
sk_prot_alloc.isra.38+0x41/0x170
2016-01-14 00:17:14     [<ffffffff934db9b3>] sk_alloc+0x33/0xb0
2016-01-14 00:17:14     [<ffffffff93590231>] unix_create1+0x51/0x1a0
2016-01-14 00:17:14     [<ffffffff935903f3>] unix_create+0x73/0x90
2016-01-14 00:17:14     [<ffffffff934d6710>] __sock_create+0xf0/0x1f0
2016-01-14 00:17:14     [<ffffffff930d95f8>] ? rcu_eqs_enter+0x68/0x90
2016-01-14 00:17:14     [<ffffffff934d6870>] sock_create+0x30/0x40
2016-01-14 00:17:14     [<ffffffff934d803c>] SyS_socketpair+0x6c/0x1d0
2016-01-14 00:17:14     [<ffffffff93013805>] ? syscall_trace_leave+0x95/0xf0
2016-01-14 00:17:14     [<ffffffff936403ae>] system_call_fastpath+0x12/0x71
2016-01-14 00:17:14     INFO: task imap:26593 blocked for more than 120 
seconds.
2016-01-14 00:17:14     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:14     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:14     imap D ffff880675a5fdc8 0 26593 4498 0x00000000
2016-01-14 00:17:14     ffff880675a5fdc8 ffff88082d943aa0 
ffff8807abab0000 ffff8806b0702f00
2016-01-14 00:17:14     ffff880675a60000 ffff88042b1f9928 
ffff88042b1f9800 ffff88042bba4c18
2016-01-14 00:17:14     ffff8807abab0000 ffff880675a5fde8 
ffffffff9363c167 0000fddf00010800
2016-01-14 00:17:14     Call Trace:
2016-01-14 00:17:14     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:14     [<ffffffff932e3433>] _xfs_log_force_lsn+0x153/0x2c0
2016-01-14 00:17:14     [<ffffffff930ad330>] ? try_to_wake_up+0x330/0x330
2016-01-14 00:17:14     [<ffffffff932c5d96>] xfs_dir_fsync+0x86/0xf0
2016-01-14 00:17:14     [<ffffffff931f4a56>] vfs_fsync_range+0x46/0xc0
2016-01-14 00:17:14     [<ffffffff931f4aec>] vfs_fsync+0x1c/0x20
2016-01-14 00:17:13     [<ffffffff9363dfd5>] 
__mutex_lock_slowpath+0x95/0x110
2016-01-14 00:17:13     [<ffffffff9363e06b>] mutex_lock+0x1b/0x2f
2016-01-14 00:17:13     [<ffffffff932cab77>] 
xfs_reclaim_inodes_ag+0x307/0x3d0
2016-01-14 00:17:13     [<ffffffff931d8cf0>] ? spin_unlock+0x10/0x10
2016-01-14 00:17:13     [<ffffffff930d9d1f>] ? __call_rcu+0x3f/0x360
2016-01-14 00:17:13     [<ffffffff931df3c9>] ? inode_lru_isolate+0x89/0x1c0
2016-01-14 00:17:13     [<ffffffff93177e48>] ? 
__list_lru_walk_one.isra.6+0x158/0x170
2016-01-14 00:17:13     [<ffffffff931df340>] ? 
insert_inode_locked+0x180/0x180
2016-01-14 00:17:13     [<ffffffff931df340>] ? 
insert_inode_locked+0x180/0x180
2016-01-14 00:17:13     [<ffffffff932cb673>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-14 00:17:13     [<ffffffff932da169>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-14 00:17:13     [<ffffffff931c7313>] super_cache_scan+0x1a3/0x1b0
2016-01-14 00:17:13     [<ffffffff9315fb06>] shrink_slab+0x216/0x3d0
2016-01-14 00:17:13     [<ffffffff93164399>] shrink_zone+0x2b9/0x2d0
2016-01-14 00:17:13     [<ffffffff9316470a>] 
do_try_to_free_pages+0x16a/0x400
2016-01-14 00:17:13     [<ffffffff93164baa>] try_to_free_pages+0xda/0x160
2016-01-14 00:17:13     [<ffffffff93635ceb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-14 00:17:13     [<ffffffff931581e0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-14 00:17:13     [<ffffffff9319cc0c>] alloc_pages_current+0x9c/0x110
2016-01-14 00:17:13     [<ffffffff931a59cb>] new_slab+0x32b/0x450
2016-01-14 00:17:13     [<ffffffff936376f8>] __slab_alloc+0x2de/0x433
2016-01-14 00:17:13     [<ffffffff934da9a1>] ? 
sk_prot_alloc.isra.38+0x41/0x170
2016-01-14 00:17:13     [<ffffffff931a7f53>] kmem_cache_alloc+0x193/0x1f0
2016-01-14 00:17:12     Call Trace:
2016-01-14 00:17:12     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:12     [<ffffffff932e354b>] _xfs_log_force_lsn+0x26b/0x2c0
2016-01-14 00:17:12     [<ffffffff930ad330>] ? try_to_wake_up+0x330/0x330
2016-01-14 00:17:12     [<ffffffff932c626f>] xfs_file_fsync+0x18f/0x1e0
2016-01-14 00:17:12     [<ffffffff931f4a56>] vfs_fsync_range+0x46/0xc0
2016-01-14 00:17:12     [<ffffffff931f4aec>] vfs_fsync+0x1c/0x20
2016-01-14 00:17:12     [<ffffffff931f4c58>] do_fsync+0x38/0x70
2016-01-14 00:17:12     [<ffffffff9314e243>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-14 00:17:12     [<ffffffff93013805>] ? syscall_trace_leave+0x95/0xf0
2016-01-14 00:17:12     [<ffffffff931f4ed0>] SyS_fsync+0x10/0x20
2016-01-14 00:17:12     [<ffffffff936403ae>] system_call_fastpath+0x12/0x71
2016-01-14 00:17:12     INFO: task pop3-login:7921 blocked for more than 
120 seconds.
2016-01-14 00:17:12     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:12     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:12     pop3-login D ffff88082c5234f8 0 7921 4498 0x00000000
2016-01-14 00:17:12     ffff88082c5234f8 ffff88042dbdbaa0 
ffff880827443aa0 ffff88082c523568
2016-01-14 00:17:12     ffff88082c524000 ffff88082bb63b6c 
ffff880827443aa0 00000000ffffffff
2016-01-14 00:17:12     ffff88082bb63b70 ffff88082c523518 
ffffffff9363c167 0000000000000000
2016-01-14 00:17:12     Call Trace:
2016-01-14 00:17:12     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:12     [<ffffffff9363c3de>] 
schedule_preempt_disabled+0xe/0x10
2016-01-14 00:17:11     [<ffffffff93099b7f>] flush_work+0xff/0x1d0
2016-01-14 00:17:11     [<ffffffff93095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-14 00:17:11     [<ffffffff932e4c3e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-14 00:17:11     [<ffffffff930e14bf>] ? 
try_to_del_timer_sync+0x4f/0x70
2016-01-14 00:17:11     [<ffffffff932e2feb>] _xfs_log_force+0x6b/0x280
2016-01-14 00:17:11     [<ffffffff932c37e0>] ? 
xfs_buf_delwri_submit_nowait+0x20/0x30
2016-01-14 00:17:11     [<ffffffff932e322a>] xfs_log_force+0x2a/0x90
2016-01-14 00:17:11     [<ffffffff932edb60>] ? 
xfs_trans_ail_cursor_first+0x90/0x90
2016-01-14 00:17:11     [<ffffffff932edca3>] xfsaild+0x143/0x5f0
2016-01-14 00:17:11     [<ffffffff9363bbd1>] ? __schedule+0x4f1/0x990
2016-01-14 00:17:11     [<ffffffff932edb60>] ? 
xfs_trans_ail_cursor_first+0x90/0x90
2016-01-14 00:17:11     [<ffffffff9309f1f9>] kthread+0xc9/0xe0
2016-01-14 00:17:11     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:11     [<ffffffff936407a2>] ret_from_fork+0x42/0x70
2016-01-14 00:17:11     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:11     INFO: task mysqld:7538 blocked for more than 120 
seconds.
2016-01-14 00:17:11     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:11     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:11     mysqld D ffff8803e708bd98 0 7538 3771 0x00000000
2016-01-14 00:17:11     ffff8803e708bd98 ffff88082d941d50 
ffff8803f1ebd7f0 ffff88042bba4c00
2016-01-14 00:17:11     ffff8803e708c000 ffff88042b1f9928 
ffff88042b1f9800 0000000000000000
2016-01-14 00:17:11     ffff8803f1ebd7f0 ffff8803e708bdb8 
ffffffff9363c167 ffff8803f1ebd7f0
2016-01-14 00:17:10     [<ffffffff9363bbd1>] ? __schedule+0x4f1/0x990
2016-01-14 00:17:10     [<ffffffff932edb60>] ? 
xfs_trans_ail_cursor_first+0x90/0x90
2016-01-14 00:17:10     [<ffffffff9309f1f9>] kthread+0xc9/0xe0
2016-01-14 00:17:10     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:10     [<ffffffff936407a2>] ret_from_fork+0x42/0x70
2016-01-14 00:17:10     [<ffffffff9309f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-14 00:17:10     INFO: task xfsaild/sdb1:2068 blocked for more 
than 120 seconds.
2016-01-14 00:17:10     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:10     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:10     xfsaild/sdb1 D ffff88042529fad8 0 2068 2 0x00000000
2016-01-14 00:17:10     ffff88042529fad8 ffff88082d948000 
ffff8800b94ad7f0 ffff88082a8401d0
2016-01-14 00:17:10     ffff8804252a0000 ffff88042529fc40 
7fffffffffffffff ffff8800b94ad7f0
2016-01-14 00:17:10     ffffffffffffffff ffff88042529faf8 
ffffffff9363c167 0000000000000000
2016-01-14 00:17:10     Call Trace:
2016-01-14 00:17:10     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:10     [<ffffffff9363ee7c>] schedule_timeout+0x1fc/0x260
2016-01-14 00:17:10     [<ffffffff93326f0c>] ? part_round_stats+0x5c/0x70
2016-01-14 00:17:10     [<ffffffff93239439>] ? kernfs_path_locked+0x49/0xa0
2016-01-14 00:17:10     [<ffffffff93324a22>] ? elv_rb_add+0x62/0x70
2016-01-14 00:17:10     [<ffffffff9363cc9f>] wait_for_completion+0x9f/0x170
2016-01-14 00:17:10     [<ffffffff930ad330>] ? try_to_wake_up+0x330/0x330
2016-01-14 00:17:09     INFO: task xfsaild/sda3:598 blocked for more 
than 120 seconds.
2016-01-14 00:17:09     Not tainted 4.1.14+63-ph #1
2016-01-14 00:17:09     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-14 00:17:09     xfsaild/sda3 D ffff88042a8d7d18 0 598 2 0x00000000
2016-01-14 00:17:09     ffff88042a8d7d18 ffff880102c93aa0 
ffff88042c248000 0000000000000282
2016-01-14 00:17:09     ffff88042a8d8000 ffff88042c248000 
0000000000000000 ffff88042b1f9800
2016-01-14 00:17:09     ffff88042bba4100 ffff88042a8d7d38 
ffffffff9363c167 ffff88042b1f9928
2016-01-14 00:17:09     Call Trace:
2016-01-14 00:17:09     [<ffffffff9363c167>] schedule+0x37/0x90
2016-01-14 00:17:09     [<ffffffff932e3109>] _xfs_log_force+0x189/0x280
2016-01-14 00:17:09     [<ffffffff930ad330>] ? try_to_wake_up+0x330/0x330
2016-01-14 00:17:09     [<ffffffff932e322a>] xfs_log_force+0x2a/0x90
2016-01-14 00:17:09     [<ffffffff932edb60>] ? 
xfs_trans_ail_cursor_first+0x90/0x90
2016-01-14 00:17:09     [<ffffffff932edca3>] xfsaild+0x143/0x5f0


Nr 2:

2016-01-15 02:01:04     [<ffffffff8e2c1d00>] xfs_buf_lock+0x40/0xe0
2016-01-15 02:01:04     [<ffffffff8e2c1f04>] _xfs_buf_find+0x164/0x2a0
2016-01-15 02:01:04     [<ffffffff8e2c20f5>] xfs_buf_get_map+0x35/0x180
2016-01-15 02:01:04     [<ffffffff8e2c2f77>] xfs_buf_read_map+0x37/0x110
2016-01-15 02:01:04     [<ffffffff8e2eef29>] 
xfs_trans_read_buf_map+0xf9/0x280
2016-01-15 02:01:04     [<ffffffff8e2b2985>] xfs_read_agi+0x95/0xf0
2016-01-15 02:01:04     [<ffffffff8e2d1dac>] xfs_iunlink_remove+0x4c/0x420
2016-01-15 02:01:04     [<ffffffff8e2e122e>] ? 
xlog_grant_head_check+0x4e/0xf0
2016-01-15 02:01:04     [<ffffffff8e2d54d7>] xfs_ifree+0x27/0xd0
2016-01-15 02:01:04     [<ffffffff8e2ef776>] ? xfs_trans_ijoin+0x36/0x60
2016-01-15 02:01:04     [<ffffffff8e2d5641>] xfs_inactive_ifree+0xc1/0x230
2016-01-15 02:01:04     [<ffffffff8e2d5846>] xfs_inactive+0x96/0x150
2016-01-15 02:01:04     [<ffffffff8e2da5cf>] xfs_fs_evict_inode+0x6f/0xb0
2016-01-15 02:01:04     [<ffffffff8e1de7b0>] evict+0xc0/0x1a0
2016-01-15 02:01:04     [<ffffffff8e1defdb>] iput+0x18b/0x1f0
2016-01-15 02:01:04     [<ffffffff8e1da678>] __dentry_kill+0x198/0x200
2016-01-15 02:01:04     [<ffffffff8e1dace0>] dput+0x1c0/0x220
2016-01-15 02:01:04     [<ffffffff8e1c5a24>] __fput+0x164/0x1e0
2016-01-15 02:01:04     [<ffffffff8e1c5aee>] ____fput+0xe/0x10
2016-01-15 02:01:04     [<ffffffff8e09d5ff>] task_work_run+0xbf/0x100
2016-01-15 02:01:04     [<ffffffff8e003bf8>] do_notify_resume+0x88/0xa0
2016-01-15 02:01:04     [<ffffffff8e640d7c>] int_signal+0x12/0x17
2016-01-15 02:01:03     [<ffffffff8e2d5846>] xfs_inactive+0x96/0x150
2016-01-15 02:01:03     [<ffffffff8e2da5cf>] xfs_fs_evict_inode+0x6f/0xb0
2016-01-15 02:01:03     [<ffffffff8e1de7b0>] evict+0xc0/0x1a0
2016-01-15 02:01:03     [<ffffffff8e1defdb>] iput+0x18b/0x1f0
2016-01-15 02:01:03     [<ffffffff8e1da678>] __dentry_kill+0x198/0x200
2016-01-15 02:01:03     [<ffffffff8e1dace0>] dput+0x1c0/0x220
2016-01-15 02:01:03     [<ffffffff8e1c5a24>] __fput+0x164/0x1e0
2016-01-15 02:01:03     [<ffffffff8e1c5aee>] ____fput+0xe/0x10
2016-01-15 02:01:03     [<ffffffff8e09d5ff>] task_work_run+0xbf/0x100
2016-01-15 02:01:03     [<ffffffff8e003bf8>] do_notify_resume+0x88/0xa0
2016-01-15 02:01:03     [<ffffffff8e640d7c>] int_signal+0x12/0x17
2016-01-15 02:01:03     INFO: task php5.4:9661 blocked for more than 120 
seconds.
2016-01-15 02:01:03     Not tainted 4.1.15+68-ph #1
2016-01-15 02:01:03     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:01:03     php5.4 D ffff8800189278e8 0 9661 15202 0x00000004
2016-01-15 02:01:03     ffff8800189278e8 ffff880624309d50 
ffff88000b4a57f0 ffff880000000002
2016-01-15 02:01:03     ffff880018928000 7fffffffffffffff 
ffff88000b4a57f0 0000000000000002
2016-01-15 02:01:03     0000000000000000 ffff880018927908 
ffffffff8e63c967 0000000000000000
2016-01-15 02:01:03     Call Trace:
2016-01-15 02:01:03     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:01:03     [<ffffffff8e63f68c>] schedule_timeout+0x1fc/0x260
2016-01-15 02:01:03     [<ffffffff8e32cee7>] ? blk_peek_request+0x87/0x290
2016-01-15 02:01:03     [<ffffffff8e63e93e>] __down_common+0xaf/0x118
2016-01-15 02:01:03     [<ffffffff8e2c1f04>] ? _xfs_buf_find+0x164/0x2a0
2016-01-15 02:01:03     [<ffffffff8e63ea1a>] __down+0x1d/0x1f
2016-01-15 02:01:03     [<ffffffff8e0c9831>] down+0x41/0x50
2016-01-15 02:01:02     Not tainted 4.1.15+68-ph #1
2016-01-15 02:01:02     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:01:02     php5.4 D ffff8800017338e8 0 9657 15202 0x00000004
2016-01-15 02:01:02     ffff8800017338e8 ffff8806242f0000 
ffff8800010a1d50 0000000000000002
2016-01-15 02:01:02     ffff880001734000 7fffffffffffffff 
ffff8800010a1d50 0000000000000002
2016-01-15 02:01:02     0000000000000000 ffff880001733908 
ffffffff8e63c967 0000000000000000
2016-01-15 02:01:02     Call Trace:
2016-01-15 02:01:02     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:01:02     [<ffffffff8e63f68c>] schedule_timeout+0x1fc/0x260
2016-01-15 02:01:02     [<ffffffff8e0b25a8>] ? __enqueue_entity+0x78/0x80
2016-01-15 02:01:02     [<ffffffff8e63e93e>] __down_common+0xaf/0x118
2016-01-15 02:01:02     [<ffffffff8e16d478>] ? zone_statistics+0x98/0xc0
2016-01-15 02:01:02     [<ffffffff8e2c1f04>] ? _xfs_buf_find+0x164/0x2a0
2016-01-15 02:01:02     [<ffffffff8e63ea1a>] __down+0x1d/0x1f
2016-01-15 02:01:02     [<ffffffff8e0c9831>] down+0x41/0x50
2016-01-15 02:01:02     [<ffffffff8e2c1d00>] xfs_buf_lock+0x40/0xe0
2016-01-15 02:01:02     [<ffffffff8e2c1f04>] _xfs_buf_find+0x164/0x2a0
2016-01-15 02:01:02     [<ffffffff8e2c20f5>] xfs_buf_get_map+0x35/0x180
2016-01-15 02:01:02     [<ffffffff8e2c2f77>] xfs_buf_read_map+0x37/0x110
2016-01-15 02:01:02     [<ffffffff8e2eef29>] 
xfs_trans_read_buf_map+0xf9/0x280
2016-01-15 02:01:02     [<ffffffff8e2b2985>] xfs_read_agi+0x95/0xf0
2016-01-15 02:01:02     [<ffffffff8e2d1dac>] xfs_iunlink_remove+0x4c/0x420
2016-01-15 02:01:02     [<ffffffff8e2e122e>] ? 
xlog_grant_head_check+0x4e/0xf0
2016-01-15 02:01:02     [<ffffffff8e2d54d7>] xfs_ifree+0x27/0xd0
2016-01-15 02:01:02     [<ffffffff8e2ef776>] ? xfs_trans_ijoin+0x36/0x60
2016-01-15 02:01:02     [<ffffffff8e2d5641>] xfs_inactive_ifree+0xc1/0x230
2016-01-15 02:01:01     [<ffffffff8e2b2a23>] xfs_ialloc_read_agi+0x43/0xe0
2016-01-15 02:01:01     [<ffffffff8e2b3421>] xfs_dialloc+0xf1/0x2d0
2016-01-15 02:01:01     [<ffffffff8e2d35eb>] xfs_ialloc+0x5b/0x550
2016-01-15 02:01:01     [<ffffffff8e2df9b7>] ? kmem_zone_alloc+0x77/0x100
2016-01-15 02:01:01     [<ffffffff8e2f1c77>] ? 
xfs_trans_mod_dquot+0x47/0x190
2016-01-15 02:01:01     [<ffffffff8e2d3b4a>] xfs_dir_ialloc+0x6a/0x290
2016-01-15 02:01:01     [<ffffffff8e2d408b>] xfs_create+0x2bb/0x6e0
2016-01-15 02:01:01     [<ffffffff8e00d775>] ? native_sched_clock+0x35/0x80
2016-01-15 02:01:01     [<ffffffff8e21cab1>] ? get_cached_acl+0x21/0x70
2016-01-15 02:01:01     [<ffffffff8e2d09b3>] xfs_generic_create+0xd3/0x2b0
2016-01-15 02:01:01     [<ffffffff8e1dc4ed>] ? __d_lookup+0x11d/0x160
2016-01-15 02:01:01     [<ffffffff8e2d0bc4>] xfs_vn_mknod+0x14/0x20
2016-01-15 02:01:01     [<ffffffff8e2d0c03>] xfs_vn_create+0x13/0x20
2016-01-15 02:01:01     [<ffffffff8e1cf307>] vfs_create+0x77/0xc0
2016-01-15 02:01:01     [<ffffffff8e1d076d>] do_last.isra.57+0x73d/0xd30
2016-01-15 02:01:01     [<ffffffff8e1d1084>] ? path_init+0xc4/0x430
2016-01-15 02:01:01     [<ffffffff8e1d2012>] path_openat+0x92/0x5a0
2016-01-15 02:01:01     [<ffffffff8e1d3f78>] ? user_path_at_empty+0x68/0xa0
2016-01-15 02:01:01     [<ffffffff8e1d4063>] do_filp_open+0x43/0xa0
2016-01-15 02:01:01     [<ffffffff8e1e0f24>] ? __alloc_fd+0x134/0x1b0
2016-01-15 02:01:01     [<ffffffff8e1c2dec>] do_sys_open+0x13c/0x230
2016-01-15 02:01:01     [<ffffffff8e0134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-15 02:01:01     [<ffffffff8e14e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-15 02:01:01     [<ffffffff8e1c2f02>] SyS_open+0x22/0x30
2016-01-15 02:01:01     [<ffffffff8e640bae>] system_call_fastpath+0x12/0x71
2016-01-15 02:01:01     INFO: task php5.4:9657 blocked for more than 120 
seconds.
2016-01-15 02:01:00     INFO: task php5.2:6976 blocked for more than 120 
seconds.
2016-01-15 02:01:00     Not tainted 4.1.15+68-ph #1
2016-01-15 02:01:00     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:01:00     php5.2 D ffff88015bd87568 0 6976 15202 0x00000004
2016-01-15 02:01:00     ffff88015bd87568 ffff8806242c0000 
ffff8801938e0000 ffff8800374ded00
2016-01-15 02:01:00     ffff88015bd88000 7fffffffffffffff 
ffff8801938e0000 0000000000000002
2016-01-15 02:01:00     0000000000000000 ffff88015bd87588 
ffffffff8e63c967 00000000000001ed
2016-01-15 02:01:00     Call Trace:
2016-01-15 02:01:00     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:01:00     [<ffffffff8e63f68c>] schedule_timeout+0x1fc/0x260
2016-01-15 02:01:00     [<ffffffff8e0b873c>] ? dequeue_entity+0x13c/0x580
2016-01-15 02:01:00     [<ffffffff8e63e93e>] __down_common+0xaf/0x118
2016-01-15 02:01:00     [<ffffffff8e0b1700>] ? 
arch_vtime_task_switch+0x40/0x90
2016-01-15 02:01:00     [<ffffffff8e2c1f04>] ? _xfs_buf_find+0x164/0x2a0
2016-01-15 02:01:00     [<ffffffff8e63ea1a>] __down+0x1d/0x1f
2016-01-15 02:01:00     [<ffffffff8e0c9831>] down+0x41/0x50
2016-01-15 02:01:00     [<ffffffff8e2c1d00>] xfs_buf_lock+0x40/0xe0
2016-01-15 02:01:00     [<ffffffff8e2c1f04>] _xfs_buf_find+0x164/0x2a0
2016-01-15 02:01:00     [<ffffffff8e2c20f5>] xfs_buf_get_map+0x35/0x180
2016-01-15 02:01:00     [<ffffffff8e2c2f77>] xfs_buf_read_map+0x37/0x110
2016-01-15 02:01:00     [<ffffffff8e2eef29>] 
xfs_trans_read_buf_map+0xf9/0x280
2016-01-15 02:01:00     [<ffffffff8e2b2985>] xfs_read_agi+0x95/0xf0
2016-01-15 02:00:59     INFO: task kworker/4:1H:6823 blocked for more 
than 120 seconds.
2016-01-15 02:00:59     Not tainted 4.1.15+68-ph #1
2016-01-15 02:00:59     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:00:59     kworker/4:1H D ffff880302813c88 0 6823 2 0x00000000
2016-01-15 02:00:59     Workqueue: xfs-log/sda3 xfs_log_worker
2016-01-15 02:00:59     ffff880302813c88 ffff8806243ed7f0 
ffff8800038b0000 ffff880621729400
2016-01-15 02:00:59     ffff880302814000 ffff8800bb179128 
ffff8800bb179000 0000000000000000
2016-01-15 02:00:59     ffff8800038b0000 ffff880302813ca8 
ffffffff8e63c967 ffff8800038b0000
2016-01-15 02:00:59     Call Trace:
2016-01-15 02:00:59     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:00:59     [<ffffffff8e2e359b>] _xfs_log_force_lsn+0x26b/0x2c0
2016-01-15 02:00:59     [<ffffffff8e0ad340>] ? try_to_wake_up+0x340/0x340
2016-01-15 02:00:59     [<ffffffff8e2df093>] xfs_trans_commit+0x1e3/0x220
2016-01-15 02:00:59     [<ffffffff8e2b8b60>] xfs_sync_sb+0x60/0xa0
2016-01-15 02:00:59     [<ffffffff8e2e1bb4>] ? 
xfs_log_need_covered+0x74/0x100
2016-01-15 02:00:59     [<ffffffff8e2e332d>] xfs_log_worker+0x4d/0x50
2016-01-15 02:00:59     [<ffffffff8e0986bf>] process_one_work+0x14f/0x410
2016-01-15 02:00:59     [<ffffffff8e098ad9>] worker_thread+0x119/0x510
2016-01-15 02:00:59     [<ffffffff8e63c3d1>] ? __schedule+0x4f1/0x990
2016-01-15 02:00:59     [<ffffffff8e0989c0>] ? 
process_scheduled_works+0x40/0x40
2016-01-15 02:00:59     [<ffffffff8e09f1f9>] kthread+0xc9/0xe0
2016-01-15 02:00:59     [<ffffffff8e09f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-15 02:00:59     [<ffffffff8e640fa2>] ret_from_fork+0x42/0x70
2016-01-15 02:00:59     [<ffffffff8e09f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-15 02:00:58     [<ffffffff8e1df3d9>] ? inode_lru_isolate+0x89/0x1c0
2016-01-15 02:00:58     [<ffffffff8e177e58>] ? 
__list_lru_walk_one.isra.6+0x158/0x170
2016-01-15 02:00:58     [<ffffffff8e1df350>] ? 
insert_inode_locked+0x180/0x180
2016-01-15 02:00:58     [<ffffffff8e1df350>] ? 
insert_inode_locked+0x180/0x180
2016-01-15 02:00:58     [<ffffffff8e2cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-15 02:00:58     [<ffffffff8e2da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-15 02:00:58     [<ffffffff8e1c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-15 02:00:58     [<ffffffff8e15fae6>] shrink_slab+0x216/0x3d0
2016-01-15 02:00:58     [<ffffffff8e164379>] shrink_zone+0x2b9/0x2d0
2016-01-15 02:00:58     [<ffffffff8e1646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-15 02:00:58     [<ffffffff8e164b8a>] try_to_free_pages+0xda/0x160
2016-01-15 02:00:58     [<ffffffff8e6364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-15 02:00:58     [<ffffffff8e1581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-15 02:00:58     [<ffffffff8e158235>] 
alloc_kmem_pages_node+0x65/0x130
2016-01-15 02:00:58     [<ffffffff8e07e61b>] ? 
copy_process.part.37+0xeb/0x1a80
2016-01-15 02:00:58     [<ffffffff8e07e639>] 
copy_process.part.37+0x109/0x1a80
2016-01-15 02:00:58     [<ffffffff8e1a7f63>] ? kmem_cache_alloc+0x193/0x1f0
2016-01-15 02:00:58     [<ffffffff8e1190cc>] ? 
acct_account_cputime+0x1c/0x20
2016-01-15 02:00:58     [<ffffffff8e0b0f99>] ? account_user_time+0x99/0xb0
2016-01-15 02:00:58     [<ffffffff8e08014c>] do_fork+0xbc/0x350
2016-01-15 02:00:58     [<ffffffff8e0134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-15 02:00:58     [<ffffffff8e14e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-15 02:00:58     [<ffffffff8e080466>] SyS_clone+0x16/0x20
2016-01-15 02:00:58     [<ffffffff8e640bae>] system_call_fastpath+0x12/0x71
2016-01-15 02:00:57     [<ffffffff8e14e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-15 02:00:57     [<ffffffff8e013805>] ? syscall_trace_leave+0x95/0xf0
2016-01-15 02:00:57     [<ffffffff8e1f4ee0>] SyS_fsync+0x10/0x20
2016-01-15 02:00:57     [<ffffffff8e640bae>] system_call_fastpath+0x12/0x71
2016-01-15 02:00:57     INFO: task auth:9631 blocked for more than 120 
seconds.
2016-01-15 02:00:57     Not tainted 4.1.15+68-ph #1
2016-01-15 02:00:57     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:00:57     auth D ffff8809eea33588 0 9631 9616 0x00000004
2016-01-15 02:00:57     ffff8809eea33588 ffff8806242c1d50 
ffff880b97f19d50 ffff8809eea33568
2016-01-15 02:00:57     ffff8809eea34000 ffff8800bb179128 
ffff8800bb179000 ffff880621729418
2016-01-15 02:00:57     ffff880b97f19d50 ffff8809eea335a8 
ffffffff8e63c967 0002577b00042c00
2016-01-15 02:00:57     Call Trace:
2016-01-15 02:00:57     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:00:57     [<ffffffff8e2e3483>] _xfs_log_force_lsn+0x153/0x2c0
2016-01-15 02:00:57     [<ffffffff8e0ad340>] ? try_to_wake_up+0x340/0x340
2016-01-15 02:00:57     [<ffffffff8e2e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-15 02:00:57     [<ffffffff8e2ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-15 02:00:57     [<ffffffff8e2d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-15 02:00:57     [<ffffffff8e0c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-15 02:00:57     [<ffffffff8e2ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-15 02:00:57     [<ffffffff8e2cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-15 02:00:57     [<ffffffff8e0d8cb6>] ? 
__call_rcu_nocb_enqueue+0xe6/0xf0
2016-01-15 02:00:56     [<ffffffff8e2c62bf>] xfs_file_fsync+0x18f/0x1e0
2016-01-15 02:00:56     [<ffffffff8e1f4a66>] vfs_fsync_range+0x46/0xc0
2016-01-15 02:00:56     [<ffffffff8e1f4afc>] vfs_fsync+0x1c/0x20
2016-01-15 02:00:56     [<ffffffff8e1f4c68>] do_fsync+0x38/0x70
2016-01-15 02:00:56     [<ffffffff8e14e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-15 02:00:56     [<ffffffff8e013805>] ? syscall_trace_leave+0x95/0xf0
2016-01-15 02:00:56     [<ffffffff8e1f4ee0>] SyS_fsync+0x10/0x20
2016-01-15 02:00:56     [<ffffffff8e640bae>] system_call_fastpath+0x12/0x71
2016-01-15 02:00:56     INFO: task mysqld:20600 blocked for more than 
120 seconds.
2016-01-15 02:00:56     Not tainted 4.1.15+68-ph #1
2016-01-15 02:00:56     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:00:56     mysqld D ffff8809218ffd98 0 20600 5893 0x00000000
2016-01-15 02:00:56     ffff8809218ffd98 ffff8806242d8000 
ffff880123ef57f0 0000000000000000
2016-01-15 02:00:56     ffff880921900000 ffff8800bb179128 
ffff8800bb179000 ffff880621729418
2016-01-15 02:00:56     ffff880123ef57f0 ffff8809218ffdb8 
ffffffff8e63c967 0002577b00042c00
2016-01-15 02:00:56     Call Trace:
2016-01-15 02:00:56     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:00:56     [<ffffffff8e2e3483>] _xfs_log_force_lsn+0x153/0x2c0
2016-01-15 02:00:56     [<ffffffff8e0ad340>] ? try_to_wake_up+0x340/0x340
2016-01-15 02:00:56     [<ffffffff8e2c62bf>] xfs_file_fsync+0x18f/0x1e0
2016-01-15 02:00:56     [<ffffffff8e1f4a66>] vfs_fsync_range+0x46/0xc0
2016-01-15 02:00:56     [<ffffffff8e1f4afc>] vfs_fsync+0x1c/0x20
2016-01-15 02:00:56     [<ffffffff8e1f4c68>] do_fsync+0x38/0x70
2016-01-15 02:00:55     [<ffffffff8e1646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-15 02:00:55     [<ffffffff8e164b8a>] try_to_free_pages+0xda/0x160
2016-01-15 02:00:55     [<ffffffff8e6364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-15 02:00:55     [<ffffffff8e1581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-15 02:00:55     [<ffffffff8e158235>] 
alloc_kmem_pages_node+0x65/0x130
2016-01-15 02:00:55     [<ffffffff8e07e61b>] ? 
copy_process.part.37+0xeb/0x1a80
2016-01-15 02:00:55     [<ffffffff8e07e639>] 
copy_process.part.37+0x109/0x1a80
2016-01-15 02:00:55     [<ffffffff8e1190cc>] ? 
acct_account_cputime+0x1c/0x20
2016-01-15 02:00:55     [<ffffffff8e0b0f99>] ? account_user_time+0x99/0xb0
2016-01-15 02:00:55     [<ffffffff8e08014c>] do_fork+0xbc/0x350
2016-01-15 02:00:55     [<ffffffff8e0134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-15 02:00:55     [<ffffffff8e080466>] SyS_clone+0x16/0x20
2016-01-15 02:00:55     [<ffffffff8e640bae>] system_call_fastpath+0x12/0x71
2016-01-15 02:00:55     INFO: task mysqld:7069 blocked for more than 120 
seconds.
2016-01-15 02:00:55     Not tainted 4.1.15+68-ph #1
2016-01-15 02:00:55     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:00:55     mysqld D ffff880f0abbbd98 0 7069 5893 0x00000000
2016-01-15 02:00:55     ffff880f0abbbd98 ffff8806242c0000 
ffff880f0ab53aa0 0000000000000000
2016-01-15 02:00:55     ffff880f0abbc000 ffff8800bb179128 
ffff8800bb179000 ffff880621729418
2016-01-15 02:00:55     ffff880f0ab53aa0 ffff880f0abbbdb8 
ffffffff8e63c967 0002577b00042c00
2016-01-15 02:00:55     Call Trace:
2016-01-15 02:00:55     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:00:55     [<ffffffff8e2e3483>] _xfs_log_force_lsn+0x153/0x2c0
2016-01-15 02:00:55     [<ffffffff8e0ad340>] ? try_to_wake_up+0x340/0x340
2016-01-15 02:00:54     [<ffffffff8e640bae>] system_call_fastpath+0x12/0x71
2016-01-15 02:00:54     INFO: task mysqld:6683 blocked for more than 120 
seconds.
2016-01-15 02:00:54     Not tainted 4.1.15+68-ph #1
2016-01-15 02:00:54     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:00:54     mysqld D ffff880f0b2f3588 0 6683 5893 0x00000000
2016-01-15 02:00:54     ffff880f0b2f3588 ffff8806242dbaa0 
ffff880f09913aa0 000000000000254e
2016-01-15 02:00:54     ffff880f0b2f4000 ffff8800bb179128 
ffff8800bb179000 ffff880621729418
2016-01-15 02:00:54     ffff880f09913aa0 ffff880f0b2f35a8 
ffffffff8e63c967 0002577b00042c00
2016-01-15 02:00:54     Call Trace:
2016-01-15 02:00:54     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:00:54     [<ffffffff8e2e3483>] _xfs_log_force_lsn+0x153/0x2c0
2016-01-15 02:00:54     [<ffffffff8e0ad340>] ? try_to_wake_up+0x340/0x340
2016-01-15 02:00:54     [<ffffffff8e2e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-15 02:00:54     [<ffffffff8e2ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-15 02:00:54     [<ffffffff8e2d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-15 02:00:54     [<ffffffff8e0c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-15 02:00:54     [<ffffffff8e2ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-15 02:00:54     [<ffffffff8e2cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-15 02:00:54     [<ffffffff8e2cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-15 02:00:54     [<ffffffff8e2da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-15 02:00:54     [<ffffffff8e1c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-15 02:00:54     [<ffffffff8e15fae6>] shrink_slab+0x216/0x3d0
2016-01-15 02:00:54     [<ffffffff8e164379>] shrink_zone+0x2b9/0x2d0
2016-01-15 02:00:53     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:00:53     mysqld D ffff88064549bbc8 0 21561 5534 0x00000000
2016-01-15 02:00:53     ffff88064549bbc8 ffff88062426d7f0 
ffff88000b4cbaa0 0000000000000040
2016-01-15 02:00:53     ffff88064549c000 ffff880f1631b674 
ffff88000b4cbaa0 00000000ffffffff
2016-01-15 02:00:53     ffff880f1631b678 ffff88064549bbe8 
ffffffff8e63c967 00000000000282c2
2016-01-15 02:00:53     Call Trace:
2016-01-15 02:00:53     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:00:53     [<ffffffff8e63cbde>] 
schedule_preempt_disabled+0xe/0x10
2016-01-15 02:00:53     [<ffffffff8e63e7e5>] 
__mutex_lock_slowpath+0x95/0x110
2016-01-15 02:00:53     [<ffffffff8e63e87b>] mutex_lock+0x1b/0x2f
2016-01-15 02:00:53     [<ffffffff8e1d028b>] do_last.isra.57+0x25b/0xd30
2016-01-15 02:00:53     [<ffffffff8e1d1084>] ? path_init+0xc4/0x430
2016-01-15 02:00:53     [<ffffffff8e1d2012>] path_openat+0x92/0x5a0
2016-01-15 02:00:53     [<ffffffff8e17d817>] ? handle_mm_fault+0xb47/0x1860
2016-01-15 02:00:53     [<ffffffff8e1d4063>] do_filp_open+0x43/0xa0
2016-01-15 02:00:53     [<ffffffff8e1e0f24>] ? __alloc_fd+0x134/0x1b0
2016-01-15 02:00:53     [<ffffffff8e1c2dec>] do_sys_open+0x13c/0x230
2016-01-15 02:00:53     [<ffffffff8e0134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-15 02:00:53     [<ffffffff8e1c2f02>] SyS_open+0x22/0x30
2016-01-15 02:00:52     [<ffffffff8e0c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-15 02:00:52     [<ffffffff8e2ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-15 02:00:52     [<ffffffff8e2cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-15 02:00:52     [<ffffffff8e2cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-15 02:00:52     [<ffffffff8e2da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-15 02:00:52     [<ffffffff8e1c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-15 02:00:52     [<ffffffff8e15fae6>] shrink_slab+0x216/0x3d0
2016-01-15 02:00:52     [<ffffffff8e164379>] shrink_zone+0x2b9/0x2d0
2016-01-15 02:00:52     [<ffffffff8e165287>] kswapd+0x527/0x980
2016-01-15 02:00:52     [<ffffffff8e164d60>] ? 
mem_cgroup_shrink_node_zone+0x150/0x150
2016-01-15 02:00:52     [<ffffffff8e09f1f9>] kthread+0xc9/0xe0
2016-01-15 02:00:52     [<ffffffff8e09f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-15 02:00:52     [<ffffffff8e640fa2>] ret_from_fork+0x42/0x70
2016-01-15 02:00:52     [<ffffffff8e09f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-15 02:00:52     INFO: task mysqld:21561 blocked for more than 
120 seconds.
2016-01-15 02:00:52     Not tainted 4.1.15+68-ph #1
2016-01-15 02:00:51     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-15 02:00:51     kswapd1 D ffff880622e87848 0 195 2 0x00000000
2016-01-15 02:00:51     ffff880622e87848 ffff8806242d8000 
ffff880622e33aa0 0000000000000000
2016-01-15 02:00:51     ffff880622e88000 ffff8800bb179128 
ffff8800bb179000 ffff880621729418
2016-01-15 02:00:51     ffff880622e33aa0 ffff880622e87868 
ffffffff8e63c967 0002577b00042c00
2016-01-15 02:00:51     Call Trace:
2016-01-15 02:00:51     [<ffffffff8e63c967>] schedule+0x37/0x90
2016-01-15 02:00:51     [<ffffffff8e2e3483>] _xfs_log_force_lsn+0x153/0x2c0
2016-01-15 02:00:51     [<ffffffff8e0ad340>] ? try_to_wake_up+0x340/0x340
2016-01-15 02:00:51     [<ffffffff8e2e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-15 02:00:51     [<ffffffff8e2ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-15 02:00:51     [<ffffffff8e2d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-15 02:00:50     INFO: task kswapd1:195 blocked for more than 120 
seconds.
2016-01-15 02:00:50     Not tainted 4.1.15+68-ph #1

Nr 3:
2016-01-12 03:18:50     [<ffffffffb107e61b>] 
copy_process.part.37+0xeb/0x1a80
2016-01-12 03:18:50     [<ffffffffb11190cc>] ? 
acct_account_cputime+0x1c/0x20
2016-01-12 03:18:50     [<ffffffffb10b0f99>] ? account_user_time+0x99/0xb0
2016-01-12 03:18:50     [<ffffffffb108014c>] do_fork+0xbc/0x350
2016-01-12 03:18:50     [<ffffffffb10134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-12 03:18:50     [<ffffffffb114e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-12 03:18:50     [<ffffffffb1080466>] SyS_clone+0x16/0x20
2016-01-12 03:18:50     [<ffffffffb1640bae>] system_call_fastpath+0x12/0x71
2016-01-12 03:18:49     [<ffffffffb12d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-12 03:18:49     [<ffffffffb10c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-12 03:18:49     [<ffffffffb12ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:49     [<ffffffffb12cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-12 03:18:49     [<ffffffffb12cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-12 03:18:49     [<ffffffffb12da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-12 03:18:49     [<ffffffffb11c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-12 03:18:49     [<ffffffffb115fae6>] shrink_slab+0x216/0x3d0
2016-01-12 03:18:49     [<ffffffffb1164379>] shrink_zone+0x2b9/0x2d0
2016-01-12 03:18:49     [<ffffffffb11646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-12 03:18:49     [<ffffffffb1164b8a>] try_to_free_pages+0xda/0x160
2016-01-12 03:18:49     [<ffffffffb16364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-12 03:18:49     [<ffffffffb11581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-12 03:18:49     [<ffffffffb119cc1c>] alloc_pages_current+0x9c/0x110
2016-01-12 03:18:49     [<ffffffffb11a59db>] new_slab+0x32b/0x450
2016-01-12 03:18:49     [<ffffffffb1637ef8>] __slab_alloc+0x2de/0x433
2016-01-12 03:18:49     [<ffffffffb107e61b>] ? 
copy_process.part.37+0xeb/0x1a80
2016-01-12 03:18:49     [<ffffffffb104dca7>] ? do_page_fault+0x37/0x90
2016-01-12 03:18:49     [<ffffffffb11a794a>] 
kmem_cache_alloc_node+0x8a/0x240
2016-01-12 03:18:48     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:48     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:48     sshd D ffff880859e6f198 0 6171 1 0x00000000
2016-01-12 03:18:48     ffff880859e6f198 ffff88085c2e1d50 
ffff880855d53aa0 ffff880859e6f248
2016-01-12 03:18:48     ffff880859e70000 ffff880859e6f300 
7fffffffffffffff ffff880855d53aa0
2016-01-12 03:18:48     ffffffffffffffff ffff880859e6f1b8 
ffffffffb163c967 ffff880859e6f298
2016-01-12 03:18:48     Call Trace:
2016-01-12 03:18:48     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:48     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:48     [<ffffffffb13506e5>] ? cfq_set_request+0xa5/0x4c0
2016-01-12 03:18:48     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:48     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:48     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:48     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:48     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:48     [<ffffffffb12e3388>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-12 03:18:48     [<ffffffffb12b4bd7>] ? 
xfs_iext_bno_to_ext+0x97/0x170
2016-01-12 03:18:48     [<ffffffffb12e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-12 03:18:48     [<ffffffffb12ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:47     [<ffffffffb115fae6>] shrink_slab+0x216/0x3d0
2016-01-12 03:18:47     [<ffffffffb1164379>] shrink_zone+0x2b9/0x2d0
2016-01-12 03:18:47     [<ffffffffb11646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-12 03:18:47     [<ffffffffb1164b8a>] try_to_free_pages+0xda/0x160
2016-01-12 03:18:47     [<ffffffffb16364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-12 03:18:47     [<ffffffffb11581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-12 03:18:47     [<ffffffffb1158235>] 
alloc_kmem_pages_node+0x65/0x130
2016-01-12 03:18:47     [<ffffffffb107e61b>] ? 
copy_process.part.37+0xeb/0x1a80
2016-01-12 03:18:47     [<ffffffffb107e639>] 
copy_process.part.37+0x109/0x1a80
2016-01-12 03:18:47     [<ffffffffb11117a2>] ? make_kgid+0x12/0x20
2016-01-12 03:18:47     [<ffffffffb11190cc>] ? 
acct_account_cputime+0x1c/0x20
2016-01-12 03:18:47     [<ffffffffb10b0f99>] ? account_user_time+0x99/0xb0
2016-01-12 03:18:47     [<ffffffffb108014c>] do_fork+0xbc/0x350
2016-01-12 03:18:47     [<ffffffffb10134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-12 03:18:47     [<ffffffffb114e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-12 03:18:47     [<ffffffffb108044c>] sys_vfork+0x1c/0x20
2016-01-12 03:18:47     [<ffffffffb1640bae>] system_call_fastpath+0x12/0x71
2016-01-12 03:18:47     INFO: task sshd:6171 blocked for more than 120 
seconds.
2016-01-12 03:18:46     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:46     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:46     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:46     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:46     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:46     [<ffffffffb11520da>] ? mempool_alloc+0x5a/0x150
2016-01-12 03:18:46     [<ffffffffc02346be>] ? 
MR_BuildRaidContext+0x2fe/0x6d0 [megaraid_sas]
2016-01-12 03:18:46     [<ffffffffb12e3388>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-12 03:18:46     [<ffffffffb12b4bd7>] ? 
xfs_iext_bno_to_ext+0x97/0x170
2016-01-12 03:18:46     [<ffffffffb12e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-12 03:18:46     [<ffffffffb12ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:46     [<ffffffffb12d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-12 03:18:46     [<ffffffffb10c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-12 03:18:46     [<ffffffffb12ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:46     [<ffffffffb12cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-12 03:18:46     [<ffffffffb12cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-12 03:18:46     [<ffffffffb12da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-12 03:18:46     [<ffffffffb11c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-12 03:18:45     [<ffffffffb11117a2>] ? make_kgid+0x12/0x20
2016-01-12 03:18:45     [<ffffffffb11190cc>] ? 
acct_account_cputime+0x1c/0x20
2016-01-12 03:18:45     [<ffffffffb10b0f99>] ? account_user_time+0x99/0xb0
2016-01-12 03:18:45     [<ffffffffb108014c>] do_fork+0xbc/0x350
2016-01-12 03:18:45     [<ffffffffb10134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-12 03:18:45     [<ffffffffb1080466>] SyS_clone+0x16/0x20
2016-01-12 03:18:45     [<ffffffffb1640bae>] system_call_fastpath+0x12/0x71
2016-01-12 03:18:45     INFO: task qmail-rspawn:6145 blocked for more 
than 120 seconds.
2016-01-12 03:18:45     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:45     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:45     qmail-rspawn D ffff88085af93348 0 6145 6125 
0x00000002
2016-01-12 03:18:45     ffff88085af93348 ffff88085c300000 
ffff8808554c9d50 0000000000000000
2016-01-12 03:18:45     ffff88085af94000 ffff88085af934b0 
7fffffffffffffff ffff8808554c9d50
2016-01-12 03:18:45     ffffffffffffffff ffff88085af93368 
ffffffffb163c967 ffff88085af933e8
2016-01-12 03:18:45     Call Trace:
2016-01-12 03:18:45     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:45     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:45     [<ffffffffb1637af4>] ? 
get_partial_node.isra.64+0x1bf/0x1dc
2016-01-12 03:18:44     [<ffffffffb12b4bd7>] ? 
xfs_iext_bno_to_ext+0x97/0x170
2016-01-12 03:18:44     [<ffffffffb12e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-12 03:18:44     [<ffffffffb12ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:44     [<ffffffffb12d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-12 03:18:44     [<ffffffffb10c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-12 03:18:44     [<ffffffffb12ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:44     [<ffffffffb12cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-12 03:18:44     [<ffffffffb12cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-12 03:18:44     [<ffffffffb12da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-12 03:18:44     [<ffffffffb11c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-12 03:18:44     [<ffffffffb115fae6>] shrink_slab+0x216/0x3d0
2016-01-12 03:18:44     [<ffffffffb1164379>] shrink_zone+0x2b9/0x2d0
2016-01-12 03:18:44     [<ffffffffb11646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-12 03:18:44     [<ffffffffb1164b8a>] try_to_free_pages+0xda/0x160
2016-01-12 03:18:44     [<ffffffffb16364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-12 03:18:44     [<ffffffffb11581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-12 03:18:44     [<ffffffffb1158235>] 
alloc_kmem_pages_node+0x65/0x130
2016-01-12 03:18:44     [<ffffffffb107e61b>] ? 
copy_process.part.37+0xeb/0x1a80
2016-01-12 03:18:44     [<ffffffffb107e639>] 
copy_process.part.37+0x109/0x1a80
2016-01-12 03:18:43     [<ffffffffb1640bae>] system_call_fastpath+0x12/0x71
2016-01-12 03:18:43     INFO: task zabbix_agentd:6130 blocked for more 
than 120 seconds.
2016-01-12 03:18:43     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:43     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:43     zabbix_agentd D ffff881053bc7348 0 6130 6118 
0x00000004
2016-01-12 03:18:43     ffff881053bc7348 ffff88085c300000 
ffff88105a4d9d50 ffff881053bc73d8
2016-01-12 03:18:43     ffff881053bc8000 ffff881053bc74b0 
7fffffffffffffff ffff88105a4d9d50
2016-01-12 03:18:43     ffffffffffffffff ffff881053bc7368 
ffffffffb163c967 ffff881053bc7368
2016-01-12 03:18:43     Call Trace:
2016-01-12 03:18:43     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:43     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:43     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:43     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:43     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:43     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:43     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:43     [<ffffffffb1156957>] ? __free_pages+0x27/0x30
2016-01-12 03:18:43     [<ffffffffb12e3388>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-12 03:18:42     [<ffffffffb12da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-12 03:18:42     [<ffffffffb11c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-12 03:18:42     [<ffffffffb115fae6>] shrink_slab+0x216/0x3d0
2016-01-12 03:18:42     [<ffffffffb1164379>] shrink_zone+0x2b9/0x2d0
2016-01-12 03:18:42     [<ffffffffb11646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-12 03:18:42     [<ffffffffb1164b8a>] try_to_free_pages+0xda/0x160
2016-01-12 03:18:42     [<ffffffffb16364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-12 03:18:42     [<ffffffffb11581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-12 03:18:42     [<ffffffffb1158235>] 
alloc_kmem_pages_node+0x65/0x130
2016-01-12 03:18:42     [<ffffffffb107e61b>] ? 
copy_process.part.37+0xeb/0x1a80
2016-01-12 03:18:42     [<ffffffffb107e639>] 
copy_process.part.37+0x109/0x1a80
2016-01-12 03:18:42     [<ffffffffb11117a2>] ? make_kgid+0x12/0x20
2016-01-12 03:18:42     [<ffffffffb11190cc>] ? 
acct_account_cputime+0x1c/0x20
2016-01-12 03:18:42     [<ffffffffb10b0f99>] ? account_user_time+0x99/0xb0
2016-01-12 03:18:42     [<ffffffffb108014c>] do_fork+0xbc/0x350
2016-01-12 03:18:42     [<ffffffffb10134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-12 03:18:42     [<ffffffffb114e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-12 03:18:42     [<ffffffffb1080466>] SyS_clone+0x16/0x20
2016-01-12 03:18:41     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:41     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:41     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:41     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:41     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:41     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:41     [<ffffffffb11520da>] ? mempool_alloc+0x5a/0x150
2016-01-12 03:18:41     [<ffffffffc02346be>] ? 
MR_BuildRaidContext+0x2fe/0x6d0 [megaraid_sas]
2016-01-12 03:18:41     [<ffffffffb1326f7c>] ? part_round_stats+0x5c/0x70
2016-01-12 03:18:41     [<ffffffffb12e3388>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-12 03:18:41     [<ffffffffb12b4bd7>] ? 
xfs_iext_bno_to_ext+0x97/0x170
2016-01-12 03:18:41     [<ffffffffb12e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-12 03:18:41     [<ffffffffb12ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:41     [<ffffffffb12d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-12 03:18:41     [<ffffffffb10c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-12 03:18:41     [<ffffffffb12ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:41     [<ffffffffb12cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-12 03:18:41     [<ffffffffb12cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-12 03:18:40     [<ffffffffb107e61b>] ? 
copy_process.part.37+0xeb/0x1a80
2016-01-12 03:18:40     [<ffffffffb107e639>] 
copy_process.part.37+0x109/0x1a80
2016-01-12 03:18:40     [<ffffffffb11117a2>] ? make_kgid+0x12/0x20
2016-01-12 03:18:40     [<ffffffffb11190cc>] ? 
acct_account_cputime+0x1c/0x20
2016-01-12 03:18:40     [<ffffffffb10b0f99>] ? account_user_time+0x99/0xb0
2016-01-12 03:18:40     [<ffffffffb108014c>] do_fork+0xbc/0x350
2016-01-12 03:18:40     [<ffffffffb10134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-12 03:18:40     [<ffffffffb114e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-12 03:18:40     [<ffffffffb1080466>] SyS_clone+0x16/0x20
2016-01-12 03:18:40     [<ffffffffb1640bae>] system_call_fastpath+0x12/0x71
2016-01-12 03:18:40     INFO: task zabbix_agentd:6129 blocked for more 
than 120 seconds.
2016-01-12 03:18:40     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:40     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:40     zabbix_agentd D ffff881053bd7348 0 6129 6118 
0x00000006
2016-01-12 03:18:40     ffff881053bd7348 ffff88085c2e1d50 
ffff88105340d7f0 ffffea0017e65180
2016-01-12 03:18:40     ffff881053bd8000 ffff881053bd74b0 
7fffffffffffffff ffff88105340d7f0
2016-01-12 03:18:40     ffffffffffffffff ffff881053bd7368 
ffffffffb163c967 ffff88085fa59650
2016-01-12 03:18:40     Call Trace:
2016-01-12 03:18:40     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:39     [<ffffffffb12e3388>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-12 03:18:39     [<ffffffffb12b4bd7>] ? 
xfs_iext_bno_to_ext+0x97/0x170
2016-01-12 03:18:39     [<ffffffffb12e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-12 03:18:39     [<ffffffffb12ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:39     [<ffffffffb12d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-12 03:18:39     [<ffffffffb10c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-12 03:18:39     [<ffffffffb12ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:39     [<ffffffffb12cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-12 03:18:39     [<ffffffffb12cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-12 03:18:39     [<ffffffffb12da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-12 03:18:39     [<ffffffffb11c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-12 03:18:39     [<ffffffffb115fae6>] shrink_slab+0x216/0x3d0
2016-01-12 03:18:39     [<ffffffffb1164379>] shrink_zone+0x2b9/0x2d0
2016-01-12 03:18:39     [<ffffffffb11646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-12 03:18:39     [<ffffffffb1164b8a>] try_to_free_pages+0xda/0x160
2016-01-12 03:18:39     [<ffffffffb16364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-12 03:18:39     [<ffffffffb11581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-12 03:18:39     [<ffffffffb1158235>] 
alloc_kmem_pages_node+0x65/0x130
2016-01-12 03:18:38     INFO: task zabbix_agentd:6128 blocked for more 
than 120 seconds.
2016-01-12 03:18:38     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:38     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:38     zabbix_agentd D ffff88105341f348 0 6128 6118 
0x00000004
2016-01-12 03:18:38     ffff88105341f348 ffff88085c2e57f0 
ffff880858739d50 ffffea00009e2100
2016-01-12 03:18:38     ffff881053420000 ffff88105341f4b0 
7fffffffffffffff ffff880858739d50
2016-01-12 03:18:38     ffffffffffffffff ffff88105341f368 
ffffffffb163c967 ffff88085fad9650
2016-01-12 03:18:38     Call Trace:
2016-01-12 03:18:38     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:38     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:38     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:38     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:38     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:38     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:38     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:38     [<ffffffffb11520da>] ? mempool_alloc+0x5a/0x150
2016-01-12 03:18:38     [<ffffffffc02346be>] ? 
MR_BuildRaidContext+0x2fe/0x6d0 [megaraid_sas]
2016-01-12 03:18:38     [<ffffffffb1156957>] ? __free_pages+0x27/0x30
2016-01-12 03:18:38     [<ffffffffb11a659c>] ? __free_slab+0xcc/0x1c0
2016-01-12 03:18:37     [<ffffffffb119cc1c>] alloc_pages_current+0x9c/0x110
2016-01-12 03:18:37     [<ffffffffb11a59db>] new_slab+0x32b/0x450
2016-01-12 03:18:37     [<ffffffffb1637ef8>] __slab_alloc+0x2de/0x433
2016-01-12 03:18:37     [<ffffffffb14d4b8d>] ? sock_alloc_inode+0x1d/0xc0
2016-01-12 03:18:37     [<ffffffffb10a98b6>] ? 
ttwu_do_activate.constprop.91+0x66/0x70
2016-01-12 03:18:37     [<ffffffffb11d6f71>] ? set_fd_set+0x21/0x30
2016-01-12 03:18:37     [<ffffffffb11d7f42>] ? core_sys_select+0x242/0x2f0
2016-01-12 03:18:37     [<ffffffffb11a7f63>] kmem_cache_alloc+0x193/0x1f0
2016-01-12 03:18:37     [<ffffffffb14d4b8d>] sock_alloc_inode+0x1d/0xc0
2016-01-12 03:18:37     [<ffffffffb11ddab6>] alloc_inode+0x26/0xa0
2016-01-12 03:18:37     [<ffffffffb11df84a>] new_inode_pseudo+0x1a/0x70
2016-01-12 03:18:37     [<ffffffffb14d4e0e>] sock_alloc+0x1e/0x80
2016-01-12 03:18:37     [<ffffffffb14d69ac>] SYSC_accept4+0x7c/0x210
2016-01-12 03:18:37     [<ffffffffb10b159d>] ? vtime_account_user+0x5d/0x70
2016-01-12 03:18:37     [<ffffffffb114e243>] ? 
context_tracking_user_exit+0x13/0x20
2016-01-12 03:18:37     [<ffffffffb10134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-12 03:18:37     [<ffffffffb114e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-12 03:18:37     [<ffffffffb14d8240>] SyS_accept+0x10/0x20
2016-01-12 03:18:37     [<ffffffffb1640bae>] system_call_fastpath+0x12/0x71
2016-01-12 03:18:36     [<ffffffffb1156957>] ? __free_pages+0x27/0x30
2016-01-12 03:18:36     [<ffffffffb12e3388>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-12 03:18:36     [<ffffffffb12b4bd7>] ? 
xfs_iext_bno_to_ext+0x97/0x170
2016-01-12 03:18:36     [<ffffffffb12e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-12 03:18:36     [<ffffffffb12ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:36     [<ffffffffb12d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-12 03:18:36     [<ffffffffb10c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-12 03:18:36     [<ffffffffb12ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:36     [<ffffffffb12cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-12 03:18:36     [<ffffffffb12cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-12 03:18:36     [<ffffffffb12da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-12 03:18:36     [<ffffffffb11c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-12 03:18:36     [<ffffffffb115fae6>] shrink_slab+0x216/0x3d0
2016-01-12 03:18:36     [<ffffffffb1164379>] shrink_zone+0x2b9/0x2d0
2016-01-12 03:18:36     [<ffffffffb11646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-12 03:18:36     [<ffffffffb1164b8a>] try_to_free_pages+0xda/0x160
2016-01-12 03:18:36     [<ffffffffb16364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-12 03:18:36     [<ffffffffb11d7220>] ? __pollwait+0xf0/0xf0
2016-01-12 03:18:36     [<ffffffffb11581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-12 03:18:35     [<ffffffffb1080466>] SyS_clone+0x16/0x20
2016-01-12 03:18:35     [<ffffffffb1640bae>] system_call_fastpath+0x12/0x71
2016-01-12 03:18:35     INFO: task nrpe:6076 blocked for more than 120 
seconds.
2016-01-12 03:18:35     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:35     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:35     nrpe D ffff880853e6b1a8 0 6076 1 0x00000002
2016-01-12 03:18:35     ffff880853e6b1a8 ffffffffb1c134a0 
ffff8808554e57f0 ffff88105f5d6240
2016-01-12 03:18:35     ffff880853e6c000 ffff880853e6b310 
7fffffffffffffff ffff8808554e57f0
2016-01-12 03:18:35     ffffffffffffffff ffff880853e6b1c8 
ffffffffb163c967 0000000000000003
2016-01-12 03:18:35     Call Trace:
2016-01-12 03:18:35     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:35     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:35     [<ffffffffb1637af4>] ? 
get_partial_node.isra.64+0x1bf/0x1dc
2016-01-12 03:18:35     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:35     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:35     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:35     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:35     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:34     [<ffffffffb12cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-12 03:18:34     [<ffffffffb12cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-12 03:18:34     [<ffffffffb12da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-12 03:18:34     [<ffffffffb11c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-12 03:18:34     [<ffffffffb115fae6>] shrink_slab+0x216/0x3d0
2016-01-12 03:18:34     [<ffffffffb1164379>] shrink_zone+0x2b9/0x2d0
2016-01-12 03:18:34     [<ffffffffb11646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-12 03:18:34     [<ffffffffb1164b8a>] try_to_free_pages+0xda/0x160
2016-01-12 03:18:34     [<ffffffffb16364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-12 03:18:34     [<ffffffffb11581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-12 03:18:34     [<ffffffffb1158235>] 
alloc_kmem_pages_node+0x65/0x130
2016-01-12 03:18:34     [<ffffffffb107e61b>] ? 
copy_process.part.37+0xeb/0x1a80
2016-01-12 03:18:34     [<ffffffffb107e639>] 
copy_process.part.37+0x109/0x1a80
2016-01-12 03:18:34     [<ffffffffb11c8910>] ? cp_new_stat+0x140/0x160
2016-01-12 03:18:34     [<ffffffffb11190cc>] ? 
acct_account_cputime+0x1c/0x20
2016-01-12 03:18:34     [<ffffffffb10b0f99>] ? account_user_time+0x99/0xb0
2016-01-12 03:18:34     [<ffffffffb108014c>] do_fork+0xbc/0x350
2016-01-12 03:18:34     [<ffffffffb10134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-12 03:18:33     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:33     [<ffffffffb13506e5>] ? cfq_set_request+0xa5/0x4c0
2016-01-12 03:18:33     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:33     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:33     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:33     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:33     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:33     [<ffffffffb11520da>] ? mempool_alloc+0x5a/0x150
2016-01-12 03:18:33     [<ffffffffc02346be>] ? 
MR_BuildRaidContext+0x2fe/0x6d0 [megaraid_sas]
2016-01-12 03:18:33     [<ffffffffb132cb37>] ? 
blk_attempt_plug_merge+0xd7/0xf0
2016-01-12 03:18:33     [<ffffffffb12e3388>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-12 03:18:33     [<ffffffffb14722b0>] ? 
scsi_prep_state_check.isra.22+0x80/0x80
2016-01-12 03:18:33     [<ffffffffb12e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-12 03:18:33     [<ffffffffb12ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:33     [<ffffffffb12d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-12 03:18:33     [<ffffffffb10c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-12 03:18:33     [<ffffffffb12ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:32     [<ffffffffb12e3388>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-12 03:18:32     [<ffffffffb12c62bf>] xfs_file_fsync+0x18f/0x1e0
2016-01-12 03:18:32     [<ffffffffb11f4a66>] vfs_fsync_range+0x46/0xc0
2016-01-12 03:18:32     [<ffffffffb11f4afc>] vfs_fsync+0x1c/0x20
2016-01-12 03:18:32     [<ffffffffb11f4c68>] do_fsync+0x38/0x70
2016-01-12 03:18:32     [<ffffffffb114e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-12 03:18:32     [<ffffffffb1013805>] ? syscall_trace_leave+0x95/0xf0
2016-01-12 03:18:32     [<ffffffffb11f4ee0>] SyS_fsync+0x10/0x20
2016-01-12 03:18:32     [<ffffffffb1640bae>] system_call_fastpath+0x12/0x71
2016-01-12 03:18:32     INFO: task cron:6006 blocked for more than 120 
seconds.
2016-01-12 03:18:32     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:32     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:32     cron D ffff881053b57348 0 6006 1 0x00000000
2016-01-12 03:18:32     ffff881053b57348 ffff880858738000 
ffff88105a8057f0 ffff8810595db080
2016-01-12 03:18:32     ffff881053b58000 ffff881053b574b0 
7fffffffffffffff ffff88105a8057f0
2016-01-12 03:18:32     ffffffffffffffff ffff881053b57368 
ffffffffb163c967 ffff880000055000
2016-01-12 03:18:32     Call Trace:
2016-01-12 03:18:32     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:31     [<ffffffffb1640bae>] system_call_fastpath+0x12/0x71
2016-01-12 03:18:31     INFO: task mysqld:6762 blocked for more than 120 
seconds.
2016-01-12 03:18:31     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:31     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:31     mysqld D ffff880843887b58 0 6762 5590 0x00000000
2016-01-12 03:18:31     ffff880843887b58 ffff88085c301d50 
ffff88084385baa0 ffff880572ac09d0
2016-01-12 03:18:31     ffff880843888000 ffff880843887cc0 
7fffffffffffffff ffff88084385baa0
2016-01-12 03:18:31     ffffffffffffffff ffff880843887b78 
ffffffffb163c967 0000000000000100
2016-01-12 03:18:31     Call Trace:
2016-01-12 03:18:31     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:31     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:31     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:31     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:31     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:31     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:31     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:31     [<ffffffffb12bb940>] ? 
xfs_submit_ioend_bio.isra.14+0x40/0x40
2016-01-12 03:18:31     [<ffffffffb1639f03>] ? 
xfs_file_dio_aio_write+0x2a4/0x2f8
2016-01-12 03:18:30     [<ffffffffb1164379>] shrink_zone+0x2b9/0x2d0
2016-01-12 03:18:30     [<ffffffffb11646ea>] 
do_try_to_free_pages+0x16a/0x400
2016-01-12 03:18:30     [<ffffffffb100268b>] ? __switch_to+0x1eb/0x590
2016-01-12 03:18:30     [<ffffffffb1164b8a>] try_to_free_pages+0xda/0x160
2016-01-12 03:18:30     [<ffffffffb16364eb>] 
__alloc_pages_slowpath+0x3ff/0x697
2016-01-12 03:18:30     [<ffffffffb11581c0>] 
__alloc_pages_nodemask+0x230/0x240
2016-01-12 03:18:30     [<ffffffffb119cc1c>] alloc_pages_current+0x9c/0x110
2016-01-12 03:18:30     [<ffffffffb11a59db>] new_slab+0x32b/0x450
2016-01-12 03:18:30     [<ffffffffb1637ef8>] __slab_alloc+0x2de/0x433
2016-01-12 03:18:30     [<ffffffffb107e61b>] ? 
copy_process.part.37+0xeb/0x1a80
2016-01-12 03:18:30     [<ffffffffb11a794a>] 
kmem_cache_alloc_node+0x8a/0x240
2016-01-12 03:18:30     [<ffffffffb107e61b>] 
copy_process.part.37+0xeb/0x1a80
2016-01-12 03:18:30     [<ffffffffb11117a2>] ? make_kgid+0x12/0x20
2016-01-12 03:18:30     [<ffffffffb11dd9f3>] ? inode_init_always+0xe3/0x180
2016-01-12 03:18:30     [<ffffffffb108014c>] do_fork+0xbc/0x350
2016-01-12 03:18:30     [<ffffffffb10134b8>] ? 
syscall_trace_enter_phase1+0xf8/0x160
2016-01-12 03:18:30     [<ffffffffb114e223>] ? 
context_tracking_user_enter+0x13/0x20
2016-01-12 03:18:30     [<ffffffffb1080466>] SyS_clone+0x16/0x20
2016-01-12 03:18:29     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:29     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:29     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:29     [<ffffffffb11520da>] ? mempool_alloc+0x5a/0x150
2016-01-12 03:18:29     [<ffffffffc02346be>] ? 
MR_BuildRaidContext+0x2fe/0x6d0 [megaraid_sas]
2016-01-12 03:18:29     [<ffffffffb132cb37>] ? 
blk_attempt_plug_merge+0xd7/0xf0
2016-01-12 03:18:29     [<ffffffffb12e3388>] _xfs_log_force_lsn+0x58/0x2c0
2016-01-12 03:18:29     [<ffffffffb12b4bd7>] ? 
xfs_iext_bno_to_ext+0x97/0x170
2016-01-12 03:18:29     [<ffffffffb12e362b>] xfs_log_force_lsn+0x3b/0xa0
2016-01-12 03:18:29     [<ffffffffb12ca660>] ? xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:29     [<ffffffffb12d59ae>] xfs_iunpin_wait+0xae/0x140
2016-01-12 03:18:29     [<ffffffffb10c2bc0>] ? 
wake_atomic_t_function+0x40/0x40
2016-01-12 03:18:29     [<ffffffffb12ca660>] xfs_reclaim_inode+0xd0/0x330
2016-01-12 03:18:29     [<ffffffffb12cab37>] 
xfs_reclaim_inodes_ag+0x277/0x3d0
2016-01-12 03:18:29     [<ffffffffb12cb6c3>] xfs_reclaim_inodes_nr+0x33/0x40
2016-01-12 03:18:29     [<ffffffffb12da1b9>] 
xfs_fs_free_cached_objects+0x19/0x20
2016-01-12 03:18:29     [<ffffffffb11c7323>] super_cache_scan+0x1a3/0x1b0
2016-01-12 03:18:29     [<ffffffffb115fae6>] shrink_slab+0x216/0x3d0
2016-01-12 03:18:28     [<ffffffffb109f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-12 03:18:28     INFO: task proftpd:5592 blocked for more than 
120 seconds.
2016-01-12 03:18:28     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:28     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:28     proftpd D ffff88105487b198 0 5592 1 0x00000006
2016-01-12 03:18:28     ffff88105487b198 ffffffffb1c134a0 
ffff8808587b9d50 ffff88105487b1d8
2016-01-12 03:18:28     ffff88105487c000 ffff88105487b300 
7fffffffffffffff ffff8808587b9d50
2016-01-12 03:18:28     ffffffffffffffff ffff88105487b1b8 
ffffffffb163c967 ffff88105b9881d8
2016-01-12 03:18:28     Call Trace:
2016-01-12 03:18:28     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:28     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:28     [<ffffffffb1637af4>] ? 
get_partial_node.isra.64+0x1bf/0x1dc
2016-01-12 03:18:28     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:28     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:27     [<ffffffffb12b6c79>] ? xfs_imap_to_bp+0xc9/0xe0
2016-01-12 03:18:27     [<ffffffffb12e327a>] xfs_log_force+0x2a/0x90
2016-01-12 03:18:27     [<ffffffffb12d68c2>] xfs_iflush+0x202/0x210
2016-01-12 03:18:27     [<ffffffffb10c9872>] ? up+0x32/0x50
2016-01-12 03:18:27     [<ffffffffb12e723a>] xfs_inode_item_push+0xda/0x140
2016-01-12 03:18:27     [<ffffffffb12edbb0>] ? 
xfs_trans_ail_cursor_first+0x90/0x90
2016-01-12 03:18:27     [<ffffffffb12ede7e>] xfsaild+0x2ce/0x5f0
2016-01-12 03:18:27     [<ffffffffb163c3d1>] ? __schedule+0x4f1/0x990
2016-01-12 03:18:27     [<ffffffffb12edbb0>] ? 
xfs_trans_ail_cursor_first+0x90/0x90
2016-01-12 03:18:27     [<ffffffffb109f1f9>] kthread+0xc9/0xe0
2016-01-12 03:18:27     [<ffffffffb109f130>] ? 
kthread_create_on_node+0x1a0/0x1a0
2016-01-12 03:18:27     [<ffffffffb1640fa2>] ret_from_fork+0x42/0x70
2016-01-12 03:18:26     [<ffffffffb10ad197>] ? try_to_wake_up+0x197/0x340
2016-01-12 03:18:26     [<ffffffffb163d4af>] wait_for_completion+0x9f/0x170
2016-01-12 03:18:26     [<ffffffffb10ad395>] ? wake_up_process+0x15/0x20
2016-01-12 03:18:26     [<ffffffffb10ad340>] ? try_to_wake_up+0x340/0x340
2016-01-12 03:18:26     [<ffffffffb1099b7f>] flush_work+0xff/0x1d0
2016-01-12 03:18:26     [<ffffffffb1095e70>] ? 
worker_detach_from_pool+0xd0/0xd0
2016-01-12 03:18:26     [<ffffffffb12e4c8e>] xlog_cil_force_lsn+0x7e/0x200
2016-01-12 03:18:26     [<ffffffffb12c2f77>] ? xfs_buf_read_map+0x37/0x110
2016-01-12 03:18:26     [<ffffffffb12e303b>] _xfs_log_force+0x6b/0x280
2016-01-12 03:18:25     ffff8810566e7a28 ffff88085c31d7f0 
ffff880859430000 000000000000137e
2016-01-12 03:18:25     ffff8810566e8000 ffff8810566e7b90 
7fffffffffffffff ffff880859430000
2016-01-12 03:18:25     ffffffffffffffff ffff8810566e7a48 
ffffffffb163c967 ffff88105b988060
2016-01-12 03:18:25     Call Trace:
2016-01-12 03:18:25     [<ffffffffb163c967>] schedule+0x37/0x90
2016-01-12 03:18:25     [<ffffffffb163f68c>] schedule_timeout+0x1fc/0x260
2016-01-12 03:18:25     [<ffffffffb100d7c9>] ? sched_clock+0x9/0x10
2016-01-12 03:18:25     [<ffffffffb10b0ae5>] ? sched_clock_cpu+0x85/0xc0
2016-01-12 03:18:24     INFO: task xfsaild/sda3:730 blocked for more 
than 120 seconds.
2016-01-12 03:18:24     Not tainted 4.1.15+68-ph #1
2016-01-12 03:18:24     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2016-01-12 03:18:24     xfsaild/sda3 D ffff8810566e7a28 0 730 2 0x00000000



I can give you many more if they may help.


Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
