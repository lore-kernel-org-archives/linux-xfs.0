Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 23:21:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O6LKPo010239
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:21:20 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87BD131FDBE
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:22:29 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 1JpBXCIU0AKS0v8c for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:22:29 -0700 (PDT)
Date: Thu, 24 Jul 2008 08:22:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] implement IHOLD/IRELE directly
Message-ID: <20080724062220.GB26938@lst.de>
References: <20080723194950.GF6188@lst.de> <20080723225548.GO6761@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723225548.GO6761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jul 24, 2008 at 08:55:48AM +1000, Dave Chinner wrote:
> On Wed, Jul 23, 2008 at 09:49:50PM +0200, Christoph Hellwig wrote:
> > Now that all direct calls to VN_HOLD/VN_RELE are gone we can implement
> > IHOLD/IRELE directly.
> > 
> > For the IHOLD case also replace igrab with a direct increment of i_count
> > because we are guaranteed to already have a live and referenced inode
> > by the VFS.  Also remove the vn_hold statistic because it's been rather
> > meaningless for some time with most references done by other callers.
> 
> Seeing as you are changing from an igrab() to a straight
> atomic_inc(), can you put an:
> 
> ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0)
> 
> into the IHOLD macro so we catch screwups in reference counting as
> quickly as possible?

Makes sense, updated patch below.  (Half-way through xfsqa with a debug
kernel so far)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-07-24 07:32:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-07-24 07:32:26.000000000 +0200
@@ -179,7 +179,6 @@ EXPORT_SYMBOL(uuid_getnodeuniq);
 EXPORT_SYMBOL(uuid_hash64);
 EXPORT_SYMBOL(uuid_is_nil);
 EXPORT_SYMBOL(uuid_table_remove);
-EXPORT_SYMBOL(vn_hold);
 
 #if defined(CONFIG_XFS_POSIX_ACL)
 EXPORT_SYMBOL(xfs_acl_vtoacl);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-07-24 07:32:10.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2008-07-24 07:32:26.000000000 +0200
@@ -82,24 +82,6 @@ vn_ioerror(
 		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ, f, l);
 }
 
-
-/*
- * Add a reference to a referenced vnode.
- */
-bhv_vnode_t *
-vn_hold(
-	bhv_vnode_t	*vp)
-{
-	struct inode	*inode;
-
-	XFS_STATS_INC(vn_hold);
-
-	inode = igrab(vp);
-	ASSERT(inode);
-
-	return vp;
-}
-
 #ifdef	XFS_INODE_TRACE
 
 /*
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-24 07:32:10.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-24 07:32:32.000000000 +0200
@@ -69,22 +69,18 @@ static inline int vn_count(bhv_vnode_t *
 	return atomic_read(&vp->i_count);
 }
 
-/*
- * Vnode reference counting functions (and macros for compatibility).
- */
-extern bhv_vnode_t	*vn_hold(bhv_vnode_t *);
-
-#if defined(XFS_INODE_TRACE)
-#define VN_HOLD(vp)		\
-	((void)vn_hold(vp),	\
-	  xfs_itrace_hold(XFS_I(vp), __FILE__, __LINE__, (inst_t *)__return_address))
-#define VN_RELE(vp)		\
-	  (xfs_itrace_rele(XFS_I(vp), __FILE__, __LINE__, (inst_t *)__return_address), \
-	   iput(vp))
-#else
-#define VN_HOLD(vp)		((void)vn_hold(vp))
-#define VN_RELE(vp)		(iput(vp))
-#endif
+#define IHOLD(ip) \
+do { \
+	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
+	atomic_inc(&(VFS_I(ip)->i_count)); \
+	xfs_itrace_hold((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+} while (0)
+
+#define IRELE(ip) \
+do { \
+	xfs_itrace_rele((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+	iput(VFS_I(ip)); \
+} while (0)
 
 static inline bhv_vnode_t *vn_grab(bhv_vnode_t *vp)
 {
Index: linux-2.6-xfs/fs/xfs/xfs_utils.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.h	2008-07-24 07:32:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.h	2008-07-24 07:32:26.000000000 +0200
@@ -18,9 +18,6 @@
 #ifndef __XFS_UTILS_H__
 #define __XFS_UTILS_H__
 
-#define IRELE(ip)	VN_RELE(VFS_I(ip))
-#define IHOLD(ip)	VN_HOLD(VFS_I(ip))
-
 extern int xfs_truncate_file(xfs_mount_t *, xfs_inode_t *);
 extern int xfs_dir_ialloc(xfs_trans_t **, xfs_inode_t *, mode_t, xfs_nlink_t,
 				xfs_dev_t, cred_t *, prid_t, int,
