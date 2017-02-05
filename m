Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdBERL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Feb 2017 12:11:58 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1caQM1-0003Ep-Au
        for linux-xfs@vger.kernel.org; Sun, 05 Feb 2017 17:11:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] xfs: don't block the log commit handler for discards
Date: Sun,  5 Feb 2017 18:11:41 +0100
Message-Id: <20170205171141.6066-5-hch@lst.de>
In-Reply-To: <20170205171141.6066-1-hch@lst.de>
References: <20170205171141.6066-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Instead we submit the discard requests and use another workqueue to
release the extents from the extent busy list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c  | 29 ------------------
 fs/xfs/xfs_discard.h  |  1 -
 fs/xfs/xfs_log_cil.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_log_priv.h |  1 +
 fs/xfs/xfs_mount.c    |  1 +
 fs/xfs/xfs_super.c    |  8 +++++
 fs/xfs/xfs_super.h    |  2 ++
 7 files changed, 88 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 4ff499aa7338..d796ffac7296 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -208,32 +208,3 @@ xfs_ioc_trim(
 		return -EFAULT;
 	return 0;
 }
-
-int
-xfs_discard_extents(
-	struct xfs_mount	*mp,
-	struct list_head	*list)
-{
-	struct xfs_extent_busy	*busyp;
-	int			error = 0;
-
-	list_for_each_entry(busyp, list, list) {
-		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
-					 busyp->length);
-
-		error = blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
-				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
-				XFS_FSB_TO_BB(mp, busyp->length),
-				GFP_NOFS, 0);
-		if (error && error != -EOPNOTSUPP) {
-			xfs_info(mp,
-	 "discard failed for extent [0x%llx,%u], error %d",
-				 (unsigned long long)busyp->bno,
-				 busyp->length,
-				 error);
-			return error;
-		}
-	}
-
-	return 0;
-}
diff --git a/fs/xfs/xfs_discard.h b/fs/xfs/xfs_discard.h
index 344879aea646..0f070f9e44e1 100644
--- a/fs/xfs/xfs_discard.h
+++ b/fs/xfs/xfs_discard.h
@@ -5,6 +5,5 @@ struct fstrim_range;
 struct list_head;
 
 extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
-extern int	xfs_discard_extents(struct xfs_mount *, struct list_head *);
 
 #endif /* XFS_DISCARD_H */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index a4ab192e1792..82f1cbcc4de1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -30,6 +30,9 @@
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
+#include "xfs_trace.h"
+
+struct workqueue_struct *xfs_discard_wq;
 
 /*
  * Allocate a new ticket. Failing to get a new ticket makes it really hard to
@@ -491,6 +494,75 @@ xlog_cil_free_logvec(
 	}
 }
 
+static void
+xlog_discard_endio_work(
+	struct work_struct	*work)
+{
+	struct xfs_cil_ctx	*ctx =
+		container_of(work, struct xfs_cil_ctx, discard_endio_work);
+	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
+
+	xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
+	kmem_free(ctx);
+}
+
+/*
+ * Queue up the actual completion to a thread to avoid IRQ-safe locking for
+ * pagb_lock.  Note that we need a unbounded workqueue, otherwise we might
+ * get the execution delayed up to 30 seconds for weird reasons.
+ */
+static void
+xlog_discard_endio(
+	struct bio		*bio)
+{
+	struct xfs_cil_ctx	*ctx = bio->bi_private;
+
+	INIT_WORK(&ctx->discard_endio_work, xlog_discard_endio_work);
+	queue_work(xfs_discard_wq, &ctx->discard_endio_work);
+}
+
+static void
+xlog_discard_busy_extents(
+	struct xfs_mount	*mp,
+	struct xfs_cil_ctx	*ctx)
+{
+	struct list_head	*list = &ctx->busy_extents;
+	struct xfs_extent_busy	*busyp;
+	struct bio		*bio = NULL;
+	struct blk_plug		plug;
+	int			error = 0;
+
+	ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
+
+	blk_start_plug(&plug);
+	list_for_each_entry(busyp, list, list) {
+		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
+					 busyp->length);
+
+		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
+				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
+				XFS_FSB_TO_BB(mp, busyp->length),
+				GFP_NOFS, 0, &bio);
+		if (error && error != -EOPNOTSUPP) {
+			xfs_info(mp,
+	 "discard failed for extent [0x%llx,%u], error %d",
+				 (unsigned long long)busyp->bno,
+				 busyp->length,
+				 error);
+			break;
+		}
+	}
+
+	if (bio) {
+		bio->bi_private = ctx;
+		bio->bi_end_io = xlog_discard_endio;
+		submit_bio(bio);
+	} else {
+		xlog_discard_endio_work(&ctx->discard_endio_work);
+	}
+	blk_finish_plug(&plug);
+}
+
 /*
  * Mark all items committed and clear busy extents. We free the log vector
  * chains in a separate pass so that we unpin the log items as quickly as
@@ -525,14 +597,10 @@ xlog_cil_committed(
 
 	xlog_cil_free_logvec(ctx->lv_chain);
 
-	if (!list_empty(&ctx->busy_extents)) {
-		ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
-
-		xfs_discard_extents(mp, &ctx->busy_extents);
-		xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
-	}
-
-	kmem_free(ctx);
+	if (!list_empty(&ctx->busy_extents))
+		xlog_discard_busy_extents(mp, ctx);
+	else
+		kmem_free(ctx);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 2b6eec52178e..c2604a5366f2 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -257,6 +257,7 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct xfs_log_callback	log_cb;		/* completion callback hook. */
 	struct list_head	committing;	/* ctx committing list */
+	struct work_struct	discard_endio_work;
 };
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4e9feb1dc15d..16dcd8cc9de4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1072,6 +1072,7 @@ xfs_unmountfs(
 	 * need to force the log first.
 	 */
 	xfs_log_force(mp, XFS_LOG_SYNC);
+	flush_workqueue(xfs_discard_wq);
 
 	/*
 	 * We now need to tell the world we are unmounting. This will allow
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d894ed027e30..ca05fb05b3ba 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1957,12 +1957,20 @@ xfs_init_workqueues(void)
 	if (!xfs_alloc_wq)
 		return -ENOMEM;
 
+	xfs_discard_wq = alloc_workqueue("xfsdiscard", WQ_UNBOUND, 0);
+	if (!xfs_discard_wq)
+		goto out_free_alloc_wq;
+
 	return 0;
+out_free_alloc_wq:
+	destroy_workqueue(xfs_alloc_wq);
+	return -ENOMEM;
 }
 
 STATIC void
 xfs_destroy_workqueues(void)
 {
+	destroy_workqueue(xfs_discard_wq);
 	destroy_workqueue(xfs_alloc_wq);
 }
 
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index b6418abd85ad..5f2f32408011 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -73,6 +73,8 @@ extern const struct quotactl_ops xfs_quotactl_operations;
 
 extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
 
+extern struct workqueue_struct *xfs_discard_wq;
+
 #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
 
 #endif	/* __XFS_SUPER_H__ */
-- 
2.11.0

