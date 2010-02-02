Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1329XiD204108 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 20:09:33 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D195B1C9B81C
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 18:10:41 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	cm9XUFBOHV79s4LF for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2010 18:10:41 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/10] xfs: remove invalid barrier optimization from xfs_fsync
Date: Wed,  3 Feb 2010 10:25:01 +1100
Message-Id: <1265153104-29680-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1265153104-29680-1-git-send-email-david@fromorbit.com>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
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
Cc: Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

We always need to flush the disk write cache and can't skip it just because
the no inode attributes have changed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_vnodeops.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

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
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
