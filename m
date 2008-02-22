Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:01:39 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M41V34031542
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:01:33 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7ABCB60502B
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:01:56 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id yVaowHqSBPFgoDH0 for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:01:56 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M41oF3006104
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:01:50 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M41oBP006102
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 05:01:50 +0100
Date: Fri, 22 Feb 2008 05:01:50 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] cleanup vnode use in xfs_create/mknod/mkdir
Message-ID: <20080222040150.GB5964@lst.de>
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-02-16 14:46:57.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-02-16 14:47:04.000000000 +0100
@@ -273,7 +273,7 @@ xfs_vn_mknod(
 	dev_t		rdev)
 {
 	struct inode	*inode;
-	bhv_vnode_t	*vp = NULL, *dvp = vn_from_inode(dir);
+	struct xfs_inode *ip = NULL;
 	xfs_acl_t	*default_acl = NULL;
 	attrexists_t	test_default_acl = _ACL_DEFAULT_EXISTS;
 	int		error;
@@ -285,11 +285,11 @@ xfs_vn_mknod(
 	if (unlikely(!sysv_valid_dev(rdev) || MAJOR(rdev) & ~0x1ff))
 		return -EINVAL;
 
-	if (test_default_acl && test_default_acl(dvp)) {
+	if (test_default_acl && test_default_acl(dir)) {
 		if (!_ACL_ALLOC(default_acl)) {
 			return -ENOMEM;
 		}
-		if (!_ACL_GET_DEFAULT(dvp, default_acl)) {
+		if (!_ACL_GET_DEFAULT(dir, default_acl)) {
 			_ACL_FREE(default_acl);
 			default_acl = NULL;
 		}
@@ -305,10 +305,10 @@ xfs_vn_mknod(
 	case S_IFSOCK:
 		rdev = sysv_encode_dev(rdev);
 	case S_IFREG:
-		error = xfs_create(XFS_I(dir), dentry, mode, rdev, &vp, NULL);
+		error = xfs_create(XFS_I(dir), dentry, mode, rdev, &ip, NULL);
 		break;
 	case S_IFDIR:
-		error = xfs_mkdir(XFS_I(dir), dentry, mode, &vp, NULL);
+		error = xfs_mkdir(XFS_I(dir), dentry, mode, &ip, NULL);
 		break;
 	default:
 		error = EINVAL;
@@ -318,19 +318,20 @@ xfs_vn_mknod(
 	if (unlikely(error))
 		goto out_free_acl;
 
-	error = xfs_init_security(vp, dir);
+	inode = ip->i_vnode;
+
+	error = xfs_init_security(inode, dir);
 	if (unlikely(error))
 		goto out_cleanup_inode;
 
 	if (default_acl) {
-		error = _ACL_INHERIT(vp, mode, default_acl);
+		error = _ACL_INHERIT(inode, mode, default_acl);
 		if (unlikely(error))
 			goto out_cleanup_inode;
-		xfs_iflags_set(XFS_I(vp), XFS_IMODIFIED);
+		xfs_iflags_set(ip, XFS_IMODIFIED);
 		_ACL_FREE(default_acl);
 	}
 
-	inode = vn_to_inode(vp);
 
 	if (S_ISDIR(mode))
 		xfs_validate_fields(inode);
@@ -339,7 +340,7 @@ xfs_vn_mknod(
 	return -error;
 
  out_cleanup_inode:
-	xfs_cleanup_inode(dir, vp, dentry, mode);
+	xfs_cleanup_inode(dir, inode, dentry, mode);
  out_free_acl:
 	if (default_acl)
 		_ACL_FREE(default_acl);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-02-16 14:47:01.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-02-16 14:47:04.000000000 +0100
@@ -1786,14 +1786,12 @@ xfs_create(
 	bhv_vname_t		*dentry,
 	mode_t			mode,
 	xfs_dev_t		rdev,
-	bhv_vnode_t		**vpp,
+	xfs_inode_t		**ipp,
 	cred_t			*credp)
 {
 	char			*name = VNAME(dentry);
 	xfs_mount_t	        *mp = dp->i_mount;
-	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
 	xfs_inode_t		*ip;
-	bhv_vnode_t	        *vp = NULL;
 	xfs_trans_t		*tp;
 	int                     error;
 	xfs_bmap_free_t		free_list;
@@ -1807,7 +1805,7 @@ xfs_create(
 	uint			resblks;
 	int			namelen;
 
-	ASSERT(!*vpp);
+	ASSERT(!*ipp);
 	xfs_itrace_entry(dp);
 
 	namelen = VNAMELEN(dentry);
@@ -1906,7 +1904,7 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	VN_HOLD(dir_vp);
+	IHOLD(dp);
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = B_FALSE;
 
@@ -1944,7 +1942,6 @@ xfs_create(
 	 * vnode to the caller, we bump the vnode ref count now.
 	 */
 	IHOLD(ip);
-	vp = XFS_ITOV(ip);
 
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
@@ -1962,16 +1959,16 @@ xfs_create(
 	XFS_QM_DQRELE(mp, udqp);
 	XFS_QM_DQRELE(mp, gdqp);
 
-	*vpp = vp;
+	*ipp = ip;
 
 	/* Fallthrough to std_return with error = 0  */
 
 std_return:
-	if ((*vpp || (error != 0 && dm_event_sent != 0)) &&
+	if ((*ipp || (error != 0 && dm_event_sent != 0)) &&
 	    DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
 			dp, DM_RIGHT_NULL,
-			*vpp ? ip : NULL,
+			*ipp ? ip : NULL,
 			DM_RIGHT_NULL, name, NULL,
 			mode, error, 0);
 	}
@@ -2646,15 +2643,13 @@ xfs_mkdir(
 	xfs_inode_t             *dp,
 	bhv_vname_t		*dentry,
 	mode_t			mode,
-	bhv_vnode_t		**vpp,
+	xfs_inode_t		**ipp,
 	cred_t			*credp)
 {
-	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
 	char			*dir_name = VNAME(dentry);
 	int			dir_namelen = VNAMELEN(dentry);
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_inode_t		*cdp;	/* inode of created dir */
-	bhv_vnode_t		*cvp;	/* vnode of created dir */
 	xfs_trans_t		*tp;
 	int			cancel_flags;
 	int			error;
@@ -2761,7 +2756,7 @@ xfs_mkdir(
 	 * from here on will result in the transaction cancel
 	 * unlocking dp so don't do it explicitly in the error path.
 	 */
-	VN_HOLD(dir_vp);
+	IHOLD(dp);
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = B_FALSE;
 
@@ -2792,11 +2787,9 @@ xfs_mkdir(
 	if (error)
 		goto error2;
 
-	cvp = XFS_ITOV(cdp);
-
 	created = B_TRUE;
 
-	*vpp = cvp;
+	*ipp = cdp;
 	IHOLD(cdp);
 
 	/*
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-02-16 14:46:57.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-02-16 14:47:04.000000000 +0100
@@ -26,12 +26,12 @@ int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, bhv_vname_t *dentry,
 		bhv_vnode_t **vpp);
 int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry, mode_t mode,
-		xfs_dev_t rdev, bhv_vnode_t **vpp, struct cred *credp);
+		xfs_dev_t rdev, struct xfs_inode **ipp, struct cred *credp);
 int xfs_remove(struct xfs_inode *dp, bhv_vname_t	*dentry);
 int xfs_link(struct xfs_inode *tdp, bhv_vnode_t *src_vp,
 		bhv_vname_t *dentry);
 int xfs_mkdir(struct xfs_inode *dp, bhv_vname_t *dentry,
-		mode_t mode, bhv_vnode_t **vpp, struct cred *credp);
+		mode_t mode, struct xfs_inode **ipp, struct cred *credp);
 int xfs_rmdir(struct xfs_inode *dp, bhv_vname_t *dentry);
 int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
 		       xfs_off_t *offset, filldir_t filldir);
