Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1DDMsId051990 for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 07:22:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07637986570
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 05:25:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ALlXpiDedaDuDDr6 for
	<xfs@oss.sgi.com>; Sun, 13 Feb 2011 05:25:31 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PobxD-0004kt-8f
	for xfs@oss.sgi.com; Sun, 13 Feb 2011 13:25:31 +0000
Date: Sun, 13 Feb 2011 08:25:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: stop using xfs_trans_iget in the RT allocator
Message-ID: <20110213132531.GA18279@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

During mount we establish references to the RT inodes, which we keep for
the lifetime of the filesystem.  Instead of using xfs_trans_iget to grab
additional references when adding RT inodes to transactions use the
combination of xfs_ilock and xfs_trans_ijoin_ref, which archives the same
end result with less overhead.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-02-12 08:01:36.000000000 +0100
+++ xfs/fs/xfs/xfs_bmap.c	2011-02-13 13:02:19.790270331 +0100
@@ -2333,7 +2333,6 @@ xfs_bmap_rtalloc(
 	xfs_extlen_t	prod = 0;	/* product factor for allocators */
 	xfs_extlen_t	ralen = 0;	/* realtime allocation length */
 	xfs_extlen_t	align;		/* minimum allocation alignment */
-	xfs_inode_t	*ip;		/* bitmap incore inode */
 	xfs_rtblock_t	rtb;
 
 	mp = ap->ip->i_mount;
@@ -2370,11 +2369,8 @@ xfs_bmap_rtalloc(
 	/*
 	 * Lock out other modifications to the RT bitmap inode.
 	 */
-	error = xfs_trans_iget(mp, ap->tp, mp->m_sb.sb_rbmino, 0,
-			       XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP, &ip);
-	if (error)
-		return error;
-	ASSERT(ip == mp->m_rbmip);
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If it's an allocation to an empty file at offset 0,
Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2011-02-12 08:01:36.000000000 +0100
+++ xfs/fs/xfs/xfs_rtalloc.c	2011-02-13 13:02:19.794270078 +0100
@@ -76,7 +76,7 @@ xfs_growfs_rt_alloc(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_extlen_t	oblocks,	/* old count of blocks */
 	xfs_extlen_t	nblocks,	/* new count of blocks */
-	xfs_ino_t	ino)		/* inode number (bitmap/summary) */
+	xfs_inode_t	*ip)		/* inode (bitmap/summary) */
 {
 	xfs_fileoff_t	bno;		/* block number in file */
 	xfs_buf_t	*bp;		/* temporary buffer for zeroing */
@@ -86,7 +86,6 @@ xfs_growfs_rt_alloc(
 	xfs_fsblock_t	firstblock;	/* first block allocated in xaction */
 	xfs_bmap_free_t	flist;		/* list of freed blocks */
 	xfs_fsblock_t	fsbno;		/* filesystem block for bno */
-	xfs_inode_t	*ip;		/* pointer to incore inode */
 	xfs_bmbt_irec_t	map;		/* block map output */
 	int		nmap;		/* number of block maps */
 	int		resblks;	/* space reservation */
@@ -112,9 +111,9 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Lock the inode.
 		 */
-		if ((error = xfs_trans_iget(mp, tp, ino, 0,
-						XFS_ILOCK_EXCL, &ip)))
-			goto error_cancel;
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+
 		xfs_bmap_init(&flist, &firstblock);
 		/*
 		 * Allocate blocks to the bitmap file.
@@ -155,9 +154,8 @@ xfs_growfs_rt_alloc(
 			/*
 			 * Lock the bitmap inode.
 			 */
-			if ((error = xfs_trans_iget(mp, tp, ino, 0,
-							XFS_ILOCK_EXCL, &ip)))
-				goto error_cancel;
+			xfs_ilock(ip, XFS_ILOCK_EXCL);
+			xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 			/*
 			 * Get a buffer for the block.
 			 */
@@ -1854,7 +1852,6 @@ xfs_growfs_rt(
 	xfs_rtblock_t	bmbno;		/* bitmap block number */
 	xfs_buf_t	*bp;		/* temporary buffer */
 	int		error;		/* error return value */
-	xfs_inode_t	*ip;		/* bitmap inode, used as lock */
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
 	xfs_drfsbno_t	nrblocks;	/* new number of realtime blocks */
 	xfs_extlen_t	nrbmblocks;	/* new number of rt bitmap blocks */
@@ -1918,11 +1915,11 @@ xfs_growfs_rt(
 	/*
 	 * Allocate space to the bitmap and summary files, as necessary.
 	 */
-	if ((error = xfs_growfs_rt_alloc(mp, rbmblocks, nrbmblocks,
-			mp->m_sb.sb_rbmino)))
+	error = xfs_growfs_rt_alloc(mp, rbmblocks, nrbmblocks, mp->m_rbmip);
+	if (error)
 		return error;
-	if ((error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks,
-			mp->m_sb.sb_rsumino)))
+	error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks, mp->m_rsumip);
+	if (error)
 		return error;
 	/*
 	 * Allocate a new (fake) mount/sb.
@@ -1972,12 +1969,8 @@ xfs_growfs_rt(
 		/*
 		 * Lock out other callers by grabbing the bitmap inode lock.
 		 */
-		error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-				       XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP,
-				       &ip);
-		if (error)
-			goto error_cancel;
-		ASSERT(ip == mp->m_rbmip);
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin_ref(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
 		/*
 		 * Update the bitmap inode's size.
 		 */
@@ -1988,11 +1981,8 @@ xfs_growfs_rt(
 		/*
 		 * Get the summary inode into the transaction.
 		 */
-		error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0,
-				       XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM, &ip);
-		if (error)
-			goto error_cancel;
-		ASSERT(ip == mp->m_rsumip);
+		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin_ref(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
 		/*
 		 * Update the summary inode's size.
 		 */
@@ -2154,7 +2144,6 @@ xfs_rtfree_extent(
 	xfs_extlen_t	len)		/* length of extent freed */
 {
 	int		error;		/* error value */
-	xfs_inode_t	*ip;		/* bitmap file inode */
 	xfs_mount_t	*mp;		/* file system mount structure */
 	xfs_fsblock_t	sb;		/* summary file block number */
 	xfs_buf_t	*sumbp;		/* summary file block buffer */
@@ -2163,10 +2152,9 @@ xfs_rtfree_extent(
 	/*
 	 * Synchronize by locking the bitmap inode.
 	 */
-	error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-			       XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP, &ip);
-	if (error)
-		return error;
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+
 #if defined(__KERNEL__) && defined(DEBUG)
 	/*
 	 * Check to see that this whole range is currently allocated.
@@ -2199,10 +2187,10 @@ xfs_rtfree_extent(
 	 */
 	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
 	    mp->m_sb.sb_rextents) {
-		if (!(ip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
-			ip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
-		*(__uint64_t *)&ip->i_d.di_atime = 0;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
+			mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+		*(__uint64_t *)&mp->m_rbmip->i_d.di_atime = 0;
+		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
 	return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
