Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41539 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758951AbcJQUWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 16:22:42 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: don't block the log commit handler for discards
Date: Mon, 17 Oct 2016 22:22:32 +0200
Message-Id: <1476735753-5861-3-git-send-email-hch@lst.de>
In-Reply-To: <1476735753-5861-1-git-send-email-hch@lst.de>
References: <1476735753-5861-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: michaelcallahan@fb.com

Instead we submit the discard requests and use another workqueue to
release the extents from the extent busy list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 11 ++++++-
 fs/xfs/xfs_discard.c     | 29 -----------------
 fs/xfs/xfs_discard.h     |  1 -
 fs/xfs/xfs_log_cil.c     | 84 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_log_priv.h    |  1 +
 fs/xfs/xfs_mount.c       |  1 +
 fs/xfs/xfs_super.c       |  8 +++++
 fs/xfs/xfs_super.h       |  2 ++
 8 files changed, 98 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c27344c..cbea3b2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3684,10 +3684,12 @@ xfs_bmap_btalloc(
 	int		tryagain;
 	int		error;
 	int		stripe_align;
+	bool		trydiscard;
 
 	ASSERT(ap->length);
 
 	mp = ap->ip->i_mount;
+	trydiscard = (mp->m_flags & XFS_MOUNT_DISCARD);
 
 	/* stripe alignment for allocation is determined by mount parameters */
 	stripe_align = 0;
@@ -3708,7 +3710,7 @@ xfs_bmap_btalloc(
 		ASSERT(ap->length);
 	}
 
-
+retry:
 	nullfb = *ap->firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
 	if (nullfb) {
@@ -3888,6 +3890,13 @@ xfs_bmap_btalloc(
 			return error;
 		ap->dfops->dop_low = true;
 	}
+
+	if (args.fsbno == NULLFSBLOCK && trydiscard) {
+		trydiscard = false;
+		flush_workqueue(xfs_discard_wq);
+		goto retry;
+	}
+
 	if (args.fsbno != NULLFSBLOCK) {
 		/*
 		 * check the allocation happened at the same or higher AG than
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 4ff499a..d796ffa 100644
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
index 344879a..0f070f9 100644
--- a/fs/xfs/xfs_discard.h
+++ b/fs/xfs/xfs_discard.h
@@ -5,6 +5,5 @@ struct fstrim_range;
 struct list_head;
 
 extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
-extern int	xfs_discard_extents(struct xfs_mount *, struct list_head *);
 
 #endif /* XFS_DISCARD_H */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index a4ab192..82f1cbc 100644
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
index 2b6eec5..c2604a5 100644
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
index fc78739..2ec411c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1052,6 +1052,7 @@ xfs_unmountfs(
 	cancel_delayed_work_sync(&mp->m_cowblocks_work);
 
 	xfs_fs_unreserve_ag_blocks(mp);
+	flush_workqueue(xfs_discard_wq);
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
 	IRELE(mp->m_rootip);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 56ad5f3..1900233 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1950,12 +1950,20 @@ xfs_init_workqueues(void)
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
index b6418ab..5f2f324 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -73,6 +73,8 @@ extern const struct quotactl_ops xfs_quotactl_operations;
 
 extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
 
+extern struct workqueue_struct *xfs_discard_wq;
+
 #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
 
 #endif	/* __XFS_SUPER_H__ */
-- 
2.1.4

