Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9515f6a247248 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 20:05:41 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QOHaRrig5wV0pL6d for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 18:07:05 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TJwNa-0000bG-E2
	for xfs@oss.sgi.com; Fri, 05 Oct 2012 11:07:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TJwNa-0003P9-B8
	for xfs@oss.sgi.com; Fri, 05 Oct 2012 11:07:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: move allocation stack switch up to xfs_bmapi_allocate
Date: Fri,  5 Oct 2012 11:06:59 +1000
Message-Id: <1349399219-13024-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1349399219-13024-1-git-send-email-david@fromorbit.com>
References: <1349399219-13024-1-git-send-email-david@fromorbit.com>
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

Switching stacks are xfs_alloc_vextent can cause deadlocks when we
run out of worker threads on the allocation workqueue. This can
occur because xfs_bmap_btalloc can make multiple calls to
xfs_alloc_vextent() and even if xfs_alloc_vextent() fails it can
return with the AGF locked in the current allocation transaction.

If we then need to make another allocation, and all the allocation
worker contexts are exhausted because the are blocked waiting for
the AGF lock, holder of the AGF cannot get it's xfs-alloc_vextent
work completed to release the AGF.  Hence allocation effectively
deadlocks.

To avoid this, move the stack switch one layer up to
xfs_bmapi_allocate() so that all of the allocation attempts in a
single switched stack transaction occur in a single worker context.
This avoids the problem of an allocation being blocked waiting for
a worker thread whilst holding the AGF.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |   42 +-----------------------------------
 fs/xfs/xfs_alloc.h |    4 ----
 fs/xfs/xfs_bmap.c  |   60 ++++++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_bmap.h  |    4 ++++
 4 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 43f791b..335206a 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2208,7 +2208,7 @@ xfs_alloc_read_agf(
  * group or loop over the allocation groups to find the result.
  */
 int				/* error */
-__xfs_alloc_vextent(
+xfs_alloc_vextent(
 	xfs_alloc_arg_t	*args)	/* allocation argument structure */
 {
 	xfs_agblock_t	agsize;	/* allocation group size */
@@ -2418,46 +2418,6 @@ error0:
 	return error;
 }
 
-static void
-xfs_alloc_vextent_worker(
-	struct work_struct	*work)
-{
-	struct xfs_alloc_arg	*args = container_of(work,
-						struct xfs_alloc_arg, work);
-	unsigned long		pflags;
-
-	/* we are in a transaction context here */
-	current_set_flags_nested(&pflags, PF_FSTRANS);
-
-	args->result = __xfs_alloc_vextent(args);
-	complete(args->done);
-
-	current_restore_flags_nested(&pflags, PF_FSTRANS);
-}
-
-/*
- * Data allocation requests often come in with little stack to work on. Push
- * them off to a worker thread so there is lots of stack to use. Metadata
- * requests, OTOH, are generally from low stack usage paths, so avoid the
- * context switch overhead here.
- */
-int
-xfs_alloc_vextent(
-	struct xfs_alloc_arg	*args)
-{
-	DECLARE_COMPLETION_ONSTACK(done);
-
-	if (!args->stack_switch)
-		return __xfs_alloc_vextent(args);
-
-
-	args->done = &done;
-	INIT_WORK_ONSTACK(&args->work, xfs_alloc_vextent_worker);
-	queue_work(xfs_alloc_wq, &args->work);
-	wait_for_completion(&done);
-	return args->result;
-}
-
 /*
  * Free an extent.
  * Just break up the extent address and hand off to xfs_free_ag_extent
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index ef7d488..feacb06 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -120,10 +120,6 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* set if this is user data */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
-	struct completion *done;
-	struct work_struct work;
-	int		result;
-	char		stack_switch;
 } xfs_alloc_arg_t;
 
 /*
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 9125955..83d0cf3 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2441,7 +2441,6 @@ xfs_bmap_btalloc(
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->blkno;
-	args.stack_switch = ap->stack_switch;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = MIN(ap->length, XFS_ALLOC_AG_MAX_USABLE(mp));
@@ -4620,12 +4619,11 @@ xfs_bmapi_delay(
 
 
 STATIC int
-xfs_bmapi_allocate(
-	struct xfs_bmalloca	*bma,
-	int			flags)
+__xfs_bmapi_allocate(
+	struct xfs_bmalloca	*bma)
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
-	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
+	int			whichfork = (bma->flags & XFS_BMAPI_ATTRFORK) ?
 						XFS_ATTR_FORK : XFS_DATA_FORK;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 	int			tmp_logflags = 0;
@@ -4658,25 +4656,25 @@ xfs_bmapi_allocate(
 	 * Indicate if this is the first user data in the file, or just any
 	 * user data.
 	 */
-	if (!(flags & XFS_BMAPI_METADATA)) {
+	if (!(bma->flags & XFS_BMAPI_METADATA)) {
 		bma->userdata = (bma->offset == 0) ?
 			XFS_ALLOC_INITIAL_USER_DATA : XFS_ALLOC_USERDATA;
 	}
 
-	bma->minlen = (flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
+	bma->minlen = (bma->flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
 
 	/*
 	 * Only want to do the alignment at the eof if it is userdata and
 	 * allocation length is larger than a stripe unit.
 	 */
 	if (mp->m_dalign && bma->length >= mp->m_dalign &&
-	    !(flags & XFS_BMAPI_METADATA) && whichfork == XFS_DATA_FORK) {
+	    !(bma->flags & XFS_BMAPI_METADATA) && whichfork == XFS_DATA_FORK) {
 		error = xfs_bmap_isaeof(bma, whichfork);
 		if (error)
 			return error;
 	}
 
-	if (flags & XFS_BMAPI_STACK_SWITCH)
+	if (bma->flags & XFS_BMAPI_STACK_SWITCH)
 		bma->stack_switch = 1;
 
 	error = xfs_bmap_alloc(bma);
@@ -4713,7 +4711,7 @@ xfs_bmapi_allocate(
 	 * A wasdelay extent has been initialized, so shouldn't be flagged
 	 * as unwritten.
 	 */
-	if (!bma->wasdel && (flags & XFS_BMAPI_PREALLOC) &&
+	if (!bma->wasdel && (bma->flags & XFS_BMAPI_PREALLOC) &&
 	    xfs_sb_version_hasextflgbit(&mp->m_sb))
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
@@ -4741,6 +4739,45 @@ xfs_bmapi_allocate(
 	return 0;
 }
 
+static void
+xfs_bmapi_allocate_worker(
+	struct work_struct	*work)
+{
+	struct xfs_bmalloca	*args = container_of(work,
+						struct xfs_bmalloca, work);
+	unsigned long		pflags;
+
+	/* we are in a transaction context here */
+	current_set_flags_nested(&pflags, PF_FSTRANS);
+
+	args->result = __xfs_bmapi_allocate(args);
+	complete(args->done);
+
+	current_restore_flags_nested(&pflags, PF_FSTRANS);
+}
+
+/*
+ * Some allocation requests often come in with little stack to work on. Push
+ * them off to a worker thread so there is lots of stack to use. Otherwise just
+ * call directly to avoid the context switch overhead here.
+ */
+int
+xfs_bmapi_allocate(
+	struct xfs_bmalloca	*args)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	if (!args->stack_switch)
+		return __xfs_bmapi_allocate(args);
+
+
+	args->done = &done;
+	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
+	queue_work(xfs_alloc_wq, &args->work);
+	wait_for_completion(&done);
+	return args->result;
+}
+
 STATIC int
 xfs_bmapi_convert_unwritten(
 	struct xfs_bmalloca	*bma,
@@ -4926,6 +4963,7 @@ xfs_bmapi_write(
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
 			bma.offset = bno;
+			bma.flags = flags;
 
 			/*
 			 * There's a 32/64 bit type mismatch between the
@@ -4941,7 +4979,7 @@ xfs_bmapi_write(
 
 			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
-			error = xfs_bmapi_allocate(&bma, flags);
+			error = xfs_bmapi_allocate(&bma);
 			if (error)
 				goto error0;
 			if (bma.blkno == NULLFSBLOCK)
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index b68c598..5f469c3 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -136,6 +136,10 @@ typedef struct xfs_bmalloca {
 	char			aeof;	/* allocated space at eof */
 	char			conv;	/* overwriting unwritten extents */
 	char			stack_switch;
+	int			flags;
+	struct completion	*done;
+	struct work_struct	work;
+	int			result;
 } xfs_bmalloca_t;
 
 /*
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
