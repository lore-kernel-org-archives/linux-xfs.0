Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3iK8145539 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2755C203865
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tfCROLzB29BfxPpD for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHq-0003B3-L0
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:42 +0000
Message-Id: <20111028100342.601864545@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:55:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 39/45] xfs: do not write the buffer from xfs_iflush
References: <20111028095423.796574703@bombadil.infradead.org>
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
the caller and let the caller decide what to do with it.  While we're at
it also remove the pincount check that all non-blocking callers already
implement and the new now unused flags parameter.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_inode.c      |   56 +++++++++++++++---------------------------------
 fs/xfs/xfs_inode.h      |    2 -
 fs/xfs/xfs_inode_item.c |   17 +++++++++++++-
 fs/xfs/xfs_sync.c       |   12 +++++-----
 4 files changed, 41 insertions(+), 46 deletions(-)

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-10-27 22:40:11.904690190 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-10-27 22:40:13.673170747 +0200
@@ -2394,22 +2394,24 @@ cluster_corrupt_out:
 }
 
 /*
- * xfs_iflush() will write a modified inode's changes out to the
- * inode's on disk home.  The caller must have the inode lock held
- * in at least shared mode and the inode flush completion must be
- * active as well.  The inode lock will still be held upon return from
- * the call and the caller is free to unlock it.
- * The inode flush will be completed when the inode reaches the disk.
- * The flags indicate how the inode's buffer should be written out.
+ * Format a modified inode's changes out to the backing buffer.
+ *
+ * The caller must have the inode lock (shared or exclusive) and inode flush
+ * lock held.  The inode lock will still be held upon return from the call
+ * and the caller is free to unlock it. The inode flush lock will be released
+ * when the inode reaches the disk.
+ *
+ * The caller must write out the buffer returned in *bpp and unlocked it using
+ * xfs_buf_relse.
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
@@ -2419,24 +2421,8 @@ xfs_iflush(
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
 
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
@@ -2468,8 +2454,7 @@ xfs_iflush(
 	/*
 	 * Get the buffer containing the on-disk inode.
 	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &bp,
-				(flags & SYNC_TRYLOCK) ? XBF_TRYLOCK : XBF_LOCK);
+	error = xfs_itobp(mp, NULL, ip, &dip, &bp, XBF_TRYLOCK);
 	if (error || !bp) {
 		xfs_ifunlock(ip);
 		return error;
@@ -2497,13 +2482,8 @@ xfs_iflush(
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
--- xfs.orig/fs/xfs/xfs_inode.h	2011-10-27 22:39:59.613171175 +0200
+++ xfs/fs/xfs/xfs_inode.h	2011-10-27 22:40:13.673170747 +0200
@@ -530,7 +530,7 @@ int		xfs_iunlink(struct xfs_trans *, xfs
 
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 void		xfs_iunpin_wait(xfs_inode_t *);
-int		xfs_iflush(xfs_inode_t *, uint);
+int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-10-27 22:39:59.621171049 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2011-10-27 22:40:13.681172022 +0200
@@ -552,6 +552,15 @@ xfs_inode_item_trylock(
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
@@ -716,6 +725,8 @@ xfs_inode_item_push(
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
+	struct xfs_buf		*bp = NULL;
+	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
@@ -740,7 +751,11 @@ xfs_inode_item_push(
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
--- xfs.orig/fs/xfs/xfs_sync.c	2011-10-27 22:40:12.489171652 +0200
+++ xfs/fs/xfs/xfs_sync.c	2011-10-27 22:40:13.685172888 +0200
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
@@ -727,12 +724,15 @@ restart:
 	 * just unlock the inode, back off and try again. Hopefully the next
 	 * pass through will see the stale flag set on the inode.
 	 */
-	error = xfs_iflush(ip, SYNC_TRYLOCK | sync_mode);
+	error = xfs_iflush(ip, &bp);
 	if (error == EAGAIN) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		/* backoff longer than in xfs_ifree_cluster */
 		delay(2);
 		goto restart;
+	} else if (!error) {
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
 	}
 	xfs_iflock(ip);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
