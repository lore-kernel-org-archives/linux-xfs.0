Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4K96kE2098289 for <xfs@oss.sgi.com>; Wed, 20 May 2009 04:06:47 -0500
Subject: inconsistent lock state on -rc6
From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 20 May 2009 11:06:19 +0200
Message-Id: <1242810379.19216.5.camel@johannes.local>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

I also had it crash again, with 4K pages, but didn't capture that --
trying to reproduce right now.

[  713.951398] =================================
[  713.965386] [ INFO: inconsistent lock state ]
[  713.972354] 2.6.30-rc6-wl-23952-g30cf869-dirty #56
[  713.979370] ---------------------------------
[  713.986362] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
[  713.993450] kswapd0/183 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  714.000521]  (&(&ip->i_lock)->mr_lock){+++++?}, at: [<c000000000258a90>] .xfs_ilock+0x90/0xb0
[  714.007832] {RECLAIM_FS-ON-W} state was registered at:
[  714.015079]   [<c00000000009c138>] .mark_held_locks+0x7c/0xcc
[  714.022410]   [<c00000000009c260>] .lockdep_trace_alloc+0xd8/0x110
[  714.029787]   [<c00000000013ed78>] .kmem_cache_alloc+0x50/0x22c
[  714.037168]   [<c00000000027dd54>] .kmem_zone_alloc+0x94/0x114
[  714.044530]   [<c00000000027de0c>] .kmem_zone_zalloc+0x38/0x80
[  714.051890]   [<c000000000244a68>] .xfs_da_state_alloc+0x34/0x50
[  714.059251]   [<c00000000024edbc>] .xfs_dir2_node_lookup+0x38/0x158
[  714.066592]   [<c000000000248e48>] .xfs_dir_lookup+0x17c/0x1e4
[  714.073874]   [<c00000000027ae8c>] .xfs_lookup+0x80/0x118
[  714.081044]   [<c000000000288640>] .xfs_vn_lookup+0x5c/0xcc
[  714.088106]   [<c00000000015260c>] .real_lookup+0xc8/0x1b4
[  714.095083]   [<c000000000152790>] .do_lookup+0x98/0x140
[  714.101963]   [<c0000000001554d8>] .__link_path_walk+0xc04/0x1218
[  714.108815]   [<c000000000155dfc>] .path_walk+0xa4/0x158
[  714.115593]   [<c0000000001561fc>] .do_path_lookup+0x204/0x2b4
[  714.122315]   [<c00000000015729c>] .do_filp_open+0x12c/0x9dc
[  714.129026]   [<c000000000142dd8>] .do_sys_open+0x98/0x15c
[  714.135739]   [<c000000000142f60>] .SyS_open+0x4c/0x6c
[  714.142279]   [<c000000000008230>] .init_post+0x60/0x1a0
[  714.148642]   [<c0000000006a1520>] .kernel_init+0x12c/0x150
[  714.155036]   [<c000000000027b8c>] .kernel_thread+0x54/0x70
[  714.161425] irq event stamp: 503825
[  714.167796] hardirqs last  enabled at (503825): [<c000000000107abc>] .free_hot_cold_page+0x280/0x3c0
[  714.174477] hardirqs last disabled at (503824): [<c000000000107b84>] .free_hot_cold_page+0x348/0x3c0
[  714.181045] softirqs last  enabled at (503088): [<c000000000069cf8>] .__do_softirq+0x2c0/0x304
[  714.187527] softirqs last disabled at (503081): [<c00000000000caf8>] .do_softirq+0x6c/0xb8
[  714.193929] 
[  714.193930] other info that might help us debug this:
[  714.206519] 2 locks held by kswapd0/183:
[  714.212884]  #0:  (shrinker_rwsem){++++..}, at: [<c000000000111ed8>] .shrink_slab+0x74/0x290
[  714.219555]  #1:  (iprune_mutex){+.+.-.}, at: [<c000000000162490>] .prune_icache+0x70/0x2d8
[  714.226313] 
[  714.226314] stack backtrace:
[  714.239539] Call Trace:
[  714.246127] [c00000021643efe0] [c00000000001099c] .show_stack+0xa0/0x1f0 (unreliable)
[  714.252957] [c00000021643f0b0] [c0000000004d14dc] .dump_stack+0x28/0x3c
[  714.259799] [c00000021643f130] [c00000000009b714] .print_usage_bug+0x1e0/0x21c
[  714.266639] [c00000021643f200] [c00000000009b850] .mark_lock_irq+0x100/0x330
[  714.273476] [c00000021643f2c0] [c00000000009bd60] .mark_lock+0x2e0/0x484
[  714.280290] [c00000021643f360] [c00000000009c080] .mark_irqflags+0x17c/0x1b8
[  714.286878] [c00000021643f3f0] [c00000000009eefc] .__lock_acquire+0x6cc/0x8f4
[  714.293237] [c00000021643f4f0] [c00000000009f270] .lock_acquire+0x14c/0x19c
[  714.299658] [c00000021643f5c0] [c00000000008a2a4] .down_read_nested+0x74/0x130
[  714.306103] [c00000021643f660] [c000000000258a90] .xfs_ilock+0x90/0xb0
[  714.312532] [c00000021643f6f0] [c00000000027afa4] .xfs_free_eofblocks+0x80/0x2b0
[  714.318990] [c00000021643f7f0] [c00000000027b7c0] .xfs_inactive+0x138/0x514
[  714.325430] [c00000021643f8b0] [c00000000028ae1c] .xfs_fs_clear_inode+0x9c/0xbc
[  714.331885] [c00000021643f940] [c000000000162004] .clear_inode+0xd4/0x150
[  714.338203] [c00000021643f9d0] [c000000000162324] .dispose_list+0x94/0x190
[  714.344376] [c00000021643fa80] [c0000000001626b8] .prune_icache+0x298/0x2d8
[  714.350548] [c00000021643fb50] [c000000000162748] .shrink_icache_memory+0x50/0x90
[  714.356744] [c00000021643fbe0] [c000000000111fdc] .shrink_slab+0x178/0x290
[  714.362891] [c00000021643fcb0] [c0000000001124f8] .balance_pgdat+0x404/0x620
[  714.368984] [c00000021643fe10] [c000000000112880] .kswapd+0x16c/0x170
[  714.374990] [c00000021643fef0] [c000000000083d68] .kthread+0x98/0xec


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
