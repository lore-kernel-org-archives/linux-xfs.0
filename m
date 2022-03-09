Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C510EC4321E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiCIFaq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiCIFan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:43 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9686E3FBD6
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:44 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id ADBE610E26E9
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H4v-EK
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJWZ-D6
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/16] xfs: factor out the CIL transaction header building
Date:   Wed,  9 Mar 2022 16:29:22 +1100
Message-Id: <20220309052937.2696447-2-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309052937.2696447-1-david@fromorbit.com>
References: <20220309052937.2696447-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62283b45
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=BhXQ-DyxcvpHrDhDbLgA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It is static code deep in the middle of the CIL push logic. Factor
it out into a helper so that it is clear and easy to modify
separately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_cil.c | 61 ++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 83a039762b81..ab96565529d8 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -858,6 +858,41 @@ xlog_cil_write_commit_record(
 	return error;
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
+	tic->t_curr_res -= hdr->lhdr.i_len + sizeof(struct xlog_op_header);
+
+	lvhdr->lv_niovecs = 1;
+	lvhdr->lv_iovecp = &hdr->lhdr;
+	lvhdr->lv_next = ctx->lv_chain;
+}
+
 /*
  * Push the Committed Item List to the log.
  *
@@ -882,11 +917,9 @@ xlog_cil_push_work(
 	struct xlog		*log = cil->xc_log;
 	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*new_ctx;
-	struct xlog_ticket	*tic;
 	int			num_iovecs;
 	int			error = 0;
-	struct xfs_trans_header thdr;
-	struct xfs_log_iovec	lhdr;
+	struct xlog_cil_trans_hdr thdr;
 	struct xfs_log_vec	lvhdr = { NULL };
 	xfs_lsn_t		preflush_tail_lsn;
 	xfs_csn_t		push_seq;
@@ -1035,24 +1068,8 @@ xlog_cil_push_work(
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
@@ -1068,7 +1085,7 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	xfs_log_ticket_ungrant(log, tic);
+	xfs_log_ticket_ungrant(log, ctx->ticket);
 
 	/*
 	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
@@ -1132,7 +1149,7 @@ xlog_cil_push_work(
 	return;
 
 out_abort_free_ticket:
-	xfs_log_ticket_ungrant(log, tic);
+	xfs_log_ticket_ungrant(log, ctx->ticket);
 	ASSERT(xlog_is_shutdown(log));
 	if (!ctx->commit_iclog) {
 		xlog_cil_committed(ctx);
-- 
2.33.0

