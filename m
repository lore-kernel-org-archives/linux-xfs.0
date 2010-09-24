Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OCUgNQ180916 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:30:43 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD23814FBFE5
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 05:44:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	BVAwlfiDEiRbR5Qp for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 05:44:16 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40176987-1927428
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 22:01:36 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Oz7R8-0007VG-NM
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:34 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Oz7R4-00060O-Fo
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/18] xfs: split out inode walk inode grabbing
Date: Fri, 24 Sep 2010 22:31:11 +1000
Message-Id: <1285331476-23015-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1285331476-23015-1-git-send-email-david@fromorbit.com>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When doing read side inode cache walks, the code to validate and
grab an inode is common to all callers. Split it out of the execute
callbacks in preparation for batching lookups. Similarly, split out
the inode reference dropping from the execute callbacks into the
main lookup look to be symmetric with the grab.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c    |   79 +++++++++++++++++-----------------------
 fs/xfs/quota/xfs_qm_syscalls.c |    9 -----
 2 files changed, 34 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 359422d..11c473f 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -39,6 +39,33 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+int
+xfs_inode_ag_walk_grab(
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	/* nothing to sync during shutdown */
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return EFSCORRUPTED;
+
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
+		return ENOENT;
+
+	/* If we can't grab the inode, it must on it's way to reclaim. */
+	if (!igrab(inode))
+		return ENOENT;
+
+	if (is_bad_inode(inode)) {
+		IRELE(ip);
+		return ENOENT;
+	}
+
+	/* inode is valid */
+	return 0;
+}
+
 
 STATIC int
 xfs_inode_ag_walk(
@@ -80,8 +107,14 @@ restart:
 		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
 			done = 1;
 
-		/* execute releases pag->pag_ici_lock */
+		if (xfs_inode_ag_walk_grab(ip)) {
+			read_unlock(&pag->pag_ici_lock);
+			continue;
+		}
+		read_unlock(&pag->pag_ici_lock);
+
 		error = execute(ip, pag, flags);
+		IRELE(ip);
 		if (error == EAGAIN) {
 			skipped++;
 			continue;
@@ -128,40 +161,6 @@ xfs_inode_ag_iterator(
 	return XFS_ERROR(last_error);
 }
 
-/* must be called with pag_ici_lock held and releases it */
-int
-xfs_sync_inode_valid(
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag)
-{
-	struct inode		*inode = VFS_I(ip);
-	int			error = EFSCORRUPTED;
-
-	/* nothing to sync during shutdown */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		goto out_unlock;
-
-	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	error = ENOENT;
-	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
-		goto out_unlock;
-
-	/* If we can't grab the inode, it must on it's way to reclaim. */
-	if (!igrab(inode))
-		goto out_unlock;
-
-	if (is_bad_inode(inode)) {
-		IRELE(ip);
-		goto out_unlock;
-	}
-
-	/* inode is valid */
-	error = 0;
-out_unlock:
-	read_unlock(&pag->pag_ici_lock);
-	return error;
-}
-
 STATIC int
 xfs_sync_inode_data(
 	struct xfs_inode	*ip,
@@ -172,10 +171,6 @@ xfs_sync_inode_data(
 	struct address_space *mapping = inode->i_mapping;
 	int			error = 0;
 
-	error = xfs_sync_inode_valid(ip, pag);
-	if (error)
-		return error;
-
 	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		goto out_wait;
 
@@ -192,7 +187,6 @@ xfs_sync_inode_data(
  out_wait:
 	if (flags & SYNC_WAIT)
 		xfs_ioend_wait(ip);
-	IRELE(ip);
 	return error;
 }
 
@@ -204,10 +198,6 @@ xfs_sync_inode_attr(
 {
 	int			error = 0;
 
-	error = xfs_sync_inode_valid(ip, pag);
-	if (error)
-		return error;
-
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_inode_clean(ip))
 		goto out_unlock;
@@ -226,7 +216,6 @@ xfs_sync_inode_attr(
 
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	IRELE(ip);
 	return error;
 }
 
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index ac11fbe..5784743 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -875,21 +875,14 @@ xfs_dqrele_inode(
 	struct xfs_perag	*pag,
 	int			flags)
 {
-	int			error;
-
 	/* skip quota inodes */
 	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
 	    ip == ip->i_mount->m_quotainfo->qi_gquotaip) {
 		ASSERT(ip->i_udquot == NULL);
 		ASSERT(ip->i_gdquot == NULL);
-		read_unlock(&pag->pag_ici_lock);
 		return 0;
 	}
 
-	error = xfs_sync_inode_valid(ip, pag);
-	if (error)
-		return error;
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
@@ -900,8 +893,6 @@ xfs_dqrele_inode(
 		ip->i_gdquot = NULL;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	IRELE(ip);
 	return 0;
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
