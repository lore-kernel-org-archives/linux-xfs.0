Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoLkp153466 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEADA1797873
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:18 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ws2wpJtqtTWe6nHg for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xG-0002wL-5d
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:18 +0000
Message-Id: <20110710205018.136515335@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/11] xfs: remove wrappers around b_iodone
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_BUF_SET_BRELSE_FUNC
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-07-09 09:16:00.995688385 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-07-09 09:34:17.985632833 +0200
@@ -1107,7 +1107,7 @@ xfs_bioerror_relse(
 	XFS_BUF_UNDELAYWRITE(bp);
 	XFS_BUF_DONE(bp);
 	XFS_BUF_STALE(bp);
-	XFS_BUF_CLR_IODONE_FUNC(bp);
+	bp->b_iodone = NULL;
 	if (!(fl & XBF_ASYNC)) {
 		/*
 		 * Mark b_error and B_ERROR _both_.
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-07-09 09:34:13.252299751 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2011-07-09 09:34:17.985632833 +0200
@@ -453,7 +453,7 @@ xfs_buf_item_unpin(
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
 			xfs_buf_do_callbacks(bp);
 			bp->b_fspriv = NULL;
-			XFS_BUF_CLR_IODONE_FUNC(bp);
+			bp->b_iodone = NULL;
 		} else {
 			spin_lock(&ailp->xa_lock);
 			xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
@@ -870,8 +870,8 @@ xfs_buf_item_relse(
 
 	bip = bp->b_fspriv;
 	bp->b_fspriv = bip->bli_item.li_bio_list;
-	if (bp->b_fspriv == NULL && XFS_BUF_IODONE_FUNC(bp) != NULL)
-		XFS_BUF_CLR_IODONE_FUNC(bp);
+	if (bp->b_fspriv == NULL)
+		bp->b_iodone = NULL;
 
 	xfs_buf_rele(bp);
 	xfs_buf_item_free(bip);
@@ -907,9 +907,9 @@ xfs_buf_attach_iodone(
 		bp->b_fspriv = lip;
 	}
 
-	ASSERT((XFS_BUF_IODONE_FUNC(bp) == xfs_buf_iodone_callbacks) ||
-	       (XFS_BUF_IODONE_FUNC(bp) == NULL));
-	XFS_BUF_SET_IODONE_FUNC(bp, xfs_buf_iodone_callbacks);
+	ASSERT(bp->b_iodone == NULL ||
+	       bp->b_iodone == xfs_buf_iodone_callbacks);
+	bp->b_iodone = xfs_buf_iodone_callbacks;
 }
 
 /*
@@ -998,7 +998,7 @@ xfs_buf_iodone_callbacks(
 			XFS_BUF_DONE(bp);
 			XFS_BUF_SET_START(bp);
 		}
-		ASSERT(XFS_BUF_IODONE_FUNC(bp));
+		ASSERT(bp->b_iodone != NULL);
 		trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
 		xfs_buf_relse(bp);
 		return;
@@ -1018,7 +1018,7 @@ xfs_buf_iodone_callbacks(
 do_callbacks:
 	xfs_buf_do_callbacks(bp);
 	bp->b_fspriv = NULL;
-	XFS_BUF_CLR_IODONE_FUNC(bp);
+	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
 
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-07-09 09:34:13.255633083 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-07-09 09:34:17.985632833 +0200
@@ -2471,7 +2471,7 @@ cluster_corrupt_out:
 		 * mark the buffer as an error and call them.  Otherwise
 		 * mark it as stale and brelse.
 		 */
-		if (XFS_BUF_IODONE_FUNC(bp)) {
+		if (bp->b_iodone) {
 			XFS_BUF_UNDONE(bp);
 			XFS_BUF_STALE(bp);
 			XFS_BUF_ERROR(bp,EIO);
@@ -2812,7 +2812,7 @@ xfs_iflush_int(
 		xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
 
 		ASSERT(bp->b_fspriv != NULL);
-		ASSERT(XFS_BUF_IODONE_FUNC(bp) != NULL);
+		ASSERT(bp->b_iodone != NULL);
 	} else {
 		/*
 		 * We're flushing an inode which is not in the AIL and has
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-07-09 09:34:13.258966416 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-07-09 09:34:17.992299515 +0200
@@ -1050,7 +1050,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
 	if (!bp)
 		goto out_free_log;
-	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
+	bp->b_iodone = xlog_iodone;
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(xfs_buf_islocked(bp));
 	log->l_xbuf = bp;
@@ -1084,7 +1084,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		if (!bp)
 			goto out_free_iclog;
 
-		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
+		bp->b_iodone = xlog_iodone;
 		iclog->ic_bp = bp;
 		iclog->ic_data = bp->b_addr;
 #ifdef DEBUG
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-07-09 09:16:01.015688384 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2011-07-09 09:34:17.995632851 +0200
@@ -371,7 +371,7 @@ xlog_recover_iodone(
 		xfs_force_shutdown(bp->b_target->bt_mount,
 					SHUTDOWN_META_IO_ERROR);
 	}
-	XFS_BUF_CLR_IODONE_FUNC(bp);
+	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
 
@@ -2178,7 +2178,7 @@ xlog_recover_buffer_pass2(
 		error = xfs_bwrite(mp, bp);
 	} else {
 		ASSERT(bp->b_target->bt_mount == mp);
-		XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
+		bp->b_iodone = xlog_recover_iodone;
 		xfs_bdwrite(mp, bp);
 	}
 
@@ -2438,7 +2438,7 @@ xlog_recover_inode_pass2(
 
 write_inode_buffer:
 	ASSERT(bp->b_target->bt_mount == mp);
-	XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
+	bp->b_iodone = xlog_recover_iodone;
 	xfs_bdwrite(mp, bp);
 error:
 	if (need_free)
@@ -2560,7 +2560,7 @@ xlog_recover_dquot_pass2(
 
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_target->bt_mount == mp);
-	XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
+	bp->b_iodone = xlog_recover_iodone;
 	xfs_bdwrite(mp, bp);
 
 	return (0);
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-07-09 09:34:13.258966416 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-07-09 09:34:17.995632851 +0200
@@ -635,8 +635,8 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT((first <= last) && (last < XFS_BUF_COUNT(bp)));
-	ASSERT((XFS_BUF_IODONE_FUNC(bp) == NULL) ||
-	       (XFS_BUF_IODONE_FUNC(bp) == xfs_buf_iodone_callbacks));
+	ASSERT(bp->b_iodone == NULL ||
+	       bp->b_iodone == xfs_buf_iodone_callbacks);
 
 	/*
 	 * Mark the buffer as needing to be written out eventually,
@@ -652,7 +652,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	XFS_BUF_DONE(bp);
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
-	XFS_BUF_SET_IODONE_FUNC(bp, xfs_buf_iodone_callbacks);
+	bp->b_iodone = xfs_buf_iodone_callbacks;
 	bip->bli_item.li_cb = xfs_buf_iodone;
 
 	trace_xfs_trans_log_buf(bip);
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2011-07-09 09:34:13.248966419 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2011-07-09 09:34:17.995632851 +0200
@@ -276,10 +276,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
 #define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
 
-#define XFS_BUF_IODONE_FUNC(bp)			((bp)->b_iodone)
-#define XFS_BUF_SET_IODONE_FUNC(bp, func)	((bp)->b_iodone = (func))
-#define XFS_BUF_CLR_IODONE_FUNC(bp)		((bp)->b_iodone = NULL)
-
 #define XFS_BUF_SET_START(bp)			do { } while (0)
 
 #define XFS_BUF_PTR(bp)			(xfs_caddr_t)((bp)->b_addr)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
