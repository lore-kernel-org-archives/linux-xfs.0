Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 04:52:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LBqEoj015788
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 04:52:14 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23005525EA2
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 04:53:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id o6qfE4FR8LONeCi1 for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 04:53:57 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KsFoD-0001C6-DA
	for xfs@oss.sgi.com; Tue, 21 Oct 2008 11:53:57 +0000
Date: Tue, 21 Oct 2008 07:53:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/3] remove dead code for old inode item recovery
Message-ID: <20081021115357.GB2881@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

We're removed the support for old-style inode items a while ago, and
xlog_recover_do_inode_trans is now only called for XFS_LI_INODE items.
That means we can remove the call to xfs_imap there and with it the
XFS_IMAP_LOOKUP that is set by all other callers.  We can also mark
xfs_imap static now.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_log_recover.c	2008-10-21 11:49:00.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_log_recover.c	2008-10-21 13:49:20.000000000 +0200
@@ -2245,7 +2245,6 @@ xlog_recover_do_inode_trans(
 	xfs_inode_log_format_t	*in_f;
 	xfs_mount_t		*mp;
 	xfs_buf_t		*bp;
-	xfs_imap_t		imap;
 	xfs_dinode_t		*dip;
 	xfs_ino_t		ino;
 	int			len;
@@ -2273,48 +2272,29 @@ xlog_recover_do_inode_trans(
 	}
 	ino = in_f->ilf_ino;
 	mp = log->l_mp;
-	if (ITEM_TYPE(item) == XFS_LI_INODE) {
-		imap.im_blkno = (xfs_daddr_t)in_f->ilf_blkno;
-		imap.im_len = in_f->ilf_len;
-		imap.im_boffset = in_f->ilf_boffset;
-	} else {
-		/*
-		 * It's an old inode format record.  We don't know where
-		 * its cluster is located on disk, and we can't allow
-		 * xfs_imap() to figure it out because the inode btrees
-		 * are not ready to be used.  Therefore do not pass the
-		 * XFS_IMAP_LOOKUP flag to xfs_imap().  This will give
-		 * us only the single block in which the inode lives
-		 * rather than its cluster, so we must make sure to
-		 * invalidate the buffer when we write it out below.
-		 */
-		imap.im_blkno = 0;
-		error = xfs_imap(log->l_mp, NULL, ino, &imap, 0);
-		if (error)
-			goto error;
-	}
 
 	/*
 	 * Inode buffers can be freed, look out for it,
 	 * and do not replay the inode.
 	 */
-	if (xlog_check_buffer_cancelled(log, imap.im_blkno, imap.im_len, 0)) {
+	if (xlog_check_buffer_cancelled(log, in_f->ilf_blkno,
+					in_f->ilf_len, 0)) {
 		error = 0;
 		goto error;
 	}
 
-	bp = xfs_buf_read_flags(mp->m_ddev_targp, imap.im_blkno, imap.im_len,
-								XFS_BUF_LOCK);
+	bp = xfs_buf_read_flags(mp->m_ddev_targp, in_f->ilf_blkno,
+				in_f->ilf_len, XFS_BUF_LOCK);
 	if (XFS_BUF_ISERROR(bp)) {
 		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
-				  bp, imap.im_blkno);
+				  bp, in_f->ilf_blkno);
 		error = XFS_BUF_GETERROR(bp);
 		xfs_buf_relse(bp);
 		goto error;
 	}
 	error = 0;
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, in_f->ilf_boffset);
 
 	/*
 	 * Make sure the place we're flushing out to really looks
Index: xfs-2.6/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_ialloc.c	2008-10-21 11:49:01.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_ialloc.c	2008-10-21 11:49:04.000000000 +0200
@@ -1317,8 +1317,7 @@ xfs_dilocate(
 #endif /* DEBUG */
 		return XFS_ERROR(EINVAL);
 	}
-	if ((mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) ||
-	    !(flags & XFS_IMAP_LOOKUP)) {
+	if ((mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp))) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
 		*bno = XFS_AGB_TO_FSB(mp, agno, agbno);
Index: xfs-2.6/fs/xfs/xfs_inode.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.c	2008-10-21 11:49:01.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.c	2008-10-21 13:48:57.000000000 +0200
@@ -126,6 +126,60 @@ xfs_inobp_check(
 #endif
 
 /*
+ * Map inode to disk block and offset.
+ *
+ * mp -- the mount point structure for the current file system
+ * tp -- the current transaction
+ * ino -- the inode number of the inode to be located
+ * imap -- this structure is filled in with the information necessary
+ *	 to retrieve the given inode from disk
+ * flags -- flags to pass to xfs_dilocate
+ */
+STATIC int
+xfs_imap(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_ino_t	ino,
+	xfs_imap_t	*imap,
+	uint		flags)
+{
+	xfs_fsblock_t	fsbno;
+	int		len;
+	int		off;
+	int		error;
+
+	fsbno = imap->im_blkno ?
+		XFS_DADDR_TO_FSB(mp, imap->im_blkno) : NULLFSBLOCK;
+	error = xfs_dilocate(mp, tp, ino, &fsbno, &len, &off, flags);
+	if (error)
+		return error;
+
+	imap->im_blkno = XFS_FSB_TO_DADDR(mp, fsbno);
+	imap->im_len = XFS_FSB_TO_BB(mp, len);
+	imap->im_agblkno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	imap->im_ioffset = (ushort)off;
+	imap->im_boffset = (ushort)(off << mp->m_sb.sb_inodelog);
+
+	/*
+	 * If the inode number maps to a block outside the bounds
+	 * of the file system then return NULL rather than calling
+	 * read_buf and panicing when we get an error from the
+	 * driver.
+	 */
+	if ((imap->im_blkno + imap->im_len) >
+	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
+			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
+			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
+			(unsigned long long) imap->im_blkno,
+			(unsigned long long) imap->im_len,
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
+		return EINVAL;
+	}
+	return 0;
+}
+
+/*
  * Find the buffer associated with the given inode map
  * We do basic validation checks on the buffer once it has been
  * retrieved from disk.
@@ -237,7 +291,7 @@ xfs_inotobp(
 	int		error;
 
 	imap.im_blkno = 0;
-	error = xfs_imap(mp, tp, ino, &imap, imap_flags | XFS_IMAP_LOOKUP);
+	error = xfs_imap(mp, tp, ino, &imap, imap_flags);
 	if (error)
 		return error;
 
@@ -870,8 +924,7 @@ xfs_iread(
 	 * Get pointer's to the on-disk inode and the buffer containing it.
 	 */
 	imap.im_blkno = bno;
-	error = xfs_imap(mp, tp, ip->i_ino, &imap,
-				XFS_IMAP_LOOKUP | imap_flags);
+	error = xfs_imap(mp, tp, ip->i_ino, &imap, imap_flags);
 	if (error)
 		goto out_destroy_inode;
 
@@ -2551,64 +2604,6 @@ xfs_idata_realloc(
 	ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
 }
 
-
-
-
-/*
- * Map inode to disk block and offset.
- *
- * mp -- the mount point structure for the current file system
- * tp -- the current transaction
- * ino -- the inode number of the inode to be located
- * imap -- this structure is filled in with the information necessary
- *	 to retrieve the given inode from disk
- * flags -- flags to pass to xfs_dilocate indicating whether or not
- *	 lookups in the inode btree were OK or not
- */
-int
-xfs_imap(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	xfs_imap_t	*imap,
-	uint		flags)
-{
-	xfs_fsblock_t	fsbno;
-	int		len;
-	int		off;
-	int		error;
-
-	fsbno = imap->im_blkno ?
-		XFS_DADDR_TO_FSB(mp, imap->im_blkno) : NULLFSBLOCK;
-	error = xfs_dilocate(mp, tp, ino, &fsbno, &len, &off, flags);
-	if (error)
-		return error;
-
-	imap->im_blkno = XFS_FSB_TO_DADDR(mp, fsbno);
-	imap->im_len = XFS_FSB_TO_BB(mp, len);
-	imap->im_agblkno = XFS_FSB_TO_AGBNO(mp, fsbno);
-	imap->im_ioffset = (ushort)off;
-	imap->im_boffset = (ushort)(off << mp->m_sb.sb_inodelog);
-
-	/*
-	 * If the inode number maps to a block outside the bounds
-	 * of the file system then return NULL rather than calling
-	 * read_buf and panicing when we get an error from the
-	 * driver.
-	 */
-	if ((imap->im_blkno + imap->im_len) >
-	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
-			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
-			(unsigned long long) imap->im_blkno,
-			(unsigned long long) imap->im_len,
-			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-		return EINVAL;
-	}
-	return 0;
-}
-
 void
 xfs_idestroy_fork(
 	xfs_inode_t	*ip,
Index: xfs-2.6/fs/xfs/xfs_inode.h
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-21 11:49:01.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-21 13:48:57.000000000 +0200
@@ -160,8 +160,7 @@ typedef struct xfs_icdinode {
 /*
  * Flags for xfs_inotobp, xfs_imap() and xfs_dilocate().
  */
-#define XFS_IMAP_LOOKUP		0x1
-#define XFS_IMAP_BULKSTAT	0x2
+#define XFS_IMAP_BULKSTAT	0x1
 
 /*
  * Fork handling.
Index: xfs-2.6/fs/xfs/xfs_imap.h
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_imap.h	2008-10-21 11:51:04.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_imap.h	2008-10-21 13:48:57.000000000 +0200
@@ -30,9 +30,4 @@ typedef struct xfs_imap {
 	ushort		im_boffset;	/* inode offset in block in bytes */
 } xfs_imap_t;
 
-struct xfs_mount;
-struct xfs_trans;
-int	xfs_imap(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-		 xfs_imap_t *, uint);
-
 #endif	/* __XFS_IMAP_H__ */
