Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6htV2067266 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:43:55 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MeRfN0wsRioAEMEX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:46:00 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6jxns003588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:59 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6jw2j019550
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:59 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6jvvh005231 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:45:57 -0600
Message-ID: <50A5E11F.9070804@oracle.com>
Date: Fri, 16 Nov 2012 14:45:51 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 07/15] xfs: Introduce a new ioctl(2) for swapping inodes
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Introduce a new ioctl(2) for swapping nodes which is like to extents swap.
With this function, the entire contents of an inode is copied, so that we can
omit the general inodes copy procedures from user land.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_dfrag.c |  257 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dfrag.h |   18 ++++-
 fs/xfs/xfs_fs.h    |    1 +
 fs/xfs/xfs_ioctl.c |   15 +++
 4 files changed, 290 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index b9b8646..f91b79c 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -450,3 +450,260 @@ out_trans_cancel:
 	xfs_trans_cancel(tp, 0);
 	goto out_unlock;
 }
+
+static int
+xfs_swap_inodes(
+	xfs_inode_t	*ip,
+	xfs_inode_t	*tip,
+	xfs_swapino_t	*sip)
+{
+	xfs_mount_t	*mp = ip->i_mount;
+	xfs_icdinode_t	*dic = NULL;
+	xfs_ifork_t	*tempifp, *ifp, *tifp, *i_afp;
+	xfs_trans_t	*tp;
+	int		src_log_flags;
+	int		target_log_flags;
+	int		error;
+
+	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
+	if (!tempifp) {
+		error = XFS_ERROR(ENOMEM);
+		goto out;
+	}
+
+	dic = kmem_alloc(sizeof(xfs_icdinode_t), KM_MAYFAIL);
+	if (!dic) {
+		error = XFS_ERROR(ENOMEM);
+		goto out;
+	}
+
+	/*
+	 * We have to do two separate lock calls here to keep lockdep
+	 * happy.  If we try to get all the locks in one call, lock
+	 * will report false positives when we drop the ILOCK and regain
+	 * them below.
+	 */
+	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
+	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
+
+	/* Verify that both files have the same format */
+	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
+		error = XFS_ERROR(EINVAL);
+		goto out_unlock;
+	}
+
+	/* Verify both files are either real-time or non-realtime */
+	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
+		error = XFS_ERROR(EINVAL);
+		goto out_unlock;
+	}
+
+	if (VN_CACHED(VFS_I(tip)) != 0) {
+		error = xfs_flushinval_pages(tip, 0, -1, FI_REMAPF_LOCKED);
+		if (error)
+			goto out_unlock;
+	}
+
+	/* Verify O_DIRECT for ftmp */
+	if (VN_CACHED(VFS_I(tip)) != 0) {
+		error = XFS_ERROR(EINVAL);
+		goto out_unlock;
+	}
+
+	/*
+	 * We need to fail if the file is memory mapped.  Once we have tossed
+	 * all existing pages, the page fault will have no option but to go to
+	 * the filesystem for pages. By making the page fault call vop_read
+	 * (or write in the case of autogrow) they block on the iolock until
+	 * we have switched the extents.
+	 */
+	if (VN_MAPPED(VFS_I(ip))) {
+		error = XFS_ERROR(EBUSY);
+		goto out_unlock;
+	}
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL);
+
+	/*
+	 * There is race condition here since we gave up the ilock.
+	 * However, the data fork will not change since we have the
+	 * iolock(locked for truncation too) so we are safe.
+	 * We don't really care if non-io related fields changes.
+	 */
+	xfs_tosspages(ip, 0, -1, FI_REMAPF);
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPINO);
+	error = xfs_trans_reserve(tp, 0, 2 * XFS_ICHANGE_LOG_RES(mp),
+				  0, 0, 0);
+	if (error) {
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		xfs_iunlock(tip, XFS_IOLOCK_EXCL);
+		xfs_trans_cancel(tp, 0);
+		goto out;
+	}
+	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
+
+	/* Swapping the inode cores -- structure copies */
+	*dic = ip->i_d;
+	ip->i_d = tip->i_d;
+	tip->i_d = *dic;
+
+	/* Swap the data forks of the inodes - structure copies */
+	ifp = &ip->i_df;
+	tifp = &tip->i_df;
+	*tempifp = *ifp;
+	*ifp = *tifp;
+	*tifp = *tempifp;
+
+	/* Swap the attributes forks */
+	i_afp = ip->i_afp;
+	ip->i_afp = tip->i_afp;
+	tip->i_afp = i_afp;
+
+	src_log_flags = XFS_ILOG_CORE;
+	switch (ip->i_d.di_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		/*
+		 * If the extents fit in the inode, fix the
+		 * pointer.  Otherwise it's already NULL or
+		 * pointing to the extent.
+		 */
+		if (ip->i_d.di_nextents <= XFS_INLINE_EXTS) {
+			ifp->if_u1.if_extents =
+				ifp->if_u2.if_inline_ext;
+		}
+		src_log_flags |= XFS_ILOG_DEXT;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		src_log_flags |= XFS_ILOG_DBROOT;
+		break;
+	}
+
+	target_log_flags = XFS_ILOG_CORE;
+	switch (tip->i_d.di_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		/*
+		 * If the extents fit in the inode, fix the
+		 * pointer.  Otherwise it's already NULL or
+		 * pointing to the extent.
+		 */
+		if (tip->i_d.di_nextents <= XFS_INLINE_EXTS) {
+			tifp->if_u1.if_extents =
+				tifp->if_u2.if_inline_ext;
+		}
+		target_log_flags |= XFS_ILOG_DEXT;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		target_log_flags |= XFS_ILOG_DBROOT;
+		break;
+	}
+
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+
+	xfs_trans_log_inode(tp, ip,  src_log_flags);
+	xfs_trans_log_inode(tp, tip, target_log_flags);
+
+	/*
+	 * If this is a synchronous mount, make sure that the
+	 * transaction goes to disk before returning to the user.
+	 */
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp, 0);
+
+out:
+	if (dic)
+		kmem_free(dic);
+	if (tempifp)
+		kmem_free(tempifp);
+	return error;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	goto out;
+}
+
+/*
+ * ioctl interface for swapino.
+ */
+int
+xfs_swapino(
+	xfs_swapino_t	*sip)
+{
+	xfs_inode_t     *ip, *tip;
+	struct fd	f, tmp;
+	int		error;
+
+	/* Pull information for the target fd */
+	f = fdget((int)sip->si_fdtarget);
+	if (!f.file) {
+		error = XFS_ERROR(EINVAL);
+		goto out;
+	}
+
+	/*
+	 * We don't need to check the FMODE nad FLAGS same to
+	 * regular file for directory as it should be open in
+	 * O_RDONLY mode.
+	 */
+	if ((!(f.file->f_mode & FMODE_WRITE) ||
+	     !(f.file->f_mode & FMODE_READ) ||
+	     (f.file->f_flags & O_APPEND)) &&
+	    !S_ISDIR(f.file->f_path.dentry->d_inode->i_mode)) {
+		error = XFS_ERROR(EBADF);
+		goto out_put_file;
+	}
+
+	tmp = fdget((int)sip->si_fdtmp);
+	if (!tmp.file) {
+		error = XFS_ERROR(EINVAL);
+		goto out_put_file;
+	}
+
+	if ((!(tmp.file->f_mode & FMODE_WRITE) ||
+	     !(tmp.file->f_mode & FMODE_READ) ||
+	     (tmp.file->f_flags & O_APPEND)) &&
+	    !S_ISDIR(tmp.file->f_path.dentry->d_inode->i_mode)) {
+		error = XFS_ERROR(EBADF);
+		goto out_put_tmp_file;
+	}
+
+	if (IS_SWAPFILE(f.file->f_path.dentry->d_inode) ||
+	    IS_SWAPFILE(tmp.file->f_path.dentry->d_inode)) {
+		error = XFS_ERROR(EINVAL);
+		goto out_put_tmp_file;
+	}
+
+	ip = XFS_I(f.file->f_path.dentry->d_inode);
+	tip = XFS_I(tmp.file->f_path.dentry->d_inode);
+
+	if (ip->i_mount != tip->i_mount) {
+		error = XFS_ERROR(EINVAL);
+		goto out_put_tmp_file;
+	}
+
+	if (ip->i_ino == tip->i_ino) {
+		error = XFS_ERROR(EINVAL);
+		goto out_put_tmp_file;
+	}
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		error = XFS_ERROR(EIO);
+		goto out_put_tmp_file;
+	}
+
+	error = xfs_swap_inodes(ip, tip, sip);
+
+out_put_tmp_file:
+	fdput(tmp);
+
+out_put_file:
+	fdput(f);
+
+out:
+	return error;
+}
diff --git a/fs/xfs/xfs_dfrag.h b/fs/xfs/xfs_dfrag.h
index 20bdd93..ef6bcd3 100644
--- a/fs/xfs/xfs_dfrag.h
+++ b/fs/xfs/xfs_dfrag.h
@@ -38,6 +38,21 @@ typedef struct xfs_swapext
  */
 #define XFS_SX_VERSION		0
 
+/*
+ * Structure passed to xfs_swapino.
+ */
+typedef struct xfs_swapino {
+	__int64_t	si_version;	/* version */
+	__int64_t	si_fdtarget;	/* fd of target file */
+	__int64_t	si_fdtmp;	/* fd of temp file */
+	char		si_pad[16];	/* pad space, unused */
+} xfs_swapino_t;
+
+/*
+ * Version flag.
+ */
+#define XFS_SI_VERSION		0
+
 #ifdef __KERNEL__
 /*
  * Prototypes for visible xfs_dfrag.c routines.
@@ -46,7 +61,8 @@ typedef struct xfs_swapext
 /*
  * Syscall interface for xfs_swapext
  */
-int	xfs_swapext(struct xfs_swapext *sx);
+int xfs_swapext(struct xfs_swapext *sx);
+int xfs_swapino(struct xfs_swapino *si);
 
 #endif	/* __KERNEL__ */
 
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index e306b8f..c459d52 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -488,6 +488,7 @@ typedef struct xfs_handle {
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 #define XFS_IOC_SET_AGSTATE	     _IOW('X', 126, struct xfs_ioc_agstate)
 #define XFS_IOC_GET_AGSTATE	     _IOR('X', 127, struct xfs_ioc_agstate)
+#define XFS_IOC_SWAPINO		     _IOWR('X', 128, struct xfs_swapino)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4d3a705..0e0c03f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1634,6 +1634,21 @@ xfs_file_ioctl(
 		return 0;
 	}
 
+	case XFS_IOC_SWAPINO: {
+		struct xfs_swapino	sip;
+
+		if (copy_from_user(&sip, arg, sizeof(xfs_swapino_t)))
+			return -XFS_ERROR(EFAULT);
+
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
+
+		error = xfs_swapino(&sip);
+		mnt_drop_write_file(filp);
+		return -error;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
