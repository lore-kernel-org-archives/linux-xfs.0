Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VBPYwt147354 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 06:25:36 -0500
Subject: XFS inconsistent lock state (-rc4)
From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 31 Jul 2009 13:25:46 +0200
Message-Id: <1249039546.29587.72.camel@johannes.local>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters <xfs-masters@oss.sgi.com>, xfs@oss.sgi.com

After pushing a lot of data onto the disk, including creating millions
of hardlinks (rsync backup run with --link-dest):

[ 3483.668282] 
[ 3483.668287] =================================
[ 3483.668363] [ INFO: inconsistent lock state ]
[ 3483.668393] 2.6.31-rc4-wl-29204-g6b3a8c9-dirty #115
[ 3483.668418] ---------------------------------
[ 3483.668444] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
[ 3483.668472] kswapd0/186 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 3483.668499]  (&(&ip->i_lock)->mr_lock){+++++?}, at: [<c00000000026c260>] .xfs_ilock+0x90/0xb0
[ 3483.668601] {RECLAIM_FS-ON-W} state was registered at:
[ 3483.668627]   [<c0000000000a572c>] .mark_held_locks+0x7c/0xcc
[ 3483.668682]   [<c0000000000a5854>] .lockdep_trace_alloc+0xd8/0x110
[ 3483.668733]   [<c00000000014df94>] .kmem_cache_alloc+0x64/0x244
[ 3483.668786]   [<c000000000290d80>] .kmem_zone_alloc+0x94/0x114
[ 3483.668835]   [<c000000000290e38>] .kmem_zone_zalloc+0x38/0x80
[ 3483.668884]   [<c000000000258330>] .xfs_da_state_alloc+0x34/0x50
[ 3483.668936]   [<c0000000002625c8>] .xfs_dir2_node_lookup+0x38/0x158
[ 3483.668985]   [<c00000000025c6a0>] .xfs_dir_lookup+0x17c/0x1e4
[ 3483.669038]   [<c00000000028e2c8>] .xfs_lookup+0x80/0x118
[ 3483.669093]   [<c00000000029b5a8>] .xfs_vn_lookup+0x5c/0xcc
[ 3483.669145]   [<c0000000001617c0>] .real_lookup+0xc8/0x1b4
[ 3483.669198]   [<c000000000161944>] .do_lookup+0x98/0x140
[ 3483.669248]   [<c000000000164b84>] .__link_path_walk+0xd08/0x1380
[ 3483.669298]   [<c000000000165570>] .path_walk+0xa4/0x158
[ 3483.669348]   [<c000000000165688>] .do_path_lookup+0x64/0x114
[ 3483.669397]   [<c0000000001668dc>] .do_filp_open+0x12c/0xad4
[ 3483.669447]   [<c000000000152174>] .do_sys_open+0x98/0x190
[ 3483.669497]   [<c000000000152330>] .SyS_open+0x4c/0x6c
[ 3483.669548]   [<c000000000008694>] .init_post+0x60/0x1a0
[ 3483.669600]   [<c0000000006d65a0>] .kernel_init+0xe8/0x10c
[ 3483.669657]   [<c00000000002823c>] .kernel_thread+0x54/0x70
[ 3483.669712] irq event stamp: 394815
[ 3483.669738] hardirqs last  enabled at (394815): [<c000000000113d04>] .free_hot_cold_page+0x244/0x360
[ 3483.669795] hardirqs last disabled at (394814): [<c000000000113dd4>] .free_hot_cold_page+0x314/0x360
[ 3483.669851] softirqs last  enabled at (394510): [<c00000000006fefc>] .__do_softirq+0x304/0x34c
[ 3483.669907] softirqs last disabled at (394503): [<c000000000027f34>] .call_do_softirq+0x14/0x24
[ 3483.669960] 
[ 3483.669962] other info that might help us debug this:
[ 3483.670009] 2 locks held by kswapd0/186:
[ 3483.670034]  #0:  (shrinker_rwsem){++++..}, at: [<c00000000011e324>] .shrink_slab+0x74/0x290
[ 3483.670162]  #1:  (iprune_mutex){+.+.-.}, at: [<c000000000171ef4>] .prune_icache+0x70/0x2d8
[ 3483.670284] 
[ 3483.670285] stack backtrace:
[ 3483.670378] Call Trace:
[ 3483.670407] [c00000021652ef80] [c000000000011170] .show_stack+0xb4/0x1e8 (unreliable)
[ 3483.670485] [c00000021652f050] [c0000000004f26d8] .dump_stack+0x28/0x3c
[ 3483.670535] [c00000021652f0d0] [c0000000000a4d08] .print_usage_bug+0x1e0/0x21c
[ 3483.670586] [c00000021652f1a0] [c0000000000a4e44] .mark_lock_irq+0x100/0x330
[ 3483.670637] [c00000021652f260] [c0000000000a5354] .mark_lock+0x2e0/0x484
[ 3483.670687] [c00000021652f300] [c0000000000a5674] .mark_irqflags+0x17c/0x1b8
[ 3483.670739] [c00000021652f390] [c0000000000a8508] .__lock_acquire+0x6f4/0x91c
[ 3483.670788] [c00000021652f490] [c0000000000a887c] .lock_acquire+0x14c/0x19c
[ 3483.670844] [c00000021652f560] [c000000000091e1c] .down_read_nested+0x74/0x130
[ 3483.670895] [c00000021652f600] [c00000000026c260] .xfs_ilock+0x90/0xb0
[ 3483.670947] [c00000021652f690] [c00000000028e3e0] .xfs_free_eofblocks+0x80/0x294
[ 3483.671000] [c00000021652f790] [c00000000028ebe4] .xfs_inactive+0x13c/0x4c4
[ 3483.671051] [c00000021652f850] [c00000000029ddd4] .xfs_fs_clear_inode+0x9c/0xbc
[ 3483.671148] [c00000021652f8e0] [c000000000171a58] .clear_inode+0xd4/0x150
[ 3483.671198] [c00000021652f970] [c000000000171d88] .dispose_list+0x94/0x190
[ 3483.671250] [c00000021652fa20] [c00000000017211c] .prune_icache+0x298/0x2d8
[ 3483.671300] [c00000021652faf0] [c0000000001721ac] .shrink_icache_memory+0x50/0x90
[ 3483.671352] [c00000021652fb80] [c00000000011e428] .shrink_slab+0x178/0x290
[ 3483.671403] [c00000021652fc50] [c00000000011e958] .balance_pgdat+0x418/0x634
[ 3483.671452] [c00000021652fdb0] [c00000000011ece0] .kswapd+0x16c/0x170
[ 3483.671504] [c00000021652fe90] [c00000000008b7bc] .kthread+0xac/0xb8


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
