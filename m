Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 12:49:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NJmx03010830
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:00 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AFACE8D056
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:49 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2rNWIStRqLY6BIoD for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:49 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NJncNg006594
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 21:49:38 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NJncEO006592
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 21:49:38 +0200
Date: Wed, 23 Jul 2008 21:49:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] kill vn_to_inode
Message-ID: <20080723194938.GC6188@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

bhv_vnode_t is just a typedef for struct inode, so there's no need for
a helper to convert between the two.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-07-23 19:31:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2008-07-23 19:31:25.000000000 +0200
@@ -185,7 +185,7 @@
 #define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
 #define xfs_stack_trace()	dump_stack()
 #define xfs_itruncate_data(ip, off)	\
-	(-vmtruncate(vn_to_inode(VFS_I(ip)), (off)))
+	(-vmtruncate(VFS_I(ip), (off)))
 
 
 /* Move the kernel do_div definition off to one side */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 19:31:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 19:34:46.000000000 +0200
@@ -613,10 +613,9 @@ xfs_set_inodeops(
 STATIC_INLINE void
 xfs_revalidate_inode(
 	xfs_mount_t		*mp,
-	bhv_vnode_t		*vp,
+	struct inode		*inode,
 	xfs_inode_t		*ip)
 {
-	struct inode		*inode = vn_to_inode(vp);
 
 	inode->i_mode	= ip->i_d.di_mode;
 	inode->i_nlink	= ip->i_d.di_nlink;
@@ -665,13 +664,12 @@ xfs_revalidate_inode(
 void
 xfs_initialize_vnode(
 	struct xfs_mount	*mp,
-	bhv_vnode_t		*vp,
+	struct inode		*inode,
 	struct xfs_inode	*ip)
 {
-	struct inode		*inode = vn_to_inode(vp);
 
 	if (!ip->i_vnode) {
-		ip->i_vnode = vp;
+		ip->i_vnode = inode;
 		inode->i_private = ip;
 	}
 
@@ -683,7 +681,7 @@ xfs_initialize_vnode(
 	 * finish our work.
 	 */
 	if (ip->i_d.di_mode != 0 && (inode->i_state & I_NEW)) {
-		xfs_revalidate_inode(mp, vp, ip);
+		xfs_revalidate_inode(mp, inode, ip);
 		xfs_set_inodeops(inode);
 
 		xfs_iflags_clear(ip, XFS_INEW);
@@ -987,7 +985,7 @@ xfs_fs_alloc_inode(
 	vp = kmem_zone_alloc(xfs_vnode_zone, KM_SLEEP);
 	if (unlikely(!vp))
 		return NULL;
-	return vn_to_inode(vp);
+	return vp;
 }
 
 STATIC void
@@ -1002,7 +1000,7 @@ xfs_fs_inode_init_once(
 	kmem_zone_t		*zonep,
 	void			*vnode)
 {
-	inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
+	inode_init_once((struct inode *)vnode);
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-07-23 19:30:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2008-07-23 19:31:15.000000000 +0200
@@ -94,7 +94,7 @@ vn_hold(
 
 	XFS_STATS_INC(vn_hold);
 
-	inode = igrab(vn_to_inode(vp));
+	inode = igrab(vp);
 	ASSERT(inode);
 
 	return vp;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-23 19:32:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-23 19:33:22.000000000 +0200
@@ -25,14 +25,6 @@ struct attrlist_cursor_kern;
 typedef struct inode	bhv_vnode_t;
 
 /*
- * Vnode to Linux inode mapping.
- */
-static inline struct inode *vn_to_inode(bhv_vnode_t *vnode)
-{
-	return vnode;
-}
-
-/*
  * Return values for xfs_inactive.  A return value of
  * VN_INACTIVE_NOCACHE implies that the file system behavior
  * has disassociated its state and bhv_desc_t from the vnode.
@@ -74,7 +66,7 @@ extern void	vn_ioerror(struct xfs_inode 
 
 static inline int vn_count(bhv_vnode_t *vp)
 {
-	return atomic_read(&vn_to_inode(vp)->i_count);
+	return atomic_read(&vp->i_count);
 }
 
 /*
@@ -88,15 +80,15 @@ extern bhv_vnode_t	*vn_hold(bhv_vnode_t 
 	  xfs_itrace_hold(XFS_I(vp), __FILE__, __LINE__, (inst_t *)__return_address))
 #define VN_RELE(vp)		\
 	  (xfs_itrace_rele(XFS_I(vp), __FILE__, __LINE__, (inst_t *)__return_address), \
-	   iput(vn_to_inode(vp)))
+	   iput(vp))
 #else
 #define VN_HOLD(vp)		((void)vn_hold(vp))
-#define VN_RELE(vp)		(iput(vn_to_inode(vp)))
+#define VN_RELE(vp)		(iput(vp))
 #endif
 
 static inline bhv_vnode_t *vn_grab(bhv_vnode_t *vp)
 {
-	return igrab(vn_to_inode(vp));
+	return igrab(vp);
 }
 
 /*
@@ -104,7 +96,7 @@ static inline bhv_vnode_t *vn_grab(bhv_v
  */
 static inline int VN_BAD(bhv_vnode_t *vp)
 {
-	return is_bad_inode(vn_to_inode(vp));
+	return is_bad_inode(vp);
 }
 
 /*
@@ -129,9 +121,9 @@ static inline void vn_atime_to_time_t(bh
 /*
  * Some useful predicates.
  */
-#define VN_MAPPED(vp)	mapping_mapped(vn_to_inode(vp)->i_mapping)
-#define VN_CACHED(vp)	(vn_to_inode(vp)->i_mapping->nrpages)
-#define VN_DIRTY(vp)	mapping_tagged(vn_to_inode(vp)->i_mapping, \
+#define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)
+#define VN_CACHED(vp)	(vp->i_mapping->nrpages)
+#define VN_DIRTY(vp)	mapping_tagged(vp->i_mapping, \
 					PAGECACHE_TAG_DIRTY)
 
 
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-07-23 19:30:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-07-23 19:30:54.000000000 +0200
@@ -714,7 +714,7 @@ xfs_fsync(
 		return XFS_ERROR(EIO);
 
 	/* capture size updates in I/O completion before writing the inode. */
-	error = filemap_fdatawait(vn_to_inode(VFS_I(ip))->i_mapping);
+	error = filemap_fdatawait(VFS_I(ip)->i_mapping);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -2917,7 +2917,7 @@ xfs_reclaim(
 		XFS_MOUNT_ILOCK(mp);
 		spin_lock(&ip->i_flags_lock);
 		__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		vn_to_inode(vp)->i_private = NULL;
+		vp->i_private = NULL;
 		ip->i_vnode = NULL;
 		spin_unlock(&ip->i_flags_lock);
 		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
