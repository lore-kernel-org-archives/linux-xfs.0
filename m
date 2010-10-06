Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96IeN4T110178 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:40:24 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 932174EB25E
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:41:27 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id Kdfle4c8R206ieCn for
	<xfs@oss.sgi.com>; Wed, 06 Oct 2010 11:41:27 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P3Yvf-0001BH-2U
	for xfs@oss.sgi.com; Wed, 06 Oct 2010 18:41:27 +0000
Message-Id: <20101006184126.919946101@localhost.localdomain>
Date: Wed, 06 Oct 2010 14:41:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/7] xfs: remove xfs_buf wrappers
References: <20101006184111.634126439@localhost.localdomain>
Content-Disposition: inline; filename=xfs-cleanup-buf-wrappers
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

Stop having two different names for many buffer functions and use the
more descriptive xfs_buf_* names directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-09-30 15:57:16.172782662 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-09-30 15:58:19.493782839 +0200
@@ -652,8 +652,7 @@ void
 xfs_buf_readahead(
 	xfs_buftarg_t		*target,
 	xfs_off_t		ioff,
-	size_t			isize,
-	xfs_buf_flags_t		flags)
+	size_t			isize)
 {
 	struct backing_dev_info *bdi;
 
@@ -661,8 +660,8 @@ xfs_buf_readahead(
 	if (bdi_read_congested(bdi))
 		return;
 
-	flags |= (XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD);
-	xfs_buf_read(target, ioff, isize, flags);
+	xfs_buf_read(target, ioff, isize,
+		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD|XBF_DONT_BLOCK);
 }
 
 /*
@@ -691,7 +690,7 @@ xfs_buf_read_uncached(
 	XFS_BUF_BUSY(bp);
 
 	xfsbdstrat(mp, bp);
-	error = xfs_iowait(bp);
+	error = xfs_buf_iowait(bp);
 	if (error || bp->b_error) {
 		xfs_buf_relse(bp);
 		return NULL;
@@ -1073,7 +1072,7 @@ xfs_bdwrite(
 
 /*
  * Called when we want to stop a buffer from getting written or read.
- * We attach the EIO error, muck with its flags, and call biodone
+ * We attach the EIO error, muck with its flags, and call xfs_buf_ioend
  * so that the proper iodone callbacks get called.
  */
 STATIC int
@@ -1090,21 +1089,21 @@ xfs_bioerror(
 	XFS_BUF_ERROR(bp, EIO);
 
 	/*
-	 * We're calling biodone, so delete XBF_DONE flag.
+	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
 	 */
 	XFS_BUF_UNREAD(bp);
 	XFS_BUF_UNDELAYWRITE(bp);
 	XFS_BUF_UNDONE(bp);
 	XFS_BUF_STALE(bp);
 
-	xfs_biodone(bp);
+	xfs_buf_ioend(bp, 0);
 
 	return EIO;
 }
 
 /*
  * Same as xfs_bioerror, except that we are releasing the buffer
- * here ourselves, and avoiding the biodone call.
+ * here ourselves, and avoiding the xfs_buf_ioend call.
  * This is meant for userdata errors; metadata bufs come with
  * iodone functions attached, so that we can track down errors.
  */
@@ -1938,7 +1937,7 @@ xfs_flush_buftarg(
 			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 
 			list_del_init(&bp->b_list);
-			xfs_iowait(bp);
+			xfs_buf_iowait(bp);
 			xfs_buf_relse(bp);
 		}
 	}
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2010-09-30 15:57:16.182782662 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2010-09-30 15:58:24.150782643 +0200
@@ -218,8 +218,7 @@ extern xfs_buf_t *xfs_buf_get_empty(size
 extern xfs_buf_t *xfs_buf_get_uncached(struct xfs_buftarg *, size_t, int);
 extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
 extern void xfs_buf_hold(xfs_buf_t *);
-extern void xfs_buf_readahead(xfs_buftarg_t *, xfs_off_t, size_t,
-				xfs_buf_flags_t);
+extern void xfs_buf_readahead(xfs_buftarg_t *, xfs_off_t, size_t);
 struct xfs_buf *xfs_buf_read_uncached(struct xfs_mount *mp,
 				struct xfs_buftarg *target,
 				xfs_daddr_t daddr, size_t length, int flags);
@@ -247,6 +246,8 @@ extern int xfs_buf_iorequest(xfs_buf_t *
 extern int xfs_buf_iowait(xfs_buf_t *);
 extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
 				xfs_buf_rw_t);
+#define xfs_buf_zero(bp, off, len) \
+	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
 
 static inline int xfs_buf_geterror(xfs_buf_t *bp)
 {
@@ -359,21 +360,6 @@ static inline void xfs_buf_relse(xfs_buf
 	xfs_buf_rele(bp);
 }
 
-#define xfs_biodone(bp)		xfs_buf_ioend(bp, 0)
-
-#define xfs_biomove(bp, off, len, data, rw) \
-	    xfs_buf_iomove((bp), (off), (len), (data), \
-		((rw) == XBF_WRITE) ? XBRW_WRITE : XBRW_READ)
-
-#define xfs_biozero(bp, off, len) \
-	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
-
-#define xfs_iowait(bp)	xfs_buf_iowait(bp)
-
-#define xfs_baread(target, rablkno, ralen)  \
-	xfs_buf_readahead((target), (rablkno), (ralen), XBF_DONT_BLOCK)
-
-
 /*
  *	Handling of buftargs.
  */
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-09-30 15:53:51.780782661 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-09-30 15:57:22.480782662 +0200
@@ -644,7 +644,7 @@ xfs_barrier_test(
 	XFS_BUF_ORDERED(sbp);
 
 	xfsbdstrat(mp, sbp);
-	error = xfs_iowait(sbp);
+	error = xfs_buf_iowait(sbp);
 
 	/*
 	 * Clear all the flags we set and possible error state in the
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-09-30 15:53:51.787782661 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-09-30 15:57:22.485782662 +0200
@@ -1433,7 +1433,7 @@ xfs_qm_dqiterate(
 				rablkcnt =  map[i+1].br_blockcount;
 				rablkno = map[i+1].br_startblock;
 				while (rablkcnt--) {
-					xfs_baread(mp->m_ddev_targp,
+					xfs_buf_readahead(mp->m_ddev_targp,
 					       XFS_FSB_TO_DADDR(mp, rablkno),
 					       mp->m_quotainfo->qi_dqchunklen);
 					rablkno++;
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2010-09-30 15:53:51.853782661 +0200
+++ xfs/fs/xfs/xfs_attr.c	2010-09-30 15:57:22.490782662 +0200
@@ -1986,7 +1986,7 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 
 			tmp = (valuelen < XFS_BUF_SIZE(bp))
 				? valuelen : XFS_BUF_SIZE(bp);
-			xfs_biomove(bp, 0, tmp, dst, XBF_READ);
+			xfs_buf_iomove(bp, 0, tmp, dst, XBRW_READ);
 			xfs_buf_relse(bp);
 			dst += tmp;
 			valuelen -= tmp;
@@ -2116,9 +2116,9 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 
 		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
 							XFS_BUF_SIZE(bp);
-		xfs_biomove(bp, 0, tmp, src, XBF_WRITE);
+		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
 		if (tmp < XFS_BUF_SIZE(bp))
-			xfs_biozero(bp, tmp, XFS_BUF_SIZE(bp) - tmp);
+			xfs_buf_zero(bp, tmp, XFS_BUF_SIZE(bp) - tmp);
 		if ((error = xfs_bwrite(mp, bp))) {/* GROT: NOTE: synchronous write */
 			return (error);
 		}
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2010-09-30 15:53:51.794782661 +0200
+++ xfs/fs/xfs/xfs_btree.c	2010-09-30 15:57:22.494782662 +0200
@@ -656,7 +656,7 @@ xfs_btree_reada_bufl(
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	xfs_baread(mp->m_ddev_targp, d, mp->m_bsize * count);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count);
 }
 
 /*
@@ -676,7 +676,7 @@ xfs_btree_reada_bufs(
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agbno != NULLAGBLOCK);
 	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	xfs_baread(mp->m_ddev_targp, d, mp->m_bsize * count);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count);
 }
 
 STATIC int
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2010-09-30 15:53:51.802782661 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2010-09-30 15:57:22.503782662 +0200
@@ -2042,7 +2042,7 @@ xfs_da_do_buf(
 				mappedbno, nmapped, 0, &bp);
 			break;
 		case 3:
-			xfs_baread(mp->m_ddev_targp, mappedbno, nmapped);
+			xfs_buf_readahead(mp->m_ddev_targp, mappedbno, nmapped);
 			error = 0;
 			bp = NULL;
 			break;
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2010-09-30 15:53:51.809782661 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2010-09-30 15:57:22.509782662 +0200
@@ -961,7 +961,7 @@ xfs_dir2_leaf_getdents(
 				if (i > ra_current &&
 				    map[ra_index].br_blockcount >=
 				    mp->m_dirblkfsbs) {
-					xfs_baread(mp->m_ddev_targp,
+					xfs_buf_readahead(mp->m_ddev_targp,
 						XFS_FSB_TO_DADDR(mp,
 						   map[ra_index].br_startblock +
 						   ra_offset),
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2010-09-30 15:53:51.862782661 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2010-09-30 15:57:22.516782662 +0200
@@ -212,7 +212,7 @@ xfs_ialloc_inode_init(
 		 *	to log a whole cluster of inodes instead of all the
 		 *	individual transactions causing a lot of log traffic.
 		 */
-		xfs_biozero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
+		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
 			uint	isize = sizeof(struct xfs_dinode);
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-09-30 15:57:16.222782662 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2010-09-30 15:59:42.573782661 +0200
@@ -168,7 +168,7 @@ xlog_bread_noalign(
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
 	xfsbdstrat(log->l_mp, bp);
-	error = xfs_iowait(bp);
+	error = xfs_buf_iowait(bp);
 	if (error)
 		xfs_ioerror_alert("xlog_bread", log->l_mp,
 				  bp, XFS_BUF_ADDR(bp));
@@ -328,7 +328,7 @@ xlog_recover_iodone(
 					SHUTDOWN_META_IO_ERROR);
 	}
 	XFS_BUF_CLR_IODONE_FUNC(bp);
-	xfs_biodone(bp);
+	xfs_buf_ioend(bp, 0);
 }
 
 /*
@@ -3816,7 +3816,7 @@ xlog_do_recover(
 	XFS_BUF_READ(bp);
 	XFS_BUF_UNASYNC(bp);
 	xfsbdstrat(log->l_mp, bp);
-	error = xfs_iowait(bp);
+	error = xfs_buf_iowait(bp);
 	if (error) {
 		xfs_ioerror_alert("xlog_do_recover",
 				  log->l_mp, bp, XFS_BUF_ADDR(bp));
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-09-30 15:53:51.824782661 +0200
+++ xfs/fs/xfs/xfs_mount.c	2010-09-30 15:57:22.526782662 +0200
@@ -1607,7 +1607,7 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 		XFS_BUF_UNASYNC(sbp);
 		ASSERT(XFS_BUF_TARGET(sbp) == mp->m_ddev_targp);
 		xfsbdstrat(mp, sbp);
-		error = xfs_iowait(sbp);
+		error = xfs_buf_iowait(sbp);
 		if (error)
 			xfs_ioerror_alert("xfs_unmountfs_writesb",
 					  mp, sbp, XFS_BUF_ADDR(sbp));
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-09-30 15:53:51.835782661 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2010-09-30 15:57:22.531782662 +0200
@@ -336,7 +336,7 @@ xfs_trans_read_buf(
 			ASSERT(!XFS_BUF_ISASYNC(bp));
 			XFS_BUF_READ(bp);
 			xfsbdstrat(tp->t_mountp, bp);
-			error = xfs_iowait(bp);
+			error = xfs_buf_iowait(bp);
 			if (error) {
 				xfs_ioerror_alert("xfs_trans_read_buf", mp,
 						  bp, blkno);
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-09-30 15:53:51.844782661 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-09-30 15:57:22.534782662 +0200
@@ -2460,7 +2460,7 @@ xfs_zero_remaining_bytes(
 		XFS_BUF_READ(bp);
 		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
 		xfsbdstrat(mp, bp);
-		error = xfs_iowait(bp);
+		error = xfs_buf_iowait(bp);
 		if (error) {
 			xfs_ioerror_alert("xfs_zero_remaining_bytes(read)",
 					  mp, bp, XFS_BUF_ADDR(bp));
@@ -2473,7 +2473,7 @@ xfs_zero_remaining_bytes(
 		XFS_BUF_UNREAD(bp);
 		XFS_BUF_WRITE(bp);
 		xfsbdstrat(mp, bp);
-		error = xfs_iowait(bp);
+		error = xfs_buf_iowait(bp);
 		if (error) {
 			xfs_ioerror_alert("xfs_zero_remaining_bytes(write)",
 					  mp, bp, XFS_BUF_ADDR(bp));
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-09-30 15:57:26.485782662 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-09-30 15:58:37.749782679 +0200
@@ -973,7 +973,7 @@ xfs_buf_iodone_callbacks(
 			xfs_buf_do_callbacks(bp, lip);
 			XFS_BUF_SET_FSPRIVATE(bp, NULL);
 			XFS_BUF_CLR_IODONE_FUNC(bp);
-			xfs_biodone(bp);
+			xfs_buf_ioend(bp, 0);
 			return;
 		}
 
@@ -1032,7 +1032,7 @@ xfs_buf_iodone_callbacks(
 	xfs_buf_do_callbacks(bp, lip);
 	XFS_BUF_SET_FSPRIVATE(bp, NULL);
 	XFS_BUF_CLR_IODONE_FUNC(bp);
-	xfs_biodone(bp);
+	xfs_buf_ioend(bp, 0);
 }
 
 /*
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-09-30 15:57:26.497782662 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-09-30 15:58:46.076782659 +0200
@@ -2724,7 +2724,7 @@ cluster_corrupt_out:
 			XFS_BUF_UNDONE(bp);
 			XFS_BUF_STALE(bp);
 			XFS_BUF_ERROR(bp,EIO);
-			xfs_biodone(bp);
+			xfs_buf_ioend(bp, 0);
 		} else {
 			XFS_BUF_STALE(bp);
 			xfs_buf_relse(bp);
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-09-30 15:57:26.513782662 +0200
+++ xfs/fs/xfs/xfs_log.c	2010-09-30 15:59:02.290782317 +0200
@@ -1310,7 +1310,7 @@ xlog_bdstrat(
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		XFS_BUF_ERROR(bp, EIO);
 		XFS_BUF_STALE(bp);
-		xfs_biodone(bp);
+		xfs_buf_ioend(bp, 0);
 		/*
 		 * It would seem logical to return EIO here, but we rely on
 		 * the log state machine to propagate I/O errors instead of

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
