Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ODORVA149102 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 08:24:27 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yaDUQdGf6Px8qjM6 for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 06:25:42 -0700 (PDT)
Date: Mon, 24 Sep 2012 23:25:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
Message-ID: <20120924132519.GM20960@dastard>
References: <20120919163133.097340199@sgi.com> <20120919233435.GF31501@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120919233435.GF31501@dastard>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

On Thu, Sep 20, 2012 at 09:34:35AM +1000, Dave Chinner wrote:
> On Wed, Sep 19, 2012 at 11:31:33AM -0500, tinguely@sgi.com wrote:
> > We have experience file system hangs on the IA64, X86_32 and X86_64
> > environments caused by a deadlock on AGF buffers.
> > 
> > The below stack frames is a simple example of the deadlock. This example
> > was taken from the current OSS Linux 3.6 sources on a x86_32 machine that
> > was suffering from a daemon storm at the time:
> 
> I hit it last night via test 113 on a RHEL6 backport that has the
> old workqueue implementation and so only has one worker per CPU.
.....
> > I traced the callers of xfs_alloc_vextent(), noting transaction creation,
> > commits and cancels; I noted loops in the callers and which were marked
> > as metadata/userdata. I can send this document to reviewers.
> 
> No need, I can see the (generic) problem now that it has been
> pointed out.
> 
> Basically, this is what the rescuer thread is kind of for - it works
> around the inability to allocate a new worker thread due to a OOM
> situation. This doesn't help us here because that rescuer would
> simply block like the others. Hence a rescuer thread concept doesn't
> solve the problem at all.
> 
> So lets go back to the case at hand. We block because this is the
> first attempt to lock the AGF in an allocation, and the
> XFS_ALLOC_FLAG_TRYLOCK flag is not set. This indicates we are asking
> for allocation in a specific AG from __xfs_alloc_vextent(), and we
> can't do that until some other allocation completes. Given that AGF
> locking orders are strictly enforced, we know that the holder of the
> AGF will not deadlock as long as it can be scheduled to run.
> 
> IOWs, it is not safe to block forever on a lock in a worker thread
> when there are outside dependencies on that lock being released to
> make progress. To me that's not really a deadlock in the traditional
> sense - it's more akin to a priority inversion that prevents the
> resource holder from making progress. i.e. blocked threads hold the
> worker resources, which prevent the lock holder from being able to
> run and release the lock.
> 
> Hmmm. I think there are other ways to trigger this as well.
> Anything that holds the AGF locked for a period of time is going to
> cause allocations to back up like this, regardless of whether we
> queue at xfs_alloc_vexent() or xfs_bmapi_write(). For example,
> FITRIM holds the AGF locked for as long as it takes to issue all the
> discard operations. That could stall enough allocations to run us
> out of worker threads and hence effectively stop data allocations
> from being run for some period of time. It won't deadlock, but it
> certainly is sub-optimal behaviour.
> 
> I suspect the only way to fix this is to re-use the old workqueue
> method of avoiding blocking on the workqueue indefinitely. That is,
> if we fail to get the lock in this case, we return with EGAIN and
> requeue the work. __xfs_alloc_vextent() and xfs_alloc_fix_freelist()
> already have trylock support, so this should be fairly easy to do.
> If I also convert the work to delayed work, I can easily add a
> backoff that will prevent busy looping on the workqueue.
> 
> I'll have a quick look at this and see what falls out....

Here's what fell out. I've smoke tested it on a couple of different
machines with xfstests, and all seems fine so far.

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
 fs/xfs/xfs_alloc.c |   65 +++++++++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_alloc.h |    3 ++-
 2 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 4f33c32..37cd31d 100644
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
@@ -2208,7 +2208,8 @@ xfs_alloc_read_agf(
  */
 int				/* error */
 __xfs_alloc_vextent(
-	xfs_alloc_arg_t	*args)	/* allocation argument structure */
+	xfs_alloc_arg_t	*args,
+	bool		trylock)
 {
 	xfs_agblock_t	agsize;	/* allocation group size */
 	int		error;
@@ -2249,6 +2250,7 @@ __xfs_alloc_vextent(
 	}
 	minleft = args->minleft;
 
+	flags = trylock ? XFS_ALLOC_FLAG_TRYLOCK : 0;
 	switch (type) {
 	case XFS_ALLOCTYPE_THIS_AG:
 	case XFS_ALLOCTYPE_NEAR_BNO:
@@ -2259,7 +2261,7 @@ __xfs_alloc_vextent(
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 		args->pag = xfs_perag_get(mp, args->agno);
 		args->minleft = 0;
-		error = xfs_alloc_fix_freelist(args, 0);
+		error = xfs_alloc_fix_freelist(args, flags);
 		args->minleft = minleft;
 		if (error) {
 			trace_xfs_alloc_vextent_nofix(args);
@@ -2309,7 +2311,7 @@ __xfs_alloc_vextent(
 			args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 			args->type = XFS_ALLOCTYPE_THIS_AG;
 			sagno = 0;
-			flags = 0;
+			flags |= XFS_ALLOC_FLAG_TRYHARD;
 		} else {
 			if (type == XFS_ALLOCTYPE_START_AG)
 				args->type = XFS_ALLOCTYPE_THIS_AG;
@@ -2328,7 +2330,7 @@ __xfs_alloc_vextent(
 			if (no_min) args->minleft = 0;
 			error = xfs_alloc_fix_freelist(args, flags);
 			args->minleft = minleft;
-			if (error) {
+			if (error && error != EAGAIN) {
 				trace_xfs_alloc_vextent_nofix(args);
 				goto error0;
 			}
@@ -2374,8 +2376,16 @@ __xfs_alloc_vextent(
 				}
 				if (flags == 0) {
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
@@ -2417,28 +2427,45 @@ error0:
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
@@ -2446,13 +2473,13 @@ xfs_alloc_vextent(
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
