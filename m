Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B0AEF7F5F
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 02:56:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B6B2304048
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 00:56:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 4RqRe6dlqSA6qXgl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Oct 2013 00:56:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VUu40-0000n0-OP
	for xfs@oss.sgi.com; Sat, 12 Oct 2013 07:56:40 +0000
Message-Id: <20131012075640.637625757@bombadil.infradead.org>
Date: Sat, 12 Oct 2013 00:55:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: fold xfs_change_file_space into xfs_ioc_space
References: <20131012075503.370510641@bombadil.infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Now that only one caller of xfs_change_file_space is left it can be merged
into said caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_bmap_util.c |  178 -------------------------------------------------
 fs/xfs/xfs_bmap_util.h |    5 -
 fs/xfs/xfs_ioctl.c     |  130 +++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_iops.h      |    4 -
 4 files changed, 126 insertions(+), 191 deletions(-)

Index: xfs/fs/xfs/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ioctl.c	2013-10-01 21:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_ioctl.c	2013-10-01 21:14:36.688221283 +0200
@@ -641,7 +641,11 @@ xfs_ioc_space(
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
@@ -661,17 +665,127 @@ xfs_ioc_space(
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
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_writeid, 0, 0);
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
Index: xfs/fs/xfs/xfs_bmap_util.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-10-01 21:08:25.264212455 +0200
+++ xfs/fs/xfs/xfs_bmap_util.c	2013-10-01 21:15:28.508222514 +0200
@@ -1385,7 +1385,7 @@ xfs_free_file_space(
 }
 
 
-STATIC int
+int
 xfs_zero_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
@@ -1446,182 +1446,6 @@ out:
 }
 
 /*
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
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_writeid, 0, 0);
-	if (error) {
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
-
-/*
  * We need to check that the format of the data fork in the temporary inode is
  * valid for the target inode before doing the swap. This is not a problem with
  * attr1 because of the fixed fork offset, but attr2 has a dynamically sized
Index: xfs/fs/xfs/xfs_bmap_util.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_util.h	2013-10-01 21:09:13.964213613 +0200
+++ xfs/fs/xfs/xfs_bmap_util.h	2013-10-01 21:15:54.148223124 +0200
@@ -93,13 +93,12 @@ int	xfs_bmap_last_extent(struct xfs_tran
 			     int *is_empty);
 
 /* preallocation and hole punch interface */
-int	xfs_change_file_space(struct xfs_inode *ip, int cmd,
-			      xfs_flock64_t *bf, xfs_off_t offset,
-			      int attr_flags);
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
 			     xfs_off_t len, int alloc_type);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 			    xfs_off_t len);
+int	xfs_zero_file_space(struct xfs_inode *ip, xfs_off_t offset,
+			    xfs_off_t len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
Index: xfs/fs/xfs/xfs_iops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.h	2013-10-01 21:06:23.584209563 +0200
+++ xfs/fs/xfs/xfs_iops.h	2013-10-01 21:16:31.752224017 +0200
@@ -30,9 +30,7 @@ extern void xfs_setup_inode(struct xfs_i
 /*
  * Internal setattr interfaces.
  */
-#define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
-#define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
-#define XFS_ATTR_SYNC		0x10	/* synchronous operation required */
+#define XFS_ATTR_NOACL		0x01	/* Don't call xfs_acl_chmod */
 
 extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
 			       int flags);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
