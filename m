Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPeMH227483 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:40 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EF0A1AE6288
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:40 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id IwaHvFKbGqwD4e6D for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:40 -0700 (PDT)
Message-Id: <20100422190909.024649557@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:49 -0700
From: Greg KH <gregkh@suse.de>
Subject: [018/197] xfs: reclaim inodes under a write lock
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit c8e20be020f234c8d492927a424a7d8bbefd5b5d upstream

Make the inode tree reclaim walk exclusive to avoid races with
concurrent sync walkers and lookups. This is a version of a patch
posted by Christoph Hellwig that avoids all the code duplication.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/linux-2.6/xfs_sync.c    |  154 ++++++++++++++++++-----------------------
 fs/xfs/linux-2.6/xfs_sync.h    |    2 
 fs/xfs/quota/xfs_qm_syscalls.c |    2 
 3 files changed, 71 insertions(+), 87 deletions(-)

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
 
-	return xfs_reclaim_inode(ip, flags);
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
+
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
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -54,6 +54,6 @@ void __xfs_inode_clear_reclaim_tag(struc
 int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
-	int flags, int tag);
+	int flags, int tag, int write_lock);
 
 #endif
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
