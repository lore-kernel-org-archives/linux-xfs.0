Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8C7eTG029976 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 06:07:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	deuvIucnEOWnk1oe (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 04:10:07 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1ThJEM-0004ig-GQ
	for xfs@oss.sgi.com; Sat, 08 Dec 2012 12:10:06 +0000
Message-Id: <20121208121006.467482248@bombadil.infradead.org>
Date: Sat, 08 Dec 2012 07:08:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: fold xfs_change_file_space into xfs_ioc_space
References: <20121208120812.755863148@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_change_file_space-2
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

Now that only one caller of xfs_change_file_space is left it can be merged
into said caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ioctl.c    |  130 +++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_vnodeops.c |  180 --------------------------------------------------
 fs/xfs/xfs_vnodeops.h |    7 -
 3 files changed, 125 insertions(+), 192 deletions(-)

Index: xfs/fs/xfs/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ioctl.c	2012-11-30 18:39:57.876020790 -0800
+++ xfs/fs/xfs/xfs_ioctl.c	2012-11-30 18:43:52.728026802 -0800
@@ -613,7 +613,11 @@ xfs_ioc_space(
 	unsigned int		cmd,
 	xfs_flock64_t		*bf)
 {
-	int			attr_flags = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct iattr		iattr;
+	bool			setprealloc = false;
+	bool			clrprealloc = false;
 	int			error;
 
 	/*
@@ -633,17 +637,127 @@ xfs_ioc_space(
 	if (!S_ISREG(inode->i_mode))
 		return -XFS_ERROR(EINVAL);
 
-	if (filp->f_flags & O_DSYNC)
-		attr_flags |= XFS_ATTR_SYNC;
-
-	if (ioflags & IO_INVIS)
-		attr_flags |= XFS_ATTR_DMI;
-
 	error = mnt_want_write_file(filp);
 	if (error)
 		return error;
+
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	error = xfs_change_file_space(ip, cmd, bf, filp->f_pos, attr_flags);
+
+	switch (bf->l_whence) {
+	case 0: /*SEEK_SET*/
+		break;
+	case 1: /*SEEK_CUR*/
+		bf->l_start += filp->f_pos;
+		break;
+	case 2: /*SEEK_END*/
+		bf->l_start += XFS_ISIZE(ip);
+		break;
+	default:
+		error = XFS_ERROR(EINVAL);
+		goto out_unlock;
+	}
+
+	/*
+	 * length of <= 0 for resv/unresv/zero is invalid.  length for
+	 * alloc/free is ignored completely and we have no idea what userspace
+	 * might have set it to, so set it to zero to allow range
+	 * checks to pass.
+	 */
+	switch (cmd) {
+	case XFS_IOC_ZERO_RANGE:
+	case XFS_IOC_RESVSP:
+	case XFS_IOC_RESVSP64:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_UNRESVSP64:
+		if (bf->l_len <= 0) {
+			error = XFS_ERROR(EINVAL);
+			goto out_unlock;
+		}
+		break;
+	default:
+		bf->l_len = 0;
+		break;
+	}
+
+	if (bf->l_start < 0 ||
+	    bf->l_start > mp->m_super->s_maxbytes ||
+	    bf->l_start + bf->l_len < 0 ||
+	    bf->l_start + bf->l_len >= mp->m_super->s_maxbytes) {
+		error = XFS_ERROR(EINVAL);
+		goto out_unlock;
+	}
+
+	switch (cmd) {
+	case XFS_IOC_ZERO_RANGE:
+		error = xfs_zero_file_space(ip, bf->l_start, bf->l_len);
+		if (!error)
+			setprealloc = true;
+		break;
+	case XFS_IOC_RESVSP:
+	case XFS_IOC_RESVSP64:
+		error = xfs_alloc_file_space(ip, bf->l_start, bf->l_len,
+						XFS_BMAPI_PREALLOC);
+		if (!error)
+			setprealloc = true;
+		break;
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_UNRESVSP64:
+		error = xfs_free_file_space(ip, bf->l_start, bf->l_len);
+		break;
+	case XFS_IOC_ALLOCSP:
+	case XFS_IOC_ALLOCSP64:
+	case XFS_IOC_FREESP:
+	case XFS_IOC_FREESP64:
+		if (bf->l_start > XFS_ISIZE(ip)) {
+			error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
+					bf->l_start - XFS_ISIZE(ip), 0);
+			if (error)
+				goto out_unlock;
+		}
+
+		iattr.ia_valid = ATTR_SIZE;
+		iattr.ia_size = bf->l_start;
+
+		error = xfs_setattr_size(ip, &iattr);
+		if (!error)
+			clrprealloc = true;
+		break;
+	default:
+		ASSERT(0);
+		error = XFS_ERROR(EINVAL);
+	}
+
+	if (error)
+		goto out_unlock;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_WRITEID);
+	error = xfs_trans_reserve(tp, 0, XFS_WRITEID_LOG_RES(mp), 0, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		goto out_unlock;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	if (!(ioflags & IO_INVIS)) {
+		ip->i_d.di_mode &= ~S_ISUID;
+		if (ip->i_d.di_mode & S_IXGRP)
+			ip->i_d.di_mode &= ~S_ISGID;
+		xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	}
+
+	if (setprealloc)
+		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+	else if (clrprealloc)
+		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	if (filp->f_flags & O_DSYNC)
+		xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp, 0);
+
+out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	mnt_drop_write_file(filp);
 	return -error;
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2012-11-30 18:42:17.796024371 -0800
+++ xfs/fs/xfs/xfs_vnodeops.c	2012-11-30 18:43:52.728026802 -0800
@@ -2054,7 +2054,7 @@ xfs_free_file_space(
 }
 
 
-STATIC int
+int
 xfs_zero_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
@@ -2113,181 +2113,3 @@ out:
 	return error;
 
 }
-
-/*
- * xfs_change_file_space()
- *      This routine allocates or frees disk space for the given file.
- *      The user specified parameters are checked for alignment and size
- *      limitations.
- *
- * RETURNS:
- *       0 on success
- *      errno on error
- *
- */
-int
-xfs_change_file_space(
-	xfs_inode_t	*ip,
-	int		cmd,
-	xfs_flock64_t	*bf,
-	xfs_off_t	offset,
-	int		attr_flags)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	int		clrprealloc;
-	int		error;
-	xfs_fsize_t	fsize;
-	int		setprealloc;
-	xfs_off_t	startoffset;
-	xfs_trans_t	*tp;
-	struct iattr	iattr;
-
-	if (!S_ISREG(ip->i_d.di_mode))
-		return XFS_ERROR(EINVAL);
-
-	switch (bf->l_whence) {
-	case 0: /*SEEK_SET*/
-		break;
-	case 1: /*SEEK_CUR*/
-		bf->l_start += offset;
-		break;
-	case 2: /*SEEK_END*/
-		bf->l_start += XFS_ISIZE(ip);
-		break;
-	default:
-		return XFS_ERROR(EINVAL);
-	}
-
-	/*
-	 * length of <= 0 for resv/unresv/zero is invalid.  length for
-	 * alloc/free is ignored completely and we have no idea what userspace
-	 * might have set it to, so set it to zero to allow range
-	 * checks to pass.
-	 */
-	switch (cmd) {
-	case XFS_IOC_ZERO_RANGE:
-	case XFS_IOC_RESVSP:
-	case XFS_IOC_RESVSP64:
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_UNRESVSP64:
-		if (bf->l_len <= 0)
-			return XFS_ERROR(EINVAL);
-		break;
-	default:
-		bf->l_len = 0;
-		break;
-	}
-
-	if (bf->l_start < 0 ||
-	    bf->l_start > mp->m_super->s_maxbytes ||
-	    bf->l_start + bf->l_len < 0 ||
-	    bf->l_start + bf->l_len >= mp->m_super->s_maxbytes)
-		return XFS_ERROR(EINVAL);
-
-	bf->l_whence = 0;
-
-	startoffset = bf->l_start;
-	fsize = XFS_ISIZE(ip);
-
-	setprealloc = clrprealloc = 0;
-	switch (cmd) {
-	case XFS_IOC_ZERO_RANGE:
-		error = xfs_zero_file_space(ip, startoffset, bf->l_len);
-		if (error)
-			return error;
-		setprealloc = 1;
-		break;
-
-	case XFS_IOC_RESVSP:
-	case XFS_IOC_RESVSP64:
-		error = xfs_alloc_file_space(ip, startoffset, bf->l_len,
-						XFS_BMAPI_PREALLOC);
-		if (error)
-			return error;
-		setprealloc = 1;
-		break;
-
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_UNRESVSP64:
-		error = xfs_free_file_space(ip, startoffset, bf->l_len);
-		if (error)
-			return error;
-		break;
-
-	case XFS_IOC_ALLOCSP:
-	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP:
-	case XFS_IOC_FREESP64:
-		/*
-		 * These operations actually do IO when extending the file, but
-		 * the allocation is done seperately to the zeroing that is
-		 * done. This set of operations need to be serialised against
-		 * other IO operations, such as truncate and buffered IO. We
-		 * need to take the IOLOCK here to serialise the allocation and
-		 * zeroing IO to prevent other IOLOCK holders (e.g. getbmap,
-		 * truncate, direct IO) from racing against the transient
-		 * allocated but not written state we can have here.
-		 */
-		if (startoffset > fsize) {
-			error = xfs_alloc_file_space(ip, fsize,
-					startoffset - fsize, 0);
-			if (error)
-				break;
-		}
-
-		iattr.ia_valid = ATTR_SIZE;
-		iattr.ia_size = startoffset;
-
-		error = xfs_setattr_size(ip, &iattr);
-
-		if (error)
-			return error;
-
-		clrprealloc = 1;
-		break;
-
-	default:
-		ASSERT(0);
-		return XFS_ERROR(EINVAL);
-	}
-
-	/*
-	 * update the inode timestamp, mode, and prealloc flag bits
-	 */
-	tp = xfs_trans_alloc(mp, XFS_TRANS_WRITEID);
-
-	if ((error = xfs_trans_reserve(tp, 0, XFS_WRITEID_LOG_RES(mp),
-				      0, 0, 0))) {
-		/* ASSERT(0); */
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
-	if ((attr_flags & XFS_ATTR_DMI) == 0) {
-		ip->i_d.di_mode &= ~S_ISUID;
-
-		/*
-		 * Note that we don't have to worry about mandatory
-		 * file locking being disabled here because we only
-		 * clear the S_ISGID bit if the Group execute bit is
-		 * on, but if it was on then mandatory locking wouldn't
-		 * have been enabled.
-		 */
-		if (ip->i_d.di_mode & S_IXGRP)
-			ip->i_d.di_mode &= ~S_ISGID;
-
-		xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	}
-	if (setprealloc)
-		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
-	else if (clrprealloc)
-		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (attr_flags & XFS_ATTR_SYNC)
-		xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp, 0);
-}
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2012-11-30 18:42:17.796024371 -0800
+++ xfs/fs/xfs/xfs_vnodeops.h	2012-11-30 18:43:52.732026802 -0800
@@ -14,9 +14,7 @@ struct xfs_inode;
 
 int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap, int flags);
 int xfs_setattr_size(struct xfs_inode *ip, struct iattr *iattr);
-#define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
-#define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
-#define XFS_ATTR_SYNC		0x10	/* synchronous operation required */
+#define XFS_ATTR_NOACL		0x01	/* Don't call xfs_acl_chmod */
 
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_release(struct xfs_inode *ip);
@@ -34,11 +32,10 @@ int xfs_readdir(struct xfs_inode	*dp, vo
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, umode_t mode, struct xfs_inode **ipp);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
-int xfs_change_file_space(struct xfs_inode *ip, int cmd,
-		xfs_flock64_t *bf, xfs_off_t offset, int attr_flags);
 int xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t len,
 			 int alloc_type);
 int xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t len);
+int xfs_zero_file_space(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t len);
 int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 		struct xfs_inode *src_ip, struct xfs_inode *target_dp,
 		struct xfs_name *target_name, struct xfs_inode *target_ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
