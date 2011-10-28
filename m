Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3hO8145498 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F7741CC6FC2
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qdWbWAewkGWqJEkr for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHq-00039V-4u
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:42 +0000
Message-Id: <20111028100342.093316239@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 36/45] xfs: remove log item from AIL in xfs_iflush after a
	shutdown
References: <20111028095423.796574703@bombadil.infradead.org>
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
to disk, which means the dquot items will stay in the AIL until we free
the inod. Currently that is not a problem, but a pending chance requires us
to empty the AIL before shutting down the filesystem, in which case this
behaviour is lethal.  Make sure to remove the log item from the AIL
to allow emptying the AIL on shutdown filesystems.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_iget.c  |   17 +----------------
 fs/xfs/xfs_inode.c |   17 +++++++++--------
 2 files changed, 10 insertions(+), 24 deletions(-)

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2011-10-27 22:39:59.605174201 +0200
+++ xfs/fs/xfs/xfs_iget.c	2011-10-27 22:40:11.904690190 +0200
@@ -124,23 +124,8 @@ xfs_inode_free(
 		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 
 	if (ip->i_itemp) {
-		/*
-		 * Only if we are shutting down the fs will we see an
-		 * inode still in the AIL. If it is there, we should remove
-		 * it to prevent a use-after-free from occurring.
-		 */
-		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
-		struct xfs_ail	*ailp = lip->li_ailp;
+		ASSERT(!(ip->i_itemp->ili_item.li_flags & XFS_LI_IN_AIL));
 
-		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
-				       XFS_FORCED_SHUTDOWN(ip->i_mount));
-		if (lip->li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&ailp->xa_lock);
-			if (lip->li_flags & XFS_LI_IN_AIL)
-				xfs_trans_ail_delete(ailp, lip);
-			else
-				spin_unlock(&ailp->xa_lock);
-		}
 		xfs_inode_item_destroy(ip);
 		ip->i_itemp = NULL;
 	}
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-10-27 22:39:59.613171175 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-10-27 22:40:11.904690190 +0200
@@ -2407,7 +2407,6 @@ xfs_iflush(
 	xfs_inode_t		*ip,
 	uint			flags)
 {
-	xfs_inode_log_item_t	*iip;
 	xfs_buf_t		*bp;
 	xfs_dinode_t		*dip;
 	xfs_mount_t		*mp;
@@ -2420,7 +2419,6 @@ xfs_iflush(
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
 
-	iip = ip->i_itemp;
 	mp = ip->i_mount;
 
 	/*
@@ -2457,13 +2455,14 @@ xfs_iflush(
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
-			iip->ili_format.ilf_fields = 0;
-		xfs_ifunlock(ip);
-		return XFS_ERROR(EIO);
+		error = XFS_ERROR(EIO);
+		goto abort_out;
 	}
 
 	/*
@@ -2510,11 +2509,13 @@ corrupt_out:
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
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
