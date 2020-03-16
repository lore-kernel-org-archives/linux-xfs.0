Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4F3C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2602075E
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dTDvHGZk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731624AbgCPOvx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:51:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOvx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vDBgVknwEKzotQYQKtz2L5ZNTjb1b5BA3YCHlq6puwo=; b=dTDvHGZkHiDetkC5/7sp6lO1mr
        fUljLfQ0urIWxjy7UQUqOw6u/MbzO7v2+9gHILEmHxFNIASkpecJf3Lq1vFByc+tbzSsBgXlog15h
        q+mL4tzWAOXbpjHDgOaynOR3NEyHsIXz5Au6dxLM+ROkFT+6KddgB+xQ0eUgTjtbxRNSnpxkSmUPn
        stchXL1IhbAQEPSdafLj1246YkmHc22zZXXN85JF77iqe8FU2TSyp1N9Tkz8H+ubNgUNstEi8dqu9
        CyMNCTsqWGubo20A8bwrHvuSvldPis15841vEd74TVq0AIiwpXkCVF9UYMV1TvYOcbxTX3UHi/Xeg
        sJSGnjUg==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr5s-00009a-SI; Mon, 16 Mar 2020 14:51:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/14] xfs: remove XLOG_STATE_IOERROR
Date:   Mon, 16 Mar 2020 15:42:33 +0100
Message-Id: <20200316144233.900390-15-hch@lst.de>
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

Just check the shutdown flag in struct xlog, instead of replicating the
information into each iclog and checking it there.

As the iclog state is now not overload with the shut down information
various places that check for a specific state now don't need to account
for the fake IOERROR state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 68 +++++++++++--------------------------------
 fs/xfs/xfs_log_cil.c  |  2 +-
 fs/xfs/xfs_log_priv.h |  1 -
 3 files changed, 18 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 761b138d97ec..07023372ccbd 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -578,7 +578,7 @@ xlog_state_release_iclog(
 {
 	lockdep_assert_held(&log->l_icloglock);
 
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
 	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
@@ -599,7 +599,7 @@ xfs_log_release_iclog(
 	bool			sync = false;
 
 	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
-		if (iclog->ic_state != XLOG_STATE_IOERROR)
+		if (!XLOG_FORCED_SHUTDOWN(log))
 			sync = __xlog_state_release_iclog(log, iclog);
 		spin_unlock(&log->l_icloglock);
 	}
@@ -924,7 +924,7 @@ xfs_log_write_unmount_record(
 	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
-	 * transitioning log state to IOERROR. Just continue...
+	 * transitioning log state to IO_ERROR. Just continue...
 	 */
 out_err:
 	if (error)
@@ -936,8 +936,7 @@ xfs_log_write_unmount_record(
 	if (iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(log, iclog, 0);
 	else
-		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-		       iclog->ic_state == XLOG_STATE_IOERROR);
+		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
 	error = xlog_state_release_iclog(log, iclog);
 	xlog_wait_on_iclog(iclog);
 
@@ -1740,7 +1739,7 @@ xlog_write_iclog(
 	 * across the log IO to archieve that.
 	 */
 	down(&iclog->ic_sema);
-	if (unlikely(iclog->ic_state == XLOG_STATE_IOERROR)) {
+	if (XLOG_FORCED_SHUTDOWN(log)) {
 		/*
 		 * It would seem logical to return EIO here, but we rely on
 		 * the log state machine to propagate I/O errors instead of
@@ -2295,8 +2294,7 @@ xlog_write_copy_finish(
 		if (iclog->ic_state == XLOG_STATE_ACTIVE)
 			xlog_state_switch_iclogs(log, iclog, 0);
 		else
-			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-			       iclog->ic_state == XLOG_STATE_IOERROR);
+			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
 		if (!commit_iclog)
 			goto release_iclog;
 		spin_unlock(&log->l_icloglock);
@@ -2817,8 +2815,7 @@ xlog_state_do_callback(
 		}
 	} while (cycled_icloglock);
 
-	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
-	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
+	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE)
 		wake_up_all(&log->l_flush_wait);
 
 	spin_unlock(&log->l_icloglock);
@@ -3167,7 +3164,7 @@ xfs_log_force(
 
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		goto out_error;
 
 	if (iclog->ic_state == XLOG_STATE_DIRTY ||
@@ -3240,7 +3237,7 @@ __xfs_log_force_lsn(
 
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		goto out_error;
 
 	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
@@ -3691,34 +3688,6 @@ xlog_verify_iclog(
 }	/* xlog_verify_iclog */
 #endif
 
-/*
- * Mark all iclogs IOERROR. l_icloglock is held by the caller.
- */
-STATIC int
-xlog_state_ioerror(
-	struct xlog	*log)
-{
-	xlog_in_core_t	*iclog, *ic;
-
-	iclog = log->l_iclog;
-	if (iclog->ic_state != XLOG_STATE_IOERROR) {
-		/*
-		 * Mark all the incore logs IOERROR.
-		 * From now on, no log flushes will result.
-		 */
-		ic = iclog;
-		do {
-			ic->ic_state = XLOG_STATE_IOERROR;
-			ic = ic->ic_next;
-		} while (ic != iclog);
-		return 0;
-	}
-	/*
-	 * Return non-zero, if state transition has already happened.
-	 */
-	return 1;
-}
-
 /*
  * This is called from xfs_force_shutdown, when we're forcibly
  * shutting down the filesystem, typically because of an IO error.
@@ -3740,10 +3709,8 @@ xfs_log_force_umount(
 	struct xfs_mount	*mp,
 	int			logerror)
 {
-	struct xlog	*log;
-	int		retval;
-
-	log = mp->m_log;
+	struct xlog		*log = mp->m_log;
+	int			retval = 0;
 
 	/*
 	 * If this happens during log recovery, don't worry about
@@ -3761,10 +3728,8 @@ xfs_log_force_umount(
 	 * Somebody could've already done the hard work for us.
 	 * No need to get locks for this.
 	 */
-	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
-		ASSERT(XLOG_FORCED_SHUTDOWN(log));
+	if (logerror && XLOG_FORCED_SHUTDOWN(log))
 		return 1;
-	}
 
 	/*
 	 * Flush all the completed transactions to disk before marking the log
@@ -3786,11 +3751,13 @@ xfs_log_force_umount(
 		mp->m_sb_bp->b_flags |= XBF_DONE;
 
 	/*
-	 * Mark the log and the iclogs with IO error flags to prevent any
-	 * further log IO from being issued or completed.
+	 * Mark the log as shut down to prevent any further log IO from being
+	 * issued or completed.  Return non-zero if log IO_ERROR transition had
+	 * already happened so that the caller can skip further processing.
 	 */
+	if (XLOG_FORCED_SHUTDOWN(log))
+		retval = 1;
 	log->l_flags |= XLOG_IO_ERROR;
-	retval = xlog_state_ioerror(log);
 	spin_unlock(&log->l_icloglock);
 
 	/*
@@ -3814,7 +3781,6 @@ xfs_log_force_umount(
 	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_do_callback(log);
 
-	/* return non-zero if log IOERROR transition had already happened */
 	return retval;
 }
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index adc4af336c97..a93097cf0990 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -845,7 +845,7 @@ xlog_cil_push_work(
 		goto out_abort;
 
 	spin_lock(&commit_iclog->ic_callback_lock);
-	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
+	if (XLOG_FORCED_SHUTDOWN(log)) {
 		spin_unlock(&commit_iclog->ic_callback_lock);
 		goto out_abort;
 	}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 2b0aec37e73e..f3f4a35ce153 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -47,7 +47,6 @@ enum xlog_iclog_state {
 	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
 	XLOG_STATE_CALLBACK,	/* Callback functions now */
 	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
-	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
 };
 
 /*
-- 
2.24.1

