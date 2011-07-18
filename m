Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6I3nwnV078332 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 22:49:58 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2486BECC732
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 20:49:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OaoZeMY0tag22RFV for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2011 20:49:56 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Qieq9-0008Cw-0d
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:49:53 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Qieq8-0002hV-P2
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:49:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: introduce an allocation workqueue
Date: Mon, 18 Jul 2011 13:49:47 +1000
Message-Id: <1310960989-10284-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1310960989-10284-1-git-send-email-david@fromorbit.com>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

We currently have significant issues with the amount of stack that
allocation in XFS uses, especially in the writeback path. We can
easily consume 4k of stack between mapping the page, manipulating
the bmap btree and allocating blocks from the free list. Not to
mention btree block readahead and other functionality that issues IO
in the allocation path.

As a result, we can no longer fit allocation in the writeback path
in the stack space provided on x86_64. To alleviate this problem,
introduce an allocation workqueue and move all allocations to a
seperate context. This can be easily added as an interposing layer
into xfs_alloc_vextent(), which takes a single argument structure
and does not return until the allocation is complete or has failed.

To do this, add a work structure and a completion to the allocation
args structure. This allows xfs_alloc_vextent to queue the args onto
the workqueue and wait for it to be completed by the worker. This
can be done completely transparently to the caller.

The worker function needs to ensure that it sets and clears the
PF_TRANS flag appropriately as it is being run in an active
transaction context. Work can also be queued in a memory reclaim
context, so a rescuer is needed for the workqueue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   13 +++++++++++++
 fs/xfs/xfs_alloc.c           |   34 +++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_alloc.h           |    5 +++++
 3 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 9a72dda..6a6d4d9 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1672,8 +1672,21 @@ xfs_init_workqueues(void)
 	if (!xfs_ail_wq)
 		goto out_destroy_syncd;
 
+	/*
+	 * The allocation workqueue can be used in memory reclaim situations
+	 * (writepage path), and parallelism is only limited by the number of
+	 * AGs in all the filesystems mounted. Hence maxactive is set very
+	 * high.
+	 */
+	xfs_alloc_wq = alloc_workqueue("xfsalloc",
+				WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 128);
+	if (!xfs_alloc_wq)
+		goto out_destroy_ail;
+
 	return 0;
 
+out_destroy_ail:
+	destroy_workqueue(xfs_ail_wq);
 out_destroy_syncd:
 	destroy_workqueue(xfs_syncd_wq);
 out:
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 1e00b3e..5883972 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -35,6 +35,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
+struct workqueue_struct *xfs_alloc_wq;
 
 #define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
 
@@ -2208,7 +2209,7 @@ xfs_alloc_read_agf(
  * group or loop over the allocation groups to find the result.
  */
 int				/* error */
-xfs_alloc_vextent(
+__xfs_alloc_vextent(
 	xfs_alloc_arg_t	*args)	/* allocation argument structure */
 {
 	xfs_agblock_t	agsize;	/* allocation group size */
@@ -2418,6 +2419,37 @@ error0:
 	return error;
 }
 
+static void
+xfs_alloc_vextent_worker(
+	struct work_struct	*work)
+{
+	struct xfs_alloc_arg	*args = container_of(work,
+						struct xfs_alloc_arg, work);
+	unsigned long		pflags;
+
+	/* we are in a transaction context here */
+	current_set_flags_nested(&pflags, PF_FSTRANS);
+
+	args->result = __xfs_alloc_vextent(args);
+	complete(args->done);
+
+	current_restore_flags_nested(&pflags, PF_FSTRANS);
+}
+
+
+int				/* error */
+xfs_alloc_vextent(
+	xfs_alloc_arg_t	*args)	/* allocation argument structure */
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	args->done = &done;
+	INIT_WORK(&args->work, xfs_alloc_vextent_worker);
+	queue_work(xfs_alloc_wq, &args->work);
+	wait_for_completion(&done);
+	return args->result;
+}
+
 /*
  * Free an extent.
  * Just break up the extent address and hand off to xfs_free_ag_extent
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 2f52b92..ab5d0fd 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -25,6 +25,8 @@ struct xfs_perag;
 struct xfs_trans;
 struct xfs_busy_extent;
 
+extern struct workqueue_struct *xfs_alloc_wq;
+
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
@@ -119,6 +121,9 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* set if this is user data */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
+	struct completion *done;
+	struct work_struct work;
+	int		result;
 } xfs_alloc_arg_t;
 
 /*
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
