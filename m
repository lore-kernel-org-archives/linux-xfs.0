Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C3877F6B
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A18D7AC004
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	x3bAsX0YWtaEqr7N for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YR-Pf
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00064D-Iy
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 46/50] xfs: Combine CIL insert and
	prepare passes
Date: Mon, 12 Aug 2013 20:50:07 +1000
Message-Id: <1376304611-22994-47-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that all the log item preparation and formatting is done under
the CIL lock, we can get rid of the intermediate log vector chain
used to track items to be inserted into the CIL.

We can already find all the items to be committed from the
transaction handle, so as long as we attach the log vectors to the
item before we insert the items into the CIL, we don't need to
create a log vector chain to pass around.

This means we can move all the item insertion code into and optimise
it into a pair of simple passes across all the items in the
transaction. The first pass does the formatting and accounting, the
second inserts them all into the CIL.

We keep this two pass split so that we can separate the CIL
insertion - which must be done under the CIL spinlock - from the
formatting. We could insert each item into the CIL with a single
pass, but that massively increases the number of times we have to
grab the CIL spinlock. It is much more efficient (and hence
scalable) to do a batch operation and insert all objects in a single
lock grab.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 227 +++++++++++++++++++++++----------------------------
 1 file changed, 100 insertions(+), 127 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b20b157..c1a3384 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -111,6 +111,53 @@ xlog_cil_lv_item_format(
 }
 
 /*
+ * Prepare the log item for insertion into the CIL. Calculate the difference in
+ * log space and vectors it will consume, and if it is a new item pin it as
+ * well.
+ */
+STATIC void
+xfs_cil_prepare_item(
+	struct xlog		*log,
+	struct xfs_log_vec	*lv,
+	struct xfs_log_vec	*old_lv,
+	int			*diff_len,
+	int			*diff_iovecs)
+{
+	/* Account for the new LV being passed in */
+	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
+		*diff_len += lv->lv_buf_len;
+		*diff_iovecs += lv->lv_niovecs;
+	}
+
+	/*
+	 * If there is no old LV, this is the first time we've seen the item in
+	 * this CIL context and so we need to pin it. If we are replacing the
+	 * old_lv, then remove the space it accounts for and free it.
+	 */
+	if (!old_lv)
+		lv->lv_item->li_ops->iop_pin(lv->lv_item);
+	else if (old_lv != lv) {
+		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
+
+		*diff_len -= old_lv->lv_buf_len;
+		*diff_iovecs -= old_lv->lv_niovecs;
+		kmem_free(old_lv);
+	}
+
+	/* attach new log vector to log item */
+	lv->lv_item->li_lv = lv;
+
+	/*
+	 * If this is the first time the item is being committed to the
+	 * CIL, store the sequence number on the log item so we can
+	 * tell in future commits whether this is the first checkpoint
+	 * the item is being committed into.
+	 */
+	if (!lv->lv_item->li_seq)
+		lv->lv_item->li_seq = log->l_cilp->xc_ctx->sequence;
+}
+
+/*
  * Format log item into a flat buffers
  *
  * For delayed logging, we need to hold a formatted buffer containing all the
@@ -136,24 +183,26 @@ xlog_cil_lv_item_format(
  * format the regions into the iclog as though they are being formatted
  * directly out of the objects themselves.
  */
-static struct xfs_log_vec *
-xlog_cil_prepare_log_vecs(
-	struct xfs_trans	*tp)
+static void
+xlog_cil_insert_format_items(
+	struct xlog		*log,
+	struct xfs_trans	*tp,
+	int			*diff_len,
+	int			*diff_iovecs)
 {
 	struct xfs_log_item_desc *lidp;
-	struct xfs_log_vec	*prev_lv = NULL;
-	struct xfs_log_vec	*ret_lv = NULL;
 
 
 	/* Bail out if we didn't find a log item.  */
 	if (list_empty(&tp->t_items)) {
 		ASSERT(0);
-		return NULL;
+		return;
 	}
 
 	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
 		struct xfs_log_item *lip = lidp->lid_item;
 		struct xfs_log_vec *lv;
+		struct xfs_log_vec *old_lv;
 		int	niovecs = 0;
 		int	nbytes = 0;
 		int	buf_size;
@@ -181,6 +230,9 @@ xlog_cil_prepare_log_vecs(
 			nbytes = 0;
 		}
 
+		/* grab the old item if it exists for reservation accounting */
+		old_lv = lip->li_lv;
+
 		/* calc buffer size */
 		buf_size = sizeof(struct xfs_log_vec) + nbytes +
 				niovecs * sizeof(struct xfs_log_iovec);
@@ -194,9 +246,17 @@ xlog_cil_prepare_log_vecs(
 			if (ordered)
 				goto insert;
 
+			/*
+			 * set the item up as though it is a new insertion so
+			 * that the space reservation accounting is correct.
+			 */
+			*diff_iovecs -= lv->lv_niovecs;
+			*diff_len -= lv->lv_buf_len;
+
 			/* Ensure the lv is set up according to ->iop_size */
 			lv->lv_niovecs = niovecs;
 			lv->lv_buf = (char *)lv + buf_size - nbytes;
+
 			lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);
 			goto insert;
 		}
@@ -222,74 +282,8 @@ xlog_cil_prepare_log_vecs(
 		lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);
 insert:
 		ASSERT(lv->lv_buf_len <= nbytes);
-		if (!ret_lv)
-			ret_lv = lv;
-		else
-			prev_lv->lv_next = lv;
-		prev_lv = lv;
-	}
-
-	return ret_lv;
-}
-
-/*
- * Prepare the log item for insertion into the CIL. Calculate the difference in
- * log space and vectors it will consume, and if it is a new item pin it as
- * well.
- */
-STATIC void
-xfs_cil_prepare_item(
-	struct xlog		*log,
-	struct xfs_log_vec	*lv,
-	int			*len,
-	int			*diff_iovecs)
-{
-	struct xfs_log_vec	*old = lv->lv_item->li_lv;
-
-	if (!old) {
-		/* new lv, must pin the log item */
-		ASSERT(!lv->lv_item->li_lv);
-
-		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
-			*len += lv->lv_buf_len;
-			*diff_iovecs += lv->lv_niovecs;
-		}
-		lv->lv_item->li_ops->iop_pin(lv->lv_item);
-
-	} else if (old != lv) {
-		/* existing lv on log item, space used is a delta */
-		ASSERT((old->lv_buf && old->lv_buf_len && old->lv_niovecs) ||
-			old->lv_buf_len == XFS_LOG_VEC_ORDERED);
-
-		/*
-		 * If the new item is ordered, keep the old one that is already
-		 * tracking dirty or ordered regions
-		 */
-		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
-			ASSERT(!lv->lv_buf);
-			kmem_free(lv);
-			return;
-		}
-
-		*len += lv->lv_buf_len - old->lv_buf_len;
-		*diff_iovecs += lv->lv_niovecs - old->lv_niovecs;
-		kmem_free(old);
-	} else {
-		/* re-used lv */
-		/* XXX: can't account for len/diff_iovecs yet */
+		xfs_cil_prepare_item(log, lv, old_lv, diff_len, diff_iovecs);
 	}
-
-	/* attach new log vector to log item */
-	lv->lv_item->li_lv = lv;
-
-	/*
-	 * If this is the first time the item is being committed to the
-	 * CIL, store the sequence number on the log item so we can
-	 * tell in future commits whether this is the first checkpoint
-	 * the item is being committed into.
-	 */
-	if (!lv->lv_item->li_seq)
-		lv->lv_item->li_seq = log->l_cilp->xc_ctx->sequence;
 }
 
 /*
@@ -302,53 +296,47 @@ xfs_cil_prepare_item(
 static void
 xlog_cil_insert_items(
 	struct xlog		*log,
-	struct xfs_log_vec	*log_vector,
-	struct xlog_ticket	*ticket)
+	struct xfs_trans	*tp)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
-	struct xfs_log_vec	*lv;
+	struct xfs_log_item_desc *lidp;
 	int			len = 0;
 	int			diff_iovecs = 0;
 	int			iclog_space;
 
-	ASSERT(log_vector);
+	ASSERT(tp);
 
 	/*
-	 * Do all the accounting aggregation and switching of log vectors
-	 * around in a separate loop to the insertion of items into the CIL.
-	 * Then we can do a separate loop to update the CIL within a single
-	 * lock/unlock pair. This reduces the number of round trips on the CIL
-	 * lock from O(nr_logvectors) to O(1) and greatly reduces the overall
-	 * hold time for the transaction commit.
-	 *
-	 * If this is the first time the item is being placed into the CIL in
-	 * this context, pin it so it can't be written to disk until the CIL is
-	 * flushed to the iclog and the iclog written to disk.
-	 *
 	 * We can do this safely because the context can't checkpoint until we
 	 * are done so it doesn't matter exactly how we update the CIL.
 	 */
+	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
+
+	/*
+	 * Now (re-)position everything modified at the tail of the CIL.
+	 * We do this here so we only need to take the CIL lock once during
+	 * the transaction commit.
+	 */
 	spin_lock(&cil->xc_cil_lock);
-	for (lv = log_vector; lv; ) {
-		struct xfs_log_vec *next = lv->lv_next;
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+		struct xfs_log_item	*lip = lidp->lid_item;
 
-		ASSERT(lv->lv_item->li_lv || list_empty(&lv->lv_item->li_cil));
-		lv->lv_next = NULL;
+		/* Skip items which aren't dirty in this transaction. */
+		if (!(lidp->lid_flags & XFS_LID_DIRTY))
+			continue;
 
-		/*
-		 * xfs_cil_prepare_item() may free the lv, so move the item on
-		 * the CIL first.
-		 */
-		list_move_tail(&lv->lv_item->li_cil, &cil->xc_cil);
-		xfs_cil_prepare_item(log, lv, &len, &diff_iovecs);
-		lv = next;
+		list_move_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
 	/* account for space used by new iovec headers  */
 	len += diff_iovecs * sizeof(xlog_op_header_t);
 	ctx->nvecs += diff_iovecs;
 
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy))
+		list_splice_init(&tp->t_busy, &ctx->busy_extents);
+
 	/*
 	 * Now transfer enough transaction reservation to the context ticket
 	 * for the checkpoint. The context ticket is special - the unit
@@ -357,10 +345,8 @@ xlog_cil_insert_items(
 	 * during the transaction commit.
 	 */
 	if (ctx->ticket->t_curr_res == 0) {
-		/* first commit in checkpoint, steal the header reservation */
-		ASSERT(ticket->t_curr_res >= ctx->ticket->t_unit_res + len);
 		ctx->ticket->t_curr_res = ctx->ticket->t_unit_res;
-		ticket->t_curr_res -= ctx->ticket->t_unit_res;
+		tp->t_ticket->t_curr_res -= ctx->ticket->t_unit_res;
 	}
 
 	/* do we need space for more log record headers? */
@@ -374,10 +360,10 @@ xlog_cil_insert_items(
 		hdrs *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
 		ctx->ticket->t_unit_res += hdrs;
 		ctx->ticket->t_curr_res += hdrs;
-		ticket->t_curr_res -= hdrs;
-		ASSERT(ticket->t_curr_res >= len);
+		tp->t_ticket->t_curr_res -= hdrs;
+		ASSERT(tp->t_ticket->t_curr_res >= len);
 	}
-	ticket->t_curr_res -= len;
+	tp->t_ticket->t_curr_res -= len;
 	ctx->space_used += len;
 
 	spin_unlock(&cil->xc_cil_lock);
@@ -746,38 +732,25 @@ xfs_log_commit_cil(
 	int			flags)
 {
 	struct xlog		*log = mp->m_log;
+	struct xfs_cil		*cil = log->l_cilp;
 	int			log_flags = 0;
-	struct xfs_log_vec	*log_vector;
 
 	if (flags & XFS_TRANS_RELEASE_LOG_RES)
 		log_flags = XFS_LOG_REL_PERM_RESERV;
 
 	/* lock out background commit */
-	down_read(&log->l_cilp->xc_ctx_lock);
+	down_read(&cil->xc_ctx_lock);
 
-	log_vector = xlog_cil_prepare_log_vecs(tp);
-	if (!log_vector)
-		return ENOMEM;
-
-	if (commit_lsn)
-		*commit_lsn = log->l_cilp->xc_ctx->sequence;
-
-	/* xlog_cil_insert_items() destroys log_vector list */
-	xlog_cil_insert_items(log, log_vector, tp->t_ticket);
+	xlog_cil_insert_items(log, tp);
 
 	/* check we didn't blow the reservation */
 	if (tp->t_ticket->t_curr_res < 0)
-		xlog_print_tic_res(log->l_mp, tp->t_ticket);
+		xlog_print_tic_res(mp, tp->t_ticket);
 
-	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy)) {
-		spin_lock(&log->l_cilp->xc_cil_lock);
-		list_splice_init(&tp->t_busy,
-					&log->l_cilp->xc_ctx->busy_extents);
-		spin_unlock(&log->l_cilp->xc_cil_lock);
-	}
+	tp->t_commit_lsn = cil->xc_ctx->sequence;
+	if (commit_lsn)
+		*commit_lsn = tp->t_commit_lsn;
 
-	tp->t_commit_lsn = *commit_lsn;
 	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
 	xfs_trans_unreserve_and_mod_sb(tp);
 
@@ -792,11 +765,11 @@ xfs_log_commit_cil(
 	 * the log items. This affects (at least) processing of stale buffers,
 	 * inodes and EFIs.
 	 */
-	xfs_trans_free_items(tp, *commit_lsn, 0);
+	xfs_trans_free_items(tp, tp->t_commit_lsn, 0);
 
 	xlog_cil_push_background(log);
 
-	up_read(&log->l_cilp->xc_ctx_lock);
+	up_read(&cil->xc_ctx_lock);
 	return 0;
 }
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
