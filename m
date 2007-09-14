Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 09:27:44 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EGRc4p028430
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 09:27:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8EGRcA5007302
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 18:27:38 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8EGRcAo007300
	for xfs@oss.sgi.com; Fri, 14 Sep 2007 18:27:38 +0200
Date: Fri, 14 Sep 2007 18:27:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] avoid xfs_getattr in XFS_IOC_FSGETXATTR ioctl
Message-ID: <20070914162738.GA7110@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

No need to call into xfs_getattr and put a big bhv_vattr_t on the stack
just to get a little information from the XFS inode.

Add a helper called xfs_ioc_fsgetxattr instead that deals with retriving
the information in a clean way.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-19 16:33:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-19 16:51:16.000000000 +0200
@@ -709,6 +709,12 @@ xfs_ioc_xattr(
 	void			__user *arg);
 
 STATIC int
+xfs_ioc_fsgetxattr(
+	xfs_inode_t		*ip,
+	int			attr,
+	void			__user *arg);
+
+STATIC int
 xfs_ioc_getbmap(
 	struct xfs_inode	*ip,
 	int			flags,
@@ -783,11 +789,13 @@ xfs_ioctl(
 	case XFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);
 
+	case XFS_IOC_FSGETXATTR:
+		return xfs_ioc_fsgetxattr(ip, 0, arg);
+	case XFS_IOC_FSGETXATTRA:
+		return xfs_ioc_fsgetxattr(ip, 1, arg);
 	case XFS_IOC_GETXFLAGS:
 	case XFS_IOC_SETXFLAGS:
-	case XFS_IOC_FSGETXATTR:
 	case XFS_IOC_FSSETXATTR:
-	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_xattr(vp, ip, filp, cmd, arg);
 
 	case XFS_IOC_FSSETDM: {
@@ -1162,6 +1170,42 @@ xfs_di2lxflags(
 }
 
 STATIC int
+xfs_ioc_fsgetxattr(
+	xfs_inode_t		*ip,
+	int			attr,
+	void			__user *arg)
+{
+	struct fsxattr		fa;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	fa.fsx_xflags = xfs_ip2xflags(ip);
+	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
+	fa.fsx_projid = ip->i_d.di_projid;
+
+	if (attr) {
+		if (ip->i_afp) {
+			if (ip->i_afp->if_flags & XFS_IFEXTENTS)
+				fa.fsx_nextents = ip->i_afp->if_bytes /
+							sizeof(xfs_bmbt_rec_t);
+			else
+				fa.fsx_nextents = ip->i_d.di_anextents;
+		} else
+			fa.fsx_nextents = 0;
+	} else {
+		if (ip->i_df.if_flags & XFS_IFEXTENTS)
+			fa.fsx_nextents = ip->i_df.if_bytes /
+						sizeof(xfs_bmbt_rec_t);
+		else
+			fa.fsx_nextents = ip->i_d.di_nextents;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (copy_to_user(arg, &fa, sizeof(fa)))
+		return -EFAULT;
+	return 0;
+}
+
+STATIC int
 xfs_ioc_xattr(
 	bhv_vnode_t		*vp,
 	xfs_inode_t		*ip,
@@ -1180,27 +1224,6 @@ xfs_ioc_xattr(
 		return -ENOMEM;
 
 	switch (cmd) {
-	case XFS_IOC_FSGETXATTR: {
-		vattr->va_mask = XFS_AT_XFLAGS | XFS_AT_EXTSIZE | \
-				 XFS_AT_NEXTENTS | XFS_AT_PROJID;
-		error = xfs_getattr(ip, vattr, 0);
-		if (unlikely(error)) {
-			error = -error;
-			break;
-		}
-
-		fa.fsx_xflags	= vattr->va_xflags;
-		fa.fsx_extsize	= vattr->va_extsize;
-		fa.fsx_nextents = vattr->va_nextents;
-		fa.fsx_projid	= vattr->va_projid;
-
-		if (copy_to_user(arg, &fa, sizeof(fa))) {
-			error = -EFAULT;
-			break;
-		}
-		break;
-	}
-
 	case XFS_IOC_FSSETXATTR: {
 		if (copy_from_user(&fa, arg, sizeof(fa))) {
 			error = -EFAULT;
@@ -1223,27 +1246,6 @@ xfs_ioc_xattr(
 		break;
 	}
 
-	case XFS_IOC_FSGETXATTRA: {
-		vattr->va_mask = XFS_AT_XFLAGS | XFS_AT_EXTSIZE | \
-				 XFS_AT_ANEXTENTS | XFS_AT_PROJID;
-		error = xfs_getattr(ip, vattr, 0);
-		if (unlikely(error)) {
-			error = -error;
-			break;
-		}
-
-		fa.fsx_xflags	= vattr->va_xflags;
-		fa.fsx_extsize	= vattr->va_extsize;
-		fa.fsx_nextents = vattr->va_anextents;
-		fa.fsx_projid	= vattr->va_projid;
-
-		if (copy_to_user(arg, &fa, sizeof(fa))) {
-			error = -EFAULT;
-			break;
-		}
-		break;
-	}
-
 	case XFS_IOC_GETXFLAGS: {
 		flags = xfs_di2lxflags(ip->i_d.di_flags);
 		if (copy_to_user(arg, &flags, sizeof(flags)))
