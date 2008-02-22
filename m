Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:10:06 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M49xNw002011
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:01 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7552B6050C2
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:25 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id C9U9OnHLyreO5ONW for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:25 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M42HF3006199
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:02:17 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M42H08006197
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 05:02:17 +0100
Date: Fri, 22 Feb 2008 05:02:17 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] cleanup vnode use in xfs_iops.c
Message-ID: <20080222040217.GG5964@lst.de>
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-01-03 14:59:58.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-01-03 15:03:03.000000000 +0100
@@ -62,12 +62,11 @@ void
 xfs_synchronize_atime(
 	xfs_inode_t	*ip)
 {
-	bhv_vnode_t	*vp;
+	struct inode	*inode = ip->i_vnode;
 
-	vp = XFS_ITOV_NULL(ip);
-	if (vp) {
-		ip->i_d.di_atime.t_sec = (__int32_t)vp->i_atime.tv_sec;
-		ip->i_d.di_atime.t_nsec = (__int32_t)vp->i_atime.tv_nsec;
+	if (inode) {
+		ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
+		ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
 	}
 }
 
@@ -80,11 +79,10 @@ void
 xfs_mark_inode_dirty_sync(
 	xfs_inode_t	*ip)
 {
-	bhv_vnode_t	*vp;
+	struct inode	*inode = ip->i_vnode;
 
-	vp = XFS_ITOV_NULL(ip);
-	if (vp)
-		mark_inode_dirty_sync(vn_to_inode(vp));
+	if (inode)
+		mark_inode_dirty_sync(inode);
 }
 
 /*
@@ -215,26 +213,26 @@ xfs_validate_fields(
  */
 STATIC int
 xfs_init_security(
-	bhv_vnode_t	*vp,
+	struct inode	*inode,
 	struct inode	*dir)
 {
-	struct inode	*ip = vn_to_inode(vp);
+	struct xfs_inode *ip = XFS_I(inode);
 	size_t		length;
 	void		*value;
 	char		*name;
 	int		error;
 
-	error = security_inode_init_security(ip, dir, &name, &value, &length);
+	error = security_inode_init_security(inode, dir, &name,
+					     &value, &length);
 	if (error) {
 		if (error == -EOPNOTSUPP)
 			return 0;
 		return -error;
 	}
 
-	error = xfs_attr_set(XFS_I(ip), name, value,
-			length, ATTR_SECURE);
+	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
 	if (!error)
-		xfs_iflags_set(XFS_I(ip), XFS_IMODIFIED);
+		xfs_iflags_set(ip, XFS_IMODIFIED);
 
 	kfree(name);
 	kfree(value);
@@ -244,7 +242,7 @@ xfs_init_security(
 STATIC void
 xfs_cleanup_inode(
 	struct inode	*dir,
-	bhv_vnode_t	*vp,
+	struct inode	*inode,
 	struct dentry	*dentry,
 	int		mode)
 {
@@ -255,14 +253,14 @@ xfs_cleanup_inode(
 	 * xfs_init_security we must back out.
 	 * ENOSPC can hit here, among other things.
 	 */
-	teardown.d_inode = vn_to_inode(vp);
+	teardown.d_inode = inode;
 	teardown.d_name = dentry->d_name;
 
 	if (S_ISDIR(mode))
 		xfs_rmdir(XFS_I(dir), &teardown);
 	else
 		xfs_remove(XFS_I(dir), &teardown);
-	VN_RELE(vp);
+	iput(inode);
 }
 
 STATIC int
