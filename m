Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RGklHY128411 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:46:47 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HC8Culdkr5dXtIoz (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 09:46:46 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCZXh-0007CB-Tl
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 16:46:46 +0000
Message-Id: <20120327164645.870931834@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 12:44:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/10] xfs: do not write the buffer from xfs_iflush
References: <20120327164400.967415009@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iflush-dont-write-buffer
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

Instead of writing the buffer directly from inside xfs_iflush return it to
the caller and let the caller decide what to do with the buffer.  Also
remove the pincount check in xfs_iflush that all non-blocking callers already
implement and the now unused flags parameter.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_inode.c      |   54 ++++++++++++++----------------------------------
 fs/xfs/xfs_inode.h      |    2 -
 fs/xfs/xfs_inode_item.c |   17 ++++++++++++++-
 fs/xfs/xfs_sync.c       |   29 +++++++++++++------------
 4 files changed, 48 insertions(+), 54 deletions(-)

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2012-03-25 16:41:19.481217746 +0200
+++ xfs/fs/xfs/xfs_inode.c	2012-03-25 16:41:21.647884454 +0200
@@ -2384,22 +2384,22 @@ cluster_corrupt_out:
 }
 
 /*
- * xfs_iflush() will write a modified inode's changes out to the
- * inode's on disk home.  The caller must have the inode lock held
- * in at least shared mode and the inode flush completion must be
- * active as well.  The inode lock will still be held upon return from
- * the call and the caller is free to unlock it.
- * The inode flush will be completed when the inode reaches the disk.
- * The flags indicate how the inode's buffer should be written out.
+ * Flush dirty inode metadata into the backing buffer.
+ *
+ * The caller must have the inode lock and the inode flush lock held.  The
+ * inode lock will still be held upon return to the caller, and the inode
+ * flush lock will be released after the inode has reached the disk.
+ *
+ * The caller must write out the buffer returned in *bpp and release it.
  */
 int
 xfs_iflush(
-	xfs_inode_t		*ip,
-	uint			flags)
+	struct xfs_inode	*ip,
+	struct xfs_buf		**bpp)
 {
-	xfs_buf_t		*bp;
-	xfs_dinode_t		*dip;
-	xfs_mount_t		*mp;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+	struct xfs_dinode	*dip;
 	int			error;
 
 	XFS_STATS_INC(xs_iflush_count);
@@ -2409,24 +2409,8 @@ xfs_iflush(
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 
-	mp = ip->i_mount;
+	*bpp = NULL;
 
-	/*
-	 * We can't flush the inode until it is unpinned, so wait for it if we
-	 * are allowed to block.  We know no one new can pin it, because we are
-	 * holding the inode lock shared and you need to hold it exclusively to
-	 * pin the inode.
-	 *
-	 * If we are not allowed to block, force the log out asynchronously so
-	 * that when we come back the inode will be unpinned. If other inodes
-	 * in the same cluster are dirty, they will probably write the inode
-	 * out for us if they occur after the log force completes.
-	 */
-	if (!(flags & SYNC_WAIT) && xfs_ipincount(ip)) {
-		xfs_iunpin(ip);
-		xfs_ifunlock(ip);
-		return EAGAIN;
-	}
 	xfs_iunpin_wait(ip);
 
 	/*
@@ -2458,8 +2442,7 @@ xfs_iflush(
 	/*
 	 * Get the buffer containing the on-disk inode.
 	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &bp,
-				(flags & SYNC_TRYLOCK) ? XBF_TRYLOCK : XBF_LOCK);
+	error = xfs_itobp(mp, NULL, ip, &dip, &bp, XBF_TRYLOCK);
 	if (error || !bp) {
 		xfs_ifunlock(ip);
 		return error;
@@ -2487,13 +2470,8 @@ xfs_iflush(
 	if (error)
 		goto cluster_corrupt_out;
 
-	if (flags & SYNC_WAIT)
-		error = xfs_bwrite(bp);
-	else
-		xfs_buf_delwri_queue(bp);
-
-	xfs_buf_relse(bp);
-	return error;
+	*bpp = bp;
+	return 0;
 
 corrupt_out:
 	xfs_buf_relse(bp);
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2012-03-25 16:41:00.701217399 +0200
+++ xfs/fs/xfs/xfs_inode.h	2012-03-25 16:41:21.647884454 +0200
@@ -528,7 +528,7 @@ int		xfs_iunlink(struct xfs_trans *, xfs
 
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 void		xfs_iunpin_wait(xfs_inode_t *);
-int		xfs_iflush(xfs_inode_t *, uint);
+int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_promote_inode(struct xfs_inode *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2012-03-25 16:41:00.711217397 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2012-03-25 16:41:21.651217787 +0200
@@ -506,6 +506,15 @@ xfs_inode_item_trylock(
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
 		return XFS_ITEM_LOCKED;
 
+	/*
+	 * Re-check the pincount now that we stabilized the value by
+	 * taking the ilock.
+	 */
+	if (xfs_ipincount(ip) > 0) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		return XFS_ITEM_PINNED;
+	}
+
 	if (!xfs_iflock_nowait(ip)) {
 		/*
 		 * inode has already been flushed to the backing buffer,
@@ -666,6 +675,8 @@ xfs_inode_item_push(
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
+	struct xfs_buf		*bp = NULL;
+	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
@@ -689,7 +700,11 @@ xfs_inode_item_push(
 	 * will pull the inode from the AIL, mark it clean and unlock the flush
 	 * lock.
 	 */
-	(void) xfs_iflush(ip, SYNC_TRYLOCK);
+	error = xfs_iflush(ip, &bp);
+	if (!error) {
+		xfs_buf_delwri_queue(bp);
+		xfs_buf_relse(bp);
+	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 }
 
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2012-03-25 16:41:21.304551114 +0200
+++ xfs/fs/xfs/xfs_sync.c	2012-03-25 16:45:50.037889431 +0200
@@ -645,10 +645,6 @@ xfs_reclaim_inode_grab(
  * (*) dgc: I don't think the clean, pinned state is possible but it gets
  * handled anyway given the order of checks implemented.
  *
- * As can be seen from the table, the return value of xfs_iflush() is not
- * sufficient to correctly decide the reclaim action here. The checks in
- * xfs_iflush() might look like duplicates, but they are not.
- *
  * Also, because we get the flush lock first, we know that any inode that has
  * been flushed delwri has had the flush completed by the time we check that
  * the inode is clean.
@@ -676,7 +672,8 @@ xfs_reclaim_inode(
 	struct xfs_perag	*pag,
 	int			sync_mode)
 {
-	int	error;
+	struct xfs_buf		*bp = NULL;
+	int			error;
 
 restart:
 	error = 0;
@@ -725,29 +722,33 @@ restart:
 	/*
 	 * Now we have an inode that needs flushing.
 	 *
-	 * We do a nonblocking flush here even if we are doing a SYNC_WAIT
-	 * reclaim as we can deadlock with inode cluster removal.
+	 * Note that xfs_iflush will never block on the inode buffer lock, as
 	 * xfs_ifree_cluster() can lock the inode buffer before it locks the
-	 * ip->i_lock, and we are doing the exact opposite here. As a result,
-	 * doing a blocking xfs_itobp() to get the cluster buffer will result
+	 * ip->i_lock, and we are doing the exact opposite here.  As a result,
+	 * doing a blocking xfs_itobp() to get the cluster buffer would result
 	 * in an ABBA deadlock with xfs_ifree_cluster().
 	 *
 	 * As xfs_ifree_cluser() must gather all inodes that are active in the
 	 * cache to mark them stale, if we hit this case we don't actually want
 	 * to do IO here - we want the inode marked stale so we can simply
-	 * reclaim it. Hence if we get an EAGAIN error on a SYNC_WAIT flush,
-	 * just unlock the inode, back off and try again. Hopefully the next
-	 * pass through will see the stale flag set on the inode.
+	 * reclaim it.  Hence if we get an EAGAIN error here,  just unlock the
+	 * inode, back off and try again.  Hopefully the next pass through will
+	 * see the stale flag set on the inode.
 	 */
-	error = xfs_iflush(ip, SYNC_TRYLOCK | sync_mode);
+	error = xfs_iflush(ip, &bp);
 	if (error == EAGAIN) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		/* backoff longer than in xfs_ifree_cluster */
 		delay(2);
 		goto restart;
 	}
-	xfs_iflock(ip);
 
+	if (!error) {
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+	}
+
+	xfs_iflock(ip);
 reclaim:
 	xfs_ifunlock(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
