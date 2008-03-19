Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 13:50:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JKoMAx030987
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:50:24 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B3276C0450
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:50:54 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id b8G91cCnvj53Yq5u for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:50:54 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m2JKeFF3023707
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 21:40:15 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m2JKeEFj023705
	for xfs@oss.sgi.com; Wed, 19 Mar 2008 21:40:14 +0100
Date: Wed, 19 Mar 2008 21:40:14 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] split xfs_ioc_xattr
Message-ID: <20080319204014.GA23644@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The three subcases of xfs_ioc_xattr don't share any semantics and almost
no code, so split it into three separate helpers.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-03-04 18:14:57.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-03-04 18:25:51.000000000 +0100
@@ -871,85 +871,85 @@ xfs_ioc_fsgetxattr(
 }
 
 STATIC int
-xfs_ioc_xattr(
+xfs_ioc_fssetxattr(
 	xfs_inode_t		*ip,
 	struct file		*filp,
-	unsigned int		cmd,
 	void			__user *arg)
 {
 	struct fsxattr		fa;
 	struct bhv_vattr	*vattr;
-	int			error = 0;
+	int			error;
 	int			attr_flags;
-	unsigned int		flags;
+
+	if (copy_from_user(&fa, arg, sizeof(fa)))
+		return -EFAULT;
 
 	vattr = kmalloc(sizeof(*vattr), GFP_KERNEL);
 	if (unlikely(!vattr))
 		return -ENOMEM;
 
-	switch (cmd) {
-	case XFS_IOC_FSSETXATTR: {
-		if (copy_from_user(&fa, arg, sizeof(fa))) {
-			error = -EFAULT;
-			break;
-		}
-
-		attr_flags = 0;
-		if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-			attr_flags |= ATTR_NONBLOCK;
-
-		vattr->va_mask = XFS_AT_XFLAGS | XFS_AT_EXTSIZE | XFS_AT_PROJID;
-		vattr->va_xflags  = fa.fsx_xflags;
-		vattr->va_extsize = fa.fsx_extsize;
-		vattr->va_projid  = fa.fsx_projid;
-
-		error = xfs_setattr(ip, vattr, attr_flags, NULL);
-		if (likely(!error))
-			vn_revalidate(XFS_ITOV(ip));	/* update flags */
-		error = -error;
-		break;
-	}
-
-	case XFS_IOC_GETXFLAGS: {
-		flags = xfs_di2lxflags(ip->i_d.di_flags);
-		if (copy_to_user(arg, &flags, sizeof(flags)))
-			error = -EFAULT;
-		break;
-	}
-
-	case XFS_IOC_SETXFLAGS: {
-		if (copy_from_user(&flags, arg, sizeof(flags))) {
-			error = -EFAULT;
-			break;
-		}
-
-		if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
-			      FS_NOATIME_FL | FS_NODUMP_FL | \
-			      FS_SYNC_FL)) {
-			error = -EOPNOTSUPP;
-			break;
-		}
-
-		attr_flags = 0;
-		if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-			attr_flags |= ATTR_NONBLOCK;
-
-		vattr->va_mask = XFS_AT_XFLAGS;
-		vattr->va_xflags = xfs_merge_ioc_xflags(flags,
-							xfs_ip2xflags(ip));
-
-		error = xfs_setattr(ip, vattr, attr_flags, NULL);
-		if (likely(!error))
-			vn_revalidate(XFS_ITOV(ip));	/* update flags */
-		error = -error;
-		break;
-	}
+	attr_flags = 0;
+	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
+		attr_flags |= ATTR_NONBLOCK;
+
+	vattr->va_mask = XFS_AT_XFLAGS | XFS_AT_EXTSIZE | XFS_AT_PROJID;
+	vattr->va_xflags  = fa.fsx_xflags;
+	vattr->va_extsize = fa.fsx_extsize;
+	vattr->va_projid  = fa.fsx_projid;
+
+	error = -xfs_setattr(ip, vattr, attr_flags, NULL);
+	if (!error)
+		vn_revalidate(XFS_ITOV(ip));	/* update flags */
+	kfree(vattr);
+	return 0;
+}
 
-	default:
-		error = -ENOTTY;
-		break;
-	}
+STATIC int
+xfs_ioc_getxflags(
+	xfs_inode_t		*ip,
+	void			__user *arg)
+{
+	unsigned int		flags;
+
+	flags = xfs_di2lxflags(ip->i_d.di_flags);
+	if (copy_to_user(arg, &flags, sizeof(flags)))
+		return -EFAULT;
+	return 0;
+}
 
+STATIC int
+xfs_ioc_setxflags(
+	xfs_inode_t		*ip,
+	struct file		*filp,
+	void			__user *arg)
+{
+	struct bhv_vattr	*vattr;
+	unsigned int		flags;
+	int			attr_flags;
+	int			error;
+
+	if (copy_from_user(&flags, arg, sizeof(flags)))
+		return -EFAULT;
+
+	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
+		      FS_NOATIME_FL | FS_NODUMP_FL | \
+		      FS_SYNC_FL))
+		return -EOPNOTSUPP;
+
+	vattr = kmalloc(sizeof(*vattr), GFP_KERNEL);
+	if (unlikely(!vattr))
+		return -ENOMEM;
+
+	attr_flags = 0;
+	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
+		attr_flags |= ATTR_NONBLOCK;
+
+	vattr->va_mask = XFS_AT_XFLAGS;
+	vattr->va_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
+
+	error = -xfs_setattr(ip, vattr, attr_flags, NULL);
+	if (likely(!error))
+		vn_revalidate(XFS_ITOV(ip));	/* update flags */
 	kfree(vattr);
 	return error;
 }
@@ -1090,10 +1090,12 @@ xfs_ioctl(
 		return xfs_ioc_fsgetxattr(ip, 0, arg);
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattr(ip, 1, arg);
+	case XFS_IOC_FSSETXATTR:
+		return xfs_ioc_fssetxattr(ip, filp, arg);
 	case XFS_IOC_GETXFLAGS:
+		return xfs_ioc_getxflags(ip, arg);
 	case XFS_IOC_SETXFLAGS:
-	case XFS_IOC_FSSETXATTR:
-		return xfs_ioc_xattr(ip, filp, cmd, arg);
+		return xfs_ioc_setxflags(ip, filp, arg);
 
 	case XFS_IOC_FSSETDM: {
 		struct fsdmidata	dmi;
