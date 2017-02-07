Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754538AbdBGRQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2017 12:16:00 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cb9Mh-0006Tg-Pv
        for linux-xfs@vger.kernel.org; Tue, 07 Feb 2017 17:15:54 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] xfs: improve handling of busy extents in the low-level allocator
Date: Tue,  7 Feb 2017 18:14:58 +0100
Message-Id: <20170207171501.4268-3-hch@lst.de>
In-Reply-To: <20170207171501.4268-1-hch@lst.de>
References: <20170207171501.4268-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Currently we force the log and simply try again if we hit a busy extent,
but especially with online discard enabled it might take a while after
the log force for the busy extents to disappear, and we might have
already completed our second pass.

So instead we add a new waitqueue and a generation counter to the pag
structure so that we can do wakeups once we've removed busy extents,
and we replace the single retry with an unconditional one - after
all we hold the AGF buffer lock, so no other allocations or frees
can be racing with us in this AG.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c |  93 +++++++++++++++++++++-------------------
 fs/xfs/xfs_extent_busy.c  | 107 +++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_extent_busy.h  |   8 +++-
 fs/xfs/xfs_mount.c        |   1 +
 fs/xfs/xfs_mount.h        |   2 +
 5 files changed, 135 insertions(+), 76 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9f06a211e157..fe98fbc4adf1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -221,20 +221,22 @@ xfs_alloc_get_rec(
  * Compute aligned version of the found extent.
  * Takes alignment and min length into account.
  */
-STATIC void
+STATIC bool
 xfs_alloc_compute_aligned(
 	xfs_alloc_arg_t	*args,		/* allocation argument structure */
 	xfs_agblock_t	foundbno,	/* starting block in found extent */
 	xfs_extlen_t	foundlen,	/* length in found extent */
 	xfs_agblock_t	*resbno,	/* result block number */
-	xfs_extlen_t	*reslen)	/* result length */
+	xfs_extlen_t	*reslen,	/* result length */
+	unsigned	*busy_gen)
 {
-	xfs_agblock_t	bno;
-	xfs_extlen_t	len;
+	xfs_agblock_t	bno = foundbno;
+	xfs_extlen_t	len = foundlen;
 	xfs_extlen_t	diff;
+	bool		busy;
 
 	/* Trim busy sections out of found extent */
-	xfs_extent_busy_trim(args, foundbno, foundlen, &bno, &len);
+	busy = xfs_extent_busy_trim(args, &bno, &len, busy_gen);
 
 	/*
 	 * If we have a largish extent that happens to start before min_agbno,
@@ -259,6 +261,8 @@ xfs_alloc_compute_aligned(
 		*resbno = bno;
 		*reslen = len;
 	}
+
+	return busy;
 }
 
 /*
@@ -737,10 +741,11 @@ xfs_alloc_ag_vextent_exact(
 	int		error;
 	xfs_agblock_t	fbno;	/* start block of found extent */
 	xfs_extlen_t	flen;	/* length of found extent */
-	xfs_agblock_t	tbno;	/* start block of trimmed extent */
-	xfs_extlen_t	tlen;	/* length of trimmed extent */
-	xfs_agblock_t	tend;	/* end block of trimmed extent */
+	xfs_agblock_t	tbno;	/* start block of busy extent */
+	xfs_extlen_t	tlen;	/* length of busy extent */
+	xfs_agblock_t	tend;	/* end block of busy extent */
 	int		i;	/* success/failure of operation */
+	unsigned	busy_gen;
 
 	ASSERT(args->alignment == 1);
 
@@ -773,7 +778,9 @@ xfs_alloc_ag_vextent_exact(
 	/*
 	 * Check for overlapping busy extents.
 	 */
-	xfs_extent_busy_trim(args, fbno, flen, &tbno, &tlen);
+	tbno = fbno;
+	tlen = flen;
+	xfs_extent_busy_trim(args, &tbno, &tlen, &busy_gen);
 
 	/*
 	 * Give up if the start of the extent is busy, or the freespace isn't
@@ -853,6 +860,7 @@ xfs_alloc_find_best_extent(
 	xfs_agblock_t		sdiff;
 	int			error;
 	int			i;
+	unsigned		busy_gen;
 
 	/* The good extent is perfect, no need to  search. */
 	if (!gdiff)
@@ -866,7 +874,8 @@ xfs_alloc_find_best_extent(
 		if (error)
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-		xfs_alloc_compute_aligned(args, *sbno, *slen, sbnoa, slena);
+		xfs_alloc_compute_aligned(args, *sbno, *slen,
+				sbnoa, slena, &busy_gen);
 
 		/*
 		 * The good extent is closer than this one.
@@ -955,7 +964,8 @@ xfs_alloc_ag_vextent_near(
 	xfs_extlen_t	ltlena;		/* aligned ... */
 	xfs_agblock_t	ltnew;		/* useful start bno of left side */
 	xfs_extlen_t	rlen;		/* length of returned extent */
-	int		forced = 0;
+	bool		busy;
+	unsigned	busy_gen;
 #ifdef DEBUG
 	/*
 	 * Randomly don't execute the first algorithm.
@@ -982,6 +992,7 @@ xfs_alloc_ag_vextent_near(
 	ltlen = 0;
 	gtlena = 0;
 	ltlena = 0;
+	busy = false;
 
 	/*
 	 * Get a cursor for the by-size btree.
@@ -1064,8 +1075,8 @@ xfs_alloc_ag_vextent_near(
 			if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-			xfs_alloc_compute_aligned(args, ltbno, ltlen,
-						  &ltbnoa, &ltlena);
+			busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
+					&ltbnoa, &ltlena, &busy_gen);
 			if (ltlena < args->minlen)
 				continue;
 			if (ltbnoa < args->min_agbno || ltbnoa > args->max_agbno)
@@ -1183,8 +1194,8 @@ xfs_alloc_ag_vextent_near(
 			if ((error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-			xfs_alloc_compute_aligned(args, ltbno, ltlen,
-						  &ltbnoa, &ltlena);
+			busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
+					&ltbnoa, &ltlena, &busy_gen);
 			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
 				break;
 			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
@@ -1199,8 +1210,8 @@ xfs_alloc_ag_vextent_near(
 			if ((error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-			xfs_alloc_compute_aligned(args, gtbno, gtlen,
-						  &gtbnoa, &gtlena);
+			busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
+					&gtbnoa, &gtlena, &busy_gen);
 			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
 				break;
 			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
@@ -1261,9 +1272,9 @@ xfs_alloc_ag_vextent_near(
 	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 
-		if (!forced++) {
+		if (busy) {
 			trace_xfs_alloc_near_busy(args);
-			xfs_log_force(args->mp, XFS_LOG_SYNC);
+			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
 			goto restart;
 		}
 		trace_xfs_alloc_size_neither(args);
@@ -1344,7 +1355,8 @@ xfs_alloc_ag_vextent_size(
 	int		i;		/* temp status variable */
 	xfs_agblock_t	rbno;		/* returned block number */
 	xfs_extlen_t	rlen;		/* length of returned extent */
-	int		forced = 0;
+	bool		busy;
+	unsigned	busy_gen;
 
 restart:
 	/*
@@ -1353,6 +1365,7 @@ xfs_alloc_ag_vextent_size(
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_CNT);
 	bno_cur = NULL;
+	busy = false;
 
 	/*
 	 * Look for an entry >= maxlen+alignment-1 blocks.
@@ -1362,14 +1375,13 @@ xfs_alloc_ag_vextent_size(
 		goto error0;
 
 	/*
-	 * If none or we have busy extents that we cannot allocate from, then
-	 * we have to settle for a smaller extent. In the case that there are
-	 * no large extents, this will return the last entry in the tree unless
-	 * the tree is empty. In the case that there are only busy large
-	 * extents, this will return the largest small extent unless there
+	 * If none then we have to settle for a smaller extent. In the case that
+	 * there are no large extents, this will return the last entry in the
+	 * tree unless the tree is empty. In the case that there are only busy
+	 * large extents, this will return the largest small extent unless there
 	 * are no smaller extents available.
 	 */
-	if (!i || forced > 1) {
+	if (!i) {
 		error = xfs_alloc_ag_vextent_small(args, cnt_cur,
 						   &fbno, &flen, &i);
 		if (error)
@@ -1380,13 +1392,11 @@ xfs_alloc_ag_vextent_size(
 			return 0;
 		}
 		ASSERT(i == 1);
-		xfs_alloc_compute_aligned(args, fbno, flen, &rbno, &rlen);
+		busy = xfs_alloc_compute_aligned(args, fbno, flen, &rbno,
+				&rlen, &busy_gen);
 	} else {
 		/*
 		 * Search for a non-busy extent that is large enough.
-		 * If we are at low space, don't check, or if we fall of
-		 * the end of the btree, turn off the busy check and
-		 * restart.
 		 */
 		for (;;) {
 			error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i);
@@ -1394,8 +1404,8 @@ xfs_alloc_ag_vextent_size(
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 
-			xfs_alloc_compute_aligned(args, fbno, flen,
-						  &rbno, &rlen);
+			busy = xfs_alloc_compute_aligned(args, fbno, flen,
+					&rbno, &rlen, &busy_gen);
 
 			if (rlen >= args->maxlen)
 				break;
@@ -1407,18 +1417,13 @@ xfs_alloc_ag_vextent_size(
 				/*
 				 * Our only valid extents must have been busy.
 				 * Make it unbusy by forcing the log out and
-				 * retrying. If we've been here before, forcing
-				 * the log isn't making the extents available,
-				 * which means they have probably been freed in
-				 * this transaction.  In that case, we have to
-				 * give up on them and we'll attempt a minlen
-				 * allocation the next time around.
+				 * retrying.
 				 */
 				xfs_btree_del_cursor(cnt_cur,
 						     XFS_BTREE_NOERROR);
 				trace_xfs_alloc_size_busy(args);
-				if (!forced++)
-					xfs_log_force(args->mp, XFS_LOG_SYNC);
+				xfs_extent_busy_flush(args->mp,
+							args->pag, busy_gen);
 				goto restart;
 			}
 		}
@@ -1454,8 +1459,8 @@ xfs_alloc_ag_vextent_size(
 			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 			if (flen < bestrlen)
 				break;
-			xfs_alloc_compute_aligned(args, fbno, flen,
-						  &rbno, &rlen);
+			busy = xfs_alloc_compute_aligned(args, fbno, flen,
+					&rbno, &rlen, &busy_gen);
 			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
 			XFS_WANT_CORRUPTED_GOTO(args->mp, rlen == 0 ||
 				(rlen <= flen && rbno + rlen <= fbno + flen),
@@ -1484,10 +1489,10 @@ xfs_alloc_ag_vextent_size(
 	 */
 	args->len = rlen;
 	if (rlen < args->minlen) {
-		if (!forced++) {
+		if (busy) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_size_busy(args);
-			xfs_log_force(args->mp, XFS_LOG_SYNC);
+			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
 			goto restart;
 		}
 		goto out_nominleft;
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 29c2f997aedf..27c3ecb138e4 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -334,25 +334,30 @@ xfs_extent_busy_reuse(
  * subset of the extent that is not busy.  If *rlen is smaller than
  * args->minlen no suitable extent could be found, and the higher level
  * code needs to force out the log and retry the allocation.
+ *
+ * Return the current discard generation for the AG if the file system
+ * has online discard enabled.  This value can be used to wait for
+ * the trimmed extent to become fully available if the AG is running out
+ * of space.
  */
-void
+bool
 xfs_extent_busy_trim(
 	struct xfs_alloc_arg	*args,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	xfs_agblock_t		*rbno,
-	xfs_extlen_t		*rlen)
+	xfs_agblock_t		*bno,
+	xfs_extlen_t		*len,
+	unsigned		*busy_gen)
 {
 	xfs_agblock_t		fbno;
 	xfs_extlen_t		flen;
 	struct rb_node		*rbp;
+	bool			ret = false;
 
 	ASSERT(len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
 restart:
-	fbno = bno;
-	flen = len;
+	fbno = *bno;
+	flen = *len;
 	rbp = args->pag->pagb_tree.rb_node;
 	while (rbp && flen >= args->minlen) {
 		struct xfs_extent_busy *busyp =
@@ -504,24 +509,24 @@ xfs_extent_busy_trim(
 
 		flen = fend - fbno;
 	}
-	spin_unlock(&args->pag->pagb_lock);
-
-	if (fbno != bno || flen != len) {
-		trace_xfs_extent_busy_trim(args->mp, args->agno, bno, len,
+out:
+	if (fbno != *bno || flen != *len) {
+		trace_xfs_extent_busy_trim(args->mp, args->agno, *bno, *len,
 					  fbno, flen);
+		*bno = fbno;
+		*len = flen;
+		*busy_gen = args->pag->pagb_gen;
+		ret = true;
 	}
-	*rbno = fbno;
-	*rlen = flen;
-	return;
+	spin_unlock(&args->pag->pagb_lock);
+	return ret;
 fail:
 	/*
 	 * Return a zero extent length as failure indications.  All callers
 	 * re-check if the trimmed extent satisfies the minlen requirement.
 	 */
-	spin_unlock(&args->pag->pagb_lock);
-	trace_xfs_extent_busy_trim(args->mp, args->agno, bno, len, fbno, 0);
-	*rbno = fbno;
-	*rlen = 0;
+	flen = 0;
+	goto out;
 }
 
 STATIC void
@@ -540,6 +545,21 @@ xfs_extent_busy_clear_one(
 	kmem_free(busyp);
 }
 
+static void
+xfs_extent_busy_put_pag(
+	struct xfs_perag	*pag,
+	bool			wakeup)
+		__releases(pag->pagb_lock)
+{
+	if (wakeup) {
+		pag->pagb_gen++;
+		wake_up_all(&pag->pagb_wait);
+	}
+
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+}
+
 /*
  * Remove all extents on the passed in list from the busy extents tree.
  * If do_discard is set skip extents that need to be discarded, and mark
@@ -554,29 +574,56 @@ xfs_extent_busy_clear(
 	struct xfs_extent_busy	*busyp, *n;
 	struct xfs_perag	*pag = NULL;
 	xfs_agnumber_t		agno = NULLAGNUMBER;
+	bool			wakeup = false;
 
 	list_for_each_entry_safe(busyp, n, list, list) {
 		if (busyp->agno != agno) {
-			if (pag) {
-				spin_unlock(&pag->pagb_lock);
-				xfs_perag_put(pag);
-			}
-			pag = xfs_perag_get(mp, busyp->agno);
-			spin_lock(&pag->pagb_lock);
+			if (pag)
+				xfs_extent_busy_put_pag(pag, wakeup);
 			agno = busyp->agno;
+			pag = xfs_perag_get(mp, agno);
+			spin_lock(&pag->pagb_lock);
+			wakeup = false;
 		}
 
 		if (do_discard && busyp->length &&
-		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD))
+		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
 			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
-		else
+		} else {
 			xfs_extent_busy_clear_one(mp, pag, busyp);
+			wakeup = true;
+		}
 	}
 
-	if (pag) {
-		spin_unlock(&pag->pagb_lock);
-		xfs_perag_put(pag);
-	}
+	if (pag)
+		xfs_extent_busy_put_pag(pag, wakeup);
+}
+
+/*
+ * Flush out all busy extents for this AG.
+ */
+void
+xfs_extent_busy_flush(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
+	unsigned		busy_gen)
+{
+	DEFINE_WAIT		(wait);
+	int			log_flushed = 0, error;
+
+	trace_xfs_log_force(mp, 0, _THIS_IP_);
+	error = _xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);
+	if (error)
+		return;
+
+	do {
+		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
+		if  (busy_gen != READ_ONCE(pag->pagb_gen))
+			break;
+		schedule();
+	} while (1);
+
+	finish_wait(&pag->pagb_wait, &wait);
 }
 
 /*
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index bfff284d2dcc..bcb99463cfbb 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -58,9 +58,13 @@ void
 xfs_extent_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
 
+bool
+xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
+		xfs_extlen_t *len, unsigned *busy_gen);
+
 void
-xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t bno,
-	xfs_extlen_t len, xfs_agblock_t *rbno, xfs_extlen_t *rlen);
+xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
+	unsigned discards);
 
 int
 xfs_extent_busy_ag_cmp(void *priv, struct list_head *a, struct list_head *b);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9b9540db17a6..4e9feb1dc15d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -215,6 +215,7 @@ xfs_initialize_perag(
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		if (xfs_buf_hash_init(pag))
 			goto out_unwind;
+		init_waitqueue_head(&pag->pagb_wait);
 
 		if (radix_tree_preload(GFP_NOFS))
 			goto out_unwind;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7f351f706b7a..20e2981a4aec 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -384,6 +384,8 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagl_rightrec;
 	spinlock_t	pagb_lock;	/* lock for pagb_tree */
 	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
+	unsigned int	pagb_gen;	/* generation count for pagb_tree */
+	wait_queue_head_t pagb_wait;	/* woken when pagb_gen changes */
 
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
-- 
2.11.0

