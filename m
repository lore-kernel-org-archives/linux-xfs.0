Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7903DC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4B760EC0
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbhHJFS7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:18:59 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:56050 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237571AbhHJFS6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:18:58 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 020871B3E58
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:18:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-00GZYm-So
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-000Abi-L8
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: convert XLOG_FORCED_SHUTDOWN() to xlog_is_shutdown()
Date:   Tue, 10 Aug 2021 15:18:17 +1000
Message-Id: <20210810051825.40715-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810051825.40715-1-david@fromorbit.com>
References: <20210810051825.40715-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=-psOZVuEB3Rg4DWKb8kA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Make it less shouty and a static inline before adding more calls
through the log code.

Also convert internal log code that uses XFS_FORCED_SHUTDOWN(mount)
to use xlog_is_shutdown(log) as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c         | 32 ++++++++++++++++----------------
 fs/xfs/xfs_log_cil.c     | 10 +++++-----
 fs/xfs/xfs_log_priv.h    |  7 +++++--
 fs/xfs/xfs_log_recover.c |  9 +++------
 fs/xfs/xfs_trans.c       |  2 +-
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index cc2a0ccfcc30..e2dc8acf48bc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -246,7 +246,7 @@ xlog_grant_head_wait(
 	list_add_tail(&tic->t_queue, &head->waiters);
 
 	do {
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto shutdown;
 		xlog_grant_push_ail(log, need_bytes);
 
@@ -260,7 +260,7 @@ xlog_grant_head_wait(
 		trace_xfs_log_grant_wake(log, tic);
 
 		spin_lock(&head->lock);
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto shutdown;
 	} while (xlog_space_left(log, &head->grant) < need_bytes);
 
@@ -365,7 +365,7 @@ xfs_log_writable(
 		return false;
 	if (xfs_readonly_buftarg(mp->m_log->l_targ))
 		return false;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xlog_is_shutdown(mp->m_log))
 		return false;
 	return true;
 }
@@ -382,7 +382,7 @@ xfs_log_regrant(
 	int			need_bytes;
 	int			error = 0;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
@@ -450,7 +450,7 @@ xfs_log_reserve(
 
 	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
@@ -830,7 +830,7 @@ xlog_wait_on_iclog(
 	struct xlog		*log = iclog->ic_log;
 
 	trace_xlog_iclog_wait_on(iclog, _RET_IP_);
-	if (!XLOG_FORCED_SHUTDOWN(log) &&
+	if (!xlog_is_shutdown(log) &&
 	    iclog->ic_state != XLOG_STATE_ACTIVE &&
 	    iclog->ic_state != XLOG_STATE_DIRTY) {
 		XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
@@ -839,7 +839,7 @@ xlog_wait_on_iclog(
 		spin_unlock(&log->l_icloglock);
 	}
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 	return 0;
 }
@@ -940,7 +940,7 @@ xfs_log_unmount_write(
 
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return;
 
 	/*
@@ -1063,7 +1063,7 @@ xfs_log_space_wake(
 	struct xlog		*log = mp->m_log;
 	int			free_bytes;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return;
 
 	if (!list_empty_careful(&log->l_write_head.waiters)) {
@@ -1154,7 +1154,7 @@ xfs_log_cover(
 
 	ASSERT((xlog_cil_empty(mp->m_log) && xlog_iclogs_empty(mp->m_log) &&
 	        !xfs_ail_min_lsn(mp->m_log->l_ailp)) ||
-	       XFS_FORCED_SHUTDOWN(mp));
+		xlog_is_shutdown(mp->m_log));
 
 	if (!xfs_log_writable(mp))
 		return 0;
@@ -1614,7 +1614,7 @@ xlog_commit_record(
 	};
 	int	error;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
@@ -1695,7 +1695,7 @@ xlog_grant_push_ail(
 	xfs_lsn_t	threshold_lsn;
 
 	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
-	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
+	if (threshold_lsn == NULLCOMMITLSN || xlog_is_shutdown(log))
 		return;
 
 	/*
@@ -2886,7 +2886,7 @@ xlog_state_do_callback(
 			cycled_icloglock = true;
 
 			spin_lock(&log->l_icloglock);
-			if (XLOG_FORCED_SHUTDOWN(log))
+			if (xlog_is_shutdown(log))
 				wake_up_all(&iclog->ic_force_wait);
 			else
 				xlog_state_clean_iclog(log, iclog);
@@ -2938,7 +2938,7 @@ xlog_state_done_syncing(
 	 * split log writes, on the second, we shut down the file system and
 	 * no iclogs should ever be attempted to be written to disk again.
 	 */
-	if (!XLOG_FORCED_SHUTDOWN(log)) {
+	if (!xlog_is_shutdown(log)) {
 		ASSERT(iclog->ic_state == XLOG_STATE_SYNCING);
 		iclog->ic_state = XLOG_STATE_DONE_SYNC;
 	}
@@ -2986,7 +2986,7 @@ xlog_state_get_iclog_space(
 
 restart:
 	spin_lock(&log->l_icloglock);
-	if (XLOG_FORCED_SHUTDOWN(log)) {
+	if (xlog_is_shutdown(log)) {
 		spin_unlock(&log->l_icloglock);
 		return -EIO;
 	}
@@ -3877,7 +3877,7 @@ xfs_log_force_umount(
 	 * No need to get locks for this.
 	 */
 	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
-		ASSERT(XLOG_FORCED_SHUTDOWN(log));
+		ASSERT(xlog_is_shutdown(log));
 		return 1;
 	}
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4e41130f206f..086e89334b5e 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -584,7 +584,7 @@ xlog_cil_committed(
 	struct xfs_cil_ctx	*ctx)
 {
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
-	bool			abort = XLOG_FORCED_SHUTDOWN(ctx->cil->xc_log);
+	bool			abort = xlog_is_shutdown(ctx->cil->xc_log);
 
 	/*
 	 * If the I/O failed, we're aborting the commit and already shutdown.
@@ -862,7 +862,7 @@ xlog_cil_push_work(
 		 * shutdown, but then went back to sleep once already in the
 		 * shutdown state.
 		 */
-		if (XLOG_FORCED_SHUTDOWN(log)) {
+		if (xlog_is_shutdown(log)) {
 			spin_unlock(&cil->xc_push_lock);
 			goto out_abort_free_ticket;
 		}
@@ -971,7 +971,7 @@ xlog_cil_push_work(
 out_abort_free_ticket:
 	xfs_log_ticket_ungrant(log, tic);
 out_abort:
-	ASSERT(XLOG_FORCED_SHUTDOWN(log));
+	ASSERT(xlog_is_shutdown(log));
 	xlog_cil_committed(ctx);
 }
 
@@ -1124,7 +1124,7 @@ xlog_cil_commit(
 
 	xlog_cil_insert_items(log, tp);
 
-	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
+	if (regrant && !xlog_is_shutdown(log))
 		xfs_log_ticket_regrant(log, tp->t_ticket);
 	else
 		xfs_log_ticket_ungrant(log, tp->t_ticket);
@@ -1197,7 +1197,7 @@ xlog_cil_force_seq(
 		 * shutdown, but then went back to sleep once already in the
 		 * shutdown state.
 		 */
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto out_shutdown;
 		if (ctx->sequence > sequence)
 			continue;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 6953f86f866c..e29fcb12dcb1 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -464,8 +464,11 @@ struct xlog {
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
 	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
 
-#define XLOG_FORCED_SHUTDOWN(log) \
-	(unlikely((log)->l_flags & XLOG_IO_ERROR))
+static inline bool
+xlog_is_shutdown(struct xlog *log)
+{
+	return (log->l_flags & XLOG_IO_ERROR);
+}
 
 /* common routines */
 extern int
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1d4213302078..e6589cf4d09f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -146,7 +146,7 @@ xlog_do_io(
 
 	error = xfs_rw_bdev(log->l_targ->bt_bdev, log->l_logBBstart + blk_no,
 			BBTOB(nbblks), data, op);
-	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp)) {
+	if (error && !xlog_is_shutdown(log)) {
 		xfs_alert(log->l_mp,
 			  "log recovery %s I/O error at daddr 0x%llx len %d error %d",
 			  op == REQ_OP_WRITE ? "write" : "read",
@@ -3313,10 +3313,7 @@ xlog_do_recover(
 	if (error)
 		return error;
 
-	/*
-	 * If IO errors happened during recovery, bail out.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	/*
@@ -3338,7 +3335,7 @@ xlog_do_recover(
 	xfs_buf_hold(bp);
 	error = _xfs_buf_read(bp, XBF_READ);
 	if (error) {
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (!xlog_is_shutdown(log)) {
 			xfs_buf_ioerror_alert(bp, __this_address);
 			ASSERT(0);
 		}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 83abaa219616..b52394b0e1f4 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -905,7 +905,7 @@ __xfs_trans_commit(
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		if (regrant && !XLOG_FORCED_SHUTDOWN(mp->m_log))
+		if (regrant && !xlog_is_shutdown(mp->m_log))
 			xfs_log_ticket_regrant(mp->m_log, tp->t_ticket);
 		else
 			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
-- 
2.31.1

