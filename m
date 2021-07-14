Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDE9C11F66
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9761E6127C
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhGNDjx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:39:53 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:48173 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237729AbhGNDjw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 23:39:52 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id A72175D47
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 13:36:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3Vhh-006Ifz-V5
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:36:58 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3Vhh-00B037-NG
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:36:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: move xlog_commit_record to xfs_log_cil.c
Date:   Wed, 14 Jul 2021 13:36:52 +1000
Message-Id: <20210714033656.2621741-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714033656.2621741-1-david@fromorbit.com>
References: <20210714033656.2621741-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=HOSJ-cswk-H18GUH334A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It is only used by the CIL checkpoints, and is the counterpart to
start record formatting and writing that is already local to
xfs_log_cil.c.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 31 -------------------------------
 fs/xfs/xfs_log_cil.c  | 35 ++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log_priv.h |  2 --
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6617cdccaf00..f919c8736d50 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1595,37 +1595,6 @@ xlog_alloc_log(
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
-	struct xfs_log_iovec reg = {
-		.i_addr = NULL,
-		.i_len = 0,
-		.i_type = XLOG_REG_TYPE_COMMIT,
-	};
-	struct xfs_log_vec vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
-	int	error;
-
-	if (xlog_is_shutdown(log))
-		return -EIO;
-
-	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
-	if (error)
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
-	return error;
-}
-
 /*
  * Compute the LSN that we'd need to push the log tail towards in order to have
  * (a) enough on-disk log space to log the number of bytes specified, (b) at
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 62967449fe8c..5eb854bda839 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -623,6 +623,38 @@ xlog_cil_process_committed(
 	}
 }
 
+/*
+ * Write out the commit record of a checkpoint transaction associated with the
+ * given ticket to close off a running log write. Return the lsn of the commit
+ * record.
+ */
+static int
+xlog_cil_write_commit_record(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	**iclog,
+	xfs_lsn_t		*lsn)
+{
+	struct xfs_log_iovec reg = {
+		.i_addr = NULL,
+		.i_len = 0,
+		.i_type = XLOG_REG_TYPE_COMMIT,
+	};
+	struct xfs_log_vec vec = {
+		.lv_niovecs = 1,
+		.lv_iovecp = &reg,
+	};
+	int	error;
+
+	if (xlog_is_shutdown(log))
+		return -EIO;
+
+	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
+	if (error)
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+	return error;
+}
+
 /*
  * Push the Committed Item List to the log.
  *
@@ -867,7 +899,8 @@ xlog_cil_push_work(
 	}
 	spin_unlock(&cil->xc_push_lock);
 
-	error = xlog_commit_record(log, tic, &commit_iclog, &commit_lsn);
+	error = xlog_cil_write_commit_record(log, tic, &commit_iclog,
+			&commit_lsn);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 6c2f88e06ac3..2de9fe62d8ca 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -504,8 +504,6 @@ void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
 		struct xlog_in_core **commit_iclog, uint optype);
-int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
-		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
-- 
2.31.1

