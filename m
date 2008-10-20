Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 15:19:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KMIwPP010134
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:18:58 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EA4814490E3
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:20:42 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 59H1qfBQBEYbEAS0 for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:20:42 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9KMKeIF023701
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 00:20:40 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9KMKeXf023699
	for xfs@oss.sgi.com; Tue, 21 Oct 2008 00:20:40 +0200
Date: Tue, 21 Oct 2008 00:20:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] stop using xfs_itobp in xfs_iread
Message-ID: <20081020222040.GB23662@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The only caller of xfs_itobp that doesn't have i_blkno setup is now
the initial inode read.  It needs access to the whole xfs_imap so using
xfs_inotobp is not an option.  Instead opencode the buffer lookup in
xfs_iread and kill all the functionality for the initial map from
xfs_itobp.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6/fs/xfs/xfs_inode.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.c	2008-10-20 17:17:35.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.c	2008-10-20 17:26:03.000000000 +0200
@@ -261,15 +261,11 @@ xfs_inotobp(
  * If a non-zero error is returned, then the contents of bpp and
  * dipp are undefined.
  *
- * If the inode is new and has not yet been initialized, use xfs_imap()
- * to determine the size and location of the buffer to read from disk.
- * If the inode has already been mapped to its buffer and read in once,
- * then use the mapping information stored in the inode rather than
- * calling xfs_imap().  This allows us to avoid the overhead of looking
- * at the inode btree for small block file systems (see xfs_dilocate()).
- * We can tell whether the inode has been mapped in before by comparing
- * its disk block address to 0.  Only uninitialized inodes will have
- * 0 for the disk block address.
+ * The inode is expected to already been mapped to its buffer and read
+ * in once, thus we can use the mapping information stored in the inode
+ * rather than calling xfs_imap().  This allows us to avoid the overhead
+ * of looking at the inode btree for small block file systems
+ * (see xfs_dilocate()).
  */
 int
 xfs_itobp(
@@ -278,40 +274,19 @@ xfs_itobp(
 	xfs_inode_t	*ip,
 	xfs_dinode_t	**dipp,
 	xfs_buf_t	**bpp,
-	xfs_daddr_t	bno,
-	uint		imap_flags,
 	uint		buf_flags)
 {
 	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
 	int		error;
 
-	if (ip->i_blkno == (xfs_daddr_t)0) {
-		imap.im_blkno = bno;
-		error = xfs_imap(mp, tp, ip->i_ino, &imap,
-					XFS_IMAP_LOOKUP | imap_flags);
-		if (error)
-			return error;
+	ASSERT(ip->i_blkno != 0);
 
-		/*
-		 * Fill in the fields in the inode that will be used to
-		 * map the inode to its buffer from now on.
-		 */
-		ip->i_blkno = imap.im_blkno;
-		ip->i_len = imap.im_len;
-		ip->i_boffset = imap.im_boffset;
-	} else {
-		/*
-		 * We've already mapped the inode once, so just use the
-		 * mapping that we saved the first time.
-		 */
-		imap.im_blkno = ip->i_blkno;
-		imap.im_len = ip->i_len;
-		imap.im_boffset = ip->i_boffset;
-	}
-	ASSERT(bno == 0 || bno == imap.im_blkno);
+	imap.im_blkno = ip->i_blkno;
+	imap.im_len = ip->i_len;
+	imap.im_boffset = ip->i_boffset;
 
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, buf_flags, imap_flags);
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, buf_flags, 0);
 	if (error)
 		return error;
 
@@ -883,6 +858,7 @@ xfs_iread(
 	xfs_buf_t	*bp;
 	xfs_dinode_t	*dip;
 	xfs_inode_t	*ip;
+	xfs_imap_t	imap;
 	int		error;
 
 	ip = xfs_inode_alloc(mp, ino);
@@ -891,18 +867,33 @@ xfs_iread(
 
 	/*
 	 * Get pointer's to the on-disk inode and the buffer containing it.
-	 * If the inode number refers to a block outside the file system
-	 * then xfs_itobp() will return NULL.  In this case we should
-	 * return NULL as well.  Set i_blkno to 0 so that xfs_itobp() will
-	 * know that this is a new incore inode.
 	 */
-	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, imap_flags, XFS_BUF_LOCK);
+	imap.im_blkno = bno;
+	error = xfs_imap(mp, tp, ip->i_ino, &imap,
+				XFS_IMAP_LOOKUP | imap_flags);
 	if (error) {
 		xfs_idestroy(ip);
 		return error;
 	}
 
 	/*
+	 * Fill in the fields in the inode that will be used to
+	 * map the inode to its buffer from now on.
+	 */
+	ip->i_blkno = imap.im_blkno;
+	ip->i_len = imap.im_len;
+	ip->i_boffset = imap.im_boffset;
+	ASSERT(bno == 0 || bno == imap.im_blkno);
+
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
+	if (error) {
+		xfs_idestroy(ip);
+		return error;
+	}
+
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+
+	/*
 	 * If we got something that isn't an inode it means someone
 	 * (nfs or dmi) has a stale handle.
 	 */
@@ -1891,7 +1882,7 @@ xfs_iunlink(
 		 * Here we put the head pointer into our next pointer,
 		 * and then we fall through to point the head at us.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XFS_BUF_LOCK);
 		if (error)
 			return error;
 
@@ -1999,7 +1990,7 @@ xfs_iunlink_remove(
 		 * of dealing with the buffer when there is no need to
 		 * change it.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XFS_BUF_LOCK);
 		if (error) {
 			cmn_err(CE_WARN,
 				"xfs_iunlink_remove: xfs_itobp()  returned an error %d on %s.  Returning error.",
@@ -2061,7 +2052,7 @@ xfs_iunlink_remove(
 		 * Now last_ibp points to the buffer previous to us on
 		 * the unlinked list.  Pull us from the list.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XFS_BUF_LOCK);
 		if (error) {
 			cmn_err(CE_WARN,
 				"xfs_iunlink_remove: xfs_itobp()  returned an error %d on %s.  Returning error.",
@@ -2316,7 +2307,7 @@ xfs_ifree(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
+	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, XFS_BUF_LOCK);
 	if (error)
 		return error;
 
@@ -3229,7 +3220,7 @@ xfs_iflush(
 	/*
 	 * Get the buffer containing the on-disk inode.
 	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &bp, 0, 0,
+	error = xfs_itobp(mp, NULL, ip, &dip, &bp,
 				noblock ? XFS_BUF_TRYLOCK : XFS_BUF_LOCK);
 	if (error || !bp) {
 		xfs_ifunlock(ip);
Index: xfs-2.6/fs/xfs/xfs_inode.h
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-20 17:21:31.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-20 17:21:50.000000000 +0200
@@ -158,7 +158,7 @@ typedef struct xfs_icdinode {
 #define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
 
 /*
- * Flags for xfs_inotobp, xfs_itobp(), xfs_imap() and xfs_dilocate().
+ * Flags for xfs_inotobp, xfs_imap() and xfs_dilocate().
  */
 #define XFS_IMAP_LOOKUP		0x1
 #define XFS_IMAP_BULKSTAT	0x2
@@ -536,7 +536,7 @@ int		xfs_inotobp(struct xfs_mount *, str
 			    struct xfs_buf **, int *, uint);
 int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, struct xfs_dinode **,
-			  struct xfs_buf **, xfs_daddr_t, uint, uint);
+			  struct xfs_buf **, uint);
 void		xfs_dinode_from_disk(struct xfs_icdinode *,
 				     struct xfs_dinode_core *);
 void		xfs_dinode_to_disk(struct xfs_dinode_core *,
Index: xfs-2.6/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_log_recover.c	2008-10-20 17:21:16.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_log_recover.c	2008-10-20 17:21:28.000000000 +0200
@@ -3223,8 +3223,7 @@ xlog_recover_process_iunlinks(
 					 * next inode in the bucket.
 					 */
 					error = xfs_itobp(mp, NULL, ip, &dip,
-							&ibp, 0, 0,
-							XFS_BUF_LOCK);
+							&ibp, XFS_BUF_LOCK);
 					ASSERT(error || (dip != NULL));
 				}
 
