Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 04:46:52 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8NBkkQ3024342
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 04:46:49 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8NBklA5009806
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 13:46:48 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8NBklen009804
	for xfs@oss.sgi.com; Sun, 23 Sep 2007 13:46:47 +0200
Date: Sun, 23 Sep 2007 13:46:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup vnode useage in xfs_iget.c
Message-ID: <20070923114647.GA9717@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Get rid of vnode useage in xfs_iget.c and pass Linux inode / xfs_inode
where apropinquate.  And kill some useless helpers while we're at it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-09-19 19:01:25.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-09-19 19:03:16.000000000 +0200
@@ -181,7 +181,6 @@ EXPORT_SYMBOL(uuid_hash64);
 EXPORT_SYMBOL(uuid_is_nil);
 EXPORT_SYMBOL(uuid_table_remove);
 EXPORT_SYMBOL(vn_hold);
-EXPORT_SYMBOL(vn_initialize);
 EXPORT_SYMBOL(vn_revalidate);
 
 #if defined(CONFIG_XFS_POSIX_ACL)
@@ -244,7 +243,6 @@ EXPORT_SYMBOL(xfs_igrow_finish);
 EXPORT_SYMBOL(xfs_ilock);
 EXPORT_SYMBOL(xfs_ilock_map_shared);
 EXPORT_SYMBOL(xfs_ilock_nowait);
-EXPORT_SYMBOL(xfs_inode_lock_init);
 EXPORT_SYMBOL(xfs_internal_inum);
 EXPORT_SYMBOL(xfs_iput);
 EXPORT_SYMBOL(xfs_iput_new);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-09-19 19:00:55.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-09-19 19:01:17.000000000 +0200
@@ -82,20 +82,6 @@ vn_ioerror(
 		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ, f, l);
 }
 
-bhv_vnode_t *
-vn_initialize(
-	struct inode	*inode)
-{
-	bhv_vnode_t	*vp = vn_from_inode(inode);
-
-	XFS_STATS_INC(vn_active);
-	XFS_STATS_INC(vn_alloc);
-
-	ASSERT(VN_CACHED(vp) == 0);
-
-	return vp;
-}
-
 /*
  * Revalidate the Linux inode from the XFS inode.
  * Note: i_size _not_ updated; we must hold the inode
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-09-19 18:57:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-09-19 19:01:12.000000000 +0200
@@ -187,7 +187,6 @@ typedef struct bhv_vattr {
 	(VN_ISREG(vp) && ((mode) & (VSGID|(VEXEC>>3))) == VSGID)
 
 extern void	vn_init(void);
-extern bhv_vnode_t	*vn_initialize(struct inode *);
 extern int	vn_revalidate(bhv_vnode_t *);
 
 /*
@@ -236,11 +235,6 @@ static inline bhv_vnode_t *vn_grab(bhv_v
 /*
  * Dealing with bad inodes
  */
-static inline void vn_mark_bad(bhv_vnode_t *vp)
-{
-	make_bad_inode(vn_to_inode(vp));
-}
-
 static inline int VN_BAD(bhv_vnode_t *vp)
 {
 	return is_bad_inode(vn_to_inode(vp));
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2007-09-19 18:56:23.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2007-09-19 19:10:33.000000000 +0200
@@ -65,7 +65,7 @@
  */
 STATIC int
 xfs_iget_core(
-	bhv_vnode_t	*vp,
+	struct inode	*inode,
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
 	xfs_ino_t	ino,
@@ -74,9 +74,9 @@ xfs_iget_core(
 	xfs_inode_t	**ipp,
 	xfs_daddr_t	bno)
 {
+	struct inode	*old_inode;
 	xfs_inode_t	*ip;
 	xfs_inode_t	*iq;
-	bhv_vnode_t	*inode_vp;
 	int		error;
 	xfs_icluster_t	*icl, *new_icl = NULL;
 	unsigned long	first_index, mask;
@@ -111,8 +111,8 @@ again:
 			goto again;
 		}
 
-		inode_vp = XFS_ITOV_NULL(ip);
-		if (inode_vp == NULL) {
+		old_inode = ip->i_vnode;
+		if (old_inode == NULL) {
 			/*
 			 * If IRECLAIM is set this inode is
 			 * on its way out of the system,
@@ -170,13 +170,11 @@ again:
 
 			goto finish_inode;
 
-		} else if (vp != inode_vp) {
-			struct inode *inode = vn_to_inode(inode_vp);
-
+		} else if (inode != old_inode) {
 			/* The inode is being torn down, pause and
 			 * try again.
 			 */
-			if (inode->i_state & (I_FREEING | I_CLEAR)) {
+			if (old_inode->i_state & (I_FREEING | I_CLEAR)) {
 				read_unlock(&pag->pag_ici_lock);
 				delay(1);
 				XFS_STATS_INC(xs_ig_frecycle);
@@ -189,7 +187,7 @@ again:
 */
 			cmn_err(CE_PANIC,
 		"xfs_iget_core: ambiguous vns: vp/0x%p, invp/0x%p",
-					inode_vp, vp);
+					old_inode, inode);
 		}
 
 		/*
@@ -231,7 +229,14 @@ finish_inode:
 
 	xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
-	xfs_inode_lock_init(ip, vp);
+
+	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
+		     "xfsino", ip->i_ino);
+	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+	init_waitqueue_head(&ip->i_ipin_wait);
+	atomic_set(&ip->i_pincount, 0);
+	initnsema(&ip->i_flock, 1, "xfsfino");
+
 	if (lock_flags)
 		xfs_ilock(ip, lock_flags);
 
@@ -334,7 +339,7 @@ finish_inode:
 	 * If we have a real type for an on-disk inode, we can set ops(&unlock)
 	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
 	 */
-	xfs_initialize_vnode(mp, vp, ip);
+	xfs_initialize_vnode(mp, inode, ip);
 	return 0;
 }
 
@@ -354,69 +359,58 @@ xfs_iget(
 	xfs_daddr_t	bno)
 {
 	struct inode	*inode;
-	bhv_vnode_t	*vp = NULL;
+	xfs_inode_t	*ip;
 	int		error;
 
 	XFS_STATS_INC(xs_ig_attempts);
 
 retry:
 	inode = iget_locked(mp->m_super, ino);
-	if (inode) {
-		xfs_inode_t	*ip;
-
-		vp = vn_from_inode(inode);
-		if (inode->i_state & I_NEW) {
-			vn_initialize(inode);
-			error = xfs_iget_core(vp, mp, tp, ino, flags,
-					lock_flags, ipp, bno);
-			if (error) {
-				vn_mark_bad(vp);
-				if (inode->i_state & I_NEW)
-					unlock_new_inode(inode);
-				iput(inode);
-			}
-		} else {
-			/*
-			 * If the inode is not fully constructed due to
-			 * filehandle mismatches wait for the inode to go
-			 * away and try again.
-			 *
-			 * iget_locked will call __wait_on_freeing_inode
-			 * to wait for the inode to go away.
-			 */
-			if (is_bad_inode(inode) ||
-			    ((ip = xfs_vtoi(vp)) == NULL)) {
-				iput(inode);
-				delay(1);
-				goto retry;
-			}
-
-			if (lock_flags != 0)
-				xfs_ilock(ip, lock_flags);
-			XFS_STATS_INC(xs_ig_found);
-			*ipp = ip;
-			error = 0;
+	if (!inode)
+		/* If we got no inode we are out of memory */
+		return ENOMEM;
+
+	if (inode->i_state & I_NEW) {
+		XFS_STATS_INC(vn_active);
+		XFS_STATS_INC(vn_alloc);
+
+		error = xfs_iget_core(inode, mp, tp, ino, flags,
+				lock_flags, ipp, bno);
+		if (error) {
+			make_bad_inode(inode);
+			if (inode->i_state & I_NEW)
+				unlock_new_inode(inode);
+			iput(inode);
 		}
-	} else
-		error = ENOMEM;	/* If we got no inode we are out of memory */
+		return error;
+	}
 
-	return error;
-}
+	/*
+	 * If the inode is not fully constructed due to
+	 * filehandle mismatches wait for the inode to go
+	 * away and try again.
+	 *
+	 * iget_locked will call __wait_on_freeing_inode
+	 * to wait for the inode to go away.
+	 */
+	if (is_bad_inode(inode)) {
+		iput(inode);
+		delay(1);
+		goto retry;
+	}
 
-/*
- * Do the setup for the various locks within the incore inode.
- */
-void
-xfs_inode_lock_init(
-	xfs_inode_t	*ip,
-	bhv_vnode_t	*vp)
-{
-	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
-		     "xfsino", ip->i_ino);
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-	init_waitqueue_head(&ip->i_ipin_wait);
-	atomic_set(&ip->i_pincount, 0);
-	initnsema(&ip->i_flock, 1, "xfsfino");
+	ip = XFS_I(inode);
+	if (!ip) {
+		iput(inode);
+		delay(1);
+		goto retry;
+	}
+
+	if (lock_flags != 0)
+		xfs_ilock(ip, lock_flags);
+	XFS_STATS_INC(xs_ig_found);
+	*ipp = ip;
+	return 0;
 }
 
 /*
@@ -456,11 +450,9 @@ void
 xfs_iput(xfs_inode_t	*ip,
 	 uint		lock_flags)
 {
-	bhv_vnode_t	*vp = XFS_ITOV(ip);
-
 	xfs_itrace_entry(ip);
 	xfs_iunlock(ip, lock_flags);
-	VN_RELE(vp);
+	IRELE(ip);
 }
 
 /*
@@ -470,20 +462,19 @@ void
 xfs_iput_new(xfs_inode_t	*ip,
 	     uint		lock_flags)
 {
-	bhv_vnode_t	*vp = XFS_ITOV(ip);
-	struct inode	*inode = vn_to_inode(vp);
+	struct inode	*inode = ip->i_vnode;
 
 	xfs_itrace_entry(ip);
 
 	if ((ip->i_d.di_mode == 0)) {
 		ASSERT(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-		vn_mark_bad(vp);
+		make_bad_inode(inode);
 	}
 	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
-	VN_RELE(vp);
+	IRELE(ip);
 }
 
 
@@ -496,8 +487,6 @@ xfs_iput_new(xfs_inode_t	*ip,
 void
 xfs_ireclaim(xfs_inode_t *ip)
 {
-	bhv_vnode_t	*vp;
-
 	/*
 	 * Remove from old hash list and mount list.
 	 */
@@ -526,9 +515,8 @@ xfs_ireclaim(xfs_inode_t *ip)
 	/*
 	 * Pull our behavior descriptor from the vnode chain.
 	 */
-	vp = XFS_ITOV_NULL(ip);
-	if (vp) {
-		vn_to_inode(vp)->i_private = NULL;
+	if (ip->i_vnode) {
+		ip->i_vnode->i_private = NULL;
 		ip->i_vnode = NULL;
 	}
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-09-19 19:02:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-09-19 19:03:10.000000000 +0200
@@ -493,7 +493,6 @@ void		xfs_ihash_init(struct xfs_mount *)
 void		xfs_ihash_free(struct xfs_mount *);
 xfs_inode_t	*xfs_inode_incore(struct xfs_mount *, xfs_ino_t,
 				  struct xfs_trans *);
-void            xfs_inode_lock_init(xfs_inode_t *, bhv_vnode_t *);
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 			 uint, uint, xfs_inode_t **, xfs_daddr_t);
 void		xfs_iput(xfs_inode_t *, uint);
