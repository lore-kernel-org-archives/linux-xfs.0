Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3Hk0JR007656 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 11:46:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBE54167AF80
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 09:45:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1HolTT7meIFcIutd for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 09:45:58 -0800 (PST)
Date: Wed, 3 Dec 2008 12:45:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] add a FMODE flag to make XFS invisible I/O less hacky
Message-ID: <20081203174527.GA16187@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk


XFS has a mode called invisble I/O that doesn't update any of the               
timestamps.  It's used for HSM-style applications and exposed through           
the nasty open by handle ioctl.

Instead of doing directly assignment of file operations that set an             
internal flag for it add a new FMODE_NOCMTIME flag that we can check           
in the normal file operations.                                                  

Note that I'd like to get this into 2.6.29 via the XFS tree as there
are a lot changes in XFS that would cause conflicts otherwise.

For 2.6.30 I'll plan turning it into a proper O_ flag available via
open(2), but for now I just want to sort out the XFS issues.
                                                                                

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-12-03 18:30:14.000000000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-12-03 18:30:34.000000000 +0100
@@ -599,19 +599,24 @@ out:
 	return error;
 }
 
-STATIC long
-xfs_compat_ioctl(
-	xfs_inode_t	*ip,
-	struct file	*filp,
-	int		ioflags,
-	unsigned	cmd,
-	void		__user *arg)
+long
+xfs_file_compat_ioctl(
+	struct file		*filp,
+	unsigned		cmd,
+	unsigned long		p)
 {
-	struct inode	*inode = filp->f_path.dentry->d_inode;
-	xfs_mount_t	*mp = ip->i_mount;
-	int		error;
+	struct inode		*inode = filp->f_path.dentry->d_inode;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	void			__user *arg = (void __user *)p;
+	int			ioflags = 0;
+	int			error;
+
+	if (filp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
+	xfs_itrace_entry(ip);
 
-	xfs_itrace_entry(XFS_I(inode));
 	switch (cmd) {
 	/* No size or alignment issues on any arch */
 	case XFS_IOC_DIOINFO:
@@ -632,7 +637,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
-		return xfs_ioctl(ip, filp, ioflags, cmd, arg);
+		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
@@ -646,7 +651,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGEOMETRY_V1:
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSRT:
-		return xfs_ioctl(ip, filp, ioflags, cmd, arg);
+		return xfs_file_ioctl(filp, cmd, p);
 #else
 	case XFS_IOC_ALLOCSP_32:
 	case XFS_IOC_FREESP_32:
@@ -687,7 +692,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_SETXFLAGS_32:
 	case XFS_IOC_GETVERSION_32:
 		cmd = _NATIVE_IOC(cmd, long);
-		return xfs_ioctl(ip, filp, ioflags, cmd, arg);
+		return xfs_file_ioctl(filp, cmd, p);
 	case XFS_IOC_SWAPEXT: {
 		struct xfs_swapext	  sxp;
 		struct compat_xfs_swapext __user *sxu = arg;
@@ -738,26 +743,3 @@ xfs_compat_ioctl(
 		return -XFS_ERROR(ENOIOCTLCMD);
 	}
 }
-
-long
-xfs_file_compat_ioctl(
-	struct file		*filp,
-	unsigned int		cmd,
-	unsigned long		p)
-{
-	struct inode	*inode = filp->f_path.dentry->d_inode;
-
-	return xfs_compat_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
-}
-
-long
-xfs_file_compat_invis_ioctl(
-	struct file		*filp,
-	unsigned int		cmd,
-	unsigned long		p)
-{
-	struct inode	*inode = filp->f_path.dentry->d_inode;
-
-	return xfs_compat_ioctl(XFS_I(inode), filp, IO_INVIS, cmd,
-				(void __user *)p);
-}
Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2008-12-03 18:30:14.000000000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2008-12-03 18:30:34.000000000 +0100
@@ -45,81 +45,45 @@
 
 static struct vm_operations_struct xfs_file_vm_ops;
 
-STATIC_INLINE ssize_t
-__xfs_file_read(
+STATIC ssize_t
+xfs_file_aio_read(
 	struct kiocb		*iocb,
 	const struct iovec	*iov,
 	unsigned long		nr_segs,
-	int			ioflags,
 	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
+	int			ioflags = IO_ISAIO;
 
 	BUG_ON(iocb->ki_pos != pos);
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= IO_ISDIRECT;
+	if (file->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
 	return xfs_read(XFS_I(file->f_path.dentry->d_inode), iocb, iov,
 				nr_segs, &iocb->ki_pos, ioflags);
 }
 
 STATIC ssize_t
-xfs_file_aio_read(
-	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	unsigned long		nr_segs,
-	loff_t			pos)
-{
-	return __xfs_file_read(iocb, iov, nr_segs, IO_ISAIO, pos);
-}
-
-STATIC ssize_t
-xfs_file_aio_read_invis(
-	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	unsigned long		nr_segs,
-	loff_t			pos)
-{
-	return __xfs_file_read(iocb, iov, nr_segs, IO_ISAIO|IO_INVIS, pos);
-}
-
-STATIC_INLINE ssize_t
-__xfs_file_write(
+xfs_file_aio_write(
 	struct kiocb		*iocb,
 	const struct iovec	*iov,
 	unsigned long		nr_segs,
-	int			ioflags,
 	loff_t			pos)
 {
-	struct file	*file = iocb->ki_filp;
+	struct file		*file = iocb->ki_filp;
+	int			ioflags = IO_ISAIO;
 
 	BUG_ON(iocb->ki_pos != pos);
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= IO_ISDIRECT;
+	if (file->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
 	return xfs_write(XFS_I(file->f_mapping->host), iocb, iov, nr_segs,
 				&iocb->ki_pos, ioflags);
 }
 
 STATIC ssize_t
-xfs_file_aio_write(
-	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	unsigned long		nr_segs,
-	loff_t			pos)
-{
-	return __xfs_file_write(iocb, iov, nr_segs, IO_ISAIO, pos);
-}
-
-STATIC ssize_t
-xfs_file_aio_write_invis(
-	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	unsigned long		nr_segs,
-	loff_t			pos)
-{
-	return __xfs_file_write(iocb, iov, nr_segs, IO_ISAIO|IO_INVIS, pos);
-}
-
-STATIC ssize_t
 xfs_file_splice_read(
 	struct file		*infilp,
 	loff_t			*ppos,
@@ -127,20 +91,13 @@ xfs_file_splice_read(
 	size_t			len,
 	unsigned int		flags)
 {
-	return xfs_splice_read(XFS_I(infilp->f_path.dentry->d_inode),
-				   infilp, ppos, pipe, len, flags, 0);
-}
+	int			ioflags = 0;
+
+	if (infilp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
 
-STATIC ssize_t
-xfs_file_splice_read_invis(
-	struct file		*infilp,
-	loff_t			*ppos,
-	struct pipe_inode_info	*pipe,
-	size_t			len,
-	unsigned int		flags)
-{
 	return xfs_splice_read(XFS_I(infilp->f_path.dentry->d_inode),
-				   infilp, ppos, pipe, len, flags, IO_INVIS);
+				   infilp, ppos, pipe, len, flags, ioflags);
 }
 
 STATIC ssize_t
@@ -151,20 +108,13 @@ xfs_file_splice_write(
 	size_t			len,
 	unsigned int		flags)
 {
-	return xfs_splice_write(XFS_I(outfilp->f_path.dentry->d_inode),
-				    pipe, outfilp, ppos, len, flags, 0);
-}
+	int			ioflags = 0;
+
+	if (outfilp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
 
-STATIC ssize_t
-xfs_file_splice_write_invis(
-	struct pipe_inode_info	*pipe,
-	struct file		*outfilp,
-	loff_t			*ppos,
-	size_t			len,
-	unsigned int		flags)
-{
 	return xfs_splice_write(XFS_I(outfilp->f_path.dentry->d_inode),
-				    pipe, outfilp, ppos, len, flags, IO_INVIS);
+				    pipe, outfilp, ppos, len, flags, ioflags);
 }
 
 STATIC int
@@ -275,42 +225,6 @@ xfs_file_mmap(
 	return 0;
 }
 
-STATIC long
-xfs_file_ioctl(
-	struct file	*filp,
-	unsigned int	cmd,
-	unsigned long	p)
-{
-	struct inode	*inode = filp->f_path.dentry->d_inode;
-
-
-	/* NOTE:  some of the ioctl's return positive #'s as a
-	 *	  byte count indicating success, such as
-	 *	  readlink_by_handle.  So we don't "sign flip"
-	 *	  like most other routines.  This means true
-	 *	  errors need to be returned as a negative value.
-	 */
-	return xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
-}
-
-STATIC long
-xfs_file_ioctl_invis(
-	struct file	*filp,
-	unsigned int	cmd,
-	unsigned long	p)
-{
-	struct inode	*inode = filp->f_path.dentry->d_inode;
-
-
-	/* NOTE:  some of the ioctl's return positive #'s as a
-	 *	  byte count indicating success, such as
-	 *	  readlink_by_handle.  So we don't "sign flip"
-	 *	  like most other routines.  This means true
-	 *	  errors need to be returned as a negative value.
-	 */
-	return xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
-}
-
 /*
  * mmap()d file has taken write protection fault and is being made
  * writable. We can set the page state up correctly for a writable
@@ -346,25 +260,6 @@ const struct file_operations xfs_file_op
 #endif
 };
 
-const struct file_operations xfs_invis_file_operations = {
-	.llseek		= generic_file_llseek,
-	.read		= do_sync_read,
-	.write		= do_sync_write,
-	.aio_read	= xfs_file_aio_read_invis,
-	.aio_write	= xfs_file_aio_write_invis,
-	.splice_read	= xfs_file_splice_read_invis,
-	.splice_write	= xfs_file_splice_write_invis,
-	.unlocked_ioctl	= xfs_file_ioctl_invis,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= xfs_file_compat_invis_ioctl,
-#endif
-	.mmap		= xfs_file_mmap,
-	.open		= xfs_file_open,
-	.release	= xfs_file_release,
-	.fsync		= xfs_file_fsync,
-};
-
-
 const struct file_operations xfs_dir_file_operations = {
 	.open		= xfs_dir_open,
 	.read		= generic_read_dir,
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-12-03 18:30:14.000000000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-12-03 18:30:34.000000000 +0100
@@ -319,10 +319,11 @@ xfs_open_by_handle(
 		put_unused_fd(new_fd);
 		return -XFS_ERROR(-PTR_ERR(filp));
 	}
+
 	if (inode->i_mode & S_IFREG) {
 		/* invisible operation should not change atime */
 		filp->f_flags |= O_NOATIME;
-		filp->f_op = &xfs_invis_file_operations;
+		filp->f_mode |= FMODE_NOCMTIME;
 	}
 
 	fd_install(new_fd, filp);
@@ -1328,21 +1329,31 @@ xfs_ioc_getbmapx(
 	return 0;
 }
 
-int
-xfs_ioctl(
-	xfs_inode_t		*ip,
+/*
+ * Note: some of the ioctl's return positive numbers as a
+ * byte count indicating success, such as readlink_by_handle.
+ * So we don't "sign flip" like most other routines.  This means
+ * true errors need to be returned as a negative value.
+ */
+long
+xfs_file_ioctl(
 	struct file		*filp,
-	int			ioflags,
 	unsigned int		cmd,
-	void			__user *arg)
+	unsigned long		p)
 {
 	struct inode		*inode = filp->f_path.dentry->d_inode;
-	xfs_mount_t		*mp = ip->i_mount;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	void			__user *arg = (void __user *)p;
+	int			ioflags = 0;
 	int			error;
 
-	xfs_itrace_entry(XFS_I(inode));
-	switch (cmd) {
+	if (filp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
 
+	xfs_itrace_entry(ip);
+
+	switch (cmd) {
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
 	case XFS_IOC_RESVSP:
Index: xfs/fs/xfs/linux-2.6/xfs_iops.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.h	2008-12-03 18:30:14.000000000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_iops.h	2008-12-03 18:30:34.000000000 +0100
@@ -22,7 +22,6 @@ struct xfs_inode;
 
 extern const struct file_operations xfs_file_operations;
 extern const struct file_operations xfs_dir_file_operations;
-extern const struct file_operations xfs_invis_file_operations;
 
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
Index: xfs/include/linux/fs.h
===================================================================
--- xfs.orig/include/linux/fs.h	2008-12-03 18:30:14.000000000 +0100
+++ xfs/include/linux/fs.h	2008-12-03 18:31:58.000000000 +0100
@@ -81,6 +81,14 @@ extern int dir_notify_enable;
 #define FMODE_WRITE_IOCTL	((__force fmode_t)128)
 #define FMODE_NDELAY_NOW	((__force fmode_t)256)
 
+/*
+ * Don't update ctime and mtime.
+ *
+ * Currently a special hack for the XFS open_by_handle ioctl, but we'll
+ * hopefully graduate it to a proper O_CMTIME flag supported by open(2) soon.
+ */
+#define FMODE_NOCMTIME		((__force fmode_t)2048)
+
 #define RW_MASK		1
 #define RWA_MASK	2
 #define READ 0
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-03 18:30:14.000000000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-03 18:30:34.000000000 +0100
@@ -68,13 +68,13 @@ xfs_attrmulti_attr_remove(
 	__uint32_t		flags);
 
 extern long
-xfs_file_compat_ioctl(
-	struct file		*file,
+xfs_file_ioctl(
+	struct file		*filp,
 	unsigned int		cmd,
-	unsigned long		arg);
+	unsigned long		p);
 
 extern long
-xfs_file_compat_ioctl_invis(
+xfs_file_compat_ioctl(
 	struct file		*file,
 	unsigned int		cmd,
 	unsigned long		arg);
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2008-12-03 18:30:14.000000000 +0100
+++ xfs/fs/xfs/xfs_vnodeops.h	2008-12-03 18:30:34.000000000 +0100
@@ -53,8 +53,6 @@ int xfs_attr_set(struct xfs_inode *dp, c
 int xfs_attr_remove(struct xfs_inode *dp, const char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		int flags, struct attrlist_cursor_kern *cursor);
-int xfs_ioctl(struct xfs_inode *ip, struct file *filp,
-		int ioflags, unsigned int cmd, void __user *arg);
 ssize_t xfs_read(struct xfs_inode *ip, struct kiocb *iocb,
 		const struct iovec *iovp, unsigned int segs,
 		loff_t *offset, int ioflags);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
