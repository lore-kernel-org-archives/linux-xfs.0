Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98AtNn8055700 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 05:55:23 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jW2enmcQ5sFvXLJ5 for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 03:56:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLB0w-0000Vu-CT
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:46 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLB0m-00028B-8U
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/14] xfs: remove xfs_iget.c
Date: Mon,  8 Oct 2012 21:56:11 +1100
Message-Id: <1349693772-8064-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1349693772-8064-1-git-send-email-david@fromorbit.com>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
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

The inode cache functions remaining in xfs_iget.c can be moved to xfs_icache.c
along with the other inode cache functions. This removes all functionality from
xfs_iget.c, so the file can simply be removed.

This move results in various functions now only having the scope of a single
file (e.g. xfs_inode_free()), so clean up all the definitions and exported
prototypes in xfs_icache.[ch] and xfs_inode.h appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/Makefile          |    1 -
 fs/xfs/xfs_export.c      |    1 +
 fs/xfs/xfs_icache.c      |  421 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h      |    6 +-
 fs/xfs/xfs_iget.c        |  455 ----------------------------------------------
 fs/xfs/xfs_inode.c       |    1 +
 fs/xfs/xfs_inode.h       |   10 +-
 fs/xfs/xfs_itable.c      |    1 +
 fs/xfs/xfs_log_recover.c |    1 +
 fs/xfs/xfs_qm.c          |    1 +
 fs/xfs/xfs_rtalloc.c     |    1 +
 fs/xfs/xfs_vnodeops.c    |    1 +
 12 files changed, 430 insertions(+), 470 deletions(-)
 delete mode 100644 fs/xfs/xfs_iget.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 442f256..e65357b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,7 +40,6 @@ xfs-y				+= xfs_aops.o \
 				   xfs_fs_subr.o \
 				   xfs_globals.o \
 				   xfs_icache.o \
-				   xfs_iget.o \
 				   xfs_ioctl.o \
 				   xfs_iomap.o \
 				   xfs_iops.o \
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 4267922..9b6e330 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -29,6 +29,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * Note that we only accept fileids which are long enough rather than allow
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index eba216f..9c8703b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -41,6 +41,421 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+STATIC void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp,
+				struct xfs_perag *pag, struct xfs_inode *ip);
+
+/*
+ * Allocate and initialise an xfs_inode.
+ */
+STATIC struct xfs_inode *
+xfs_inode_alloc(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct xfs_inode	*ip;
+
+	/*
+	 * if this didn't occur in transactions, we could use
+	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
+	 * code up to do this anyway.
+	 */
+	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
+	if (!ip)
+		return NULL;
+	if (inode_init_always(mp->m_super, VFS_I(ip))) {
+		kmem_zone_free(xfs_inode_zone, ip);
+		return NULL;
+	}
+
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(!xfs_isiflocked(ip));
+	ASSERT(ip->i_ino == 0);
+
+	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+
+	/* initialise the xfs inode */
+	ip->i_ino = ino;
+	ip->i_mount = mp;
+	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
+	ip->i_afp = NULL;
+	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
+	ip->i_flags = 0;
+	ip->i_delayed_blks = 0;
+	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
+
+	return ip;
+}
+
+STATIC void
+xfs_inode_free_callback(
+	struct rcu_head		*head)
+{
+	struct inode		*inode = container_of(head, struct inode, i_rcu);
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	kmem_zone_free(xfs_inode_zone, ip);
+}
+
+STATIC void
+xfs_inode_free(
+	struct xfs_inode	*ip)
+{
+	switch (ip->i_d.di_mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFLNK:
+		xfs_idestroy_fork(ip, XFS_DATA_FORK);
+		break;
+	}
+
+	if (ip->i_afp)
+		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+
+	if (ip->i_itemp) {
+		ASSERT(!(ip->i_itemp->ili_item.li_flags & XFS_LI_IN_AIL));
+		xfs_inode_item_destroy(ip);
+		ip->i_itemp = NULL;
+	}
+
+	/* asserts to verify all state is correct here */
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(!xfs_isiflocked(ip));
+
+	/*
+	 * Because we use RCU freeing we need to ensure the inode always
+	 * appears to be reclaimed with an invalid inode number when in the
+	 * free state. The ip->i_flags_lock provides the barrier against lookup
+	 * races.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags = XFS_IRECLAIM;
+	ip->i_ino = 0;
+	spin_unlock(&ip->i_flags_lock);
+
+	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
+}
+
+/*
+ * Check the validity of the inode we just found it the cache
+ */
+static int
+xfs_iget_cache_hit(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip,
+	xfs_ino_t		ino,
+	int			flags,
+	int			lock_flags) __releases(RCU)
+{
+	struct inode		*inode = VFS_I(ip);
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	/*
+	 * check for re-use of an inode within an RCU grace period due to the
+	 * radix tree nodes not being updated yet. We monitor for this by
+	 * setting the inode number to zero before freeing the inode structure.
+	 * If the inode has been reallocated and set up, then the inode number
+	 * will not match, so check for that, too.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (ip->i_ino != ino) {
+		trace_xfs_iget_skip(ip);
+		XFS_STATS_INC(xs_ig_frecycle);
+		error = EAGAIN;
+		goto out_error;
+	}
+
+
+	/*
+	 * If we are racing with another cache hit that is currently
+	 * instantiating this inode or currently recycling it out of
+	 * reclaimabe state, wait for the initialisation to complete
+	 * before continuing.
+	 *
+	 * XXX(hch): eventually we should do something equivalent to
+	 *	     wait_on_inode to wait for these flags to be cleared
+	 *	     instead of polling for it.
+	 */
+	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
+		trace_xfs_iget_skip(ip);
+		XFS_STATS_INC(xs_ig_frecycle);
+		error = EAGAIN;
+		goto out_error;
+	}
+
+	/*
+	 * If lookup is racing with unlink return an error immediately.
+	 */
+	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
+		error = ENOENT;
+		goto out_error;
+	}
+
+	/*
+	 * If IRECLAIMABLE is set, we've torn down the VFS inode already.
+	 * Need to carefully get it back into useable state.
+	 */
+	if (ip->i_flags & XFS_IRECLAIMABLE) {
+		trace_xfs_iget_reclaim(ip);
+
+		/*
+		 * We need to set XFS_IRECLAIM to prevent xfs_reclaim_inode
+		 * from stomping over us while we recycle the inode.  We can't
+		 * clear the radix tree reclaimable tag yet as it requires
+		 * pag_ici_lock to be held exclusive.
+		 */
+		ip->i_flags |= XFS_IRECLAIM;
+
+		spin_unlock(&ip->i_flags_lock);
+		rcu_read_unlock();
+
+		error = -inode_init_always(mp->m_super, inode);
+		if (error) {
+			/*
+			 * Re-initializing the inode failed, and we are in deep
+			 * trouble.  Try to re-add it to the reclaim list.
+			 */
+			rcu_read_lock();
+			spin_lock(&ip->i_flags_lock);
+
+			ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
+			ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
+			trace_xfs_iget_reclaim_fail(ip);
+			goto out_error;
+		}
+
+		spin_lock(&pag->pag_ici_lock);
+		spin_lock(&ip->i_flags_lock);
+
+		/*
+		 * Clear the per-lifetime state in the inode as we are now
+		 * effectively a new inode and need to return to the initial
+		 * state before reuse occurs.
+		 */
+		ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
+		ip->i_flags |= XFS_INEW;
+		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
+		inode->i_state = I_NEW;
+
+		ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
+		mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+
+		spin_unlock(&ip->i_flags_lock);
+		spin_unlock(&pag->pag_ici_lock);
+	} else {
+		/* If the VFS inode is being torn down, pause and try again. */
+		if (!igrab(inode)) {
+			trace_xfs_iget_skip(ip);
+			error = EAGAIN;
+			goto out_error;
+		}
+
+		/* We've got a live one. */
+		spin_unlock(&ip->i_flags_lock);
+		rcu_read_unlock();
+		trace_xfs_iget_hit(ip);
+	}
+
+	if (lock_flags != 0)
+		xfs_ilock(ip, lock_flags);
+
+	xfs_iflags_clear(ip, XFS_ISTALE | XFS_IDONTCACHE);
+	XFS_STATS_INC(xs_ig_found);
+
+	return 0;
+
+out_error:
+	spin_unlock(&ip->i_flags_lock);
+	rcu_read_unlock();
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
+	int			flags,
+	int			lock_flags)
+{
+	struct xfs_inode	*ip;
+	int			error;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
+	int			iflags;
+
+	ip = xfs_inode_alloc(mp, ino);
+	if (!ip)
+		return ENOMEM;
+
+	error = xfs_iread(mp, tp, ip, flags);
+	if (error)
+		goto out_destroy;
+
+	trace_xfs_iget_miss(ip);
+
+	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
+		error = ENOENT;
+		goto out_destroy;
+	}
+
+	/*
+	 * Preload the radix tree so we can insert safely under the
+	 * write spinlock. Note that we cannot sleep inside the preload
+	 * region. Since we can be called from transaction context, don't
+	 * recurse into the file system.
+	 */
+	if (radix_tree_preload(GFP_NOFS)) {
+		error = EAGAIN;
+		goto out_destroy;
+	}
+
+	/*
+	 * Because the inode hasn't been added to the radix-tree yet it can't
+	 * be found by another thread, so we can do the non-sleeping lock here.
+	 */
+	if (lock_flags) {
+		if (!xfs_ilock_nowait(ip, lock_flags))
+			BUG();
+	}
+
+	/*
+	 * These values must be set before inserting the inode into the radix
+	 * tree as the moment it is inserted a concurrent lookup (allowed by the
+	 * RCU locking mechanism) can find it and that lookup must see that this
+	 * is an inode currently under construction (i.e. that XFS_INEW is set).
+	 * The ip->i_flags_lock that protects the XFS_INEW flag forms the
+	 * memory barrier that ensures this detection works correctly at lookup
+	 * time.
+	 */
+	iflags = XFS_INEW;
+	if (flags & XFS_IGET_DONTCACHE)
+		iflags |= XFS_IDONTCACHE;
+	ip->i_udquot = ip->i_gdquot = NULL;
+	xfs_iflags_set(ip, iflags);
+
+	/* insert the new inode */
+	spin_lock(&pag->pag_ici_lock);
+	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
+	if (unlikely(error)) {
+		WARN_ON(error != -EEXIST);
+		XFS_STATS_INC(xs_ig_dup);
+		error = EAGAIN;
+		goto out_preload_end;
+	}
+	spin_unlock(&pag->pag_ici_lock);
+	radix_tree_preload_end();
+
+	*ipp = ip;
+	return 0;
+
+out_preload_end:
+	spin_unlock(&pag->pag_ici_lock);
+	radix_tree_preload_end();
+	if (lock_flags)
+		xfs_iunlock(ip, lock_flags);
+out_destroy:
+	__destroy_inode(VFS_I(ip));
+	xfs_inode_free(ip);
+	return error;
+}
+
+/*
+ * Look up an inode by number in the given file system.
+ * The inode is looked up in the cache held in each AG.
+ * If the inode is found in the cache, initialise the vfs inode
+ * if necessary.
+ *
+ * If it is not in core, read it in from the file system's device,
+ * add it to the cache and initialise the vfs inode.
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
+ */
+int
+xfs_iget(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_ino_t	ino,
+	uint		flags,
+	uint		lock_flags,
+	xfs_inode_t	**ipp)
+{
+	xfs_inode_t	*ip;
+	int		error;
+	xfs_perag_t	*pag;
+	xfs_agino_t	agino;
+
+	/*
+	 * xfs_reclaim_inode() uses the ILOCK to ensure an inode
+	 * doesn't get freed while it's being referenced during a
+	 * radix tree traversal here.  It assumes this function
+	 * aqcuires only the ILOCK (and therefore it has no need to
+	 * involve the IOLOCK in this synchronization).
+	 */
+	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
+
+	/* reject inode numbers outside existing AGs */
+	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+		return EINVAL;
+
+	/* get the perag structure and ensure that it's inode capable */
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
+	agino = XFS_INO_TO_AGINO(mp, ino);
+
+again:
+	error = 0;
+	rcu_read_lock();
+	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+
+	if (ip) {
+		error = xfs_iget_cache_hit(pag, ip, ino, flags, lock_flags);
+		if (error)
+			goto out_error_or_again;
+	} else {
+		rcu_read_unlock();
+		XFS_STATS_INC(xs_ig_missed);
+
+		error = xfs_iget_cache_miss(mp, pag, tp, ino, &ip,
+							flags, lock_flags);
+		if (error)
+			goto out_error_or_again;
+	}
+	xfs_perag_put(pag);
+
+	*ipp = ip;
+
+	/*
+	 * If we have a real type for an on-disk inode, we can set ops(&unlock)
+	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
+	 */
+	if (xfs_iflags_test(ip, XFS_INEW) && ip->i_d.di_mode != 0)
+		xfs_setup_inode(ip);
+	return 0;
+
+out_error_or_again:
+	if (error == EAGAIN) {
+		delay(1);
+		goto again;
+	}
+	xfs_perag_put(pag);
+	return error;
+}
+
 /*
  * The inode lookup is done in batches to keep the amount of lock traffic and
  * radix tree lookups to a minimum. The batch size is a trade off between
@@ -253,7 +668,7 @@ xfs_reclaim_worker(
 	xfs_reclaim_work_queue(mp);
 }
 
-void
+static void
 __xfs_inode_set_reclaim_tag(
 	struct xfs_perag	*pag,
 	struct xfs_inode	*ip)
@@ -319,7 +734,7 @@ __xfs_inode_clear_reclaim(
 	}
 }
 
-void
+STATIC void
 __xfs_inode_clear_reclaim_tag(
 	xfs_mount_t	*mp,
 	xfs_perag_t	*pag,
@@ -542,7 +957,7 @@ out:
  * then a shut down during filesystem unmount reclaim walk leak all the
  * unreclaimed inodes.
  */
-int
+STATIC int
 xfs_reclaim_inodes_ag(
 	struct xfs_mount	*mp,
 	int			flags,
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 0ba9c89..222e22f 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -24,6 +24,9 @@ struct xfs_perag;
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
 #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 
+int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
+	     uint flags, uint lock_flags, xfs_inode_t **ipp);
+
 void xfs_reclaim_worker(struct work_struct *work);
 
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
@@ -31,9 +34,6 @@ int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
-void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
-void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
-				struct xfs_inode *ip);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
deleted file mode 100644
index ea9a5fa..0000000
--- a/fs/xfs/xfs_iget.c
+++ /dev/null
@@ -1,455 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_acl.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
-#include "xfs_quota.h"
-#include "xfs_utils.h"
-#include "xfs_trans_priv.h"
-#include "xfs_inode_item.h"
-#include "xfs_bmap.h"
-#include "xfs_trace.h"
-#include "xfs_icache.h"
-
-
-/*
- * Allocate and initialise an xfs_inode.
- */
-STATIC struct xfs_inode *
-xfs_inode_alloc(
-	struct xfs_mount	*mp,
-	xfs_ino_t		ino)
-{
-	struct xfs_inode	*ip;
-
-	/*
-	 * if this didn't occur in transactions, we could use
-	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
-	 * code up to do this anyway.
-	 */
-	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
-	if (!ip)
-		return NULL;
-	if (inode_init_always(mp->m_super, VFS_I(ip))) {
-		kmem_zone_free(xfs_inode_zone, ip);
-		return NULL;
-	}
-
-	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(!xfs_isiflocked(ip));
-	ASSERT(ip->i_ino == 0);
-
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-
-	/* initialise the xfs inode */
-	ip->i_ino = ino;
-	ip->i_mount = mp;
-	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
-	ip->i_afp = NULL;
-	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
-	ip->i_flags = 0;
-	ip->i_delayed_blks = 0;
-	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
-
-	return ip;
-}
-
-STATIC void
-xfs_inode_free_callback(
-	struct rcu_head		*head)
-{
-	struct inode		*inode = container_of(head, struct inode, i_rcu);
-	struct xfs_inode	*ip = XFS_I(inode);
-
-	kmem_zone_free(xfs_inode_zone, ip);
-}
-
-void
-xfs_inode_free(
-	struct xfs_inode	*ip)
-{
-	switch (ip->i_d.di_mode & S_IFMT) {
-	case S_IFREG:
-	case S_IFDIR:
-	case S_IFLNK:
-		xfs_idestroy_fork(ip, XFS_DATA_FORK);
-		break;
-	}
-
-	if (ip->i_afp)
-		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
-
-	if (ip->i_itemp) {
-		ASSERT(!(ip->i_itemp->ili_item.li_flags & XFS_LI_IN_AIL));
-		xfs_inode_item_destroy(ip);
-		ip->i_itemp = NULL;
-	}
-
-	/* asserts to verify all state is correct here */
-	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(!xfs_isiflocked(ip));
-
-	/*
-	 * Because we use RCU freeing we need to ensure the inode always
-	 * appears to be reclaimed with an invalid inode number when in the
-	 * free state. The ip->i_flags_lock provides the barrier against lookup
-	 * races.
-	 */
-	spin_lock(&ip->i_flags_lock);
-	ip->i_flags = XFS_IRECLAIM;
-	ip->i_ino = 0;
-	spin_unlock(&ip->i_flags_lock);
-
-	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
-}
-
-/*
- * Check the validity of the inode we just found it the cache
- */
-static int
-xfs_iget_cache_hit(
-	struct xfs_perag	*pag,
-	struct xfs_inode	*ip,
-	xfs_ino_t		ino,
-	int			flags,
-	int			lock_flags) __releases(RCU)
-{
-	struct inode		*inode = VFS_I(ip);
-	struct xfs_mount	*mp = ip->i_mount;
-	int			error;
-
-	/*
-	 * check for re-use of an inode within an RCU grace period due to the
-	 * radix tree nodes not being updated yet. We monitor for this by
-	 * setting the inode number to zero before freeing the inode structure.
-	 * If the inode has been reallocated and set up, then the inode number
-	 * will not match, so check for that, too.
-	 */
-	spin_lock(&ip->i_flags_lock);
-	if (ip->i_ino != ino) {
-		trace_xfs_iget_skip(ip);
-		XFS_STATS_INC(xs_ig_frecycle);
-		error = EAGAIN;
-		goto out_error;
-	}
-
-
-	/*
-	 * If we are racing with another cache hit that is currently
-	 * instantiating this inode or currently recycling it out of
-	 * reclaimabe state, wait for the initialisation to complete
-	 * before continuing.
-	 *
-	 * XXX(hch): eventually we should do something equivalent to
-	 *	     wait_on_inode to wait for these flags to be cleared
-	 *	     instead of polling for it.
-	 */
-	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
-		trace_xfs_iget_skip(ip);
-		XFS_STATS_INC(xs_ig_frecycle);
-		error = EAGAIN;
-		goto out_error;
-	}
-
-	/*
-	 * If lookup is racing with unlink return an error immediately.
-	 */
-	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
-		error = ENOENT;
-		goto out_error;
-	}
-
-	/*
-	 * If IRECLAIMABLE is set, we've torn down the VFS inode already.
-	 * Need to carefully get it back into useable state.
-	 */
-	if (ip->i_flags & XFS_IRECLAIMABLE) {
-		trace_xfs_iget_reclaim(ip);
-
-		/*
-		 * We need to set XFS_IRECLAIM to prevent xfs_reclaim_inode
-		 * from stomping over us while we recycle the inode.  We can't
-		 * clear the radix tree reclaimable tag yet as it requires
-		 * pag_ici_lock to be held exclusive.
-		 */
-		ip->i_flags |= XFS_IRECLAIM;
-
-		spin_unlock(&ip->i_flags_lock);
-		rcu_read_unlock();
-
-		error = -inode_init_always(mp->m_super, inode);
-		if (error) {
-			/*
-			 * Re-initializing the inode failed, and we are in deep
-			 * trouble.  Try to re-add it to the reclaim list.
-			 */
-			rcu_read_lock();
-			spin_lock(&ip->i_flags_lock);
-
-			ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
-			ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
-			trace_xfs_iget_reclaim_fail(ip);
-			goto out_error;
-		}
-
-		spin_lock(&pag->pag_ici_lock);
-		spin_lock(&ip->i_flags_lock);
-
-		/*
-		 * Clear the per-lifetime state in the inode as we are now
-		 * effectively a new inode and need to return to the initial
-		 * state before reuse occurs.
-		 */
-		ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
-		ip->i_flags |= XFS_INEW;
-		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
-		inode->i_state = I_NEW;
-
-		ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
-		mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-
-		spin_unlock(&ip->i_flags_lock);
-		spin_unlock(&pag->pag_ici_lock);
-	} else {
-		/* If the VFS inode is being torn down, pause and try again. */
-		if (!igrab(inode)) {
-			trace_xfs_iget_skip(ip);
-			error = EAGAIN;
-			goto out_error;
-		}
-
-		/* We've got a live one. */
-		spin_unlock(&ip->i_flags_lock);
-		rcu_read_unlock();
-		trace_xfs_iget_hit(ip);
-	}
-
-	if (lock_flags != 0)
-		xfs_ilock(ip, lock_flags);
-
-	xfs_iflags_clear(ip, XFS_ISTALE | XFS_IDONTCACHE);
-	XFS_STATS_INC(xs_ig_found);
-
-	return 0;
-
-out_error:
-	spin_unlock(&ip->i_flags_lock);
-	rcu_read_unlock();
-	return error;
-}
-
-
-static int
-xfs_iget_cache_miss(
-	struct xfs_mount	*mp,
-	struct xfs_perag	*pag,
-	xfs_trans_t		*tp,
-	xfs_ino_t		ino,
-	struct xfs_inode	**ipp,
-	int			flags,
-	int			lock_flags)
-{
-	struct xfs_inode	*ip;
-	int			error;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
-	int			iflags;
-
-	ip = xfs_inode_alloc(mp, ino);
-	if (!ip)
-		return ENOMEM;
-
-	error = xfs_iread(mp, tp, ip, flags);
-	if (error)
-		goto out_destroy;
-
-	trace_xfs_iget_miss(ip);
-
-	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
-		error = ENOENT;
-		goto out_destroy;
-	}
-
-	/*
-	 * Preload the radix tree so we can insert safely under the
-	 * write spinlock. Note that we cannot sleep inside the preload
-	 * region. Since we can be called from transaction context, don't
-	 * recurse into the file system.
-	 */
-	if (radix_tree_preload(GFP_NOFS)) {
-		error = EAGAIN;
-		goto out_destroy;
-	}
-
-	/*
-	 * Because the inode hasn't been added to the radix-tree yet it can't
-	 * be found by another thread, so we can do the non-sleeping lock here.
-	 */
-	if (lock_flags) {
-		if (!xfs_ilock_nowait(ip, lock_flags))
-			BUG();
-	}
-
-	/*
-	 * These values must be set before inserting the inode into the radix
-	 * tree as the moment it is inserted a concurrent lookup (allowed by the
-	 * RCU locking mechanism) can find it and that lookup must see that this
-	 * is an inode currently under construction (i.e. that XFS_INEW is set).
-	 * The ip->i_flags_lock that protects the XFS_INEW flag forms the
-	 * memory barrier that ensures this detection works correctly at lookup
-	 * time.
-	 */
-	iflags = XFS_INEW;
-	if (flags & XFS_IGET_DONTCACHE)
-		iflags |= XFS_IDONTCACHE;
-	ip->i_udquot = ip->i_gdquot = NULL;
-	xfs_iflags_set(ip, iflags);
-
-	/* insert the new inode */
-	spin_lock(&pag->pag_ici_lock);
-	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
-	if (unlikely(error)) {
-		WARN_ON(error != -EEXIST);
-		XFS_STATS_INC(xs_ig_dup);
-		error = EAGAIN;
-		goto out_preload_end;
-	}
-	spin_unlock(&pag->pag_ici_lock);
-	radix_tree_preload_end();
-
-	*ipp = ip;
-	return 0;
-
-out_preload_end:
-	spin_unlock(&pag->pag_ici_lock);
-	radix_tree_preload_end();
-	if (lock_flags)
-		xfs_iunlock(ip, lock_flags);
-out_destroy:
-	__destroy_inode(VFS_I(ip));
-	xfs_inode_free(ip);
-	return error;
-}
-
-/*
- * Look up an inode by number in the given file system.
- * The inode is looked up in the cache held in each AG.
- * If the inode is found in the cache, initialise the vfs inode
- * if necessary.
- *
- * If it is not in core, read it in from the file system's device,
- * add it to the cache and initialise the vfs inode.
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
- */
-int
-xfs_iget(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	uint		flags,
-	uint		lock_flags,
-	xfs_inode_t	**ipp)
-{
-	xfs_inode_t	*ip;
-	int		error;
-	xfs_perag_t	*pag;
-	xfs_agino_t	agino;
-
-	/*
-	 * xfs_reclaim_inode() uses the ILOCK to ensure an inode
-	 * doesn't get freed while it's being referenced during a
-	 * radix tree traversal here.  It assumes this function
-	 * aqcuires only the ILOCK (and therefore it has no need to
-	 * involve the IOLOCK in this synchronization).
-	 */
-	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
-
-	/* reject inode numbers outside existing AGs */
-	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
-		return EINVAL;
-
-	/* get the perag structure and ensure that it's inode capable */
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
-	agino = XFS_INO_TO_AGINO(mp, ino);
-
-again:
-	error = 0;
-	rcu_read_lock();
-	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
-
-	if (ip) {
-		error = xfs_iget_cache_hit(pag, ip, ino, flags, lock_flags);
-		if (error)
-			goto out_error_or_again;
-	} else {
-		rcu_read_unlock();
-		XFS_STATS_INC(xs_ig_missed);
-
-		error = xfs_iget_cache_miss(mp, pag, tp, ino, &ip,
-							flags, lock_flags);
-		if (error)
-			goto out_error_or_again;
-	}
-	xfs_perag_put(pag);
-
-	*ipp = ip;
-
-	/*
-	 * If we have a real type for an on-disk inode, we can set ops(&unlock)
-	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
-	 */
-	if (xfs_iflags_test(ip, XFS_INEW) && ip->i_d.di_mode != 0)
-		xfs_setup_inode(ip);
-	return 0;
-
-out_error_or_again:
-	if (error == EAGAIN) {
-		delay(1);
-		goto again;
-	}
-	xfs_perag_put(pag);
-	return error;
-}
-
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ba404e4..bba8f37 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -45,6 +45,7 @@
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 94b32f9..1fc2065 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -496,11 +496,10 @@ static inline int xfs_isiflocked(struct xfs_inode *ip)
 	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
 	 ((pip)->i_d.di_mode & S_ISGID))
 
+
 /*
- * xfs_iget.c prototypes.
+ * xfs_inode.c prototypes.
  */
-int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-			 uint, uint, xfs_inode_t **);
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
@@ -508,11 +507,6 @@ void		xfs_ilock_demote(xfs_inode_t *, uint);
 int		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_map_shared(xfs_inode_t *);
 void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
-void		xfs_inode_free(struct xfs_inode *ip);
-
-/*
- * xfs_inode.c prototypes.
- */
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
 			   xfs_nlink_t, xfs_dev_t, prid_t, int,
 			   struct xfs_buf **, xfs_inode_t **);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 01d10a6..3998fd2 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -34,6 +34,7 @@
 #include "xfs_error.h"
 #include "xfs_btree.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 STATIC int
 xfs_internal_inum(
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5da3ace..651c988 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -42,6 +42,7 @@
 #include "xfs_quota.h"
 #include "xfs_utils.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 STATIC int
 xlog_find_zeroed(
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 2e86fa0..48c750b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -40,6 +40,7 @@
 #include "xfs_utils.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ca28a4b..a69e0b4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -38,6 +38,7 @@
 #include "xfs_utils.h"
 #include "xfs_trace.h"
 #include "xfs_buf.h"
+#include "xfs_icache.h"
 
 
 /*
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 1492856..2ee1f49 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -47,6 +47,7 @@
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * The maximum pathlen is 1024 bytes. Since the minimum file system
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
