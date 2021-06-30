Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825B1C11F6C
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C26261D0D
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhF3Gks (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 02:40:48 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:36731 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232520AbhF3Gkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 02:40:47 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id BDB2C1B0952
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 16:38:16 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrT-0012kC-Vt
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrT-007LlA-O8
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/9] xfs: XLOG_STATE_IOERROR must die
Date:   Wed, 30 Jun 2021 16:38:06 +1000
Message-Id: <20210630063813.1751007-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630063813.1751007-1-david@fromorbit.com>
References: <20210630063813.1751007-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=p1n60LeDUcQraZ1cDp0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We don't need an iclog state field to tell us the log has been shut
down. We can just check the xlog_is_shutdown() instead. The avoids
the need to shutdowns overwriting the current iclog state while
being active used by the log code and so having to ensure that every
iclog state check handles XLOG_STATE_IOERROR appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 114 +++++++++++++-----------------------------
 fs/xfs/xfs_log_cil.c  |   2 +-
 fs/xfs/xfs_log_priv.h |   5 +-
 fs/xfs/xfs_trace.h    |   1 -
 4 files changed, 36 insertions(+), 86 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5ae11e7bf2fd..3ea67a90bcde 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -522,7 +522,7 @@ xlog_state_release_iclog(
 	lockdep_assert_held(&log->l_icloglock);
 
 	trace_xlog_iclog_release(iclog, _RET_IP_);
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
@@ -857,7 +857,7 @@ xlog_unmount_write(
 	error = xlog_write_unmount_record(log, tic);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
-	 * transitioning log state to IOERROR. Just continue...
+	 * transitioning log state to shutdown. Just continue...
 	 */
 out_err:
 	if (error)
@@ -870,7 +870,7 @@ xlog_unmount_write(
 		xlog_state_switch_iclogs(log, iclog, 0);
 	else
 		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-		       iclog->ic_state == XLOG_STATE_IOERROR);
+			xlog_is_shutdown(log));
 	/*
 	 * Ensure the journal is fully flushed and on stable storage once the
 	 * iclog containing the unmount record is written.
@@ -1769,7 +1769,7 @@ xlog_write_iclog(
 	 * across the log IO to archieve that.
 	 */
 	down(&iclog->ic_sema);
-	if (unlikely(iclog->ic_state == XLOG_STATE_IOERROR)) {
+	if (xlog_is_shutdown(log)) {
 		/*
 		 * It would seem logical to return EIO here, but we rely on
 		 * the log state machine to propagate I/O errors instead of
@@ -2298,7 +2298,7 @@ xlog_write_copy_finish(
 			xlog_state_switch_iclogs(log, iclog, 0);
 		else
 			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-			       iclog->ic_state == XLOG_STATE_IOERROR);
+				xlog_is_shutdown(log));
 		if (!commit_iclog)
 			goto release_iclog;
 		spin_unlock(&log->l_icloglock);
@@ -2713,8 +2713,7 @@ xlog_state_set_callback(
 static bool
 xlog_state_iodone_process_iclog(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	bool			*ioerror)
+	struct xlog_in_core	*iclog)
 {
 	xfs_lsn_t		lowest_lsn;
 	xfs_lsn_t		header_lsn;
@@ -2726,15 +2725,6 @@ xlog_state_iodone_process_iclog(
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
@@ -2765,12 +2755,13 @@ xlog_state_do_callback(
 	struct xlog_in_core	*iclog;
 	struct xlog_in_core	*first_iclog;
 	bool			cycled_icloglock;
-	bool			ioerror;
 	int			flushcnt = 0;
 	int			repeats = 0;
 
 	spin_lock(&log->l_icloglock);
 	do {
+		repeats++;
+
 		/*
 		 * Scan all iclogs starting with the one pointed to by the
 		 * log.  Reset this starting point each time the log is
@@ -2779,23 +2770,21 @@ xlog_state_do_callback(
 		 * Keep looping through iclogs until one full pass is made
 		 * without running any callbacks.
 		 */
-		first_iclog = log->l_iclog;
-		iclog = log->l_iclog;
 		cycled_icloglock = false;
-		ioerror = false;
-		repeats++;
-
-		do {
+		first_iclog = NULL;
+		for (iclog = log->l_iclog;
+		     iclog != first_iclog;
+		     iclog = iclog->ic_next) {
 			LIST_HEAD(cb_list);
 
-			if (xlog_state_iodone_process_iclog(log, iclog,
-							&ioerror))
-				break;
+			if (!first_iclog)
+				first_iclog = iclog;
 
-			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
-			    iclog->ic_state != XLOG_STATE_IOERROR) {
-				iclog = iclog->ic_next;
-				continue;
+			if (!xlog_is_shutdown(log)) {
+				if (xlog_state_iodone_process_iclog(log, iclog))
+					break;
+				if (iclog->ic_state != XLOG_STATE_CALLBACK)
+					continue;
 			}
 			list_splice_init(&iclog->ic_callbacks, &cb_list);
 			spin_unlock(&log->l_icloglock);
@@ -2810,8 +2799,7 @@ xlog_state_do_callback(
 				wake_up_all(&iclog->ic_force_wait);
 			else
 				xlog_state_clean_iclog(log, iclog);
-			iclog = iclog->ic_next;
-		} while (first_iclog != iclog);
+		};
 
 		if (repeats > 5000) {
 			flushcnt += repeats;
@@ -2820,10 +2808,10 @@ xlog_state_do_callback(
 				"%s: possible infinite loop (%d iterations)",
 				__func__, flushcnt);
 		}
-	} while (!ioerror && cycled_icloglock);
+	} while (!xlog_is_shutdown(log) && cycled_icloglock);
 
 	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
-	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
+	    xlog_is_shutdown(log))
 		wake_up_all(&log->l_flush_wait);
 
 	spin_unlock(&log->l_icloglock);
@@ -2833,13 +2821,6 @@ xlog_state_do_callback(
 /*
  * Finish transitioning this iclog to the dirty state.
  *
- * Make sure that we completely execute this routine only when this is
- * the last call to the iclog.  There is a good chance that iclog flushes,
- * when we reach the end of the physical log, get turned into 2 separate
- * calls to bwrite.  Hence, one iclog flush could generate two calls to this
- * routine.  By using the reference count bwritecnt, we guarantee that only
- * the second completion goes through.
- *
  * Callbacks could take time, so they are done outside the scope of the
  * global state machine log lock.
  */
@@ -3171,10 +3152,10 @@ xfs_log_force(
 	xlog_cil_force(log);
 
 	spin_lock(&log->l_icloglock);
-	iclog = log->l_iclog;
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (xlog_is_shutdown(log))
 		goto out_error;
 
+	iclog = log->l_iclog;
 	trace_xlog_iclog_force(iclog, _RET_IP_);
 
 	if (iclog->ic_state == XLOG_STATE_DIRTY ||
@@ -3245,10 +3226,10 @@ xlog_force_lsn(
 	struct xlog_in_core	*iclog;
 
 	spin_lock(&log->l_icloglock);
-	iclog = log->l_iclog;
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (xlog_is_shutdown(log))
 		goto out_error;
 
+	iclog = log->l_iclog;
 	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
 		trace_xlog_iclog_force_lsn(iclog, _RET_IP_);
 		iclog = iclog->ic_next;
@@ -3683,34 +3664,6 @@ xlog_verify_iclog(
 }
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
@@ -3726,6 +3679,8 @@ xlog_state_ioerror(
  * Note: for the !logerror case we need to flush the regions held in memory out
  * to disk first. This needs to be done before the log is marked as shutdown,
  * otherwise the iclog writes will fail.
+ *
+ * Return non-zero if log shutdown transition had already happened.
  */
 int
 xfs_log_force_umount(
@@ -3733,7 +3688,7 @@ xfs_log_force_umount(
 	int			logerror)
 {
 	struct xlog	*log;
-	int		retval;
+	int		retval = 0;
 
 	log = mp->m_log;
 
@@ -3753,10 +3708,8 @@ xfs_log_force_umount(
 	 * Somebody could've already done the hard work for us.
 	 * No need to get locks for this.
 	 */
-	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
-		ASSERT(xlog_is_shutdown(log));
+	if (logerror && xlog_is_shutdown(log))
 		return 1;
-	}
 
 	/*
 	 * Flush all the completed transactions to disk before marking the log
@@ -3781,8 +3734,10 @@ xfs_log_force_umount(
 	 * Mark the log and the iclogs with IO error flags to prevent any
 	 * further log IO from being issued or completed.
 	 */
-	log->l_flags |= XLOG_IO_ERROR;
-	retval = xlog_state_ioerror(log);
+	if (!(log->l_flags & XLOG_IO_ERROR)) {
+		log->l_flags |= XLOG_IO_ERROR;
+		retval = 1;
+	}
 	spin_unlock(&log->l_icloglock);
 
 	/*
@@ -3806,7 +3761,6 @@ xfs_log_force_umount(
 	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_do_callback(log);
 
-	/* return non-zero if log IOERROR transition had already happened */
 	return retval;
 }
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 23eec4f76f19..1616d0442cd9 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -889,7 +889,7 @@ xlog_cil_push_work(
 	 * callbacks and dropped the icloglock.
 	 */
 	spin_lock(&log->l_icloglock);
-	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
+	if (xlog_is_shutdown(log)) {
 		spin_unlock(&log->l_icloglock);
 		goto out_abort;
 	}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 80d4e1325e1d..bf05763ba8df 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -47,7 +47,6 @@ enum xlog_iclog_state {
 	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
 	XLOG_STATE_CALLBACK,	/* Callback functions now */
 	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
-	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
 };
 
 #define XLOG_STATE_STRINGS \
@@ -56,9 +55,7 @@ enum xlog_iclog_state {
 	{ XLOG_STATE_SYNCING,	"XLOG_STATE_SYNCING" }, \
 	{ XLOG_STATE_DONE_SYNC,	"XLOG_STATE_DONE_SYNC" }, \
 	{ XLOG_STATE_CALLBACK,	"XLOG_STATE_CALLBACK" }, \
-	{ XLOG_STATE_DIRTY,	"XLOG_STATE_DIRTY" }, \
-	{ XLOG_STATE_IOERROR,	"XLOG_STATE_IOERROR" }
-
+	{ XLOG_STATE_DIRTY,	"XLOG_STATE_DIRTY" }
 
 /*
  * Log ticket flags
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 38f2f67303f7..da49db486b90 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3932,7 +3932,6 @@ TRACE_DEFINE_ENUM(XLOG_STATE_SYNCING);
 TRACE_DEFINE_ENUM(XLOG_STATE_DONE_SYNC);
 TRACE_DEFINE_ENUM(XLOG_STATE_CALLBACK);
 TRACE_DEFINE_ENUM(XLOG_STATE_DIRTY);
-TRACE_DEFINE_ENUM(XLOG_STATE_IOERROR);
 
 DECLARE_EVENT_CLASS(xlog_iclog_class,
 	TP_PROTO(struct xlog_in_core *iclog, unsigned long caller_ip),
-- 
2.31.1

