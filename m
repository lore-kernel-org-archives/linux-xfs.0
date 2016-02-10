Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C31CF7CA2
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 04:53:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4276304051
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 02:53:25 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id on4HP2nBxhwCw0id (version=TLSv1
	cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 02:53:22 -0800 (PST)
Received: from fsav104.sakura.ne.jp (fsav104.sakura.ne.jp [27.133.134.231])
	by www262.sakura.ne.jp (8.14.5/8.14.5) with ESMTP id u1AArKVv066746
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 19:53:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from AQUA (softbank126072091035.bbtec.net [126.72.91.35])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.14.5/8.14.5) with ESMTP id u1AArK7H066743
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 19:53:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: xfs_nondir_ilock_class lockdep warning
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201602101953.HEB13075.HFLOOFQVStOJFM@I-love.SAKURA.ne.jp>
Date: Wed, 10 Feb 2016 19:53:21 +0900
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello.

I'm getting xfs_nondir_ilock_class lockdep warning.
I reported this because google hits little.
Please reply if this is not a known false positive.

[   68.427630] 
[   68.430639] =================================
[   68.432328] [ INFO: inconsistent lock state ]
[   68.433981] 4.5.0-rc3-next-20160209+ #297 Not tainted
[   68.435768] ---------------------------------
[   68.437417] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
[   68.439481] a.out/3934 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   68.441284]  (&xfs_nondir_ilock_class){++++?-}, at: [<ffffffff812c166f>] xfs_ilock+0x7f/0xe0
[   68.443947] {IN-RECLAIM_FS-W} state was registered at:
[   68.445770]   [<ffffffff810be971>] __lock_acquire+0x391/0x1f70
[   68.447749]   [<ffffffff810c0dfd>] lock_acquire+0x6d/0x90
[   68.449684]   [<ffffffff810ba665>] down_write_nested+0x45/0x80
[   68.451661]   [<ffffffff812c166f>] xfs_ilock+0x7f/0xe0
[   68.453526]   [<ffffffff812b9a4d>] xfs_reclaim_inode+0x12d/0x350
[   68.455551]   [<ffffffff812b9f3a>] xfs_reclaim_inodes_ag+0x2ca/0x4f0
[   68.457615]   [<ffffffff812bac7e>] xfs_reclaim_inodes_nr+0x2e/0x40
[   68.460051]   [<ffffffff812c9744>] xfs_fs_free_cached_objects+0x14/0x20
[   68.462163]   [<ffffffff811c7b6c>] super_cache_scan+0x17c/0x190
[   68.464179]   [<ffffffff8115379b>] shrink_slab.part.41+0x1db/0x2a0
[   68.466202]   [<ffffffff81156efd>] shrink_zone+0x2dd/0x2f0
[   68.468102]   [<ffffffff81157c3c>] kswapd+0x4cc/0x920
[   68.469894]   [<ffffffff81090989>] kthread+0xf9/0x110
[   68.471656]   [<ffffffff817074f2>] ret_from_fork+0x22/0x50
[   68.473465] irq event stamp: 3425
[   68.474841] hardirqs last  enabled at (3425): [<ffffffff81706b51>] _raw_spin_unlock_irqrestore+0x31/0x60
[   68.477381] hardirqs last disabled at (3424): [<ffffffff817069b4>] _raw_spin_lock_irqsave+0x24/0x60
[   68.479820] softirqs last  enabled at (2240): [<ffffffff8107457d>] __do_softirq+0x1bd/0x290
[   68.482099] softirqs last disabled at (2215): [<ffffffff8107497b>] irq_exit+0xeb/0x100
[   68.484281] 
[   68.484281] other info that might help us debug this:
[   68.486785]  Possible unsafe locking scenario:
[   68.486785] 
[   68.489118]        CPU0
[   68.490158]        ----
[   68.491180]   lock(&xfs_nondir_ilock_class);
[   68.492600]   <Interrupt>
[   68.493639]     lock(&xfs_nondir_ilock_class);
[   68.495072] 
[   68.495072]  *** DEADLOCK ***
[   68.495072] 
[   68.497766] 4 locks held by a.out/3934:
[   68.499027]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff811c798c>] __sb_start_write+0xcc/0xe0
[   68.501349]  #1:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff812b6cbf>] xfs_file_buffered_aio_write+0x5f/0x1f0
[   68.504102]  #2:  (&(&ip->i_iolock)->mr_lock#2){++++++}, at: [<ffffffff812c1689>] xfs_ilock+0x99/0xe0
[   68.506564]  #3:  (&xfs_nondir_ilock_class){++++?-}, at: [<ffffffff812c166f>] xfs_ilock+0x7f/0xe0
[   68.509059] 
[   68.509059] stack backtrace:
[   68.511014] CPU: 1 PID: 3934 Comm: a.out Not tainted 4.5.0-rc3-next-20160209+ #297
[   68.512961] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[   68.515481]  0000000000000086 00000000b6c05ee8 ffff88007bb3b928 ffffffff8139d91d
[   68.517565]  ffff8800362f8000 ffffffff82574ee0 ffff88007bb3b978 ffffffff8113dc64
[   68.519631]  0000000000000000 ffff880000000001 ffff880000000001 0000000000000008
[   68.521695] Call Trace:
[   68.522759]  [<ffffffff8139d91d>] dump_stack+0x85/0xc8
[   68.524778]  [<ffffffff8113dc64>] print_usage_bug+0x2b0/0x2c1
[   68.527086]  [<ffffffff810bd010>] ? check_usage_forwards+0x130/0x130
[   68.532840]  [<ffffffff810bdb23>] mark_lock+0x193/0x680
[   68.534422]  [<ffffffff810be076>] mark_held_locks+0x66/0x90
[   68.536056]  [<ffffffff812ce961>] ? kmem_zone_alloc+0x91/0x120
[   68.537742]  [<ffffffff810c13df>] lockdep_trace_alloc+0x6f/0xd0
[   68.539459]  [<ffffffff8119dee6>] kmem_cache_alloc+0x26/0x170
[   68.541289]  [<ffffffff812ce961>] kmem_zone_alloc+0x91/0x120
[   68.542954]  [<ffffffff8128b7c6>] xfs_bmbt_init_cursor+0x36/0x150
[   68.544710]  [<ffffffff8128a52a>] xfs_bunmapi+0x71a/0x970
[   68.546365]  [<ffffffff812afa85>] xfs_bmap_punch_delalloc_range+0xd5/0x150
[   68.548254]  [<ffffffff812ea341>] xfs_vm_kill_delalloc_range+0x5a/0x99
[   68.550148]  [<ffffffff812ab7ab>] xfs_vm_write_end+0x5b/0x70
[   68.551826]  [<ffffffff812c1689>] ? xfs_ilock+0x99/0xe0
[   68.553421]  [<ffffffff81140eb3>] generic_perform_write+0x113/0x1d0
[   68.555204]  [<ffffffff812c1689>] ? xfs_ilock+0x99/0xe0
[   68.556791]  [<ffffffff812c1689>] ? xfs_ilock+0x99/0xe0
[   68.558366]  [<ffffffff812b6d2e>] xfs_file_buffered_aio_write+0xce/0x1f0
[   68.560782]  [<ffffffff812b6ed4>] xfs_file_write_iter+0x84/0x140
[   68.562544]  [<ffffffff811c3307>] __vfs_write+0xc7/0x100
[   68.564113]  [<ffffffff811c3fed>] vfs_write+0x9d/0x190
[   68.565649]  [<ffffffff811e3afa>] ? __fget_light+0x6a/0x90
[   68.567240]  [<ffffffff811c4823>] SyS_write+0x53/0xd0
[   68.568752]  [<ffffffff8100362d>] do_syscall_64+0x5d/0x180
[   68.570361]  [<ffffffff8170737f>] entry_SYSCALL64_slow_path+0x25/0x25

[  177.931915] 
[  177.931915] =================================
[  177.931916] [ INFO: inconsistent lock state ]
[  177.931917] 4.5.0-rc3-next-20160209+ #298 Not tainted
[  177.931917] ---------------------------------
[  177.931918] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
[  177.931919] a.out/9565 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  177.931925]  (&xfs_nondir_ilock_class){++++?-}, at: [<ffffffff812c165f>] xfs_ilock+0x7f/0xe0
[  177.931925] {IN-RECLAIM_FS-W} state was registered at:
[  177.931928]   [<ffffffff810be971>] __lock_acquire+0x391/0x1f70
[  177.931929]   [<ffffffff810c0dfd>] lock_acquire+0x6d/0x90
[  177.931932]   [<ffffffff810ba665>] down_write_nested+0x45/0x80
[  177.931933]   [<ffffffff812c165f>] xfs_ilock+0x7f/0xe0
[  177.931935]   [<ffffffff812b9a3d>] xfs_reclaim_inode+0x12d/0x350
[  177.931937]   [<ffffffff812b9f2a>] xfs_reclaim_inodes_ag+0x2ca/0x4f0
[  177.931938]   [<ffffffff812bac6e>] xfs_reclaim_inodes_nr+0x2e/0x40
[  177.931939]   [<ffffffff812c9734>] xfs_fs_free_cached_objects+0x14/0x20
[  177.931942]   [<ffffffff811c7b5c>] super_cache_scan+0x17c/0x190
[  177.931944]   [<ffffffff8115378b>] shrink_slab.part.41+0x1db/0x2a0
[  177.931946]   [<ffffffff81156eed>] shrink_zone+0x2dd/0x2f0
[  177.931947]   [<ffffffff81157c2c>] kswapd+0x4cc/0x920
[  177.931949]   [<ffffffff81090989>] kthread+0xf9/0x110
[  177.931952]   [<ffffffff817074f2>] ret_from_fork+0x22/0x50
[  177.931953] irq event stamp: 284513
[  177.931955] hardirqs last  enabled at (284513): [<ffffffff81706b41>] _raw_spin_unlock_irqrestore+0x31/0x60
[  177.931956] hardirqs last disabled at (284512): [<ffffffff817069a4>] _raw_spin_lock_irqsave+0x24/0x60
[  177.931959] softirqs last  enabled at (283876): [<ffffffff8107457d>] __do_softirq+0x1bd/0x290
[  177.931961] softirqs last disabled at (283863): [<ffffffff8107497b>] irq_exit+0xeb/0x100
[  177.931961] 
[  177.931961] other info that might help us debug this:
[  177.931961]  Possible unsafe locking scenario:
[  177.931961] 
[  177.931962]        CPU0
[  177.931962]        ----
[  177.931962]   lock(&xfs_nondir_ilock_class);
[  177.931963]   <Interrupt>
[  177.931963]     lock(&xfs_nondir_ilock_class);
[  177.931963] 
[  177.931963]  *** DEADLOCK ***
[  177.931963] 
[  177.931964] 4 locks held by a.out/9565:
[  177.931976]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff811c797c>] __sb_start_write+0xcc/0xe0
[  177.931979]  #1:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff812b6caf>] xfs_file_buffered_aio_write+0x5f/0x1f0
[  177.931984]  #2:  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<ffffffff812c1679>] xfs_ilock+0x99/0xe0
[  177.931986]  #3:  (&xfs_nondir_ilock_class){++++?-}, at: [<ffffffff812c165f>] xfs_ilock+0x7f/0xe0
[  177.931987] 
[  177.931987] stack backtrace:
[  177.931988] CPU: 3 PID: 9565 Comm: a.out Not tainted 4.5.0-rc3-next-20160209+ #298
[  177.931989] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[  177.931991]  0000000000000086 000000009bcbb437 ffff88007af47928 ffffffff8139d90d
[  177.931992]  ffff88007af48000 ffffffff82575240 ffff88007af47978 ffffffff8113dc64
[  177.931993]  0000000000000000 ffff880000000001 ffff880000000001 0000000000000008
[  177.931993] Call Trace:
[  177.931997]  [<ffffffff8139d90d>] dump_stack+0x85/0xc8
[  177.931999]  [<ffffffff8113dc64>] print_usage_bug+0x2b0/0x2c1
[  177.932000]  [<ffffffff810bd010>] ? check_usage_forwards+0x130/0x130
[  177.932001]  [<ffffffff810bdb23>] mark_lock+0x193/0x680
[  177.932001]  [<ffffffff810be076>] mark_held_locks+0x66/0x90
[  177.932003]  [<ffffffff812ce951>] ? kmem_zone_alloc+0x91/0x120
[  177.932003]  [<ffffffff810c13df>] lockdep_trace_alloc+0x6f/0xd0
[  177.932006]  [<ffffffff8119ded6>] kmem_cache_alloc+0x26/0x170
[  177.932007]  [<ffffffff812ce951>] kmem_zone_alloc+0x91/0x120
[  177.932009]  [<ffffffff8128b7b6>] xfs_bmbt_init_cursor+0x36/0x150
[  177.932010]  [<ffffffff8128a51a>] xfs_bunmapi+0x71a/0x970
[  177.932011]  [<ffffffff812afa75>] xfs_bmap_punch_delalloc_range+0xd5/0x150
[  177.932013]  [<ffffffff812ea331>] xfs_vm_kill_delalloc_range+0x5a/0x99
[  177.932014]  [<ffffffff812ab79b>] xfs_vm_write_end+0x5b/0x70
[  177.932015]  [<ffffffff812c1679>] ? xfs_ilock+0x99/0xe0
[  177.932017]  [<ffffffff81140eb3>] generic_perform_write+0x113/0x1d0
[  177.932017]  [<ffffffff812c1679>] ? xfs_ilock+0x99/0xe0
[  177.932018]  [<ffffffff812c1679>] ? xfs_ilock+0x99/0xe0
[  177.932020]  [<ffffffff812b6d1e>] xfs_file_buffered_aio_write+0xce/0x1f0
[  177.932021]  [<ffffffff812b6ec4>] xfs_file_write_iter+0x84/0x140
[  177.932023]  [<ffffffff811c32f7>] __vfs_write+0xc7/0x100
[  177.932025]  [<ffffffff811c3fdd>] vfs_write+0x9d/0x190
[  177.932027]  [<ffffffff811e3aea>] ? __fget_light+0x6a/0x90
[  177.932028]  [<ffffffff811c4813>] SyS_write+0x53/0xd0
[  177.932030]  [<ffffffff8100362d>] do_syscall_64+0x5d/0x180
[  177.932032]  [<ffffffff8170737f>] entry_SYSCALL64_slow_path+0x25/0x25

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
