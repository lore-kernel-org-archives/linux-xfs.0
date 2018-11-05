Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387595AbeKFDbN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Nov 2018 22:31:13 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7977B307DAB1
        for <linux-xfs@vger.kernel.org>; Mon,  5 Nov 2018 18:10:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F63C17CCB
        for <linux-xfs@vger.kernel.org>; Mon,  5 Nov 2018 18:10:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: defer online discard submission to a workqueue
Date: Mon,  5 Nov 2018 13:10:21 -0500
Message-Id: <20181105181021.8174-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When online discard is enabled, discards of busy extents are
submitted asynchronously as a bio chain. bio completion and
resulting busy extent cleanup is deferred to a workqueue. Async
discard submission is intended to avoid blocking log forces on a
full discard sequence which can take a noticeable amount of time in
some cases.

We've had reports of this still producing log force stalls with XFS
on VDO, which executes discards synchronously and relies on online
discard in XFS. In particular, there appears to be a limit on how
many discards can execute at one time. When this limit is hit,
discard submission blocks and affects XFS up through log completion.

There is no need for XFS to ever block in this path as busy extents
are cleared on discard completion. Since we already have a workqueue
for discard bio completion, reuse that workqueue for discard
submission and completely separate online discard processing from
iclog completion processing. With this change, the only path that
should ever block on discard completion is the allocation path if it
determines a need to wait on busy extents.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_cil.c  | 13 ++++++++-----
 fs/xfs/xfs_log_priv.h |  1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d3884e08b43c..087e99e80edd 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -529,9 +529,11 @@ xlog_discard_endio(
 
 static void
 xlog_discard_busy_extents(
-	struct xfs_mount	*mp,
-	struct xfs_cil_ctx	*ctx)
+	struct work_struct	*work)
 {
+	struct xfs_cil_ctx	*ctx = container_of(work, struct xfs_cil_ctx,
+						    discard_work);
+	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
 	struct list_head	*list = &ctx->busy_extents;
 	struct xfs_extent_busy	*busyp;
 	struct bio		*bio = NULL;
@@ -603,9 +605,10 @@ xlog_cil_committed(
 
 	xlog_cil_free_logvec(ctx->lv_chain);
 
-	if (!list_empty(&ctx->busy_extents))
-		xlog_discard_busy_extents(mp, ctx);
-	else
+	if (!list_empty(&ctx->busy_extents)) {
+		INIT_WORK(&ctx->discard_work, xlog_discard_busy_extents);
+		queue_work(xfs_discard_wq, &ctx->discard_work);
+	} else
 		kmem_free(ctx);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b5f82cb36202..085bebd51135 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -245,6 +245,7 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct xfs_log_callback	log_cb;		/* completion callback hook. */
 	struct list_head	committing;	/* ctx committing list */
+	struct work_struct	discard_work;
 	struct work_struct	discard_endio_work;
 };
 
-- 
2.17.2
