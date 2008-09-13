Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:02:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DE2N5L015221
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:02:23 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 924B21ADDFBB
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:03:51 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id tJHew8KU7sEaflSU for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:03:51 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVj1-0007gC-CP
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:03:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] XFS: factor xfs_iget_core() into hit and miss cases
Date: Sun, 14 Sep 2008 00:03:45 +1000
Message-Id: <1221314627-29065-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1221314627-29065-1-git-send-email-david@fromorbit.com>
References: <1221314627-29065-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

There are really two cases in xfs_iget_core(). The first is the
cache hit case, the second is the miss case. They share very little
code, and hence can easily be factored out into separate functions.
This makes the code much easier to understand and subsequently
modify.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iget.c |  347 +++++++++++++++++++++++++++++------------------------
 1 files changed, 191 insertions(+), 156 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 7932551..3b6d35e 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -40,161 +40,119 @@
 #include "xfs_utils.h"
 
 /*
- * Look up an inode by number in the given file system.
- * The inode is looked up in the cache held in each AG.
- * If the inode is found in the cache, attach it to the provided
- * vnode.
- *
- * If it is not in core, read it in from the file system's device,
- * add it to the cache and attach the provided vnode.
- *
- * The inode is locked according to the value of the lock_flags parameter.
- * This flag parameter indicates how and if the inode's IO lock and inode lock
- * should be taken.
- *
- * mp -- the mount point structure for the current file system.  It points
- *       to the inode hash table.
- * tp -- a pointer to the current transaction if there is one.  This is
- *       simply passed through to the xfs_iread() call.
- * ino -- the number of the inode desired.  This is the unique identifier
- *        within the file system for the inode being requested.
- * lock_flags -- flags indicating how to lock the inode.  See the comment
- *		 for xfs_ilock() for a list of valid values.
- * bno -- the block number starting the buffer containing the inode,
- *	  if known (as by bulkstat), else 0.
+ * Check the validity of the inode we just found it the cache
  */
-STATIC int
-xfs_iget_core(
-	struct inode	*inode,
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	uint		flags,
-	uint		lock_flags,
-	xfs_inode_t	**ipp,
-	xfs_daddr_t	bno)
+static int
+xfs_iget_cache_hit(
+	struct inode		*inode,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip,
+	int			flags,
+	int			lock_flags) __releases(pag->pag_ici_lock)
 {
-	struct inode	*old_inode;
-	xfs_inode_t	*ip;
-	int		error;
-	unsigned long	first_index, mask;
-	xfs_perag_t	*pag;
-	xfs_agino_t	agino;
-
-	/* the radix tree exists only in inode capable AGs */
-	if (XFS_INO_TO_AGNO(mp, ino) >= mp->m_maxagi)
-		return EINVAL;
-
-	/* get the perag structure and ensure that it's inode capable */
-	pag = xfs_get_perag(mp, ino);
-	if (!pag->pagi_inodeok)
-		return EINVAL;
-	ASSERT(pag->pag_ici_init);
-	agino = XFS_INO_TO_AGINO(mp, ino);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*old_inode;
+	int			error = 0;
 
-again:
-	read_lock(&pag->pag_ici_lock);
-	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+	/*
+	 * If INEW is set this inode is being set up
+	 * Pause and try again.
+	 */
+	if (xfs_iflags_test(ip, XFS_INEW)) {
+		error = EAGAIN;
+		XFS_STATS_INC(xs_ig_frecycle);
+		goto out_error;
+	}
 
-	if (ip != NULL) {
+	old_inode = ip->i_vnode;
+	if (old_inode == NULL) {
 		/*
-		 * If INEW is set this inode is being set up
+		 * If IRECLAIM is set this inode is
+		 * on its way out of the system,
 		 * we need to pause and try again.
 		 */
-		if (xfs_iflags_test(ip, XFS_INEW)) {
-			read_unlock(&pag->pag_ici_lock);
-			delay(1);
+		if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
+			error = EAGAIN;
 			XFS_STATS_INC(xs_ig_frecycle);
+			goto out_error;
+		}
+		ASSERT(xfs_iflags_test(ip, XFS_IRECLAIMABLE));
 
-			goto again;
+		/*
+		 * If lookup is racing with unlink, then we
+		 * should return an error immediately so we
+		 * don't remove it from the reclaim list and
+		 * potentially leak the inode.
+		 */
+		if ((ip->i_d.di_mode == 0) &&
+		    !(flags & XFS_IGET_CREATE)) {
+			error = ENOENT;
+			goto out_error;
 		}
+		xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
+
+		xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
+		read_unlock(&pag->pag_ici_lock);
+
+		XFS_MOUNT_ILOCK(mp);
+		list_del_init(&ip->i_reclaim);
+		XFS_MOUNT_IUNLOCK(mp);
 
-		old_inode = ip->i_vnode;
-		if (old_inode == NULL) {
-			/*
-			 * If IRECLAIM is set this inode is
-			 * on its way out of the system,
-			 * we need to pause and try again.
-			 */
-			if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-				read_unlock(&pag->pag_ici_lock);
-				delay(1);
-				XFS_STATS_INC(xs_ig_frecycle);
-
-				goto again;
-			}
-			ASSERT(xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-
-			/*
-			 * If lookup is racing with unlink, then we
-			 * should return an error immediately so we
-			 * don't remove it from the reclaim list and
-			 * potentially leak the inode.
-			 */
-			if ((ip->i_d.di_mode == 0) &&
-			    !(flags & XFS_IGET_CREATE)) {
-				read_unlock(&pag->pag_ici_lock);
-				xfs_put_perag(mp, pag);
-				return ENOENT;
-			}
-
-			xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
-
-			XFS_STATS_INC(xs_ig_found);
-			xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
-			read_unlock(&pag->pag_ici_lock);
-
-			XFS_MOUNT_ILOCK(mp);
-			list_del_init(&ip->i_reclaim);
-			XFS_MOUNT_IUNLOCK(mp);
-
-			goto finish_inode;
-
-		} else if (inode != old_inode) {
-			/* The inode is being torn down, pause and
-			 * try again.
-			 */
-			if (old_inode->i_state & (I_FREEING | I_CLEAR)) {
-				read_unlock(&pag->pag_ici_lock);
-				delay(1);
-				XFS_STATS_INC(xs_ig_frecycle);
-
-				goto again;
-			}
+	} else if (inode != old_inode) {
+		/* The inode is being torn down, pause and
+		 * try again.
+		 */
+		if (old_inode->i_state & (I_FREEING | I_CLEAR)) {
+			error = EAGAIN;
+			XFS_STATS_INC(xs_ig_frecycle);
+			goto out_error;
+		}
 /* Chances are the other vnode (the one in the inode) is being torn
 * down right now, and we landed on top of it. Question is, what do
 * we do? Unhook the old inode and hook up the new one?
 */
-			cmn_err(CE_PANIC,
-		"xfs_iget_core: ambiguous vns: vp/0x%p, invp/0x%p",
-					old_inode, inode);
-		}
-
-		/*
-		 * Inode cache hit
-		 */
+		cmn_err(CE_PANIC,
+	"xfs_iget_core: ambiguous vns: vp/0x%p, invp/0x%p",
+				old_inode, inode);
+	} else {
 		read_unlock(&pag->pag_ici_lock);
-		XFS_STATS_INC(xs_ig_found);
+	}
 
-finish_inode:
-		if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
-			xfs_put_perag(mp, pag);
-			return ENOENT;
-		}
+	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
+		error = ENOENT;
+		goto out;
+	}
 
-		if (lock_flags != 0)
-			xfs_ilock(ip, lock_flags);
+	if (lock_flags != 0)
+		xfs_ilock(ip, lock_flags);
 
-		xfs_iflags_clear(ip, XFS_ISTALE);
-		xfs_itrace_exit_tag(ip, "xfs_iget.found");
-		goto return_ip;
-	}
+	xfs_iflags_clear(ip, XFS_ISTALE);
+	xfs_itrace_exit_tag(ip, "xfs_iget.found");
+	XFS_STATS_INC(xs_ig_found);
+	return 0;
 
-	/*
-	 * Inode cache miss
-	 */
+out_error:
 	read_unlock(&pag->pag_ici_lock);
-	XFS_STATS_INC(xs_ig_missed);
+out:
+	return error;
+}
+
+
+static int
+xfs_iget_cache_miss(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
+	xfs_trans_t		*tp,
+	xfs_ino_t		ino,
+	struct xfs_inode	**ipp,
+	xfs_daddr_t		bno,
+	int			flags,
+	int			lock_flags)
+{
+	struct xfs_inode	*ip;
+	int			error;
+	unsigned long		first_index, mask;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
 
 	/*
 	 * Read the disk inode attributes into a new inode structure and get
@@ -202,14 +160,11 @@ finish_inode:
 	 */
 	error = xfs_iread(mp, tp, ino, &ip, bno,
 			  (flags & XFS_IGET_BULKSTAT) ? XFS_IMAP_BULKSTAT : 0);
-	if (error) {
-		xfs_put_perag(mp, pag);
+	if (error)
 		return error;
-	}
 
 	xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
-
 	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
 		     "xfsino", ip->i_ino);
 	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
@@ -228,9 +183,8 @@ finish_inode:
 		xfs_ilock(ip, lock_flags);
 
 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
-		xfs_idestroy(ip);
-		xfs_put_perag(mp, pag);
-		return ENOENT;
+		error = ENOENT;
+		goto out_destroy;
 	}
 
 	/*
@@ -238,37 +192,110 @@ finish_inode:
 	 * write spinlock.
 	 */
 	if (radix_tree_preload(GFP_KERNEL)) {
-		xfs_idestroy(ip);
-		delay(1);
-		goto again;
+		error = EAGAIN;
+		goto out_destroy;
 	}
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = agino & mask;
 	write_lock(&pag->pag_ici_lock);
-	/*
-	 * insert the new inode
-	 */
+
+	/* insert the new inode */
 	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
 	if (unlikely(error)) {
-		BUG_ON(error != -EEXIST);
-		write_unlock(&pag->pag_ici_lock);
-		radix_tree_preload_end();
-		xfs_idestroy(ip);
+		WARN_ON(error != -EEXIST);
 		XFS_STATS_INC(xs_ig_dup);
-		goto again;
+		error = EAGAIN;
+		goto out_unlock;
 	}
 
-	/*
-	 * These values _must_ be set before releasing the radix tree lock!
-	 */
+	/* These values _must_ be set before releasing the radix tree lock! */
 	ip->i_udquot = ip->i_gdquot = NULL;
 	xfs_iflags_set(ip, XFS_INEW);
 
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
+	*ipp = ip;
+	return 0;
+
+out_unlock:
+	write_unlock(&pag->pag_ici_lock);
+	radix_tree_preload_end();
+out_destroy:
+	xfs_idestroy(ip);
+	return error;
+}
+
+/*
+ * Look up an inode by number in the given file system.
+ * The inode is looked up in the cache held in each AG.
+ * If the inode is found in the cache, attach it to the provided
+ * vnode.
+ *
+ * If it is not in core, read it in from the file system's device,
+ * add it to the cache and attach the provided vnode.
+ *
+ * The inode is locked according to the value of the lock_flags parameter.
+ * This flag parameter indicates how and if the inode's IO lock and inode lock
+ * should be taken.
+ *
+ * mp -- the mount point structure for the current file system.  It points
+ *       to the inode hash table.
+ * tp -- a pointer to the current transaction if there is one.  This is
+ *       simply passed through to the xfs_iread() call.
+ * ino -- the number of the inode desired.  This is the unique identifier
+ *        within the file system for the inode being requested.
+ * lock_flags -- flags indicating how to lock the inode.  See the comment
+ *		 for xfs_ilock() for a list of valid values.
+ * bno -- the block number starting the buffer containing the inode,
+ *	  if known (as by bulkstat), else 0.
+ */
+STATIC int
+xfs_iget_core(
+	struct inode	*inode,
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_ino_t	ino,
+	uint		flags,
+	uint		lock_flags,
+	xfs_inode_t	**ipp,
+	xfs_daddr_t	bno)
+{
+	xfs_inode_t	*ip;
+	int		error;
+	xfs_perag_t	*pag;
+	xfs_agino_t	agino;
+
+	/* the radix tree exists only in inode capable AGs */
+	if (XFS_INO_TO_AGNO(mp, ino) >= mp->m_maxagi)
+		return EINVAL;
+
+	/* get the perag structure and ensure that it's inode capable */
+	pag = xfs_get_perag(mp, ino);
+	if (!pag->pagi_inodeok)
+		return EINVAL;
+	ASSERT(pag->pag_ici_init);
+	agino = XFS_INO_TO_AGINO(mp, ino);
+
+again:
+	error = 0;
+	read_lock(&pag->pag_ici_lock);
+	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+
+	if (ip) {
+		error = xfs_iget_cache_hit(inode, pag, ip, flags, lock_flags);
+		if (error)
+			goto out_error_or_again;
+	} else {
+		read_unlock(&pag->pag_ici_lock);
+		XFS_STATS_INC(xs_ig_missed);
+
+		error = xfs_iget_cache_miss(mp, pag, tp, ino, &ip, bno,
+							flags, lock_flags);
+		if (error)
+			goto out_error_or_again;
+	}
 	xfs_put_perag(mp, pag);
 
- return_ip:
 	ASSERT(ip->i_df.if_ext_max ==
 	       XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t));
 
@@ -288,6 +315,14 @@ finish_inode:
 	if (ip->i_d.di_mode != 0)
 		xfs_setup_inode(ip);
 	return 0;
+
+out_error_or_again:
+	if (error == EAGAIN) {
+		delay(1);
+		goto again;
+	}
+	xfs_put_perag(mp, pag);
+	return error;
 }
 
 
-- 
1.5.6
