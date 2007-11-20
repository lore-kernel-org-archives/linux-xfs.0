Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Nov 2007 17:37:04 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAK1apNa009011
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2007 17:36:58 -0800
Date: Tue, 20 Nov 2007 12:36:51 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: xfs_reno #2
Message-ID: <20071120013651.GR995458@sgi.com>
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Thu, Oct 04, 2007 at 02:25:16PM +1000, Barry Naujok wrote:
> A couple changes from the first xfs_reno:
> 
>  - Major one is that symlinks are now supported, but only
>    owner, group and extended attributes are copied for them
>    (not times or inode attributes).
> 
>  - Man page!
> 
> 
> To make this better, ideally we need some form of
> "swap inodes" function in the kernel, where the entire
> contents of the inode themselves are swapped. This form
> can handle any inode and without any of the dir/file/attr/etc
> copy/swap mechanisms we have in xfs_reno.

Something like the attached patch?

This is proof-of-concept. I've compiled it but I haven't tested
it. Your mission, Barry, should you choose to accept it, it to
make it work ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_ioctl.c |    4 
 fs/xfs/xfs_dfrag.c           |  313 ++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_dfrag.h           |   24 ++-
 fs/xfs/xfs_fs.h              |    1 
 fs/xfs/xfs_trans.h           |    3 
 fs/xfs/xfsidbg.c             |    9 -
 6 files changed, 297 insertions(+), 57 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-11-16 10:27:41.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c	2007-11-20 11:18:45.829822690 +1100
@@ -817,6 +817,10 @@ xfs_ioctl(
 		error = xfs_swapext((struct xfs_swapext __user *)arg);
 		return -error;
 	}
+	case XFS_IOC_SWAPINO: {
+		error = xfs_swapino((struct xfs_swapino __user *)arg);
+		return -error;
+	}
 
 	case XFS_IOC_FSCOUNTS: {
 		xfs_fsop_counts_t out;
Index: 2.6.x-xfs-new/fs/xfs/xfs_dfrag.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dfrag.c	2007-11-16 10:27:41.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_dfrag.c	2007-11-20 11:41:28.196327293 +1100
@@ -44,6 +44,20 @@
 #include "xfs_rw.h"
 #include "xfs_vnodeops.h"
 
+
+STATIC int
+xfs_swap_fd_to_inode(int fd, struct file **filp, xfs_inode_t **ip)
+{
+	*filp = fget(fd);
+	if (!*filp)
+		return EINVAL;
+
+	*ip = XFS_I((*filp)->f_path.dentry->d_inode);
+	if (!*ip)
+		return EBADF;
+	return 0;
+}
+
 /*
  * Syssgi interface for swapext
  */
@@ -53,75 +67,85 @@ xfs_swapext(
 {
 	xfs_swapext_t	*sxp;
 	xfs_inode_t     *ip=NULL, *tip=NULL;
-	xfs_mount_t     *mp;
 	struct file	*fp = NULL, *tfp = NULL;
-	bhv_vnode_t	*vp, *tvp;
-	int		error = 0;
+	int		error;
 
+	error = ENOMEM;
 	sxp = kmem_alloc(sizeof(xfs_swapext_t), KM_MAYFAIL);
-	if (!sxp) {
-		error = XFS_ERROR(ENOMEM);
+	if (!sxp)
 		goto error0;
-	}
-
-	if (copy_from_user(sxp, sxu, sizeof(xfs_swapext_t))) {
-		error = XFS_ERROR(EFAULT);
+	error = EFAULT;
+	if (copy_from_user(sxp, sxu, sizeof(xfs_swapext_t)))
 		goto error0;
-	}
 
-	/* Pull information for the target fd */
-	if (((fp = fget((int)sxp->sx_fdtarget)) == NULL) ||
-	    ((vp = vn_from_inode(fp->f_path.dentry->d_inode)) == NULL))  {
-		error = XFS_ERROR(EINVAL);
+	error = xfs_swap_fd_to_inode((int)sxp->sx_fdtarget, &fp, &ip);
+	if (error)
 		goto error0;
-	}
-
-	ip = xfs_vtoi(vp);
-	if (ip == NULL) {
-		error = XFS_ERROR(EBADF);
+	error = xfs_swap_fd_to_inode((int)sxp->sx_fdtmp, &tfp, &tip);
+	if (error)
 		goto error0;
-	}
 
-	if (((tfp = fget((int)sxp->sx_fdtmp)) == NULL) ||
-	    ((tvp = vn_from_inode(tfp->f_path.dentry->d_inode)) == NULL)) {
-		error = XFS_ERROR(EINVAL);
+	error = EINVAL;
+	if (ip->i_mount != tip->i_mount)
 		goto error0;
-	}
-
-	tip = xfs_vtoi(tvp);
-	if (tip == NULL) {
-		error = XFS_ERROR(EBADF);
+	if (ip->i_ino == tip->i_ino)
 		goto error0;
-	}
-
-	if (ip->i_mount != tip->i_mount) {
-		error =  XFS_ERROR(EINVAL);
+	error = EIO;
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		goto error0;
-	}
 
-	if (ip->i_ino == tip->i_ino) {
-		error =  XFS_ERROR(EINVAL);
-		goto error0;
-	}
+	error = xfs_swap_extents(ip, tip, sxp);
+error0:
+	if (fp != NULL)
+		fput(fp);
+	if (tfp != NULL)
+		fput(tfp);
+	if (sxp != NULL)
+		kmem_free(sxp, sizeof(xfs_swapext_t));
+	return error;
+}
 
-	mp = ip->i_mount;
 
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		error =  XFS_ERROR(EIO);
+int
+xfs_swapino(
+	xfs_swapino_t	__user *siu)
+{
+	xfs_swapino_t	*sino;
+	xfs_inode_t     *ip=NULL, *tip=NULL;
+	struct file	*fp = NULL, *tfp = NULL;
+	int		error;
+
+	error = ENOMEM;
+	sino = kmem_alloc(sizeof(xfs_swapino_t), KM_MAYFAIL);
+	if (!sino)
+		goto error0;
+	error = EFAULT;
+	if (copy_from_user(sino, siu, sizeof(xfs_swapino_t)))
 		goto error0;
-	}
 
-	error = xfs_swap_extents(ip, tip, sxp);
+	error = xfs_swap_fd_to_inode((int)sino->sx_fdtarget, &fp, &ip);
+	if (error)
+		goto error0;
+	error = xfs_swap_fd_to_inode((int)sino->sx_fdtmp, &tfp, &tip);
+	if (error)
+		goto error0;
+	error = EINVAL;
+	if (ip->i_mount != tip->i_mount)
+		goto error0;
+	if (ip->i_ino == tip->i_ino)
+		goto error0;
+	error = EIO;
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		goto error0;
 
- error0:
+	error = xfs_swap_inodes(ip, tip, sino);
+error0:
 	if (fp != NULL)
 		fput(fp);
 	if (tfp != NULL)
 		fput(tfp);
-
-	if (sxp != NULL)
-		kmem_free(sxp, sizeof(xfs_swapext_t));
-
+	if (sino != NULL)
+		kmem_free(sino, sizeof(xfs_swapino_t));
 	return error;
 }
 
@@ -397,3 +421,198 @@ xfs_swap_extents(
 		kmem_free(tempifp, sizeof(xfs_ifork_t));
 	return error;
 }
+
+STATIC void
+xfs_swapino_log_fields(
+	xfs_trans_t	*tp,
+	xfs_inode_t	*ip)
+{
+	int		ilf_fields = XFS_ILOG_CORE;
+
+	switch(ip->i_d.di_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		/* If the extents fit in the inode, fix the
+		 * pointer.  Otherwise it's already NULL or
+		 * pointing to the extent.
+		 */
+		if (ip->i_d.di_nextents <= XFS_INLINE_EXTS) {
+			xfs_ifork_t	*ifp = &ip->i_df;
+			ifp->if_u1.if_extents = ifp->if_u2.if_inline_ext;
+		}
+		ilf_fields |= XFS_ILOG_DEXT;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		ilf_fields |= XFS_ILOG_DBROOT;
+		break;
+	}
+
+	switch(ip->i_d.di_aformat) {
+	case XFS_DINODE_FMT_LOCAL:
+		ilf_fields |= XFS_ILOG_ADATA;
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		/* If the extents fit in the inode, fix the
+		 * pointer.  Otherwise it's already NULL or
+		 * pointing to the extent.
+		 */
+		if (ip->i_d.di_nextents <= XFS_INLINE_EXTS) {
+			xfs_ifork_t	*ifp = ip->i_afp;
+			ifp->if_u1.if_extents = ifp->if_u2.if_inline_ext;
+		}
+		ilf_fields |= XFS_ILOG_AEXT;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		ilf_fields |= XFS_ILOG_ABROOT;
+		break;
+	}
+	xfs_trans_log_inode(tp, ip, ilf_fields);
+}
+
+int
+xfs_swap_inodes(
+	xfs_inode_t	*ip,
+	xfs_inode_t	*tip,
+	xfs_swapino_t	*sino)
+{
+	xfs_mount_t	*mp;
+	xfs_inode_t	*ips[2];
+	xfs_trans_t	*tp;
+	xfs_icdinode_t	*dic = NULL;
+	xfs_ifork_t	*tempifp, *ifp, *tifp, *i_afp;
+	static uint	lock_flags = XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL;
+	int		error;
+	char		locked = 0;
+
+	mp = ip->i_mount;
+	error = ENOMEM;
+	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
+	if (!tempifp)
+		goto error0;
+	dic = kmem_alloc(sizeof(xfs_dinode_core_t), KM_MAYFAIL);
+	if (!dic)
+		goto error0;
+
+	/* Lock in i_ino order */
+	if (ip->i_ino < tip->i_ino) {
+		ips[0] = ip;
+		ips[1] = tip;
+	} else {
+		ips[0] = tip;
+		ips[1] = ip;
+	}
+
+	xfs_lock_inodes(ips, 2, 0, lock_flags);
+	locked = 1;
+
+	/* Check permissions */
+	error = xfs_iaccess(ip, S_IWUSR, NULL);
+	if (error)
+		goto error0;
+	error = xfs_iaccess(tip, S_IWUSR, NULL);
+	if (error)
+		goto error0;
+
+	/* Verify that both files have the same format */
+	error = EINVAL;
+	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT))
+		goto error0;
+
+	/* Verify both files are either real-time or non-realtime */
+	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip))
+		goto error0;
+
+	if (VN_CACHED(tip->i_vnode) != 0) {
+		xfs_inval_cached_trace(tip, 0, -1, 0, -1);
+		error = xfs_flushinval_pages(tip, 0, -1,
+				FI_REMAPF_LOCKED);
+		if (error)
+			goto error0;
+	}
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL);
+
+	/*
+	 * There is a race condition here since we gave up the
+	 * ilock.  However, the data fork will not change since
+	 * we have the iolock (locked for truncation too) so we
+	 * are safe.  We don't really care if non-io related
+	 * fields change.
+	 */
+
+	xfs_tosspages(ip, 0, -1, FI_REMAPF);
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPINO);
+	error = xfs_trans_reserve(tp, 0, 2 * XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error) {
+		xfs_iunlock(ip,  XFS_IOLOCK_EXCL);
+		xfs_iunlock(tip, XFS_IOLOCK_EXCL);
+		xfs_trans_cancel(tp, 0);
+		locked = 0;
+		goto error0;
+	}
+	xfs_lock_inodes(ips, 2, 0, XFS_ILOCK_EXCL);
+
+	/*
+	 * Swap the inode cores - structure copies.
+	 */
+	*dic = ip->i_d;
+	ip->i_d = tip->i_d;
+	tip->i_d = *dic;
+
+	/*
+	 * Swap the data forks of the inodes - structure copies
+	 */
+	ifp = &ip->i_df;
+	tifp = &tip->i_df;
+	*tempifp = *ifp;
+	*ifp = *tifp;
+	*tifp = *tempifp;
+
+	/*
+	 * Swap the attribute forks
+	 */
+	i_afp = ip->i_afp;
+	ip->i_afp = tip->i_afp;
+	tip->i_afp = i_afp;
+
+	/*
+	 * Increment vnode ref counts since xfs_trans_commit &
+	 * xfs_trans_cancel will both unlock the inodes and
+	 * decrement the associated ref counts.
+	 */
+	VN_HOLD(ip->i_vnode);
+	VN_HOLD(tip->i_vnode);
+	xfs_trans_ijoin(tp, ip, lock_flags);
+	xfs_trans_ijoin(tp, tip, lock_flags);
+
+
+	/*
+	 * log both entire inodes
+	 */
+	xfs_swapino_log_fields(tp, ip);
+	xfs_swapino_log_fields(tp, tip);
+
+	/*
+	 * If this is a synchronous mount, make sure that the
+	 * transaction goes to disk before returning to the user.
+	 */
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp, XFS_TRANS_SWAPINO);
+	locked = 0;
+
+ error0:
+	if (locked) {
+		xfs_iunlock(ip,  lock_flags);
+		xfs_iunlock(tip, lock_flags);
+	}
+	vn_revalidate(ip->i_vnode);
+	vn_revalidate(tip->i_vnode);
+	if (dic)
+		kmem_free(dic, sizeof(xfs_icdinode_t));
+	if (tempifp)
+		kmem_free(tempifp, sizeof(xfs_ifork_t));
+	return error;
+}
Index: 2.6.x-xfs-new/fs/xfs/xfs_dfrag.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dfrag.h	2007-01-16 10:54:17.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_dfrag.h	2007-11-20 11:20:01.364010037 +1100
@@ -21,7 +21,6 @@
 /*
  * Structure passed to xfs_swapext
  */
-
 typedef struct xfs_swapext
 {
 	__int64_t	sx_version;	/* version */
@@ -38,19 +37,34 @@ typedef struct xfs_swapext
  */
 #define XFS_SX_VERSION		0
 
-#ifdef __KERNEL__
 /*
- * Prototypes for visible xfs_dfrag.c routines.
+ * Structure passed to xfs_swapext
  */
+typedef struct xfs_swapino
+{
+	__int64_t	sx_version;	/* version */
+	__int64_t	sx_fdtarget;	/* fd of target file */
+	__int64_t	sx_fdtmp;	/* fd of tmp file */
+	char		sx_pad[16];	/* pad space, unused */
+} xfs_swapino_t;
 
 /*
- * Syscall interface for xfs_swapext
+ * Version flag
+ */
+#define XFS_SI_VERSION		0
+
+#ifdef __KERNEL__
+/*
+ * Prototypes for visible xfs_dfrag.c routines.
  */
-int	xfs_swapext(struct xfs_swapext __user *sx);
 
+int	xfs_swapext(struct xfs_swapext __user *sx);
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 		struct xfs_swapext *sxp);
 
+int	xfs_swapino(struct xfs_swapino __user *si);
+int	xfs_swap_inodes(struct xfs_inode *ip, struct xfs_inode *tip,
+		struct xfs_swapino *sino);
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_DFRAG_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_fs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fs.h	2007-10-15 09:58:18.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fs.h	2007-11-20 11:19:54.640883392 +1100
@@ -480,6 +480,7 @@ typedef struct xfs_handle {
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_SWAPINO		     _IOWR('X', 126, struct xfs_swapino)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.h	2007-11-16 11:32:26.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.h	2007-11-20 11:28:17.027542129 +1100
@@ -95,7 +95,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_GROWFSRT_FREE		39
 #define	XFS_TRANS_SWAPEXT		40
 #define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_TYPE_MAX		41
+#define	XFS_TRANS_SWAPINO		42
+#define	XFS_TRANS_TYPE_MAX		42
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-11-16 11:32:26.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-11-20 11:29:03.701447244 +1100
@@ -5911,11 +5911,12 @@ xfsidbg_print_trans_type(unsigned int t_
 	case XFS_TRANS_GROWFSRT_ALLOC:	kdb_printf("GROWFSRT_ALLOC");	break;
 	case XFS_TRANS_GROWFSRT_ZERO:	kdb_printf("GROWFSRT_ZERO");	break;
 	case XFS_TRANS_GROWFSRT_FREE:	kdb_printf("GROWFSRT_FREE");	break;
-  	case XFS_TRANS_SWAPEXT:		kdb_printf("SWAPEXT");		break;
+	case XFS_TRANS_SWAPEXT:		kdb_printf("SWAPEXT");		break;
 	case XFS_TRANS_SB_COUNT:	kdb_printf("SB_COUNT");		break;
- 	case XFS_TRANS_DUMMY1:		kdb_printf("DUMMY1");		break;
- 	case XFS_TRANS_DUMMY2:		kdb_printf("DUMMY2");		break;
- 	case XLOG_UNMOUNT_REC_TYPE:	kdb_printf("UNMOUNT");		break;
+	case XFS_TRANS_SWAPINO:		kdb_printf("SWAPINO");		break;
+	case XFS_TRANS_DUMMY1:		kdb_printf("DUMMY1");		break;
+	case XFS_TRANS_DUMMY2:		kdb_printf("DUMMY2");		break;
+	case XLOG_UNMOUNT_REC_TYPE:	kdb_printf("UNMOUNT");		break;
 	default:			kdb_printf("unknown(0x%x)", t_type); break;
 	}
 }
