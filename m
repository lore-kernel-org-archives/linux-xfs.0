Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Dec 2007 12:29:13 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBEKT34H000317
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:29:06 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAF3A484C23
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:29:14 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id GubRwYi5tNia3NA2 for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:29:14 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lBEKQWF3023598
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 21:26:32 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lBEKQWTw023596
	for xfs@oss.sgi.com; Fri, 14 Dec 2007 21:26:32 +0100
Date: Fri, 14 Dec 2007 21:26:31 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] kill xfs_root
Message-ID: <20071214202631.GB23248@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The only caller (xfs_fs_fill_super) can simplify call igrab on the
root inode.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-12-13 20:12:18.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-12-13 20:12:23.000000000 +0100
@@ -309,4 +309,3 @@ EXPORT_SYMBOL(xfs_ichgtime_fast);
 EXPORT_SYMBOL(xfs_free_eofblocks);
 
 EXPORT_SYMBOL(xfs_do_force_shutdown);
-EXPORT_SYMBOL(xfs_root);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-12-13 20:11:13.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-12-13 20:11:56.000000000 +0100
@@ -1287,9 +1287,11 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
-	error = xfs_root(mp, &rootvp);
-	if (error)
+	rootvp = igrab(mp->m_rootip->i_vnode);
+	if (!rootvp) {
+		error = ENOENT;
 		goto fail_unmount;
+	}
 
 	sb->s_root = d_alloc_root(vn_to_inode(rootvp));
 	if (!sb->s_root) {
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-12-13 20:11:13.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-12-13 20:12:03.000000000 +0100
@@ -808,26 +808,6 @@ fscorrupt_out2:
 }
 
 /*
- * xfs_root extracts the root vnode from a vfs.
- *
- * vfsp -- the vfs struct for the desired file system
- * vpp  -- address of the caller's vnode pointer which should be
- *         set to the desired fs root vnode
- */
-int
-xfs_root(
-	xfs_mount_t	*mp,
-	bhv_vnode_t	**vpp)
-{
-	bhv_vnode_t	*vp;
-
-	vp = XFS_ITOV(mp->m_rootip);
-	VN_HOLD(vp);
-	*vpp = vp;
-	return 0;
-}
-
-/*
  * xfs_sync flushes any pending I/O to file system vfsp.
  *
  * This routine is called by vfs_sync() to make sure that things make it
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2007-12-13 20:12:05.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2007-12-13 20:12:07.000000000 +0100
@@ -13,7 +13,6 @@ int xfs_mount(struct xfs_mount *mp, stru
 int xfs_unmount(struct xfs_mount *mp, int flags, struct cred *credp);
 int xfs_mntupdate(struct xfs_mount *mp, int *flags,
 		struct xfs_mount_args *args);
-int xfs_root(struct xfs_mount *mp, bhv_vnode_t **vpp);
 int xfs_sync(struct xfs_mount *mp, int flags);
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
