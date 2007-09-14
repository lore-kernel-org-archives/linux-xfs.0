Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 09:30:46 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EGUf4p030185
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 09:30:42 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8EGUgA5007488
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 18:30:42 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8EGUgpV007486
	for xfs@oss.sgi.com; Fri, 14 Sep 2007 18:30:42 +0200
Date: Fri, 14 Sep 2007 18:30:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/4] simplify xfs_create/mknod/symlink prototype
Message-ID: <20070914163041.GG7110@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

(sorry, go the patch numbering one off)

Simplify the prototype for xfs_create/xfs_mkdir/xfs_symlink by not
passing down a bhv_vattr_t that just hogs stack space.  Instead pass
down the mode in a mode_t and in case of xfs_crate the rdev as a scalar
type aswell.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-09-14 14:34:55.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-09-14 14:40:49.000000000 +0200
@@ -272,7 +272,6 @@ xfs_vn_mknod(
 	dev_t		rdev)
 {
 	struct inode	*ip;
-	bhv_vattr_t	vattr = { 0 };
 	bhv_vnode_t	*vp = NULL, *dvp = vn_from_inode(dir);
 	xfs_acl_t	*default_acl = NULL;
 	attrexists_t	test_default_acl = _ACL_DEFAULT_EXISTS;
@@ -298,19 +297,14 @@ xfs_vn_mknod(
 	if (IS_POSIXACL(dir) && !default_acl && xfs_has_fs_struct(current))
 		mode &= ~current->fs->umask;
 
-	vattr.va_mask = XFS_AT_TYPE|XFS_AT_MODE;
-	vattr.va_mode = mode;
-
 	switch (mode & S_IFMT) {
 	case S_IFCHR: case S_IFBLK: case S_IFIFO: case S_IFSOCK:
-		vattr.va_rdev = sysv_encode_dev(rdev);
-		vattr.va_mask |= XFS_AT_RDEV;
-		/*FALLTHROUGH*/
+		rdev = sysv_encode_dev(rdev);
 	case S_IFREG:
-		error = xfs_create(XFS_I(dir), dentry, &vattr, &vp, NULL);
+		error = xfs_create(XFS_I(dir), dentry, mode, rdev, &vp, NULL);
 		break;
 	case S_IFDIR:
-		error = xfs_mkdir(XFS_I(dir), dentry, &vattr, &vp, NULL);
+		error = xfs_mkdir(XFS_I(dir), dentry, mode, &vp, NULL);
 		break;
 	default:
 		error = EINVAL;
@@ -325,7 +319,7 @@ xfs_vn_mknod(
 
 	if (unlikely(default_acl)) {
 		if (!error) {
-			error = _ACL_INHERIT(vp, &vattr, default_acl);
+			error = _ACL_INHERIT(vp, mode, default_acl);
 			if (!error)
 				xfs_iflags_set(XFS_I(vp), XFS_IMODIFIED);
 			else
@@ -440,18 +434,17 @@ xfs_vn_symlink(
 	const char	*symname)
 {
 	struct inode	*ip;
-	bhv_vattr_t	va = { 0 };
 	bhv_vnode_t	*cvp;	/* used to lookup symlink to put in dentry */
 	int		error;
+	mode_t		mode;
 
 	cvp = NULL;
 
-	va.va_mode = S_IFLNK |
+	mode = S_IFLNK |
 		(irix_symlink_mode ? 0777 & ~current->fs->umask : S_IRWXUGO);
-	va.va_mask = XFS_AT_TYPE|XFS_AT_MODE;
 
-	error = xfs_symlink(XFS_I(dir), dentry, &va,
-			(char *)symname, &cvp, NULL);
+	error = xfs_symlink(XFS_I(dir), dentry, (char *)symname, mode,
+			    &cvp, NULL);
 	if (likely(!error && cvp)) {
 		error = xfs_init_security(cvp, dir);
 		if (likely(!error)) {
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-09-14 14:31:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-09-14 14:38:23.000000000 +0200
@@ -1819,7 +1819,8 @@ int
 xfs_create(
 	xfs_inode_t		*dp,
 	bhv_vname_t		*dentry,
-	bhv_vattr_t		*vap,
+	mode_t			mode,
+	xfs_dev_t		rdev,
 	bhv_vnode_t		**vpp,
 	cred_t			*credp)
 {
@@ -1829,7 +1830,6 @@ xfs_create(
 	xfs_inode_t		*ip;
 	bhv_vnode_t	        *vp = NULL;
 	xfs_trans_t		*tp;
-	xfs_dev_t		rdev;
 	int                     error;
 	xfs_bmap_free_t		free_list;
 	xfs_fsblock_t		first_block;
@@ -1840,20 +1840,18 @@ xfs_create(
 	xfs_prid_t		prid;
 	struct xfs_dquot	*udqp, *gdqp;
 	uint			resblks;
-	int			dm_di_mode;
 	int			namelen;
 
 	ASSERT(!*vpp);
 	xfs_itrace_entry(dp);
 
-	dm_di_mode = vap->va_mode;
 	namelen = VNAMELEN(dentry);
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
 				dir_vp, DM_RIGHT_NULL, NULL,
 				DM_RIGHT_NULL, name, NULL,
-				dm_di_mode, 0, 0);
+				mode, 0, 0);
 
 		if (error)
 			return error;
@@ -1868,8 +1866,6 @@ xfs_create(
 	udqp = gdqp = NULL;
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_d.di_projid;
-	else if (vap->va_mask & XFS_AT_PROJID)
-		prid = (xfs_prid_t)vap->va_projid;
 	else
 		prid = (xfs_prid_t)dfltprid;
 
@@ -1921,8 +1917,7 @@ xfs_create(
 
 	if (resblks == 0 && (error = xfs_dir_canenter(tp, dp, name, namelen)))
 		goto error_return;
-	rdev = (vap->va_mask & XFS_AT_RDEV) ? vap->va_rdev : 0;
-	error = xfs_dir_ialloc(&tp, dp, vap->va_mode, 1,
+	error = xfs_dir_ialloc(&tp, dp, mode, 1,
 			rdev, credp, prid, resblks > 0,
 			&ip, &committed);
 	if (error) {
@@ -2013,7 +2008,7 @@ std_return:
 			dir_vp, DM_RIGHT_NULL,
 			*vpp ? vp:NULL,
 			DM_RIGHT_NULL, name, NULL,
-			dm_di_mode, error, 0);
+			mode, error, 0);
 	}
 	return error;
 
@@ -2702,7 +2697,7 @@ int
 xfs_mkdir(
 	xfs_inode_t             *dp,
 	bhv_vname_t		*dentry,
-	bhv_vattr_t		*vap,
+	mode_t			mode,
 	bhv_vnode_t		**vpp,
 	cred_t			*credp)
 {
@@ -2724,19 +2719,17 @@ xfs_mkdir(
 	xfs_prid_t		prid;
 	struct xfs_dquot	*udqp, *gdqp;
 	uint			resblks;
-	int			dm_di_mode;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
 	tp = NULL;
-	dm_di_mode = vap->va_mode;
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
 					dir_vp, DM_RIGHT_NULL, NULL,
 					DM_RIGHT_NULL, dir_name, NULL,
-					dm_di_mode, 0, 0);
+					mode, 0, 0);
 		if (error)
 			return error;
 		dm_event_sent = 1;
@@ -2750,8 +2743,6 @@ xfs_mkdir(
 	udqp = gdqp = NULL;
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_d.di_projid;
-	else if (vap->va_mask & XFS_AT_PROJID)
-		prid = (xfs_prid_t)vap->va_projid;
 	else
 		prid = (xfs_prid_t)dfltprid;
 
@@ -2804,7 +2795,7 @@ xfs_mkdir(
 	/*
 	 * create the directory inode.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, vap->va_mode, 2,
+	error = xfs_dir_ialloc(&tp, dp, mode, 2,
 			0, credp, prid, resblks > 0,
 		&cdp, NULL);
 	if (error) {
@@ -2898,7 +2889,7 @@ std_return:
 					created ? XFS_ITOV(cdp):NULL,
 					DM_RIGHT_NULL,
 					dir_name, NULL,
-					dm_di_mode, error, 0);
+					mode, error, 0);
 	}
 	return error;
 
@@ -3155,8 +3146,8 @@ int
 xfs_symlink(
 	xfs_inode_t		*dp,
 	bhv_vname_t		*dentry,
-	bhv_vattr_t		*vap,
 	char			*target_path,
+	mode_t			mode,
 	bhv_vnode_t		**vpp,
 	cred_t			*credp)
 {
@@ -3243,8 +3234,6 @@ xfs_symlink(
 	udqp = gdqp = NULL;
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_d.di_projid;
-	else if (vap->va_mask & XFS_AT_PROJID)
-		prid = (xfs_prid_t)vap->va_projid;
 	else
 		prid = (xfs_prid_t)dfltprid;
 
@@ -3313,7 +3302,7 @@ xfs_symlink(
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (vap->va_mode&~S_IFMT),
+	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT),
 			       1, 0, credp, prid, resblks > 0, &ip, NULL);
 	if (error) {
 		if (error == ENOSPC)
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2007-09-14 14:31:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2007-09-14 14:34:49.000000000 +0200
@@ -26,19 +26,19 @@ int xfs_release(struct xfs_inode *ip);
 int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, bhv_vname_t *dentry,
 		bhv_vnode_t **vpp);
-int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry,
-		struct bhv_vattr *vap, bhv_vnode_t **vpp, struct cred *credp);
+int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry, mode_t mode,
+		xfs_dev_t rdev, bhv_vnode_t **vpp, struct cred *credp);
 int xfs_remove(struct xfs_inode *dp, bhv_vname_t	*dentry);
 int xfs_link(struct xfs_inode *tdp, bhv_vnode_t *src_vp,
 		bhv_vname_t *dentry);
 int xfs_mkdir(struct xfs_inode *dp, bhv_vname_t *dentry,
-		struct bhv_vattr *vap, bhv_vnode_t **vpp, struct cred *credp);
+		mode_t mode, bhv_vnode_t **vpp, struct cred *credp);
 int xfs_rmdir(struct xfs_inode *dp, bhv_vname_t *dentry);
 int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
 		       xfs_off_t *offset, filldir_t filldir);
 int xfs_symlink(struct xfs_inode *dp, bhv_vname_t *dentry,
-		struct bhv_vattr *vap, char *target_path,
-		bhv_vnode_t **vpp, struct cred *credp);
+		char *target_path, mode_t mode, bhv_vnode_t **vpp,
+		struct cred *credp);
 int xfs_fid2(struct xfs_inode *ip, struct xfs_fid *xfid);
 int xfs_rwlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
 void xfs_rwunlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2007-09-14 14:39:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2007-09-14 14:40:00.000000000 +0200
@@ -705,7 +705,7 @@ xfs_acl_vtoacl(
 int
 xfs_acl_inherit(
 	bhv_vnode_t	*vp,
-	bhv_vattr_t	*vap,
+	mode_t		mode,
 	xfs_acl_t	*pdaclp)
 {
 	xfs_acl_t	*cacl;
@@ -733,7 +733,7 @@ xfs_acl_inherit(
 		return ENOMEM;
 
 	memcpy(cacl, pdaclp, sizeof(xfs_acl_t));
-	xfs_acl_filter_mode(vap->va_mode, cacl);
+	xfs_acl_filter_mode(mode, cacl);
 	xfs_acl_setmode(vp, cacl, &basicperms);
 
 	/*
Index: linux-2.6-xfs/fs/xfs/xfs_acl.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.h	2007-09-14 14:40:09.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.h	2007-09-14 14:40:31.000000000 +0200
@@ -57,7 +57,7 @@ extern struct kmem_zone *xfs_acl_zone;
 		(zone) = kmem_zone_init(sizeof(xfs_acl_t), (name))
 #define xfs_acl_zone_destroy(zone)	kmem_zone_destroy(zone)
 
-extern int xfs_acl_inherit(bhv_vnode_t *, struct bhv_vattr *, xfs_acl_t *);
+extern int xfs_acl_inherit(bhv_vnode_t *, mode_t mode, xfs_acl_t *);
 extern int xfs_acl_iaccess(struct xfs_inode *, mode_t, cred_t *);
 extern int xfs_acl_vtoacl(bhv_vnode_t *, xfs_acl_t *, xfs_acl_t *);
 extern int xfs_acl_vhasacl_access(bhv_vnode_t *);
@@ -70,7 +70,7 @@ extern int xfs_acl_vremove(bhv_vnode_t *
 #define _ACL_TYPE_DEFAULT	2
 #define _ACL_PERM_INVALID(perm)	((perm) & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
 
-#define _ACL_INHERIT(c,v,d)	(xfs_acl_inherit(c,v,d))
+#define _ACL_INHERIT(c,m,d)	(xfs_acl_inherit(c,m,d))
 #define _ACL_GET_ACCESS(pv,pa)	(xfs_acl_vtoacl(pv,pa,NULL) == 0)
 #define _ACL_GET_DEFAULT(pv,pd)	(xfs_acl_vtoacl(pv,NULL,pd) == 0)
 #define _ACL_ACCESS_EXISTS	xfs_acl_vhasacl_access
@@ -90,7 +90,7 @@ extern int xfs_acl_vremove(bhv_vnode_t *
 #define xfs_acl_vhasacl_default(v)	(0)
 #define _ACL_ALLOC(a)		(1)	/* successfully allocate nothing */
 #define _ACL_FREE(a)		((void)0)
-#define _ACL_INHERIT(c,v,d)	(0)
+#define _ACL_INHERIT(c,m,d)	(0)
 #define _ACL_GET_ACCESS(pv,pa)	(0)
 #define _ACL_GET_DEFAULT(pv,pd)	(0)
 #define _ACL_ACCESS_EXISTS	(NULL)
