Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:08:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97M86fH009025
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:08:06 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DDC41B0C579
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:09:44 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id t1eq3U3tEUM8h1st for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:09:44 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKkL-0002Vj-JY
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:09:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] XFS: Don't use log forces when busy extents are allocated
Date: Wed,  8 Oct 2008 09:09:34 +1100
Message-Id: <1223417377-8679-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417377-8679-1-git-send-email-david@fromorbit.com>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Even though we try to avoid busy extents, there are still situations
where we can't avoid them (such as allocation from the AGFL). To
minimise the overhead of such allocation behaviour, we mark the
transaction doing the allocation as synchronous rather than
triggering a log force to get the previous freeing transaction on
disk.

The synchronous transaction provides the same guarantees as a
synchronous log force because it ensures that all the transactions
are on disk. i.e. it preserves the free->allocate order of the
extent correctly in recovery.

The big advantage to this method comes from the fact that we don't
hold the AGF locked during the writeback of the log buffers during
transaction commit. Hence we can be doing further allocations while
the synchronous transaction is committing, unlike the current
synchronous log force case.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_ag.h    |    1 -
 fs/xfs/xfs_alloc.c |   93 ++++++++++++++++++++--------------------------------
 2 files changed, 36 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index e7aaa1c..7048d3d 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -164,7 +164,6 @@ struct xfs_busy_extent {
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
-	struct xfs_trans *tp;	/* transaction that did the free */
 };
 
 /*
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 77dc18e..f9d092e 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -142,7 +142,6 @@ xfs_alloc_mark_busy(
 	busyp->agno = agno;
 	busyp->bno = bno;
 	busyp->length = len;
-	busyp->tp = tp;
 
 	pag = xfs_perag_get(tp->t_mountp, agno);
 	spin_lock(&pag->pagb_lock);
@@ -155,11 +154,10 @@ xfs_alloc_mark_busy(
 
 /*
  * Search for a busy extent within the range of the extent we are about to
- * allocate.  You need to be holding the busy extent tree lock when calling
- * __xfs_alloc_busy_search().
+ * allocate.
  */
 static struct xfs_busy_extent *
-__xfs_alloc_busy_search(
+xfs_alloc_busy_search(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
@@ -171,6 +169,7 @@ __xfs_alloc_busy_search(
 
 	uend = bno + len - 1;
 	pag = xfs_perag_get(tp->t_mountp, agno);
+	spin_lock(&pag->pagb_lock);
 	rbp = pag->pagb_tree.rb_node;
 	while (rbp) {
 		struct xfs_busy_extent	*busyp;
@@ -183,12 +182,14 @@ __xfs_alloc_busy_search(
 			rbp = rbp->rb_right;
 		else {
 			/* (start1,length1) within (start2, length2) */
-			TRACE_BUSYSEARCH("xfs_alloc_search_busy",
+			TRACE_BUSYSEARCH("xfs_alloc_busy_search",
 					 "found1", agno, bno, len, tp);
+			spin_unlock(&pag->pagb_lock);
 			xfs_perag_put(pag);
 			return busyp;
 		}
 	}
+	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
 	return NULL;
 }
@@ -200,13 +201,12 @@ xfs_alloc_clear_busy(
 {
 	struct xfs_perag	*pag;
 
-	pag = xfs_perag_get(tp->t_mountp, busyp->agno);
-	spin_lock(&pag->pagb_lock);
-
 	/* check that the busyp is still in the rbtree */
-	ASSERT(__xfs_alloc_busy_search(tp, busyp->agno, busyp->bno,
+	ASSERT(xfs_alloc_busy_search(tp, busyp->agno, busyp->bno,
 						busyp->length) == busyp);
 
+	pag = xfs_perag_get(tp->t_mountp, busyp->agno);
+	spin_lock(&pag->pagb_lock);
 	TRACE_UNBUSY("xfs_alloc_clear_busy", "found", busyp->agno, busyp->bno,
 							busyp->length, tp);
 	rb_erase(&busyp->rb_node, &pag->pagb_tree);
@@ -217,41 +217,6 @@ xfs_alloc_clear_busy(
 }
 
 /*
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
-
-/*
  * Internal functions.
  */
 
@@ -852,9 +817,16 @@ xfs_alloc_ag_vextent(
 			TRACE_MODAGF(NULL, agf, XFS_AGF_FREEBLKS);
 			xfs_alloc_log_agf(args->tp, args->agbp,
 						XFS_AGF_FREEBLKS);
-			/* search the busylist for these blocks */
-			xfs_alloc_search_busy(args->tp, args->agno,
-					args->agbno, args->len);
+			/*
+			 * Search the busylist for these blocks and mark the
+			 * transaction as synchronous if blocks are found. This
+			 * avoids the need to block in due to a synchronous log
+			 * force to ensure correct ordering as the synchronous
+			 * transaction will guarantee that for us.
+			 */
+			if (xfs_alloc_busy_search(args->tp, args->agno,
+						args->agbno, args->len))
+				xfs_trans_set_sync(args->tp);
 		}
 		if (!args->isfl)
 			xfs_trans_mod_sb(args->tp,
@@ -914,7 +886,7 @@ xfs_alloc_ag_vextent_exact(
 	error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i);
 	if (error)
 		goto error0;
-	if (__xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
+	if (xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
 		goto not_found;
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	ASSERT(fbno <= args->agbno);
@@ -1009,7 +981,7 @@ xfs_alloc_find_best_extent(
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		xfs_alloc_compute_aligned(*sbno, *slen, args->alignment,
 					args->minlen, &bno, slena);
-		if (__xfs_alloc_busy_search(args->tp, args->agno, bno, *slena)) {
+		if (xfs_alloc_busy_search(args->tp, args->agno, bno, *slena)) {
 			/* just freed - skip this one */
 			goto next_record;
 		}
@@ -1189,7 +1161,7 @@ xfs_alloc_ag_vextent_near(
 					args->minlen, &ltbnoa, &ltlena);
 			if (ltlena < args->minlen)
 				continue;
-			if (__xfs_alloc_busy_search(args->tp, args->agno, ltbnoa, ltlena))
+			if (xfs_alloc_busy_search(args->tp, args->agno, ltbnoa, ltlena))
 				continue;
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
@@ -1311,7 +1283,7 @@ xfs_alloc_ag_vextent_near(
 			xfs_alloc_compute_aligned(ltbno, ltlen, args->alignment,
 					args->minlen, &ltbnoa, &ltlena);
 			if (ltlena >= args->minlen &&
-			    !__xfs_alloc_busy_search(args->tp, args->agno, ltbnoa, ltlena))
+			    !xfs_alloc_busy_search(args->tp, args->agno, ltbnoa, ltlena))
 				break;
 			/*
 			 * clear the length so we don't accidentally use this
@@ -1334,7 +1306,7 @@ xfs_alloc_ag_vextent_near(
 			xfs_alloc_compute_aligned(gtbno, gtlen, args->alignment,
 					args->minlen, &gtbnoa, &gtlena);
 			if (gtlena >= args->minlen &&
-			    !__xfs_alloc_busy_search(args->tp, args->agno, gtbnoa, gtlena))
+			    !xfs_alloc_busy_search(args->tp, args->agno, gtbnoa, gtlena))
 				break;
 			gtlena = 0;
 			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
@@ -1513,7 +1485,7 @@ restart:
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			if (!check_busy ||
-			    !__xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
+			    !xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
 				break;
 			error = xfs_btree_increment(cnt_cur, 0, &i);
 			if (error)
@@ -1566,7 +1538,7 @@ restart:
 			 * a better choice than other extents due to the log
 			 * force penalty of using them.
 			 */
-			if (__xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
+			if (xfs_alloc_busy_search(args->tp, args->agno, fbno, flen))
 				continue;
 			xfs_alloc_compute_aligned(fbno, flen, args->alignment,
 				args->minlen, &rbno, &rlen);
@@ -2267,10 +2239,17 @@ xfs_alloc_get_freelist(
 	 * and remain there until the freeing transaction is committed to
 	 * disk.  Now that we have allocated blocks, this list must be
 	 * searched to see if a block is being reused.  If one is, then
-	 * the freeing transaction must be pushed to disk NOW by forcing
-	 * to disk all iclogs up that transaction's LSN.
+	 * the freeing transaction must be pushed to disk before this
+	 * transaction.
+	 *
+	 * We do this by setting the current transaction
+	 * to a sync transaction which guarantees that the freeing transaction
+	 * is on disk before this transaction. This is done instead of a
+	 * synchronous log force here so that we don't sit and wait with
+	 * the AGF locked in the transaction during the log force.
 	 */
-	xfs_alloc_search_busy(tp, be32_to_cpu(agf->agf_seqno), bno, 1);
+	if (xfs_alloc_busy_search(tp, be32_to_cpu(agf->agf_seqno), bno, 1))
+		xfs_trans_set_sync(tp);
 	return 0;
 }
 
-- 
1.5.6.5
