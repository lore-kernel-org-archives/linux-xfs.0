Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:08:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97M89ax009067
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:08:10 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0DAE1B0C579
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:09:46 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id Ei5RW29H6NDV4DQG for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:09:46 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKkL-0002Vp-NO
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:09:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] XFS: Avoid busy extent ranges rather than the entire extent
Date: Wed,  8 Oct 2008 09:09:36 +1100
Message-Id: <1223417377-8679-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417377-8679-1-git-send-email-david@fromorbit.com>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When we check an extent for being busy, we check for an overlap
and if we find one we declare that extent off-limits and move
on to the next free extent. This means that we can skip entire
AGs that have a single large free extent with very small overlapping
busy extent.

This can actually cause significant problems - often we have to
allocate within a given AG, and we have a reservation that guarantees
us that the free space is there. If we only have a singel extent,
and part of it is busy, we will fail the allocation and that will
cause problems.

To avoid this problem, we should trim the busy range out of the
extent we have found and determine if that trimmed range is still OK
for allocation. In many cases, this check can be incorporated into
the cwallocationextent alignment code which already does trimming of
the found extent before determining if it is a valid candidate for
allocation.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_ag.h    |    1 +
 fs/xfs/xfs_alloc.c |  439 +++++++++++++++++++++++++++++-----------------------
 2 files changed, 248 insertions(+), 192 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index ec87185..62bb280 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -161,6 +161,7 @@ typedef struct xfs_agfl {
  */
 struct xfs_busy_extent {
 	struct rb_node	rb_node;
+	atomic_t	ref;
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index e5fb397..73536ef 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -105,34 +105,75 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
  * though, we need to know that the busy extent was a allocbt block
  * and record that in the busy extent structure.
  */
-STATIC void
+STATIC struct xfs_busy_extent *
+xfs_alloc_busy_alloc(void)
+{
+	struct xfs_busy_extent	*busyp;
+
+	/* XXX: probably should use a zone */
+	busyp = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
+	if (!busyp)
+		return NULL;
+	atomic_set(&busyp->ref, 1);
+	return busyp;
+}
+
+static inline void
+xfs_alloc_busy_get(
+	struct xfs_busy_extent	*busyp)
+{
+	ASSERT(atomic_read(&busyp->ref) > 0);
+	atomic_inc(&busyp->ref);
+}
+
+static inline void
+xfs_alloc_busy_put(
+	struct xfs_busy_extent	*busyp)
+{
+	ASSERT(atomic_read(&busyp->ref) > 0);
+	if (atomic_dec_and_test(&busyp->ref))
+		kmem_free(busyp);
+}
+
+/*
+ * Insert a new busy extent into the tree.
+ *
+ * We can get duplicates occurring here in the case where an extent
+ * goes from an allocbt block to the freelist (i.e. btree merge occurs)
+ * and then the free list can be shortened which moves the extent
+ * from the free list to a frespace record. In this case, we simply
+ * clear the freelist flag from the busy extent.
+ */
+STATIC int
 xfs_alloc_busy_insert(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		bno,
-	struct rb_node		*node)
+	struct xfs_busy_extent	*busyp)
 {
 	struct rb_node		**rbp = &pag->pagb_tree.rb_node;
 	struct rb_node		*parent = NULL;
-	struct xfs_busy_extent	*busyp;
 
 	while (*rbp) {
-		parent = *rbp;
-		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
+		struct xfs_busy_extent	*bp;
 
-		ASSERT(bno != busyp->bno);
-		if (bno < busyp->bno)
+		parent = *rbp;
+		bp = rb_entry(parent, struct xfs_busy_extent, rb_node);
+		if (bno < bp->bno)
 			rbp = &(*rbp)->rb_left;
-		else if (bno > busyp->bno)
+		else if (bno > bp->bno)
 			rbp = &(*rbp)->rb_right;
 		else {
-			cmn_err(CE_WARN,
-				"XFS: ignoring duplicate busy extent.\n");
-			ASSERT(0);
+			/* clear the freelist flag and free the new node */
+			ASSERT(bp->flags & XFS_BUSY_EXT_FREELIST);
+			bp->flags &= ~XFS_BUSY_EXT_FREELIST;
+			xfs_alloc_busy_put(busyp);
+			return 0;
 		}
 	}
 
-	rb_link_node(node, parent, rbp);
-	rb_insert_color(node, &pag->pagb_tree);
+	rb_link_node(&busyp->rb_node, parent, rbp);
+	rb_insert_color(&busyp->rb_node, &pag->pagb_tree);
+	return 1;
 }
 
 STATIC void
@@ -146,7 +187,7 @@ xfs_alloc_mark_busy(
 	struct xfs_busy_extent	*busyp;
 	struct xfs_perag	*pag;
 
-	busyp = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
+	busyp = xfs_alloc_busy_alloc();
 	if (!busyp) {
 		/*
 		 * No Memory!  Since it is now not possible to track the free
@@ -166,33 +207,53 @@ xfs_alloc_mark_busy(
 
 	pag = xfs_perag_get(tp->t_mountp, agno);
 	spin_lock(&pag->pagb_lock);
-	xfs_alloc_busy_insert(pag, bno, &busyp->rb_node);
-	xfs_trans_add_busy(tp, busyp);
+	if (xfs_alloc_busy_insert(pag, bno, busyp))
+		xfs_trans_add_busy(tp, busyp);
 	TRACE_BUSY("xfs_alloc_mark_busy", "got", agno, bno, len, tp);
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
 }
 
+void
+xfs_alloc_clear_busy(
+	struct xfs_trans	*tp,
+	struct xfs_busy_extent	*busyp)
+{
+	struct xfs_perag	*pag = xfs_perag_get(tp->t_mountp, busyp->agno);
+
+	TRACE_UNBUSY("xfs_alloc_clear_busy", "found", busyp->agno, busyp->bno,
+							busyp->length, tp);
+	spin_lock(&pag->pagb_lock);
+	ASSERT(!RB_EMPTY_NODE(&busyp->rb_node));
+	rb_erase(&busyp->rb_node, &pag->pagb_tree);
+	spin_unlock(&pag->pagb_lock);
+
+	xfs_perag_put(pag);
+	xfs_alloc_busy_put(busyp);
+}
+
 /*
  * Search for a busy extent that overlaps the range of the extent we
- * are about to allocate.
+ * have been given. If we find a match, take a reference to the busyp
+ * and return it to the caller so they can decide what action to take.
+ * Caller must drop the reference.
  */
-static struct xfs_busy_extent *
-__xfs_alloc_busy_search(
+STATIC struct xfs_busy_extent *
+xfs_alloc_busy_search(
 	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len)
 {
+	struct xfs_perag	*pag = xfs_perag_get(tp->t_mountp, agno);
+	struct xfs_busy_extent	*busyp = NULL;
 	struct rb_node		*rbp;
 	xfs_agblock_t		uend, bend;
 
 	uend = bno + len - 1;
+	spin_lock(&pag->pagb_lock);
 	rbp = pag->pagb_tree.rb_node;
 	while (rbp) {
-		struct xfs_busy_extent	*busyp;
-
 		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
 		bend = busyp->bno + busyp->length - 1;
 		if (uend < busyp->bno)
@@ -203,50 +264,69 @@ __xfs_alloc_busy_search(
 			/* (start1,length1) overlaps (start2, length2) */
 			TRACE_BUSYSEARCH("xfs_alloc_busy_search",
 					 "found1", agno, bno, len, tp);
-			return busyp;
+			xfs_alloc_busy_get(busyp);
+			break;
 		}
+		busyp = NULL;
 	}
-	return NULL;
-}
-
-STATIC struct xfs_busy_extent *
-xfs_alloc_busy_search(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len)
-{
-	struct xfs_busy_extent	*busyp;
-	struct xfs_perag	*pag = xfs_perag_get(tp->t_mountp, agno);
-
-	spin_lock(&pag->pagb_lock);
-	busyp = __xfs_alloc_busy_search(tp, pag, agno, bno, len);
 	spin_unlock(&pag->pagb_lock);
 
 	xfs_perag_put(pag);
 	return busyp;
 }
 
-void
-xfs_alloc_clear_busy(
+/*
+ * For a given extent [fbno, flen], search the busy extent list
+ * to find a subset of the extent that is not busy.
+ */
+STATIC void
+xfs_alloc_busy_search_trim(
 	struct xfs_trans	*tp,
-	struct xfs_busy_extent	*busyp)
-{
-	struct xfs_perag	*pag;
-
-	/* check that the busyp is still in the rbtree */
-	ASSERT(xfs_alloc_busy_search(tp, busyp->agno, busyp->bno,
-						busyp->length) == busyp);
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		fbno,
+	xfs_extlen_t		flen,
+	xfs_agblock_t		*rbno,
+	xfs_extlen_t		*rlen)
 
-	pag = xfs_perag_get(tp->t_mountp, busyp->agno);
-	spin_lock(&pag->pagb_lock);
-	TRACE_UNBUSY("xfs_alloc_clear_busy", "found", busyp->agno, busyp->bno,
-							busyp->length, tp);
-	rb_erase(&busyp->rb_node, &pag->pagb_tree);
-	spin_unlock(&pag->pagb_lock);
-	xfs_perag_put(pag);
+{
+	xfs_agblock_t		bno = fbno;
+	xfs_extlen_t		len = flen;
+	struct xfs_busy_extent	*busyp;
 
-	kmem_free(busyp);
+	busyp = xfs_alloc_busy_search(tp, agno, bno, len);
+	while (busyp) {
+		xfs_agblock_t	end = bno + len;
+		xfs_agblock_t	bend = busyp->bno + busyp->length;
+		if (busyp->bno < bno) {
+			/* start overlap */
+			ASSERT(bend >= bno);
+			ASSERT(bend <= end);
+			len -= bno - bend;
+			bno = bend;
+		} else if (bend > end) {
+			/* end overlap */
+			ASSERT(busyp->bno >= bno);
+			ASSERT(busyp->bno < end);
+			len -= bend - end;
+		} else {
+			/* middle overlap - return larger segment */
+			ASSERT(busyp->bno >= bno);
+			ASSERT(bend <= end);
+			len = busyp->bno - bno;
+			if (len >= end - bend) {
+				/* use first segment */
+				len = len;
+			} else {
+				/* use last segment */
+				bno = bend;
+				len = end - bend;
+			}
+		}
+		xfs_alloc_busy_put(busyp);
+		busyp = xfs_alloc_busy_search(tp, agno, bno, len);
+	}
+	*rbno = bno;
+	*rlen = len;
 }
 
 /*
@@ -340,53 +420,14 @@ xfs_alloc_get_rec(
 }
 
 /*
- * If the extent is busy via xfs_alloc_put_freelist(), and we are
- * currently reusing it via xfs_alloc_get_freelist(), remove the
- * extent from the busy list. Do this search and remove atomically
- * so we don't race with transaction completion calling
- * xfs_alloc_clear_busy().
- *
- * We should never get the situation where an extent on the freelist
- * is busy due to other methods of freeing extents. If it happens,
- * let the caller handle it (e.g. by using a synchronous log
- * force to wait for the extent to become unbusy).
- */
-static struct xfs_busy_extent *
-xfs_alloc_search_clear_busy_freelist(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	int			btreeblk)
-{
-	struct xfs_busy_extent	*busyp;
-	struct xfs_perag	*pag = xfs_perag_get(tp->t_mountp, agno);
-
-	spin_lock(&pag->pagb_lock);
-	busyp = __xfs_alloc_busy_search(tp, pag, agno, bno, len);
-	if (busyp && btreeblk && (busyp->flags & XFS_BUSY_EXT_FREELIST)) {
-		TRACE_UNBUSY("xfs_alloc_search_clear_busy_freelist",
-			"found", busyp->agno, busyp->bno, busyp->length, tp);
-		rb_erase(&busyp->rb_node, &pag->pagb_tree);
-		kmem_free(busyp);
-		busyp = NULL;
-	}
-	spin_unlock(&pag->pagb_lock);
-
-	xfs_perag_put(pag);
-	return busyp;
-}
-
-/*
  * Compute aligned version of the found extent.
- * Takes alignment and min length into account.
+ * Takes alignment, min length and busy extent ranges into account.
  */
 STATIC void
 xfs_alloc_compute_aligned(
+	xfs_alloc_arg_t	*args,
 	xfs_agblock_t	foundbno,	/* starting block in found extent */
 	xfs_extlen_t	foundlen,	/* length in found extent */
-	xfs_extlen_t	alignment,	/* alignment for allocation */
-	xfs_extlen_t	minlen,		/* minimum length for allocation */
 	xfs_agblock_t	*resbno,	/* result block number */
 	xfs_extlen_t	*reslen)	/* result length */
 {
@@ -394,13 +435,13 @@ xfs_alloc_compute_aligned(
 	xfs_extlen_t	diff;
 	xfs_extlen_t	len;
 
-	if (alignment > 1 && foundlen >= minlen) {
-		bno = roundup(foundbno, alignment);
+	/* Trim busy sections out of found extent */
+	xfs_alloc_busy_search_trim(args->tp, args->agno, foundbno, foundlen,
+							&bno, &len);
+	if (args->alignment > 1 && len >= args->minlen) {
+		bno = roundup(bno, args->alignment);
 		diff = bno - foundbno;
 		len = diff >= foundlen ? 0 : foundlen - diff;
-	} else {
-		bno = foundbno;
-		len = foundlen;
 	}
 	*resbno = bno;
 	*reslen = len;
@@ -876,6 +917,10 @@ xfs_alloc_ag_vextent(
 		ASSERT(args->len >= args->minlen && args->len <= args->maxlen);
 		ASSERT(!(args->wasfromfl) || !args->isfl);
 		ASSERT(args->agbno % args->alignment == 0);
+
+		/* we should never be handed a busy extent. */
+		ASSERT(!xfs_alloc_busy_search(args->tp, args->agno,
+						args->agbno, args->len));
 		if (!(args->wasfromfl)) {
 
 			agf = XFS_BUF_TO_AGF(args->agbp);
@@ -888,16 +933,6 @@ xfs_alloc_ag_vextent(
 			TRACE_MODAGF(NULL, agf, XFS_AGF_FREEBLKS);
 			xfs_alloc_log_agf(args->tp, args->agbp,
 						XFS_AGF_FREEBLKS);
-			/*
-			 * Search the busylist for these blocks and mark the
-			 * transaction as synchronous if blocks are found. This
-			 * avoids the need to block in due to a synchronous log
-			 * force to ensure correct ordering as the synchronous
-			 * transaction will guarantee that for us.
-			 */
-			if (xfs_alloc_busy_search(args->tp, args->agno,
-						args->agbno, args->len))
-				xfs_trans_set_sync(args->tp);
 		}
 		if (!args->isfl)
 			xfs_trans_mod_sb(args->tp,
@@ -927,14 +962,14 @@ xfs_alloc_ag_vextent_exact(
 {
 	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
 	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
-	xfs_agblock_t	end;	/* end of allocated extent */
 	int		error;
 	xfs_agblock_t	fbno;	/* start block of found extent */
-	xfs_agblock_t	fend;	/* end block of found extent */
 	xfs_extlen_t	flen;	/* length of found extent */
+	xfs_agblock_t	tbno;	/* start block of trimmed extent */
+	xfs_extlen_t	tlen;	/* length of trimmed extent */
+	xfs_agblock_t	tend;	/* end block of trimmed extent */
+	xfs_agblock_t	end;	/* end of allocated extent */
 	int		i;	/* success/failure of operation */
-	xfs_agblock_t	maxend;	/* end of maximal extent */
-	xfs_agblock_t	minend;	/* end of minimal extent */
 	xfs_extlen_t	rlen;	/* length of returned extent */
 
 	ASSERT(args->alignment == 1);
@@ -957,22 +992,22 @@ xfs_alloc_ag_vextent_exact(
 	error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i);
 	if (error)
 		goto error0;
-	if (xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
-		goto not_found;
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	ASSERT(fbno <= args->agbno);
 
+	/* Trim busy sections out of found extent */
+	xfs_alloc_busy_search_trim(args->tp, args->agno, fbno, flen,
+							&tbno, &tlen);
+
 	/* Give up if the freespace isn't long enough for the minimum request. */
-	minend = args->agbno + args->minlen;
-	maxend = args->agbno + args->maxlen;
-	fend = fbno + flen;
-	if (fend < minend)
+	tend = tbno + tlen;
+	if (tend < args->agbno + args->minlen)
 		goto not_found;
 	/*
 	 * End of extent will be smaller of the freespace end and the
 	 * maximal requested end.
 	 */
-	end = XFS_AGBLOCK_MIN(fend, maxend);
+	end = XFS_AGBLOCK_MIN(tend, (args->agbno + args->maxlen));
 
 	/* Fix the length according to mod and prod if given. */
 	args->len = end - args->agbno;
@@ -981,7 +1016,7 @@ xfs_alloc_ag_vextent_exact(
 		goto not_found;
 
 	rlen = args->len;
-	ASSERT(args->agbno + rlen <= fend);
+	ASSERT(args->agbno + rlen <= tend);
 	end = args->agbno + rlen;
 	/*
 	 * We are allocating agbno for rlen [agbno .. end]
@@ -1028,10 +1063,10 @@ xfs_alloc_find_best_extent(
 	xfs_agblock_t	gdiff,		/* difference for search comparison */
 	xfs_agblock_t	*sbno,		/* extent found by search */
 	xfs_extlen_t	*slen,
+	xfs_agblock_t	*sbnoa,		/* aligned extent found by search */
 	xfs_extlen_t	*slena,		/* aligned length */
 	int		dir)	/* 0 = search right, 1 = search left */
 {
-	xfs_agblock_t	bno;
 	xfs_agblock_t	new;
 	xfs_agblock_t	sdiff;
 	int		i;
@@ -1050,35 +1085,29 @@ xfs_alloc_find_best_extent(
 		if (error)
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		xfs_alloc_compute_aligned(*sbno, *slen, args->alignment,
-					args->minlen, &bno, slena);
-		if (xfs_alloc_busy_search(args->tp, args->agno, bno, *slena)) {
-			/* just freed - skip this one */
-			goto next_record;
-		}
+		xfs_alloc_compute_aligned(args, *sbno, *slen, sbnoa, slena);
 
 		/* The good extent is closer than this one */
 		if (!dir) {
-			if (bno >= args->agbno + gdiff)
+			if (*sbnoa >= args->agbno + gdiff)
 				goto out_use_good;
 		} else {
-			if (bno <= args->agbno - gdiff)
+			if (*sbnoa <= args->agbno - gdiff)
 				goto out_use_good;
 		}
 
-		/* Same distance, compare length and pick the best. */
+		/* Same region, compare length and pick the best. */
 		if (*slena >= args->minlen) {
 			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-					args->alignment, *sbno, *slen, &new);
+					args->alignment, *sbnoa, *slena, &new);
 
 			/* choose closer size and invalidate other cursor */
 			if (sdiff < gdiff)
 				goto out_use_search;
 			goto out_use_good;
 		}
-next_record:
 		if (!dir)
 			error = xfs_btree_increment(*scur, 0, &i);
 		else
@@ -1228,19 +1257,17 @@ xfs_alloc_ag_vextent_near(
 			if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			xfs_alloc_compute_aligned(ltbno, ltlen, args->alignment,
-					args->minlen, &ltbnoa, &ltlena);
+			xfs_alloc_compute_aligned(args, ltbno, ltlen,
+							&ltbnoa, &ltlena);
 			if (ltlena < args->minlen)
 				continue;
-			if (xfs_alloc_busy_search(args->tp, args->agno, ltbnoa, ltlena))
-				continue;
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			ASSERT(args->len >= args->minlen);
 			if (args->len < blen)
 				continue;
 			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, ltbno, ltlen, &ltnew);
+				args->alignment, ltbnoa, ltlena, &ltnew);
 			if (ltnew != NULLAGBLOCK &&
 			    (args->len > blen || ltdiff < bdiff)) {
 				bdiff = ltdiff;
@@ -1351,17 +1378,10 @@ xfs_alloc_ag_vextent_near(
 			if ((error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			xfs_alloc_compute_aligned(ltbno, ltlen, args->alignment,
-					args->minlen, &ltbnoa, &ltlena);
-			if (ltlena >= args->minlen &&
-			    !xfs_alloc_busy_search(args->tp, args->agno, ltbnoa, ltlena))
+			xfs_alloc_compute_aligned(args, ltbno, ltlen,
+							&ltbnoa, &ltlena);
+			if (ltlena >= args->minlen)
 				break;
-			/*
-			 * clear the length so we don't accidentally use this
-			 * extent after we decrement the cursor then find a
-			 * match from the other cursor.
-			 */
-			ltlena = 0;
 			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
 				goto error0;
 			if (!i) {
@@ -1374,12 +1394,10 @@ xfs_alloc_ag_vextent_near(
 			if ((error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			xfs_alloc_compute_aligned(gtbno, gtlen, args->alignment,
-					args->minlen, &gtbnoa, &gtlena);
-			if (gtlena >= args->minlen &&
-			    !xfs_alloc_busy_search(args->tp, args->agno, gtbnoa, gtlena))
+			xfs_alloc_compute_aligned(args, gtbno, gtlen,
+							&gtbnoa, &gtlena);
+			if (gtlena >= args->minlen)
 				break;
-			gtlena = 0;
 			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
 				goto error0;
 			if (!i) {
@@ -1398,11 +1416,12 @@ xfs_alloc_ag_vextent_near(
 			xfs_alloc_fix_len(args);
 			rlen = args->len;
 			ltdiff = xfs_alloc_compute_diff(args->agbno, rlen,
-				args->alignment, ltbno, ltlen, &ltnew);
+				args->alignment, ltbnoa, ltlena, &ltnew);
 
 			error = xfs_alloc_find_best_extent(args,
 						&bno_cur_lt, &bno_cur_gt,
-						ltdiff, &gtbno, &gtlen, &gtlena,
+						ltdiff, &gtbno, &gtlen, 
+						&gtbnoa, &gtlena,
 						0 /* search right */);
 			if (error)
 				goto error0;
@@ -1414,11 +1433,12 @@ xfs_alloc_ag_vextent_near(
 			xfs_alloc_fix_len(args);
 			rlen = args->len;
 			gtdiff = xfs_alloc_compute_diff(args->agbno, rlen,
-				args->alignment, gtbno, gtlen, &gtnew);
+				args->alignment, gtbnoa, gtlena, &gtnew);
 
 			error = xfs_alloc_find_best_extent(args,
 						&bno_cur_gt, &bno_cur_lt,
-						gtdiff, &ltbno, &ltlen, &ltlena,
+						gtdiff, &ltbno, &ltlen, 
+						&ltbnoa, &ltlena,
 						1 /* search left */);
 			if (error)
 				goto error0;
@@ -1442,7 +1462,7 @@ xfs_alloc_ag_vextent_near(
 		bno_cur_lt = bno_cur_gt;
 		bno_cur_gt = NULL;
 		ltbno = gtbno;
-		//ltbnoa = gtbnoa;
+		ltbnoa = gtbnoa;
 		ltlen = gtlen;
 		ltlena = gtlena;
 		j = 1;
@@ -1451,7 +1471,7 @@ xfs_alloc_ag_vextent_near(
 	/*
 	 * Fix up the length and compute the useful address.
 	 */
-	ltend = ltbno + ltlen;
+	ltend = ltbnoa + ltlena;
 	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 	xfs_alloc_fix_len(args);
 	if (!xfs_alloc_fix_minleft(args)) {
@@ -1461,8 +1481,8 @@ xfs_alloc_ag_vextent_near(
 		return 0;
 	}
 	rlen = args->len;
-	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment, ltbno,
-		ltlen, &ltnew);
+	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment, ltbnoa,
+		ltlena, &ltnew);
 	ASSERT(ltnew >= ltbno);
 	ASSERT(ltnew + rlen <= ltend);
 	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
@@ -1510,7 +1530,7 @@ xfs_alloc_ag_vextent_size(
 	int		i;		/* temp status variable */
 	xfs_agblock_t	rbno;		/* returned block number */
 	xfs_extlen_t	rlen;		/* length of returned extent */
-	int		check_busy = 1;
+	int		forced = 0;
 
 	/*
 	 * Allocate and initialize a cursor for the by-size btree.
@@ -1526,10 +1546,14 @@ restart:
 			args->maxlen + args->alignment - 1, &i)))
 		goto error0;
 	/*
-	 * If none, then pick up the last entry in the tree unless the
-	 * tree is empty.
+	 * If none or we have busy extents that we cannot allocate from, then
+	 * we have to settle for a smaller extent. In the case that there are
+	 * no large extents, this will return the last entry in the tree unless
+	 * the tree is empty. In the case that there are only busy large
+	 * extents, this will return the largest small extent unless there
+	 * are no smaller extents available.
 	 */
-	if (!i) {
+	if (!i || forced > 1) {
 		if ((error = xfs_alloc_ag_vextent_small(args, cnt_cur, &fbno,
 				&flen, &i)))
 			goto error0;
@@ -1539,6 +1563,7 @@ restart:
 			return 0;
 		}
 		ASSERT(i == 1);
+		xfs_alloc_compute_aligned(args, fbno, flen, &rbno, &rlen);
 	}
 	/*
 	 * There's a freespace as big as maxlen+alignment-1, get it.
@@ -1555,17 +1580,30 @@ restart:
 			if (error)
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			if (!check_busy ||
-			    !xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
+			xfs_alloc_compute_aligned(args, fbno, flen,
+							&rbno, &rlen);
+			if (rlen >= args->maxlen)
 				break;
 			error = xfs_btree_increment(cnt_cur, 0, &i);
 			if (error)
 				goto error0;
 			if (i == 0) {
-				ASSERT(check_busy);
-				check_busy = 0;
+				/*
+				 * Our only valid extents must have been busy.
+				 * Make it unbusy by forcing the log out and
+				 * retrying. If we've been here before, forcing
+				 * the log isn't making the extents available,
+				 * which means they have probably been freed in
+				 * this transaction. In that case, we have to
+				 * give up on them and we'll attempt a minlen
+				 * allocation the next time around.
+				 */
 				xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 				TRACE_ALLOC("busy restart", args);
+				if (!forced)
+					xfs_log_force(args->mp, 0,
+						XFS_LOG_FORCE|XFS_LOG_SYNC);
+				forced++;
 				goto restart;
 			}
 		}
@@ -1576,8 +1614,6 @@ restart:
 	 * once aligned; if not, we search left for something better.
 	 * This can't happen in the second case above.
 	 */
-	xfs_alloc_compute_aligned(fbno, flen, args->alignment, args->minlen,
-		&rbno, &rlen);
 	rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
 	XFS_WANT_CORRUPTED_GOTO(rlen == 0 ||
 			(rlen <= flen && rbno + rlen <= fbno + flen), error0);
@@ -1604,15 +1640,8 @@ restart:
 			if (flen < bestrlen)
 				break;
 
-			/*
-			 * avoid busy candidate extents as they are clearly not
-			 * a better choice than other extents due to the log
-			 * force penalty of using them.
-			 */
-			if (xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
-				continue;
-			xfs_alloc_compute_aligned(fbno, flen, args->alignment,
-				args->minlen, &rbno, &rlen);
+			xfs_alloc_compute_aligned(args, fbno, flen,
+							&rbno, &rlen);
 			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
 			XFS_WANT_CORRUPTED_GOTO(rlen == 0 ||
 				(rlen <= flen && rbno + rlen <= fbno + flen),
@@ -1640,13 +1669,19 @@ restart:
 	 * Fix up the length.
 	 */
 	args->len = rlen;
-	xfs_alloc_fix_len(args);
-	if (rlen < args->minlen || !xfs_alloc_fix_minleft(args)) {
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-		TRACE_ALLOC("nominleft", args);
-		args->agbno = NULLAGBLOCK;
-		return 0;
+	if (rlen < args->minlen) {
+		if (!forced) {
+			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+			TRACE_ALLOC("busy restart", args);
+			xfs_log_force(args->mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+			forced++;
+			goto restart;
+		}
+		goto out_nominleft;
 	}
+	xfs_alloc_fix_len(args);
+	if (!xfs_alloc_fix_minleft(args))
+		goto out_nominleft;
 	rlen = args->len;
 	XFS_WANT_CORRUPTED_GOTO(rlen <= flen, error0);
 	/*
@@ -1676,6 +1711,12 @@ error0:
 	if (bno_cur)
 		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
 	return error;
+
+out_nominleft:
+	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+	TRACE_ALLOC("nominleft", args);
+	args->agbno = NULLAGBLOCK;
+	return 0;
 }
 
 /*
@@ -2327,10 +2368,24 @@ xfs_alloc_get_freelist(
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
 
-	/* handle busy extents */
-	if (xfs_alloc_search_clear_busy_freelist(tp,
-			be32_to_cpu(agf->agf_seqno), bno, 1, btreeblk))
-		xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+	/*
+	 * for busy btree blocks, we want to remove them from the
+	 * busy tree as we are now reusing it. Other busy extents
+	 * require a log force to be able to use safely.
+	 */
+	if (btreeblk) {
+		struct xfs_busy_extent	*busyp;
+
+		busyp = xfs_alloc_busy_search(tp, be32_to_cpu(agf->agf_seqno),
+							bno, 1);
+		if (busyp) {
+			if (busyp->flags & XFS_BUSY_EXT_FREELIST)
+				xfs_alloc_clear_busy(tp, busyp);
+			else
+				xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+			xfs_alloc_busy_put(busyp);
+		}
+	}
 
 	return 0;
 }
-- 
1.5.6.5
