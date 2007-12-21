Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Dec 2007 22:22:12 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBL6M50a010742
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:07 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0681FB9147A
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:18 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 6WoJoNioQiGwF7ZM for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:18 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lBL6MDF3023402
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Dec 2007 07:22:13 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lBL6MD63023400
	for xfs@oss.sgi.com; Fri, 21 Dec 2007 07:22:13 +0100
Date: Fri, 21 Dec 2007 07:22:13 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] clean up xfs_swapext
Message-ID: <20071221062213.GB23180@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 - stop using vnodes
 - use proper multiple label goto unwinding
 - give the struct file * variables saner names


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2007-12-19 16:14:39.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2007-12-19 16:29:58.000000000 +0100
@@ -52,76 +52,61 @@ xfs_swapext(
 	xfs_swapext_t	__user *sxu)
 {
 	xfs_swapext_t	*sxp;
-	xfs_inode_t     *ip=NULL, *tip=NULL;
-	xfs_mount_t     *mp;
-	struct file	*fp = NULL, *tfp = NULL;
-	bhv_vnode_t	*vp, *tvp;
+	xfs_inode_t     *ip, *tip;
+	struct file	*file, *target_file;
 	int		error = 0;
 
 	sxp = kmem_alloc(sizeof(xfs_swapext_t), KM_MAYFAIL);
 	if (!sxp) {
 		error = XFS_ERROR(ENOMEM);
-		goto error0;
+		goto out;
 	}
 
 	if (copy_from_user(sxp, sxu, sizeof(xfs_swapext_t))) {
 		error = XFS_ERROR(EFAULT);
-		goto error0;
+		goto out_free_sxp;
 	}
 
 	/* Pull information for the target fd */
-	if (((fp = fget((int)sxp->sx_fdtarget)) == NULL) ||
-	    ((vp = vn_from_inode(fp->f_path.dentry->d_inode)) == NULL))  {
+	file = fget((int)sxp->sx_fdtarget);
+	if (!file) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
-	}
-
-	ip = xfs_vtoi(vp);
-	if (ip == NULL) {
-		error = XFS_ERROR(EBADF);
-		goto error0;
+		goto out_free_sxp;
 	}
 
-	if (((tfp = fget((int)sxp->sx_fdtmp)) == NULL) ||
-	    ((tvp = vn_from_inode(tfp->f_path.dentry->d_inode)) == NULL)) {
+	target_file = fget((int)sxp->sx_fdtmp);
+	if (!target_file) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_put_file;
 	}
 
-	tip = xfs_vtoi(tvp);
-	if (tip == NULL) {
-		error = XFS_ERROR(EBADF);
-		goto error0;
-	}
+	ip = XFS_I(file->f_path.dentry->d_inode);
+	tip = XFS_I(target_file->f_path.dentry->d_inode);
 
 	if (ip->i_mount != tip->i_mount) {
-		error =  XFS_ERROR(EINVAL);
-		goto error0;
+		error = XFS_ERROR(EINVAL);
+		goto out_put_target_file;
 	}
 
 	if (ip->i_ino == tip->i_ino) {
-		error =  XFS_ERROR(EINVAL);
-		goto error0;
+		error = XFS_ERROR(EINVAL);
+		goto out_put_target_file;
 	}
 
-	mp = ip->i_mount;
-
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		error =  XFS_ERROR(EIO);
-		goto error0;
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		error = XFS_ERROR(EIO);
+		goto out_put_target_file;
 	}
 
 	error = xfs_swap_extents(ip, tip, sxp);
 
- error0:
-	if (fp != NULL)
-		fput(fp);
-	if (tfp != NULL)
-		fput(tfp);
-
-	if (sxp != NULL)
-		kmem_free(sxp, sizeof(xfs_swapext_t));
-
+ out_put_target_file:
+	fput(target_file);
+ out_put_file:
+	fput(file);
+ out_free_sxp:
+	kmem_free(sxp, sizeof(xfs_swapext_t));
+ out:
 	return error;
 }
 
