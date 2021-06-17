Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F554C49EA5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5723661405
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhFQI2c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:28:32 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:45024 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230361AbhFQI2c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:28:32 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id D43564183
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 18:26:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-00DjwO-F8
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-0044v9-7U
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: move xlog_commit_record to xfs_log_cil.c
Date:   Thu, 17 Jun 2021 18:26:12 +1000
Message-Id: <20210617082617.971602-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617082617.971602-1-david@fromorbit.com>
References: <20210617082617.971602-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=V8DxLeoJGKXQ6a2vHtwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It is only used by the CIL checkpoints, and is the counterpart to
start record formatting and writing that is already local to
xfs_log_cil.c.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 41 ---------------------------------------
 fs/xfs/xfs_log_cil.c  | 45 ++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log_priv.h |  2 --
 3 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 54fd6a695bb5..cf661c155786 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1563,47 +1563,6 @@ xlog_alloc_log(
 	return ERR_PTR(error);
 }	/* xlog_alloc_log */
 
-/*
- * Write out the commit record of a transaction associated with the given
- * ticket to close off a running log write. Return the lsn of the commit record.
- */
-int
-xlog_commit_record(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*lsn)
-{
-	struct xlog_op_header	ophdr = {
-		.oh_clientid = XFS_TRANSACTION,
-		.oh_tid = cpu_to_be32(ticket->t_tid),
-		.oh_flags = XLOG_COMMIT_TRANS,
-	};
-	struct xfs_log_iovec reg = {
-		.i_addr = &ophdr,
-		.i_len = sizeof(struct xlog_op_header),
-		.i_type = XLOG_REG_TYPE_COMMIT,
-	};
-	struct xfs_log_vec vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
-	int	error;
-	LIST_HEAD(lv_chain);
-	INIT_LIST_HEAD(&vec.lv_list);
-	list_add(&vec.lv_list, &lv_chain);
-
-	if (XLOG_FORCED_SHUTDOWN(log))
-		return -EIO;
-
-	/* account for space used by record data */
-	ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, &lv_chain, ticket, lsn, iclog, reg.i_len);
-	if (error)
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
-	return error;
-}
-
 /*
  * Compute the LSN that we'd need to push the log tail towards in order to have
  * (a) enough on-disk log space to log the number of bytes specified, (b) at
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 2fb0ab02dda3..2c8b25888c53 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -783,6 +783,48 @@ xlog_cil_build_trans_hdr(
 	tic->t_curr_res -= lvhdr->lv_bytes;
 }
 
+/*
+ * Write out the commit record of a checkpoint transaction associated with the
+ * given ticket to close off a running log write. Return the lsn of the commit
+ * record.
+ */
+int
+xlog_cil_write_commit_record(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	**iclog,
+	xfs_lsn_t		*lsn)
+{
+	struct xlog_op_header	ophdr = {
+		.oh_clientid = XFS_TRANSACTION,
+		.oh_tid = cpu_to_be32(ticket->t_tid),
+		.oh_flags = XLOG_COMMIT_TRANS,
+	};
+	struct xfs_log_iovec reg = {
+		.i_addr = &ophdr,
+		.i_len = sizeof(struct xlog_op_header),
+		.i_type = XLOG_REG_TYPE_COMMIT,
+	};
+	struct xfs_log_vec vec = {
+		.lv_niovecs = 1,
+		.lv_iovecp = &reg,
+	};
+	int	error;
+	LIST_HEAD(lv_chain);
+	INIT_LIST_HEAD(&vec.lv_list);
+	list_add(&vec.lv_list, &lv_chain);
+
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return -EIO;
+
+	/* account for space used by record data */
+	ticket->t_curr_res -= reg.i_len;
+	error = xlog_write(log, &lv_chain, ticket, lsn, iclog, reg.i_len);
+	if (error)
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+	return error;
+}
+
 /*
  * CIL item reordering compare function. We want to order in ascending ID order,
  * but we want to leave items with the same ID in the order they were added to
@@ -1041,7 +1083,8 @@ xlog_cil_push_work(
 	}
 	spin_unlock(&cil->xc_push_lock);
 
-	error = xlog_commit_record(log, ctx->ticket, &commit_iclog, &commit_lsn);
+	error = xlog_cil_write_commit_record(log, ctx->ticket, &commit_iclog,
+			&commit_lsn);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 330befd9f6be..26f26769d1c6 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -490,8 +490,6 @@ void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct list_head *lv_chain,
 		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
 		struct xlog_in_core **commit_iclog, uint32_t len);
-int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
-		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
 
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
-- 
2.31.1

