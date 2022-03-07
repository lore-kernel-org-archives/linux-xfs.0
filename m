Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64472C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 23:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbiCGXTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiCGXTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 18:19:55 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1449F31368
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 15:19:00 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 15BB610E1CAD;
        Tue,  8 Mar 2022 10:18:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRMcz-002mA7-UQ; Tue, 08 Mar 2022 10:18:58 +1100
Date:   Tue, 8 Mar 2022 10:18:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     willy@infradead.org
Subject: [PATCH 4/3] xfs: async CIL flushes need pending pushes to be made
 stable
Message-ID: <20220307231857.GR59715@dread.disaster.area>
References: <20220307053252.2534616-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307053252.2534616-1-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=622692e3
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8
        a=Icm_k0NaIDjJNltb-DgA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
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

The fix is simple - always set the cil->xc_push_commit_stable when
xlog_cil_flush() is called, regardless of whether there is already a
pending push or not.

Reported-by: Matthew Wilcox <willy@infradead.org>
Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 05cee602406c..9785ac0351fe 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1490,11 +1490,21 @@ xlog_cil_push_now(
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
 	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) ||
 	    push_seq <= cil->xc_push_seq) {
 		spin_unlock(&cil->xc_push_lock);
@@ -1502,7 +1512,6 @@ xlog_cil_push_now(
 	}
 
 	cil->xc_push_seq = push_seq;
-	cil->xc_push_commit_stable = async;
 	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
 	spin_unlock(&cil->xc_push_lock);
 }
