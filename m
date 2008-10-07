Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:08:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97M86cc009022
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:08:06 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D9231B0C572
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:09:43 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 5DjWuQ4Xa5NgYZpZ for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:09:43 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKkL-0002Vf-HZ
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:09:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/7] XFS: Don't immediately reallocate busy extents
Date: Wed,  8 Oct 2008 09:09:33 +1100
Message-Id: <1223417377-8679-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417377-8679-1-git-send-email-david@fromorbit.com>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Every time we reallocate a busy extent, we cause a synchronous log
force to occur to ensure the freeing transaction is on disk before
we continue and use the newly allocated extent. This is extremely
sub-optimal as it means we are holding the AGF locked over a
blocking log force that could take several hundred milliseconds
to complete. This prevents us from making progress and other
allocations and freeing from ocurring in that AG for that period
of time.

Instead of searching the busy extent list after deciding on the
extent to allocate, check each candidate extent during the
allocation decisions as to whether they are in the busy list.
If they are in the busy list, we don't consider that extent a
good choice to allocate. This will have relatively low overhead
because the rbtree is indexed by block number so searches should
find a busy extent very quickly.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_alloc.c |  779 +++++++++++++++++++++++++---------------------------
 1 files changed, 380 insertions(+), 399 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 98908ba..77dc18e 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -45,12 +45,6 @@
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
-STATIC void
-xfs_alloc_search_busy(xfs_trans_t *tp,
-		    xfs_agnumber_t agno,
-		    xfs_agblock_t bno,
-		    xfs_extlen_t len);
-
 #if defined(XFS_ALLOC_TRACE)
 ktrace_t *xfs_alloc_trace_buf;
 
@@ -85,6 +79,178 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 	xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
 
+
+
+/*
+ * AG Busy list management
+ * The busy list contains block ranges that have been freed but whose
+ * transactions have not yet hit disk.  If any block listed in a busy
+ * list is reused, the transaction that freed it must be forced to disk
+ * before continuing to use the block.
+ *
+ * xfs_alloc_mark_busy - add to the per-ag busy list
+ * xfs_alloc_clear_busy - remove an item from the per-ag busy list
+ */
+static void
+xfs_alloc_busy_insert(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		bno,
+	struct rb_node		*node)
+{
+	struct rb_node		**rbp = &pag->pagb_tree.rb_node;
+	struct rb_node		*parent = NULL;
+	struct xfs_busy_extent	*busyp;
+
+	while (*rbp) {
+		parent = *rbp;
+		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
+
+		if (bno < busyp->bno)
+			rbp = &(*rbp)->rb_left;
+		else if (bno > busyp->bno)
+			rbp = &(*rbp)->rb_right;
+		else
+			BUG();
+	}
+
+	rb_link_node(node, parent, rbp);
+	rb_insert_color(node, &pag->pagb_tree);
+}
+
+void
+xfs_alloc_mark_busy(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
+{
+	struct xfs_busy_extent	*busyp;
+	struct xfs_perag	*pag;
+
+	busyp = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
+	if (!busyp) {
+		/*
+		 * No Memory!  Since it is now not possible to track the free
+		 * block, make this a synchronous transaction to insure that
+		 * the block is not reused before this transaction commits.
+		 */
+		TRACE_BUSY("xfs_alloc_mark_busy", "ENOMEM", agno, bno, len, tp);
+		xfs_trans_set_sync(tp);
+		return;
+	}
+
+	busyp->agno = agno;
+	busyp->bno = bno;
+	busyp->length = len;
+	busyp->tp = tp;
+
+	pag = xfs_perag_get(tp->t_mountp, agno);
+	spin_lock(&pag->pagb_lock);
+	xfs_alloc_busy_insert(pag, bno, &busyp->rb_node);
+	xfs_trans_add_busy(tp, busyp);
+	TRACE_BUSY("xfs_alloc_mark_busy", "got", agno, bno, len, tp);
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+}
+
+/*
+ * Search for a busy extent within the range of the extent we are about to
+ * allocate.  You need to be holding the busy extent tree lock when calling
+ * __xfs_alloc_busy_search().
+ */
+static struct xfs_busy_extent *
+__xfs_alloc_busy_search(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
+{
+	struct xfs_perag	*pag;
+	struct rb_node		*rbp;
+	xfs_agblock_t		uend, bend;
+
+	uend = bno + len - 1;
+	pag = xfs_perag_get(tp->t_mountp, agno);
+	rbp = pag->pagb_tree.rb_node;
+	while (rbp) {
+		struct xfs_busy_extent	*busyp;
+
+		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		bend = busyp->bno + busyp->length - 1;
+		if (uend < busyp->bno)
+			rbp = rbp->rb_left;
+		else if (bno > bend)
+			rbp = rbp->rb_right;
+		else {
+			/* (start1,length1) within (start2, length2) */
+			TRACE_BUSYSEARCH("xfs_alloc_search_busy",
+					 "found1", agno, bno, len, tp);
+			xfs_perag_put(pag);
+			return busyp;
+		}
+	}
+	xfs_perag_put(pag);
+	return NULL;
+}
+
+void
+xfs_alloc_clear_busy(
+	struct xfs_trans	*tp,
+	struct xfs_busy_extent	*busyp)
+{
+	struct xfs_perag	*pag;
+
+	pag = xfs_perag_get(tp->t_mountp, busyp->agno);
+	spin_lock(&pag->pagb_lock);
+
+	/* check that the busyp is still in the rbtree */
+	ASSERT(__xfs_alloc_busy_search(tp, busyp->agno, busyp->bno,
+						busyp->length) == busyp);
+
+	TRACE_UNBUSY("xfs_alloc_clear_busy", "found", busyp->agno, busyp->bno,
+							busyp->length, tp);
+	rb_erase(&busyp->rb_node, &pag->pagb_tree);
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+
+	kmem_free(busyp);
+}
+
+/*
+ * If we find the extent in the busy list, force the log out to get the
+ * extent out of the busy list so the caller can use it straight away.
+ */
+STATIC void
+xfs_alloc_search_busy(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
+{
+	struct xfs_perag	*pag;
+	struct xfs_busy_extent	*busyp;
+	xfs_lsn_t		lsn;
+
+	pag = xfs_perag_get(tp->t_mountp, agno);
+	spin_lock(&pag->pagb_lock);
+	busyp = __xfs_alloc_busy_search(tp, agno, bno, len);
+	if (!busyp) {
+		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "not-found", agno, bno, len, tp);
+		spin_unlock(&pag->pagb_lock);
+		xfs_perag_put(pag);
+		return;
+	}
+	/*
+	 * A block was found, force the log through the LSN of the
+	 * transaction that freed the block
+	 */
+	TRACE_BUSYSEARCH("xfs_alloc_search_busy", "found", agno, bno, len, tp);
+	lsn = busyp->tp->t_commit_lsn;
+	spin_unlock(&pag->pagb_lock);
+	xfs_log_force(tp->t_mountp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
+	xfs_perag_put(pag);
+}
+
 /*
  * Internal functions.
  */
@@ -705,6 +871,12 @@ xfs_alloc_ag_vextent(
  * Extent's length (returned in *len) will be between minlen and maxlen,
  * and of the form k * prod + mod unless there's nothing that large.
  * Return the starting a.g. block (bno), or NULLAGBLOCK if we can't do it.
+ *
+ * Avoid allocating extents that span a busy extent range to avoid causing a
+ * synchronous log force to be required during the transaction and hence avoid
+ * holding the AGF locked for an excessive period of time. If we are doing low
+ * space allocation, speed is a secondary factor so in that case we will use
+ * busy extents and take the hit....
  */
 STATIC int			/* error */
 xfs_alloc_ag_vextent_exact(
@@ -735,46 +907,36 @@ xfs_alloc_ag_vextent_exact(
 	 */
 	if ((error = xfs_alloc_lookup_le(bno_cur, args->agbno, args->minlen, &i)))
 		goto error0;
-	if (!i) {
-		/*
-		 * Didn't find it, return null.
-		 */
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
-	/*
-	 * Grab the freespace record.
-	 */
-	if ((error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i)))
+	if (!i)
+		goto not_found;
+
+	/* Grab a non-busy freespace record. */
+	error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i);
+	if (error)
 		goto error0;
+	if (__xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
+		goto not_found;
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	ASSERT(fbno <= args->agbno);
+
+	/* Give up if the freespace isn't long enough for the minimum request. */
 	minend = args->agbno + args->minlen;
 	maxend = args->agbno + args->maxlen;
 	fend = fbno + flen;
-	/*
-	 * Give up if the freespace isn't long enough for the minimum request.
-	 */
-	if (fend < minend) {
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
+	if (fend < minend)
+		goto not_found;
 	/*
 	 * End of extent will be smaller of the freespace end and the
 	 * maximal requested end.
 	 */
 	end = XFS_AGBLOCK_MIN(fend, maxend);
-	/*
-	 * Fix the length according to mod and prod if given.
-	 */
+
+	/* Fix the length according to mod and prod if given. */
 	args->len = end - args->agbno;
 	xfs_alloc_fix_len(args);
-	if (!xfs_alloc_fix_minleft(args)) {
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-		return 0;
-	}
+	if (!xfs_alloc_fix_minleft(args))
+		goto not_found;
+
 	rlen = args->len;
 	ASSERT(args->agbno + rlen <= fend);
 	end = args->agbno + rlen;
@@ -797,6 +959,13 @@ xfs_alloc_ag_vextent_exact(
 	args->wasfromfl = 0;
 	return 0;
 
+not_found:
+	/* Didn't find it, return null. */
+	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
+	args->agbno = NULLAGBLOCK;
+	TRACE_ALLOC("not found", args);
+	return 0;
+
 error0:
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
 	TRACE_ALLOC("error", args);
@@ -804,10 +973,104 @@ error0:
 }
 
 /*
+ * Search the btree in a given direction via the search cursor
+ * and compare the records found against the good extent we've
+ * already found.
+ */
+STATIC int
+xfs_alloc_find_best_extent(
+	xfs_alloc_arg_t	*args,
+	xfs_btree_cur_t	**gcur,		/* good cursor */
+	xfs_btree_cur_t	**scur,		/* searching cursor */
+	xfs_agblock_t	gdiff,		/* difference for search comparison */
+	xfs_agblock_t	*sbno,		/* extent found by search */
+	xfs_extlen_t	*slen,
+	xfs_extlen_t	*slena,		/* aligned length */
+	int		dir)	/* 0 = search right, 1 = search left */
+{
+	xfs_agblock_t	bno;
+	xfs_agblock_t	new;
+	xfs_agblock_t	sdiff;
+	int		i;
+	int		error;
+
+	/* The good extent is perfect, no need to  search. */
+	if (!gdiff)
+		goto out_use_good;
+
+	/*
+	 * Look until we find a better one, run out of
+	 * space, or run off the end.
+	 */
+	do {
+		error = xfs_alloc_get_rec(*scur, sbno, slen, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		xfs_alloc_compute_aligned(*sbno, *slen, args->alignment,
+					args->minlen, &bno, slena);
+		if (__xfs_alloc_busy_search(args->tp, args->agno, bno, *slena)) {
+			/* just freed - skip this one */
+			goto next_record;
+		}
+
+		/* The good extent is closer than this one */
+		if (!dir) {
+			if (bno >= args->agbno + gdiff)
+				goto out_use_good;
+		} else {
+			if (bno <= args->agbno - gdiff)
+				goto out_use_good;
+		}
+
+		/* Same distance, compare length and pick the best. */
+		if (*slena >= args->minlen) {
+			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
+			xfs_alloc_fix_len(args);
+			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
+					args->alignment, *sbno, *slen, &new);
+
+			/* choose closer size and invalidate other cursor */
+			if (sdiff < gdiff)
+				goto out_use_search;
+			goto out_use_good;
+		}
+next_record:
+		if (!dir)
+			error = xfs_btree_increment(*scur, 0, &i);
+		else
+			error = xfs_btree_decrement(*scur, 0, &i);
+		if (error)
+			goto error0;
+	} while (i);
+
+out_use_good:
+	xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
+	*scur = NULL;
+	return 0;
+
+out_use_search:
+	xfs_btree_del_cursor(*gcur, XFS_BTREE_NOERROR);
+	*gcur = NULL;
+	return 0;
+
+error0:
+	/* caller invalidates cursors */
+	return error;
+
+}
+
+/*
  * Allocate a variable extent near bno in the allocation group agno.
  * Extent's length (returned in len) will be between minlen and maxlen,
  * and of the form k * prod + mod unless there's nothing that large.
  * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
+ *
+ * Avoid allocating extents that span a busy extent range to avoid causing a
+ * synchronous log force to be required during the transaction and hence avoid
+ * holding the AGF locked for an excessive period of time. If we are doing low
+ * space allocation, speed is a secondary factor so in that case we will use
+ * busy extents and take the hit....
  */
 STATIC int				/* error */
 xfs_alloc_ag_vextent_near(
@@ -926,6 +1189,8 @@ xfs_alloc_ag_vextent_near(
 					args->minlen, &ltbnoa, &ltlena);
 			if (ltlena < args->minlen)
 				continue;
+			if (__xfs_alloc_busy_search(args->tp, args->agno, ltbnoa, ltlena))
+				continue;
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			ASSERT(args->len >= args->minlen);
@@ -1045,8 +1310,15 @@ xfs_alloc_ag_vextent_near(
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			xfs_alloc_compute_aligned(ltbno, ltlen, args->alignment,
 					args->minlen, &ltbnoa, &ltlena);
-			if (ltlena >= args->minlen)
+			if (ltlena >= args->minlen &&
+			    !__xfs_alloc_busy_search(args->tp, args->agno, ltbnoa, ltlena))
 				break;
+			/*
+			 * clear the length so we don't accidentally use this
+			 * extent after we decrement the cursor then find a
+			 * match from the other cursor.
+			 */
+			ltlena = 0;
 			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
 				goto error0;
 			if (!i) {
@@ -1061,8 +1333,10 @@ xfs_alloc_ag_vextent_near(
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			xfs_alloc_compute_aligned(gtbno, gtlen, args->alignment,
 					args->minlen, &gtbnoa, &gtlena);
-			if (gtlena >= args->minlen)
+			if (gtlena >= args->minlen &&
+			    !__xfs_alloc_busy_search(args->tp, args->agno, gtbnoa, gtlena))
 				break;
+			gtlena = 0;
 			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
 				goto error0;
 			if (!i) {
@@ -1072,201 +1346,39 @@ xfs_alloc_ag_vextent_near(
 			}
 		}
 	} while (bno_cur_lt || bno_cur_gt);
-	/*
-	 * Got both cursors still active, need to find better entry.
-	 */
+
+	/* Got both cursors still active, need to find better entry. */
 	if (bno_cur_lt && bno_cur_gt) {
-		/*
-		 * Left side is long enough, look for a right side entry.
-		 */
 		if (ltlena >= args->minlen) {
-			/*
-			 * Fix up the length.
-			 */
+			/* Left side is good, look for a right side entry. */
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			rlen = args->len;
 			ltdiff = xfs_alloc_compute_diff(args->agbno, rlen,
 				args->alignment, ltbno, ltlen, &ltnew);
-			/*
-			 * Not perfect.
-			 */
-			if (ltdiff) {
-				/*
-				 * Look until we find a better one, run out of
-				 * space, or run off the end.
-				 */
-				while (bno_cur_lt && bno_cur_gt) {
-					if ((error = xfs_alloc_get_rec(
-							bno_cur_gt, &gtbno,
-							&gtlen, &i)))
-						goto error0;
-					XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-					xfs_alloc_compute_aligned(gtbno, gtlen,
-						args->alignment, args->minlen,
-						&gtbnoa, &gtlena);
-					/*
-					 * The left one is clearly better.
-					 */
-					if (gtbnoa >= args->agbno + ltdiff) {
-						xfs_btree_del_cursor(
-							bno_cur_gt,
-							XFS_BTREE_NOERROR);
-						bno_cur_gt = NULL;
-						break;
-					}
-					/*
-					 * If we reach a big enough entry,
-					 * compare the two and pick the best.
-					 */
-					if (gtlena >= args->minlen) {
-						args->len =
-							XFS_EXTLEN_MIN(gtlena,
-								args->maxlen);
-						xfs_alloc_fix_len(args);
-						rlen = args->len;
-						gtdiff = xfs_alloc_compute_diff(
-							args->agbno, rlen,
-							args->alignment,
-							gtbno, gtlen, &gtnew);
-						/*
-						 * Right side is better.
-						 */
-						if (gtdiff < ltdiff) {
-							xfs_btree_del_cursor(
-								bno_cur_lt,
-								XFS_BTREE_NOERROR);
-							bno_cur_lt = NULL;
-						}
-						/*
-						 * Left side is better.
-						 */
-						else {
-							xfs_btree_del_cursor(
-								bno_cur_gt,
-								XFS_BTREE_NOERROR);
-							bno_cur_gt = NULL;
-						}
-						break;
-					}
-					/*
-					 * Fell off the right end.
-					 */
-					if ((error = xfs_btree_increment(
-							bno_cur_gt, 0, &i)))
-						goto error0;
-					if (!i) {
-						xfs_btree_del_cursor(
-							bno_cur_gt,
-							XFS_BTREE_NOERROR);
-						bno_cur_gt = NULL;
-						break;
-					}
-				}
-			}
-			/*
-			 * The left side is perfect, trash the right side.
-			 */
-			else {
-				xfs_btree_del_cursor(bno_cur_gt,
-						     XFS_BTREE_NOERROR);
-				bno_cur_gt = NULL;
-			}
-		}
-		/*
-		 * It's the right side that was found first, look left.
-		 */
-		else {
-			/*
-			 * Fix up the length.
-			 */
+
+			error = xfs_alloc_find_best_extent(args,
+						&bno_cur_lt, &bno_cur_gt,
+						ltdiff, &gtbno, &gtlen, &gtlena,
+						0 /* search right */);
+			if (error)
+				goto error0;
+		} else {
+			ASSERT(gtlena >= args->minlen);
+
+			/* Right side is good, look for a left side entry. */
 			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			rlen = args->len;
 			gtdiff = xfs_alloc_compute_diff(args->agbno, rlen,
 				args->alignment, gtbno, gtlen, &gtnew);
-			/*
-			 * Right side entry isn't perfect.
-			 */
-			if (gtdiff) {
-				/*
-				 * Look until we find a better one, run out of
-				 * space, or run off the end.
-				 */
-				while (bno_cur_lt && bno_cur_gt) {
-					if ((error = xfs_alloc_get_rec(
-							bno_cur_lt, &ltbno,
-							&ltlen, &i)))
-						goto error0;
-					XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-					xfs_alloc_compute_aligned(ltbno, ltlen,
-						args->alignment, args->minlen,
-						&ltbnoa, &ltlena);
-					/*
-					 * The right one is clearly better.
-					 */
-					if (ltbnoa <= args->agbno - gtdiff) {
-						xfs_btree_del_cursor(
-							bno_cur_lt,
-							XFS_BTREE_NOERROR);
-						bno_cur_lt = NULL;
-						break;
-					}
-					/*
-					 * If we reach a big enough entry,
-					 * compare the two and pick the best.
-					 */
-					if (ltlena >= args->minlen) {
-						args->len = XFS_EXTLEN_MIN(
-							ltlena, args->maxlen);
-						xfs_alloc_fix_len(args);
-						rlen = args->len;
-						ltdiff = xfs_alloc_compute_diff(
-							args->agbno, rlen,
-							args->alignment,
-							ltbno, ltlen, &ltnew);
-						/*
-						 * Left side is better.
-						 */
-						if (ltdiff < gtdiff) {
-							xfs_btree_del_cursor(
-								bno_cur_gt,
-								XFS_BTREE_NOERROR);
-							bno_cur_gt = NULL;
-						}
-						/*
-						 * Right side is better.
-						 */
-						else {
-							xfs_btree_del_cursor(
-								bno_cur_lt,
-								XFS_BTREE_NOERROR);
-							bno_cur_lt = NULL;
-						}
-						break;
-					}
-					/*
-					 * Fell off the left end.
-					 */
-					if ((error = xfs_btree_decrement(
-							bno_cur_lt, 0, &i)))
-						goto error0;
-					if (!i) {
-						xfs_btree_del_cursor(bno_cur_lt,
-							XFS_BTREE_NOERROR);
-						bno_cur_lt = NULL;
-						break;
-					}
-				}
-			}
-			/*
-			 * The right side is perfect, trash the left side.
-			 */
-			else {
-				xfs_btree_del_cursor(bno_cur_lt,
-					XFS_BTREE_NOERROR);
-				bno_cur_lt = NULL;
-			}
+
+			error = xfs_alloc_find_best_extent(args,
+						&bno_cur_gt, &bno_cur_lt,
+						gtdiff, &ltbno, &ltlen, &ltlena,
+						1 /* search left */);
+			if (error)
+				goto error0;
 		}
 	}
 	/*
@@ -1287,7 +1399,7 @@ xfs_alloc_ag_vextent_near(
 		bno_cur_lt = bno_cur_gt;
 		bno_cur_gt = NULL;
 		ltbno = gtbno;
-		ltbnoa = gtbnoa;
+		//ltbnoa = gtbnoa;
 		ltlen = gtlen;
 		ltlena = gtlena;
 		j = 1;
@@ -1332,10 +1444,16 @@ xfs_alloc_ag_vextent_near(
 }
 
 /*
- * Allocate a variable extent anywhere in the allocation group agno.
- * Extent's length (returned in len) will be between minlen and maxlen,
- * and of the form k * prod + mod unless there's nothing that large.
- * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
+ * Allocate a variable extent anywhere in the allocation group agno.  Extent's
+ * length (returned in len) will be between minlen and maxlen, and of the form
+ * k * prod + mod unless there's nothing that large.  Return the starting a.g.
+ * block, or NULLAGBLOCK if we can't do it.
+ *
+ * Avoid allocating extents that span a busy extent range to avoid causing a
+ * synchronous log force to be required during the transaction and hence avoid
+ * holding the AGF locked for an excessive period of time. If we are doing low
+ * space allocation, speed is a secondary factor so in that case we will use
+ * busy extents and take the hit....
  */
 STATIC int				/* error */
 xfs_alloc_ag_vextent_size(
@@ -1349,10 +1467,12 @@ xfs_alloc_ag_vextent_size(
 	int		i;		/* temp status variable */
 	xfs_agblock_t	rbno;		/* returned block number */
 	xfs_extlen_t	rlen;		/* length of returned extent */
+	int		check_busy = 1;
 
 	/*
 	 * Allocate and initialize a cursor for the by-size btree.
 	 */
+restart:
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_CNT);
 	bno_cur = NULL;
@@ -1381,9 +1501,31 @@ xfs_alloc_ag_vextent_size(
 	 * There's a freespace as big as maxlen+alignment-1, get it.
 	 */
 	else {
-		if ((error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		/*
+		 * Search for a non-busy extent that is large enough.
+		 * If we are at low space, don't check, or if we fall off
+		 * the end of the btree, turn off the busy check and
+		 * restart.
+		 */
+		for (;;) {
+			error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+			if (!check_busy ||
+			    !__xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
+				break;
+			error = xfs_btree_increment(cnt_cur, 0, &i);
+			if (error)
+				goto error0;
+			if (i == 0) {
+				ASSERT(check_busy);
+				check_busy = 0;
+				xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+				TRACE_ALLOC("busy restart", args);
+				goto restart;
+			}
+		}
 	}
 	/*
 	 * In the first case above, we got the last entry in the
@@ -1407,16 +1549,25 @@ xfs_alloc_ag_vextent_size(
 		bestflen = flen;
 		bestfbno = fbno;
 		for (;;) {
-			if ((error = xfs_btree_decrement(cnt_cur, 0, &i)))
+			error = xfs_btree_decrement(cnt_cur, 0, &i);
+			if (error)
 				goto error0;
 			if (i == 0)
 				break;
-			if ((error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen,
-					&i)))
+			error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i);
+			if (error)
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			if (flen < bestrlen)
 				break;
+
+			/*
+			 * avoid busy candidate extents as they are clearly not
+			 * a better choice than other extents due to the log
+			 * force penalty of using them.
+			 */
+			if (__xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
+				continue;
 			xfs_alloc_compute_aligned(fbno, flen, args->alignment,
 				args->minlen, &rbno, &rlen);
 			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
@@ -2566,173 +2717,3 @@ error0:
 	return error;
 }
 
-
-/*
- * AG Busy list management
- * The busy list contains block ranges that have been freed but whose
- * transactions have not yet hit disk.  If any block listed in a busy
- * list is reused, the transaction that freed it must be forced to disk
- * before continuing to use the block.
- *
- * xfs_alloc_mark_busy - add to the per-ag busy list
- * xfs_alloc_clear_busy - remove an item from the per-ag busy list
- */
-static void
-xfs_alloc_busy_insert(
-	struct xfs_perag	*pag,
-	xfs_agblock_t		bno,
-	struct rb_node		*node)
-{
-	struct rb_node		**rbp = &pag->pagb_tree.rb_node;
-	struct rb_node		*parent = NULL;
-	struct xfs_busy_extent	*busyp;
-
-	while (*rbp) {
-		parent = *rbp;
-		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
-
-		if (bno < busyp->bno)
-			rbp = &(*rbp)->rb_left;
-		else if (bno > busyp->bno)
-			rbp = &(*rbp)->rb_right;
-		else
-			BUG();
-	}
-
-	rb_link_node(node, parent, rbp);
-	rb_insert_color(node, &pag->pagb_tree);
-}
-
-void
-xfs_alloc_mark_busy(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len)
-{
-	struct xfs_busy_extent	*busyp;
-	struct xfs_perag	*pag;
-
-	busyp = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
-	if (!busyp) {
-		/*
-		 * No Memory!  Since it is now not possible to track the free
-		 * block, make this a synchronous transaction to insure that
-		 * the block is not reused before this transaction commits.
-		 */
-		TRACE_BUSY("xfs_alloc_mark_busy", "ENOMEM", agno, bno, len, tp);
-		xfs_trans_set_sync(tp);
-		return;
-	}
-
-	busyp->agno = agno;
-	busyp->bno = bno;
-	busyp->length = len;
-	busyp->tp = tp;
-
-	pag = xfs_perag_get(tp->t_mountp, agno);
-	spin_lock(&pag->pagb_lock);
-	xfs_alloc_busy_insert(pag, bno, &busyp->rb_node);
-	xfs_trans_add_busy(tp, busyp);
-	TRACE_BUSY("xfs_alloc_mark_busy", "got", agno, bno, len, tp);
-	spin_unlock(&pag->pagb_lock);
-	xfs_perag_put(pag);
-}
-
-/*
- * Search for a busy extent within the range of the extent we are about to
- * allocate.  You need to be holding the busy extent tree lock when calling
- * __xfs_alloc_busy_search().
- */
-static struct xfs_busy_extent *
-__xfs_alloc_busy_search(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len)
-{
-	struct xfs_perag	*pag;
-	struct rb_node		*rbp;
-	xfs_agblock_t		uend, bend;
-
-	uend = bno + len - 1;
-	pag = xfs_perag_get(tp->t_mountp, agno);
-	rbp = pag->pagb_tree.rb_node;
-	while (rbp) {
-		struct xfs_busy_extent	*busyp;
-
-		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
-		bend = busyp->bno + busyp->length - 1;
-		if (uend < busyp->bno)
-			rbp = rbp->rb_left;
-		else if (bno > bend)
-			rbp = rbp->rb_right;
-		else {
-			/* (start1,length1) within (start2, length2) */
-			TRACE_BUSYSEARCH("xfs_alloc_search_busy",
-					 "found1", agno, bno, len, tp);
-			xfs_perag_put(pag);
-			return busyp;
-		}
-	}
-	xfs_perag_put(pag);
-	return NULL;
-}
-
-void
-xfs_alloc_clear_busy(
-	struct xfs_trans	*tp,
-	struct xfs_busy_extent	*busyp)
-{
-	struct xfs_perag	*pag;
-
-	pag = xfs_perag_get(tp->t_mountp, busyp->agno);
-	spin_lock(&pag->pagb_lock);
-
-	/* check that the busyp is still in the rbtree */
-	ASSERT(__xfs_alloc_busy_search(tp, busyp->agno, busyp->bno,
-						busyp->length) == busyp);
-
-	TRACE_UNBUSY("xfs_alloc_clear_busy", "found", busyp->agno, busyp->bno,
-							busyp->length, tp);
-	rb_erase(&busyp->rb_node, &pag->pagb_tree);
-	spin_unlock(&pag->pagb_lock);
-	xfs_perag_put(pag);
-
-	kmem_free(busyp);
-}
-
-/*
- * If we find the extent in the busy list, force the log out to get the
- * extent out of the busy list so the caller can use it straight away.
- */
-STATIC void
-xfs_alloc_search_busy(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len)
-{
-	struct xfs_perag	*pag;
-	struct xfs_busy_extent	*busyp;
-	xfs_lsn_t		lsn;
-
-	pag = xfs_perag_get(tp->t_mountp, agno);
-	spin_lock(&pag->pagb_lock);
-	busyp = __xfs_alloc_busy_search(tp, agno, bno, len);
-	if (!busyp) {
-		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "not-found", agno, bno, len, tp);
-		spin_unlock(&pag->pagb_lock);
-		xfs_perag_put(pag);
-		return;
-	}
-	/*
-	 * A block was found, force the log through the LSN of the
-	 * transaction that freed the block
-	 */
-	TRACE_BUSYSEARCH("xfs_alloc_search_busy", "found", agno, bno, len, tp);
-	lsn = busyp->tp->t_commit_lsn;
-	spin_unlock(&pag->pagb_lock);
-	xfs_log_force(tp->t_mountp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
-	xfs_perag_put(pag);
-}
-- 
1.5.6.5
