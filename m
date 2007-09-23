Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 04:42:11 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8NBg5Q3022702
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 04:42:08 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8NBg7A5009650
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 13:42:07 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8NBg6o0009647
	for xfs@oss.sgi.com; Sun, 23 Sep 2007 13:42:06 +0200
Date: Sun, 23 Sep 2007 13:42:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup vnode useage in xfs_ioctl.c
Message-ID: <20070923114206.GA9585@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_ioctl.c passes around vnode pointers quite a lot, but all places
already have the Linux inode which is identical to the vnode these
days.  Clean the code up to always use the Linux inode.

Note: this requires '[PATCH 4/4] avoid xfs_getattr in XFS_IOC_FSGETXATTR
ioctl' applied first.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-09-19 18:49:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-09-19 18:51:21.000000000 +0200
@@ -75,7 +75,6 @@ xfs_find_handle(
 	xfs_handle_t		handle;
 	xfs_fsop_handlereq_t	hreq;
 	struct inode		*inode;
-	bhv_vnode_t		*vp;
 
 	if (copy_from_user(&hreq, arg, sizeof(hreq)))
 		return -XFS_ERROR(EFAULT);
@@ -134,21 +133,16 @@ xfs_find_handle(
 		return -XFS_ERROR(EBADF);
 	}
 
-	/* we need the vnode */
-	vp = vn_from_inode(inode);
-
 	/* now we can grab the fsid */
 	memcpy(&handle.ha_fsid, XFS_I(inode)->i_mount->m_fixedfsid,
 			sizeof(xfs_fsid_t));
 	hsize = sizeof(xfs_fsid_t);
 
 	if (cmd != XFS_IOC_PATH_TO_FSHANDLE) {
-		xfs_inode_t	*ip;
+		xfs_inode_t	*ip = XFS_I(inode);
 		int		lock_mode;
 
 		/* need to get access to the xfs_inode to read the generation */
-		ip = xfs_vtoi(vp);
-		ASSERT(ip);
 		lock_mode = xfs_ilock_map_shared(ip);
 
 		/* fill in fid section of handle from inode */
@@ -176,21 +170,19 @@ xfs_find_handle(
 
 
 /*
- * Convert userspace handle data into vnode (and inode).
- * We [ab]use the fact that all the fsop_handlereq ioctl calls
- * have a data structure argument whose first component is always
- * a xfs_fsop_handlereq_t, so we can cast to and from this type.
- * This allows us to optimise the copy_from_user calls and gives
- * a handy, shared routine.
+ * Convert userspace handle data into inode.
+ *
+ * We use the fact that all the fsop_handlereq ioctl calls have a data
+ * structure argument whose first component is always a xfs_fsop_handlereq_t,
+ * so we can pass that sub structure into this handy, shared routine.
  *
- * If no error, caller must always VN_RELE the returned vp.
+ * If no error, caller must always iput the returned inode.
  */
 STATIC int
 xfs_vget_fsop_handlereq(
 	xfs_mount_t		*mp,
 	struct inode		*parinode,	/* parent inode pointer    */
 	xfs_fsop_handlereq_t	*hreq,
-	bhv_vnode_t		**vp,
 	struct inode		**inode)
 {
 	void			__user *hanp;
@@ -199,8 +191,6 @@ xfs_vget_fsop_handlereq(
 	xfs_handle_t		*handlep;
 	xfs_handle_t		handle;
 	xfs_inode_t		*ip;
-	struct inode		*inodep;
-	bhv_vnode_t		*vpp;
 	xfs_ino_t		ino;
 	__u32			igen;
 	int			error;
@@ -241,7 +231,7 @@ xfs_vget_fsop_handlereq(
 	}
 
 	/*
-	 * Get the XFS inode, building a vnode to go with it.
+	 * Get the XFS inode, building a Linux inode to go with it.
 	 */
 	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, 0);
 	if (error)
@@ -253,12 +243,9 @@ xfs_vget_fsop_handlereq(
 		return XFS_ERROR(ENOENT);
 	}
 
-	vpp = XFS_ITOV(ip);
-	inodep = vn_to_inode(vpp);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	*vp = vpp;
-	*inode = inodep;
+	*inode = ip->i_vnode;
 	return 0;
 }
 
@@ -275,7 +262,6 @@ xfs_open_by_handle(
 	struct file		*filp;
 	struct inode		*inode;
 	struct dentry		*dentry;
-	bhv_vnode_t		*vp;
 	xfs_fsop_handlereq_t	hreq;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -283,7 +269,7 @@ xfs_open_by_handle(
 	if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &hreq, &vp, &inode);
+	error = xfs_vget_fsop_handlereq(mp, parinode, &hreq, &inode);
 	if (error)
 		return -error;
 
@@ -385,7 +371,6 @@ xfs_readlink_by_handle(
 {
 	struct inode		*inode;
 	xfs_fsop_handlereq_t	hreq;
-	bhv_vnode_t		*vp;
 	__u32			olen;
 	void			*link;
 	int			error;
@@ -395,7 +380,7 @@ xfs_readlink_by_handle(
 	if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &hreq, &vp, &inode);
+	error = xfs_vget_fsop_handlereq(mp, parinode, &hreq, &inode);
 	if (error)
 		return -error;
 
@@ -438,34 +423,32 @@ xfs_fssetdm_by_handle(
 	struct fsdmidata	fsd;
 	xfs_fsop_setdm_handlereq_t dmhreq;
 	struct inode		*inode;
-	bhv_vnode_t		*vp;
 
 	if (!capable(CAP_MKNOD))
 		return -XFS_ERROR(EPERM);
 	if (copy_from_user(&dmhreq, arg, sizeof(xfs_fsop_setdm_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &dmhreq.hreq, &vp, &inode);
+	error = xfs_vget_fsop_handlereq(mp, parinode, &dmhreq.hreq, &inode);
 	if (error)
 		return -error;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode)) {
-		VN_RELE(vp);
-		return -XFS_ERROR(EPERM);
+		error = -XFS_ERROR(EPERM);
+		goto out;
 	}
 
 	if (copy_from_user(&fsd, dmhreq.data, sizeof(fsd))) {
-		VN_RELE(vp);
-		return -XFS_ERROR(EFAULT);
+		error = -XFS_ERROR(EFAULT);
+		goto out;
 	}
 
-	error = xfs_set_dmattrs(xfs_vtoi(vp),
-			fsd.fsd_dmevmask, fsd.fsd_dmstate);
+	error = -xfs_set_dmattrs(XFS_I(inode), fsd.fsd_dmevmask,
+				 fsd.fsd_dmstate);
 
-	VN_RELE(vp);
-	if (error)
-		return -error;
-	return 0;
+ out:
+	iput(inode);
+	return error;
 }
 
 STATIC int
@@ -478,7 +461,6 @@ xfs_attrlist_by_handle(
 	attrlist_cursor_kern_t	*cursor;
 	xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct inode		*inode;
-	bhv_vnode_t		*vp;
 	char			*kbuf;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -488,8 +470,7 @@ xfs_attrlist_by_handle(
 	if (al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &al_hreq.hreq,
-			&vp, &inode);
+	error = xfs_vget_fsop_handlereq(mp, parinode, &al_hreq.hreq, &inode);
 	if (error)
 		goto out;
 
@@ -509,7 +490,7 @@ xfs_attrlist_by_handle(
  out_kfree:
 	kfree(kbuf);
  out_vn_rele:
-	VN_RELE(vp);
+	iput(inode);
  out:
 	return -error;
 }
@@ -598,7 +579,6 @@ xfs_attrmulti_by_handle(
 	xfs_attr_multiop_t	*ops;
 	xfs_fsop_attrmulti_handlereq_t am_hreq;
 	struct inode		*inode;
-	bhv_vnode_t		*vp;
 	unsigned int		i, size;
 	char			*attr_name;
 
@@ -607,7 +587,7 @@ xfs_attrmulti_by_handle(
 	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &am_hreq.hreq, &vp, &inode);
+	error = xfs_vget_fsop_handlereq(mp, parinode, &am_hreq.hreq, &inode);
 	if (error)
 		goto out;
 
@@ -666,7 +646,7 @@ xfs_attrmulti_by_handle(
  out_kfree_ops:
 	kfree(ops);
  out_vn_rele:
-	VN_RELE(vp);
+	iput(inode);
  out:
 	return -error;
 }
@@ -702,7 +682,6 @@ xfs_ioc_fsgeometry(
 
 STATIC int
 xfs_ioc_xattr(
-	bhv_vnode_t		*vp,
 	xfs_inode_t		*ip,
 	struct file		*filp,
 	unsigned int		cmd,
@@ -735,7 +714,6 @@ xfs_ioctl(
 	void			__user *arg)
 {
 	struct inode		*inode = filp->f_path.dentry->d_inode;
-	bhv_vnode_t		*vp = vn_from_inode(inode);
 	xfs_mount_t		*mp = ip->i_mount;
 	int			error;
 
@@ -795,7 +773,7 @@ xfs_ioctl(
 	case XFS_IOC_GETXFLAGS:
 	case XFS_IOC_SETXFLAGS:
 	case XFS_IOC_FSSETXATTR:
-		return xfs_ioc_xattr(vp, ip, filp, cmd, arg);
+		return xfs_ioc_xattr(ip, filp, cmd, arg);
 
 	case XFS_IOC_FSSETDM: {
 		struct fsdmidata	dmi;
@@ -1206,7 +1184,6 @@ xfs_ioc_fsgetxattr(
 
 STATIC int
 xfs_ioc_xattr(
-	bhv_vnode_t		*vp,
 	xfs_inode_t		*ip,
 	struct file		*filp,
 	unsigned int		cmd,
@@ -1240,7 +1217,7 @@ xfs_ioc_xattr(
 
 		error = xfs_setattr(ip, vattr, attr_flags, NULL);
 		if (likely(!error))
-			vn_revalidate(vp);	/* update flags */
+			vn_revalidate(XFS_ITOV(ip));	/* update flags */
 		error = -error;
 		break;
 	}
@@ -1275,7 +1252,7 @@ xfs_ioc_xattr(
 
 		error = xfs_setattr(ip, vattr, attr_flags, NULL);
 		if (likely(!error))
-			vn_revalidate(vp);	/* update flags */
+			vn_revalidate(XFS_ITOV(ip));	/* update flags */
 		error = -error;
 		break;
 	}
