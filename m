Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58246ECE58D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 282A3206BB
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PD7aWg1u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbfJIOc1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:32:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIOc1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:32:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DaSse2j8v1/z2dbX0dZuE+2DrivxUQK9biqdgLnu66c=; b=PD7aWg1uChcbXxUulX1LyJm9g
        V1bWbNIox2WWb/4PpcQKV7MkbBldpGg1m39dEP0cMcxAKedxCrMjLxM4UrQ4jLFSxFO0PzWjnPXqw
        YxtWqoOTRFf2KhFZKxCe6OyFVQR76FUpV20rsP/n7ERgxCz2cdfT7j09mOXTBrGzWoWaHjeN+FuwJ
        o6tt+jkRrlDyV4mHl5Oyu3GYqNHv+21NEs+FmgT3UqtftFcHyl0VAP8Ym81NkYOfSa2rXvhIA7L/l
        uU6Cl4y4HwCTgcisZB1qxDY3cijQ52pHuXtA5z+dwArhD2d5CLgkLqA4tANhn5og9pOHs8jrM9YvT
        r3XUo4auQ==;
Received: from [2001:4bb8:188:141c:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iID0s-0005d0-TL
        for linux-xfs@vger.kernel.org; Wed, 09 Oct 2019 14:32:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: call xlog_state_release_iclog with l_icloglock held
Date:   Wed,  9 Oct 2019 16:27:44 +0200
Message-Id: <20191009142748.18005-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009142748.18005-1-hch@lst.de>
References: <20191009142748.18005-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All but one caller of xlog_state_release_iclog hold l_icloglock and need
to drop and reacquire it to call xlog_state_release_iclog.  Switch the
xlog_state_release_iclog calling conventions to expect the lock to be
held, and open code the logic (using a shared helper) in the only
remaining caller that does not have the lock (and where not holding it
is a nice performance optimization).  Also move the refactored code to
require the least amount of forward declarations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 188 +++++++++++++++++++++++------------------------
 1 file changed, 90 insertions(+), 98 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 860a555772fe..67a767d90ebf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -57,10 +57,6 @@ xlog_state_get_iclog_space(
 	struct xlog_ticket	*ticket,
 	int			*continued_write,
 	int			*logoffsetp);
-STATIC int
-xlog_state_release_iclog(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog);
 STATIC void
 xlog_state_switch_iclogs(
 	struct xlog		*log,
@@ -83,7 +79,10 @@ STATIC void
 xlog_ungrant_log_space(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket);
-
+STATIC void
+xlog_sync(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog);
 #if defined(DEBUG)
 STATIC void
 xlog_verify_dest_ptr(
@@ -552,16 +551,71 @@ xfs_log_done(
 	return lsn;
 }
 
+static bool
+__xlog_state_release_iclog(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
+{
+	lockdep_assert_held(&log->l_icloglock);
+
+	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
+		/* update tail before writing to iclog */
+		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
+
+		iclog->ic_state = XLOG_STATE_SYNCING;
+		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+		xlog_verify_tail_lsn(log, iclog, tail_lsn);
+		/* cycle incremented when incrementing curr_block */
+		return true;
+	}
+
+	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
+	return false;
+}
+
+/*
+ * Flush iclog to disk if this is the last reference to the given iclog and the
+ * it is in the WANT_SYNC state.
+ */
+static int
+xlog_state_release_iclog(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
+{
+	lockdep_assert_held(&log->l_icloglock);
+
+	if (iclog->ic_state & XLOG_STATE_IOERROR)
+		return -EIO;
+
+	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
+	    __xlog_state_release_iclog(log, iclog)) {
+		spin_unlock(&log->l_icloglock);
+		xlog_sync(log, iclog);
+		spin_lock(&log->l_icloglock);
+	}
+
+	return 0;
+}
+
 int
 xfs_log_release_iclog(
-	struct xfs_mount	*mp,
+	struct xfs_mount        *mp,
 	struct xlog_in_core	*iclog)
 {
-	if (xlog_state_release_iclog(mp->m_log, iclog)) {
+	struct xlog		*log = mp->m_log;
+	bool			sync;
+
+	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 		return -EIO;
 	}
 
+	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
+		sync = __xlog_state_release_iclog(log, iclog);
+		spin_unlock(&log->l_icloglock);
+		if (sync)
+			xlog_sync(log, iclog);
+	}
 	return 0;
 }
 
@@ -866,10 +920,7 @@ xfs_log_write_unmount_record(
 	iclog = log->l_iclog;
 	atomic_inc(&iclog->ic_refcnt);
 	xlog_state_want_sync(log, iclog);
-	spin_unlock(&log->l_icloglock);
 	error = xlog_state_release_iclog(log, iclog);
-
-	spin_lock(&log->l_icloglock);
 	switch (iclog->ic_state) {
 	default:
 		if (!XLOG_FORCED_SHUTDOWN(log)) {
@@ -950,13 +1001,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		spin_lock(&log->l_icloglock);
 		iclog = log->l_iclog;
 		atomic_inc(&iclog->ic_refcnt);
-
 		xlog_state_want_sync(log, iclog);
-		spin_unlock(&log->l_icloglock);
 		error =  xlog_state_release_iclog(log, iclog);
 
-		spin_lock(&log->l_icloglock);
-
 		if ( ! (   iclog->ic_state == XLOG_STATE_ACTIVE
 			|| iclog->ic_state == XLOG_STATE_DIRTY
 			|| iclog->ic_state == XLOG_STATE_IOERROR) ) {
@@ -2255,6 +2302,8 @@ xlog_write_copy_finish(
 	int			log_offset,
 	struct xlog_in_core	**commit_iclog)
 {
+	int			error;
+
 	if (*partial_copy) {
 		/*
 		 * This iclog has already been marked WANT_SYNC by
@@ -2262,10 +2311,9 @@ xlog_write_copy_finish(
 		 */
 		spin_lock(&log->l_icloglock);
 		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
-		spin_unlock(&log->l_icloglock);
 		*record_cnt = 0;
 		*data_cnt = 0;
-		return xlog_state_release_iclog(log, iclog);
+		goto release_iclog;
 	}
 
 	*partial_copy = 0;
@@ -2279,15 +2327,19 @@ xlog_write_copy_finish(
 		*data_cnt = 0;
 
 		xlog_state_want_sync(log, iclog);
-		spin_unlock(&log->l_icloglock);
-
 		if (!commit_iclog)
-			return xlog_state_release_iclog(log, iclog);
+			goto release_iclog;
+		spin_unlock(&log->l_icloglock);
 		ASSERT(flags & XLOG_COMMIT_TRANS);
 		*commit_iclog = iclog;
 	}
 
 	return 0;
+
+release_iclog:
+	error = xlog_state_release_iclog(log, iclog);
+	spin_unlock(&log->l_icloglock);
+	return error;
 }
 
 /*
@@ -2349,7 +2401,7 @@ xlog_write(
 	int			contwr = 0;
 	int			record_cnt = 0;
 	int			data_cnt = 0;
-	int			error;
+	int			error = 0;
 
 	*start_lsn = 0;
 
@@ -2502,13 +2554,15 @@ xlog_write(
 
 	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
+	if (commit_iclog) {
+		ASSERT(flags & XLOG_COMMIT_TRANS);
+		*commit_iclog = iclog;
+	} else {
+		error = xlog_state_release_iclog(log, iclog);
+	}
 	spin_unlock(&log->l_icloglock);
-	if (!commit_iclog)
-		return xlog_state_release_iclog(log, iclog);
 
-	ASSERT(flags & XLOG_COMMIT_TRANS);
-	*commit_iclog = iclog;
-	return 0;
+	return error;
 }
 
 
@@ -2979,7 +3033,6 @@ xlog_state_get_iclog_space(
 	int		  log_offset;
 	xlog_rec_header_t *head;
 	xlog_in_core_t	  *iclog;
-	int		  error;
 
 restart:
 	spin_lock(&log->l_icloglock);
@@ -3028,24 +3081,22 @@ xlog_state_get_iclog_space(
 	 * can fit into remaining data section.
 	 */
 	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
+		int		error = 0;
+
 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
 
 		/*
-		 * If I'm the only one writing to this iclog, sync it to disk.
-		 * We need to do an atomic compare and decrement here to avoid
-		 * racing with concurrent atomic_dec_and_lock() calls in
+		 * If we are the only one writing to this iclog, sync it to
+		 * disk.  We need to do an atomic compare and decrement here to
+		 * avoid racing with concurrent atomic_dec_and_lock() calls in
 		 * xlog_state_release_iclog() when there is more than one
 		 * reference to the iclog.
 		 */
-		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
-			/* we are the only one */
-			spin_unlock(&log->l_icloglock);
+		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
 			error = xlog_state_release_iclog(log, iclog);
-			if (error)
-				return error;
-		} else {
-			spin_unlock(&log->l_icloglock);
-		}
+		spin_unlock(&log->l_icloglock);
+		if (error)
+			return error;
 		goto restart;
 	}
 
@@ -3156,60 +3207,6 @@ xlog_ungrant_log_space(
 	xfs_log_space_wake(log->l_mp);
 }
 
-/*
- * Flush iclog to disk if this is the last reference to the given iclog and
- * the WANT_SYNC bit is set.
- *
- * When this function is entered, the iclog is not necessarily in the
- * WANT_SYNC state.  It may be sitting around waiting to get filled.
- *
- *
- */
-STATIC int
-xlog_state_release_iclog(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog)
-{
-	int		sync = 0;	/* do we sync? */
-
-	if (iclog->ic_state & XLOG_STATE_IOERROR)
-		return -EIO;
-
-	ASSERT(atomic_read(&iclog->ic_refcnt) > 0);
-	if (!atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock))
-		return 0;
-
-	if (iclog->ic_state & XLOG_STATE_IOERROR) {
-		spin_unlock(&log->l_icloglock);
-		return -EIO;
-	}
-	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE ||
-	       iclog->ic_state == XLOG_STATE_WANT_SYNC);
-
-	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
-		/* update tail before writing to iclog */
-		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
-		sync++;
-		iclog->ic_state = XLOG_STATE_SYNCING;
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
-		xlog_verify_tail_lsn(log, iclog, tail_lsn);
-		/* cycle incremented when incrementing curr_block */
-	}
-	spin_unlock(&log->l_icloglock);
-
-	/*
-	 * We let the log lock go, so it's possible that we hit a log I/O
-	 * error or some other SHUTDOWN condition that marks the iclog
-	 * as XLOG_STATE_IOERROR before the bwrite. However, we know that
-	 * this iclog has consistent data, so we ignore IOERROR
-	 * flags after this point.
-	 */
-	if (sync)
-		xlog_sync(log, iclog);
-	return 0;
-}	/* xlog_state_release_iclog */
-
-
 /*
  * This routine will mark the current iclog in the ring as WANT_SYNC
  * and move the current iclog pointer to the next iclog in the ring.
@@ -3333,12 +3330,9 @@ xfs_log_force(
 			atomic_inc(&iclog->ic_refcnt);
 			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 			xlog_state_switch_iclogs(log, iclog, 0);
-			spin_unlock(&log->l_icloglock);
-
 			if (xlog_state_release_iclog(log, iclog))
-				return -EIO;
+				goto out_error;	
 
-			spin_lock(&log->l_icloglock);
 			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn ||
 			    iclog->ic_state == XLOG_STATE_DIRTY)
 				goto out_unlock;
@@ -3433,12 +3427,10 @@ __xfs_log_force_lsn(
 		}
 		atomic_inc(&iclog->ic_refcnt);
 		xlog_state_switch_iclogs(log, iclog, 0);
-		spin_unlock(&log->l_icloglock);
 		if (xlog_state_release_iclog(log, iclog))
-			return -EIO;
+			goto out_error;
 		if (log_flushed)
 			*log_flushed = 1;
-		spin_lock(&log->l_icloglock);
 	}
 
 	if (!(flags & XFS_LOG_SYNC) ||
-- 
2.20.1

