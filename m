Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63GLObT105901 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 11:21:24 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ESnhdum4IpyhoACa (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 09:21:23 -0700 (PDT)
Date: Tue, 3 Jul 2012 12:21:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: merge xfs_itobp into xfs_imap_to_bp
Message-ID: <20120703162122.GA16775@infradead.org>
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

All callers of xfs_imap_to_bp want the dinode pointer, so let's calculate it
inside xfs_imap_to_bp.  Once that is done xfs_itobp becomes a fairly pointless
wrapper which can be replaced with direct calls to xfs_imap_to_bp.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_inode.c       |  131 ++++++++++++++++-------------------------------
 fs/xfs/xfs_inode.h       |    6 +-
 fs/xfs/xfs_itable.c      |    2 
 fs/xfs/xfs_log_recover.c |    2 
 fs/xfs/xfs_sync.c        |    4 -
 5 files changed, 54 insertions(+), 91 deletions(-)

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2012-06-21 18:07:04.093327438 +0200
+++ xfs/fs/xfs/xfs_inode.c	2012-07-02 12:14:18.929112302 +0200
@@ -132,23 +132,28 @@ xfs_inobp_check(
 #endif
 
 /*
- * Find the buffer associated with the given inode map
- * We do basic validation checks on the buffer once it has been
- * retrieved from disk.
+ * This routine is called to map an inode to the buffer containing the on-disk
+ * version of the inode.  It returns a pointer to the buffer containing the
+ * on-disk inode in the bpp parameter, and in the dipp parameter it returns a
+ * pointer to the on-disk inode within that buffer.
+ *
+ * If a non-zero error is returned, then the contents of bpp and dipp are
+ * undefined.
  */
-STATIC int
+int
 xfs_imap_to_bp(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	struct xfs_imap	*imap,
-	xfs_buf_t	**bpp,
-	uint		buf_flags,
-	uint		iget_flags)
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_imap		*imap,
+	struct xfs_dinode	**dipp,
+	struct xfs_buf		**bpp,
+	uint			buf_flags,
+	uint			iget_flags)
 {
-	int		error;
-	int		i;
-	int		ni;
-	xfs_buf_t	*bp;
+	struct xfs_buf		*bp;
+	int			error;
+	int			i;
+	int			ni;
 
 	buf_flags |= XBF_UNMAPPED;
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
@@ -189,8 +194,8 @@ xfs_imap_to_bp(
 				xfs_trans_brelse(tp, bp);
 				return XFS_ERROR(EINVAL);
 			}
-			XFS_CORRUPTION_ERROR("xfs_imap_to_bp",
-						XFS_ERRLEVEL_HIGH, mp, dip);
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
+					     mp, dip);
 #ifdef DEBUG
 			xfs_emerg(mp,
 				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
@@ -204,7 +209,9 @@ xfs_imap_to_bp(
 	}
 
 	xfs_inobp_check(mp, bp);
+
 	*bpp = bp;
+	*dipp = (struct xfs_dinode *)xfs_buf_offset(bp, imap->im_boffset);
 	return 0;
 }
 
@@ -240,63 +247,15 @@ xfs_inotobp(
 	if (error)
 		return error;
 
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, 0, imap_flags);
+	error = xfs_imap_to_bp(mp, tp, &imap, dipp, &bp, 0, imap_flags);
 	if (error)
 		return error;
 
-	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
 	*bpp = bp;
 	*offset = imap.im_boffset;
 	return 0;
 }
 
-
-/*
- * This routine is called to map an inode to the buffer containing
- * the on-disk version of the inode.  It returns a pointer to the
- * buffer containing the on-disk inode in the bpp parameter, and in
- * the dip parameter it returns a pointer to the on-disk inode within
- * that buffer.
- *
- * If a non-zero error is returned, then the contents of bpp and
- * dipp are undefined.
- *
- * The inode is expected to already been mapped to its buffer and read
- * in once, thus we can use the mapping information stored in the inode
- * rather than calling xfs_imap().  This allows us to avoid the overhead
- * of looking at the inode btree for small block file systems
- * (see xfs_imap()).
- */
-int
-xfs_itobp(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	xfs_dinode_t	**dipp,
-	xfs_buf_t	**bpp,
-	uint		buf_flags)
-{
-	xfs_buf_t	*bp;
-	int		error;
-
-	ASSERT(ip->i_imap.im_blkno != 0);
-
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp, buf_flags, 0);
-	if (error)
-		return error;
-
-	if (!bp) {
-		ASSERT(buf_flags & XBF_TRYLOCK);
-		ASSERT(tp == NULL);
-		*bpp = NULL;
-		return EAGAIN;
-	}
-
-	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
-	*bpp = bp;
-	return 0;
-}
-
 /*
  * Move inode type and inode format specific information from the
  * on-disk inode to the in-core inode.  For fifos, devs, and sockets
@@ -796,10 +755,9 @@ xfs_iread(
 	/*
 	 * Get pointers to the on-disk inode and the buffer containing it.
 	 */
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp, 0, iget_flags);
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0, iget_flags);
 	if (error)
 		return error;
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	/*
 	 * If we got something that isn't an inode it means someone
@@ -876,7 +834,7 @@ xfs_iread(
 	/*
 	 * Use xfs_trans_brelse() to release the buffer containing the
 	 * on-disk inode, because it was acquired with xfs_trans_read_buf()
-	 * in xfs_itobp() above.  If tp is NULL, this is just a normal
+	 * in xfs_imap_to_bp() above.  If tp is NULL, this is just a normal
 	 * brelse().  If we're within a transaction, then xfs_trans_brelse()
 	 * will only release the buffer if it is not dirty within the
 	 * transaction.  It will be OK to release the buffer in this case,
@@ -1355,7 +1313,8 @@ xfs_iunlink(
 		 * Here we put the head pointer into our next pointer,
 		 * and then we fall through to point the head at us.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0);
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
+				       0, 0);
 		if (error)
 			return error;
 
@@ -1429,16 +1388,16 @@ xfs_iunlink_remove(
 
 	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
 		/*
-		 * We're at the head of the list.  Get the inode's
-		 * on-disk buffer to see if there is anyone after us
-		 * on the list.  Only modify our next pointer if it
-		 * is not already NULLAGINO.  This saves us the overhead
-		 * of dealing with the buffer when there is no need to
-		 * change it.
+		 * We're at the head of the list.  Get the inode's on-disk
+		 * buffer to see if there is anyone after us on the list.
+		 * Only modify our next pointer if it is not already NULLAGINO.
+		 * This saves us the overhead of dealing with the buffer when
+		 * there is no need to change it.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0);
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
+				       0, 0);
 		if (error) {
-			xfs_warn(mp, "%s: xfs_itobp() returned error %d.",
+			xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
 				__func__, error);
 			return error;
 		}
@@ -1493,13 +1452,15 @@ xfs_iunlink_remove(
 			ASSERT(next_agino != NULLAGINO);
 			ASSERT(next_agino != 0);
 		}
+
 		/*
-		 * Now last_ibp points to the buffer previous to us on
-		 * the unlinked list.  Pull us from the list.
+		 * Now last_ibp points to the buffer previous to us on the
+		 * unlinked list.  Pull us from the list.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0);
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
+				       0, 0);
 		if (error) {
-			xfs_warn(mp, "%s: xfs_itobp(2) returned error %d.",
+			xfs_warn(mp, "%s: xfs_imap_to_bp(2) returned error %d.",
 				__func__, error);
 			return error;
 		}
@@ -1749,7 +1710,8 @@ xfs_ifree(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, 0);
+	error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &dip, &ibp,
+			       0, 0);
 	if (error)
 		return error;
 
@@ -2428,7 +2390,7 @@ xfs_iflush(
 	/*
 	 * For stale inodes we cannot rely on the backing buffer remaining
 	 * stale in cache for the remaining life of the stale inode and so
-	 * xfs_itobp() below may give us a buffer that no longer contains
+	 * xfs_imap_to_bp() below may give us a buffer that no longer contains
 	 * inodes below. We have to check this after ensuring the inode is
 	 * unpinned so that it is safe to reclaim the stale inode after the
 	 * flush call.
@@ -2454,7 +2416,8 @@ xfs_iflush(
 	/*
 	 * Get the buffer containing the on-disk inode.
 	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &bp, XBF_TRYLOCK);
+	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
+			       0);
 	if (error || !bp) {
 		xfs_ifunlock(ip);
 		return error;
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2012-06-15 14:25:55.808399998 +0200
+++ xfs/fs/xfs/xfs_inode.h	2012-07-02 12:14:18.929112302 +0200
@@ -560,9 +560,9 @@ do { \
 int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
 			    xfs_ino_t, struct xfs_dinode **,
 			    struct xfs_buf **, int *, uint);
-int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
-			  struct xfs_inode *, struct xfs_dinode **,
-			  struct xfs_buf **, uint);
+int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
+			       struct xfs_imap *, struct xfs_dinode **,
+			       struct xfs_buf **, uint, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, uint);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2012-06-15 14:25:55.288399985 +0200
+++ xfs/fs/xfs/xfs_itable.c	2012-07-02 12:13:03.402446086 +0200
@@ -555,7 +555,7 @@ xfs_bulkstat_single(
 
 	/*
 	 * note that requesting valid inode numbers which are not allocated
-	 * to inodes will most likely cause xfs_itobp to generate warning
+	 * to inodes will most likely cause xfs_imap_to_bp to generate warning
 	 * messages about bad magic numbers. This is ok. The fact that
 	 * the inode isn't actually an inode is handled by the
 	 * error check below. Done this way to make the usual case faster
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2012-06-26 23:12:24.683076907 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2012-07-02 12:13:03.405779419 +0200
@@ -3106,7 +3106,7 @@ xlog_recover_process_one_iunlink(
 	/*
 	 * Get the on disk inode to find the next inode in the bucket.
 	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, 0);
+	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0, 0);
 	if (error)
 		goto fail_iput;
 
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2012-06-26 22:52:05.509750859 +0200
+++ xfs/fs/xfs/xfs_sync.c	2012-07-02 12:13:03.405779419 +0200
@@ -712,8 +712,8 @@ restart:
 	 * Note that xfs_iflush will never block on the inode buffer lock, as
 	 * xfs_ifree_cluster() can lock the inode buffer before it locks the
 	 * ip->i_lock, and we are doing the exact opposite here.  As a result,
-	 * doing a blocking xfs_itobp() to get the cluster buffer would result
-	 * in an ABBA deadlock with xfs_ifree_cluster().
+	 * doing a blocking xfs_imap_to_bp() to get the cluster buffer would
+	 * result in an ABBA deadlock with xfs_ifree_cluster().
 	 *
 	 * As xfs_ifree_cluser() must gather all inodes that are active in the
 	 * cache to mark them stale, if we hit this case we don't actually want

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
