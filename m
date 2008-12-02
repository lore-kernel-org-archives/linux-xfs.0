Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G6qLc031621 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:06:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41E84164F1BF
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:06:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dHWBv2Q59089jHMG for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:06:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xlz-0007Vh-QO
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:51 +0000
Message-Id: <20081202160651.749289000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 15/22] replace b_fspriv with b_mount
Content-Disposition: inline; filename=xfs-add-bp_mount-field
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Replace the b_fspriv pointer and it's ugly accessors with a properly types
xfs_mount pointer.  Also switch log reocvery over to it instead of using
b_fspriv for the mount pointer.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-11-15 15:27:32.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2008-11-15 15:28:01.000000000 +0100
@@ -1085,7 +1085,7 @@ xfs_bawrite(
 	bp->b_flags &= ~(XBF_READ | XBF_DELWRI | XBF_READ_AHEAD);
 	bp->b_flags |= (XBF_WRITE | XBF_ASYNC | _XBF_RUN_QUEUES);
 
-	bp->b_fspriv3 = mp;
+	bp->b_mount = mp;
 	bp->b_strat = xfs_bdstrat_cb;
 	return xfs_bdstrat_cb(bp);
 }
@@ -1098,7 +1098,7 @@ xfs_bdwrite(
 	XB_TRACE(bp, "bdwrite", 0);
 
 	bp->b_strat = xfs_bdstrat_cb;
-	bp->b_fspriv3 = mp;
+	bp->b_mount = mp;
 
 	bp->b_flags &= ~XBF_READ;
 	bp->b_flags |= (XBF_DELWRI | XBF_ASYNC);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-11-15 15:28:08.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h	2008-11-15 15:29:12.000000000 +0100
@@ -168,7 +168,7 @@ typedef struct xfs_buf {
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_fspriv;
 	void			*b_fspriv2;
-	void			*b_fspriv3;
+	struct xfs_mount	*b_mount;
 	unsigned short		b_error;	/* error code on I/O */
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
@@ -335,8 +335,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_SET_FSPRIVATE(bp, val)		((bp)->b_fspriv = (void*)(val))
 #define XFS_BUF_FSPRIVATE2(bp, type)		((type)(bp)->b_fspriv2)
 #define XFS_BUF_SET_FSPRIVATE2(bp, val)		((bp)->b_fspriv2 = (void*)(val))
-#define XFS_BUF_FSPRIVATE3(bp, type)		((type)(bp)->b_fspriv3)
-#define XFS_BUF_SET_FSPRIVATE3(bp, val)		((bp)->b_fspriv3 = (void*)(val))
 #define XFS_BUF_SET_START(bp)			do { } while (0)
 #define XFS_BUF_SET_BRELSE_FUNC(bp, func)	((bp)->b_relse = (func))
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-11-15 15:25:29.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-11-15 15:26:27.000000000 +0100
@@ -847,13 +847,7 @@ retry:
 int
 xfs_bdstrat_cb(struct xfs_buf *bp)
 {
-	xfs_mount_t	*mp;
-
-	mp = XFS_BUF_FSPRIVATE3(bp, xfs_mount_t *);
-	if (!XFS_FORCED_SHUTDOWN(mp)) {
-		xfs_buf_iorequest(bp);
-		return 0;
-	} else {
+	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
 		xfs_buftrace("XFS__BDSTRAT IOERROR", bp);
 		/*
 		 * Metadata write that didn't get logged but
@@ -866,6 +860,9 @@ xfs_bdstrat_cb(struct xfs_buf *bp)
 		else
 			return (xfs_bioerror(bp));
 	}
+
+	xfs_buf_iorequest(bp);
+	return 0;
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_buf_item.c	2008-11-15 15:24:38.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_buf_item.c	2008-11-15 15:25:05.000000000 +0100
@@ -707,8 +707,8 @@ xfs_buf_item_init(
 	 * the first.  If we do already have one, there is
 	 * nothing to do here so return.
 	 */
-	if (XFS_BUF_FSPRIVATE3(bp, xfs_mount_t *) != mp)
-		XFS_BUF_SET_FSPRIVATE3(bp, mp);
+	if (bp->b_mount != mp)
+		bp->b_mount = mp;
 	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
 	if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
 		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
Index: linux-2.6-xfs/fs/xfs/xfs_rw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rw.c	2008-11-15 15:26:37.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_rw.c	2008-11-15 15:27:17.000000000 +0100
@@ -406,7 +406,7 @@ xfs_bwrite(
 	 * XXXsup how does this work for quotas.
 	 */
 	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
-	XFS_BUF_SET_FSPRIVATE3(bp, mp);
+	bp->b_mount = mp;
 	XFS_BUF_WRITE(bp);
 
 	if ((error = XFS_bwrite(bp))) {
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-11-15 15:31:41.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-11-15 15:35:12.000000000 +0100
@@ -267,21 +267,16 @@ STATIC void
 xlog_recover_iodone(
 	struct xfs_buf	*bp)
 {
-	xfs_mount_t	*mp;
-
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *));
-
 	if (XFS_BUF_GETERROR(bp)) {
 		/*
 		 * We're not going to bother about retrying
 		 * this during recovery. One strike!
 		 */
-		mp = XFS_BUF_FSPRIVATE(bp, xfs_mount_t *);
 		xfs_ioerror_alert("xlog_recover_iodone",
-				  mp, bp, XFS_BUF_ADDR(bp));
-		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+				  bp->b_mount, bp, XFS_BUF_ADDR(bp));
+		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 	}
-	XFS_BUF_SET_FSPRIVATE(bp, NULL);
+	bp->b_mount = NULL;
 	XFS_BUF_CLR_IODONE_FUNC(bp);
 	xfs_biodone(bp);
 }
@@ -2225,9 +2220,8 @@ xlog_recover_do_buffer_trans(
 		XFS_BUF_STALE(bp);
 		error = xfs_bwrite(mp, bp);
 	} else {
-		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) == NULL ||
-		       XFS_BUF_FSPRIVATE(bp, xfs_mount_t *) == mp);
-		XFS_BUF_SET_FSPRIVATE(bp, mp);
+		ASSERT(bp->b_mount == NULL || bp->b_mount == mp);
+		bp->b_mount = mp;
 		XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
 		xfs_bdwrite(mp, bp);
 	}
@@ -2490,9 +2484,8 @@ xlog_recover_do_inode_trans(
 
 write_inode_buffer:
 	if (ITEM_TYPE(item) == XFS_LI_INODE) {
-		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) == NULL ||
-		       XFS_BUF_FSPRIVATE(bp, xfs_mount_t *) == mp);
-		XFS_BUF_SET_FSPRIVATE(bp, mp);
+		ASSERT(bp->b_mount == NULL || bp->b_mount == mp);
+		bp->b_mount = mp;
 		XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
 		xfs_bdwrite(mp, bp);
 	} else {
@@ -2623,9 +2616,8 @@ xlog_recover_do_dquot_trans(
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
 
 	ASSERT(dq_f->qlf_size == 2);
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) == NULL ||
-	       XFS_BUF_FSPRIVATE(bp, xfs_mount_t *) == mp);
-	XFS_BUF_SET_FSPRIVATE(bp, mp);
+	ASSERT(bp->b_mount == NULL || bp->b_mount == mp);
+	bp->b_mount = mp;
 	XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
 	xfs_bdwrite(mp, bp);
 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
