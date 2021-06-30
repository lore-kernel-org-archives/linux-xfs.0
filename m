Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9410C11F6A
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 07:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A018261D0E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 07:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhF3HXn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 03:23:43 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:50590 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232879AbhF3HXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 03:23:42 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5885680B7B9
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 17:21:13 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyUX2-0013NN-EC
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 17:21:12 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyUX2-007M4V-6G
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 17:21:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: pass a CIL context to xlog_write()
Date:   Wed, 30 Jun 2021 17:21:05 +1000
Message-Id: <20210630072108.1752073-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630072108.1752073-1-david@fromorbit.com>
References: <20210630072108.1752073-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=mA0rlXmpgBq_sLbHoTEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Pass the CIL context to xlog_write() rather than a pointer to a LSN
variable. Only the CIL checkpoint calls to xlog_write() need to know
about the start LSN of the writes, so rework xlog_write to directly
write the LSNs into the CIL context structure.

This removes the commit_lsn variable from xlog_cil_push_work(), so
now we only have to issue the commit record ordering wakeup from
there.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 18 +++++++++------
 fs/xfs/xfs_log_cil.c  | 52 ++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_log_priv.h |  7 ++++--
 3 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 559a78f3752d..fd0731cf1cb3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -898,7 +898,7 @@ xlog_write_unmount_record(
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp)
 		blkdev_issue_flush(log->l_targ->bt_bdev);
-	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
+	return xlog_write(log, NULL, &vec, ticket, NULL, XLOG_UNMOUNT_TRANS);
 }
 
 /*
@@ -2391,9 +2391,9 @@ xlog_write_copy_finish(
 int
 xlog_write(
 	struct xlog		*log,
+	struct xfs_cil_ctx	*ctx,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
-	xfs_lsn_t		*start_lsn,
 	struct xlog_in_core	**commit_iclog,
 	uint			optype)
 {
@@ -2424,8 +2424,6 @@ xlog_write(
 	}
 
 	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
-	if (start_lsn)
-		*start_lsn = 0;
 	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 		void		*ptr;
 		int		log_offset;
@@ -2438,9 +2436,15 @@ xlog_write(
 		ASSERT(log_offset <= iclog->ic_size - 1);
 		ptr = iclog->ic_datap + log_offset;
 
-		/* Start_lsn is the first lsn written to. */
-		if (start_lsn && !*start_lsn)
-			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+		/*
+		 * If we have a context pointer, pass it the first iclog we are
+		 * writing to so it can record state needed for iclog write
+		 * ordering.
+		 */
+		if (ctx) {
+			xlog_cil_set_ctx_write_state(ctx, iclog);
+			ctx = NULL;
+		}
 
 		/*
 		 * This loop writes out as many regions as can fit in the amount
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 41f44e6e191c..4b6589bbddb5 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -631,6 +631,30 @@ xlog_cil_process_committed(
 	}
 }
 
+/*
+* Record the LSN of the iclog we were just granted space to start writing into.
+* If the context doesn't have a start_lsn recorded, then this iclog will
+* contain the start record for the checkpoint. Otherwise this write contains
+* the commit record for the checkpoint.
+*/
+void
+xlog_cil_set_ctx_write_state(
+	struct xfs_cil_ctx	*ctx,
+	struct xlog_in_core	*iclog)
+{
+	struct xfs_cil		*cil = ctx->cil;
+	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+
+	ASSERT(!ctx->commit_lsn);
+	spin_lock(&cil->xc_push_lock);
+	if (!ctx->start_lsn)
+		ctx->start_lsn = lsn;
+	else
+		ctx->commit_lsn = lsn;
+	spin_unlock(&cil->xc_push_lock);
+}
+
+
 /*
  * Write out the commit record of a checkpoint transaction associated with the
  * given ticket to close off a running log write. Return the lsn of the commit
@@ -638,26 +662,26 @@ xlog_cil_process_committed(
  */
 static int
 xlog_cil_write_commit_record(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*lsn)
+	struct xfs_cil_ctx	*ctx,
+	struct xlog_in_core	**iclog)
 {
-	struct xfs_log_iovec reg = {
+	struct xlog		*log = ctx->cil->xc_log;
+	struct xfs_log_iovec	reg = {
 		.i_addr = NULL,
 		.i_len = 0,
 		.i_type = XLOG_REG_TYPE_COMMIT,
 	};
-	struct xfs_log_vec vec = {
+	struct xfs_log_vec	vec = {
 		.lv_niovecs = 1,
 		.lv_iovecp = &reg,
 	};
-	int	error;
+	int			error;
 
 	if (xlog_is_shutdown(log))
 		return -EIO;
 
-	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
+	error = xlog_write(log, ctx, &vec, ctx->ticket, iclog,
+			XLOG_COMMIT_TRANS);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -694,7 +718,6 @@ xlog_cil_push_work(
 	struct xfs_trans_header thdr;
 	struct xfs_log_iovec	lhdr;
 	struct xfs_log_vec	lvhdr = { NULL };
-	xfs_lsn_t		commit_lsn;
 	xfs_lsn_t		push_seq;
 	struct bio		bio;
 	DECLARE_COMPLETION_ONSTACK(bdev_flush);
@@ -868,8 +891,7 @@ xlog_cil_push_work(
 	 */
 	wait_for_completion(&bdev_flush);
 
-	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL,
-				XLOG_START_TRANS);
+	error = xlog_write(log, ctx, &lvhdr, tic, NULL, XLOG_START_TRANS);
 	if (error)
 		goto out_abort_free_ticket;
 
@@ -907,8 +929,7 @@ xlog_cil_push_work(
 	}
 	spin_unlock(&cil->xc_push_lock);
 
-	error = xlog_cil_write_commit_record(log, tic, &commit_iclog,
-			&commit_lsn);
+	error = xlog_cil_write_commit_record(ctx, &commit_iclog);
 	if (error)
 		goto out_abort_free_ticket;
 
@@ -935,7 +956,6 @@ xlog_cil_push_work(
 	 * and wake up anyone who is waiting for the commit to complete.
 	 */
 	spin_lock(&cil->xc_push_lock);
-	ctx->commit_lsn = commit_lsn;
 	wake_up_all(&cil->xc_commit_wait);
 	spin_unlock(&cil->xc_push_lock);
 
@@ -951,11 +971,11 @@ xlog_cil_push_work(
 	 * iclog header lsn and compare it to the commit lsn to determine if we
 	 * need to wait on iclogs or not.
 	 */
-	if (ctx->start_lsn != commit_lsn) {
+	if (ctx->start_lsn != ctx->commit_lsn) {
 		xfs_lsn_t	plsn;
 
 		plsn = be64_to_cpu(commit_iclog->ic_prev->ic_header.h_lsn);
-		if (plsn && XFS_LSN_CMP(plsn, commit_lsn) < 0) {
+		if (plsn && XFS_LSN_CMP(plsn, ctx->commit_lsn) < 0) {
 			/*
 			 * Waiting on ic_force_wait orders the completion of
 			 * iclogs older than ic_prev. Hence we only need to wait
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 2de9fe62d8ca..2a02ce05b649 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -501,8 +501,8 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
 
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
-int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
-		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
+int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
+		struct xfs_log_vec *log_vector, struct xlog_ticket *tic,
 		struct xlog_in_core **commit_iclog, uint optype);
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
@@ -573,6 +573,9 @@ void	xlog_cil_destroy(struct xlog *log);
 bool	xlog_cil_empty(struct xlog *log);
 void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
 			xfs_csn_t *commit_seq, bool regrant);
+void	xlog_cil_set_ctx_write_state(struct xfs_cil_ctx *ctx,
+			struct xlog_in_core *iclog);
+
 
 /*
  * CIL force routines
-- 
2.31.1

