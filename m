Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2648C49EA4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5EA161405
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFQI2c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:28:32 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:50379 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230284AbhFQI2c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:28:32 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id A97AD6AA29
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 18:26:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-00DjwY-Hq
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-0044vI-A9
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: separate out setting CIL context LSNs from xlog_write
Date:   Thu, 17 Jun 2021 18:26:15 +1000
Message-Id: <20210617082617.971602-7-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617082617.971602-1-david@fromorbit.com>
References: <20210617082617.971602-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=YsFj3S2UlflZm4waXM0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In preparation for moving more CIL context specific functionality
into these operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 17 ++---------------
 fs/xfs/xfs_log_cil.c  | 23 +++++++++++++++++++++++
 fs/xfs/xfs_log_priv.h |  2 ++
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fc0e43c57683..1c214b395223 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2408,21 +2408,8 @@ xlog_write(
 	if (error)
 		return error;
 
-	/*
-	 * If we have a CIL context, record the LSN of the iclog we were just
-	 * granted space to start writing into. If the context doesn't have
-	 * a start_lsn recorded, then this iclog will contain the start record
-	 * for the checkpoint. Otherwise this write contains the commit record
-	 * for the checkpoint.
-	 */
-	if (ctx) {
-		spin_lock(&ctx->cil->xc_push_lock);
-		if (!ctx->start_lsn)
-			ctx->start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
-		else
-			ctx->commit_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
-		spin_unlock(&ctx->cil->xc_push_lock);
-	}
+	if (ctx)
+		xlog_cil_set_ctx_write_state(ctx, iclog);
 
 	lv = list_first_entry_or_null(lv_chain, struct xfs_log_vec, lv_list);
 	while (lv) {
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f993ec69fc97..2d8d904ffb78 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -783,6 +783,29 @@ xlog_cil_build_trans_hdr(
 	tic->t_curr_res -= lvhdr->lv_bytes;
 }
 
+/*
+ * Record the LSN of the iclog we were just granted space to start writing into.
+ * If the context doesn't have a start_lsn recorded, then this iclog will
+ * contain the start record for the checkpoint. Otherwise this write contains
+ * the commit record for the checkpoint.
+ */
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
 /*
  * Ensure that the order of log writes follows checkpoint sequence order. This
  * relies on the context LSN being zero until the log write has guaranteed the
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index af8a9dfa8068..849ba2eb3483 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -563,6 +563,8 @@ void	xlog_cil_destroy(struct xlog *log);
 bool	xlog_cil_empty(struct xlog *log);
 void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
 			xfs_csn_t *commit_seq, bool regrant);
+void	xlog_cil_set_ctx_write_state(struct xfs_cil_ctx *ctx,
+			struct xlog_in_core *iclog);
 
 /*
  * CIL force routines
-- 
2.31.1

