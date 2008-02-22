Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:01:50 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M41fQV031597
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:01:45 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D167D60502F
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:06 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2DKBkWcbulSDYfks for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:06 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M421F3006136
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:02:01 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M421KY006134
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 05:02:01 +0100
Date: Fri, 22 Feb 2008 05:02:01 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] cleanup vnode use in xfs_symlink and xfs_rename
Message-ID: <20080222040201.GD5964@lst.de>
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-01-03 14:41:33.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-01-03 14:47:32.000000000 +0100
@@ -437,29 +437,33 @@ xfs_vn_symlink(
 	struct dentry	*dentry,
 	const char	*symname)
 {
-	struct inode	*ip;
-	bhv_vnode_t	*cvp;	/* used to lookup symlink to put in dentry */
+	struct inode	*inode;
+	struct xfs_inode *cip = NULL;
 	int		error;
 	mode_t		mode;
 
-	cvp = NULL;
-
 	mode = S_IFLNK |
 		(irix_symlink_mode ? 0777 & ~current->fs->umask : S_IRWXUGO);
 
 	error = xfs_symlink(XFS_I(dir), dentry, (char *)symname, mode,
-			    &cvp, NULL);
-	if (likely(!error && cvp)) {
-		error = xfs_init_security(cvp, dir);
-		if (likely(!error)) {
-			ip = vn_to_inode(cvp);
-			d_instantiate(dentry, ip);
-			xfs_validate_fields(dir);
-			xfs_validate_fields(ip);
-		} else {
-			xfs_cleanup_inode(dir, cvp, dentry, 0);
-		}
-	}
+			    &cip, NULL);
+	if (unlikely(error))
+		goto out;
+
+	inode = cip->i_vnode;
+
+	error = xfs_init_security(inode, dir);
+	if (unlikely(error))
+		goto out_cleanup_inode;
+
+	d_instantiate(dentry, inode);
+	xfs_validate_fields(dir);
+	xfs_validate_fields(inode);
+	return 0;
+
+ out_cleanup_inode:
+	xfs_cleanup_inode(dir, inode, dentry, 0);
+ out:
 	return -error;
 }
 
@@ -487,12 +491,9 @@ xfs_vn_rename(
 	struct dentry	*ndentry)
 {
 	struct inode	*new_inode = ndentry->d_inode;
-	bhv_vnode_t	*tvp;	/* target directory */
 	int		error;
 
-	tvp = vn_from_inode(ndir);
-
-	error = xfs_rename(XFS_I(odir), odentry, tvp, ndentry);
+	error = xfs_rename(XFS_I(odir), odentry, XFS_I(ndir), ndentry);
 	if (likely(!error)) {
 		if (new_inode)
 			xfs_validate_fields(new_inode);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-01-03 14:40:07.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-01-03 14:41:14.000000000 +0100
@@ -3077,10 +3077,9 @@ xfs_symlink(
 	bhv_vname_t		*dentry,
 	char			*target_path,
 	mode_t			mode,
-	bhv_vnode_t		**vpp,
+	xfs_inode_t		**ipp,
 	cred_t			*credp)
 {
-	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t		*tp;
 	xfs_inode_t		*ip;
@@ -3106,7 +3105,7 @@ xfs_symlink(
 	char			*link_name = VNAME(dentry);
 	int			link_namelen;
 
-	*vpp = NULL;
+	*ipp = NULL;
 	error = 0;
 	ip = NULL;
 	tp = NULL;
@@ -3245,7 +3244,7 @@ xfs_symlink(
 	 * transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	VN_HOLD(dir_vp);
+	IHOLD(dp);
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = B_FALSE;
 
@@ -3361,13 +3360,8 @@ std_return:
 					0, error, 0);
 	}
 
-	if (!error) {
-		bhv_vnode_t *vp;
-
-		ASSERT(ip);
-		vp = XFS_ITOV(ip);
-		*vpp = vp;
-	}
+	if (!error)
+		*ipp = ip;
 	return error;
 
  error2:
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-01-03 14:41:16.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-01-03 14:46:56.000000000 +0100
@@ -36,7 +36,7 @@ int xfs_rmdir(struct xfs_inode *dp, bhv_
 int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
 		       xfs_off_t *offset, filldir_t filldir);
 int xfs_symlink(struct xfs_inode *dp, bhv_vname_t *dentry,
-		char *target_path, mode_t mode, bhv_vnode_t **vpp,
+		char *target_path, mode_t mode, struct xfs_inode **ipp,
 		struct cred *credp);
 int xfs_inode_flush(struct xfs_inode *ip, int flags);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
@@ -45,7 +45,7 @@ int xfs_change_file_space(struct xfs_ino
 		xfs_flock64_t *bf, xfs_off_t offset,
 		struct cred *credp, int	attr_flags);
 int xfs_rename(struct xfs_inode *src_dp, bhv_vname_t *src_vname,
-		bhv_vnode_t *target_dir_vp, bhv_vname_t *target_vname);
+		struct xfs_inode *target_dp, bhv_vname_t *target_vname);
 int xfs_attr_get(struct xfs_inode *ip, const char *name, char *value,
 		int *valuelenp, int flags, cred_t *cred);
 int xfs_attr_set(struct xfs_inode *dp, const char *name, char *value,
Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2008-01-03 14:45:04.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2008-01-03 14:46:35.000000000 +0100
@@ -220,12 +220,11 @@ int
 xfs_rename(
 	xfs_inode_t	*src_dp,
 	bhv_vname_t	*src_vname,
-	bhv_vnode_t	*target_dir_vp,
+	xfs_inode_t	*target_dp,
 	bhv_vname_t	*target_vname)
 {
-	bhv_vnode_t	*src_dir_vp = XFS_ITOV(src_dp);
 	xfs_trans_t	*tp;
-	xfs_inode_t	*target_dp, *src_ip, *target_ip;
+	xfs_inode_t	*src_ip, *target_ip;
 	xfs_mount_t	*mp = src_dp->i_mount;
 	int		new_parent;		/* moving to a new dir */
 	int		src_is_directory;	/* src_name is a directory */
@@ -245,16 +244,7 @@ xfs_rename(
 	int		target_namelen = VNAMELEN(target_vname);
 
 	xfs_itrace_entry(src_dp);
-	xfs_itrace_entry(xfs_vtoi(target_dir_vp));
-
-	/*
-	 * Find the XFS behavior descriptor for the target directory
-	 * vnode since it was not handed to us.
-	 */
-	target_dp = xfs_vtoi(target_dir_vp);
-	if (target_dp == NULL) {
-		return XFS_ERROR(EXDEV);
-	}
+	xfs_itrace_entry(target_dp);
 
 	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_RENAME) ||
 	    DM_EVENT_ENABLED(target_dp, DM_EVENT_RENAME)) {
@@ -361,10 +351,10 @@ xfs_rename(
 	 * them when they unlock the inodes.  Also, we need to be careful
 	 * not to add an inode to the transaction more than once.
 	 */
-	VN_HOLD(src_dir_vp);
+	IHOLD(src_dp);
 	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
 	if (new_parent) {
-		VN_HOLD(target_dir_vp);
+		IHOLD(target_dp);
 		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
 	}
 	if ((src_ip != src_dp) && (src_ip != target_dp)) {
