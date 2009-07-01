Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61CiBFa010475
	for <linux-xfs@oss.sgi.com>; Wed, 1 Jul 2009 07:44:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3D0E9BC356
	for <linux-xfs@oss.sgi.com>; Wed,  1 Jul 2009 05:51:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bWSDjlRXr16Zsf2X for
	<linux-xfs@oss.sgi.com>; Wed, 01 Jul 2009 05:51:02 -0700 (PDT)
Date: Wed, 1 Jul 2009 08:44:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
Message-ID: <20090701124441.GA12844@infradead.org>
References: <4A408316.2070903@news-service.com>
	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<20090623171305.GB23971@infradead.org>
	<4A4A7205.6010101@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A4A7205.6010101@news-service.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Patrick Schreurs <patrick@news-service.com>
Cc: linux-xfs@oss.sgi.com, Tommy van Leeuwen <tommy@news-service.com>, Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

Actually you might want to give this patch a try which fixes a race
affecting the reclaim tag in iget:


Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2009-06-04 13:27:41.901946950 +0200
+++ xfs/fs/xfs/xfs_iget.c	2009-06-04 14:08:08.837816707 +0200
@@ -132,80 +132,89 @@ xfs_iget_cache_hit(
 	int			flags,
 	int			lock_flags) __releases(pag->pag_ici_lock)
 {
+	struct inode		*inode = VFS_I(ip);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error = EAGAIN;
+	int			error;
+
+	spin_lock(&ip->i_flags_lock);
 
 	/*
-	 * If INEW is set this inode is being set up
-	 * If IRECLAIM is set this inode is being torn down
-	 * Pause and try again.
+	 * This inode is being torn down, pause and try again.
 	 */
-	if (xfs_iflags_test(ip, (XFS_INEW|XFS_IRECLAIM))) {
+	if (ip->i_flags & XFS_IRECLAIM) {
 		XFS_STATS_INC(xs_ig_frecycle);
+		error = EAGAIN;
 		goto out_error;
 	}
 
-	/* If IRECLAIMABLE is set, we've torn down the vfs inode part */
-	if (xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
+	/*
+	 * If we are racing with another cache hit that is currently recycling
+	 * this inode out of the XFS_IRECLAIMABLE state, wait for the
+	 * initialisation to complete before continuing.
+	 */
+	if (ip->i_flags & XFS_INEW) {
+		spin_unlock(&ip->i_flags_lock);
+		read_unlock(&pag->pag_ici_lock);
 
-		/*
-		 * If lookup is racing with unlink, then we should return an
-		 * error immediately so we don't remove it from the reclaim
-		 * list and potentially leak the inode.
-		 */
-		if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
-			error = ENOENT;
-			goto out_error;
-		}
+		XFS_STATS_INC(xs_ig_frecycle);
+		wait_on_inode(inode);
+		return EAGAIN;
+	}
 
+	/*
+	 * If lookup is racing with unlink, then we should return an
+	 * error immediately so we don't remove it from the reclaim
+	 * list and potentially leak the inode.
+	 */
+	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
+		error = ENOENT;
+		goto out_error;
+	}
+
+	/*
+	 * If IRECLAIMABLE is set, we've torn down the vfs inode part already.
+	 * Need to carefully get it back into useable state.
+	 */
+	if (ip->i_flags & XFS_IRECLAIMABLE) {
 		xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
 		/*
-		 * We need to re-initialise the VFS inode as it has been
-		 * 'freed' by the VFS. Do this here so we can deal with
-		 * errors cleanly, then tag it so it can be set up correctly
-		 * later.
+		 * We need to set XFS_INEW atomically with clearing the
+		 * reclaimable tag so that we do have an indicator of the
+		 * inode still being initialized.
 		 */
-		if (!inode_init_always(mp->m_super, VFS_I(ip))) {
+		ip->i_flags |= XFS_INEW;
+		__xfs_inode_clear_reclaim_tag(pag, ip);
+
+		spin_unlock(&ip->i_flags_lock);
+		read_unlock(&pag->pag_ici_lock);
+
+		if (unlikely(!inode_init_always(mp->m_super, inode))) {
+			printk("node_init_always failed!!\n");
+
+			/*
+			 * Re-initializing the inode failed, and we are in deep
+			 * trouble.  Try to re-add it to the reclaim list.
+			 */
+			read_lock(&pag->pag_ici_lock);
+			spin_lock(&ip->i_flags_lock);
+
+			ip->i_flags &= ~XFS_INEW;
+			__xfs_inode_set_reclaim_tag(pag, ip);
+
 			error = ENOMEM;
 			goto out_error;
 		}
-
-		/*
-		 * We must set the XFS_INEW flag before clearing the
-		 * XFS_IRECLAIMABLE flag so that if a racing lookup does
-		 * not find the XFS_IRECLAIMABLE above but has the igrab()
-		 * below succeed we can safely check XFS_INEW to detect
-		 * that this inode is still being initialised.
-		 */
-		xfs_iflags_set(ip, XFS_INEW);
-		xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
-
-		/* clear the radix tree reclaim flag as well. */
-		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
-	} else if (!igrab(VFS_I(ip))) {
+	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
-		XFS_STATS_INC(xs_ig_frecycle);
-		goto out_error;
-	} else if (xfs_iflags_test(ip, XFS_INEW)) {
-		/*
-		 * We are racing with another cache hit that is
-		 * currently recycling this inode out of the XFS_IRECLAIMABLE
-		 * state. Wait for the initialisation to complete before
-		 * continuing.
-		 */
-		wait_on_inode(VFS_I(ip));
-	}
+		if (!igrab(inode))
+			goto out_error;
 
-	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
-		error = ENOENT;
-		iput(VFS_I(ip));
-		goto out_error;
+		/* We've got a live one. */
+		spin_unlock(&ip->i_flags_lock);
+		read_unlock(&pag->pag_ici_lock);
 	}
 
-	/* We've got a live one. */
-	read_unlock(&pag->pag_ici_lock);
-
 	if (lock_flags != 0)
 		xfs_ilock(ip, lock_flags);
 
@@ -215,6 +224,7 @@ xfs_iget_cache_hit(
 	return 0;
 
 out_error:
+	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
 	return error;
 }
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-06-04 13:40:09.135939715 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-06-04 13:59:17.978816696 +0200
@@ -607,6 +607,17 @@ xfs_reclaim_inode(
 	return 0;
 }
 
+void
+__xfs_inode_set_reclaim_tag(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	xfs_agino_t	agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+
+	radix_tree_tag_set(&pag->pag_ici_root, agino, XFS_ICI_RECLAIM_TAG);
+	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+}
+
 /*
  * We set the inode flag atomically with the radix tree tag.
  * Once we get tag lookups on the radix tree, this inode flag
@@ -621,9 +632,7 @@ xfs_inode_set_reclaim_tag(
 
 	read_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
-	radix_tree_tag_set(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+	__xfs_inode_set_reclaim_tag(pag, ip);
 	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
@@ -631,30 +640,15 @@ xfs_inode_set_reclaim_tag(
 
 void
 __xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
-	xfs_perag_t	*pag,
-	xfs_inode_t	*ip)
-{
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-}
-
-void
-xfs_inode_clear_reclaim_tag(
-	xfs_inode_t	*ip)
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
+	xfs_agino_t	agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 
-	read_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	__xfs_inode_clear_reclaim_tag(mp, pag, ip);
-	spin_unlock(&ip->i_flags_lock);
-	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+	ip->i_flags &= ~XFS_IRECLAIMABLE;
+	radix_tree_tag_clear(&pag->pag_ici_root, agino, XFS_ICI_RECLAIM_TAG);
 }
 
-
 STATIC void
 xfs_reclaim_inodes_ag(
 	xfs_mount_t	*mp,
Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-06-04 13:53:32.994814723 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2009-06-04 13:58:54.746942001 +0200
@@ -51,7 +51,6 @@ int xfs_reclaim_inode(struct xfs_inode *
 int xfs_reclaim_inodes(struct xfs_mount *mp, int noblock, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
-void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
-void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
-				struct xfs_inode *ip);
+void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
+void __xfs_inode_clear_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
 #endif

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
