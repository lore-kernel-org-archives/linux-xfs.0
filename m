Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:02:22 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M42CH6031908
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:14 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0188F605031
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:12 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Dzp0uDLNENBLkoVA for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:12 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M427F3006162
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:02:07 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M427jn006160
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 05:02:07 +0100
Date: Fri, 22 Feb 2008 05:02:07 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] cleanup vnode use in xfs_lookup
Message-ID: <20080222040206.GE5964@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2008-01-03 14:53:44.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c	2008-01-03 14:54:21.000000000 +0100
@@ -213,17 +213,16 @@ xfs_fs_get_parent(
 	struct dentry		*child)
 {
 	int			error;
-	bhv_vnode_t		*cvp;
+	struct xfs_inode	*cip;
 	struct dentry		*parent;
 
-	cvp = NULL;
-	error = xfs_lookup(XFS_I(child->d_inode), &dotdot, &cvp);
+	error = xfs_lookup(XFS_I(child->d_inode), &dotdot, &cip);
 	if (unlikely(error))
 		return ERR_PTR(-error);
 
-	parent = d_alloc_anon(vn_to_inode(cvp));
+	parent = d_alloc_anon(cip->i_vnode);
 	if (unlikely(!parent)) {
-		VN_RELE(cvp);
+		iput(cip->i_vnode);
 		return ERR_PTR(-ENOMEM);
 	}
 	return parent;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-01-03 14:53:13.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-01-03 14:53:41.000000000 +0100
@@ -372,13 +372,13 @@ xfs_vn_lookup(
 	struct dentry	*dentry,
 	struct nameidata *nd)
 {
-	bhv_vnode_t	*cvp;
+	struct xfs_inode *cip;
 	int		error;
 
 	if (dentry->d_name.len >= MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	error = xfs_lookup(XFS_I(dir), dentry, &cvp);
+	error = xfs_lookup(XFS_I(dir), dentry, &cip);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
 			return ERR_PTR(-error);
@@ -386,7 +386,7 @@ xfs_vn_lookup(
 		return NULL;
 	}
 
-	return d_splice_alias(vn_to_inode(cvp), dentry);
+	return d_splice_alias(cip->i_vnode, dentry);
 }
 
 STATIC int
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-01-03 14:52:25.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-01-03 14:52:56.000000000 +0100
@@ -1765,7 +1765,7 @@ int
 xfs_lookup(
 	xfs_inode_t		*dp,
 	bhv_vname_t		*dentry,
-	bhv_vnode_t		**vpp)
+	xfs_inode_t		**ipp)
 {
 	xfs_inode_t		*ip;
 	xfs_ino_t		e_inum;
@@ -1780,7 +1780,7 @@ xfs_lookup(
 	lock_mode = xfs_ilock_map_shared(dp);
 	error = xfs_dir_lookup_int(dp, lock_mode, dentry, &e_inum, &ip);
 	if (!error) {
-		*vpp = XFS_ITOV(ip);
+		*ipp = ip;
 		xfs_itrace_ref(ip);
 	}
 	xfs_iunlock_map_shared(dp, lock_mode);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-01-03 14:52:57.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-01-03 14:53:08.000000000 +0100
@@ -24,7 +24,7 @@ int xfs_fsync(struct xfs_inode *ip, int 
 int xfs_release(struct xfs_inode *ip);
 int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, bhv_vname_t *dentry,
-		bhv_vnode_t **vpp);
+		struct xfs_inode **ipp);
 int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry, mode_t mode,
 		xfs_dev_t rdev, struct xfs_inode **ipp, struct cred *credp);
 int xfs_remove(struct xfs_inode *dp, bhv_vname_t	*dentry);
