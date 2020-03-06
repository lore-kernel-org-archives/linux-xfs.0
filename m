Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B57CC10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07FCA20717
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K+lgLzJ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgCFObo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:31:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39450 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgCFObo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:31:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6CSzyDMBsQeIwaawouhlHDnVyEJcEWAaqhajdOnU31w=; b=K+lgLzJ0L13U2/O9sz6wZnRF1G
        Ps2Wl7LHvOWGFr/oBTjHWfgYCM2t56Sz7mNllOJebzc5sMtHMrl0FFi0PhgMD4r2piJlBfgpNuaRi
        mD8mmJyuWaymxd9UBwyuNnYW8n0/o/fTtc39jxT2ZTiCfq8WWAVGOBVXZwSTc8w3IgVx9OT7inZiu
        y8oukGKR+SZwoEWRzG+KFBpMBm86vv41Nvtj8enqIs+hcnv6PPAebBgIVYLLRLmcHUeU0CQmzcU0x
        0eXRlkn2dyf8ZBsh7UHebD25iUKNXP5FIzdkYF6S3IDDM7wtpIwm2D+yHVKFdJvEyeuUUICw6sYVS
        slGgLqbQ==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAE0t-0008IY-SG; Fri, 06 Mar 2020 14:31:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] xfs: kill XLOG_STATE_IOERROR
Date:   Fri,  6 Mar 2020 07:31:37 -0700
Message-Id: <20200306143137.236478-8-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306143137.236478-1-hch@lst.de>
References: <20200306143137.236478-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just check the shutdown flag in struct xlog, instead of replicating the
information into each iclog and checking it there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 95 +++++++++++++++----------------------------
 fs/xfs/xfs_log_cil.c  |  2 +-
 fs/xfs/xfs_log_priv.h |  1 -
 3 files changed, 34 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fae5107099b1..1bcd5c735d6b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -583,7 +583,7 @@ xlog_state_release_iclog(
 {
 	lockdep_assert_held(&log->l_icloglock);
 
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
 	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
@@ -604,11 +604,11 @@ xfs_log_release_iclog(
 	struct xlog		*log = mp->m_log;
 	bool			sync;
 
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error;
 
 	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
-		if (iclog->ic_state == XLOG_STATE_IOERROR) {
+		if (XLOG_FORCED_SHUTDOWN(log)) {
 			spin_unlock(&log->l_icloglock);
 			goto error;
 		}
@@ -914,7 +914,7 @@ xfs_log_write_unmount_record(
 	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
-	 * transitioning log state to IOERROR. Just continue...
+	 * transitioning log state to IO_ERROR. Just continue...
 	 */
 out_err:
 	if (error)
@@ -1737,7 +1737,7 @@ xlog_write_iclog(
 	 * across the log IO to archieve that.
 	 */
 	down(&iclog->ic_sema);
-	if (unlikely(iclog->ic_state == XLOG_STATE_IOERROR)) {
+	if (unlikely(XLOG_FORCED_SHUTDOWN(log))) {
 		/*
 		 * It would seem logical to return EIO here, but we rely on
 		 * the log state machine to propagate I/O errors instead of
@@ -2721,6 +2721,17 @@ xlog_state_iodone_process_iclog(
 	xfs_lsn_t		lowest_lsn;
 	xfs_lsn_t		header_lsn;
 
+	/*
+	 * Between marking a filesystem SHUTDOWN and stopping the log, we do
+	 * flush all iclogs to disk (if there wasn't a log I/O error).  So, we
+	 * do want things to go smoothly in case of just a SHUTDOWN w/o a
+	 * LOG_IO_ERROR.
+	 */
+	if (XLOG_FORCED_SHUTDOWN(log)) {
+		*ioerror = true;
+		return false;
+	}
+
 	switch (iclog->ic_state) {
 	case XLOG_STATE_ACTIVE:
 	case XLOG_STATE_DIRTY:
@@ -2728,15 +2739,6 @@ xlog_state_iodone_process_iclog(
 		 * Skip all iclogs in the ACTIVE & DIRTY states:
 		 */
 		return false;
-	case XLOG_STATE_IOERROR:
-		/*
-		 * Between marking a filesystem SHUTDOWN and stopping the log,
-		 * we do flush all iclogs to disk (if there wasn't a log I/O
-		 * error). So, we do want things to go smoothly in case of just
-		 * a SHUTDOWN w/o a LOG_IO_ERROR.
-		 */
-		*ioerror = true;
-		return false;
 	case XLOG_STATE_DONE_SYNC:
 		/*
 		 * Now that we have an iclog that is in the DONE_SYNC state, do
@@ -2830,7 +2832,7 @@ xlog_state_do_callback(
 				break;
 
 			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
-			    iclog->ic_state != XLOG_STATE_IOERROR) {
+			    !XLOG_FORCED_SHUTDOWN(log)) {
 				iclog = iclog->ic_next;
 				continue;
 			}
@@ -2856,7 +2858,7 @@ xlog_state_do_callback(
 	} while (!ioerror && cycled_icloglock);
 
 	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
-	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
+	    XLOG_FORCED_SHUTDOWN(log))
 		wake_up_all(&log->l_flush_wait);
 
 	spin_unlock(&log->l_icloglock);
@@ -3202,7 +3204,7 @@ xfs_log_force(
 
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		goto out_error;
 
 	if (iclog->ic_state == XLOG_STATE_DIRTY ||
@@ -3259,11 +3261,11 @@ xfs_log_force(
 	if (!(flags & XFS_LOG_SYNC))
 		goto out_unlock;
 
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		goto out_error;
 	XFS_STATS_INC(mp, xs_log_force_sleep);
 	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 	return 0;
 
@@ -3288,7 +3290,7 @@ __xfs_log_force_lsn(
 
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		goto out_error;
 
 	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
@@ -3338,12 +3340,12 @@ __xfs_log_force_lsn(
 	     iclog->ic_state == XLOG_STATE_DIRTY))
 		goto out_unlock;
 
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		goto out_error;
 
 	XFS_STATS_INC(mp, xs_log_force_sleep);
 	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 	return 0;
 
@@ -3407,7 +3409,7 @@ xlog_state_want_sync(
 		xlog_state_switch_iclogs(log, iclog, 0);
 	} else {
 		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-		       iclog->ic_state == XLOG_STATE_IOERROR);
+		       XLOG_FORCED_SHUTDOWN(log));
 	}
 }
 
@@ -3774,34 +3776,6 @@ xlog_verify_iclog(
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
@@ -3823,10 +3797,8 @@ xfs_log_force_umount(
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
@@ -3844,10 +3816,8 @@ xfs_log_force_umount(
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
@@ -3869,11 +3839,13 @@ xfs_log_force_umount(
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
@@ -3897,7 +3869,6 @@ xfs_log_force_umount(
 	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_do_callback(log);
 
-	/* return non-zero if log IOERROR transition had already happened */
 	return retval;
 }
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b5c4a45c208c..41a45d75a2d0 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -846,7 +846,7 @@ xlog_cil_push(
 		goto out_abort;
 
 	spin_lock(&commit_iclog->ic_callback_lock);
-	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
+	if (XLOG_FORCED_SHUTDOWN(log)) {
 		spin_unlock(&commit_iclog->ic_callback_lock);
 		goto out_abort;
 	}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b192c5a9f9fd..fd4c913ee7e6 100644
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

