Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 20:38:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L4cYer011387
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:38:38 -0800
Date: Mon, 21 Jan 2008 15:38:47 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch] factor xfs_itobp V2
Message-ID: <20080121043847.GC155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Factor xfs_itobp() and xfs_inotobp().

The only difference between the functions is one passes an
inode for the lookup, the other passes an inode number.
However, they don't do the same validity checking or set
all the same state on the buffer that is returned yet
they should.

Factor the functions into a common implementation.

Version 2:
- kill xfs_ino_to_imap and move checking inside xfs_imap

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_inode.c |  261 +++++++++++++++++++++--------------------------------
 1 file changed, 106 insertions(+), 155 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-01-18 19:13:07.087183981 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-01-21 15:35:39.980364728 +1100
@@ -126,6 +126,85 @@ xfs_inobp_check(
 #endif
 
 /*
+ * Find the buffer associated with the given inode map
+ * We do basic validation checks on the buffer once it has been
+ * retrieved from disk.
+ */
+STATIC int
+xfs_imap_to_bp(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_imap_t	*imap,
+	xfs_buf_t	**bpp,
+	uint		buf_flags,
+	uint		imap_flags)
+{
+	int		error;
+	int		i;
+	int		ni;
+	xfs_buf_t	*bp;
+
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
+				   (int)imap->im_len, XFS_BUF_LOCK, &bp);
+	if (error) {
+		cmn_err(CE_WARN, "xfs_imap_to_bp: xfs_trans_read_buf()returned "
+				"an error %d on %s.  Returning error.",
+				error, mp->m_fsname);
+		return error;
+	}
+
+	/*
+	 * Validate the magic number and version of every inode in the buffer
+	 * (if DEBUG kernel) or the first inode in the buffer, otherwise.
+	 */
+#ifdef DEBUG
+	ni = BBTOB(imap->im_len) >> mp->m_sb.sb_inodelog;
+#else	/* usual case */
+	ni = 1;
+#endif
+
+	for (i = 0; i < ni; i++) {
+		int		di_ok;
+		xfs_dinode_t	*dip;
+
+		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
+					(i << mp->m_sb.sb_inodelog));
+		di_ok = be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
+			    XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
+		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
+						XFS_ERRTAG_ITOBP_INOTOBP,
+						XFS_RANDOM_ITOBP_INOTOBP))) {
+			if (imap_flags & XFS_IMAP_BULKSTAT) {
+				xfs_trans_brelse(tp, bp);
+				return XFS_ERROR(EINVAL);
+			}
+			XFS_CORRUPTION_ERROR("xfs_imap_to_bp",
+						XFS_ERRLEVEL_HIGH, mp, dip);
+#ifdef DEBUG
+			cmn_err(CE_PANIC,
+					"Device %s - bad inode magic/vsn "
+					"daddr %lld #%d (magic=%x)",
+				XFS_BUFTARG_NAME(mp->m_ddev_targp),
+				(unsigned long long)imap->im_blkno, i,
+				be16_to_cpu(dip->di_core.di_magic));
+#endif
+			xfs_trans_brelse(tp, bp);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+	}
+
+	xfs_inobp_check(mp, bp);
+
+	/*
+	 * Mark the buffer as an inode buffer now that it looks good
+	 */
+	XFS_BUF_SET_VTYPE(bp, B_FS_INO);
+
+	*bpp = bp;
+	return 0;
+}
+
+/*
  * This routine is called to map an inode number within a file
  * system to the buffer containing the on-disk version of the
  * inode.  It returns a pointer to the buffer containing the
@@ -147,72 +226,19 @@ xfs_inotobp(
 	xfs_buf_t	**bpp,
 	int		*offset)
 {
-	int		di_ok;
 	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
 	int		error;
-	xfs_dinode_t	*dip;
 
-	/*
-	 * Call the space management code to find the location of the
-	 * inode on disk.
-	 */
 	imap.im_blkno = 0;
 	error = xfs_imap(mp, tp, ino, &imap, XFS_IMAP_LOOKUP);
-	if (error != 0) {
-		cmn_err(CE_WARN,
-	"xfs_inotobp: xfs_imap()  returned an "
-	"error %d on %s.  Returning error.", error, mp->m_fsname);
+	if (error)
 		return error;
-	}
-
-	/*
-	 * If the inode number maps to a block outside the bounds of the
-	 * file system then return NULL rather than calling read_buf
-	 * and panicing when we get an error from the driver.
-	 */
-	if ((imap.im_blkno + imap.im_len) >
-	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-		cmn_err(CE_WARN,
-	"xfs_inotobp: inode number (%llu + %d) maps to a block outside the bounds "
-	"of the file system %s.  Returning EINVAL.",
-			(unsigned long long)imap.im_blkno,
-			imap.im_len, mp->m_fsname);
-		return XFS_ERROR(EINVAL);
-	}
-
-	/*
-	 * Read in the buffer.  If tp is NULL, xfs_trans_read_buf() will
-	 * default to just a read_buf() call.
-	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap.im_blkno,
-				   (int)imap.im_len, XFS_BUF_LOCK, &bp);
 
-	if (error) {
-		cmn_err(CE_WARN,
-	"xfs_inotobp: xfs_trans_read_buf()  returned an "
-	"error %d on %s.  Returning error.", error, mp->m_fsname);
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, 0);
+	if (error)
 		return error;
-	}
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, 0);
-	di_ok =
-		be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
-		XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
-	if (unlikely(XFS_TEST_ERROR(!di_ok, mp, XFS_ERRTAG_ITOBP_INOTOBP,
-			XFS_RANDOM_ITOBP_INOTOBP))) {
-		XFS_CORRUPTION_ERROR("xfs_inotobp", XFS_ERRLEVEL_LOW, mp, dip);
-		xfs_trans_brelse(tp, bp);
-		cmn_err(CE_WARN,
-	"xfs_inotobp: XFS_TEST_ERROR()  returned an "
-	"error on %s.  Returning EFSCORRUPTED.",  mp->m_fsname);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
 
-	xfs_inobp_check(mp, bp);
-
-	/*
-	 * Set *dipp to point to the on-disk inode in the buffer.
-	 */
 	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
 	*bpp = bp;
 	*offset = imap.im_boffset;
@@ -253,41 +279,15 @@ xfs_itobp(
 	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
 	int		error;
-	int		i;
-	int		ni;
 
 	if (ip->i_blkno == (xfs_daddr_t)0) {
-		/*
-		 * Call the space management code to find the location of the
-		 * inode on disk.
-		 */
 		imap.im_blkno = bno;
-		if ((error = xfs_imap(mp, tp, ip->i_ino, &imap,
-					XFS_IMAP_LOOKUP | imap_flags)))
+		error = xfs_imap(mp, tp, ip->i_ino, &imap,
+					XFS_IMAP_LOOKUP | imap_flags);
+		if (error)
 			return error;
 
 		/*
-		 * If the inode number maps to a block outside the bounds
-		 * of the file system then return NULL rather than calling
-		 * read_buf and panicing when we get an error from the
-		 * driver.
-		 */
-		if ((imap.im_blkno + imap.im_len) >
-		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_itobp: "
-					"(imap.im_blkno (0x%llx) "
-					"+ imap.im_len (0x%llx)) > "
-					" XFS_FSB_TO_BB(mp, "
-					"mp->m_sb.sb_dblocks) (0x%llx)",
-					(unsigned long long) imap.im_blkno,
-					(unsigned long long) imap.im_len,
-					XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-#endif /* DEBUG */
-			return XFS_ERROR(EINVAL);
-		}
-
-		/*
 		 * Fill in the fields in the inode that will be used to
 		 * map the inode to its buffer from now on.
 		 */
@@ -305,76 +305,10 @@ xfs_itobp(
 	}
 	ASSERT(bno == 0 || bno == imap.im_blkno);
 
-	/*
-	 * Read in the buffer.  If tp is NULL, xfs_trans_read_buf() will
-	 * default to just a read_buf() call.
-	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap.im_blkno,
-				   (int)imap.im_len, XFS_BUF_LOCK, &bp);
-	if (error) {
-#ifdef DEBUG
-		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_itobp: "
-				"xfs_trans_read_buf() returned error %d, "
-				"imap.im_blkno 0x%llx, imap.im_len 0x%llx",
-				error, (unsigned long long) imap.im_blkno,
-				(unsigned long long) imap.im_len);
-#endif /* DEBUG */
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
+	if (error)
 		return error;
-	}
-
-	/*
-	 * Validate the magic number and version of every inode in the buffer
-	 * (if DEBUG kernel) or the first inode in the buffer, otherwise.
-	 * No validation is done here in userspace (xfs_repair).
-	 */
-#if !defined(__KERNEL__)
-	ni = 0;
-#elif defined(DEBUG)
-	ni = BBTOB(imap.im_len) >> mp->m_sb.sb_inodelog;
-#else	/* usual case */
-	ni = 1;
-#endif
-
-	for (i = 0; i < ni; i++) {
-		int		di_ok;
-		xfs_dinode_t	*dip;
 
-		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
-					(i << mp->m_sb.sb_inodelog));
-		di_ok = be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
-		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
-						XFS_ERRTAG_ITOBP_INOTOBP,
-						XFS_RANDOM_ITOBP_INOTOBP))) {
-			if (imap_flags & XFS_IMAP_BULKSTAT) {
-				xfs_trans_brelse(tp, bp);
-				return XFS_ERROR(EINVAL);
-			}
-#ifdef DEBUG
-			cmn_err(CE_ALERT,
-					"Device %s - bad inode magic/vsn "
-					"daddr %lld #%d (magic=%x)",
-				XFS_BUFTARG_NAME(mp->m_ddev_targp),
-				(unsigned long long)imap.im_blkno, i,
-				be16_to_cpu(dip->di_core.di_magic));
-#endif
-			XFS_CORRUPTION_ERROR("xfs_itobp", XFS_ERRLEVEL_HIGH,
-					     mp, dip);
-			xfs_trans_brelse(tp, bp);
-			return XFS_ERROR(EFSCORRUPTED);
-		}
-	}
-
-	xfs_inobp_check(mp, bp);
-
-	/*
-	 * Mark the buffer as an inode buffer now that it looks good
-	 */
-	XFS_BUF_SET_VTYPE(bp, B_FS_INO);
-
-	/*
-	 * Set *dipp to point to the on-disk inode in the buffer.
-	 */
 	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
 	*bpp = bp;
 	return 0;
@@ -2678,14 +2612,31 @@ xfs_imap(
 	fsbno = imap->im_blkno ?
 		XFS_DADDR_TO_FSB(mp, imap->im_blkno) : NULLFSBLOCK;
 	error = xfs_dilocate(mp, tp, ino, &fsbno, &len, &off, flags);
-	if (error != 0) {
+	if (error)
 		return error;
-	}
+
 	imap->im_blkno = XFS_FSB_TO_DADDR(mp, fsbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, len);
 	imap->im_agblkno = XFS_FSB_TO_AGBNO(mp, fsbno);
 	imap->im_ioffset = (ushort)off;
 	imap->im_boffset = (ushort)(off << mp->m_sb.sb_inodelog);
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
 	return 0;
 }
 
