Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A12C4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23B8360EC0
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236849AbhHJFX1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:23:27 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:58614 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237337AbhHJFXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:23:25 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id CBE7784BCF
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:23:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDKE7-00GZdO-R7
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:22:59 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDKE7-000AlN-JU
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:22:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: move the CIL workqueue to the CIL
Date:   Tue, 10 Aug 2021 15:22:57 +1000
Message-Id: <20210810052257.41308-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810052257.41308-1-david@fromorbit.com>
References: <20210810052257.41308-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=DQkj07otzc7_PMFSBPwA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We only use the CIL workqueue in the CIL, so it makes no sense to
hang it off the xfs_mount and have to walk multiple pointers back up
to the mount when we have the CIL structures right there.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c  | 20 +++++++++++++++++---
 fs/xfs/xfs_log_priv.h |  1 +
 fs/xfs/xfs_mount.h    |  1 -
 fs/xfs/xfs_super.c    | 15 +--------------
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 17785f4d50f7..ccd621ea9412 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1151,7 +1151,7 @@ xlog_cil_push_background(
 	spin_lock(&cil->xc_push_lock);
 	if (cil->xc_push_seq < cil->xc_current_sequence) {
 		cil->xc_push_seq = cil->xc_current_sequence;
-		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_ctx->push_work);
+		queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
 	}
 
 	/*
@@ -1217,7 +1217,7 @@ xlog_cil_push_now(
 
 	/* start on any pending background push to minimise wait time on it */
 	if (!async)
-		flush_workqueue(log->l_mp->m_cil_workqueue);
+		flush_workqueue(cil->xc_push_wq);
 
 	/*
 	 * If the CIL is empty or we've already pushed the sequence then
@@ -1231,7 +1231,7 @@ xlog_cil_push_now(
 
 	cil->xc_push_seq = push_seq;
 	cil->xc_push_commit_stable = async;
-	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_ctx->push_work);
+	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
 	spin_unlock(&cil->xc_push_lock);
 }
 
@@ -1470,6 +1470,15 @@ xlog_cil_init(
 	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
 	if (!cil)
 		return -ENOMEM;
+	/*
+	 * Limit the CIL pipeline depth to 4 concurrent works to bound the
+	 * concurrency the log spinlocks will be exposed to.
+	 */
+	cil->xc_push_wq = alloc_workqueue("xfs-cil/%s",
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
+			4, log->l_mp->m_super->s_id);
+	if (!cil->xc_push_wq)
+		goto out_destroy_cil;
 
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
@@ -1486,6 +1495,10 @@ xlog_cil_init(
 	xlog_cil_ctx_switch(cil, ctx);
 
 	return 0;
+
+out_destroy_cil:
+	kmem_free(cil);
+	return -ENOMEM;
 }
 
 void
@@ -1499,6 +1512,7 @@ xlog_cil_destroy(
 	}
 
 	ASSERT(list_empty(&log->l_cilp->xc_cil));
+	destroy_workqueue(log->l_cilp->xc_push_wq);
 	kmem_free(log->l_cilp);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 5aaaf5f0b35c..844fbeec3545 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -272,6 +272,7 @@ struct xfs_cil {
 	struct xlog		*xc_log;
 	struct list_head	xc_cil;
 	spinlock_t		xc_cil_lock;
+	struct workqueue_struct	*xc_push_wq;
 
 	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
 	struct xfs_cil_ctx	*xc_ctx;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 32143102cc91..2266c6a668cf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -107,7 +107,6 @@ typedef struct xfs_mount {
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
-	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
 	struct workqueue_struct *m_blockgc_wq;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6d42883b8fae..7b55464f6de0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -518,21 +518,11 @@ xfs_init_mount_workqueues(
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_buf;
 
-	/*
-	 * Limit the CIL pipeline depth to 4 concurrent works to bound the
-	 * concurrency the log spinlocks will be exposed to.
-	 */
-	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
-			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
-			4, mp->m_super->s_id);
-	if (!mp->m_cil_workqueue)
-		goto out_destroy_unwritten;
-
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
 			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
 			0, mp->m_super->s_id);
 	if (!mp->m_reclaim_workqueue)
-		goto out_destroy_cil;
+		goto out_destroy_unwritten;
 
 	mp->m_blockgc_wq = alloc_workqueue("xfs-blockgc/%s",
 			XFS_WQFLAGS(WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM),
@@ -559,8 +549,6 @@ xfs_init_mount_workqueues(
 	destroy_workqueue(mp->m_blockgc_wq);
 out_destroy_reclaim:
 	destroy_workqueue(mp->m_reclaim_workqueue);
-out_destroy_cil:
-	destroy_workqueue(mp->m_cil_workqueue);
 out_destroy_unwritten:
 	destroy_workqueue(mp->m_unwritten_workqueue);
 out_destroy_buf:
@@ -577,7 +565,6 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_blockgc_wq);
 	destroy_workqueue(mp->m_inodegc_wq);
 	destroy_workqueue(mp->m_reclaim_workqueue);
-	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
 	destroy_workqueue(mp->m_buf_workqueue);
 }
-- 
2.31.1

