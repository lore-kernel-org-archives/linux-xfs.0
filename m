Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 09 Feb 2008 11:42:30 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m19JgNne003960
	for <xfs@oss.sgi.com>; Sat, 9 Feb 2008 11:42:25 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC0C55BBAEC
	for <xfs@oss.sgi.com>; Sat,  9 Feb 2008 11:42:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id DAd4bEdNc6zvEk1f for <xfs@oss.sgi.com>; Sat, 09 Feb 2008 11:42:45 -0800 (PST)
Received: from Liberator.local (sandeen.net [209.173.210.139])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 80D6E18004487
	for <xfs@oss.sgi.com>; Sat,  9 Feb 2008 13:42:43 -0600 (CST)
Message-ID: <47AE0232.9000002@sandeen.net>
Date: Sat, 09 Feb 2008 13:42:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove forward declarations for ioctl helpers; let "noinline"
 do the work
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

(if this one is too purely cosmetic I won't be offended)

The forward declarations for the xfs_ioctl() helpers and
the associated comment about gcc behavior really aren't
needed; all of these functions are marked STATIC which
includes noinline, and the stack usage won't be a problem.

This effectively just removes the forward declarations and
moves xfs_ioctl() back to the end of the file.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

---

 xfs_ioctl.c |  563 ++++++++++++++++----------------------
 1 files changed, 255 insertions(+), 308 deletions(-)

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -651,314 +651,6 @@ xfs_attrmulti_by_handle(
 	return -error;
 }
 
-/* prototypes for a few of the stack-hungry cases that have
- * their own functions.  Functions are defined after their use
- * so gcc doesn't get fancy and inline them with -03 */
-
-STATIC int
-xfs_ioc_space(
-	struct xfs_inode	*ip,
-	struct inode		*inode,
-	struct file		*filp,
-	int			flags,
-	unsigned int		cmd,
-	void			__user *arg);
-
-STATIC int
-xfs_ioc_bulkstat(
-	xfs_mount_t		*mp,
-	unsigned int		cmd,
-	void			__user *arg);
-
-STATIC int
-xfs_ioc_fsgeometry_v1(
-	xfs_mount_t		*mp,
-	void			__user *arg);
-
-STATIC int
-xfs_ioc_fsgeometry(
-	xfs_mount_t		*mp,
-	void			__user *arg);
-
-STATIC int
-xfs_ioc_xattr(
-	xfs_inode_t		*ip,
-	struct file		*filp,
-	unsigned int		cmd,
-	void			__user *arg);
-
-STATIC int
-xfs_ioc_fsgetxattr(
-	xfs_inode_t		*ip,
-	int			attr,
-	void			__user *arg);
-
-STATIC int
-xfs_ioc_getbmap(
-	struct xfs_inode	*ip,
-	int			flags,
-	unsigned int		cmd,
-	void			__user *arg);
-
-STATIC int
-xfs_ioc_getbmapx(
-	struct xfs_inode	*ip,
-	void			__user *arg);
-
-int
-xfs_ioctl(
-	xfs_inode_t		*ip,
-	struct file		*filp,
-	int			ioflags,
-	unsigned int		cmd,
-	void			__user *arg)
-{
-	struct inode		*inode = filp->f_path.dentry->d_inode;
-	xfs_mount_t		*mp = ip->i_mount;
-	int			error;
-
-	xfs_itrace_entry(XFS_I(inode));
-	switch (cmd) {
-
-	case XFS_IOC_ALLOCSP:
-	case XFS_IOC_FREESP:
-	case XFS_IOC_RESVSP:
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP64:
-	case XFS_IOC_RESVSP64:
-	case XFS_IOC_UNRESVSP64:
-		/*
-		 * Only allow the sys admin to reserve space unless
-		 * unwritten extents are enabled.
-		 */
-		if (!XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) &&
-		    !capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, arg);
-
-	case XFS_IOC_DIOINFO: {
-		struct dioattr	da;
-		xfs_buftarg_t	*target =
-			XFS_IS_REALTIME_INODE(ip) ?
-			mp->m_rtdev_targp : mp->m_ddev_targp;
-
-		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
-		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
-
-		if (copy_to_user(arg, &da, sizeof(da)))
-			return -XFS_ERROR(EFAULT);
-		return 0;
-	}
-
-	case XFS_IOC_FSBULKSTAT_SINGLE:
-	case XFS_IOC_FSBULKSTAT:
-	case XFS_IOC_FSINUMBERS:
-		return xfs_ioc_bulkstat(mp, cmd, arg);
-
-	case XFS_IOC_FSGEOMETRY_V1:
-		return xfs_ioc_fsgeometry_v1(mp, arg);
-
-	case XFS_IOC_FSGEOMETRY:
-		return xfs_ioc_fsgeometry(mp, arg);
-
-	case XFS_IOC_GETVERSION:
-		return put_user(inode->i_generation, (int __user *)arg);
-
-	case XFS_IOC_FSGETXATTR:
-		return xfs_ioc_fsgetxattr(ip, 0, arg);
-	case XFS_IOC_FSGETXATTRA:
-		return xfs_ioc_fsgetxattr(ip, 1, arg);
-	case XFS_IOC_GETXFLAGS:
-	case XFS_IOC_SETXFLAGS:
-	case XFS_IOC_FSSETXATTR:
-		return xfs_ioc_xattr(ip, filp, cmd, arg);
-
-	case XFS_IOC_FSSETDM: {
-		struct fsdmidata	dmi;
-
-		if (copy_from_user(&dmi, arg, sizeof(dmi)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_set_dmattrs(ip, dmi.fsd_dmevmask,
-				dmi.fsd_dmstate);
-		return -error;
-	}
-
-	case XFS_IOC_GETBMAP:
-	case XFS_IOC_GETBMAPA:
-		return xfs_ioc_getbmap(ip, ioflags, cmd, arg);
-
-	case XFS_IOC_GETBMAPX:
-		return xfs_ioc_getbmapx(ip, arg);
-
-	case XFS_IOC_FD_TO_HANDLE:
-	case XFS_IOC_PATH_TO_HANDLE:
-	case XFS_IOC_PATH_TO_FSHANDLE:
-		return xfs_find_handle(cmd, arg);
-
-	case XFS_IOC_OPEN_BY_HANDLE:
-		return xfs_open_by_handle(mp, arg, filp, inode);
-
-	case XFS_IOC_FSSETDM_BY_HANDLE:
-		return xfs_fssetdm_by_handle(mp, arg, inode);
-
-	case XFS_IOC_READLINK_BY_HANDLE:
-		return xfs_readlink_by_handle(mp, arg, inode);
-
-	case XFS_IOC_ATTRLIST_BY_HANDLE:
-		return xfs_attrlist_by_handle(mp, arg, inode);
-
-	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-		return xfs_attrmulti_by_handle(mp, arg, inode);
-
-	case XFS_IOC_SWAPEXT: {
-		error = xfs_swapext((struct xfs_swapext __user *)arg);
-		return -error;
-	}
-
-	case XFS_IOC_FSCOUNTS: {
-		xfs_fsop_counts_t out;
-
-		error = xfs_fs_counts(mp, &out);
-		if (error)
-			return -error;
-
-		if (copy_to_user(arg, &out, sizeof(out)))
-			return -XFS_ERROR(EFAULT);
-		return 0;
-	}
-
-	case XFS_IOC_SET_RESBLKS: {
-		xfs_fsop_resblks_t inout;
-		__uint64_t	   in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&inout, arg, sizeof(inout)))
-			return -XFS_ERROR(EFAULT);
-
-		/* input parameter is passed in resblks field of structure */
-		in = inout.resblks;
-		error = xfs_reserve_blocks(mp, &in, &inout);
-		if (error)
-			return -error;
-
-		if (copy_to_user(arg, &inout, sizeof(inout)))
-			return -XFS_ERROR(EFAULT);
-		return 0;
-	}
-
-	case XFS_IOC_GET_RESBLKS: {
-		xfs_fsop_resblks_t out;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		error = xfs_reserve_blocks(mp, NULL, &out);
-		if (error)
-			return -error;
-
-		if (copy_to_user(arg, &out, sizeof(out)))
-			return -XFS_ERROR(EFAULT);
-
-		return 0;
-	}
-
-	case XFS_IOC_FSGROWFSDATA: {
-		xfs_growfs_data_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_growfs_data(mp, &in);
-		return -error;
-	}
-
-	case XFS_IOC_FSGROWFSLOG: {
-		xfs_growfs_log_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_growfs_log(mp, &in);
-		return -error;
-	}
-
-	case XFS_IOC_FSGROWFSRT: {
-		xfs_growfs_rt_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_growfs_rt(mp, &in);
-		return -error;
-	}
-
-	case XFS_IOC_FREEZE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (inode->i_sb->s_frozen == SB_UNFROZEN)
-			freeze_bdev(inode->i_sb->s_bdev);
-		return 0;
-
-	case XFS_IOC_THAW:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		if (inode->i_sb->s_frozen != SB_UNFROZEN)
-			thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);
-		return 0;
-
-	case XFS_IOC_GOINGDOWN: {
-		__uint32_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (get_user(in, (__uint32_t __user *)arg))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_fs_goingdown(mp, in);
-		return -error;
-	}
-
-	case XFS_IOC_ERROR_INJECTION: {
-		xfs_error_injection_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_errortag_add(in.errtag, mp);
-		return -error;
-	}
-
-	case XFS_IOC_ERROR_CLEARALL:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		error = xfs_errortag_clearall(mp, 1);
-		return -error;
-
-	default:
-		return -ENOTTY;
-	}
-}
-
 STATIC int
 xfs_ioc_space(
 	struct xfs_inode	*ip,
@@ -1332,3 +1024,258 @@ xfs_ioc_getbmapx(
 
 	return 0;
 }
+
+int
+xfs_ioctl(
+	xfs_inode_t		*ip,
+	struct file		*filp,
+	int			ioflags,
+	unsigned int		cmd,
+	void			__user *arg)
+{
+	struct inode		*inode = filp->f_path.dentry->d_inode;
+	xfs_mount_t		*mp = ip->i_mount;
+	int			error;
+
+	xfs_itrace_entry(XFS_I(inode));
+	switch (cmd) {
+
+	case XFS_IOC_ALLOCSP:
+	case XFS_IOC_FREESP:
+	case XFS_IOC_RESVSP:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_ALLOCSP64:
+	case XFS_IOC_FREESP64:
+	case XFS_IOC_RESVSP64:
+	case XFS_IOC_UNRESVSP64:
+		/*
+		 * Only allow the sys admin to reserve space unless
+		 * unwritten extents are enabled.
+		 */
+		if (!XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) &&
+		    !capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, arg);
+
+	case XFS_IOC_DIOINFO: {
+		struct dioattr	da;
+		xfs_buftarg_t	*target =
+			XFS_IS_REALTIME_INODE(ip) ?
+			mp->m_rtdev_targp : mp->m_ddev_targp;
+
+		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
+		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
+
+		if (copy_to_user(arg, &da, sizeof(da)))
+			return -XFS_ERROR(EFAULT);
+		return 0;
+	}
+
+	case XFS_IOC_FSBULKSTAT_SINGLE:
+	case XFS_IOC_FSBULKSTAT:
+	case XFS_IOC_FSINUMBERS:
+		return xfs_ioc_bulkstat(mp, cmd, arg);
+
+	case XFS_IOC_FSGEOMETRY_V1:
+		return xfs_ioc_fsgeometry_v1(mp, arg);
+
+	case XFS_IOC_FSGEOMETRY:
+		return xfs_ioc_fsgeometry(mp, arg);
+
+	case XFS_IOC_GETVERSION:
+		return put_user(inode->i_generation, (int __user *)arg);
+
+	case XFS_IOC_FSGETXATTR:
+		return xfs_ioc_fsgetxattr(ip, 0, arg);
+	case XFS_IOC_FSGETXATTRA:
+		return xfs_ioc_fsgetxattr(ip, 1, arg);
+	case XFS_IOC_GETXFLAGS:
+	case XFS_IOC_SETXFLAGS:
+	case XFS_IOC_FSSETXATTR:
+		return xfs_ioc_xattr(ip, filp, cmd, arg);
+
+	case XFS_IOC_FSSETDM: {
+		struct fsdmidata	dmi;
+
+		if (copy_from_user(&dmi, arg, sizeof(dmi)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_set_dmattrs(ip, dmi.fsd_dmevmask,
+				dmi.fsd_dmstate);
+		return -error;
+	}
+
+	case XFS_IOC_GETBMAP:
+	case XFS_IOC_GETBMAPA:
+		return xfs_ioc_getbmap(ip, ioflags, cmd, arg);
+
+	case XFS_IOC_GETBMAPX:
+		return xfs_ioc_getbmapx(ip, arg);
+
+	case XFS_IOC_FD_TO_HANDLE:
+	case XFS_IOC_PATH_TO_HANDLE:
+	case XFS_IOC_PATH_TO_FSHANDLE:
+		return xfs_find_handle(cmd, arg);
+
+	case XFS_IOC_OPEN_BY_HANDLE:
+		return xfs_open_by_handle(mp, arg, filp, inode);
+
+	case XFS_IOC_FSSETDM_BY_HANDLE:
+		return xfs_fssetdm_by_handle(mp, arg, inode);
+
+	case XFS_IOC_READLINK_BY_HANDLE:
+		return xfs_readlink_by_handle(mp, arg, inode);
+
+	case XFS_IOC_ATTRLIST_BY_HANDLE:
+		return xfs_attrlist_by_handle(mp, arg, inode);
+
+	case XFS_IOC_ATTRMULTI_BY_HANDLE:
+		return xfs_attrmulti_by_handle(mp, arg, inode);
+
+	case XFS_IOC_SWAPEXT: {
+		error = xfs_swapext((struct xfs_swapext __user *)arg);
+		return -error;
+	}
+
+	case XFS_IOC_FSCOUNTS: {
+		xfs_fsop_counts_t out;
+
+		error = xfs_fs_counts(mp, &out);
+		if (error)
+			return -error;
+
+		if (copy_to_user(arg, &out, sizeof(out)))
+			return -XFS_ERROR(EFAULT);
+		return 0;
+	}
+
+	case XFS_IOC_SET_RESBLKS: {
+		xfs_fsop_resblks_t inout;
+		__uint64_t	   in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&inout, arg, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);
+
+		/* input parameter is passed in resblks field of structure */
+		in = inout.resblks;
+		error = xfs_reserve_blocks(mp, &in, &inout);
+		if (error)
+			return -error;
+
+		if (copy_to_user(arg, &inout, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);
+		return 0;
+	}
+
+	case XFS_IOC_GET_RESBLKS: {
+		xfs_fsop_resblks_t out;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		error = xfs_reserve_blocks(mp, NULL, &out);
+		if (error)
+			return -error;
+
+		if (copy_to_user(arg, &out, sizeof(out)))
+			return -XFS_ERROR(EFAULT);
+
+		return 0;
+	}
+
+	case XFS_IOC_FSGROWFSDATA: {
+		xfs_growfs_data_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_growfs_data(mp, &in);
+		return -error;
+	}
+
+	case XFS_IOC_FSGROWFSLOG: {
+		xfs_growfs_log_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_growfs_log(mp, &in);
+		return -error;
+	}
+
+	case XFS_IOC_FSGROWFSRT: {
+		xfs_growfs_rt_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_growfs_rt(mp, &in);
+		return -error;
+	}
+
+	case XFS_IOC_FREEZE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (inode->i_sb->s_frozen == SB_UNFROZEN)
+			freeze_bdev(inode->i_sb->s_bdev);
+		return 0;
+
+	case XFS_IOC_THAW:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		if (inode->i_sb->s_frozen != SB_UNFROZEN)
+			thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);
+		return 0;
+
+	case XFS_IOC_GOINGDOWN: {
+		__uint32_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (get_user(in, (__uint32_t __user *)arg))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_fs_goingdown(mp, in);
+		return -error;
+	}
+
+	case XFS_IOC_ERROR_INJECTION: {
+		xfs_error_injection_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_errortag_add(in.errtag, mp);
+		return -error;
+	}
+
+	case XFS_IOC_ERROR_CLEARALL:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		error = xfs_errortag_clearall(mp, 1);
+		return -error;
+
+	default:
+		return -ENOTTY;
+	}
+}
+
