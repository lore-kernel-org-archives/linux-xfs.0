Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:10:03 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M49wTr002009
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:00 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CB526050C2
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:23 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2Hntc3rlyaT3VoPv for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:23 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M41uF3006119
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:01:56 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M41uIc006117
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 05:01:56 +0100
Date: Fri, 22 Feb 2008 05:01:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] cleanup vnode use in xfs_link
Message-ID: <20080222040156.GC5964@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-01-03 14:37:54.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-01-03 14:38:34.000000000 +0100
@@ -395,23 +395,22 @@ xfs_vn_link(
 	struct inode	*dir,
 	struct dentry	*dentry)
 {
-	struct inode	*ip;	/* inode of guy being linked to */
-	bhv_vnode_t	*vp;	/* vp of name being linked */
+	struct inode	*inode;	/* inode of guy being linked to */
 	int		error;
 
-	ip = old_dentry->d_inode;	/* inode being linked to */
-	vp = vn_from_inode(ip);
+	inode = old_dentry->d_inode;
 
-	VN_HOLD(vp);
-	error = xfs_link(XFS_I(dir), vp, dentry);
+	igrab(inode);
+	error = xfs_link(XFS_I(dir), XFS_I(inode), dentry);
 	if (unlikely(error)) {
-		VN_RELE(vp);
-	} else {
-		xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
-		xfs_validate_fields(ip);
-		d_instantiate(dentry, ip);
+		iput(inode);
+		return -error;
 	}
-	return -error;
+
+	xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
+	xfs_validate_fields(inode);
+	d_instantiate(dentry, inode);
+	return 0;
 }
 
 STATIC int
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-01-03 14:38:31.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-01-03 14:38:34.000000000 +0100
@@ -2489,12 +2489,10 @@ xfs_remove(
 int
 xfs_link(
 	xfs_inode_t		*tdp,
-	bhv_vnode_t		*src_vp,
+	xfs_inode_t		*sip,
 	bhv_vname_t		*dentry)
 {
-	bhv_vnode_t		*target_dir_vp = XFS_ITOV(tdp);
 	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_inode_t		*sip = xfs_vtoi(src_vp);
 	xfs_trans_t		*tp;
 	xfs_inode_t		*ips[2];
 	int			error;
@@ -2507,10 +2505,10 @@ xfs_link(
 	int			target_namelen;
 
 	xfs_itrace_entry(tdp);
-	xfs_itrace_entry(xfs_vtoi(src_vp));
+	xfs_itrace_entry(sip);
 
 	target_namelen = VNAMELEN(dentry);
-	ASSERT(!VN_ISDIR(src_vp));
+	ASSERT(!S_ISDIR(sip->i_d.di_mode));
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -2562,8 +2560,8 @@ xfs_link(
 	 * xfs_trans_cancel will both unlock the inodes and
 	 * decrement the associated ref counts.
 	 */
-	VN_HOLD(src_vp);
-	VN_HOLD(target_dir_vp);
+	IHOLD(sip);
+	IHOLD(tdp);
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-01-03 14:37:54.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-01-03 14:38:50.000000000 +0100
@@ -28,7 +28,7 @@ int xfs_lookup(struct xfs_inode *dp, bhv
 int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry, mode_t mode,
 		xfs_dev_t rdev, struct xfs_inode **ipp, struct cred *credp);
 int xfs_remove(struct xfs_inode *dp, bhv_vname_t	*dentry);
-int xfs_link(struct xfs_inode *tdp, bhv_vnode_t *src_vp,
+int xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
 		bhv_vname_t *dentry);
 int xfs_mkdir(struct xfs_inode *dp, bhv_vname_t *dentry,
 		mode_t mode, struct xfs_inode **ipp, struct cred *credp);
