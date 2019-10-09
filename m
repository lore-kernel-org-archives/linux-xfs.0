Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0638FC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6354206BB
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bzJwvBXz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731378AbfJIOcj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:32:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44034 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIOcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5U08Qfv2Z5C6JKuDAuk31Z54sFJA3yeu3zcQj0Dopt0=; b=bzJwvBXzyV/UHqiZzdj5hkKOk
        AXomLq+oVVZPDSnuxkRdmCSKI7khL3T7kktG2Y6j9b7F/8tB84BXwf+kXGoY2ZTAnDcStpxfZl667
        c4fkWIxzlj2QXbaPEyypGEqKzD1iP1d98Cq/Jw1iE/zc2PePeqPvsXrlvi3YedejtW/eGIPdVJ26a
        kbQ/vk3zOQSgT8QPAfTYTMU1y+aH5MhZMQQmEoKjYryPpa/w42/mdKyi8oZZxLx1A4+K0g4RyY4ek
        Lj28qILpG3sDsx2+JHyUDhkwaOw+F1App/57b/NJd6sW8j08qkZHoLy3MO83KdNPjmUHtdmh1JHx0
        /QZWxmTVg==;
Received: from [2001:4bb8:188:141c:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iID14-0005ef-MG
        for linux-xfs@vger.kernel.org; Wed, 09 Oct 2019 14:32:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: remove the XLOG_STATE_DO_CALLBACK state
Date:   Wed,  9 Oct 2019 16:27:48 +0200
Message-Id: <20191009142748.18005-9-hch@lst.de>
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

XLOG_STATE_DO_CALLBACK is only entered through XLOG_STATE_DONE_SYNC
and just used in a single debug check.  Remove the flag and thus
simplify the calling conventions for xlog_state_do_callback and
xlog_state_iodone_process_iclog.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 76 +++++++------------------------------------
 fs/xfs/xfs_log_priv.h |  1 -
 2 files changed, 11 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 001a9586cb56..d158b6d56a26 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2750,7 +2750,6 @@ static bool
 xlog_state_iodone_process_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	struct xlog_in_core	*completed_iclog,
 	bool			*ioerror)
 {
 	xfs_lsn_t		lowest_lsn;
@@ -2768,17 +2767,16 @@ xlog_state_iodone_process_iclog(
 		 * Between marking a filesystem SHUTDOWN and stopping the log,
 		 * we do flush all iclogs to disk (if there wasn't a log I/O
 		 * error). So, we do want things to go smoothly in case of just
-		 * a SHUTDOWN  w/o a LOG_IO_ERROR.
+		 * a SHUTDOWN w/o a LOG_IO_ERROR.
 		 */
 		*ioerror = true;
 		return false;
 	case XLOG_STATE_DONE_SYNC:
-	case XLOG_STATE_DO_CALLBACK:
 		/*
-		 * Now that we have an iclog that is in either the DO_CALLBACK
-		 * or DONE_SYNC states, do one more check here to see if we have
-		 * chased our tail around.  If this is not the lowest lsn iclog,
-		 * then we will leave it for another completion to process.
+		 * Now that we have an iclog that is in the DONE_SYNC state, do
+		 * one more check here to see if we have chased our tail around.
+		 * If this is not the lowest lsn iclog, then we will leave it
+		 * for another completion to process.
 		 */
 		header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 		lowest_lsn = xlog_get_lowest_lsn(log);
@@ -2789,15 +2787,9 @@ xlog_state_iodone_process_iclog(
 	default:
 		/*
 		 * Can only perform callbacks in order.  Since this iclog is not
-		 * in the DONE_SYNC or DO_CALLBACK states, we skip the rest and
-		 * just try to clean up.  If we set our iclog to DO_CALLBACK, we
-		 * will not process it when we retry since a previous iclog is
-		 * in the CALLBACK and the state cannot change since we are
-		 * holding l_icloglock.
+		 * in the DONE_SYNC state, we skip the rest and just try to
+		 * clean up.
 		 */
-		if (completed_iclog &&
-		    (completed_iclog->ic_state == XLOG_STATE_DONE_SYNC))
-			completed_iclog->ic_state = XLOG_STATE_DO_CALLBACK;
 		return true;
 	}
 }
@@ -2838,54 +2830,13 @@ xlog_state_do_iclog_callbacks(
 	spin_unlock(&iclog->ic_callback_lock);
 }
 
-#ifdef DEBUG
-/*
- * Make one last gasp attempt to see if iclogs are being left in limbo.  If the
- * above loop finds an iclog earlier than the current iclog and in one of the
- * syncing states, the current iclog is put into DO_CALLBACK and the callbacks
- * are deferred to the completion of the earlier iclog. Walk the iclogs in order
- * and make sure that no iclog is in DO_CALLBACK unless an earlier iclog is in
- * one of the syncing states.
- */
-static void
-xlog_state_callback_check_state(
-	struct xlog		*log)
-{
-	struct xlog_in_core	*first_iclog = log->l_iclog;
-	struct xlog_in_core	*iclog = first_iclog;
-
-	do {
-		ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
-		/*
-		 * Terminate the loop if iclogs are found in states
-		 * which will cause other threads to clean up iclogs.
-		 *
-		 * SYNCING - i/o completion will go through logs
-		 * DONE_SYNC - interrupt thread should be waiting for
-		 *              l_icloglock
-		 * IOERROR - give up hope all ye who enter here
-		 */
-		if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-		    iclog->ic_state == XLOG_STATE_SYNCING ||
-		    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
-		    iclog->ic_state == XLOG_STATE_IOERROR )
-			break;
-		iclog = iclog->ic_next;
-	} while (first_iclog != iclog);
-}
-#else
-#define xlog_state_callback_check_state(l)	((void)0)
-#endif
-
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log,
-	bool			aborted,
-	struct xlog_in_core	*ciclog)
+	bool			aborted)
 {
 	struct xlog_in_core	*iclog;
 	struct xlog_in_core	*first_iclog;
-	bool			did_callbacks = false;
 	bool			cycled_icloglock;
 	bool			ioerror;
 	int			flushcnt = 0;
@@ -2909,7 +2860,7 @@ xlog_state_do_callback(
 
 		do {
 			if (xlog_state_iodone_process_iclog(log, iclog,
-							ciclog, &ioerror))
+							&ioerror))
 				break;
 
 			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
@@ -2929,8 +2880,6 @@ xlog_state_do_callback(
 			iclog = iclog->ic_next;
 		} while (first_iclog != iclog);
 
-		did_callbacks |= cycled_icloglock;
-
 		if (repeats > 5000) {
 			flushcnt += repeats;
 			repeats = 0;
@@ -2940,9 +2889,6 @@ xlog_state_do_callback(
 		}
 	} while (!ioerror && cycled_icloglock);
 
-	if (did_callbacks)
-		xlog_state_callback_check_state(log);
-
 	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
 	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
 		wake_up_all(&log->l_flush_wait);
@@ -2993,7 +2939,7 @@ xlog_state_done_syncing(
 	 */
 	wake_up_all(&iclog->ic_write_wait);
 	spin_unlock(&log->l_icloglock);
-	xlog_state_do_callback(log, aborted, iclog);	/* also cleans log */
+	xlog_state_do_callback(log, aborted);	/* also cleans log */
 }	/* xlog_state_done_syncing */
 
 
@@ -3987,7 +3933,7 @@ xfs_log_force_umount(
 	spin_lock(&log->l_cilp->xc_push_lock);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
 	spin_unlock(&log->l_cilp->xc_push_lock);
-	xlog_state_do_callback(log, true, NULL);
+	xlog_state_do_callback(log, true);
 
 	/* return non-zero if log IOERROR transition had already happened */
 	return retval;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index bf076893f516..4f19375f6592 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -45,7 +45,6 @@ enum xlog_iclog_state {
 	XLOG_STATE_WANT_SYNC,	/* Want to sync this iclog; no more writes */
 	XLOG_STATE_SYNCING,	/* This IC log is syncing */
 	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
-	XLOG_STATE_DO_CALLBACK,	/* Process callback functions */
 	XLOG_STATE_CALLBACK,	/* Callback functions now */
 	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
 	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
-- 
2.20.1

