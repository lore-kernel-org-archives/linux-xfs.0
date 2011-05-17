Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4HEc1Vd188659 for <xfs@oss.sgi.com>; Tue, 17 May 2011 09:38:01 -0500
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7343345D7A7
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 07:38:00 -0700 (PDT)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id AXsIDRLfg8aW2XK8
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 07:38:00 -0700 (PDT)
Received: by qwb7 with SMTP id 7so328304qwb.26
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 07:37:59 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 May 2011 10:37:59 -0400
Message-ID: <BANLkTinyaam3pFub7QD4Xi=tn8WvFfmqJw@mail.gmail.com>
Subject: xfs deadlock during reclaim in _xfs_trans_alloc?
From: Peter Watkins <treestem@gmail.com>
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

Greetings,

I think I've hit another case when reclaim recurses into xfs and deadlocks.

The system was under memory pressure and an fsync() call sent xfs into
reclaim which blocked on the prune_icache mutex while holding an xfs
inode buffer lock. Another thread, also in reclaim, held the
prune_icache mutex but needed that xfs inode buffer lock to make
progress.

Perhaps _xfs_trans_alloc should not recurse into the filesystem if its
allocation goes into reclaim? Should it say:

       tp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP|KM_NOFS);

I'll send a proposed patch in a second. (I'm on 2.6.27, but the patch
will be against latest)

--Peter


Here are the stacks:

PID: 8487   TASK: f3133ed0  CPU: 4   COMMAND: "postmaster"
 #0 [f32c9c44] schedule at c03abd22
 #1 [f32c9ca0] __mutex_lock_slowpath at c03ac8d1
 #2 [f32c9cc8] mutex_lock at c03ac78d
 #3 [f32c9cd0] prune_icache at c01d437f
 #4 [f32c9cf8] shrink_icache_memory at c01d4537
 #5 [f32c9d00] shrink_slab at c0198e57
 #6 [f32c9d4c] do_try_to_free_pages at c019a698
 #7 [f32c9d84] try_to_free_pages at c019a867
 #8 [f32c9dd4] __alloc_pages_internal at c0194112
 #9 [f32c9e20] allocate_slab at c01b8040
#10 [f32c9e40] new_slab at c01b8122
#11 [f32c9e60] __slab_alloc at c01b8769
#12 [f32c9e80] kmem_cache_alloc at c01b88dd
#13 [f32c9ea0] kmem_zone_alloc at f8e02a09 [xfs]
#14 [f32c9ec4] kmem_zone_zalloc at f8e02a58 [xfs]
#15 [f32c9ed8] _xfs_trans_alloc at f8df8104 [xfs] <==== should use KM_NOFS?
#16 [f32c9ee8] xfs_trans_alloc at f8df80cb [xfs]
#17 [f32c9f40] xfs_fsync at f8dfd8a6 [xfs]
#18 [f32c9f68] xfs_file_fsync at f8e07582 [xfs]
#19 [f32c9f7c] do_fsync at c01e2e15
#20 [f32c9f98] __do_fsync at c01e2e7a
#21 [f32c9fac] sys_fsync at c01e2ead
#22 [f32c9fb4] ia32_sysenter_target at c0109d6c

PID: 19589  TASK: d65e8000  CPU: 4   COMMAND: "calcer"
 #0 [d8b7b548] schedule at c03abd22
 #1 [d8b7b5a4] schedule_timeout at c03ac4ec
 #2 [d8b7b5ec] __down at c03acc9a
 #3 [d8b7b610] down at c015690c
 #4 [d8b7b620] xfs_buf_lock at f8e05a02 [xfs] <=== needs xfs_buf lock
 #5 [d8b7b62c] _xfs_buf_find at f8e05374 [xfs]
 #6 [d8b7b660] xfs_buf_get_flags at f8e05447 [xfs]
 #7 [d8b7b688] xfs_buf_read_flags at f8e0554d [xfs]
 #8 [d8b7b6a0] xfs_trans_read_buf at f8dfa4d5 [xfs]
 #9 [d8b7b6c8] xfs_alloc_read_agfl at f8dab69f [xfs]
#10 [d8b7b708] xfs_alloc_fix_freelist at f8dad28c [xfs]
#11 [d8b7b7b0] xfs_free_extent at f8dadec7 [xfs]
#12 [d8b7b848] xfs_bmap_finish at f8dbfd6e [xfs]
#13 [d8b7b880] xfs_itruncate_finish at f8de1687 [xfs]
#14 [d8b7b904] xfs_inactive at f8dfe887 [xfs]
#15 [d8b7b950] xfs_fs_clear_inode at f8e0d885 [xfs]
#16 [d8b7b970] clear_inode at c01d4099
#17 [d8b7b980] generic_delete_inode at c01d4ecd
#18 [d8b7b994] generic_drop_inode at c01d50af
#19 [d8b7b99c] iput at c01d5115
#20 [d8b7b9a8] gridfs_read_inode at f8e7064a [gridfs]
#21 [d8b7ba88] do_try_to_free_pages at c019a698 <==== holds iprune_mutex
#22 [d8b7bac0] try_to_free_pages at c019a867
#23 [d8b7bb10] __alloc_pages_internal at c0194112
#24 [d8b7bb5c] allocate_slab at c01b8040
#25 [d8b7bb7c] new_slab at c01b8122
#26 [d8b7bb9c] __slab_alloc at c01b8769
#27 [d8b7bbbc] kmem_cache_alloc at c01b88dd
#28 [d8b7bbdc] mem_cgroup_charge_common at c01bc5c3
#29 [d8b7bc0c] mem_cgroup_charge at c01bc7e1
#30 [d8b7bc20] do_anonymous_page at c01a2676
#31 [d8b7bc7c] handle_mm_fault at c01a324d
#32 [d8b7bcf4] do_page_fault at c03afd1c

I *think* the fsync thread holds that xfs_buf lock, but I haven't verified it.
There is only one other thread in xfs, here:

PID: 19084  TASK: dd8a8c90  CPU: 4   COMMAND: "postmaster"
 #0 [e8aed9c4] schedule at c03abd22
 #1 [e8aeda20] __mutex_lock_slowpath at c03ac8d1
 #2 [e8aeda48] mutex_lock at c03ac78d
 #3 [e8aeda50] prune_icache at c01d437f
 #4 [e8aeda78] shrink_icache_memory at c01d4537
 #5 [e8aeda80] shrink_slab at c0198e57
 #6 [e8aedacc] do_try_to_free_pages at c019a698
 #7 [e8aedb04] try_to_free_pages at c019a867
 #8 [e8aedb54] __alloc_pages_internal at c0194112
 #9 [e8aedba0] allocate_slab at c01b8040
#10 [e8aedbc0] new_slab at c01b8122
#11 [e8aedbe0] __slab_alloc at c01b8769
#12 [e8aedc00] kmem_cache_alloc at c01b88dd
#13 [e8aedc20] radix_tree_preload at c0269c1a
#14 [e8aedc38] add_to_page_cache_locked at c018e2bf
#15 [e8aedc54] add_to_page_cache_lru at c018e39f
#16 [e8aedc68] mpage_readpages at c01ecd10
#17 [e8aedce4] xfs_vm_readpages at f8e04b89 [xfs]
#18 [e8aedcf0] read_pages at c01972e8
#19 [e8aedd10] __do_page_cache_readahead at c01973a0
#20 [e8aedd40] ra_submit at c0197578
#21 [e8aedd58] ondemand_readahead at c01976c7
#22 [e8aedd7c] page_cache_async_readahead at c019780e
#23 [e8aedd9c] do_generic_file_read at c018efe6
#24 [e8aeddf4] generic_file_aio_read at c018f297
#25 [e8aede40] xfs_read at f8e0b134 [xfs]
#26 [e8aede90] xfs_file_aio_read at f8e071c9 [xfs]
#27 [e8aedebc] do_sync_read at c01bf2e7
#28 [e8aedf70] vfs_read at c01bf3d0
#29 [e8aedf94] sys_read at c01bf77d

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
