Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q224DHqN241492 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 22:13:17 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Fiq6rtMeq4ILo06y for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 20:13:15 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S3Jrj-0006Fy-4P
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:13:11 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S3JqT-0000J3-JA
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: introduce an allocation workqueue
Date: Fri,  2 Mar 2012 15:11:44 +1100
Message-Id: <1330661507-1121-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1330661507-1121-1-git-send-email-david@fromorbit.com>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_alloc.c |   34 +++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_alloc.h |    5 +++++
 fs/xfs/xfs_super.c |   16 ++++++++++++++++
 3 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index ce84ffd..31e9033 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -35,6 +35,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
+struct workqueue_struct *xfs_alloc_wq;
 
 #define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
 
@@ -2207,7 +2208,7 @@ xfs_alloc_read_agf(
  * group or loop over the allocation groups to find the result.
  */
 int				/* error */
-xfs_alloc_vextent(
+__xfs_alloc_vextent(
 	xfs_alloc_arg_t	*args)	/* allocation argument structure */
 {
 	xfs_agblock_t	agsize;	/* allocation group size */
@@ -2417,6 +2418,37 @@ error0:
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
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5e0d43f..13fa0cf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1604,12 +1604,28 @@ xfs_init_workqueues(void)
 	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_NON_REENTRANT, 0);
 	if (!xfs_syncd_wq)
 		return -ENOMEM;
+
+	/*
+	 * The allocation workqueue can be used in memory reclaim situations
+	 * (writepage path), and parallelism is only limited by the number of
+	 * AGs in all the filesystems mounted. Hence use the default large
+	 * max_active value for this workqueue.
+	 */
+	xfs_alloc_wq = alloc_workqueue("xfsalloc", WQ_MEM_RECLAIM, 0);
+	if (!xfs_alloc_wq)
+		goto out_destroy_syncd;
+
 	return 0;
+
+out_destroy_syncd:
+	destroy_workqueue(xfs_syncd_wq);
+	return -ENOMEM;
 }
 
 STATIC void
 xfs_destroy_workqueues(void)
 {
+	destroy_workqueue(xfs_alloc_wq);
 	destroy_workqueue(xfs_syncd_wq);
 }
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
