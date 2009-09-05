Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n850KsGT253858 for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 19:21:04 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8065D42BEC9
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2009 17:21:21 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id DEQR2KPjYbExrBt8 for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2009 17:21:21 -0700 (PDT)
Message-Id: <20090905001455.522626105@mini.kroah.org>
Date: Fri, 04 Sep 2009 17:14:28 -0700
From: Greg KH <gregkh@suse.de>
Subject: [patch 53/71] xfs: fix freeing of inodes not yet added to the inode
	cache
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline;
	filename=xfs-fix-freeing-of-inodes-not-yet-added-to-the-inode-cache.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
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
Cc: stable-review@kernel.org, akpm@linux-foundation.org, xfs@oss.sgi.com, torvalds@linux-foundation.org, Christoph Hellwig <hch@lst.de>, alan@lxorguk.ukuu.org.uk

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christoph Hellwig <hch@infradead.org>

upstream commit b36ec0428a06fcbdb67d61e9e664154e5dd9a8c7

When freeing an inode that lost race getting added to the inode cache we
must not call into ->destroy_inode, because that would delete the inode
that won the race from the inode cache radix tree.

This patch uses splits a new xfs_inode_free helper out of xfs_ireclaim
and uses that plus __destroy_inode to make sure we really only free
the memory allocted for the inode that lost the race, and not mess with
the inode cache state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reported-by: Alex Samad <alex@samad.com.au>
Reported-by: Andrew Randrianasulu <randrik@mail.ru>
Reported-by: Stephane <sharnois@max-t.com>
Reported-by: Tommy <tommy@news-service.com>
Reported-by: Miah Gregory <mace@darksilence.net>
Reported-by: Gabriel Barazer <gabriel@oxeva.fr>
Reported-by: Leandro Lucarella <llucax@gmail.com>
Reported-by: Daniel Burr <dburr@fami.com.au>
Reported-by: Nickolay <newmail@spaces.ru>
Reported-by: Michael Guntsche <mike@it-loops.com>
Reported-by: Dan Carley <dan.carley+linuxkern-bugs@gmail.com>
Reported-by: Michael Ole Olsen <gnu@gmx.net>
Reported-by: Michael Weissenbacher <mw@dermichi.com>
Reported-by: Martin Spott <Martin.Spott@mgras.net>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Tested-by: Michael Guntsche <mike@it-loops.com>
Tested-by: Dan Carley <dan.carley+linuxkern-bugs@gmail.com>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_iget.c  |  125 ++++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_inode.h |   17 -------
 2 files changed, 68 insertions(+), 74 deletions(-)

--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -115,6 +115,71 @@ xfs_inode_alloc(
 	return ip;
 }
 
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
+#ifdef XFS_INODE_TRACE
+	ktrace_free(ip->i_trace);
+#endif
+#ifdef XFS_BMAP_TRACE
+	ktrace_free(ip->i_xtrace);
+#endif
+#ifdef XFS_BTREE_TRACE
+	ktrace_free(ip->i_btrace);
+#endif
+#ifdef XFS_RW_TRACE
+	ktrace_free(ip->i_rwtrace);
+#endif
+#ifdef XFS_ILOCK_TRACE
+	ktrace_free(ip->i_lock_trace);
+#endif
+#ifdef XFS_DIR2_TRACE
+	ktrace_free(ip->i_dir_trace);
+#endif
+
+	if (ip->i_itemp) {
+		/*
+		 * Only if we are shutting down the fs will we see an
+		 * inode still in the AIL. If it is there, we should remove
+		 * it to prevent a use-after-free from occurring.
+		 */
+		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
+		struct xfs_ail	*ailp = lip->li_ailp;
+
+		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
+				       XFS_FORCED_SHUTDOWN(ip->i_mount));
+		if (lip->li_flags & XFS_LI_IN_AIL) {
+			spin_lock(&ailp->xa_lock);
+			if (lip->li_flags & XFS_LI_IN_AIL)
+				xfs_trans_ail_delete(ailp, lip);
+			else
+				spin_unlock(&ailp->xa_lock);
+		}
+		xfs_inode_item_destroy(ip);
+		ip->i_itemp = NULL;
+	}
+
+	/* asserts to verify all state is correct here */
+	ASSERT(atomic_read(&ip->i_iocount) == 0);
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(completion_done(&ip->i_flush));
+
+	kmem_zone_free(xfs_inode_zone, ip);
+}
+
 /*
  * Check the validity of the inode we just found it the cache
  */
@@ -291,7 +356,8 @@ out_preload_end:
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
 out_destroy:
-	xfs_destroy_inode(ip);
+	__destroy_inode(VFS_I(ip));
+	xfs_inode_free(ip);
 	return error;
 }
 
@@ -499,62 +565,7 @@ xfs_ireclaim(
 	XFS_QM_DQDETACH(ip->i_mount, ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
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
-#ifdef XFS_INODE_TRACE
-	ktrace_free(ip->i_trace);
-#endif
-#ifdef XFS_BMAP_TRACE
-	ktrace_free(ip->i_xtrace);
-#endif
-#ifdef XFS_BTREE_TRACE
-	ktrace_free(ip->i_btrace);
-#endif
-#ifdef XFS_RW_TRACE
-	ktrace_free(ip->i_rwtrace);
-#endif
-#ifdef XFS_ILOCK_TRACE
-	ktrace_free(ip->i_lock_trace);
-#endif
-#ifdef XFS_DIR2_TRACE
-	ktrace_free(ip->i_dir_trace);
-#endif
-	if (ip->i_itemp) {
-		/*
-		 * Only if we are shutting down the fs will we see an
-		 * inode still in the AIL. If it is there, we should remove
-		 * it to prevent a use-after-free from occurring.
-		 */
-		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
-		struct xfs_ail	*ailp = lip->li_ailp;
-
-		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
-				       XFS_FORCED_SHUTDOWN(ip->i_mount));
-		if (lip->li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&ailp->xa_lock);
-			if (lip->li_flags & XFS_LI_IN_AIL)
-				xfs_trans_ail_delete(ailp, lip);
-			else
-				spin_unlock(&ailp->xa_lock);
-		}
-		xfs_inode_item_destroy(ip);
-		ip->i_itemp = NULL;
-	}
-	/* asserts to verify all state is correct here */
-	ASSERT(atomic_read(&ip->i_iocount) == 0);
-	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(completion_done(&ip->i_flush));
-	kmem_zone_free(xfs_inode_zone, ip);
+	xfs_inode_free(ip);
 }
 
 /*
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -309,23 +309,6 @@ static inline struct inode *VFS_I(struct
 }
 
 /*
- * Get rid of a partially initialized inode.
- *
- * We have to go through destroy_inode to make sure allocations
- * from init_inode_always like the security data are undone.
- *
- * We mark the inode bad so that it takes the short cut in
- * the reclaim path instead of going through the flush path
- * which doesn't make sense for an inode that has never seen the
- * light of day.
- */
-static inline void xfs_destroy_inode(struct xfs_inode *ip)
-{
-	make_bad_inode(VFS_I(ip));
-	return destroy_inode(VFS_I(ip));
-}
-
-/*
  * i_flags helper functions
  */
 static inline void


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
