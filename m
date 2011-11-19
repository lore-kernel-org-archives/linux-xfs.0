Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJIFjUQ072064 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 12:15:45 -0600
Message-Id: <20111119181543.809288814@bombadil.infradead.org>
Date: Sat, 19 Nov 2011 13:13:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/9] [PATCH 3/9] xfs: fix ->write_inode return values
References: <20111119181336.964593075@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0003-xfs-fix-write_inode-return-values.patch
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
To: stable@vger.kernel.org
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com

Currently we always redirty an inode that was attempted to be written out
synchronously but has been cleaned by an AIL pushed internall, which is
rather bogus.  Fix that by doing the i_update_core check early on and
return 0 for it.  Also include async calls for it, as doing any work for
those is just as pointless.  While we're at it also fix the sign for the
EIO return in case of a filesystem shutdown, and fix the completely
non-sensical locking around xfs_log_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
(cherry picked from commit 297db93bb74cf687510313eb235a7aec14d67e97)

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   34 +++++++++-------------------------
 1 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 347cae9..28de70b 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -878,33 +878,17 @@ xfs_log_inode(
 	struct xfs_trans	*tp;
 	int			error;
 
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
 	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
-
 	if (error) {
 		xfs_trans_cancel(tp, 0);
-		/* we need to return with the lock hold shared */
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
 		return error;
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * Note - it's possible that we might have pushed ourselves out of the
-	 * way during trans_reserve which would flush the inode.  But there's
-	 * no guarantee that the inode buffer has actually gone out yet (it's
-	 * delwri).  Plus the buffer could be pinned anyway if it's part of
-	 * an inode in another recent transaction.  So we play it safe and
-	 * fire off the transaction anyway.
-	 */
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_commit(tp, 0);
-	xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
-
-	return error;
+	return xfs_trans_commit(tp, 0);
 }
 
 STATIC int
@@ -919,7 +903,9 @@ xfs_fs_write_inode(
 	trace_xfs_write_inode(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return -XFS_ERROR(EIO);
+	if (!ip->i_update_core)
+		return 0;
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		/*
@@ -930,12 +916,10 @@ xfs_fs_write_inode(
 		 * of synchronous log foces dramatically.
 		 */
 		xfs_ioend_wait(ip);
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		if (ip->i_update_core) {
-			error = xfs_log_inode(ip);
-			if (error)
-				goto out_unlock;
-		}
+		error = xfs_log_inode(ip);
+		if (error)
+			goto out;
+		return 0;
 	} else {
 		/*
 		 * We make this non-blocking if the inode is contended, return
-- 
1.7.7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
