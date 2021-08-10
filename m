Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2E9C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A7060EC0
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbhHJFWA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:22:00 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40899 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237625AbhHJFVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:21:52 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 59FC780BBD1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:21:23 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDKCY-00GZcH-Qm
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:21:22 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDKCY-000Agy-JJ
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:21:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: factor out log write ordering from xlog_cil_push_work()
Date:   Tue, 10 Aug 2021 15:21:18 +1000
Message-Id: <20210810052120.41019-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810052120.41019-1-david@fromorbit.com>
References: <20210810052120.41019-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=k7W3vL2-wnp397sw1bIA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So we can use it for start record ordering as well as commit record
ordering in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c | 87 ++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 651118fbaa61..38917c97a582 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -656,9 +656,54 @@ xlog_cil_set_ctx_write_state(
 
 
 /*
- * Write out the commit record of a checkpoint transaction associated with the
- * given ticket to close off a running log write. Return the lsn of the commit
- * record.
+ * Ensure that the order of log writes follows checkpoint sequence order. This
+ * relies on the context LSN being zero until the log write has guaranteed the
+ * LSN that the log write will start at via xlog_state_get_iclog_space().
+ */
+static int
+xlog_cil_order_write(
+	struct xfs_cil		*cil,
+	xfs_csn_t		sequence)
+{
+	struct xfs_cil_ctx	*ctx;
+
+restart:
+	spin_lock(&cil->xc_push_lock);
+	list_for_each_entry(ctx, &cil->xc_committing, committing) {
+		/*
+		 * Avoid getting stuck in this loop because we were woken by the
+		 * shutdown, but then went back to sleep once already in the
+		 * shutdown state.
+		 */
+		if (xlog_is_shutdown(cil->xc_log)) {
+			spin_unlock(&cil->xc_push_lock);
+			return -EIO;
+		}
+
+		/*
+		 * Higher sequences will wait for this one so skip them.
+		 * Don't wait for our own sequence, either.
+		 */
+		if (ctx->sequence >= sequence)
+			continue;
+		if (!ctx->commit_lsn) {
+			/*
+			 * It is still being pushed! Wait for the push to
+			 * complete, then start again from the beginning.
+			 */
+			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
+			goto restart;
+		}
+	}
+	spin_unlock(&cil->xc_push_lock);
+	return 0;
+}
+
+/*
+ * Write out the commit record of a checkpoint transaction to close off a
+ * running log write. These commit records are strictly ordered in ascending CIL
+ * sequence order so that log recovery will always replay the checkpoints in the
+ * correct order.
  */
 static int
 xlog_cil_write_commit_record(
@@ -904,39 +949,9 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	/*
-	 * now that we've written the checkpoint into the log, strictly
-	 * order the commit records so replay will get them in the right order.
-	 */
-restart:
-	spin_lock(&cil->xc_push_lock);
-	list_for_each_entry(new_ctx, &cil->xc_committing, committing) {
-		/*
-		 * Avoid getting stuck in this loop because we were woken by the
-		 * shutdown, but then went back to sleep once already in the
-		 * shutdown state.
-		 */
-		if (xlog_is_shutdown(log)) {
-			spin_unlock(&cil->xc_push_lock);
-			goto out_abort_free_ticket;
-		}
-
-		/*
-		 * Higher sequences will wait for this one so skip them.
-		 * Don't wait for our own sequence, either.
-		 */
-		if (new_ctx->sequence >= ctx->sequence)
-			continue;
-		if (!new_ctx->commit_lsn) {
-			/*
-			 * It is still being pushed! Wait for the push to
-			 * complete, then start again from the beginning.
-			 */
-			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
-			goto restart;
-		}
-	}
-	spin_unlock(&cil->xc_push_lock);
+	error = xlog_cil_order_write(ctx->cil, ctx->sequence);
+	if (error)
+		goto out_abort_free_ticket;
 
 	error = xlog_cil_write_commit_record(ctx, &commit_iclog);
 	if (error)
-- 
2.31.1

