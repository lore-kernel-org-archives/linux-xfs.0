Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3PSoE001964 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:25:29 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5793A7864E
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:25:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id Dv1HqsGrJTPXPcDw for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:25:27 -0800 (PST)
Message-Id: <20081126032026.775790208@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:06 -0600
From: sandeen@sandeen.net
Subject: [patch 01/12] Move copy_from_user calls out of ioctl helpers into
	ioctl switch.
Content-Disposition: inline; filename=ioctls-move-usercopy-from-helpers
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Moving the copy_from_user out of some of the ioctl helpers will
make it easier for the compat ioctl switch to copy in the right
struct, then just pass to the underlying helper.

Also, move common access checks into the helpers themselves,
and out of the native ioctl switch code, to reduce code
duplication between native & compat ioctl callers.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-11-24 16:32:40.011002274 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-11-24 17:09:29.867064329 -0600
@@ -71,23 +71,19 @@
 STATIC int
 xfs_find_handle(
 	unsigned int		cmd,
-	void			__user *arg)
+	xfs_fsop_handlereq_t	*hreq)
 {
 	int			hsize;
 	xfs_handle_t		handle;
-	xfs_fsop_handlereq_t	hreq;
 	struct inode		*inode;
 
-	if (copy_from_user(&hreq, arg, sizeof(hreq)))
-		return -XFS_ERROR(EFAULT);
-
 	memset((char *)&handle, 0, sizeof(handle));
 
 	switch (cmd) {
 	case XFS_IOC_PATH_TO_FSHANDLE:
 	case XFS_IOC_PATH_TO_HANDLE: {
 		struct path path;
-		int error = user_lpath((const char __user *)hreq.path, &path);
+		int error = user_lpath((const char __user *)hreq->path, &path);
 		if (error)
 			return error;
 
@@ -101,7 +97,7 @@ xfs_find_handle(
 	case XFS_IOC_FD_TO_HANDLE: {
 		struct file	*file;
 
-		file = fget(hreq.fd);
+		file = fget(hreq->fd);
 		if (!file)
 		    return -EBADF;
 
@@ -158,8 +154,8 @@ xfs_find_handle(
 	}
 
 	/* now copy our handle into the user buffer & write out the size */
-	if (copy_to_user(hreq.ohandle, &handle, hsize) ||
-	    copy_to_user(hreq.ohandlen, &hsize, sizeof(__s32))) {
+	if (copy_to_user(hreq->ohandle, &handle, hsize) ||
+	    copy_to_user(hreq->ohandlen, &hsize, sizeof(__s32))) {
 		iput(inode);
 		return -XFS_ERROR(EFAULT);
 	}
@@ -252,7 +248,7 @@ xfs_vget_fsop_handlereq(
 STATIC int
 xfs_open_by_handle(
 	xfs_mount_t		*mp,
-	void			__user *arg,
+	xfs_fsop_handlereq_t	*hreq,
 	struct file		*parfilp,
 	struct inode		*parinode)
 {
@@ -262,14 +258,11 @@ xfs_open_by_handle(
 	struct file		*filp;
 	struct inode		*inode;
 	struct dentry		*dentry;
-	xfs_fsop_handlereq_t	hreq;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -XFS_ERROR(EPERM);
-	if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &hreq, &inode);
+	error = xfs_vget_fsop_handlereq(mp, parinode, hreq, &inode);
 	if (error)
 		return -error;
 
@@ -280,10 +273,10 @@ xfs_open_by_handle(
 	}
 
 #if BITS_PER_LONG != 32
-	hreq.oflags |= O_LARGEFILE;
+	hreq->oflags |= O_LARGEFILE;
 #endif
 	/* Put open permission in namei format. */
-	permflag = hreq.oflags;
+	permflag = hreq->oflags;
 	if ((permflag+1) & O_ACCMODE)
 		permflag++;
 	if (permflag & O_TRUNC)
@@ -322,7 +315,7 @@ xfs_open_by_handle(
 	mntget(parfilp->f_path.mnt);
 
 	/* Create file pointer. */
-	filp = dentry_open(dentry, parfilp->f_path.mnt, hreq.oflags);
+	filp = dentry_open(dentry, parfilp->f_path.mnt, hreq->oflags);
 	if (IS_ERR(filp)) {
 		put_unused_fd(new_fd);
 		return -XFS_ERROR(-PTR_ERR(filp));
@@ -366,21 +359,18 @@ do_readlink(
 STATIC int
 xfs_readlink_by_handle(
 	xfs_mount_t		*mp,
-	void			__user *arg,
+	xfs_fsop_handlereq_t	*hreq,
 	struct inode		*parinode)
 {
 	struct inode		*inode;
-	xfs_fsop_handlereq_t	hreq;
 	__u32			olen;
 	void			*link;
 	int			error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -XFS_ERROR(EPERM);
-	if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &hreq, &inode);
+	error = xfs_vget_fsop_handlereq(mp, parinode, hreq, &inode);
 	if (error)
 		return -error;
 
@@ -390,7 +380,7 @@ xfs_readlink_by_handle(
 		goto out_iput;
 	}
 
-	if (copy_from_user(&olen, hreq.ohandlen, sizeof(__u32))) {
+	if (copy_from_user(&olen, hreq->ohandlen, sizeof(__u32))) {
 		error = -XFS_ERROR(EFAULT);
 		goto out_iput;
 	}
@@ -402,7 +392,7 @@ xfs_readlink_by_handle(
 	error = -xfs_readlink(XFS_I(inode), link);
 	if (error)
 		goto out_kfree;
-	error = do_readlink(hreq.ohandle, olen, link);
+	error = do_readlink(hreq->ohandle, olen, link);
 	if (error)
 		goto out_kfree;
 
@@ -669,12 +659,19 @@ xfs_ioc_space(
 	struct file		*filp,
 	int			ioflags,
 	unsigned int		cmd,
-	void			__user *arg)
+	xfs_flock64_t		*bf)
 {
-	xfs_flock64_t		bf;
 	int			attr_flags = 0;
 	int			error;
 
+	/*
+	 * Only allow the sys admin to reserve space unless
+	 * unwritten extents are enabled.
+	 */
+	if (!xfs_sb_version_hasextflgbit(&ip->i_mount->m_sb) &&
+	    !capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+
 	if (inode->i_flags & (S_IMMUTABLE|S_APPEND))
 		return -XFS_ERROR(EPERM);
 
@@ -684,15 +681,12 @@ xfs_ioc_space(
 	if (!S_ISREG(inode->i_mode))
 		return -XFS_ERROR(EINVAL);
 
-	if (copy_from_user(&bf, arg, sizeof(bf)))
-		return -XFS_ERROR(EFAULT);
-
 	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
 		attr_flags |= XFS_ATTR_NONBLOCK;
 	if (ioflags & IO_INVIS)
 		attr_flags |= XFS_ATTR_DMI;
 
-	error = xfs_change_file_space(ip, cmd, &bf, filp->f_pos, attr_flags);
+	error = xfs_change_file_space(ip, cmd, bf, filp->f_pos, attr_flags);
 	return -error;
 }
 
@@ -1343,17 +1337,13 @@ xfs_ioctl(
 	case XFS_IOC_ALLOCSP64:
 	case XFS_IOC_FREESP64:
 	case XFS_IOC_RESVSP64:
-	case XFS_IOC_UNRESVSP64:
-		/*
-		 * Only allow the sys admin to reserve space unless
-		 * unwritten extents are enabled.
-		 */
-		if (!xfs_sb_version_hasextflgbit(&mp->m_sb) &&
-		    !capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, arg);
+	case XFS_IOC_UNRESVSP64: {
+		xfs_flock64_t		bf;
 
+		if (copy_from_user(&bf, arg, sizeof(bf)))
+			return -XFS_ERROR(EFAULT);
+		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
+	}
 	case XFS_IOC_DIOINFO: {
 		struct dioattr	da;
 		xfs_buftarg_t	*target =
@@ -1413,18 +1403,30 @@ xfs_ioctl(
 
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
-	case XFS_IOC_PATH_TO_FSHANDLE:
-		return xfs_find_handle(cmd, arg);
+	case XFS_IOC_PATH_TO_FSHANDLE: {
+		xfs_fsop_handlereq_t	hreq;
 
-	case XFS_IOC_OPEN_BY_HANDLE:
-		return xfs_open_by_handle(mp, arg, filp, inode);
+		if (copy_from_user(&hreq, arg, sizeof(hreq)))
+			return -XFS_ERROR(EFAULT);
+		return xfs_find_handle(cmd, &hreq);
+	}
+	case XFS_IOC_OPEN_BY_HANDLE: {
+		xfs_fsop_handlereq_t	hreq;
 
+		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
+			return -XFS_ERROR(EFAULT);
+		return xfs_open_by_handle(mp, &hreq, filp, inode);
+	}
 	case XFS_IOC_FSSETDM_BY_HANDLE:
 		return xfs_fssetdm_by_handle(mp, arg, inode);
 
-	case XFS_IOC_READLINK_BY_HANDLE:
-		return xfs_readlink_by_handle(mp, arg, inode);
+	case XFS_IOC_READLINK_BY_HANDLE: {
+		xfs_fsop_handlereq_t	hreq;
 
+		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
+			return -XFS_ERROR(EFAULT);
+		return xfs_readlink_by_handle(mp, &hreq, inode);
+	}
 	case XFS_IOC_ATTRLIST_BY_HANDLE:
 		return xfs_attrlist_by_handle(mp, arg, inode);
 
@@ -1432,7 +1434,11 @@ xfs_ioctl(
 		return xfs_attrmulti_by_handle(mp, arg, filp, inode);
 
 	case XFS_IOC_SWAPEXT: {
-		error = xfs_swapext((struct xfs_swapext __user *)arg);
+		struct xfs_swapext	sxp;
+
+		if (copy_from_user(&sxp, arg, sizeof(xfs_swapext_t)))
+			return -XFS_ERROR(EFAULT);
+		error = xfs_swapext(&sxp);
 		return -error;
 	}
 
@@ -1488,9 +1494,6 @@ xfs_ioctl(
 	case XFS_IOC_FSGROWFSDATA: {
 		xfs_growfs_data_t in;
 
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
 		if (copy_from_user(&in, arg, sizeof(in)))
 			return -XFS_ERROR(EFAULT);
 
@@ -1501,9 +1504,6 @@ xfs_ioctl(
 	case XFS_IOC_FSGROWFSLOG: {
 		xfs_growfs_log_t in;
 
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
 		if (copy_from_user(&in, arg, sizeof(in)))
 			return -XFS_ERROR(EFAULT);
 
@@ -1514,9 +1514,6 @@ xfs_ioctl(
 	case XFS_IOC_FSGROWFSRT: {
 		xfs_growfs_rt_t in;
 
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
 		if (copy_from_user(&in, arg, sizeof(in)))
 			return -XFS_ERROR(EFAULT);
 
Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2008-11-24 16:32:40.011002274 -0600
+++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2008-11-24 16:32:43.037001385 -0600
@@ -49,9 +49,8 @@
  */
 int
 xfs_swapext(
-	xfs_swapext_t	__user *sxu)
+	xfs_swapext_t	*sxp)
 {
-	xfs_swapext_t	*sxp;
 	xfs_inode_t     *ip, *tip;
 	struct file	*file, *target_file;
 	int		error = 0;
@@ -62,11 +61,6 @@ xfs_swapext(
 		goto out;
 	}
 
-	if (copy_from_user(sxp, sxu, sizeof(xfs_swapext_t))) {
-		error = XFS_ERROR(EFAULT);
-		goto out_free_sxp;
-	}
-
 	/* Pull information for the target fd */
 	file = fget((int)sxp->sx_fdtarget);
 	if (!file) {
Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.h	2008-11-24 16:32:40.012001185 -0600
+++ linux-2.6-xfs/fs/xfs/xfs_dfrag.h	2008-11-24 16:32:43.053255069 -0600
@@ -46,7 +46,7 @@ typedef struct xfs_swapext
 /*
  * Syscall interface for xfs_swapext
  */
-int	xfs_swapext(struct xfs_swapext __user *sx);
+int	xfs_swapext(struct xfs_swapext *sx);
 
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 		struct xfs_swapext *sxp);
Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2008-11-24 16:32:40.012001185 -0600
+++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2008-11-24 16:32:43.070002196 -0600
@@ -435,6 +435,9 @@ xfs_growfs_data(
 	xfs_growfs_data_t	*in)
 {
 	int error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return XFS_ERROR(EPERM);
 	if (!mutex_trylock(&mp->m_growlock))
 		return XFS_ERROR(EWOULDBLOCK);
 	error = xfs_growfs_data_private(mp, in);
@@ -448,6 +451,9 @@ xfs_growfs_log(
 	xfs_growfs_log_t	*in)
 {
 	int error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return XFS_ERROR(EPERM);
 	if (!mutex_trylock(&mp->m_growlock))
 		return XFS_ERROR(EWOULDBLOCK);
 	error = xfs_growfs_log_private(mp, in);
Index: linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rtalloc.c	2008-11-24 16:32:40.012001185 -0600
+++ linux-2.6-xfs/fs/xfs/xfs_rtalloc.c	2008-11-24 16:32:43.096001372 -0600
@@ -1879,6 +1879,8 @@ xfs_growfs_rt(
 	/*
 	 * Initial error checking.
 	 */
+	if (!capable(CAP_SYS_ADMIN))
+		return XFS_ERROR(EPERM);
 	if (mp->m_rtdev_targp == NULL || mp->m_rbmip == NULL ||
 	    (nrblocks = in->newblocks) <= sbp->sb_rblocks ||
 	    (sbp->sb_rblocks && (in->extsize != sbp->sb_rextsize)))

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
