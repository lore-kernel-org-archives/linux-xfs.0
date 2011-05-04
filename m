Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44IuYHI088835 for <xfs@oss.sgi.com>; Wed, 4 May 2011 13:56:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BFBE11CD88E
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 12:00:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CwsKOv6RLpKzVd3K for
	<xfs@oss.sgi.com>; Wed, 04 May 2011 12:00:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QHhIx-00025L-Od
	for xfs@oss.sgi.com; Wed, 04 May 2011 19:00:11 +0000
Message-Id: <20110504190011.710110863@bombadil.infradead.org>
Date: Wed, 04 May 2011 14:55:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: make discard operations asynchronous
References: <20110504185513.136746538@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-async-discard-workqueue
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Instead of waiting for each discard request keep the CIL context alive
until all of them are done, at which point we can tear it down completly
and remove the busy extents from the rbtree.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_discard.c	2011-05-03 19:43:13.467745055 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-05-03 19:43:14.514406051 +0200
@@ -30,6 +30,7 @@
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
 #include "xfs_discard.h"
 #include "xfs_trace.h"
 
@@ -192,31 +193,88 @@ xfs_ioc_trim(
 	return 0;
 }
 
-int
-xfs_discard_extents(
-	struct xfs_mount	*mp,
-	struct list_head	*list)
+STATIC void
+xfs_discard_end_io(
+	struct bio		*bio,
+	int			err)
 {
-	struct xfs_busy_extent	*busyp;
-	int			error = 0;
+	struct xfs_cil_ctx	*ctx = bio->bi_private;
 
-	list_for_each_entry(busyp, list, list) {
-		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
-					 busyp->length);
-
-		error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
-				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
-				XFS_FSB_TO_BB(mp, busyp->length),
-				GFP_NOFS, 0);
-		if (error && error != EOPNOTSUPP) {
-			xfs_info(mp,
-	 "discard failed for extent [0x%llu,%u], error %d",
-				 (unsigned long long)busyp->bno,
-				 busyp->length,
-				 error);
-			return error;
+	if (err && err != EOPNOTSUPP) {
+		xfs_info(ctx->cil->xc_log->l_mp,
+			 "discard failed at sector 0x%llu, error %d",
+			 (unsigned long long)bio->bi_sector, err);
+	}
+
+	if (atomic_dec_and_test(&ctx->ref))
+		queue_work(xfs_discard_workqueue, &ctx->work);
+	bio_put(bio);
+}
+
+STATIC int
+xfs_issue_discard(
+	struct xfs_cil_ctx	*ctx,
+	struct xfs_busy_extent	*busyp)
+{
+	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
+	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
+	struct request_queue	*q = bdev_get_queue(bdev);
+	unsigned int		max_discard_sectors;
+	struct bio		*bio;
+	sector_t		sector;
+	sector_t		nr_sects;
+
+	if (!blk_queue_discard(q))
+		return -EOPNOTSUPP;
+
+	trace_xfs_discard_extent(mp, busyp->agno, busyp->bno, busyp->length);
+
+	sector = XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno);
+	nr_sects = XFS_FSB_TO_BB(mp, busyp->length);
+
+	/*
+	 * Ensure that max_discard_sectors is of the proper granularity
+	 */
+	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	if (q->limits.discard_granularity) {
+		unsigned int disc_sects = q->limits.discard_granularity >> 9;
+
+		max_discard_sectors &= ~(disc_sects - 1);
+	}
+
+	while (nr_sects) {
+		bio = bio_alloc(GFP_NOFS, 1);
+		if (!bio)
+			return -ENOMEM;
+
+		bio->bi_sector = sector;
+		bio->bi_end_io = xfs_discard_end_io;
+		bio->bi_bdev = bdev;
+		bio->bi_private = ctx;
+
+		if (nr_sects > max_discard_sectors) {
+			bio->bi_size = max_discard_sectors << 9;
+			nr_sects -= max_discard_sectors;
+			sector += max_discard_sectors;
+		} else {
+			bio->bi_size = nr_sects << 9;
+			nr_sects = 0;
 		}
+
+		atomic_inc(&ctx->ref);
+		submit_bio(REQ_WRITE | REQ_DISCARD, bio);
 	}
 
 	return 0;
 }
+
+int
+xfs_discard_extents(
+	struct xfs_cil_ctx	*ctx)
+{
+	struct xfs_busy_extent	*busyp;
+
+	list_for_each_entry(busyp, &ctx->busy_extents, list)
+		xfs_issue_discard(ctx, busyp);
+	return 0;
+}
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-05-03 19:43:07.164445869 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-05-03 19:43:14.517739367 +0200
@@ -48,6 +48,7 @@ STATIC void xfs_buf_delwri_queue(xfs_buf
 static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
 struct workqueue_struct *xfsconvertd_workqueue;
+struct workqueue_struct *xfs_discard_workqueue;
 
 #ifdef XFS_BUF_LOCK_TRACKING
 # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
@@ -1785,6 +1786,7 @@ xfs_flush_buftarg(
 	LIST_HEAD(wait_list);
 	struct blk_plug plug;
 
+	xfs_buf_runall_queues(xfs_discard_workqueue);
 	xfs_buf_runall_queues(xfsconvertd_workqueue);
 	xfs_buf_runall_queues(xfsdatad_workqueue);
 	xfs_buf_runall_queues(xfslogd_workqueue);
@@ -1848,8 +1850,15 @@ xfs_buf_init(void)
 	if (!xfsconvertd_workqueue)
 		goto out_destroy_xfsdatad_workqueue;
 
+	xfs_discard_workqueue = alloc_workqueue("xfs_discard",
+					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+	if (!xfs_discard_workqueue)
+		goto out_destroy_xfsconvertd_workqueue;
+
 	return 0;
 
+ out_destroy_xfsconvertd_workqueue:
+	destroy_workqueue(xfsconvertd_workqueue);
  out_destroy_xfsdatad_workqueue:
 	destroy_workqueue(xfsdatad_workqueue);
  out_destroy_xfslogd_workqueue:
@@ -1863,6 +1872,7 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
+	destroy_workqueue(xfs_discard_workqueue);
 	destroy_workqueue(xfsconvertd_workqueue);
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2011-05-03 19:43:07.181112445 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2011-05-03 19:43:14.517739367 +0200
@@ -348,4 +348,6 @@ extern struct list_head *xfs_get_buftarg
 #define xfs_binval(buftarg)		xfs_flush_buftarg(buftarg, 1)
 #define XFS_bflush(buftarg)		xfs_flush_buftarg(buftarg, 1)
 
+extern struct workqueue_struct *xfs_discard_workqueue;
+
 #endif	/* __XFS_BUF_H__ */
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-05-03 19:43:13.967742345 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-05-03 19:43:14.517739367 +0200
@@ -1084,6 +1084,7 @@ restart:
 		if (!forced++) {
 			trace_xfs_alloc_near_busy(args);
 			xfs_log_force(args->mp, XFS_LOG_SYNC);
+			flush_workqueue(xfs_discard_workqueue);
 			goto restart;
 		}
 
@@ -1243,8 +1244,10 @@ restart:
 				xfs_btree_del_cursor(cnt_cur,
 						     XFS_BTREE_NOERROR);
 				trace_xfs_alloc_size_busy(args);
-				if (!forced++)
+				if (!forced++) {
 					xfs_log_force(args->mp, XFS_LOG_SYNC);
+					flush_workqueue(xfs_discard_workqueue);
+				}
 				goto restart;
 			}
 		}
@@ -1314,6 +1317,7 @@ restart:
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_size_busy(args);
 			xfs_log_force(args->mp, XFS_LOG_SYNC);
+			flush_workqueue(xfs_discard_workqueue);
 			goto restart;
 		}
 		goto out_nominleft;
@@ -2612,13 +2616,13 @@ xfs_alloc_busy_update_extent(
 	xfs_agblock_t		bend = bbno + busyp->length;
 
 	/*
-	 * This extent is currently beeing discard.  Give the thread
-	 * performing the discard a chance to mark the extent unbusy
-	 * and retry.
+	 * This extent is currently beeing discard.  Flush the discard
+	 * completion queue and retry the search.
 	 */
 	if (busyp->flags & XFS_ALLOC_BUSY_DISCARDED) {
 		spin_unlock(&pag->pagb_lock);
-		delay(1);
+		flush_workqueue(xfs_discard_workqueue);
+		trace_xfs_alloc_busy_discarded(mp, pag->pag_agno, fbno, flen);
 		spin_lock(&pag->pagb_lock);
 		return false;
 	}
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-05-03 19:43:07.194445707 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-05-03 19:43:14.521072682 +0200
@@ -1183,6 +1183,7 @@ DEFINE_BUSY_EVENT(xfs_alloc_busy_enomem)
 DEFINE_BUSY_EVENT(xfs_alloc_busy_force);
 DEFINE_BUSY_EVENT(xfs_alloc_busy_reuse);
 DEFINE_BUSY_EVENT(xfs_alloc_busy_clear);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_discarded);
 
 TRACE_EVENT(xfs_alloc_busy_trim,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
Index: xfs/fs/xfs/linux-2.6/xfs_discard.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_discard.h	2011-05-03 19:43:13.467745055 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_discard.h	2011-05-03 19:43:14.521072682 +0200
@@ -2,9 +2,9 @@
 #define XFS_DISCARD_H 1
 
 struct fstrim_range;
-struct list_head;
+struct xfs_cil_ctx;
 
 extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
-extern int	xfs_discard_extents(struct xfs_mount *, struct list_head *);
+extern int	xfs_discard_extents(struct xfs_cil_ctx *);
 
 #endif /* XFS_DISCARD_H */
Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-05-03 19:43:14.214407676 +0200
+++ xfs/fs/xfs/xfs_log_cil.c	2011-05-03 19:43:14.521072682 +0200
@@ -415,7 +415,7 @@ xlog_cil_committed(
 	if (!list_empty(&ctx->busy_extents)) {
 		ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
 
-		xfs_discard_extents(mp, &ctx->busy_extents);
+		xfs_discard_extents(ctx);
 	}
 
 	if (atomic_dec_and_test(&ctx->ref))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
