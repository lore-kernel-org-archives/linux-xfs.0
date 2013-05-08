Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B64D829E0E
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 04:04:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 894418F8059
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 02:04:26 -0700 (PDT)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id tkvTxCbuKotHVwq2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 May 2013 02:04:24 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	r4894MMi020950
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 8 May 2013 11:04:22 +0200
Received: from mail2.itwm.fhg.de ([131.246.191.79]:59903)
	by itwm2.itwm.fhg.de with esmtps (TLSv1:DES-CBC3-SHA:168)
	(/C=DE/ST=Rheinland-Pfalz/L=Kaiserslautern/O=Fraunhofer
	ITWM/OU=SLG/CN=mail2.itwm.fhg.de)(verified=1) (Exim 4.74 #1)
	id 1Ua0IP-0006DB-UE
	for xfs@oss.sgi.com; Wed, 08 May 2013 11:04:21 +0200
Message-ID: <518A1515.20805@itwm.fraunhofer.de>
Date: Wed, 08 May 2013 11:04:21 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: 3.9.0: INFO: inconsistent lock state (xfs_ilock)
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
To: xfs@oss.sgi.com

While waiting for the xfs_log_item list corruption, I got a lockdep warning.

> [101949.322212]
> [101949.323834] =================================
> [101949.327242] [ INFO: inconsistent lock state ]
> [101949.327242] 3.9.0-debug+ #10 Not tainted
> [101949.327242] ---------------------------------
> [101949.327242] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
> [101949.327242] fhgfs-storage/W/1710 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [101949.327242]  (&(&ip->i_lock)->mr_lock){++++?-}, at: [<ffffffffa05268c4>] xfs_ilock+0x109/0x138 [xfs]
> [101949.327242] {IN-RECLAIM_FS-W} state was registered at:
> [101949.327242]   [<ffffffff810b97ec>] __lock_acquire+0x57a/0x1903
> [101949.327242]   [<ffffffff810bacba>] lock_acquire+0x145/0x179
> [101949.327242]   [<ffffffff810829a0>] down_write_nested+0x67/0xc2
> [101949.327242]   [<ffffffffa05268c4>] xfs_ilock+0x109/0x138 [xfs]
> [101949.327242]   [<ffffffffa04e3b64>] xfs_reclaim_inode+0x52/0x334 [xfs]
> [101949.327242]   [<ffffffffa04e41cc>] xfs_reclaim_inodes_ag+0x386/0x4a7 [xfs]
> [101949.327242]   [<ffffffffa04e49a2>] xfs_reclaim_inodes_nr+0x33/0x3a [xfs]
> [101949.327242]   [<ffffffffa04ecfa7>] xfs_fs_free_cached_objects+0x15/0x17 [xfs]
> [101949.327242]   [<ffffffff8119b853>] prune_super+0x104/0x179
> [101949.327242]   [<ffffffff8114b7bf>] shrink_slab+0x2db/0x4b2
> [101949.327242]   [<ffffffff8114ccd0>] kswapd+0x891/0xb91
> [101949.327242]   [<ffffffff8107e150>] kthread+0xe1/0xe9
> [101949.327242]   [<ffffffff8156be7c>] ret_from_fork+0x7c/0xb0
> [101949.327242] irq event stamp: 928730947
> [101949.327242] hardirqs last  enabled at (928730947): [<ffffffff81560062>] __mutex_unlock_slowpath+0x128/0x13d
> [101949.327242] hardirqs last disabled at (928730946): [<ffffffff8155ffa8>] __mutex_unlock_slowpath+0x6e/0x13d
> [101949.327242] softirqs last  enabled at (928730604): [<ffffffff810603b6>] __do_softirq+0x34e/0x3bc
> [101949.327242] softirqs last disabled at (928730569): [<ffffffff810604fb>] irq_exit+0x60/0xb6
> [101949.327242]
> [101949.327242] other info that might help us debug this:
> [101949.327242]  Possible unsafe locking scenario:
> [101949.327242]
> [101949.327242]        CPU0
> [101949.327242]        ----
> [101949.327242]   lock(&(&ip->i_lock)->mr_lock);
> [101949.327242]   <Interrupt>
> [101949.327242]     lock(&(&ip->i_lock)->mr_lock);
> [101949.327242]
> [101949.327242]  *** DEADLOCK ***
> [101949.327242]
> [101949.327242] 4 locks held by fhgfs-storage/W/1710:
> [101949.327242]  #0:  (sb_writers#11){.+.+.+}, at: [<ffffffffa04e0e7f>] xfs_file_aio_write+0xb1/0x172 [xfs]
> [101949.327242]  #1:  (&sb->s_type->i_mutex_key#16){+.+.+.}, at: [<ffffffffa04e0bd0>] xfs_file_buffered_aio_write+0x5d/0x25b [xfs]
> [101949.327242]  #2:  (&(&ip->i_iolock)->mr_lock#2){++++++}, at: [<ffffffffa052688c>] xfs_ilock+0xd1/0x138 [xfs]
> [101949.327242]  #3:  (&(&ip->i_lock)->mr_lock){++++?-}, at: [<ffffffffa05268c4>] xfs_ilock+0x109/0x138 [xfs]
> [101949.327242]
> [101949.327242] stack backtrace:
> [101949.327242] Pid: 1710, comm: fhgfs-storage/W Not tainted 3.9.0-debug+ #10
> [101949.327242] Call Trace:
> [101949.327242]  [<ffffffff810b80a8>] print_usage_bug+0x29d/0x2b8
> [101949.327242]  [<ffffffff81022bf7>] ? save_stack_trace+0x38/0x59
> [101949.327242]  [<ffffffff810b88f6>] mark_lock+0x1c9/0x3cb
> [101949.327242]  [<ffffffff810b7d28>] ? check_usage_forwards+0xe3/0xe3
> [101949.327242]  [<ffffffff810b8c1d>] mark_held_locks+0x125/0x14f
> [101949.327242]  [<ffffffffa04f3d7c>] ? kmem_zone_alloc+0x6c/0xcf [xfs]
> [101949.327242]  [<ffffffff810b8cec>] lockdep_trace_alloc+0xa5/0xc9
> [101949.327242]  [<ffffffff811875ff>] kmem_cache_alloc+0x3d/0x2cf
> [101949.327242]  [<ffffffffa050ce8c>] ? __xfs_bmbt_get_all+0x9/0x41 [xfs]
> [101949.327242]  [<ffffffffa04f3d7c>] kmem_zone_alloc+0x6c/0xcf [xfs]
> [101949.327242]  [<ffffffffa04f3dfd>] kmem_zone_zalloc+0x1e/0x46 [xfs]
> [101949.327242]  [<ffffffffa050d5cd>] xfs_bmbt_init_cursor+0x4a/0x12c [xfs]
> [101949.327242]  [<ffffffffa050c3d3>] xfs_bunmapi+0x2af/0xc11 [xfs]
> [101949.327242]  [<ffffffffa050ce3c>] xfs_bmap_punch_delalloc_range+0x107/0x13b [xfs]
> [101949.327242]  [<ffffffffa04d7649>] xfs_vm_kill_delalloc_range+0x61/0xa1 [xfs]
> [101949.327242]  [<ffffffffa04d76f7>] xfs_vm_write_end+0x6e/0x86 [xfs]
> [101949.327242]  [<ffffffff81135145>] generic_file_buffered_write+0x192/0x27c
> [101949.327242]  [<ffffffff811b1f0e>] ? file_remove_suid+0x19/0xa9
> [101949.327242]  [<ffffffffa04e0d46>] xfs_file_buffered_aio_write+0x1d3/0x25b [xfs]
> [101949.327242]  [<ffffffffa04e0ed4>] xfs_file_aio_write+0x106/0x172 [xfs]
> [101949.327242]  [<ffffffff81198c5a>] do_sync_write+0xa0/0xe0
> [101949.327242]  [<ffffffff81198f1d>] vfs_write+0xc0/0x125
> [101949.327242]  [<ffffffff81199729>] sys_write+0x60/0x94
> [101949.327242]  [<ffffffff8156bf29>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
