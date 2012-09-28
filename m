Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S37Wqb168361 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 22:07:32 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lHKc0J0d2dAYqzWU for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 20:08:50 -0700 (PDT)
Date: Fri, 28 Sep 2012 13:08:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
Message-ID: <20120928030847.GC25626@dastard>
References: <20120924171159.GG1140@sgi.com>
	<201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
	<20120925005632.GB23520@dastard> <5061CA48.3040202@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5061CA48.3040202@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Tue, Sep 25, 2012 at 10:14:16AM -0500, Mark Tinguely wrote:
> On 09/24/12 19:56, Dave Chinner wrote:
> >On Mon, Sep 24, 2012 at 01:09:04PM -0500, Mark Tinguely wrote:
> Your patch hangs when limiting the available workers on test 109 on
> the 3 machines (2 x86_64 and a x86_32) that I tried it on. I am
> trying a fourth machine to be sure.

Update version attached - it was just a loop exit case that didn't
work, and that case is only triggered on xbf_low allocations (i.e.
ENOSPC).

It doesn't cause any problems here on 3.6-rc7 (combined with your
patch 3), and the two patches also fix the same hangs on my RHEL
test kernels that only have one worker thread per CPU.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: don't block xfs_alloc_wq on AGF locks

From: Dave Chinner <dchinner@redhat.com>

When the workqueue runs out of worker threads because all the
allocations are blockd on the AGF lock, the AGF lock holder cannot
run to complete the allocation transaction that will unlock the AGF.
As a result, allocations stop making progress.  Raising the
workqueue concurrency limit does not solve the problem, just raises
the number of allocations that need to block before we hit the
starvation issue.

To avoid workqueue starvation, instead of blocking on the AGF lock
only try to lock the AGF when caled from worker thread context. If
we fail to get the lock on all the AGs we are allowed to try, return
an EAGAIN error and have the worker requeue the allocation work for
a short time in the future when progress has been made. Because we
no longer block worker threads, we avoid the issue of starving
allocations requests of service and hence will always make progress.

Because the trylock semantics are now slightly different, add a
"try-harder" flag to ensure that we avoid conflating the new
"trylock" with the existing "avoid allocating data in a metadata
prefered AG" semantics. The "try-harder" flag is now used to
indicate data allocation in metadata-preferred AGs is allowed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |   68 ++++++++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_alloc.h |    3 ++-
 2 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 0287f3b..57fad5f 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1764,9 +1764,9 @@ xfs_alloc_fix_freelist(
 	xfs_trans_t	*tp;	/* transaction pointer */
 
 	mp = args->mp;
-
 	pag = args->pag;
 	tp = args->tp;
+
 	if (!pag->pagf_init) {
 		if ((error = xfs_alloc_read_agf(mp, tp, args->agno, flags,
 				&agbp)))
@@ -1775,7 +1775,7 @@ xfs_alloc_fix_freelist(
 			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
 			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
 			args->agbp = NULL;
-			return 0;
+			return EAGAIN;
 		}
 	} else
 		agbp = NULL;
@@ -1786,7 +1786,7 @@ xfs_alloc_fix_freelist(
 	 * try harder at this point
 	 */
 	if (pag->pagf_metadata && args->userdata &&
-	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
+	    (flags & XFS_ALLOC_FLAG_TRYHARD)) {
 		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
 		args->agbp = NULL;
 		return 0;
@@ -1822,7 +1822,7 @@ xfs_alloc_fix_freelist(
 			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
 			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
 			args->agbp = NULL;
-			return 0;
+			return EAGAIN;
 		}
 	}
 	/*
@@ -2209,7 +2209,8 @@ xfs_alloc_read_agf(
  */
 int				/* error */
 __xfs_alloc_vextent(
-	xfs_alloc_arg_t	*args)	/* allocation argument structure */
+	xfs_alloc_arg_t	*args,
+	bool		trylock)
 {
 	xfs_agblock_t	agsize;	/* allocation group size */
 	int		error;
@@ -2250,6 +2251,7 @@ __xfs_alloc_vextent(
 	}
 	minleft = args->minleft;
 
+	flags = trylock ? XFS_ALLOC_FLAG_TRYLOCK : 0;
 	switch (type) {
 	case XFS_ALLOCTYPE_THIS_AG:
 	case XFS_ALLOCTYPE_NEAR_BNO:
@@ -2260,7 +2262,7 @@ __xfs_alloc_vextent(
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 		args->pag = xfs_perag_get(mp, args->agno);
 		args->minleft = 0;
-		error = xfs_alloc_fix_freelist(args, 0);
+		error = xfs_alloc_fix_freelist(args, flags);
 		args->minleft = minleft;
 		if (error) {
 			trace_xfs_alloc_vextent_nofix(args);
@@ -2310,7 +2312,8 @@ __xfs_alloc_vextent(
 			args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 			args->type = XFS_ALLOCTYPE_THIS_AG;
 			sagno = 0;
-			flags = 0;
+			trylock = 0;
+			flags |= XFS_ALLOC_FLAG_TRYHARD;
 		} else {
 			if (type == XFS_ALLOCTYPE_START_AG)
 				args->type = XFS_ALLOCTYPE_THIS_AG;
@@ -2329,7 +2332,7 @@ __xfs_alloc_vextent(
 			if (no_min) args->minleft = 0;
 			error = xfs_alloc_fix_freelist(args, flags);
 			args->minleft = minleft;
-			if (error) {
+			if (error && error != EAGAIN) {
 				trace_xfs_alloc_vextent_nofix(args);
 				goto error0;
 			}
@@ -2373,10 +2376,18 @@ __xfs_alloc_vextent(
 					trace_xfs_alloc_vextent_allfailed(args);
 					break;
 				}
-				if (flags == 0) {
+				if (flags == XFS_ALLOC_FLAG_TRYHARD) {
 					no_min = 1;
+				} else if (trylock &&
+					 flags == XFS_ALLOC_FLAG_TRYLOCK) {
+					flags |= XFS_ALLOC_FLAG_TRYHARD;
+				} else if (trylock &&
+					   (flags & XFS_ALLOC_FLAG_TRYHARD)) {
+					error = EAGAIN;
+					trace_xfs_alloc_vextent_noagbp(args);
+					goto error0;
 				} else {
-					flags = 0;
+					flags = XFS_ALLOC_FLAG_TRYHARD;
 					if (type == XFS_ALLOCTYPE_START_BNO) {
 						args->agbno = XFS_FSB_TO_AGBNO(mp,
 							args->fsbno);
@@ -2418,28 +2429,45 @@ error0:
 	return error;
 }
 
+/*
+ * The worker is not allowed to block indefinitely on AGF locks. This prevents
+ * worker thread starvation from preventing allocation progress from being made.
+ * This occurs when the transaction holding the AGF cannot be scheduled to run
+ * in a worker because all worker threads are blocked on the AGF lock and no
+ * more can be allocated.
+ */
 static void
 xfs_alloc_vextent_worker(
 	struct work_struct	*work)
 {
-	struct xfs_alloc_arg	*args = container_of(work,
+	struct delayed_work	*dwork = container_of(work,
+						struct delayed_work, work);
+	struct xfs_alloc_arg	*args = container_of(dwork,
 						struct xfs_alloc_arg, work);
 	unsigned long		pflags;
+	int			result;
 
 	/* we are in a transaction context here */
 	current_set_flags_nested(&pflags, PF_FSTRANS);
 
-	args->result = __xfs_alloc_vextent(args);
-	complete(args->done);
+	result = __xfs_alloc_vextent(args, true);
+	if (result == EAGAIN) {
+		/* requeue for a later retry */
+		queue_delayed_work(xfs_alloc_wq, &args->work,
+				   msecs_to_jiffies(10));
+	} else {
+		args->result = result;
+		complete(args->done);
+	}
 
 	current_restore_flags_nested(&pflags, PF_FSTRANS);
 }
 
 /*
  * Data allocation requests often come in with little stack to work on. Push
- * them off to a worker thread so there is lots of stack to use. Metadata
- * requests, OTOH, are generally from low stack usage paths, so avoid the
- * context switch overhead here.
+ * them off to a worker thread so there is lots of stack to use if we are not
+ * already in a worker thread context. Metadata requests, OTOH, are generally
+ * from low stack usage paths, so avoid the context switch overhead here.
  */
 int
 xfs_alloc_vextent(
@@ -2447,13 +2475,13 @@ xfs_alloc_vextent(
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 
-	if (!args->userdata)
-		return __xfs_alloc_vextent(args);
+	if (!args->userdata || (current->flags & PF_WQ_WORKER))
+		return __xfs_alloc_vextent(args, false);
 
 
 	args->done = &done;
-	INIT_WORK_ONSTACK(&args->work, xfs_alloc_vextent_worker);
-	queue_work(xfs_alloc_wq, &args->work);
+	INIT_DELAYED_WORK_ONSTACK(&args->work, xfs_alloc_vextent_worker);
+	queue_delayed_work(xfs_alloc_wq, &args->work, 0);
 	wait_for_completion(&done);
 	return args->result;
 }
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 93be4a6..047a239 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -54,6 +54,7 @@ typedef unsigned int xfs_alloctype_t;
  */
 #define	XFS_ALLOC_FLAG_TRYLOCK	0x00000001  /* use trylock for buffer locking */
 #define	XFS_ALLOC_FLAG_FREEING	0x00000002  /* indicate caller is freeing extents*/
+#define XFS_ALLOC_FLAG_TRYHARD	0x00000004  /* also use metadata AGs for data */
 
 /*
  * In order to avoid ENOSPC-related deadlock caused by
@@ -121,7 +122,7 @@ typedef struct xfs_alloc_arg {
 	char		userdata;	/* set if this is user data */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
 	struct completion *done;
-	struct work_struct work;
+	struct delayed_work work;
 	int		result;
 } xfs_alloc_arg_t;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
