Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:47:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDlBZ4026105
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:47:11 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C53081488018
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:47:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 7kmQYtvGayzNmptA for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:47:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSR4-0001Vs-1A
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:47:10 +0000
Date: Mon, 27 Oct 2008 09:47:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/10] cleanup the inode reclaim path
Message-ID: <20081027134710.GB5730@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-cleanup-xfs_ireclaim
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Merge xfs_iextract and xfs_idestory into xfs_ireclaim as they are never
called individually.  Also rewrite most comments in this area as they
were serverly out of date.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-10-25 13:41:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-10-25 13:42:16.000000000 +0200
@@ -363,65 +363,109 @@ xfs_iput_new(
 	IRELE(ip);
 }
 
-
 /*
- * This routine embodies the part of the reclaim code that pulls
- * the inode from the inode hash table and the mount structure's
- * inode list.
- * This should only be called from xfs_reclaim().
+ * This is called free all the memory associated with an inode.
+ * It must free the inode itself and any buffers allocated for
+ * if_extents/if_data and if_broot.  It must also free the lock
+ * associated with the inode.
+ *
+ * Note: because we don't initialise everything on reallocation out
+ * of the zone, we must ensure we nullify everything correctly before
+ * freeing the structure.
  */
 void
-xfs_ireclaim(xfs_inode_t *ip)
+xfs_ireclaim(
+	struct xfs_inode	*ip)
 {
-	/*
-	 * Remove from old hash list and mount list.
-	 */
-	XFS_STATS_INC(xs_ig_reclaims);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
 
-	xfs_iextract(ip);
+	XFS_STATS_INC(xs_ig_reclaims);
 
 	/*
-	 * Here we do a spurious inode lock in order to coordinate with inode
-	 * cache radix tree lookups.  This is because the lookup can reference
-	 * the inodes in the cache without taking references.  We make that OK
-	 * here by ensuring that we wait until the inode is unlocked after the
-	 * lookup before we go ahead and free it.  We get both the ilock and
-	 * the iolock because the code may need to drop the ilock one but will
-	 * still hold the iolock.
+	 * Remove the inode from the per-AG radix tree.  It doesn't matter
+	 * if it was never added to it because radix_tree_delete can deal
+	 * with that case just fine.
 	 */
-	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	pag = xfs_get_perag(mp, ip->i_ino);
+	write_lock(&pag->pag_ici_lock);
+	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	write_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(mp, pag);
 
 	/*
-	 * Release dquots (and their references) if any. An inode may escape
-	 * xfs_inactive and get here via vn_alloc->vn_reclaim path.
+	 * Here we do an (almost) spurious inode lock in order to coordinate
+	 * with inode cache radix tree lookups.  This is because the lookup
+	 * can reference the inodes in the cache without taking references.
+	 *
+	 * We make that OK here by ensuring that we wait until the inode is
+	 * unlocked after the lookup before we go ahead and free it.  We get
+	 * both the ilock and the iolock because the code may need to drop the
+	 * ilock one but will still hold the iolock.
 	 */
-	XFS_QM_DQDETACH(ip->i_mount, ip);
-
+	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 	/*
-	 * Free all memory associated with the inode.
+	 * Release dquots (and their references) if any.
 	 */
+	XFS_QM_DQDETACH(ip->i_mount, ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_idestroy(ip);
-}
 
-/*
- * This routine removes an about-to-be-destroyed inode from
- * all of the lists in which it is located with the exception
- * of the behavior chain.
- */
-void
-xfs_iextract(
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
+	switch (ip->i_d.di_mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFLNK:
+		xfs_idestroy_fork(ip, XFS_DATA_FORK);
+		break;
+	}
 
-	write_lock(&pag->pag_ici_lock);
-	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
-	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
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
+	if (ip->i_itemp) {
+		/*
+		 * Only if we are shutting down the fs will we see an
+		 * inode still in the AIL. If it is there, we should remove
+		 * it to prevent a use-after-free from occurring.
+		 */
+		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
+		struct xfs_ail	*ailp = lip->li_ailp;
 
-	mp->m_ireclaims++;
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
+	/* asserts to verify all state is correct here */
+	ASSERT(atomic_read(&ip->i_iocount) == 0);
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(completion_done(&ip->i_flush));
+	kmem_zone_free(xfs_inode_zone, ip);
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-10-25 13:41:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-10-25 13:42:16.000000000 +0200
@@ -531,8 +531,6 @@ int		xfs_itruncate_finish(struct xfs_tra
 				     xfs_fsize_t, int, int);
 int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
 
-void		xfs_idestroy(xfs_inode_t *);
-void		xfs_iextract(xfs_inode_t *);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 void		xfs_ipin(xfs_inode_t *);
 void		xfs_iunpin(xfs_inode_t *);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-10-25 13:41:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-10-25 13:42:16.000000000 +0200
@@ -241,7 +241,6 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	uint			m_ireclaims;	/* count of calls to reclaim*/
 	uint			m_readio_log;	/* min read size log bytes */
 	uint			m_readio_blocks; /* min read size blocks */
 	uint			m_writeio_log;	/* min write size log bytes */
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-10-25 13:41:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-10-25 13:42:16.000000000 +0200
@@ -2664,78 +2664,6 @@ xfs_idestroy_fork(
 }
 
 /*
- * This is called free all the memory associated with an inode.
- * It must free the inode itself and any buffers allocated for
- * if_extents/if_data and if_broot.  It must also free the lock
- * associated with the inode.
- *
- * Note: because we don't initialise everything on reallocation out
- * of the zone, we must ensure we nullify everything correctly before
- * freeing the structure.
- */
-void
-xfs_idestroy(
-	xfs_inode_t	*ip)
-{
-	switch (ip->i_d.di_mode & S_IFMT) {
-	case S_IFREG:
-	case S_IFDIR:
-	case S_IFLNK:
-		xfs_idestroy_fork(ip, XFS_DATA_FORK);
-		break;
-	}
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
-}
-
-
-/*
  * Increment the pin count of the given buffer.
  * This value is protected by ipinlock spinlock in the mount structure.
  */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-25 13:41:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-25 13:42:16.000000000 +0200
@@ -214,8 +214,6 @@ EXPORT_SYMBOL(xfs_error_trap);
 EXPORT_SYMBOL(xfs_file_last_byte);
 EXPORT_SYMBOL(xfs_freesb);
 EXPORT_SYMBOL(xfs_fs_cmn_err);
-EXPORT_SYMBOL(xfs_idestroy);
-EXPORT_SYMBOL(xfs_iextract);
 EXPORT_SYMBOL(xfs_iext_add);
 EXPORT_SYMBOL(xfs_iext_destroy);
 EXPORT_SYMBOL(xfs_iext_get_ext);
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-10-25 13:41:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-10-25 13:42:16.000000000 +0200
@@ -6519,7 +6519,6 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		mp->m_rtdev_targp ? mp->m_rtdev_targp->bt_dev : 0);
 	kdb_printf("bsize %d agfrotor %d xfs_rotorstep %d agirotor %d\n",
 		mp->m_bsize, mp->m_agfrotor, xfs_rotorstep, mp->m_agirotor);
-	kdb_printf("ireclaims 0x%x\n", mp->m_ireclaims);
 	kdb_printf("readio_log 0x%x readio_blocks 0x%x ",
 		mp->m_readio_log, mp->m_readio_blocks);
 	kdb_printf("writeio_log 0x%x writeio_blocks 0x%x\n",

-- 
