Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8M6hwwY050862 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 01:43:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9A64903EC
	for <xfs@oss.sgi.com>; Tue, 21 Sep 2010 23:44:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	pk3CCYnfr2wvd9oi for <xfs@oss.sgi.com>;
	Tue, 21 Sep 2010 23:44:50 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39842548-1927428
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 16:14:49 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OyJ4H-0003u4-19
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:37 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OyJ4E-0002lL-Qs
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/16] xfs: implement batched inode lookups for AG walking
Date: Wed, 22 Sep 2010 16:44:25 +1000
Message-Id: <1285137869-10310-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1285137869-10310-1-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
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

With the reclaim code separated from the generic walking code, it is
simple to implement batched lookups for the generic walk code.
Separate out the inode validation from the execute operations and
modify the tree lookups to get a batch of inodes at a time.

Reclaim operations will be optimised separately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c    |  104 +++++++++++++++++++++++-----------------
 fs/xfs/linux-2.6/xfs_sync.h    |    3 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   26 +++++-----
 3 files changed, 75 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 7737a13..227ecde 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -39,11 +39,19 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+/*
+ * The inode lookup is done in batches to keep the amount of lock traffic and
+ * radix tree lookups to a minimum. The batch size is a trade off between
+ * lookup reduction and stack usage. This is in the reclaim path, so we can't
+ * be too greedy.
+ */
+#define XFS_LOOKUP_BATCH	32
 
 STATIC int
 xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
+	int			(*grab)(struct xfs_inode *ip),
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags)
@@ -52,48 +60,68 @@ xfs_inode_ag_walk(
 	int			last_error = 0;
 	int			skipped;
 	int			done;
+	int			nr_found;
 
 restart:
 	done = 0;
 	skipped = 0;
 	first_index = 0;
+	nr_found = 0;
 	do {
 		int		error = 0;
-		int		nr_found;
-		xfs_inode_t	*ip;
+		int		i;
+		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
 
 		read_lock(&pag->pag_ici_lock);
 		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-				(void **)&ip, first_index, 1);
+					(void **)batch, first_index,
+					XFS_LOOKUP_BATCH);
 		if (!nr_found) {
 			read_unlock(&pag->pag_ici_lock);
 			break;
 		}
 
 		/*
-		 * Update the index for the next lookup. Catch overflows
-		 * into the next AG range which can occur if we have inodes
-		 * in the last block of the AG and we are currently
-		 * pointing to the last inode.
+		 * Grab the inodes before we drop the lock. if we found
+		 * nothing, nr == 0 and the loop will be skipped.
 		 */
-		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-			done = 1;
-
-		/* execute releases pag->pag_ici_lock */
-		error = execute(ip, pag, flags);
-		if (error == EAGAIN) {
-			skipped++;
-			continue;
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_inode *ip = batch[i];
+
+			if (done || grab(ip))
+				batch[i] = NULL;
+
+			/*
+			 * Update the index for the next lookup. Catch overflows
+			 * into the next AG range which can occur if we have inodes
+			 * in the last block of the AG and we are currently
+			 * pointing to the last inode.
+			 */
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+				done = 1;
+		}
+
+		/* unlock now we've grabbed the inodes. */
+		read_unlock(&pag->pag_ici_lock);
+
+		for (i = 0; i < nr_found; i++) {
+			if (!batch[i])
+				continue;
+			error = execute(batch[i], pag, flags);
+			if (error == EAGAIN) {
+				skipped++;
+				continue;
+			}
+			if (error && last_error != EFSCORRUPTED)
+				last_error = error;
 		}
-		if (error)
-			last_error = error;
 
 		/* bail out if the filesystem is corrupted.  */
 		if (error == EFSCORRUPTED)
 			break;
 
-	} while (!done);
+	} while (nr_found && !done);
 
 	if (skipped) {
 		delay(1);
@@ -105,6 +133,7 @@ restart:
 int
 xfs_inode_ag_iterator(
 	struct xfs_mount	*mp,
+	int			(*grab)(struct xfs_inode *ip),
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags)
@@ -117,7 +146,7 @@ xfs_inode_ag_iterator(
 	ag = 0;
 	while ((pag = xfs_perag_get(mp, ag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, flags);
+		error = xfs_inode_ag_walk(mp, pag, grab, execute, flags);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -128,38 +157,31 @@ xfs_inode_ag_iterator(
 	return XFS_ERROR(last_error);
 }
 
-/* must be called with pag_ici_lock held and releases it */
 int
-xfs_sync_inode_valid(
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag)
+xfs_sync_inode_grab(
+	struct xfs_inode	*ip)
 {
 	struct inode		*inode = VFS_I(ip);
-	int			error = EFSCORRUPTED;
 
 	/* nothing to sync during shutdown */
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		goto out_unlock;
+		return EFSCORRUPTED;
 
 	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	error = ENOENT;
 	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
-		goto out_unlock;
+		return ENOENT;
 
 	/* If we can't grab the inode, it must on it's way to reclaim. */
 	if (!igrab(inode))
-		goto out_unlock;
+		return ENOENT;
 
 	if (is_bad_inode(inode)) {
 		IRELE(ip);
-		goto out_unlock;
+		return ENOENT;
 	}
 
 	/* inode is valid */
-	error = 0;
-out_unlock:
-	read_unlock(&pag->pag_ici_lock);
-	return error;
+	return 0;
 }
 
 STATIC int
@@ -172,10 +194,6 @@ xfs_sync_inode_data(
 	struct address_space *mapping = inode->i_mapping;
 	int			error = 0;
 
-	error = xfs_sync_inode_valid(ip, pag);
-	if (error)
-		return error;
-
 	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		goto out_wait;
 
@@ -204,10 +222,6 @@ xfs_sync_inode_attr(
 {
 	int			error = 0;
 
-	error = xfs_sync_inode_valid(ip, pag);
-	if (error)
-		return error;
-
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_inode_clean(ip))
 		goto out_unlock;
@@ -242,7 +256,8 @@ xfs_sync_data(
 
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 
-	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags);
+	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_grab,
+					xfs_sync_inode_data, flags);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -260,7 +275,8 @@ xfs_sync_attr(
 {
 	ASSERT((flags & ~SYNC_WAIT) == 0);
 
-	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags);
+	return xfs_inode_ag_iterator(mp, xfs_sync_inode_grab,
+					xfs_sync_inode_attr, flags);
 }
 
 STATIC int
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index e8a3528..8b73fb4 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -47,8 +47,9 @@ void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
 
-int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
+int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
+	int (*grab)(struct xfs_inode *ip),
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
 	int flags);
 
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index ac11fbe..8d2fdbe 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -868,28 +868,27 @@ xfs_qm_export_flags(
 	return (uflags);
 }
 
-
 STATIC int
-xfs_dqrele_inode(
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	int			flags)
+xfs_dqrele_inode_grab(
+	struct xfs_inode	*ip)
 {
-	int			error;
-
 	/* skip quota inodes */
 	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
 	    ip == ip->i_mount->m_quotainfo->qi_gquotaip) {
 		ASSERT(ip->i_udquot == NULL);
 		ASSERT(ip->i_gdquot == NULL);
-		read_unlock(&pag->pag_ici_lock);
-		return 0;
+		return ENOENT;
 	}
 
-	error = xfs_sync_inode_valid(ip, pag);
-	if (error)
-		return error;
+	return xfs_sync_inode_grab(ip);
+}
 
+STATIC int
+xfs_dqrele_inode(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags)
+{
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
@@ -918,7 +917,8 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags);
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode_grab,
+					xfs_dqrele_inode, flags);
 }
 
 /*------------------------------------------------------------------------*/
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
