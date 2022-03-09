Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93DAC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 01:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiCIB4R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiCIB4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Mar 2022 20:56:16 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4273141FAB
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 17:55:18 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 17873531107
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 12:55:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRlXn-003DPS-7j
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 12:55:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRlXn-00B72F-6w
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 12:55:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: async CIL flushes need pending pushes to be made stable
Date:   Wed,  9 Mar 2022 12:55:12 +1100
Message-Id: <20220309015512.2648074-5-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309015512.2648074-1-david@fromorbit.com>
References: <20220309015512.2648074-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62280904
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8
        a=yk_eRm6W7gORI4apyj4A:9 a=1CNFftbPRP8L7MoqJWF3:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When the AIL tries to flush the CIL, it relies on the CIL push
ending up on stable storage without having to wait for and
manipulate iclog state directly. However, if there is already a
pending CIL push when the AIL tries to flush the CIL, it won't set
the cil->xc_push_commit_stable flag and so the CIL push will not
actively flush the commit record iclog.

generic/530 when run on a single CPU test VM can trigger this fairly
reliably. This test exercises unlinked inode recovery, and can
result in inodes being pinned in memory by ongoing modifications to
the inode cluster buffer to record unlinked list modifications. As a
result, the first inode unlinked in a buffer can pin the tail of the
log whilst the inode cluster buffer is pinned by the current
checkpoint that has been pushed but isn't on stable storage because
because the cil->xc_push_commit_stable was not set. This results in
the log/AIL effectively deadlocking until something triggers the
commit record iclog to be pushed to stable storage (i.e. the
periodic log worker calling xfs_log_force()).

The fix is two-fold - first we should always set the
cil->xc_push_commit_stable when xlog_cil_flush() is called,
regardless of whether there is already a pending push or not.

Second, if the CIL is empty, we should trigger an iclog flush to
ensure that the iclogs of the last checkpoint have actually been
submitted to disk as that checkpoint may not have been run under
stable completion constraints.

Reported-and-tested-by: Matthew Wilcox <willy@infradead.org>
Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 83a039762b81..25a86e35b4fe 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1243,18 +1243,27 @@ xlog_cil_push_now(
 	if (!async)
 		flush_workqueue(cil->xc_push_wq);
 
+	spin_lock(&cil->xc_push_lock);
+
+	/*
+	 * If this is an async flush request, we always need to set the
+	 * xc_push_commit_stable flag even if something else has already queued
+	 * a push. The flush caller is asking for the CIL to be on stable
+	 * storage when the next push completes, so regardless of who has queued
+	 * the push, the flush requires stable semantics from it.
+	 */
+	cil->xc_push_commit_stable = async;
+
 	/*
 	 * If the CIL is empty or we've already pushed the sequence then
-	 * there's no work we need to do.
+	 * there's no more work that we need to do.
 	 */
-	spin_lock(&cil->xc_push_lock);
 	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
 		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
 
 	cil->xc_push_seq = push_seq;
-	cil->xc_push_commit_stable = async;
 	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
 	spin_unlock(&cil->xc_push_lock);
 }
@@ -1352,6 +1361,13 @@ xlog_cil_flush(
 
 	trace_xfs_log_force(log->l_mp, seq, _RET_IP_);
 	xlog_cil_push_now(log, seq, true);
+
+	/*
+	 * If the CIL is empty, make sure that any previous checkpoint that may
+	 * still be in an active iclog is pushed to stable storage.
+	 */
+	if (list_empty(&log->l_cilp->xc_cil))
+		xfs_log_force(log->l_mp, 0);
 }
 
 /*
-- 
2.33.0

