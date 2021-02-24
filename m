Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E709C4332B
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 06:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1DB460C3E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 06:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhBXGfz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 01:35:55 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:33223 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233739AbhBXGfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 01:35:46 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 79A831AD613
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 17:35:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEnlG-001loE-KY
        for linux-xfs@vger.kernel.org; Wed, 24 Feb 2021 17:35:02 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEnlG-00EQqj-Cj
        for linux-xfs@vger.kernel.org; Wed, 24 Feb 2021 17:35:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/13] xfs: factor out the CIL transaction header building
Date:   Wed, 24 Feb 2021 17:34:47 +1100
Message-Id: <20210224063459.3436852-2-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210224063459.3436852-1-david@fromorbit.com>
References: <20210224063459.3436852-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=LUy3kMpZBJK1m2kfqSYA:9
        a=NcoQNvhe-oT6KlQJ:21 a=lm7fjIG7RdWeNkM_:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It is static code deep in the middle of the CIL push logic. Factor
it out into a helper so that it is clear and easy to modify
separately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 71 +++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 54d3fabd9a5b..e8c674b291f3 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -651,6 +651,41 @@ xlog_cil_process_committed(
 	}
 }
 
+struct xlog_cil_trans_hdr {
+	struct xfs_trans_header	thdr;
+	struct xfs_log_iovec	lhdr;
+};
+
+/*
+ * Build a checkpoint transaction header to begin the journal transaction.  We
+ * need to account for the space used by the transaction header here as it is
+ * not accounted for in xlog_write().
+ */
+static void
+xlog_cil_build_trans_hdr(
+	struct xfs_cil_ctx	*ctx,
+	struct xlog_cil_trans_hdr *hdr,
+	struct xfs_log_vec	*lvhdr,
+	int			num_iovecs)
+{
+	struct xlog_ticket	*tic = ctx->ticket;
+
+	memset(hdr, 0, sizeof(*hdr));
+
+	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
+	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
+	hdr->thdr.th_tid = tic->t_tid;
+	hdr->thdr.th_num_items = num_iovecs;
+	hdr->lhdr.i_addr = &hdr->thdr;
+	hdr->lhdr.i_len = sizeof(xfs_trans_header_t);
+	hdr->lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
+	tic->t_curr_res -= hdr->lhdr.i_len + sizeof(xlog_op_header_t);
+
+	lvhdr->lv_niovecs = 1;
+	lvhdr->lv_iovecp = &hdr->lhdr;
+	lvhdr->lv_next = ctx->lv_chain;
+}
+
 /*
  * Push the Committed Item List to the log.
  *
@@ -676,11 +711,9 @@ xlog_cil_push_work(
 	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*new_ctx;
 	struct xlog_in_core	*commit_iclog;
-	struct xlog_ticket	*tic;
 	int			num_iovecs;
 	int			error = 0;
-	struct xfs_trans_header thdr;
-	struct xfs_log_iovec	lhdr;
+	struct xlog_cil_trans_hdr thdr;
 	struct xfs_log_vec	lvhdr = { NULL };
 	xfs_lsn_t		commit_lsn;
 	xfs_lsn_t		push_seq;
@@ -822,24 +855,8 @@ xlog_cil_push_work(
 	 * Build a checkpoint transaction header and write it to the log to
 	 * begin the transaction. We need to account for the space used by the
 	 * transaction header here as it is not accounted for in xlog_write().
-	 *
-	 * The LSN we need to pass to the log items on transaction commit is
-	 * the LSN reported by the first log vector write. If we use the commit
-	 * record lsn then we can move the tail beyond the grant write head.
 	 */
-	tic = ctx->ticket;
-	thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
-	thdr.th_type = XFS_TRANS_CHECKPOINT;
-	thdr.th_tid = tic->t_tid;
-	thdr.th_num_items = num_iovecs;
-	lhdr.i_addr = &thdr;
-	lhdr.i_len = sizeof(xfs_trans_header_t);
-	lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
-	tic->t_curr_res -= lhdr.i_len + sizeof(xlog_op_header_t);
-
-	lvhdr.lv_niovecs = 1;
-	lvhdr.lv_iovecp = &lhdr;
-	lvhdr.lv_next = ctx->lv_chain;
+	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
 
 	/*
 	 * Before we format and submit the first iclog, we have to ensure that
@@ -847,7 +864,13 @@ xlog_cil_push_work(
 	 */
 	wait_for_completion(&bdev_flush);
 
-	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL,
+	/*
+	 * The LSN we need to pass to the log items on transaction commit is the
+	 * LSN reported by the first log vector write, not the commit lsn. If we
+	 * use the commit record lsn then we can move the tail beyond the grant
+	 * write head.
+	 */
+	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
 				XLOG_START_TRANS);
 	if (error)
 		goto out_abort_free_ticket;
@@ -886,11 +909,11 @@ xlog_cil_push_work(
 	}
 	spin_unlock(&cil->xc_push_lock);
 
-	error = xlog_commit_record(log, tic, &commit_iclog, &commit_lsn);
+	error = xlog_commit_record(log, ctx->ticket, &commit_iclog, &commit_lsn);
 	if (error)
 		goto out_abort_free_ticket;
 
-	xfs_log_ticket_ungrant(log, tic);
+	xfs_log_ticket_ungrant(log, ctx->ticket);
 
 	spin_lock(&commit_iclog->ic_callback_lock);
 	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
@@ -935,7 +958,7 @@ xlog_cil_push_work(
 	return;
 
 out_abort_free_ticket:
-	xfs_log_ticket_ungrant(log, tic);
+	xfs_log_ticket_ungrant(log, ctx->ticket);
 out_abort:
 	ASSERT(XLOG_FORCED_SHUTDOWN(log));
 	xlog_cil_committed(ctx);
-- 
2.28.0

