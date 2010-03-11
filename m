Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMetRA194283 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:40:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4BEB233ABB
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	EQ6dyU6VnDeQAXgT for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:26 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/19] xfs: reclaim inodes under a write lock
Date: Fri, 12 Mar 2010 09:42:08 +1100
Message-Id: <1268347337-7160-11-git-send-email-david@fromorbit.com>
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

>From c8e20be020f234c8d492927a424a7d8bbefd5b5d
Date: Sun, 10 Jan 2010 23:51:45 +0000
Make the inode tree reclaim walk exclusive to avoid races with
concurrent sync walkers and lookups. This is a version of a patch
posted by Christoph Hellwig that avoids all the code duplication.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c    |  154 ++++++++++++++++++----------------------
 fs/xfs/linux-2.6/xfs_sync.h    |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    2 +-
 3 files changed, 71 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index d895a3a..63c585e 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -64,7 +64,6 @@ xfs_inode_ag_lookup(
 	 * as the tree is sparse and a gang lookup walks to find
 	 * the number of objects requested.
 	 */
-	read_lock(&pag->pag_ici_lock);
 	if (tag == XFS_ICI_NO_TAG) {
 		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 				(void **)&ip, *first_index, 1);
@@ -73,7 +72,7 @@ xfs_inode_ag_lookup(
 				(void **)&ip, *first_index, 1, tag);
 	}
 	if (!nr_found)
-		goto unlock;
+		return NULL;
 
 	/*
 	 * Update the index for the next lookup. Catch overflows
@@ -83,13 +82,8 @@ xfs_inode_ag_lookup(
 	 */
 	*first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 	if (*first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-		goto unlock;
-
+		return NULL;
 	return ip;
-
-unlock:
-	read_unlock(&pag->pag_ici_lock);
-	return NULL;
 }
 
 STATIC int
@@ -99,7 +93,8 @@ xfs_inode_ag_walk(
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags,
-	int			tag)
+	int			tag,
+	int			exclusive)
 {
 	struct xfs_perag	*pag = &mp->m_perag[ag];
 	uint32_t		first_index;
@@ -113,10 +108,20 @@ restart:
 		int		error = 0;
 		xfs_inode_t	*ip;
 
+		if (exclusive)
+			write_lock(&pag->pag_ici_lock);
+		else
+			read_lock(&pag->pag_ici_lock);
 		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
-		if (!ip)
+		if (!ip) {
+			if (exclusive)
+				write_unlock(&pag->pag_ici_lock);
+			else
+				read_unlock(&pag->pag_ici_lock);
 			break;
+		}
 
+		/* execute releases pag->pag_ici_lock */
 		error = execute(ip, pag, flags);
 		if (error == EAGAIN) {
 			skipped++;
@@ -124,9 +129,8 @@ restart:
 		}
 		if (error)
 			last_error = error;
-		/*
-		 * bail out if the filesystem is corrupted.
-		 */
+
+		/* bail out if the filesystem is corrupted.  */
 		if (error == EFSCORRUPTED)
 			break;
 
@@ -147,7 +151,8 @@ xfs_inode_ag_iterator(
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags,
-	int			tag)
+	int			tag,
+	int			exclusive)
 {
 	int			error = 0;
 	int			last_error = 0;
@@ -156,7 +161,8 @@ xfs_inode_ag_iterator(
 	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
 		if (!mp->m_perag[ag].pag_ici_init)
 			continue;
-		error = xfs_inode_ag_walk(mp, ag, execute, flags, tag);
+		error = xfs_inode_ag_walk(mp, ag, execute, flags, tag,
+						exclusive);
 		if (error) {
 			last_error = error;
 			if (error == EFSCORRUPTED)
@@ -180,11 +186,7 @@ xfs_sync_inode_valid(
 		return EFSCORRUPTED;
 	}
 
-	/*
-	 * If we can't get a reference on the inode, it must be in reclaim.
-	 * Leave it for the reclaim code to flush. Also avoid inodes that
-	 * haven't been fully initialised.
-	 */
+	/* If we can't get a reference on the inode, it must be in reclaim. */
 	if (!igrab(inode)) {
 		read_unlock(&pag->pag_ici_lock);
 		return ENOENT;
@@ -281,7 +283,7 @@ xfs_sync_data(
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 
 	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags,
-				      XFS_ICI_NO_TAG);
+				      XFS_ICI_NO_TAG, 0);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -303,7 +305,7 @@ xfs_sync_attr(
 	ASSERT((flags & ~SYNC_WAIT) == 0);
 
 	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags,
-				     XFS_ICI_NO_TAG);
+				     XFS_ICI_NO_TAG, 0);
 }
 
 STATIC int
@@ -663,60 +665,6 @@ xfs_syncd_stop(
 	kthread_stop(mp->m_sync_task);
 }
 
-STATIC int
-xfs_reclaim_inode(
-	xfs_inode_t	*ip,
-	int		sync_mode)
-{
-	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
-
-	/* The hash lock here protects a thread in xfs_iget_core from
-	 * racing with us on linking the inode back with a vnode.
-	 * Once we have the XFS_IRECLAIM flag set it will not touch
-	 * us.
-	 */
-	write_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
-	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
-		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
-		return -EAGAIN;
-	}
-	__xfs_iflags_set(ip, XFS_IRECLAIM);
-	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(ip->i_mount, pag);
-
-	/*
-	 * If the inode is still dirty, then flush it out.  If the inode
-	 * is not in the AIL, then it will be OK to flush it delwri as
-	 * long as xfs_iflush() does not keep any references to the inode.
-	 * We leave that decision up to xfs_iflush() since it has the
-	 * knowledge of whether it's OK to simply do a delwri flush of
-	 * the inode or whether we need to wait until the inode is
-	 * pulled from the AIL.
-	 * We get the flush lock regardless, though, just to make sure
-	 * we don't free it while it is being flushed.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_iflock(ip);
-
-	/*
-	 * In the case of a forced shutdown we rely on xfs_iflush() to
-	 * wait for the inode to be unpinned before returning an error.
-	 */
-	if (!is_bad_inode(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
-		/* synchronize with xfs_iflush_done */
-		xfs_iflock(ip);
-		xfs_ifunlock(ip);
-	}
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	xfs_ireclaim(ip);
-	return 0;
-}
-
 void
 __xfs_inode_set_reclaim_tag(
 	struct xfs_perag	*pag,
@@ -759,19 +707,55 @@ __xfs_inode_clear_reclaim_tag(
 }
 
 STATIC int
-xfs_reclaim_inode_now(
+xfs_reclaim_inode(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
-	int			flags)
+	int			sync_mode)
 {
-	/* ignore if already under reclaim */
-	if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-		read_unlock(&pag->pag_ici_lock);
+	/*
+	 * The radix tree lock here protects a thread in xfs_iget from racing
+	 * with us starting reclaim on the inode.  Once we have the
+	 * XFS_IRECLAIM flag set it will not touch us.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
+		/* ignore as it is already under reclaim */
+		spin_unlock(&ip->i_flags_lock);
+		write_unlock(&pag->pag_ici_lock);
 		return 0;
 	}
-	read_unlock(&pag->pag_ici_lock);
+	__xfs_iflags_set(ip, XFS_IRECLAIM);
+	spin_unlock(&ip->i_flags_lock);
+	write_unlock(&pag->pag_ici_lock);
+
+	/*
+	 * If the inode is still dirty, then flush it out.  If the inode
+	 * is not in the AIL, then it will be OK to flush it delwri as
+	 * long as xfs_iflush() does not keep any references to the inode.
+	 * We leave that decision up to xfs_iflush() since it has the
+	 * knowledge of whether it's OK to simply do a delwri flush of
+	 * the inode or whether we need to wait until the inode is
+	 * pulled from the AIL.
+	 * We get the flush lock regardless, though, just to make sure
+	 * we don't free it while it is being flushed.
+	 */
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_iflock(ip);
 
-	return xfs_reclaim_inode(ip, flags);
+	/*
+	 * In the case of a forced shutdown we rely on xfs_iflush() to
+	 * wait for the inode to be unpinned before returning an error.
+	 */
+	if (!is_bad_inode(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
+		/* synchronize with xfs_iflush_done */
+		xfs_iflock(ip);
+		xfs_ifunlock(ip);
+	}
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_ireclaim(ip);
+	return 0;
 }
 
 int
@@ -779,6 +763,6 @@ xfs_reclaim_inodes(
 	xfs_mount_t	*mp,
 	int		mode)
 {
-	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode_now, mode,
-					XFS_ICI_RECLAIM_TAG);
+	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode, mode,
+					XFS_ICI_RECLAIM_TAG, 1);
 }
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index a500b4d..ea932b4 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -54,6 +54,6 @@ void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
-	int flags, int tag);
+	int flags, int tag, int write_lock);
 
 #endif
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 5d1a3b9..f99cfa4 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -893,7 +893,7 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, XFS_ICI_NO_TAG);
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, XFS_ICI_NO_TAG, 0);
 }
 
 /*------------------------------------------------------------------------*/
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
