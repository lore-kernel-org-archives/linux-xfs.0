Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9ttG1182574 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:55:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 891F71C5E160
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:56:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MYUVh7dZIPOn7eRe for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:56:55 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NXApS-0001G1-TD
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 09:56:54 +0000
Message-Id: <20100119095654.708720933@bombadil.infradead.org>
Date: Tue, 19 Jan 2010 04:56:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] [PATCH] xfs: remove duplicate buffer flags
References: <20100119095643.378866749@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-buf-flags-cleanup
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

Currently we define aliases for the buffer flags in various namespaces,
which only adds confusion.  Remove all but the XBF_ flags to clean this
up a bit.

Note that we still abuse XFS_B_ASYNC/XBF_ASYNC for some non-buffer uses,
but I'll clean that up later.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2010-01-17 11:13:28.899262696 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2010-01-17 11:14:36.978275990 +0100
@@ -275,33 +275,19 @@ extern void xfs_buf_terminate(void);
 	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
 
 
-#define XFS_B_ASYNC		XBF_ASYNC
-#define XFS_B_DELWRI		XBF_DELWRI
-#define XFS_B_READ		XBF_READ
-#define XFS_B_WRITE		XBF_WRITE
-#define XFS_B_STALE		XBF_STALE
-
-#define XFS_BUF_TRYLOCK		XBF_TRYLOCK
-#define XFS_INCORE_TRYLOCK	XBF_TRYLOCK
-#define XFS_BUF_LOCK		XBF_LOCK
-#define XFS_BUF_MAPPED		XBF_MAPPED
-
-#define BUF_BUSY		XBF_DONT_BLOCK
-
 #define XFS_BUF_BFLAGS(bp)	((bp)->b_flags)
 #define XFS_BUF_ZEROFLAGS(bp)	((bp)->b_flags &= \
 		~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED))
 
-#define XFS_BUF_STALE(bp)	((bp)->b_flags |= XFS_B_STALE)
-#define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XFS_B_STALE)
-#define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XFS_B_STALE)
+#define XFS_BUF_STALE(bp)	((bp)->b_flags |= XBF_STALE)
+#define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
+#define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
 #define XFS_BUF_SUPER_STALE(bp)	do {				\
 					XFS_BUF_STALE(bp);	\
 					xfs_buf_delwri_dequeue(bp);	\
 					XFS_BUF_DONE(bp);	\
 				} while (0)
 
-#define XFS_BUF_MANAGE		XBF_FS_MANAGED
 #define XFS_BUF_UNMANAGE(bp)	((bp)->b_flags &= ~XBF_FS_MANAGED)
 
 #define XFS_BUF_DELAYWRITE(bp)		((bp)->b_flags |= XBF_DELWRI)
@@ -390,7 +376,7 @@ static inline void xfs_buf_relse(xfs_buf
 
 #define xfs_biomove(bp, off, len, data, rw) \
 	    xfs_buf_iomove((bp), (off), (len), (data), \
-		((rw) == XFS_B_WRITE) ? XBRW_WRITE : XBRW_READ)
+		((rw) == XBF_WRITE) ? XBRW_WRITE : XBRW_READ)
 
 #define xfs_biozero(bp, off, len) \
 	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
Index: xfs/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2010-01-17 11:13:28.905253682 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_fs_subr.c	2010-01-17 11:14:36.979254745 +0100
@@ -79,7 +79,7 @@ xfs_flush_pages(
 		xfs_iflags_clear(ip, XFS_ITRUNCATED);
 		ret = -filemap_fdatawrite(mapping);
 	}
-	if (flags & XFS_B_ASYNC)
+	if (flags & XBF_ASYNC)
 		return ret;
 	ret2 = xfs_wait_on_pages(ip, first, last);
 	if (!ret)
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-01-17 11:13:28.910254109 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-01-17 11:14:36.980004841 +0100
@@ -234,7 +234,7 @@ xfs_sync_inode_data(
 	}
 
 	error = xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
-				0 : XFS_B_ASYNC, FI_NONE);
+				0 : XBF_ASYNC, FI_NONE);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
  out_wait:
@@ -370,7 +370,7 @@ xfs_sync_fsdata(
 	if (flags & SYNC_TRYLOCK) {
 		ASSERT(!(flags & SYNC_WAIT));
 
-		bp = xfs_getsb(mp, XFS_BUF_TRYLOCK);
+		bp = xfs_getsb(mp, XBF_TRYLOCK);
 		if (!bp)
 			goto out;
 
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-01-17 11:13:28.922253750 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-01-17 11:14:36.982004327 +0100
@@ -1527,8 +1527,7 @@ xfs_qm_dqflock_pushbuf_wait(
 	 * the flush lock when the I/O completes.
 	 */
 	bp = xfs_incore(dqp->q_mount->m_ddev_targp, dqp->q_blkno,
-		    XFS_QI_DQCHUNKLEN(dqp->q_mount),
-		    XFS_INCORE_TRYLOCK);
+		    XFS_QI_DQCHUNKLEN(dqp->q_mount), XBF_TRYLOCK);
 	if (bp != NULL) {
 		if (XFS_BUF_ISDELAYWRITE(bp)) {
 			int	error;
Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-01-17 11:13:28.929273219 +0100
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-01-17 11:14:36.983004314 +0100
@@ -237,8 +237,7 @@ xfs_qm_dquot_logitem_pushbuf(
 	}
 	mp = dqp->q_mount;
 	bp = xfs_incore(mp->m_ddev_targp, qip->qli_format.qlf_blkno,
-		    XFS_QI_DQCHUNKLEN(mp),
-		    XFS_INCORE_TRYLOCK);
+		    XFS_QI_DQCHUNKLEN(mp), XBF_TRYLOCK);
 	if (bp != NULL) {
 		if (XFS_BUF_ISDELAYWRITE(bp)) {
 			dopush = ((qip->qli_item.li_flags & XFS_LI_IN_AIL) &&
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-01-17 11:13:28.936023938 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2010-01-17 11:14:36.984004512 +0100
@@ -2180,7 +2180,7 @@ xfs_alloc_read_agf(
 	ASSERT(agno != NULLAGNUMBER);
 
 	error = xfs_read_agf(mp, tp, agno,
-			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XFS_BUF_TRYLOCK : 0,
+			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
 			bpp);
 	if (error)
 		return error;
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2010-01-17 11:13:28.944004633 +0100
+++ xfs/fs/xfs/xfs_attr.c	2010-01-17 11:14:36.986004697 +0100
@@ -2007,15 +2007,14 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_read_buf(mp, mp->m_ddev_targp, dblkno,
-					     blkcnt,
-					     XFS_BUF_LOCK | XBF_DONT_BLOCK,
+					     blkcnt, XBF_LOCK | XBF_DONT_BLOCK,
 					     &bp);
 			if (error)
 				return(error);
 
 			tmp = (valuelen < XFS_BUF_SIZE(bp))
 				? valuelen : XFS_BUF_SIZE(bp);
-			xfs_biomove(bp, 0, tmp, dst, XFS_B_READ);
+			xfs_biomove(bp, 0, tmp, dst, XBF_READ);
 			xfs_buf_relse(bp);
 			dst += tmp;
 			valuelen -= tmp;
@@ -2141,13 +2140,13 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
 		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt,
-				 XFS_BUF_LOCK | XBF_DONT_BLOCK);
+				 XBF_LOCK | XBF_DONT_BLOCK);
 		ASSERT(bp);
 		ASSERT(!XFS_BUF_GETERROR(bp));
 
 		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
 							XFS_BUF_SIZE(bp);
-		xfs_biomove(bp, 0, tmp, src, XFS_B_WRITE);
+		xfs_biomove(bp, 0, tmp, src, XBF_WRITE);
 		if (tmp < XFS_BUF_SIZE(bp))
 			xfs_biozero(bp, tmp, XFS_BUF_SIZE(bp) - tmp);
 		if ((error = xfs_bwrite(mp, bp))) {/* GROT: NOTE: synchronous write */
@@ -2208,8 +2207,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 		/*
 		 * If the "remote" value is in the cache, remove it.
 		 */
-		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt,
-				XFS_INCORE_TRYLOCK);
+		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt, XBF_TRYLOCK);
 		if (bp) {
 			XFS_BUF_STALE(bp);
 			XFS_BUF_UNDELAYWRITE(bp);
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2010-01-17 11:13:28.953004730 +0100
+++ xfs/fs/xfs/xfs_attr_leaf.c	2010-01-17 11:14:36.988005370 +0100
@@ -2950,7 +2950,7 @@ xfs_attr_leaf_freextent(xfs_trans_t **tr
 						map.br_blockcount);
 			bp = xfs_trans_get_buf(*trans,
 					dp->i_mount->m_ddev_targp,
-					dblkno, dblkcnt, XFS_BUF_LOCK);
+					dblkno, dblkcnt, XBF_LOCK);
 			xfs_trans_binval(*trans, bp);
 			/*
 			 * Roll to next transaction.
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2010-01-17 11:13:28.963004676 +0100
+++ xfs/fs/xfs/xfs_btree.c	2010-01-17 11:14:36.991003726 +0100
@@ -977,7 +977,7 @@ xfs_btree_get_buf_block(
 	xfs_daddr_t		d;
 
 	/* need to sort out how callers deal with failures first */
-	ASSERT(!(flags & XFS_BUF_TRYLOCK));
+	ASSERT(!(flags & XBF_TRYLOCK));
 
 	d = xfs_btree_ptr_to_daddr(cur, ptr);
 	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
@@ -1008,7 +1008,7 @@ xfs_btree_read_buf_block(
 	int			error;
 
 	/* need to sort out how callers deal with failures first */
-	ASSERT(!(flags & XFS_BUF_TRYLOCK));
+	ASSERT(!(flags & XBF_TRYLOCK));
 
 	d = xfs_btree_ptr_to_daddr(cur, ptr);
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2010-01-17 11:13:28.972004564 +0100
+++ xfs/fs/xfs/xfs_ialloc.c	2010-01-17 11:14:36.993004399 +0100
@@ -205,7 +205,7 @@ xfs_ialloc_inode_init(
 		d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));
 		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 					 mp->m_bsize * blks_per_cluster,
-					 XFS_BUF_LOCK);
+					 XBF_LOCK);
 		ASSERT(fbuf);
 		ASSERT(!XFS_BUF_GETERROR(fbuf));
 
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-01-17 11:13:28.981004243 +0100
+++ xfs/fs/xfs/xfs_inode.c	2010-01-17 11:14:36.997004559 +0100
@@ -151,7 +151,7 @@ xfs_imap_to_bp(
 				"an error %d on %s.  Returning error.",
 				error, mp->m_fsname);
 		} else {
-			ASSERT(buf_flags & XFS_BUF_TRYLOCK);
+			ASSERT(buf_flags & XBF_TRYLOCK);
 		}
 		return error;
 	}
@@ -239,7 +239,7 @@ xfs_inotobp(
 	if (error)
 		return error;
 
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XBF_LOCK, imap_flags);
 	if (error)
 		return error;
 
@@ -285,7 +285,7 @@ xfs_itobp(
 		return error;
 
 	if (!bp) {
-		ASSERT(buf_flags & XFS_BUF_TRYLOCK);
+		ASSERT(buf_flags & XBF_TRYLOCK);
 		ASSERT(tp == NULL);
 		*bpp = NULL;
 		return EAGAIN;
@@ -807,7 +807,7 @@ xfs_iread(
 	 * Get pointers to the on-disk inode and the buffer containing it.
 	 */
 	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp,
-			       XFS_BUF_LOCK, iget_flags);
+			       XBF_LOCK, iget_flags);
 	if (error)
 		return error;
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
@@ -1751,7 +1751,7 @@ xfs_iunlink(
 		 * Here we put the head pointer into our next pointer,
 		 * and then we fall through to point the head at us.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XFS_BUF_LOCK);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XBF_LOCK);
 		if (error)
 			return error;
 
@@ -1833,7 +1833,7 @@ xfs_iunlink_remove(
 		 * of dealing with the buffer when there is no need to
 		 * change it.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XFS_BUF_LOCK);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XBF_LOCK);
 		if (error) {
 			cmn_err(CE_WARN,
 				"xfs_iunlink_remove: xfs_itobp()  returned an error %d on %s.  Returning error.",
@@ -1895,7 +1895,7 @@ xfs_iunlink_remove(
 		 * Now last_ibp points to the buffer previous to us on
 		 * the unlinked list.  Pull us from the list.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XFS_BUF_LOCK);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XBF_LOCK);
 		if (error) {
 			cmn_err(CE_WARN,
 				"xfs_iunlink_remove: xfs_itobp()  returned an error %d on %s.  Returning error.",
@@ -2040,7 +2040,7 @@ xfs_ifree_cluster(
 
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno, 
 					mp->m_bsize * blks_per_cluster,
-					XFS_BUF_LOCK);
+					XBF_LOCK);
 
 		pre_flushed = 0;
 		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
@@ -2151,7 +2151,7 @@ xfs_ifree(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, XFS_BUF_LOCK);
+	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, XBF_LOCK);
 	if (error)
 		return error;
 
@@ -2952,7 +2952,7 @@ xfs_iflush(
 	 * Get the buffer containing the on-disk inode.
 	 */
 	error = xfs_itobp(mp, NULL, ip, &dip, &bp,
-				noblock ? XFS_BUF_TRYLOCK : XFS_BUF_LOCK);
+				noblock ? XBF_TRYLOCK : XBF_LOCK);
 	if (error || !bp) {
 		xfs_ifunlock(ip);
 		return error;
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-01-17 11:13:28.986004320 +0100
+++ xfs/fs/xfs/xfs_inode_item.c	2010-01-17 11:14:36.998003569 +0100
@@ -785,7 +785,7 @@ xfs_inode_item_pushbuf(
 
 	mp = ip->i_mount;
 	bp = xfs_incore(mp->m_ddev_targp, iip->ili_format.ilf_blkno,
-		    iip->ili_format.ilf_len, XFS_INCORE_TRYLOCK);
+		    iip->ili_format.ilf_len, XBF_TRYLOCK);
 
 	if (bp != NULL) {
 		if (XFS_BUF_ISDELAYWRITE(bp)) {
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-01-17 11:13:28.992003548 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2010-01-17 11:14:37.000007106 +0100
@@ -2184,9 +2184,9 @@ xlog_recover_do_buffer_trans(
 	}
 
 	mp = log->l_mp;
-	buf_flags = XFS_BUF_LOCK;
+	buf_flags = XBF_LOCK;
 	if (!(flags & XFS_BLI_INODE_BUF))
-		buf_flags |= XFS_BUF_MAPPED;
+		buf_flags |= XBF_MAPPED;
 
 	bp = xfs_buf_read(mp->m_ddev_targp, blkno, len, buf_flags);
 	if (XFS_BUF_ISERROR(bp)) {
@@ -2288,7 +2288,7 @@ xlog_recover_do_inode_trans(
 	}
 
 	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
-			  XFS_BUF_LOCK);
+			  XBF_LOCK);
 	if (XFS_BUF_ISERROR(bp)) {
 		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
 				  bp, in_f->ilf_blkno);
@@ -3146,7 +3146,7 @@ xlog_recover_process_one_iunlink(
 	/*
 	 * Get the on disk inode to find the next inode in the bucket.
 	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, XFS_BUF_LOCK);
+	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, XBF_LOCK);
 	if (error)
 		goto fail_iput;
 
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-01-17 11:13:28.998011086 +0100
+++ xfs/fs/xfs/xfs_mount.c	2010-01-17 11:14:37.003004344 +0100
@@ -665,7 +665,7 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	 * access to the superblock.
 	 */
 	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
-	extra_flags = XFS_BUF_LOCK | XFS_BUF_MANAGE | XFS_BUF_MAPPED;
+	extra_flags = XBF_LOCK | XBF_FS_MANAGED | XBF_MAPPED;
 
 	bp = xfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR, BTOBB(sector_size),
 			  extra_flags);
@@ -1970,7 +1970,7 @@ xfs_getsb(
 
 	ASSERT(mp->m_sb_bp != NULL);
 	bp = mp->m_sb_bp;
-	if (flags & XFS_BUF_TRYLOCK) {
+	if (flags & XBF_TRYLOCK) {
 		if (!XFS_BUF_CPSEMA(bp)) {
 			return NULL;
 		}
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-01-17 11:13:29.004006961 +0100
+++ xfs/fs/xfs/xfs_trans_buf.c	2010-01-17 11:14:37.004004332 +0100
@@ -75,13 +75,14 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	xfs_buf_log_item_t	*bip;
 
 	if (flags == 0)
-		flags = XFS_BUF_LOCK | XFS_BUF_MAPPED;
+		flags = XBF_LOCK | XBF_MAPPED;
 
 	/*
 	 * Default to a normal get_buf() call if the tp is NULL.
 	 */
 	if (tp == NULL)
-		return xfs_buf_get(target_dev, blkno, len, flags | BUF_BUSY);
+		return xfs_buf_get(target_dev, blkno, len,
+				   flags | XBF_DONT_BLOCK);
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -117,14 +118,14 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	}
 
 	/*
-	 * We always specify the BUF_BUSY flag within a transaction so
-	 * that get_buf does not try to push out a delayed write buffer
+	 * We always specify the XBF_DONT_BLOCK flag within a transaction
+	 * so that get_buf does not try to push out a delayed write buffer
 	 * which might cause another transaction to take place (if the
 	 * buffer was delayed alloc).  Such recursive transactions can
 	 * easily deadlock with our current transaction as well as cause
 	 * us to run out of stack space.
 	 */
-	bp = xfs_buf_get(target_dev, blkno, len, flags | BUF_BUSY);
+	bp = xfs_buf_get(target_dev, blkno, len, flags | XBF_DONT_BLOCK);
 	if (bp == NULL) {
 		return NULL;
 	}
@@ -290,15 +291,15 @@ xfs_trans_read_buf(
 	int			error;
 
 	if (flags == 0)
-		flags = XFS_BUF_LOCK | XFS_BUF_MAPPED;
+		flags = XBF_LOCK | XBF_MAPPED;
 
 	/*
 	 * Default to a normal get_buf() call if the tp is NULL.
 	 */
 	if (tp == NULL) {
-		bp = xfs_buf_read(target, blkno, len, flags | BUF_BUSY);
+		bp = xfs_buf_read(target, blkno, len, flags | XBF_DONT_BLOCK);
 		if (!bp)
-			return (flags & XFS_BUF_TRYLOCK) ?
+			return (flags & XBF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
 
 		if (XFS_BUF_GETERROR(bp) != 0) {
@@ -385,14 +386,14 @@ xfs_trans_read_buf(
 	}
 
 	/*
-	 * We always specify the BUF_BUSY flag within a transaction so
-	 * that get_buf does not try to push out a delayed write buffer
+	 * We always specify the XBF_DONT_BLOCK flag within a transaction
+	 * so that get_buf does not try to push out a delayed write buffer
 	 * which might cause another transaction to take place (if the
 	 * buffer was delayed alloc).  Such recursive transactions can
 	 * easily deadlock with our current transaction as well as cause
 	 * us to run out of stack space.
 	 */
-	bp = xfs_buf_read(target, blkno, len, flags | BUF_BUSY);
+	bp = xfs_buf_read(target, blkno, len, flags | XBF_DONT_BLOCK);
 	if (bp == NULL) {
 		*bpp = NULL;
 		return 0;
@@ -472,8 +473,8 @@ shutdown_abort:
 	if (XFS_BUF_ISSTALE(bp) && XFS_BUF_ISDELAYWRITE(bp))
 		cmn_err(CE_NOTE, "about to pop assert, bp == 0x%p", bp);
 #endif
-	ASSERT((XFS_BUF_BFLAGS(bp) & (XFS_B_STALE|XFS_B_DELWRI)) !=
-						(XFS_B_STALE|XFS_B_DELWRI));
+	ASSERT((XFS_BUF_BFLAGS(bp) & (XBF_STALE|XBF_DELWRI)) !=
+				     (XBF_STALE|XBF_DELWRI));
 
 	trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
 	xfs_buf_relse(bp);
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-01-17 11:13:29.013028221 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-01-17 11:14:37.006004587 +0100
@@ -256,7 +256,7 @@ xfs_setattr(
 		    iattr->ia_size > ip->i_d.di_size) {
 			code = xfs_flush_pages(ip,
 					ip->i_d.di_size, iattr->ia_size,
-					XFS_B_ASYNC, FI_NONE);
+					XBF_ASYNC, FI_NONE);
 		}
 
 		/* wait for all I/O to complete */
@@ -1096,7 +1096,7 @@ xfs_release(
 		 */
 		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
 		if (truncated && VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
-			xfs_flush_pages(ip, 0, -1, XFS_B_ASYNC, FI_NONE);
+			xfs_flush_pages(ip, 0, -1, XBF_ASYNC, FI_NONE);
 	}
 
 	if (ip->i_d.di_nlink != 0) {
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-01-17 11:13:28.917253952 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-01-17 11:14:37.008004213 +0100
@@ -1169,7 +1169,7 @@ xfs_bioerror_relse(
 	XFS_BUF_STALE(bp);
 	XFS_BUF_CLR_IODONE_FUNC(bp);
 	XFS_BUF_CLR_BDSTRAT_FUNC(bp);
-	if (!(fl & XFS_B_ASYNC)) {
+	if (!(fl & XBF_ASYNC)) {
 		/*
 		 * Mark b_error and B_ERROR _both_.
 		 * Lot's of chunkcache code assumes that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
