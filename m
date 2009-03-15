Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FJ7x14032114 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 14:08:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E1BA19ABB0
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 12:07:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail05.adl2.internode.on.net
	[203.16.214.69]) by cuda.sgi.com with ESMTP id Y4nHgbi75qZECCMf
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 12:07:16 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	43731180-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:16:54 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Lionj-0006nV-WF
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:46:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] [XFS] introduce a per-ag inode iterator
Date: Sun, 15 Mar 2009 22:46:43 +1100
Message-Id: <1237117603-26071-7-git-send-email-david@fromorbit.com>
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

Given that we walk across the per-ag inode lists so
often, it makes sense to introduce an iterator for this.
Break the operations on each inode into two operations -
a lookup validation step to confirm the inode is good to
be used and an execution step that performs the operation
on the inode.

Convert the sync and reclaim code to use this new iterator.
At some point the quota sync needs to be converted as well.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |  320 ++++++++++++++++++++-----------------------
 1 files changed, 149 insertions(+), 171 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index f9c2a56..45dfff9 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -48,6 +48,132 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+
+STATIC xfs_inode_t *
+xfs_inode_ag_lookup(
+	xfs_mount_t	*mp,
+	xfs_perag_t	*pag,
+	int		(*lookup)(xfs_mount_t *mp, xfs_inode_t *ip),
+	uint32_t	*first_index,
+	int		tag)
+{
+	int		nr_found;
+	xfs_inode_t	*ip;
+	int		error = -ENOENT;
+
+	/*
+	 * use a gang lookup to find the next inode in the tree
+	 * as the tree is sparse and a gang lookup walks to find
+	 * the number of objects requested.
+	 */
+	read_lock(&pag->pag_ici_lock);
+	if (tag == -1) {
+		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+				(void**)&ip, *first_index, 1);
+	} else {
+		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
+				(void**)&ip, *first_index, 1, tag);
+	}
+	if (!nr_found)
+		goto unlock;
+
+	/*
+	 * Update the index for the next lookup. Catch overflows
+	 * into the next AG range which can occur if we have inodes
+	 * in the last block of the AG and we are currently
+	 * pointing to the last inode.
+	 */
+	*first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+	if (*first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+		goto unlock;
+
+
+	error = lookup(mp, ip);
+	read_unlock(&pag->pag_ici_lock);
+	if (error)
+		return ERR_PTR(error);
+	return ip;
+
+unlock:
+	read_unlock(&pag->pag_ici_lock);
+	return NULL;
+}
+
+STATIC int
+xfs_inode_ag_walk(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	ag,
+	int		(*lookup)(xfs_mount_t *mp, xfs_inode_t *ip),
+	int		(*execute)(xfs_inode_t *ip, int flags),
+	int		flags,
+	int		tag)
+{
+	xfs_perag_t	*pag = &mp->m_perag[ag];
+	uint32_t	first_index;
+	int		last_error = 0;
+	int		skipped;
+
+restart:
+	skipped = 0;
+	first_index = 0;
+	do {
+		int		error = 0;
+		xfs_inode_t	*ip;
+
+		ip = xfs_inode_ag_lookup(mp, pag, lookup, &first_index, tag);
+		if (!ip)
+			break;
+		if (IS_ERR(ip))
+			continue;
+
+		error = execute(ip, flags);
+		if (error == EAGAIN) {
+			skipped++;
+			continue;
+		}
+		if (error)
+			last_error = error;
+		/*
+		 * bail out if the filesystem is corrupted.
+		 */
+		if (error == EFSCORRUPTED)
+			break;
+
+	} while (1);
+
+	if (skipped) {
+		delay(1);
+		goto restart;
+	}
+
+	xfs_put_perag(mp, pag);
+	return last_error;
+}
+
+STATIC int
+xfs_inode_ag_iterator(
+	xfs_mount_t	*mp,
+	int		(*lookup)(xfs_mount_t *mp, xfs_inode_t *ip),
+	int		(*execute)(xfs_inode_t *ip, int flags),
+	int		flags,
+	int		tag)
+{
+	int		error = 0;
+	int		last_error = 0;
+	xfs_agnumber_t	ag;
+
+	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
+		if (!mp->m_perag[ag].pag_ici_init)
+			continue;
+		error = xfs_inode_ag_walk(mp, ag, lookup, execute, flags, tag);
+		if (error)
+			last_error = error;
+		if (error == EFSCORRUPTED)
+			break;
+	}
+	return XFS_ERROR(last_error);
+}
+
 static int
 xfs_sync_inode_data(
 	struct xfs_inode	*ip,
@@ -76,6 +202,7 @@ xfs_sync_inode_data(
 	if (flags & SYNC_IOWAIT)
 		xfs_ioend_wait(ip);
 
+	IRELE(ip);
 	return error;
 }
 
@@ -91,7 +218,7 @@ xfs_sync_inode_flush(
 	 * the inode flush clustering code inside xfs_iflush
 	 */
 	if (xfs_inode_clean(ip))
-		return 0;
+		goto out_rele;
 
 	/*
 	 * We make this non-blocking if the inode is contended,
@@ -107,7 +234,7 @@ xfs_sync_inode_flush(
 		error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
 	} else {
 		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
-			goto out;
+			goto out_rele;
 		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
 			goto out_unlock;
 
@@ -116,7 +243,8 @@ xfs_sync_inode_flush(
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-out:
+out_rele:
+	IRELE(ip);
 	return error;
 }
 
@@ -151,115 +279,32 @@ error:
 	return error;
 }
 
-/*
- * Sync all the inodes in the given AG according to the
- * direction given by the flags.
- */
-STATIC int
-xfs_sync_inodes_ag(
-	xfs_mount_t	*mp,
-	int		ag,
-	int		flags)
-{
-	xfs_perag_t	*pag = &mp->m_perag[ag];
-	int		nr_found;
-	uint32_t	first_index = 0;
-	int		error = 0;
-	int		last_error = 0;
-
-	do {
-		xfs_inode_t	*ip = NULL;
-
-		/*
-		 * use a gang lookup to find the next inode in the tree
-		 * as the tree is sparse and a gang lookup walks to find
-		 * the number of objects requested.
-		 */
-		read_lock(&pag->pag_ici_lock);
-		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-				(void**)&ip, first_index, 1);
-
-		if (!nr_found) {
-			read_unlock(&pag->pag_ici_lock);
-			break;
-		}
-
-		/*
-		 * Update the index for the next lookup. Catch overflows
-		 * into the next AG range which can occur if we have inodes
-		 * in the last block of the AG and we are currently
-		 * pointing to the last inode.
-		 */
-		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino)) {
-			read_unlock(&pag->pag_ici_lock);
-			break;
-		}
-
-		error = xfs_sync_inode_valid(mp, ip);
-		if (error) {
-			read_unlock(&pag->pag_ici_lock);
-			if (error == EFSCORRUPTED)
-				return 0;
-			continue;
-		}
-
-		/*
-		 * If we have to flush data or wait for I/O completion
-		 * we need to hold the iolock.
-		 */
-		if (flags & SYNC_DELWRI)
-			error = xfs_sync_inode_data(ip, flags);
-
-		if (flags & SYNC_ATTR)
-			error = xfs_sync_inode_flush(ip, flags);
-
-		IRELE(ip);
-
-		if (error)
-			last_error = error;
-		/*
-		 * bail out if the filesystem is corrupted.
-		 */
-		if (error == EFSCORRUPTED)
-			return XFS_ERROR(error);
-
-	} while (nr_found);
-
-	return last_error;
-}
-
 int
 xfs_sync_inodes(
 	xfs_mount_t	*mp,
 	int		flags)
 {
-	int		error;
-	int		last_error;
-	int		i;
+	int		error = 0;
 	int		lflags = XFS_LOG_FORCE;
 
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return 0;
-	error = 0;
-	last_error = 0;
 
 	if (flags & SYNC_WAIT)
 		lflags |= XFS_LOG_SYNC;
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-		if (!mp->m_perag[i].pag_ici_init)
-			continue;
-		error = xfs_sync_inodes_ag(mp, i, flags);
-		if (error)
-			last_error = error;
-		if (error == EFSCORRUPTED)
-			break;
-	}
 	if (flags & SYNC_DELWRI)
+		error = xfs_inode_ag_iterator(mp, xfs_sync_inode_valid,
+					xfs_sync_inode_data, flags, -1);
+
+	if (flags & SYNC_ATTR)
+		error = xfs_inode_ag_iterator(mp, xfs_sync_inode_valid,
+					xfs_sync_inode_flush, flags, -1);
+
+	if (!error && (flags & SYNC_DELWRI))
 		xfs_log_force(mp, 0, lflags);
 
-	return XFS_ERROR(last_error);
+	return XFS_ERROR(error);
 }
 
 STATIC int
@@ -724,72 +769,12 @@ xfs_reclaim_inode_valid(
 	return 0;
 }
 
-STATIC void
-xfs_reclaim_inodes_ag(
-	xfs_mount_t	*mp,
-	int		ag,
-	int		mode)
+static int
+xfs_reclaim_inode_now(
+	xfs_inode_t	*ip,
+	int		flags)
 {
-	xfs_inode_t	*ip = NULL;
-	xfs_perag_t	*pag = &mp->m_perag[ag];
-	int		nr_found;
-	uint32_t	first_index;
-	int		skipped;
-
-restart:
-	first_index = 0;
-	skipped = 0;
-	do {
-		int	error;
-
-		/*
-		 * use a gang lookup to find the next inode in the tree
-		 * as the tree is sparse and a gang lookup walks to find
-		 * the number of objects requested.
-		 */
-		read_lock(&pag->pag_ici_lock);
-		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
-					(void**)&ip, first_index, 1,
-					XFS_ICI_RECLAIM_TAG);
-
-		if (!nr_found) {
-			read_unlock(&pag->pag_ici_lock);
-			break;
-		}
-
-		/*
-		 * Update the index for the next lookup. Catch overflows
-		 * into the next AG range which can occur if we have inodes
-		 * in the last block of the AG and we are currently
-		 * pointing to the last inode.
-		 */
-		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino)) {
-			read_unlock(&pag->pag_ici_lock);
-			break;
-		}
-
-		error = xfs_reclaim_inode_valid(mp, ip);
-		if (error) {
-			read_unlock(&pag->pag_ici_lock);
-			continue;
-		}
-		read_unlock(&pag->pag_ici_lock);
-
-		/*
-		 * hmmm - this is an inode already in reclaim. Do
-		 * we even bother catching it here?
-		 */
-		if (xfs_reclaim_inode(ip, 0, mode))
-			skipped++;
-	} while (nr_found);
-
-	if (skipped) {
-		delay(1);
-		goto restart;
-	}
-	return;
-
+	return xfs_reclaim_inode(ip, 0, flags);
 }
 
 int
@@ -797,14 +782,7 @@ xfs_reclaim_inodes(
 	xfs_mount_t	*mp,
 	int		mode)
 {
-	int		i;
-
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-		if (!mp->m_perag[i].pag_ici_init)
-			continue;
-		xfs_reclaim_inodes_ag(mp, i, mode);
-	}
-	return 0;
+	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode_valid,
+					xfs_reclaim_inode_now, mode,
+					XFS_ICI_RECLAIM_TAG);
 }
-
-
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
