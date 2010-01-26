Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0QLblnU148005 for <xfs@oss.sgi.com>; Tue, 26 Jan 2010 15:37:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83AC81C7EEC5
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2010 13:38:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jDW0EzRBAedwqewj for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2010 13:38:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NZt7b-0003wY-JR
	for xfs@oss.sgi.com; Tue, 26 Jan 2010 21:38:51 +0000
Date: Tue, 26 Jan 2010 16:38:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove invalid barrier optimization from xfs_fsync
Message-ID: <20100126213851.GA14927@infradead.org>
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

We always need to flush the disk write cache and can't skip it just because
the no inode attributes have changed.


Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index fd108b7..43241e2 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -597,7 +597,7 @@ xfs_fsync(
 {
 	xfs_trans_t	*tp;
 	int		error = 0;
-	int		log_flushed = 0, changed = 1;
+	int		log_flushed = 0;
 
 	xfs_itrace_entry(ip);
 
@@ -627,18 +627,10 @@ xfs_fsync(
 		 * disk yet, the inode will be still be pinned.  If it is,
 		 * force the log.
 		 */
-
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
 		if (xfs_ipincount(ip)) {
 			error = _xfs_log_force(ip->i_mount, XFS_LOG_SYNC,
 					       &log_flushed);
-		} else {
-			/*
-			 * If the inode is not pinned and nothing has changed
-			 * we don't need to flush the cache.
-			 */
-			changed = 0;
 		}
 	} else	{
 		/*
@@ -673,7 +665,7 @@ xfs_fsync(
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
-	if ((ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
+	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {
 		/*
 		 * If the log write didn't issue an ordered tag we need
 		 * to flush the disk cache for the data device now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
