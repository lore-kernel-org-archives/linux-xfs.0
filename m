Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANCGUhJ204799 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 06:16:31 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27FE01C6A514
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 04:18:06 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xD9WvAdUP5SDVFjC for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 04:18:06 -0800 (PST)
Date: Tue, 23 Nov 2010 23:18:02 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: XFS reclaim lock order bug
Message-ID: <20101123121802.GA4785@amd>
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
To: xfs@oss.sgi.com

Hi,

IIRC I've reported this before. Perhaps it is a false positive, but even
so it is still annoying that it triggers and turns off lockdep for
subsequent debugging.

Any chance it can get fixed or properly annotated?

Thanks,
Nick


[  286.895008] 
[  286.895010] =================================
[  286.895020] [ INFO: inconsistent lock state ]
[  286.895020] 2.6.37-rc3+ #28
[  286.895020] ---------------------------------
[  286.895020] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
[  286.895020] rm/1844 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  286.895020]  (&(&ip->i_iolock)->mr_lock#2){++++-+}, at: [<ffffffffa0067e58>] xfs_ilock+0xe8/0x1e0 [xfs]
[  286.895020] {RECLAIM_FS-ON-R} state was registered at:
[  286.895020]   [<ffffffff8108380b>] mark_held_locks+0x6b/0xa0
[  286.895020]   [<ffffffff810838d1>] lockdep_trace_alloc+0x91/0xd0
[  286.895020]   [<ffffffff810d1851>] __alloc_pages_nodemask+0x91/0x780
[  286.895020]   [<ffffffff8110a043>] alloc_page_vma+0x93/0x150
[  286.895020]   [<ffffffff810ed909>] handle_mm_fault+0x719/0x9a0
[  286.895020]   [<ffffffff816068e3>] do_page_fault+0x133/0x4f0
[  286.895020]   [<ffffffff816039df>] page_fault+0x1f/0x30
[  286.895020]   [<ffffffff810cb52a>] generic_file_aio_read+0x2fa/0x730
[  286.895020]   [<ffffffffa009a29b>] xfs_file_aio_read+0x15b/0x390 [xfs]
[  286.895020]   [<ffffffff81117812>] do_sync_read+0xd2/0x110
[  286.895020]   [<ffffffff81117b55>] vfs_read+0xc5/0x190
[  286.895020]   [<ffffffff8111846c>] sys_read+0x4c/0x80
[  286.895020]   [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  286.895020] irq event stamp: 1095103
[  286.895020] hardirqs last  enabled at (1095103): [<ffffffff81603215>] _raw_spin_unlock_irqrestore+0x65/0x80
[  286.895020] hardirqs last disabled at (1095102): [<ffffffff81602be7>] _raw_spin_lock_irqsave+0x17/0x60
[  286.895020] softirqs last  enabled at (1093048): [<ffffffff81050c4e>] __do_softirq+0x16e/0x360
[  286.895020] softirqs last disabled at (1093009): [<ffffffff81003fcc>] call_softirq+0x1c/0x50
[  286.895020] 
[  286.895020] other info that might help us debug this:
[  286.895020] 3 locks held by rm/1844:
[  286.895020]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81124cdc>] do_lookup+0xfc/0x170
[  286.895020]  #1:  (shrinker_rwsem){++++..}, at: [<ffffffff810d8f68>] shrink_slab+0x38/0x190
[  286.895020]  #2:  (&pag->pag_ici_reclaim_lock){+.+...}, at: [<ffffffffa00a2944>] xfs_reclaim_inodes_ag+0xa4/0x370 [xfs]
[  286.895020] 
[  286.895020] stack backtrace:
[  286.895020] Pid: 1844, comm: rm Not tainted 2.6.37-rc3+ #28
[  286.895020] Call Trace:
[  286.895020]  [<ffffffff810828f0>] print_usage_bug+0x170/0x180
[  286.895020]  [<ffffffff810835b1>] mark_lock+0x211/0x400
[  286.895020]  [<ffffffff810841ae>] __lock_acquire+0x40e/0x1490
[  286.895020]  [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
[  286.895020]  [<ffffffffa0067e58>] ? xfs_ilock+0xe8/0x1e0 [xfs]
[  286.895020]  [<ffffffffa00a2774>] ? xfs_reclaim_inode+0x174/0x2a0 [xfs]
[  286.895020]  [<ffffffff81073c3a>] down_write_nested+0x4a/0x70
[  286.895020]  [<ffffffffa0067e58>] ? xfs_ilock+0xe8/0x1e0 [xfs]
[  286.895020]  [<ffffffffa0067e58>] xfs_ilock+0xe8/0x1e0 [xfs]
[  286.895020]  [<ffffffffa00a27c0>] xfs_reclaim_inode+0x1c0/0x2a0 [xfs]
[  286.895020]  [<ffffffffa00a2aaf>] xfs_reclaim_inodes_ag+0x20f/0x370 [xfs]
[  286.895020]  [<ffffffffa00a2c88>] xfs_reclaim_inode_shrink+0x78/0x80 [xfs]
[  286.895020]  [<ffffffff810d9057>] shrink_slab+0x127/0x190
[  286.895020]  [<ffffffff810dbf09>] zone_reclaim+0x349/0x420
[  286.895020]  [<ffffffff810cf815>] ? zone_watermark_ok+0x25/0xe0
[  286.895020]  [<ffffffff810d1603>] get_page_from_freelist+0x673/0x830
[  286.895020]  [<ffffffff8110c013>] ? init_object+0x43/0x80
[  286.895020]  [<ffffffffa00929ec>] ? kmem_zone_alloc+0x8c/0xd0 [xfs]
[  286.895020]  [<ffffffff8108380b>] ? mark_held_locks+0x6b/0xa0
[  286.895020]  [<ffffffff8108380b>] ? mark_held_locks+0x6b/0xa0
[  286.895020]  [<ffffffff810d18d0>] __alloc_pages_nodemask+0x110/0x780
[  286.895020]  [<ffffffff8110eb3a>] ? unfreeze_slab+0x11a/0x160
[  286.895020]  [<ffffffff811089d6>] alloc_pages_current+0x76/0xf0
[  286.895020]  [<ffffffff8110ce45>] new_slab+0x205/0x2b0
[  286.895020]  [<ffffffff8110ef7c>] __slab_alloc+0x30c/0x480
[  286.895020]  [<ffffffff8112f372>] ? d_alloc+0x22/0x200
[  286.895020]  [<ffffffff8112f372>] ? d_alloc+0x22/0x200
[  286.895020]  [<ffffffff8112f372>] ? d_alloc+0x22/0x200
[  286.895020]  [<ffffffff8110fe18>] kmem_cache_alloc+0xf8/0x1a0
[  286.895020]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  286.895020]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  286.895020]  [<ffffffff8112f372>] d_alloc+0x22/0x200
[  286.895020]  [<ffffffff811236fb>] d_alloc_and_lookup+0x2b/0x90
[  286.895020]  [<ffffffff8112f24c>] ? d_lookup+0x3c/0x60
[  286.895020]  [<ffffffff81124cfa>] do_lookup+0x11a/0x170
[  286.895020]  [<ffffffff81125a4a>] link_path_walk+0x31a/0xa50
[  286.895020]  [<ffffffff81126292>] path_walk+0x62/0xe0
[  286.895020]  [<ffffffff8112636b>] do_path_lookup+0x5b/0x60
[  286.895020]  [<ffffffff81126fe2>] user_path_at+0x52/0xa0
[  286.895020]  [<ffffffff8110e8d5>] ? kmem_cache_free+0xe5/0x190
[  286.895020]  [<ffffffff81083b4d>] ? trace_hardirqs_on+0xd/0x10
[  286.895020]  [<ffffffff81126760>] ? do_unlinkat+0x60/0x1d0
[  286.895020]  [<ffffffff8111d077>] vfs_fstatat+0x37/0x70
[  286.895020]  [<ffffffff8111d21f>] sys_newfstatat+0x1f/0x50
[  286.895020]  [<ffffffff81083afd>] ? trace_hardirqs_on_caller+0x13d/0x180
[  286.895020]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  286.895020]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
