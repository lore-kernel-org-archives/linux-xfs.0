Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JGXt09220172 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 11:33:55 -0500
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5DF33304082
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 09:35:04 -0700 (PDT)
Message-Id: <20120919163133.097340199@sgi.com>
Date: Wed, 19 Sep 2012 11:31:33 -0500
From: tinguely@sgi.com
Subject: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock hang 
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We have experience file system hangs on the IA64, X86_32 and X86_64
environments caused by a deadlock on AGF buffers.

The below stack frames is a simple example of the deadlock. This example
was taken from the current OSS Linux 3.6 sources on a x86_32 machine that
was suffering from a daemon storm at the time:

The holder of the lock:

PID: 11601  TASK: d29dadb0  CPU: 3   COMMAND: "kworker/3:3"
 #0 [c8ea57bc] __schedule at c068a7e8
 #1 [c8ea5844] schedule at c068abd9
 #2 [c8ea584c] schedule_timeout at c0689808
 #3 [c8ea58b0] wait_for_common at c068a436
 #4 [c8ea58e8] wait_for_completion at c068a54d
 #5 [c8ea58f0] xfs_alloc_vextent at e1ed8f63 [xfs]
 #6 [c8ea590c] xfs_bmap_btalloc at e1ee4124 [xfs]
 #7 [c8ea59dc] xfs_bmap_alloc at e1ee42f5 [xfs]
 #8 [c8ea59e4] xfs_bmapi_allocate at e1ef0ae9 [xfs]
 #9 [c8ea5a14] xfs_bmapi_write at e1ef13a7 [xfs]
#10 [c8ea5b18] xfs_iomap_write_allocate at e1ec7e93 [xfs]
#11 [c8ea5bac] xfs_map_blocks at e1eb795d [xfs]
#12 [c8ea5c08] xfs_vm_writepage at e1eb88d9 [xfs]
#13 [c8ea5c64] find_get_pages_tag at c02df2a2
#14 [c8ea5c9c] __writepage at c02e6769
#15 [c8ea5ca8] write_cache_pages at c02e6f8c
#16 [c8ea5d48] generic_writepages at c02e7212
#17 [c8ea5d78] xfs_vm_writepages at e1eb6c5a [xfs]
#18 [c8ea5d8c] do_writepages at c02e7f4a
#19 [c8ea5d98] __filemap_fdatawrite_range at c02e046a
#20 [c8ea5dc4] filemap_fdatawrite_range at c02e0fb1
#21 [c8ea5de0] xfs_flush_pages at e1ec32e9 [xfs]
#22 [c8ea5e0c] xfs_sync_inode_data at e1ecdd73 [xfs]
#23 [c8ea5e34] xfs_inode_ag_walk at e1ece0d6 [xfs]
#24 [c8ea5f00] xfs_inode_ag_iterator at e1ece23f [xfs]
#25 [c8ea5f28] xfs_sync_data at e1ece2ce [xfs]
#26 [c8ea5f38] xfs_flush_worker at e1ece31d [xfs]
#27 [c8ea5f44] process_one_work at c024e39d
#28 [c8ea5f88] process_scheduled_works at c024e6ad
#29 [c8ea5f98] worker_thread at c024f6cb
#30 [c8ea5fbc] kthread at c0253c1b
#31 [c8ea5fe8] kernel_thread_helper at c0692af4

The worker that is blocked waiting for the lock:

PID: 30223  TASK: dfb86cb0  CPU: 3   COMMAND: "xfsalloc"
 #0 [d4a45b9c] __schedule at c068a7e8
 #1 [d4a45c24] schedule at c068abd9
 #2 [d4a45c2c] schedule_timeout at c0689808
 #3 [d4a45c90] __down_common at c068a1d4
 #4 [d4a45cc0] __down at c068a25e
 #5 [d4a45cc8] down at c02598ff
 #6 [d4a45cd8] xfs_buf_lock at e1ebaa6d [xfs]
 #7 [d4a45cf8] _xfs_buf_find at e1ebad0e [xfs]
 #8 [d4a45d2c] xfs_buf_get_map at e1ebaf00 [xfs]
 #9 [d4a45d58] xfs_buf_read_map at e1ebbce3 [xfs]
#10 [d4a45d7c] xfs_trans_read_buf_map at e1f2974e [xfs]
#11 [d4a45dac] xfs_read_agf at e1ed7d2c [xfs]
#12 [d4a45dec] xfs_alloc_read_agf at e1ed7f2d [xfs]
#13 [d4a45e0c] xfs_alloc_fix_freelist at e1ed84f6 [xfs]
#14 [d4a45e4c] check_preempt_curr at c0261c47
#15 [d4a45e60] ttwu_do_wakeup at c0261c7e
#16 [d4a45e8c] radix_tree_lookup at c0465ab5
#17 [d4a45e94] xfs_perag_get at e1f19a36 [xfs]
#18 [d4a45ec8] __xfs_alloc_vextent at e1ed899d [xfs]
#19 [d4a45f1c] xfs_alloc_vextent_worker at e1ed8edb [xfs]
#20 [d4a45f30] process_one_work at c024e39d
#21 [d4a45f74] process_scheduled_works at c024e6ad
#22 [d4a45f84] rescuer_thread at c024e7f0
#23 [d4a45fbc] kthread at c0253c1b
#24 [d4a45fe8] kernel_thread_helper at c0692af

The AGF buffer can be locked across multiple calls to xfs_alloc_vextent().
This buffer must remained locked until the transaction is either committed or
canceled. The deadlock occurs when other callers of xfs_alloc_vextent() block
waiting for the AGF buffer lock and the workqueue manager cannot create another
allocate worker to service the allocation request for the process that holds
the lock, The default limit for the allocation worker is 256 workers and that
limit can be increased to 512, but lack of resources before this limit is the
real reason the workqueue manager cannot create another worker.

It is very easy to have a more than one AG hung in this manner simultaneously.

The locked AGF buffer and possibly the calling inode can be in the AIL. Since
they are locked, these items cannot be pushed. This prevents the tail from
moving; eventually the log space is depleted causing the whole filesystem to
hang.

Tests 109 and 119 seem to trigger this condition the easiest. To recreate the
problem, eat up the spare RAM (above hang was caused during a daemon storm)
or simply limit the number of allocation workers when running xfstests.

The solution to this problem is to move the allocation worker so that the
loops over xfs_alloc_vextent() for a single transaction, on non-metadata
paths will happen in a single worker.

I traced the callers of xfs_alloc_vextent(), noting transaction creation,
commits and cancels; I noted loops in the callers and which were marked
as metadata/userdata. I can send this document to reviewers.

Patch 1: limits the allocation worker to the X86_64 architectures.
        
Patch 2: moves the allocation worker so that loops to xfs_alloc_vextent()
	 for a transaction is contained in one worker. I have a document
	 that lists the callers of xfs_alloc_vextent() noting loops,
	 transaction allocations/commits and metadata callers.

Patch 3: zeros 2 uninitialized userdata variables.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
