Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EElMIA130888 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:47:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFF1B107D6EF
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 07:59:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vTwNOsATo8fSFxOJ for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 07:59:56 -0700 (PDT)
Date: Tue, 14 Sep 2010 10:48:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/18] xfs: reduce the number of CIL lock round trips
	during commit
Message-ID: <20100914144810.GB3400@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284461777-1496-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 14, 2010 at 08:56:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When commiting a transaction, we do a lock CIL state lock round trip
> on every single log vector we insert into the CIL. This is resulting
> in the lock being as hot as the inode and dcache locks on 8-way
> create workloads. Rework the insertion loops to bring the number
> of lock round trips to one per transaction for log vectors, and one
> more do the busy extents.
> 
> Also change the allocation of the log vector buffer not to zero it
> as we copy over the entire allocated buffer anyway.

The change looks good, but I think the functions names and splits in
the CIL insert code are now a bit confusing.  What about mergeing
something like the patch below into yours?


Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2010-09-14 11:32:36.365935029 -0300
+++ xfs/fs/xfs/xfs_log_cil.c	2010-09-14 11:43:58.046935056 -0300
@@ -145,6 +145,47 @@ xlog_cil_init_post_recovery(
 								log->l_curr_block);
 }
 
+static void
+xlog_cil_prepare_item(
+	struct log		*log,
+	struct xfs_log_vec	*lv,
+	int			*len,
+	int			*diff_iovecs)
+{
+	struct xfs_log_vec	*old = lv->lv_item->li_lv;
+
+	if (old) {
+		/* existing lv on log item, space used is a delta */
+		ASSERT(!list_empty(&lv->lv_item->li_cil));
+		ASSERT(old->lv_buf && old->lv_buf_len && old->lv_niovecs);
+
+		*len += lv->lv_buf_len - old->lv_buf_len;
+		*diff_iovecs += lv->lv_niovecs - old->lv_niovecs;
+		kmem_free(old->lv_buf);
+		kmem_free(old);
+	} else {
+		/* new lv, must pin the log item */
+		ASSERT(!lv->lv_item->li_lv);
+		ASSERT(list_empty(&lv->lv_item->li_cil));
+
+		*len += lv->lv_buf_len;
+		*diff_iovecs += lv->lv_niovecs;
+		IOP_PIN(lv->lv_item);
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
 /*
  * Insert the log items into the CIL and calculate the difference in space
  * consumed by the item. Add the space to the checkpoint ticket and calculate
@@ -153,27 +194,46 @@ xlog_cil_init_post_recovery(
  * the current transaction ticket so that the accounting works out correctly.
  */
 static void
-xlog_cil_insert(
+xlog_cil_insert_items(
 	struct log		*log,
-	struct xlog_ticket	*ticket,
 	struct xfs_log_vec	*log_vector,
-	int			diff_length,
-	int			diff_iovecs)
+	struct xlog_ticket	*ticket)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
-	int			iclog_space;
-	int			len = diff_length;
 	struct xfs_log_vec	*lv;
+	int			len = 0;
+	int			diff_iovecs = 0;
+	int			iclog_space;
 
-	spin_lock(&cil->xc_cil_lock);
+	ASSERT(log_vector);
 
-	/* move the items to the tail of the CIL */
+	/*
+	 * Do all the accounting aggregation and switching of log vectors
+	 * around in a separate loop to the insertion of items into the CIL.
+	 * Then we can do a separate loop to update the CIL within a single
+	 * lock/unlock pair. This reduces the number of round trips on the CIL
+	 * lock from O(nr_logvectors) to O(1) and greatly reduces the overall
+	 * hold time for the transaction commit.
+	 *
+	 * If this is the first time the item is being placed into the CIL in
+	 * this context, pin it so it can't be written to disk until the CIL is
+	 * flushed to the iclog and the iclog written to disk.
+	 *
+	 * We can do this safely because the context can't checkpoint until we
+	 * are done so it doesn't matter exactly how we update the CIL.
+	 */
 	for (lv = log_vector; lv; lv = lv->lv_next)
-		list_move_tail(&lv->lv_item->li_cil, &cil->xc_cil);
+		xlog_cil_prepare_item(log, lv, &len, &diff_iovecs);
 
 	/* account for space used by new iovec headers  */
 	len += diff_iovecs * sizeof(xlog_op_header_t);
+
+	spin_lock(&cil->xc_cil_lock);
+	/* move the items to the tail of the CIL */
+	for (lv = log_vector; lv; lv = lv->lv_next)
+		list_move_tail(&lv->lv_item->li_cil, &cil->xc_cil);
+
 	ctx->nvecs += diff_iovecs;
 
 	/*
@@ -270,76 +330,6 @@ xlog_cil_format_items(
 }
 
 static void
-xlog_cil_insert_items(
-	struct log		*log,
-	struct xfs_log_vec	*log_vector,
-	struct xlog_ticket	*ticket,
-	xfs_lsn_t		*start_lsn)
-{
-	struct xfs_log_vec	*lv;
-	int			len = 0;
-	int			diff_iovecs = 0;
-
-	ASSERT(log_vector);
-
-	if (start_lsn)
-		*start_lsn = log->l_cilp->xc_ctx->sequence;
-
-	/*
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
-	 * We can do this safely because the context can't checkpoint until we
-	 * are done so it doesn't matter exactly how we update the CIL.
-	 */
-	for (lv = log_vector; lv; lv = lv->lv_next) {
-		struct xfs_log_vec	*old = lv->lv_item->li_lv;
-
-		if (old) {
-			/* existing lv on log item, space used is a delta */
-			ASSERT(!list_empty(&lv->lv_item->li_cil));
-			ASSERT(old->lv_buf && old->lv_buf_len && old->lv_niovecs);
-
-			len += lv->lv_buf_len - old->lv_buf_len;
-			diff_iovecs += lv->lv_niovecs - old->lv_niovecs;
-			kmem_free(old->lv_buf);
-			kmem_free(old);
-		} else {
-			/* new lv, must pin the log item */
-			ASSERT(!lv->lv_item->li_lv);
-			ASSERT(list_empty(&lv->lv_item->li_cil));
-
-			len += lv->lv_buf_len;
-			diff_iovecs += lv->lv_niovecs;
-			IOP_PIN(lv->lv_item);
-
-		}
-
-		/* attach new log vector to log item */
-		lv->lv_item->li_lv = lv;
-
-		/*
-		 * If this is the first time the item is being committed to the
-		 * CIL, store the sequence number on the log item so we can
-		 * tell in future commits whether this is the first checkpoint
-		 * the item is being committed into.
-		 */
-		if (!lv->lv_item->li_seq)
-			lv->lv_item->li_seq = log->l_cilp->xc_ctx->sequence;
-	}
-
-	xlog_cil_insert(log, ticket, log_vector, len, diff_iovecs);
-}
-
-static void
 xlog_cil_free_logvec(
 	struct xfs_log_vec	*log_vector)
 {
@@ -654,7 +644,11 @@ xfs_log_commit_cil(
 
 	/* lock out background commit */
 	down_read(&log->l_cilp->xc_ctx_lock);
-	xlog_cil_insert_items(log, log_vector, tp->t_ticket, commit_lsn);
+
+	if (commit_lsn)
+		*commit_lsn = log->l_cilp->xc_ctx->sequence;
+
+	xlog_cil_insert_items(log, log_vector, tp->t_ticket);
 
 	/* check we didn't blow the reservation */
 	if (tp->t_ticket->t_curr_res < 0)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
