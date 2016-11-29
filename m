Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50111 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756492AbcK2LRK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 06:17:10 -0500
Message-ID: <1480418228.2258.28.camel@pengutronix.de>
Subject: XFS on RBD deadlock
From: Lucas Stach <l.stach@pengutronix.de>
Date: Tue, 29 Nov 2016 12:17:08 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ceph-devel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: Michael Olbrich <m.olbrich@pengutronix.de>, =?ISO-8859-1?Q?Bj=F6rn_L=E4ssig?= <b.laessig@pengutronix.de>

Hi all,

we have encountered a deadlock with XFS on RBD on one of our development
compile servers.
The system has multiple XFS file system instances mounted on both local
storage and RBD. When under load the system encounters sustained high
memory pressure.
The deadlock was only seen with the XFS on RBD instance, other FS
instances on local storage remained unaffected. 

We were able to collect some backtraces, a trimmed version with the (in
our opinion) interesting bits below, that seem to illustrate the
deadlock pretty well. Backtraces from a 4.8 kernel, but current code
looks mostly unchanged.

1. One thread causes memory pressure, VM is trying to free memory
through the XFS superblock shrinker, which needs to force out the log to
be able to get rid of some of the cached inodes.

cc1             D ffff92243fad8180     0  6772   6770 0x00000080
ffff9224d107b200 ffff922438de2f40 ffff922e8304fed8 ffff9224d107b200
ffff922ea7554000 ffff923034fb0618 0000000000000000 ffff9224d107b200
ffff9230368e5400 ffff92303788b000 ffffffff951eb4e1 0000003e00095bc0
Nov 28 18:21:23 dude kernel: Call Trace:
[<ffffffff951eb4e1>] ? schedule+0x31/0x80
[<ffffffffc0ab0570>] ? _xfs_log_force_lsn+0x1b0/0x340 [xfs]
[<ffffffff94ca5790>] ? wake_up_q+0x60/0x60
[<ffffffffc0a9f7ff>] ? __xfs_iunpin_wait+0x9f/0x160 [xfs]
[<ffffffffc0ab0730>] ? xfs_log_force_lsn+0x30/0xb0 [xfs]
[<ffffffffc0a97041>] ? xfs_reclaim_inode+0x131/0x370 [xfs]
[<ffffffffc0a9f7ff>] ? __xfs_iunpin_wait+0x9f/0x160 [xfs]
[<ffffffff94cbcf80>] ? autoremove_wake_function+0x40/0x40
[<ffffffffc0a97041>] ? xfs_reclaim_inode+0x131/0x370 [xfs]
[<ffffffffc0a97442>] ? xfs_reclaim_inodes_ag+0x1c2/0x2d0 [xfs]
[<ffffffff94cb197c>] ? enqueue_task_fair+0x5c/0x920
[<ffffffff94c35895>] ? sched_clock+0x5/0x10
[<ffffffff94ca47e0>] ? check_preempt_curr+0x50/0x90
[<ffffffff94ca4834>] ? ttwu_do_wakeup+0x14/0xe0
[<ffffffff94ca53c3>] ? try_to_wake_up+0x53/0x3a0
[<ffffffffc0a98331>] ? xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[<ffffffff94e05bfe>] ? super_cache_scan+0x17e/0x190
[<ffffffff94d919f3>] ? shrink_slab.part.38+0x1e3/0x3d0
[<ffffffff94d9616a>] ? shrink_node+0x10a/0x320
[<ffffffff94d96474>] ? do_try_to_free_pages+0xf4/0x350
[<ffffffff94d967ba>] ? try_to_free_pages+0xea/0x1b0
[<ffffffff94d863bd>] ? __alloc_pages_nodemask+0x61d/0xe60
[<ffffffff94dd918a>] ? alloc_pages_vma+0xba/0x280
[<ffffffff94db0f8b>] ? wp_page_copy+0x45b/0x6c0
[<ffffffff94db3e12>] ? alloc_set_pte+0x2e2/0x5f0
[<ffffffff94db2169>] ? do_wp_page+0x4a9/0x7e0
[<ffffffff94db4bd2>] ? handle_mm_fault+0x872/0x1250
[<ffffffff94c65a53>] ? __do_page_fault+0x1e3/0x500
[<ffffffff951f0cd8>] ? page_fault+0x28/0x30

2. RBD worker is trying to handle the XFS block request, but the
involved crypto code recurses into the XFS superblock shrinker, as it's
trying to allocate memory with GFP_KERNEL in __crypto_alloc_tfm.

kworker/9:3     D ffff92303f318180     0 20732      2 0x00000080
Workqueue: ceph-msgr ceph_con_workfn [libceph]
 ffff923035dd4480 ffff923038f8a0c0 0000000000000001 000000009eb27318
 ffff92269eb28000 ffff92269eb27338 ffff923036b145ac ffff923035dd4480
 00000000ffffffff ffff923036b145b0 ffffffff951eb4e1 ffff923036b145a8
Call Trace:
 [<ffffffff951eb4e1>] ? schedule+0x31/0x80
 [<ffffffff951eb77a>] ? schedule_preempt_disabled+0xa/0x10
 [<ffffffff951ed1f4>] ? __mutex_lock_slowpath+0xb4/0x130
 [<ffffffff951ed28b>] ? mutex_lock+0x1b/0x30
 [<ffffffffc0a974b3>] ? xfs_reclaim_inodes_ag+0x233/0x2d0 [xfs]
 [<ffffffff94d92ba5>] ? move_active_pages_to_lru+0x125/0x270
 [<ffffffff94f2b985>] ? radix_tree_gang_lookup_tag+0xc5/0x1c0
 [<ffffffff94dad0f3>] ? __list_lru_walk_one.isra.3+0x33/0x120
 [<ffffffffc0a98331>] ? xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
 [<ffffffff94e05bfe>] ? super_cache_scan+0x17e/0x190
 [<ffffffff94d919f3>] ? shrink_slab.part.38+0x1e3/0x3d0
 [<ffffffff94d9616a>] ? shrink_node+0x10a/0x320
 [<ffffffff94d96474>] ? do_try_to_free_pages+0xf4/0x350
 [<ffffffff94d967ba>] ? try_to_free_pages+0xea/0x1b0
 [<ffffffff94d863bd>] ? __alloc_pages_nodemask+0x61d/0xe60
 [<ffffffff94ddf42d>] ? cache_grow_begin+0x9d/0x560
 [<ffffffff94ddfb88>] ? fallback_alloc+0x148/0x1c0
 [<ffffffff94ed84e7>] ? __crypto_alloc_tfm+0x37/0x130
 [<ffffffff94de09db>] ? __kmalloc+0x1eb/0x580
 [<ffffffffc09fe2db>] ? crush_choose_firstn+0x3eb/0x470 [libceph]
 [<ffffffff94ed84e7>] ? __crypto_alloc_tfm+0x37/0x130
 [<ffffffff94ed9c19>] ? crypto_spawn_tfm+0x39/0x60
 [<ffffffffc08b30a3>] ? crypto_cbc_init_tfm+0x23/0x40 [cbc]
 [<ffffffff94ed857c>] ? __crypto_alloc_tfm+0xcc/0x130
 [<ffffffff94edcc23>] ? crypto_skcipher_init_tfm+0x113/0x180
 [<ffffffff94ed7cc3>] ? crypto_create_tfm+0x43/0xb0
 [<ffffffff94ed83b0>] ? crypto_larval_lookup+0x150/0x150
 [<ffffffff94ed7da2>] ? crypto_alloc_tfm+0x72/0x120
 [<ffffffffc0a01dd7>] ? ceph_aes_encrypt2+0x67/0x400 [libceph]
 [<ffffffffc09fd264>] ? ceph_pg_to_up_acting_osds+0x84/0x5b0 [libceph]
 [<ffffffff950d40a0>] ? release_sock+0x40/0x90
 [<ffffffff95139f94>] ? tcp_recvmsg+0x4b4/0xae0
 [<ffffffffc0a02714>] ? ceph_encrypt2+0x54/0xc0 [libceph]
 [<ffffffffc0a02b4d>] ? ceph_x_encrypt+0x5d/0x90 [libceph]
 [<ffffffffc0a02bdf>] ? calcu_signature+0x5f/0x90 [libceph]
 [<ffffffffc0a02ef5>] ? ceph_x_sign_message+0x35/0x50 [libceph]
 [<ffffffffc09e948c>] ? prepare_write_message_footer+0x5c/0xa0 [libceph]
 [<ffffffffc09ecd18>] ? ceph_con_workfn+0x2258/0x2dd0 [libceph]
 [<ffffffffc09e9903>] ? queue_con_delay+0x33/0xd0 [libceph]
 [<ffffffffc09f68ed>] ? __submit_request+0x20d/0x2f0 [libceph]
 [<ffffffffc09f6ef8>] ? ceph_osdc_start_request+0x28/0x30 [libceph]
 [<ffffffffc0b52603>] ? rbd_queue_workfn+0x2f3/0x350 [rbd]
 [<ffffffff94c94ec0>] ? process_one_work+0x160/0x410
 [<ffffffff94c951bd>] ? worker_thread+0x4d/0x480
 [<ffffffff94c95170>] ? process_one_work+0x410/0x410
 [<ffffffff94c9af8d>] ? kthread+0xcd/0xf0
 [<ffffffff951efb2f>] ? ret_from_fork+0x1f/0x40
 [<ffffffff94c9aec0>] ? kthread_create_on_node+0x190/0x190

3. This causes the XFS shrinker to not make any progress, also blocking
other tasks that are trying to free memory this way.

xz              D ffff92303f358180     0  5932   5928 0x00000084
 ffff921a56201180 ffff923038f8ae00 ffff92303788b2c8 0000000000000001
 ffff921e90234000 ffff921e90233820 ffff923036b14eac ffff921a56201180
 00000000ffffffff ffff923036b14eb0 ffffffff951eb4e1 ffff923036b14ea8
Call Trace:
 [<ffffffff951eb4e1>] ? schedule+0x31/0x80
 [<ffffffff951eb77a>] ? schedule_preempt_disabled+0xa/0x10
 [<ffffffff951ed1f4>] ? __mutex_lock_slowpath+0xb4/0x130
 [<ffffffff951ed28b>] ? mutex_lock+0x1b/0x30
 [<ffffffffc0a974b3>] ? xfs_reclaim_inodes_ag+0x233/0x2d0 [xfs]
 [<ffffffff94f2b985>] ? radix_tree_gang_lookup_tag+0xc5/0x1c0
 [<ffffffff94dad0f3>] ? __list_lru_walk_one.isra.3+0x33/0x120
 [<ffffffffc0a98331>] ? xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
 [<ffffffff94e05bfe>] ? super_cache_scan+0x17e/0x190
 [<ffffffff94d919f3>] ? shrink_slab.part.38+0x1e3/0x3d0
 [<ffffffff94d9616a>] ? shrink_node+0x10a/0x320
 [<ffffffff94d96474>] ? do_try_to_free_pages+0xf4/0x350
 [<ffffffff94d967ba>] ? try_to_free_pages+0xea/0x1b0
 [<ffffffff94d863bd>] ? __alloc_pages_nodemask+0x61d/0xe60
 [<ffffffff94dd73b1>] ? alloc_pages_current+0x91/0x140
 [<ffffffff94e0ab98>] ? pipe_write+0x208/0x3f0
 [<ffffffff94e01b08>] ? new_sync_write+0xd8/0x130
 [<ffffffff94e02293>] ? vfs_write+0xb3/0x1a0
 [<ffffffff94e03672>] ? SyS_write+0x52/0xc0
 [<ffffffff94c03b8a>] ? do_syscall_64+0x7a/0xd0
 [<ffffffff951ef9a5>] ? entry_SYSCALL64_slow_path+0x25/0x25


This might be the same issue as in
http://tracker.ceph.com/issues/15891 ,but as the backtraces there are
from an older kernel version it's not really clear.

Regards,
Lucas

