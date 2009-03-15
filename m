Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBlIVi008382 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:47:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2574C1C4395B
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:46:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail11.adl2.internode.on.net
	[203.16.214.75]) by cuda.sgi.com with ESMTP id JGpZ7xW4ujrdGCRy
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:46:55 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	46133987-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:16:54 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Lionj-0006nJ-K7
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:46:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] [XFS] Factor out inode validation for sync
Date: Sun, 15 Mar 2009 22:46:40 +1100
Message-Id: <1237117603-26071-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1237117603-26071-1-git-send-email-david@fromorbit.com>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
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

Separate the validation of inodes found by the radix
tree walk from the radix tree lookup.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   56 ++++++++++++++++++++++++++----------------
 1 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index b3d4f7a..a83438a 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -120,6 +120,37 @@ out:
 	return error;
 }
 
+int
+xfs_sync_inode_valid(
+	xfs_mount_t	*mp,
+	xfs_inode_t	*ip)
+{
+	struct inode	*inode;
+	int		error;
+
+	/* nothing to sync during shutdown */
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return EFSCORRUPTED;
+
+	/*
+	 * If we can't get a reference on the inode, it must be in reclaim.
+	 * Leave it for the reclaim code to flush. Also avoid inodes that
+	 * haven't been fully initialised.
+	 */
+	error = ENOENT;
+	inode = VFS_I(ip);
+	if (!igrab(inode))
+		goto error;
+	if (is_bad_inode(inode) ||
+	    xfs_iflags_test(ip, XFS_INEW))
+		goto rele;
+	return 0;
+rele:
+	IRELE(ip);
+error:
+	return error;
+}
+
 /*
  * Sync all the inodes in the given AG according to the
  * direction given by the flags.
@@ -137,7 +168,6 @@ xfs_sync_inodes_ag(
 	int		last_error = 0;
 
 	do {
-		struct inode	*inode;
 		xfs_inode_t	*ip = NULL;
 
 		/*
@@ -166,27 +196,11 @@ xfs_sync_inodes_ag(
 			break;
 		}
 
-		/* nothing to sync during shutdown */
-		if (XFS_FORCED_SHUTDOWN(mp)) {
+		error = xfs_sync_inode_valid(mp, ip);
+		if (error) {
 			read_unlock(&pag->pag_ici_lock);
-			return 0;
-		}
-
-		/*
-		 * If we can't get a reference on the inode, it must be
-		 * in reclaim. Leave it for the reclaim code to flush.
-		 */
-		inode = VFS_I(ip);
-		if (!igrab(inode)) {
-			read_unlock(&pag->pag_ici_lock);
-			continue;
-		}
-		read_unlock(&pag->pag_ici_lock);
-
-		/* avoid new or bad inodes */
-		if (is_bad_inode(inode) ||
-		    xfs_iflags_test(ip, XFS_INEW)) {
-			IRELE(ip);
+			if (error == EFSCORRUPTED)
+				return 0;
 			continue;
 		}
 
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
