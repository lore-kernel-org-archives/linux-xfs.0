Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8B1C49EAB
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9822D613FB
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhFQI2d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:28:33 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39430 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230377AbhFQI2c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:28:32 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D32A6863029
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 18:26:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-00DjwL-Cd
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-0044vL-Az
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfs: attached iclog callbacks in xlog_cil_set_ctx_write_state()
Date:   Thu, 17 Jun 2021 18:26:16 +1000
Message-Id: <20210617082617.971602-8-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617082617.971602-1-david@fromorbit.com>
References: <20210617082617.971602-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=uxvPD085kqIpK6bAL4UA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently attach iclog callbacks for the CIL when the commit
iclog is returned from xlog_write. Because
xlog_state_get_iclog_space() always guarantees that the commit
record will fit in the iclog it returns, we can move this IO
callback setting to xlog_cil_set_ctx_write_state(), record the
commit iclog in the context and remove the need for the commit iclog
to be returned by xlog_write() altogether.


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |  8 ++----
 fs/xfs/xfs_log_cil.c  | 65 +++++++++++++++++++++++++------------------
 fs/xfs/xfs_log_priv.h |  3 +-
 3 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1c214b395223..359246d54db7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -871,7 +871,7 @@ xlog_write_unmount_record(
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp)
 		blkdev_issue_flush(log->l_targ->bt_bdev);
-	return xlog_write(log, NULL, &lv_chain, ticket, NULL, reg.i_len);
+	return xlog_write(log, NULL, &lv_chain, ticket, reg.i_len);
 }
 
 /*
@@ -2386,7 +2386,6 @@ xlog_write(
 	struct xfs_cil_ctx	*ctx,
 	struct list_head	*lv_chain,
 	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**commit_iclog,
 	uint32_t		len)
 {
 	struct xlog_in_core	*iclog = NULL;
@@ -2436,10 +2435,7 @@ xlog_write(
 	 */
 	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, 0);
-	if (commit_iclog)
-		*commit_iclog = iclog;
-	else
-		error = xlog_state_release_iclog(log, iclog, ticket);
+	error = xlog_state_release_iclog(log, iclog, ticket);
 	spin_unlock(&log->l_icloglock);
 
 	return error;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 2d8d904ffb78..87e30917ce2e 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -799,11 +799,34 @@ xlog_cil_set_ctx_write_state(
 
 	ASSERT(!ctx->commit_lsn);
 	spin_lock(&cil->xc_push_lock);
-	if (!ctx->start_lsn)
+	if (!ctx->start_lsn) {
 		ctx->start_lsn = lsn;
-	else
-		ctx->commit_lsn = lsn;
+		spin_unlock(&cil->xc_push_lock);
+		return;
+	}
+
+	/*
+	 * Take a reference to the iclog for the context so that we still hold
+	 * it when xlog_write is done and has released it. This means the
+	 * context controls when the iclog is released for IO.
+	 */
+	atomic_inc(&iclog->ic_refcnt);
+	ctx->commit_iclog = iclog;
+	ctx->commit_lsn = lsn;
 	spin_unlock(&cil->xc_push_lock);
+
+	/*
+	 * xlog_state_get_iclog_space() guarantees there is enough space in the
+	 * iclog for an entire commit record, so attach the context callbacks to
+	 * the iclog at this time if we are not already in a shutdown state.
+	 */
+	spin_lock(&iclog->ic_callback_lock);
+	if (iclog->ic_state == XLOG_STATE_IOERROR) {
+		spin_unlock(&iclog->ic_callback_lock);
+		return;
+	}
+	list_add_tail(&ctx->iclog_entry, &iclog->ic_callbacks);
+	spin_unlock(&iclog->ic_callback_lock);
 }
 
 /*
@@ -858,8 +881,7 @@ xlog_cil_order_write(
  */
 int
 xlog_cil_write_commit_record(
-	struct xfs_cil_ctx	*ctx,
-	struct xlog_in_core	**iclog)
+	struct xfs_cil_ctx	*ctx)
 {
 	struct xlog		*log = ctx->cil->xc_log;
 	struct xlog_op_header	ophdr = {
@@ -890,7 +912,7 @@ xlog_cil_write_commit_record(
 
 	/* account for space used by record data */
 	ctx->ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, ctx, &lv_chain, ctx->ticket, iclog, reg.i_len);
+	error = xlog_write(log, ctx, &lv_chain, ctx->ticket, reg.i_len);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -940,7 +962,6 @@ xlog_cil_push_work(
 	struct xlog		*log = cil->xc_log;
 	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*new_ctx;
-	struct xlog_in_core	*commit_iclog;
 	int			num_iovecs = 0;
 	int			num_bytes = 0;
 	int			error = 0;
@@ -1109,8 +1130,7 @@ xlog_cil_push_work(
 	 * use the commit record lsn then we can move the tail beyond the grant
 	 * write head.
 	 */
-	error = xlog_write(log, ctx, &ctx->lv_chain, ctx->ticket,
-				NULL, num_bytes);
+	error = xlog_write(log, ctx, &ctx->lv_chain, ctx->ticket, num_bytes);
 
 	/*
 	 * Take the lvhdr back off the lv_chain as it should not be passed
@@ -1120,20 +1140,10 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	error = xlog_cil_write_commit_record(ctx, &commit_iclog);
+	error = xlog_cil_write_commit_record(ctx);
 	if (error)
 		goto out_abort_free_ticket;
 
-	spin_lock(&commit_iclog->ic_callback_lock);
-	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
-		spin_unlock(&commit_iclog->ic_callback_lock);
-		goto out_abort_free_ticket;
-	}
-	ASSERT_ALWAYS(commit_iclog->ic_state == XLOG_STATE_ACTIVE ||
-		      commit_iclog->ic_state == XLOG_STATE_WANT_SYNC);
-	list_add_tail(&ctx->iclog_entry, &commit_iclog->ic_callbacks);
-	spin_unlock(&commit_iclog->ic_callback_lock);
-
 	/*
 	 * now the checkpoint commit is complete and we've attached the
 	 * callbacks to the iclog we can assign the commit LSN to the context
@@ -1168,8 +1178,8 @@ xlog_cil_push_work(
 	if (ctx->start_lsn != commit_lsn) {
 		struct xlog_in_core	*iclog;
 
-		for (iclog = commit_iclog->ic_prev;
-		     iclog != commit_iclog;
+		for (iclog = ctx->commit_iclog->ic_prev;
+		     iclog != ctx->commit_iclog;
 		     iclog = iclog->ic_prev) {
 			xfs_lsn_t	hlsn;
 
@@ -1201,7 +1211,7 @@ xlog_cil_push_work(
 		 * ordering for this checkpoint is correctly preserved down to
 		 * stable storage.
 		 */
-		commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
+		ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
 	}
 
 	/*
@@ -1214,10 +1224,11 @@ xlog_cil_push_work(
 	 * will be written when released, switch it's state to WANT_SYNC right
 	 * now.
 	 */
-	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
-	if (push_commit_stable && commit_iclog->ic_state == XLOG_STATE_ACTIVE)
-		xlog_state_switch_iclogs(log, commit_iclog, 0);
-	xlog_state_release_iclog(log, commit_iclog, ticket);
+	ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
+	if (push_commit_stable &&
+	    ctx->commit_iclog->ic_state == XLOG_STATE_ACTIVE)
+		xlog_state_switch_iclogs(log, ctx->commit_iclog, 0);
+	xlog_state_release_iclog(log, ctx->commit_iclog, ticket);
 	spin_unlock(&log->l_icloglock);
 
 	xfs_log_ticket_ungrant(log, ticket);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 849ba2eb3483..72dfa3b89513 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -237,6 +237,7 @@ struct xfs_cil_ctx {
 	struct work_struct	discard_endio_work;
 	struct work_struct	push_work;
 	atomic_t		order_id;
+	struct xlog_in_core	*commit_iclog;
 };
 
 /*
@@ -489,7 +490,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
 		struct list_head *lv_chain, struct xlog_ticket *tic,
-		struct xlog_in_core **commit_iclog, uint32_t len);
+		uint32_t len);
 
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
-- 
2.31.1

