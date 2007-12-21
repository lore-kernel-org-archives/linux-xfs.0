Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Dec 2007 22:22:30 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBL6MKlH010826
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:23 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C1C24AB255
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:32 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id RPWXjb3RAQh8wlye for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:32 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lBL6MQF3023430
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Dec 2007 07:22:27 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lBL6MQXD023428
	for xfs@oss.sgi.com; Fri, 21 Dec 2007 07:22:26 +0100
Date: Fri, 21 Dec 2007 07:22:26 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] use generic_permission
Message-ID: <20071221062226.GD23180@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Now that all direct caller of xfs_iaccess are gone we can kill
xfs_iaccess and xfs_access and just use generic_permission with a
check_acl callback.  This is required for the per-mount read-only
patchset in -mm to work properly with XFS.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-12-19 16:55:36.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-12-19 16:57:33.000000000 +0100
@@ -3583,69 +3583,6 @@ xfs_iflush_all(
 	XFS_MOUNT_IUNLOCK(mp);
 }
 
-/*
- * xfs_iaccess: check accessibility of inode for mode.
- */
-int
-xfs_iaccess(
-	xfs_inode_t	*ip,
-	mode_t		mode,
-	cred_t		*cr)
-{
-	int		error;
-	mode_t		orgmode = mode;
-	struct inode	*inode = vn_to_inode(XFS_ITOV(ip));
-
-	if (mode & S_IWUSR) {
-		umode_t		imode = inode->i_mode;
-
-		if (IS_RDONLY(inode) &&
-		    (S_ISREG(imode) || S_ISDIR(imode) || S_ISLNK(imode)))
-			return XFS_ERROR(EROFS);
-
-		if (IS_IMMUTABLE(inode))
-			return XFS_ERROR(EACCES);
-	}
-
-	/*
-	 * If there's an Access Control List it's used instead of
-	 * the mode bits.
-	 */
-	if ((error = _ACL_XFS_IACCESS(ip, mode, cr)) != -1)
-		return error ? XFS_ERROR(error) : 0;
-
-	if (current_fsuid(cr) != ip->i_d.di_uid) {
-		mode >>= 3;
-		if (!in_group_p((gid_t)ip->i_d.di_gid))
-			mode >>= 3;
-	}
-
-	/*
-	 * If the DACs are ok we don't need any capability check.
-	 */
-	if ((ip->i_d.di_mode & mode) == mode)
-		return 0;
-	/*
-	 * Read/write DACs are always overridable.
-	 * Executable DACs are overridable if at least one exec bit is set.
-	 */
-	if (!(orgmode & S_IXUSR) ||
-	    (inode->i_mode & S_IXUGO) || S_ISDIR(inode->i_mode))
-		if (capable_cred(cr, CAP_DAC_OVERRIDE))
-			return 0;
-
-	if ((orgmode == S_IRUSR) ||
-	    (S_ISDIR(inode->i_mode) && (!(orgmode & S_IWUSR)))) {
-		if (capable_cred(cr, CAP_DAC_READ_SEARCH))
-			return 0;
-#ifdef	NOISE
-		cmn_err(CE_NOTE, "Ick: mode=%o, orgmode=%o", mode, orgmode);
-#endif	/* NOISE */
-		return XFS_ERROR(EACCES);
-	}
-	return XFS_ERROR(EACCES);
-}
-
 #ifdef XFS_ILOCK_TRACE
 ktrace_t	*xfs_ilock_trace_buf;
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-12-19 16:55:36.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-12-19 16:57:33.000000000 +0100
@@ -550,7 +550,6 @@ void		xfs_iunpin(xfs_inode_t *);
 int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
 int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_iflush_all(struct xfs_mount *);
-int		xfs_iaccess(xfs_inode_t *, mode_t, cred_t *);
 void		xfs_ichgtime(xfs_inode_t *, int);
 xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, int, uint);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-12-19 16:55:36.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-12-19 16:57:33.000000000 +0100
@@ -898,27 +898,6 @@ xfs_setattr(
 	return code;
 }
 
-
-/*
- * xfs_access
- * Null conversion from vnode mode bits to inode mode bits, as in efs.
- */
-int
-xfs_access(
-	xfs_inode_t	*ip,
-	int		mode,
-	cred_t		*credp)
-{
-	int		error;
-
-	xfs_itrace_entry(ip);
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_iaccess(ip, mode, credp);
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return error;
-}
-
-
 /*
  * The maximum pathlen is 1024 bytes. Since the minimum file system
  * blocksize is 512 bytes, we can get a max of 2 extents back from
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-19 16:55:36.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-12-19 16:59:11.000000000 +0100
@@ -555,12 +555,31 @@ xfs_vn_put_link(
 
 #ifdef CONFIG_XFS_POSIX_ACL
 STATIC int
+xfs_check_acl(
+	struct inode		*inode,
+	int			mask)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
+
+	xfs_itrace_entry(ip);
+
+	if (XFS_IFORK_Q(ip)) {
+		error = xfs_acl_iaccess(ip, mask, NULL);
+		if (error != -1)
+			return -error;
+	}
+
+	return -EAGAIN;
+}
+
+STATIC int
 xfs_vn_permission(
-	struct inode	*inode,
-	int		mode,
-	struct nameidata *nd)
+	struct inode		*inode,
+	int			mask,
+	struct nameidata	*nd)
 {
-	return -xfs_access(XFS_I(inode), mode << 6, NULL);
+	return generic_permission(inode, mask, xfs_check_acl);
 }
 #else
 #define xfs_vn_permission NULL
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-12-19 16:55:36.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-12-19 16:57:33.000000000 +0100
@@ -225,7 +225,6 @@ EXPORT_SYMBOL(xfs_fs_cmn_err);
 EXPORT_SYMBOL(xfs_highbit32);
 EXPORT_SYMBOL(xfs_highbit64);
 EXPORT_SYMBOL(xfs_idestroy);
-EXPORT_SYMBOL(xfs_iaccess);
 EXPORT_SYMBOL(xfs_iextract);
 EXPORT_SYMBOL(xfs_iext_add);
 EXPORT_SYMBOL(xfs_iext_destroy);
Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2007-12-19 16:55:36.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2007-12-19 16:57:33.000000000 +0100
@@ -392,32 +392,6 @@ xfs_acl_allow_set(
 }
 
 /*
- * The access control process to determine the access permission:
- *	if uid == file owner id, use the file owner bits.
- *	if gid == file owner group id, use the file group bits.
- *	scan ACL for a matching user or group, and use matched entry
- *	permission. Use total permissions of all matching group entries,
- *	until all acl entries are exhausted. The final permission produced
- *	by matching acl entry or entries needs to be & with group permission.
- *	if not owner, owning group, or matching entry in ACL, use file
- *	other bits.  
- */
-STATIC int
-xfs_acl_capability_check(
-	mode_t		mode,
-	cred_t		*cr)
-{
-	if ((mode & ACL_READ) && !capable_cred(cr, CAP_DAC_READ_SEARCH))
-		return EACCES;
-	if ((mode & ACL_WRITE) && !capable_cred(cr, CAP_DAC_OVERRIDE))
-		return EACCES;
-	if ((mode & ACL_EXECUTE) && !capable_cred(cr, CAP_DAC_OVERRIDE))
-		return EACCES;
-
-	return 0;
-}
-
-/*
  * Note: cr is only used here for the capability check if the ACL test fails.
  *       It is not used to find out the credentials uid or groups etc, as was
  *       done in IRIX. It is assumed that the uid and groups for the current
@@ -438,7 +412,6 @@ xfs_acl_access(
 
 	matched.ae_tag = 0;	/* Invalid type */
 	matched.ae_perm = 0;
-	md >>= 6;	/* Normalize the bits for comparison */
 
 	for (i = 0; i < fap->acl_cnt; i++) {
 		/*
@@ -520,7 +493,8 @@ xfs_acl_access(
 		break;
 	}
 
-	return xfs_acl_capability_check(md, cr);
+	/* EACCES tells generic_permission to check for capability overrides */
+	return EACCES;
 }
 EXPORT_SYMBOL(xfs_acl_access);
 
Index: linux-2.6-xfs/fs/xfs/xfs_acl.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.h	2007-12-19 16:55:36.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_acl.h	2007-12-19 16:57:33.000000000 +0100
@@ -75,7 +75,6 @@ extern int xfs_acl_vremove(bhv_vnode_t *
 #define _ACL_GET_DEFAULT(pv,pd)	(xfs_acl_vtoacl(pv,NULL,pd) == 0)
 #define _ACL_ACCESS_EXISTS	xfs_acl_vhasacl_access
 #define _ACL_DEFAULT_EXISTS	xfs_acl_vhasacl_default
-#define _ACL_XFS_IACCESS(i,m,c) (XFS_IFORK_Q(i) ? xfs_acl_iaccess(i,m,c) : -1)
 
 #define _ACL_ALLOC(a)		((a) = kmem_zone_alloc(xfs_acl_zone, KM_SLEEP))
 #define _ACL_FREE(a)		((a)? kmem_zone_free(xfs_acl_zone, (a)):(void)0)
@@ -95,7 +94,6 @@ extern int xfs_acl_vremove(bhv_vnode_t *
 #define _ACL_GET_DEFAULT(pv,pd)	(0)
 #define _ACL_ACCESS_EXISTS	(NULL)
 #define _ACL_DEFAULT_EXISTS	(NULL)
-#define _ACL_XFS_IACCESS(i,m,c) (-1)
 #endif
 
 #endif	/* __XFS_ACL_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2007-12-19 16:55:36.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2007-12-19 16:57:33.000000000 +0100
@@ -18,7 +18,6 @@ int xfs_open(struct xfs_inode *ip);
 int xfs_getattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags);
 int xfs_setattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags,
 		struct cred *credp);
-int xfs_access(struct xfs_inode *ip, int mode, struct cred *credp);
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_fsync(struct xfs_inode *ip, int flag, xfs_off_t start,
 		xfs_off_t stop);
