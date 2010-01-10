Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0ANtNr8064783 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 17:55:23 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04C5CEF1ABD
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 15:56:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	y6tmZpL8OHlU4uxA for <xfs@oss.sgi.com>;
	Sun, 10 Jan 2010 15:56:16 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11344159-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 10:26:14 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NU7dk-0002qU-Hn
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 10:56:12 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NU7ZY-0007Yq-Jp
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 10:51:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: Avoid inodes in reclaim when flushing from inode
	cache
Date: Mon, 11 Jan 2010 10:51:46 +1100
Message-Id: <1263167508-9346-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263167508-9346-1-git-send-email-david@fromorbit.com>
References: <1263167508-9346-1-git-send-email-david@fromorbit.com>
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

THe reclaim code will handle flushing of dirty inodes before
reclaim occurs, so avoid them when determining whether an inode is
a candidate for flushing to disk when walking the radix trees.
This is based on a test patch from Christoph Hellwig.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 2ee1265..6946978 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -180,26 +180,31 @@ xfs_sync_inode_valid(
 	struct xfs_perag	*pag)
 {
 	struct inode		*inode = VFS_I(ip);
+	int			error = EFSCORRUPTED;
 
 	/* nothing to sync during shutdown */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		read_unlock(&pag->pag_ici_lock);
-		return EFSCORRUPTED;
-	}
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		goto out_unlock;
 
-	/* If we can't get a reference on the inode, it must be in reclaim. */
-	if (!igrab(inode)) {
-		read_unlock(&pag->pag_ici_lock);
-		return ENOENT;
-	}
-	read_unlock(&pag->pag_ici_lock);
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	error = ENOENT;
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
+		goto out_unlock;
 
-	if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
+	/* If we can't grab the inode, it must on it's way to reclaim. */
+	if (!igrab(inode))
+		goto out_unlock;
+
+	if (is_bad_inode(inode)) {
 		IRELE(ip);
-		return ENOENT;
+		goto out_unlock;
 	}
 
-	return 0;
+	/* inode is valid */
+	error = 0;
+out_unlock:
+	read_unlock(&pag->pag_ici_lock);
+	return error;
 }
 
 STATIC int
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
