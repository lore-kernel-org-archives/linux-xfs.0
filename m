Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E389D7F60
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D23F1304048
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:29 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id YvsFCD1kFF1i8N7D (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:28 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/20] xfs: factor out a xfs_update_prealloc_flags() helper
Date: Thu, 22 Jan 2015 12:10:04 +0100
Message-Id: <1421925006-24231-19-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

This logic is duplicated in xfs_file_fallocate and xfs_ioc_space, and
we'll need another copy of it for pNFS block support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  | 64 +++++++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_inode.h |  9 ++++++++
 fs/xfs/xfs_ioctl.c | 50 ++++++++++--------------------------------
 3 files changed, 63 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 13e974e..712d312 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -127,6 +127,42 @@ xfs_iozero(
 	return (-status);
 }
 
+int
+xfs_update_prealloc_flags(
+	struct xfs_inode	*ip,
+	enum xfs_prealloc_flags	flags)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_WRITEID);
+	error = xfs_trans_reserve(tp, &M_RES(ip->i_mount)->tr_writeid, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	if (!(flags & XFS_PREALLOC_INVISIBLE)) {
+		ip->i_d.di_mode &= ~S_ISUID;
+		if (ip->i_d.di_mode & S_IXGRP)
+			ip->i_d.di_mode &= ~S_ISGID;
+		xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	}
+
+	if (flags & XFS_PREALLOC_SET)
+		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+	if (flags & XFS_PREALLOC_CLEAR)
+		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	if (flags & XFS_PREALLOC_SYNC)
+		xfs_trans_set_sync(tp);
+	return xfs_trans_commit(tp, 0);
+}
+
 /*
  * Fsync operations on directories are much simpler than on regular files,
  * as there is no file data to flush, and thus also no need for explicit
@@ -784,8 +820,8 @@ xfs_file_fallocate(
 {
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_trans	*tp;
 	long			error;
+	enum xfs_prealloc_flags	flags = 0;
 	loff_t			new_size = 0;
 
 	if (!S_ISREG(inode->i_mode))
@@ -822,6 +858,8 @@ xfs_file_fallocate(
 		if (error)
 			goto out_unlock;
 	} else {
+		flags |= XFS_PREALLOC_SET;
+
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -839,28 +877,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
-	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_WRITEID);
-	error = xfs_trans_reserve(tp, &M_RES(ip->i_mount)->tr_writeid, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		goto out_unlock;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	ip->i_d.di_mode &= ~S_ISUID;
-	if (ip->i_d.di_mode & S_IXGRP)
-		ip->i_d.di_mode &= ~S_ISGID;
-
-	if (!(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)))
-		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
-
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
 	if (file->f_flags & O_DSYNC)
-		xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
+		flags |= XFS_PREALLOC_SYNC;
+
+	error = xfs_update_prealloc_flags(ip, flags);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4ed2ba9..bc220bc 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -377,6 +377,15 @@ int		xfs_droplink(struct xfs_trans *, struct xfs_inode *);
 int		xfs_bumplink(struct xfs_trans *, struct xfs_inode *);
 
 /* from xfs_file.c */
+enum xfs_prealloc_flags {
+	XFS_PREALLOC_SET	= (1 << 1),
+	XFS_PREALLOC_CLEAR	= (1 << 2),
+	XFS_PREALLOC_SYNC	= (1 << 3),
+	XFS_PREALLOC_INVISIBLE	= (1 << 4),
+};
+
+int		xfs_update_prealloc_flags(struct xfs_inode *,
+			enum xfs_prealloc_flags);
 int		xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 int		xfs_iozero(struct xfs_inode *, loff_t, size_t);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a183198..d58bcd2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -606,11 +606,8 @@ xfs_ioc_space(
 	unsigned int		cmd,
 	xfs_flock64_t		*bf)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
 	struct iattr		iattr;
-	bool			setprealloc = false;
-	bool			clrprealloc = false;
+	enum xfs_prealloc_flags	flags = 0;
 	int			error;
 
 	/*
@@ -630,6 +627,11 @@ xfs_ioc_space(
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 
+	if (filp->f_flags & O_DSYNC)
+		flags |= XFS_PREALLOC_SYNC;
+	if (ioflags & XFS_IO_INVIS)	
+		flags |= XFS_PREALLOC_INVISIBLE;
+
 	error = mnt_want_write_file(filp);
 	if (error)
 		return error;
@@ -673,25 +675,23 @@ xfs_ioc_space(
 	}
 
 	if (bf->l_start < 0 ||
-	    bf->l_start > mp->m_super->s_maxbytes ||
+	    bf->l_start > inode->i_sb->s_maxbytes ||
 	    bf->l_start + bf->l_len < 0 ||
-	    bf->l_start + bf->l_len >= mp->m_super->s_maxbytes) {
+	    bf->l_start + bf->l_len >= inode->i_sb->s_maxbytes) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
 
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
+		flags |= XFS_PREALLOC_SET;
 		error = xfs_zero_file_space(ip, bf->l_start, bf->l_len);
-		if (!error)
-			setprealloc = true;
 		break;
 	case XFS_IOC_RESVSP:
 	case XFS_IOC_RESVSP64:
+		flags |= XFS_PREALLOC_SET;
 		error = xfs_alloc_file_space(ip, bf->l_start, bf->l_len,
 						XFS_BMAPI_PREALLOC);
-		if (!error)
-			setprealloc = true;
 		break;
 	case XFS_IOC_UNRESVSP:
 	case XFS_IOC_UNRESVSP64:
@@ -701,6 +701,7 @@ xfs_ioc_space(
 	case XFS_IOC_ALLOCSP64:
 	case XFS_IOC_FREESP:
 	case XFS_IOC_FREESP64:
+		flags |= XFS_PREALLOC_CLEAR;
 		if (bf->l_start > XFS_ISIZE(ip)) {
 			error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
 					bf->l_start - XFS_ISIZE(ip), 0);
@@ -712,8 +713,6 @@ xfs_ioc_space(
 		iattr.ia_size = bf->l_start;
 
 		error = xfs_setattr_size(ip, &iattr);
-		if (!error)
-			clrprealloc = true;
 		break;
 	default:
 		ASSERT(0);
@@ -723,32 +722,7 @@ xfs_ioc_space(
 	if (error)
 		goto out_unlock;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_WRITEID);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_writeid, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		goto out_unlock;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
-	if (!(ioflags & XFS_IO_INVIS)) {
-		ip->i_d.di_mode &= ~S_ISUID;
-		if (ip->i_d.di_mode & S_IXGRP)
-			ip->i_d.di_mode &= ~S_ISGID;
-		xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	}
-
-	if (setprealloc)
-		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
-	else if (clrprealloc)
-		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (filp->f_flags & O_DSYNC)
-		xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_update_prealloc_flags(ip, flags);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
