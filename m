Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 14:51:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TLpf6K032127
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:51:41 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E01B9B24ED
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:53:17 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id M7c5ymDjiirM725P for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:53:17 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8TLrFIF030714
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 23:53:15 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8TLrF2e030712
	for xfs@oss.sgi.com; Mon, 29 Sep 2008 23:53:15 +0200
Date: Mon, 29 Sep 2008 23:53:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] kill sys_cred
Message-ID: <20080929215315.GA30363@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

capable_cred has been unused for a while so we can kill it and sys_cred.
That also means the cred argument to xfs_setattr and
xfs_change_file_space can be removed now.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-09-29 18:20:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-09-29 18:24:15.000000000 +0200
@@ -2472,7 +2472,7 @@ xfs_dm_punch_hole(
 #endif
 
 	error = xfs_change_file_space(ip, XFS_IOC_UNRESVSP, &bf,
-				(xfs_off_t)off, sys_cred,
+				(xfs_off_t)off,
 				XFS_ATTR_DMI|XFS_ATTR_NOLOCK);
 
 	/*
@@ -2730,7 +2730,7 @@ xfs_dm_set_fileattr(
 		iattr.ia_size = stat.fa_size;
 	}
 
-	return -xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_DMI, NULL);
+	return -xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_DMI);
 }
 
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_cred.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_cred.h	2008-09-29 18:19:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_cred.h	2008-09-29 18:26:42.000000000 +0200
@@ -27,12 +27,4 @@ typedef struct cred {
 	/* EMPTY */
 } cred_t;
 
-extern struct cred *sys_cred;
-
-/* this is a hack.. (assumes sys_cred is the only cred_t in the system) */
-static inline int capable_cred(cred_t *cr, int cid)
-{
-	return (cr == sys_cred) ? 1 : capable(cid);
-}
-
 #endif  /* __XFS_CRED_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-29 18:24:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-29 18:24:44.000000000 +0200
@@ -694,8 +694,7 @@ xfs_ioc_space(
 	if (ioflags & IO_INVIS)
 		attr_flags |= XFS_ATTR_DMI;
 
-	error = xfs_change_file_space(ip, cmd, &bf, filp->f_pos,
-					      NULL, attr_flags);
+	error = xfs_change_file_space(ip, cmd, &bf, filp->f_pos, attr_flags);
 	return -error;
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-09-29 18:20:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-09-29 18:24:28.000000000 +0200
@@ -595,7 +595,7 @@ xfs_vn_setattr(
 	struct dentry	*dentry,
 	struct iattr	*iattr)
 {
-	return -xfs_setattr(XFS_I(dentry->d_inode), iattr, 0, NULL);
+	return -xfs_setattr(XFS_I(dentry->d_inode), iattr, 0);
 }
 
 /*
@@ -636,7 +636,7 @@ xfs_vn_fallocate(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 	error = xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
-				      0, NULL, XFS_ATTR_NOLOCK);
+				      0, XFS_ATTR_NOLOCK);
 	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode))
 		new_size = offset + len;
@@ -647,7 +647,7 @@ xfs_vn_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK, NULL);
+		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
 	}
 
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-09-29 18:19:42.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-09-29 18:19:45.000000000 +0200
@@ -172,7 +172,6 @@ EXPORT_SYMBOL(xfs_buf_offset);
 EXPORT_SYMBOL(xfs_buf_rele);
 EXPORT_SYMBOL(xfs_buf_readahead);
 EXPORT_SYMBOL(xfs_buf_unlock);
-EXPORT_SYMBOL(sys_cred);
 EXPORT_SYMBOL(uuid_create_nil);
 EXPORT_SYMBOL(uuid_equal);
 EXPORT_SYMBOL(uuid_getnodeuniq);
Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2008-09-29 18:19:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2008-09-29 18:22:31.000000000 +0200
@@ -759,7 +759,7 @@ xfs_acl_setmode(
 	if (gap && nomask)
 		iattr.ia_mode |= gap->ae_perm << 3;
 
-	return xfs_setattr(XFS_I(vp), &iattr, 0, sys_cred);
+	return xfs_setattr(XFS_I(vp), &iattr, 0);
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-09-29 18:20:55.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-09-29 18:25:13.000000000 +0200
@@ -57,8 +57,7 @@ int
 xfs_setattr(
 	struct xfs_inode	*ip,
 	struct iattr		*iattr,
-	int			flags,
-	cred_t			*credp)
+	int			flags)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
@@ -3452,7 +3451,6 @@ xfs_change_file_space(
 	int		cmd,
 	xfs_flock64_t	*bf,
 	xfs_off_t	offset,
-	cred_t		*credp,
 	int		attr_flags)
 {
 	xfs_mount_t	*mp = ip->i_mount;
@@ -3540,7 +3538,7 @@ xfs_change_file_space(
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = startoffset;
 
-		error = xfs_setattr(ip, &iattr, attr_flags, credp);
+		error = xfs_setattr(ip, &iattr, attr_flags);
 
 		if (error)
 			return error;
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-09-29 18:21:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-09-29 18:25:05.000000000 +0200
@@ -14,8 +14,7 @@ struct xfs_inode;
 struct xfs_iomap;
 
 
-int xfs_setattr(struct xfs_inode *ip, struct iattr *vap, int flags,
-		struct cred *credp);
+int xfs_setattr(struct xfs_inode *ip, struct iattr *vap, int flags);
 #define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
 #define	XFS_ATTR_NONBLOCK	0x02	/* return EAGAIN if operation would block */
 #define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
@@ -43,8 +42,7 @@ int xfs_inode_flush(struct xfs_inode *ip
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
 int xfs_reclaim(struct xfs_inode *ip);
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,
-		xfs_flock64_t *bf, xfs_off_t offset,
-		struct cred *credp, int	attr_flags);
+		xfs_flock64_t *bf, xfs_off_t offset, int attr_flags);
 int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 		struct xfs_inode *src_ip, struct xfs_inode *target_dp,
 		struct xfs_name *target_name, struct xfs_inode *target_ip);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_globals.c	2008-09-29 18:26:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c	2008-09-29 18:26:31.000000000 +0200
@@ -43,10 +43,3 @@ xfs_param_t xfs_params = {
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
 };
-
-/*
- * Global system credential structure.
- */
-static cred_t sys_cred_val;
-cred_t *sys_cred = &sys_cred_val;
-
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_globals.h	2008-09-29 18:26:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.h	2008-09-29 18:26:35.000000000 +0200
@@ -19,6 +19,5 @@
 #define __XFS_GLOBALS_H__
 
 extern uint64_t	xfs_panic_mask;		/* set to cause more panics */
-extern struct cred *sys_cred;
 
 #endif	/* __XFS_GLOBALS_H__ */
