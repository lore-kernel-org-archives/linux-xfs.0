Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 09:27:51 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EGRk4p028450
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 09:27:47 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8EGRlA5007349
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 18:27:47 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8EGRlMG007347
	for xfs@oss.sgi.com; Fri, 14 Sep 2007 18:27:47 +0200
Date: Fri, 14 Sep 2007 18:27:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] simplify validata_fields
Message-ID: <20070914162746.GB7110@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Stop using xfs_getattr and a onstack bhv_vattr_t just to get three
fields from the underlying inode and opencode copying from the inode
fields instead.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-09-06 10:13:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-09-06 10:18:06.000000000 +0200
@@ -179,18 +179,19 @@ xfs_ichgtime_fast(
  */
 STATIC void
 xfs_validate_fields(
-	struct inode	*ip,
-	bhv_vattr_t	*vattr)
+	struct inode		*inode)
 {
-	vattr->va_mask = XFS_AT_NLINK|XFS_AT_SIZE|XFS_AT_NBLOCKS;
-	if (!xfs_getattr(XFS_I(ip), vattr, ATTR_LAZY)) {
-		ip->i_nlink = vattr->va_nlink;
-		ip->i_blocks = vattr->va_nblocks;
-
-		/* we're under i_sem so i_size can't change under us */
-		if (i_size_read(ip) != vattr->va_size)
-			i_size_write(ip, vattr->va_size);
-	}
+	struct xfs_inode	*ip = XFS_I(inode);
+	loff_t size;
+
+	inode->i_nlink = ip->i_d.di_nlink;
+	inode->i_blocks =
+		XFS_FSB_TO_BB(ip->i_mount, ip->i_d.di_nblocks +
+					   ip->i_delayed_blks);
+	/* we're under i_sem so i_size can't change under us */
+	size = XFS_ISIZE(ip);
+	if (i_size_read(inode) != size)
+		i_size_write(inode, size);
 }
 
 /*
@@ -340,9 +341,9 @@ xfs_vn_mknod(
 		if (S_ISCHR(mode) || S_ISBLK(mode))
 			ip->i_rdev = rdev;
 		else if (S_ISDIR(mode))
-			xfs_validate_fields(ip, &vattr);
+			xfs_validate_fields(ip);
 		d_instantiate(dentry, ip);
-		xfs_validate_fields(dir, &vattr);
+		xfs_validate_fields(dir);
 	}
 	return -error;
 }
@@ -397,7 +398,6 @@ xfs_vn_link(
 {
 	struct inode	*ip;	/* inode of guy being linked to */
 	bhv_vnode_t	*vp;	/* vp of name being linked */
-	bhv_vattr_t	vattr;
 	int		error;
 
 	ip = old_dentry->d_inode;	/* inode being linked to */
@@ -409,7 +409,7 @@ xfs_vn_link(
 		VN_RELE(vp);
 	} else {
 		xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
-		xfs_validate_fields(ip, &vattr);
+		xfs_validate_fields(ip);
 		d_instantiate(dentry, ip);
 	}
 	return -error;
@@ -421,15 +421,14 @@ xfs_vn_unlink(
 	struct dentry	*dentry)
 {
 	struct inode	*inode;
-	bhv_vattr_t	vattr;
 	int		error;
 
 	inode = dentry->d_inode;
 
 	error = xfs_remove(XFS_I(dir), dentry);
 	if (likely(!error)) {
-		xfs_validate_fields(dir, &vattr);	/* size needs update */
-		xfs_validate_fields(inode, &vattr);
+		xfs_validate_fields(dir);	/* size needs update */
+		xfs_validate_fields(inode);
 	}
 	return -error;
 }
@@ -458,8 +457,8 @@ xfs_vn_symlink(
 		if (likely(!error)) {
 			ip = vn_to_inode(cvp);
 			d_instantiate(dentry, ip);
-			xfs_validate_fields(dir, &va);
-			xfs_validate_fields(ip, &va);
+			xfs_validate_fields(dir);
+			xfs_validate_fields(ip);
 		} else {
 			xfs_cleanup_inode(dir, cvp, dentry, 0);
 		}
@@ -473,13 +472,12 @@ xfs_vn_rmdir(
 	struct dentry	*dentry)
 {
 	struct inode	*inode = dentry->d_inode;
-	bhv_vattr_t	vattr;
 	int		error;
 
 	error = xfs_rmdir(XFS_I(dir), dentry);
 	if (likely(!error)) {
-		xfs_validate_fields(inode, &vattr);
-		xfs_validate_fields(dir, &vattr);
+		xfs_validate_fields(inode);
+		xfs_validate_fields(dir);
 	}
 	return -error;
 }
@@ -493,7 +491,6 @@ xfs_vn_rename(
 {
 	struct inode	*new_inode = ndentry->d_inode;
 	bhv_vnode_t	*tvp;	/* target directory */
-	bhv_vattr_t	vattr;
 	int		error;
 
 	tvp = vn_from_inode(ndir);
@@ -501,10 +498,10 @@ xfs_vn_rename(
 	error = xfs_rename(XFS_I(odir), odentry, tvp, ndentry);
 	if (likely(!error)) {
 		if (new_inode)
-			xfs_validate_fields(new_inode, &vattr);
-		xfs_validate_fields(odir, &vattr);
+			xfs_validate_fields(new_inode);
+		xfs_validate_fields(odir);
 		if (ndir != odir)
-			xfs_validate_fields(ndir, &vattr);
+			xfs_validate_fields(ndir);
 	}
 	return -error;
 }
