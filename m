Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4810BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 04:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06AAC64DD9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 04:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhA1Eml (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:42:41 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35547 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231147AbhA1Emk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 23:42:40 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7B4BC3C330A
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 15:41:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l4z80-003F5H-Gc
        for linux-xfs@vger.kernel.org; Thu, 28 Jan 2021 15:41:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1l4z80-003NuA-8X
        for linux-xfs@vger.kernel.org; Thu, 28 Jan 2021 15:41:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: separate CIL commit record IO
Date:   Thu, 28 Jan 2021 15:41:51 +1100
Message-Id: <20210128044154.806715-3-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210128044154.806715-1-david@fromorbit.com>
References: <20210128044154.806715-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=EmqxpYm9HcoA:10 a=20KFwNOVAAAA:8 a=-CzamR9Lu324sNjnbDUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To allow for iclog IO device cache flush behaviour to be optimised,
we first need to separate out the commit record iclog IO from the
rest of the checkpoint so we can wait for the checkpoint IO to
complete before we issue the commit record.

This separate is only necessary if the commit record is being
written into a different iclog to the start of the checkpoint. If
the entire checkpoint and commit is in the one iclog, then they are
both covered by the one set of cache flush primitives on the iclog
and hence there is no need to separate them.

Otherwise, we need to wait for all the previous iclogs to complete
so they are ordered correctly and made stable by the REQ_PREFLUSH
that the commit record iclog IO issues. This guarantees that if a
reader sees the commit record in the journal, they will also see the
entire checkpoint that commit record closes off.

This also provides the guarantee that when the commit record IO
completes, we can safely unpin all the log items in the checkpoint
so they can be written back because the entire checkpoint is stable
in the journal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 47 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_cil.c  |  7 +++++++
 fs/xfs/xfs_log_priv.h |  2 ++
 3 files changed, 56 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c5f507c24577..c5e3da23961c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -808,6 +808,53 @@ xlog_wait_on_iclog(
 	return 0;
 }
 
+/*
+ * Wait on any iclogs that are still flushing in the range of start_lsn to
+ * the current iclog's lsn. The caller holds a reference to the iclog, but
+ * otherwise holds no log locks.
+ *
+ * We walk backwards through the iclogs to find the iclog with the highest lsn
+ * in the range that we need to wait for and then wait for it to complete.
+ * Completion ordering of iclog IOs ensures that all prior iclogs to this IO are
+ * complete by the time our candidate has completed.
+ */
+int
+xlog_wait_on_iclog_lsn(
+	struct xlog_in_core	*iclog,
+	xfs_lsn_t		start_lsn)
+{
+	struct xlog		*log = iclog->ic_log;
+	struct xlog_in_core	*prev;
+	int			error = -EIO;
+
+	spin_lock(&log->l_icloglock);
+	if (XLOG_FORCED_SHUTDOWN(log))
+		goto out_unlock;
+
+	error = 0;
+	for (prev = iclog->ic_prev; prev != iclog; prev = prev->ic_prev) {
+
+		/* Done if the lsn is before our start lsn */
+		if (XFS_LSN_CMP(be64_to_cpu(prev->ic_header.h_lsn),
+				start_lsn) < 0)
+			break;
+
+		/* Don't need to wait on completed, clean iclogs */
+		if (prev->ic_state == XLOG_STATE_DIRTY ||
+		    prev->ic_state == XLOG_STATE_ACTIVE) {
+			continue;
+		}
+
+		/* wait for completion on this iclog */
+		xlog_wait(&prev->ic_force_wait, &log->l_icloglock);
+		return 0;
+	}
+
+out_unlock:
+	spin_unlock(&log->l_icloglock);
+	return error;
+}
+
 /*
  * Write out an unmount record using the ticket provided. We have to account for
  * the data space used in the unmount ticket as this write is not done from a
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b0ef071b3cb5..c5cc1b7ad25e 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -870,6 +870,13 @@ xlog_cil_push_work(
 	wake_up_all(&cil->xc_commit_wait);
 	spin_unlock(&cil->xc_push_lock);
 
+	/*
+	 * If the checkpoint spans multiple iclogs, wait for all previous
+	 * iclogs to complete before we submit the commit_iclog.
+	 */
+	if (ctx->start_lsn != commit_lsn)
+		xlog_wait_on_iclog_lsn(commit_iclog, ctx->start_lsn);
+
 	/* release the hounds! */
 	xfs_log_release_iclog(commit_iclog);
 	return;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 037950cf1061..a7ac85aaff4e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -584,6 +584,8 @@ xlog_wait(
 	remove_wait_queue(wq, &wait);
 }
 
+int xlog_wait_on_iclog_lsn(struct xlog_in_core *iclog, xfs_lsn_t start_lsn);
+
 /*
  * The LSN is valid so long as it is behind the current LSN. If it isn't, this
  * means that the next log record that includes this metadata could have a
-- 
2.28.0

