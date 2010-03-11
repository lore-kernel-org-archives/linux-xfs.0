Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMf4bS194382 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3ED8E1D2DEB1
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	DCAbftF9F2bAO7s8 for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:36 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/19] xfs: fix stale inode flush avoidance
Date: Fri, 12 Mar 2010 09:42:11 +1100
Message-Id: <1268347337-7160-14-git-send-email-david@fromorbit.com>
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

>From 4b6a46882cca8349e8942e2650c33b11bc571c92
Date: Mon, 11 Jan 2010 11:45:21 +0000
When reclaiming stale inodes, we need to guarantee that inodes are
unpinned before returning with a "clean" status. If we don't we can
reclaim inodes that are pinned, leading to use after free in the
transaction subsystem as transactions complete.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_inode.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 13d7d21..523a1ae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2878,13 +2878,9 @@ xfs_iflush(
 
 	/*
 	 * If the inode isn't dirty, then just release the inode flush lock and
-	 * do nothing. Treat stale inodes the same; we cannot rely on the
-	 * backing buffer remaining stale in cache for the remaining life of
-	 * the stale inode and so xfs_itobp() below may give us a buffer that
-	 * no longer contains inodes below. Doing this stale check here also
-	 * avoids forcing the log on pinned, stale inodes.
+	 * do nothing.
 	 */
-	if (xfs_inode_clean(ip) || xfs_iflags_test(ip, XFS_ISTALE)) {
+	if (xfs_inode_clean(ip)) {
 		xfs_ifunlock(ip);
 		return 0;
 	}
@@ -2908,6 +2904,19 @@ xfs_iflush(
 	xfs_iunpin_wait(ip);
 
 	/*
+	 * For stale inodes we cannot rely on the backing buffer remaining
+	 * stale in cache for the remaining life of the stale inode and so
+	 * xfs_itobp() below may give us a buffer that no longer contains
+	 * inodes below. We have to check this after ensuring the inode is
+	 * unpinned so that it is safe to reclaim the stale inode after the
+	 * flush call.
+	 */
+	if (xfs_iflags_test(ip, XFS_ISTALE)) {
+		xfs_ifunlock(ip);
+		return 0;
+	}
+
+	/*
 	 * This may have been unpinned because the filesystem is shutting
 	 * down forcibly. If that's the case we must not write this inode
 	 * to disk, because the log record didn't make it to disk!
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
