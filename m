Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DBCCC7F4E
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 12:02:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77569AC006
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 10:02:00 -0800 (PST)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id gBqhFIighi6gVFoO
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Nov 2015 10:01:58 -0800 (PST)
Date: Tue, 10 Nov 2015 13:01:50 -0500
From: Chris Mason <clm@fb.com>
Subject: [PATCH v2] xfs: use WQ_MEM_RECLAIM for m_log_workqueue
Message-ID: <20151110180150.GD26661@ret.masoncoding.com>
References: <20151104185103.GC5458@ret.masoncoding.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151104185103.GC5458@ret.masoncoding.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, Tejun Heo <htejun@fb.com>

We're consistently hitting deadlocks here with XFS on recent kernels.
After some digging through the crash files, it looks like everyone in
the system is waiting for XFS to reclaim memory.

Something like this:

PID: 2733434  TASK: ffff8808cd242800  CPU: 19  COMMAND: "java"
0 [ffff88082d093368] __schedule at ffffffff818c4df2
1 [ffff88082d0933b8] schedule at ffffffff818c5517
2 [ffff88082d0933d8] schedule_timeout at ffffffff818c7c6c
3 [ffff88082d093478] wait_for_completion at ffffffff818c6125
4 [ffff88082d0934d8] flush_work at ffffffff8106867c
5 [ffff88082d093548] xlog_cil_force_lsn at ffffffff81317b00
6 [ffff88082d0935f8] _xfs_log_force_lsn at ffffffff81316249
7 [ffff88082d093688] xfs_log_force_lsn at ffffffff813164fb
8 [ffff88082d0936b8] xfs_iunpin_wait at ffffffff8130835e
9 [ffff88082d093728] xfs_reclaim_inode at ffffffff812fd453
10 [ffff88082d093778] xfs_reclaim_inodes_ag at ffffffff812fd8c7
11 [ffff88082d093928] xfs_reclaim_inodes_nr at ffffffff812fe433
12 [ffff88082d093958] xfs_fs_free_cached_objects at ffffffff8130d3b9
13 [ffff88082d093968] super_cache_scan at ffffffff811a6f73
14 [ffff88082d0939c8] shrink_slab at ffffffff811460e6
15 [ffff88082d093aa8] shrink_zone at ffffffff8114a53f
16 [ffff88082d093b48] do_try_to_free_pages at ffffffff8114a8ba
17 [ffff88082d093be8] try_to_free_pages at ffffffff8114ad5a
18 [ffff88082d093c78] __alloc_pages_nodemask at ffffffff8113e1b8
19 [ffff88082d093d88] alloc_kmem_pages_node at ffffffff8113e671
20 [ffff88082d093dd8] copy_process at ffffffff8104f781
21 [ffff88082d093ec8] do_fork at ffffffff8105129c
22 [ffff88082d093f38] sys_clone at ffffffff810515b6
23 [ffff88082d093f48] stub_clone at ffffffff818c8e4d

xfs_log_force_lsn is waiting for logs to get cleaned, which is waiting
for IO, which is waiting for workers to complete the IO which is waiting
for worker threads that don't exist yet:

PID: 2752451  TASK: ffff880bd6bdda00  CPU: 37  COMMAND: "kworker/37:1"
0 [ffff88000394fbb0] __schedule at ffffffff818c4df2
1 [ffff88000394fc00] schedule at ffffffff818c5517
2 [ffff88000394fc20] schedule_timeout at ffffffff818c7c6c
3 [ffff88000394fcc0] wait_for_completion_killable at ffffffff818c6495
4 [ffff88000394fd30] kthread_create_on_node at ffffffff8106ec82
5 [ffff88000394fdf0] create_worker at ffffffff8106752f
6 [ffff88000394fe40] worker_thread at ffffffff810699be
7 [ffff88000394fec0] kthread at ffffffff8106ef59
8 [ffff88000394ff50] ret_from_fork at ffffffff818c8ac8

I think we should be using WQ_MEM_RECLAIM to make sure this thread pool
makes progress when we're not able to allocate new workers.

While we are here, just assume that everything in the FS will eventually
wait on one of these workqueues, and flag them all for reclaim.

Signed-off-by: Chris Mason <clm@fb.com>
---
 v1 -> v2 add WQ_MEM_RECLAIM to xfs-reclaim and xfs-eofblocks too,
 fix commit text so git commit doesn't eat the stack traces

 fs/xfs/xfs_super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 904f637..d74d7e1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -838,17 +838,18 @@ xfs_init_mount_workqueues(
 		goto out_destroy_unwritten;
 
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
-			WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
 	mp->m_log_workqueue = alloc_workqueue("xfs-log/%s",
-			WQ_FREEZABLE|WQ_HIGHPRI, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE|WQ_HIGHPRI,
+			0, mp->m_fsname);
 	if (!mp->m_log_workqueue)
 		goto out_destroy_reclaim;
 
 	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
-			WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_eofblocks_workqueue)
 		goto out_destroy_log;
 
-- 
2.4.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
