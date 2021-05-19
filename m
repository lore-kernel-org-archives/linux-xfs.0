Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CC2C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4F046109F
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243321AbhESMOp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:45 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:42927 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245046AbhESMOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:42 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 841FD114098C
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002m0O-H6
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002SGX-9U
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/39] xfs: separate CIL commit record IO
Date:   Wed, 19 May 2021 22:12:40 +1000
Message-Id: <20210519121317.585244-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=6GbAA9ItjH-Z6eHFJ-YA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To allow for iclog IO device cache flush behaviour to be optimised,
we first need to separate out the commit record iclog IO from the
rest of the checkpoint so we can wait for the checkpoint IO to
complete before we issue the commit record.

This separation is only necessary if the commit record is being
written into a different iclog to the start of the checkpoint as the
upcoming cache flushing changes requires completion ordering against
the other iclogs submitted by the checkpoint.

If the entire checkpoint and commit is in the one iclog, then they
are both covered by the one set of cache flush primitives on the
iclog and hence there is no need to separate them for ordering.

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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c      | 8 +++++---
 fs/xfs/xfs_log_cil.c  | 9 +++++++++
 fs/xfs/xfs_log_priv.h | 2 ++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0e563ff8cd3b..4cd5840e953a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -786,10 +786,12 @@ xfs_log_mount_cancel(
 }
 
 /*
- * Wait for the iclog to be written disk, or return an error if the log has been
- * shut down.
+ * Wait for the iclog and all prior iclogs to be written disk as required by the
+ * log force state machine. Waiting on ic_force_wait ensures iclog completions
+ * have been ordered and callbacks run before we are woken here, hence
+ * guaranteeing that all the iclogs up to this one are on stable storage.
  */
-static int
+int
 xlog_wait_on_iclog(
 	struct xlog_in_core	*iclog)
 		__releases(iclog->ic_log->l_icloglock)
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b0ef071b3cb5..1e5fd6f268c2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -870,6 +870,15 @@ xlog_cil_push_work(
 	wake_up_all(&cil->xc_commit_wait);
 	spin_unlock(&cil->xc_push_lock);
 
+	/*
+	 * If the checkpoint spans multiple iclogs, wait for all previous
+	 * iclogs to complete before we submit the commit_iclog.
+	 */
+	if (ctx->start_lsn != commit_lsn) {
+		spin_lock(&log->l_icloglock);
+		xlog_wait_on_iclog(commit_iclog->ic_prev);
+	}
+
 	/* release the hounds! */
 	xfs_log_release_iclog(commit_iclog);
 	return;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 037950cf1061..ee7786b33da9 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -584,6 +584,8 @@ xlog_wait(
 	remove_wait_queue(wq, &wait);
 }
 
+int xlog_wait_on_iclog(struct xlog_in_core *iclog);
+
 /*
  * The LSN is valid so long as it is behind the current LSN. If it isn't, this
  * means that the next log record that includes this metadata could have a
-- 
2.31.1

