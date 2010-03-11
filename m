Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMfESu194492 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CFA2233AC3
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	hER3AT24Q6zMJFGo for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:46 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/19] xfs: remove invalid barrier optimization from xfs_fsync
Date: Fri, 12 Mar 2010 09:42:15 +1100
Message-Id: <1268347337-7160-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1268347337-7160-1-git-send-email-david@fromorbit.com>
References: <1268347337-7160-1-git-send-email-david@fromorbit.com>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

From: Christoph Hellwig <hch@lst.de>

>From e8b217e7530c6a073ac69f1c85b922d93fdf5647
Date: Tue, 2 Feb 2010 10:16:26 +1100
We always need to flush the disk write cache and can't skip it just because
the no inode attributes have changed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_vnodeops.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index ae2e44f..38a6324 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -597,7 +597,7 @@ xfs_fsync(
 {
 	xfs_trans_t	*tp;
 	int		error = 0;
-	int		log_flushed = 0, changed = 1;
+	int		log_flushed = 0;
 
 	xfs_itrace_entry(ip);
 
@@ -627,19 +627,11 @@ xfs_fsync(
 		 * disk yet, the inode will be still be pinned.  If it is,
 		 * force the log.
 		 */
-
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
 		if (xfs_ipincount(ip)) {
 			error = _xfs_log_force(ip->i_mount, (xfs_lsn_t)0,
 				      XFS_LOG_FORCE | XFS_LOG_SYNC,
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
@@ -674,7 +666,7 @@ xfs_fsync(
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
