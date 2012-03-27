Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RGkjVg128322 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:46:45 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	sWV2G5V7QOWF56vV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 09:46:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCZXg-00079z-FQ
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 16:46:44 +0000
Message-Id: <20120327164644.420702935@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 12:44:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/10] xfs: remove log item from AIL in xfs_iflush after a
	shutdown
References: <20120327164400.967415009@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-delete-inode-from-ail-earlier
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

If a filesystem has been forced shutdown we are never going to write inodes
to disk, which means the inode items will stay in the AIL until we free
the inode. Currently that is not a problem, but a pending change requires us
to empty the AIL before shutting down the filesystem. In that case leaving
the inode in the AIL is lethal. Make sure to remove the log item from the AIL
to allow emptying the AIL on shutdown filesystems.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_iget.c  |   18 +-----------------
 fs/xfs/xfs_inode.c |   17 +++++++++--------
 fs/xfs/xfs_sync.c  |    1 +
 3 files changed, 11 insertions(+), 25 deletions(-)

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2012-03-16 12:44:56.037030588 +0100
+++ xfs/fs/xfs/xfs_inode.c	2012-03-16 12:47:03.697032954 +0100
@@ -2397,7 +2397,6 @@ xfs_iflush(
 	xfs_inode_t		*ip,
 	uint			flags)
 {
-	xfs_inode_log_item_t	*iip;
 	xfs_buf_t		*bp;
 	xfs_dinode_t		*dip;
 	xfs_mount_t		*mp;
@@ -2410,7 +2409,6 @@ xfs_iflush(
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 
-	iip = ip->i_itemp;
 	mp = ip->i_mount;
 
 	/*
@@ -2447,13 +2445,14 @@ xfs_iflush(
 	/*
 	 * This may have been unpinned because the filesystem is shutting
 	 * down forcibly. If that's the case we must not write this inode
-	 * to disk, because the log record didn't make it to disk!
+	 * to disk, because the log record didn't make it to disk.
+	 *
+	 * We also have to remove the log item from the AIL in this case,
+	 * as we wait for an empty AIL as part of the unmount process.
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
-		if (iip)
-			iip->ili_fields = 0;
-		xfs_ifunlock(ip);
-		return XFS_ERROR(EIO);
+		error = XFS_ERROR(EIO);
+		goto abort_out;
 	}
 
 	/*
@@ -2500,11 +2499,13 @@ corrupt_out:
 	xfs_buf_relse(bp);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 cluster_corrupt_out:
+	error = XFS_ERROR(EFSCORRUPTED);
+abort_out:
 	/*
 	 * Unlocks the flush lock
 	 */
 	xfs_iflush_abort(ip);
-	return XFS_ERROR(EFSCORRUPTED);
+	return error;
 }
 
 
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2012-03-16 12:44:56.047030587 +0100
+++ xfs/fs/xfs/xfs_iget.c	2012-03-16 12:47:03.697032954 +0100
@@ -123,23 +123,7 @@ xfs_inode_free(
 		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 
 	if (ip->i_itemp) {
-		/*
-		 * Only if we are shutting down the fs will we see an
-		 * inode still in the AIL. If it is there, we should remove
-		 * it to prevent a use-after-free from occurring.
-		 */
-		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
-		struct xfs_ail	*ailp = lip->li_ailp;
-
-		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
-				       XFS_FORCED_SHUTDOWN(ip->i_mount));
-		if (lip->li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&ailp->xa_lock);
-			if (lip->li_flags & XFS_LI_IN_AIL)
-				xfs_trans_ail_delete(ailp, lip);
-			else
-				spin_unlock(&ailp->xa_lock);
-		}
+		ASSERT(!(ip->i_itemp->ili_item.li_flags & XFS_LI_IN_AIL));
 		xfs_inode_item_destroy(ip);
 		ip->i_itemp = NULL;
 	}
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2012-03-16 12:44:57.707030619 +0100
+++ xfs/fs/xfs/xfs_sync.c	2012-03-16 12:47:03.697032954 +0100
@@ -783,6 +783,7 @@ restart:
 		goto reclaim;
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
+		xfs_iflush_abort(ip);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip)) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
