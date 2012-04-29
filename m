Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TAfFD2113405 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 05:41:15 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4FQhQ1375ExGJQdn for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 03:41:12 -0700 (PDT)
Date: Sun, 29 Apr 2012 20:41:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 30/37 V2] xfs: clean up busy extent naming
Message-ID: <20120429104110.GR9541@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-31-git-send-email-david@fromorbit.com>
	<4F96ECC6.7070605@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F96ECC6.7070605@sgi.com>
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
Cc: xfs@oss.sgi.com

On Tue, Apr 24, 2012 at 01:11:18PM -0500, Mark Tinguely wrote:
> On 04/23/12 00:59, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Now that the busy extent tracking has been moved out of the
> >allocation files, clean up the namespace it uses to
> >"xfs_extent_busy" rather than a mix of "xfs_busy" and
> >"xfs_alloc_busy".
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> Other than the STATIC on xfs_extend_busy_trim() leaving an undefined
> routine in the xfs.ko, it looks good.

New version rebased on modified previous patch below.

-- 
Dave Chinner
david@fromorbit.com

xfs: clean up busy extent naming

From: Dave Chinner <dchinner@redhat.com>

Now that the busy extent tracking has been moved out of the
allocation files, clean up the namespace it uses to
"xfs_extent_busy" rather than a mix of "xfs_busy" and
"xfs_alloc_busy".

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c       |   12 +++----
 fs/xfs/xfs_alloc_btree.c |    6 ++--
 fs/xfs/xfs_discard.c     |    4 +--
 fs/xfs/xfs_extent_busy.c |   78 +++++++++++++++++++++++-----------------------
 fs/xfs/xfs_extent_busy.h |   20 ++++++------
 fs/xfs/xfs_log_cil.c     |    6 ++--
 fs/xfs/xfs_trace.h       |   16 +++++-----
 fs/xfs/xfs_trans.c       |    4 +--
 8 files changed, 73 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index ae6df25..588496d 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -47,7 +47,7 @@ STATIC int xfs_alloc_ag_vextent_near(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
-STATIC void xfs_alloc_busy_trim(struct xfs_alloc_arg *,
+STATIC void xfs_extent_busy_trim(struct xfs_alloc_arg *,
 		xfs_agblock_t, xfs_extlen_t, xfs_agblock_t *, xfs_extlen_t *);
 
 /*
@@ -152,7 +152,7 @@ xfs_alloc_compute_aligned(
 	xfs_extlen_t	len;
 
 	/* Trim busy sections out of found extent */
-	xfs_alloc_busy_trim(args, foundbno, foundlen, &bno, &len);
+	xfs_extent_busy_trim(args, foundbno, foundlen, &bno, &len);
 
 	if (args->alignment > 1 && len >= args->minlen) {
 		xfs_agblock_t	aligned_bno = roundup(bno, args->alignment);
@@ -536,7 +536,7 @@ xfs_alloc_ag_vextent(
 		if (error)
 			return error;
 
-		ASSERT(!xfs_alloc_busy_search(args->mp, args->agno,
+		ASSERT(!xfs_extent_busy_search(args->mp, args->agno,
 					      args->agbno, args->len));
 	}
 
@@ -603,7 +603,7 @@ xfs_alloc_ag_vextent_exact(
 	/*
 	 * Check for overlapping busy extents.
 	 */
-	xfs_alloc_busy_trim(args, fbno, flen, &tbno, &tlen);
+	xfs_extent_busy_trim(args, fbno, flen, &tbno, &tlen);
 
 	/*
 	 * Give up if the start of the extent is busy, or the freespace isn't
@@ -1391,7 +1391,7 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
-			xfs_alloc_busy_reuse(args->mp, args->agno, fbno, 1,
+			xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
 					     args->userdata);
 
 			if (args->userdata) {
@@ -2496,7 +2496,7 @@ xfs_free_extent(
 
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
 	if (!error)
-		xfs_alloc_busy_insert(tp, args.agno, args.agbno, len, 0);
+		xfs_extent_busy_insert(tp, args.agno, args.agbno, len, 0);
 error0:
 	xfs_perag_put(args.pag);
 	return error;
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 3f66548..68ebabc 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -94,7 +94,7 @@ xfs_allocbt_alloc_block(
 		return 0;
 	}
 
-	xfs_alloc_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1, false);
 
 	xfs_trans_agbtree_delta(cur->bc_tp, 1);
 	new->s = cpu_to_be32(bno);
@@ -119,8 +119,8 @@ xfs_allocbt_free_block(
 	if (error)
 		return error;
 
-	xfs_alloc_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
-			      XFS_ALLOC_BUSY_SKIP_DISCARD);
+	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
+			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
 }
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index e3f1abe..f9c3fe3 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -118,7 +118,7 @@ xfs_trim_extents(
 		 * If any blocks in the range are still busy, skip the
 		 * discard and try again the next time.
 		 */
-		if (xfs_alloc_busy_search(mp, agno, fbno, flen)) {
+		if (xfs_extent_busy_search(mp, agno, fbno, flen)) {
 			trace_xfs_discard_busy(mp, agno, fbno, flen);
 			goto next_extent;
 		}
@@ -212,7 +212,7 @@ xfs_discard_extents(
 	struct xfs_mount	*mp,
 	struct list_head	*list)
 {
-	struct xfs_busy_extent	*busyp;
+	struct xfs_extent_busy	*busyp;
 	int			error = 0;
 
 	list_for_each_entry(busyp, list, list) {
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 4b5a4fa..9475bd9 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -32,27 +32,27 @@
 #include "xfs_trace.h"
 
 void
-xfs_alloc_busy_insert(
+xfs_extent_busy_insert(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	unsigned int		flags)
 {
-	struct xfs_busy_extent	*new;
-	struct xfs_busy_extent	*busyp;
+	struct xfs_extent_busy	*new;
+	struct xfs_extent_busy	*busyp;
 	struct xfs_perag	*pag;
 	struct rb_node		**rbp;
 	struct rb_node		*parent = NULL;
 
-	new = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
+	new = kmem_zalloc(sizeof(struct xfs_extent_busy), KM_MAYFAIL);
 	if (!new) {
 		/*
 		 * No Memory!  Since it is now not possible to track the free
 		 * block, make this a synchronous transaction to insure that
 		 * the block is not reused before this transaction commits.
 		 */
-		trace_xfs_alloc_busy_enomem(tp->t_mountp, agno, bno, len);
+		trace_xfs_extent_busy_enomem(tp->t_mountp, agno, bno, len);
 		xfs_trans_set_sync(tp);
 		return;
 	}
@@ -64,14 +64,14 @@ xfs_alloc_busy_insert(
 	new->flags = flags;
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_alloc_busy(tp->t_mountp, agno, bno, len);
+	trace_xfs_extent_busy(tp->t_mountp, agno, bno, len);
 
 	pag = xfs_perag_get(tp->t_mountp, new->agno);
 	spin_lock(&pag->pagb_lock);
 	rbp = &pag->pagb_tree.rb_node;
 	while (*rbp) {
 		parent = *rbp;
-		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
+		busyp = rb_entry(parent, struct xfs_extent_busy, rb_node);
 
 		if (new->bno < busyp->bno) {
 			rbp = &(*rbp)->rb_left;
@@ -95,14 +95,14 @@ xfs_alloc_busy_insert(
 /*
  * Search for a busy extent within the range of the extent we are about to
  * allocate.  You need to be holding the busy extent tree lock when calling
- * xfs_alloc_busy_search(). This function returns 0 for no overlapping busy
+ * xfs_extent_busy_search(). This function returns 0 for no overlapping busy
  * extent, -1 for an overlapping but not exact busy extent, and 1 for an exact
  * match. This is done so that a non-zero return indicates an overlap that
  * will require a synchronous transaction, but it can still be
  * used to distinguish between a partial or exact match.
  */
 int
-xfs_alloc_busy_search(
+xfs_extent_busy_search(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
@@ -110,7 +110,7 @@ xfs_alloc_busy_search(
 {
 	struct xfs_perag	*pag;
 	struct rb_node		*rbp;
-	struct xfs_busy_extent	*busyp;
+	struct xfs_extent_busy	*busyp;
 	int			match = 0;
 
 	pag = xfs_perag_get(mp, agno);
@@ -120,7 +120,7 @@ xfs_alloc_busy_search(
 
 	/* find closest start bno overlap */
 	while (rbp) {
-		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		busyp = rb_entry(rbp, struct xfs_extent_busy, rb_node);
 		if (bno < busyp->bno) {
 			/* may overlap, but exact start block is lower */
 			if (bno + len > busyp->bno)
@@ -154,10 +154,10 @@ xfs_alloc_busy_search(
  * needs to be restarted.
  */
 STATIC bool
-xfs_alloc_busy_update_extent(
+xfs_extent_busy_update_extent(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	struct xfs_busy_extent	*busyp,
+	struct xfs_extent_busy	*busyp,
 	xfs_agblock_t		fbno,
 	xfs_extlen_t		flen,
 	bool			userdata)
@@ -171,7 +171,7 @@ xfs_alloc_busy_update_extent(
 	 * performing the discard a chance to mark the extent unbusy
 	 * and retry.
 	 */
-	if (busyp->flags & XFS_ALLOC_BUSY_DISCARDED) {
+	if (busyp->flags & XFS_EXTENT_BUSY_DISCARDED) {
 		spin_unlock(&pag->pagb_lock);
 		delay(1);
 		spin_lock(&pag->pagb_lock);
@@ -285,13 +285,13 @@ xfs_alloc_busy_update_extent(
 		ASSERT(0);
 	}
 
-	trace_xfs_alloc_busy_reuse(mp, pag->pag_agno, fbno, flen);
+	trace_xfs_extent_busy_reuse(mp, pag->pag_agno, fbno, flen);
 	return true;
 
 out_force_log:
 	spin_unlock(&pag->pagb_lock);
 	xfs_log_force(mp, XFS_LOG_SYNC);
-	trace_xfs_alloc_busy_force(mp, pag->pag_agno, fbno, flen);
+	trace_xfs_extent_busy_force(mp, pag->pag_agno, fbno, flen);
 	spin_lock(&pag->pagb_lock);
 	return false;
 }
@@ -301,7 +301,7 @@ out_force_log:
  * For a given extent [fbno, flen], make sure we can reuse it safely.
  */
 void
-xfs_alloc_busy_reuse(
+xfs_extent_busy_reuse(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		fbno,
@@ -318,8 +318,8 @@ xfs_alloc_busy_reuse(
 restart:
 	rbp = pag->pagb_tree.rb_node;
 	while (rbp) {
-		struct xfs_busy_extent *busyp =
-			rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		struct xfs_extent_busy *busyp =
+			rb_entry(rbp, struct xfs_extent_busy, rb_node);
 		xfs_agblock_t	bbno = busyp->bno;
 		xfs_agblock_t	bend = bbno + busyp->length;
 
@@ -331,7 +331,7 @@ restart:
 			continue;
 		}
 
-		if (!xfs_alloc_busy_update_extent(mp, pag, busyp, fbno, flen,
+		if (!xfs_extent_busy_update_extent(mp, pag, busyp, fbno, flen,
 						  userdata))
 			goto restart;
 	}
@@ -346,7 +346,7 @@ restart:
  * code needs to force out the log and retry the allocation.
  */
 STATIC void
-xfs_alloc_busy_trim(
+xfs_extent_busy_trim(
 	struct xfs_alloc_arg	*args,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
@@ -365,8 +365,8 @@ restart:
 	flen = len;
 	rbp = args->pag->pagb_tree.rb_node;
 	while (rbp && flen >= args->minlen) {
-		struct xfs_busy_extent *busyp =
-			rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		struct xfs_extent_busy *busyp =
+			rb_entry(rbp, struct xfs_extent_busy, rb_node);
 		xfs_agblock_t	fend = fbno + flen;
 		xfs_agblock_t	bbno = busyp->bno;
 		xfs_agblock_t	bend = bbno + busyp->length;
@@ -384,8 +384,8 @@ restart:
 		 * extent instead of trimming the allocation.
 		 */
 		if (!args->userdata &&
-		    !(busyp->flags & XFS_ALLOC_BUSY_DISCARDED)) {
-			if (!xfs_alloc_busy_update_extent(args->mp, args->pag,
+		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
+			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
 							  busyp, fbno, flen,
 							  false))
 				goto restart;
@@ -517,7 +517,7 @@ restart:
 	spin_unlock(&args->pag->pagb_lock);
 
 	if (fbno != bno || flen != len) {
-		trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len,
+		trace_xfs_extent_busy_trim(args->mp, args->agno, bno, len,
 					  fbno, flen);
 	}
 	*rbno = fbno;
@@ -529,19 +529,19 @@ fail:
 	 * re-check if the trimmed extent satisfies the minlen requirement.
 	 */
 	spin_unlock(&args->pag->pagb_lock);
-	trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len, fbno, 0);
+	trace_xfs_extent_busy_trim(args->mp, args->agno, bno, len, fbno, 0);
 	*rbno = fbno;
 	*rlen = 0;
 }
 
-static void
-xfs_alloc_busy_clear_one(
+STATIC void
+xfs_extent_busy_clear_one(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	struct xfs_busy_extent	*busyp)
+	struct xfs_extent_busy	*busyp)
 {
 	if (busyp->length) {
-		trace_xfs_alloc_busy_clear(mp, busyp->agno, busyp->bno,
+		trace_xfs_extent_busy_clear(mp, busyp->agno, busyp->bno,
 						busyp->length);
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	}
@@ -556,12 +556,12 @@ xfs_alloc_busy_clear_one(
  * these as undergoing a discard operation instead.
  */
 void
-xfs_alloc_busy_clear(
+xfs_extent_busy_clear(
 	struct xfs_mount	*mp,
 	struct list_head	*list,
 	bool			do_discard)
 {
-	struct xfs_busy_extent	*busyp, *n;
+	struct xfs_extent_busy	*busyp, *n;
 	struct xfs_perag	*pag = NULL;
 	xfs_agnumber_t		agno = NULLAGNUMBER;
 
@@ -577,10 +577,10 @@ xfs_alloc_busy_clear(
 		}
 
 		if (do_discard && busyp->length &&
-		    !(busyp->flags & XFS_ALLOC_BUSY_SKIP_DISCARD))
-			busyp->flags = XFS_ALLOC_BUSY_DISCARDED;
+		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD))
+			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
 		else
-			xfs_alloc_busy_clear_one(mp, pag, busyp);
+			xfs_extent_busy_clear_one(mp, pag, busyp);
 	}
 
 	if (pag) {
@@ -593,11 +593,11 @@ xfs_alloc_busy_clear(
  * Callback for list_sort to sort busy extents by the AG they reside in.
  */
 int
-xfs_alloc_busy_ag_cmp(
+xfs_extent_busy_ag_cmp(
 	void			*priv,
 	struct list_head	*a,
 	struct list_head	*b)
 {
-	return container_of(a, struct xfs_busy_extent, list)->agno -
-		container_of(b, struct xfs_busy_extent, list)->agno;
+	return container_of(a, struct xfs_extent_busy, list)->agno -
+		container_of(b, struct xfs_extent_busy, list)->agno;
 }
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 671b501..91f2fcb 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -27,39 +27,39 @@
  * Note that we use the transaction ID to record the transaction, not the
  * transaction structure itself. See xfs_extent_busy_insert() for details.
  */
-struct xfs_busy_extent {
+struct xfs_extent_busy {
 	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
 	struct list_head list;		/* transaction busy extent list */
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
 	unsigned int	flags;
-#define XFS_ALLOC_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
-#define XFS_ALLOC_BUSY_SKIP_DISCARD	0x02	/* do not discard */
+#define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
+#define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
 };
 
 void
-xfs_alloc_busy_insert(struct xfs_trans *tp, xfs_agnumber_t agno,
+xfs_extent_busy_insert(struct xfs_trans *tp, xfs_agnumber_t agno,
 	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
 
 void
-xfs_alloc_busy_clear(struct xfs_mount *mp, struct list_head *list,
+xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
 	bool do_discard);
 
 int
-xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
+xfs_extent_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t bno, xfs_extlen_t len);
 
 void
-xfs_alloc_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
+xfs_extent_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
 
 int
-xfs_alloc_busy_ag_cmp(void *priv, struct list_head *a, struct list_head *b);
+xfs_extent_busy_ag_cmp(void *priv, struct list_head *a, struct list_head *b);
 
-static inline void xfs_alloc_busy_sort(struct list_head *list)
+static inline void xfs_extent_busy_sort(struct list_head *list)
 {
-	list_sort(NULL, list, xfs_alloc_busy_ag_cmp);
+	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
 }
 
 #endif /* __XFS_EXTENT_BUSY_H__ */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index a6e3e71..601ccf0 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -338,8 +338,8 @@ xlog_cil_committed(
 	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
 					ctx->start_lsn, abort);
 
-	xfs_alloc_busy_sort(&ctx->busy_extents);
-	xfs_alloc_busy_clear(mp, &ctx->busy_extents,
+	xfs_extent_busy_sort(&ctx->busy_extents);
+	xfs_extent_busy_clear(mp, &ctx->busy_extents,
 			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
 
 	spin_lock(&ctx->cil->xc_cil_lock);
@@ -352,7 +352,7 @@ xlog_cil_committed(
 		ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
 
 		xfs_discard_extents(mp, &ctx->busy_extents);
-		xfs_alloc_busy_clear(mp, &ctx->busy_extents, false);
+		xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
 	}
 
 	kmem_free(ctx);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 900764c..febff43 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1142,7 +1142,7 @@ TRACE_EVENT(xfs_bunmap,
 
 );
 
-DECLARE_EVENT_CLASS(xfs_busy_class,
+DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len),
 	TP_ARGS(mp, agno, agbno, len),
@@ -1165,17 +1165,17 @@ DECLARE_EVENT_CLASS(xfs_busy_class,
 		  __entry->len)
 );
 #define DEFINE_BUSY_EVENT(name) \
-DEFINE_EVENT(xfs_busy_class, name, \
+DEFINE_EVENT(xfs_extent_busy_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
 		 xfs_agblock_t agbno, xfs_extlen_t len), \
 	TP_ARGS(mp, agno, agbno, len))
-DEFINE_BUSY_EVENT(xfs_alloc_busy);
-DEFINE_BUSY_EVENT(xfs_alloc_busy_enomem);
-DEFINE_BUSY_EVENT(xfs_alloc_busy_force);
-DEFINE_BUSY_EVENT(xfs_alloc_busy_reuse);
-DEFINE_BUSY_EVENT(xfs_alloc_busy_clear);
+DEFINE_BUSY_EVENT(xfs_extent_busy);
+DEFINE_BUSY_EVENT(xfs_extent_busy_enomem);
+DEFINE_BUSY_EVENT(xfs_extent_busy_force);
+DEFINE_BUSY_EVENT(xfs_extent_busy_reuse);
+DEFINE_BUSY_EVENT(xfs_extent_busy_clear);
 
-TRACE_EVENT(xfs_alloc_busy_trim,
+TRACE_EVENT(xfs_extent_busy_trim,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len,
 		 xfs_agblock_t tbno, xfs_extlen_t tlen),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 6af1dc1..584e76a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -613,8 +613,8 @@ STATIC void
 xfs_trans_free(
 	struct xfs_trans	*tp)
 {
-	xfs_alloc_busy_sort(&tp->t_busy);
-	xfs_alloc_busy_clear(tp->t_mountp, &tp->t_busy, false);
+	xfs_extent_busy_sort(&tp->t_busy);
+	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	atomic_dec(&tp->t_mountp->m_active_trans);
 	if (tp->t_flags & XFS_TRANS_FREEZE_PROT)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
