Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xOHU127430 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:25 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0BpypOS0ZPVe1qCd for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIo-0001Zg-E0
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004XL-BE
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/37] xfs: remove log item from AIL in xfs_iflush after a
	shutdown
Date: Mon, 23 Apr 2012 15:58:32 +1000
Message-Id: <1335160747-17254-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

If a filesystem has been forced shutdown we are never going to write inodes
to disk, which means the inode items will stay in the AIL until we free
the inode. Currently that is not a problem, but a pending change requires us
to empty the AIL before shutting down the filesystem. In that case leaving
the inode in the AIL is lethal. Make sure to remove the log item from the AIL
to allow emptying the AIL on shutdown filesystems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c |    3 +--
 fs/xfs/xfs_iget.c  |   18 +-----------------
 fs/xfs/xfs_inode.c |   17 +++++++++--------
 fs/xfs/xfs_sync.c  |    1 +
 4 files changed, 12 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e2f6f7c..786a61e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -915,8 +915,7 @@ xfs_qm_dqflush(
 
 		spin_lock(&mp->m_ail->xa_lock);
 		if (lip->li_flags & XFS_LI_IN_AIL)
-			xfs_trans_ail_delete(mp->m_ail, lip,
-					     SHUTDOWN_CORRUPT_INCORE);
+			xfs_trans_ail_delete(mp->m_ail, lip);
 		else
 			spin_unlock(&mp->m_ail->xa_lock);
 
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index bcc6c24..ab89ca7 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bc46c0a..00f9c2f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
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
 
 
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 6a7987f..c07cbb4 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -782,6 +782,7 @@ restart:
 		goto reclaim;
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
+		xfs_iflush_abort(ip);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip)) {
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
