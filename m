Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA2CC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B99420752
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T8J5RFi5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731560AbgCPOvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:51:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57638 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=stgC4n6JF2yWEvggUewpLyCk+AREcfhOemi5clJSTLA=; b=T8J5RFi5CGn42xuIgZriEbNgrn
        uG/TD44UR7G8c8DieVFLAsdWDR9BbwhVXKc63vrRW7GpFP+aBR7dv0l9wc6BTr2mcZU48J3qG9qV0
        dNGyFLrBegtQKozkeSZi9CgZ2f73Xnz6QIagaoq09Htb+m7P8S5d8TY1/S+t6f4c8F5b1POB44HrA
        yCPOhE1ex2zigdaISpAyUqd8UqrjwMcZU+MX0hqP561bGUapAfZXGI3hRvRRYh9zVEcUrIZlFBh2U
        rlXs+F3A0gVqOq2GTAdo21sbeVNWYw1UcJ71/MO83lx8MTB7U0M5plC0/c9uKL/YYXFVb9IcbDYRh
        kVTvORrw==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr5X-00006C-6i; Mon, 16 Mar 2020 14:51:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/14] xfs: remove the aborted parameter to xlog_state_done_syncing
Date:   Mon, 16 Mar 2020 15:42:24 +0100
Message-Id: <20200316144233.900390-6-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316144233.900390-1-hch@lst.de>
References: <20200316144233.900390-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We can just check for a shut down log all the way down in
xlog_cil_committed instead of passing the parameter.  This means a
slight behavior change in that we now also abort log items if the
shutdown came in halfway into the I/O completion processing, which
actually is the right thing to do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c     | 48 +++++++++++++++-----------------------------
 fs/xfs/xfs_log.h     |  2 +-
 fs/xfs/xfs_log_cil.c | 12 +++++------
 3 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7af9c292540b..8ede2852f104 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -47,8 +47,7 @@ xlog_dealloc_log(
 
 /* local state machine functions */
 STATIC void xlog_state_done_syncing(
-	struct xlog_in_core	*iclog,
-	bool			aborted);
+	struct xlog_in_core	*iclog);
 STATIC int
 xlog_state_get_iclog_space(
 	struct xlog		*log,
@@ -1254,7 +1253,6 @@ xlog_ioend_work(
 	struct xlog_in_core     *iclog =
 		container_of(work, struct xlog_in_core, ic_end_io_work);
 	struct xlog		*log = iclog->ic_log;
-	bool			aborted = false;
 	int			error;
 
 	error = blk_status_to_errno(iclog->ic_bio.bi_status);
@@ -1270,17 +1268,9 @@ xlog_ioend_work(
 	if (XFS_TEST_ERROR(error, log->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
 		xfs_alert(log->l_mp, "log I/O error %d", error);
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
-		/*
-		 * This flag will be propagated to the trans-committed
-		 * callback routines to let them know that the log-commit
-		 * didn't succeed.
-		 */
-		aborted = true;
-	} else if (iclog->ic_state == XLOG_STATE_IOERROR) {
-		aborted = true;
 	}
 
-	xlog_state_done_syncing(iclog, aborted);
+	xlog_state_done_syncing(iclog);
 	bio_uninit(&iclog->ic_bio);
 
 	/*
@@ -1759,7 +1749,7 @@ xlog_write_iclog(
 		 * the buffer manually, the code needs to be kept in sync
 		 * with the I/O completion path.
 		 */
-		xlog_state_done_syncing(iclog, true);
+		xlog_state_done_syncing(iclog);
 		up(&iclog->ic_sema);
 		return;
 	}
@@ -2783,8 +2773,7 @@ xlog_state_iodone_process_iclog(
 static void
 xlog_state_do_iclog_callbacks(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	bool			aborted)
+	struct xlog_in_core	*iclog)
 		__releases(&log->l_icloglock)
 		__acquires(&log->l_icloglock)
 {
@@ -2796,7 +2785,7 @@ xlog_state_do_iclog_callbacks(
 		list_splice_init(&iclog->ic_callbacks, &tmp);
 
 		spin_unlock(&iclog->ic_callback_lock);
-		xlog_cil_process_committed(&tmp, aborted);
+		xlog_cil_process_committed(&tmp);
 		spin_lock(&iclog->ic_callback_lock);
 	}
 
@@ -2811,8 +2800,7 @@ xlog_state_do_iclog_callbacks(
 
 STATIC void
 xlog_state_do_callback(
-	struct xlog		*log,
-	bool			aborted)
+	struct xlog		*log)
 {
 	struct xlog_in_core	*iclog;
 	struct xlog_in_core	*first_iclog;
@@ -2853,7 +2841,7 @@ xlog_state_do_callback(
 			 * we'll have to run at least one more complete loop.
 			 */
 			cycled_icloglock = true;
-			xlog_state_do_iclog_callbacks(log, iclog, aborted);
+			xlog_state_do_iclog_callbacks(log, iclog);
 
 			xlog_state_clean_iclog(log, iclog);
 			iclog = iclog->ic_next;
@@ -2891,25 +2879,22 @@ xlog_state_do_callback(
  */
 STATIC void
 xlog_state_done_syncing(
-	struct xlog_in_core	*iclog,
-	bool			aborted)
+	struct xlog_in_core	*iclog)
 {
 	struct xlog		*log = iclog->ic_log;
 
 	spin_lock(&log->l_icloglock);
-
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
 	/*
 	 * If we got an error, either on the first buffer, or in the case of
-	 * split log writes, on the second, we mark ALL iclogs STATE_IOERROR,
-	 * and none should ever be attempted to be written to disk
-	 * again.
+	 * split log writes, on the second, we shut down the file system and
+	 * none should ever be attempted to be written to disk again.
 	 */
-	if (iclog->ic_state == XLOG_STATE_SYNCING)
+	if (!XLOG_FORCED_SHUTDOWN(log)) {
+		ASSERT(iclog->ic_state == XLOG_STATE_SYNCING);
 		iclog->ic_state = XLOG_STATE_DONE_SYNC;
-	else
-		ASSERT(iclog->ic_state == XLOG_STATE_IOERROR);
+	}
 
 	/*
 	 * Someone could be sleeping prior to writing out the next
@@ -2918,9 +2903,8 @@ xlog_state_done_syncing(
 	 */
 	wake_up_all(&iclog->ic_write_wait);
 	spin_unlock(&log->l_icloglock);
-	xlog_state_do_callback(log, aborted);	/* also cleans log */
-}	/* xlog_state_done_syncing */
-
+	xlog_state_do_callback(log);	/* also cleans log */
+}
 
 /*
  * If the head of the in-core log ring is not (ACTIVE or DIRTY), then we must
@@ -3884,7 +3868,7 @@ xfs_log_force_umount(
 	spin_lock(&log->l_cilp->xc_push_lock);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
 	spin_unlock(&log->l_cilp->xc_push_lock);
-	xlog_state_do_callback(log, true);
+	xlog_state_do_callback(log);
 
 	/* return non-zero if log IOERROR transition had already happened */
 	return retval;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index b38602216c5a..cc77cc36560a 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -137,7 +137,7 @@ void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
 void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_lsn_t *commit_lsn, bool regrant);
-void	xlog_cil_process_committed(struct list_head *list, bool aborted);
+void	xlog_cil_process_committed(struct list_head *list);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
 void	xfs_log_work_queue(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 047ac253edfe..adc4af336c97 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -574,10 +574,10 @@ xlog_discard_busy_extents(
  */
 static void
 xlog_cil_committed(
-	struct xfs_cil_ctx	*ctx,
-	bool			abort)
+	struct xfs_cil_ctx	*ctx)
 {
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
+	bool			abort = XLOG_FORCED_SHUTDOWN(ctx->cil->xc_log);
 
 	/*
 	 * If the I/O failed, we're aborting the commit and already shutdown.
@@ -613,15 +613,14 @@ xlog_cil_committed(
 
 void
 xlog_cil_process_committed(
-	struct list_head	*list,
-	bool			aborted)
+	struct list_head	*list)
 {
 	struct xfs_cil_ctx	*ctx;
 
 	while ((ctx = list_first_entry_or_null(list,
 			struct xfs_cil_ctx, iclog_entry))) {
 		list_del(&ctx->iclog_entry);
-		xlog_cil_committed(ctx, aborted);
+		xlog_cil_committed(ctx);
 	}
 }
 
@@ -878,7 +877,8 @@ xlog_cil_push_work(
 out_abort_free_ticket:
 	xfs_log_ticket_put(tic);
 out_abort:
-	xlog_cil_committed(ctx, true);
+	ASSERT(XLOG_FORCED_SHUTDOWN(log));
+	xlog_cil_committed(ctx);
 }
 
 /*
-- 
2.24.1

