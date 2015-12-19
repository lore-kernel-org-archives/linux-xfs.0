Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5654E80D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C99DEAC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:38 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7HrI5Y1iGeCKjV5Z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:36 -0800 (PST)
Subject: [PATCH 73/76] xfs: use new vfs reflink and dedup function pointers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:29 -0800
Message-ID: <20151219090429.12713.55302.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Use the new VFS function pointers for copy_file_range and dedupe_data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c  |   61 ++++++++++++++++
 fs/xfs/xfs_ioctl.c |  199 ----------------------------------------------------
 2 files changed, 60 insertions(+), 200 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e6bc6ab..0d96a37 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1081,7 +1081,7 @@ xfs_file_wait_for_io(
 }
 
 /* Hook up to the VFS reflink function */
-int
+STATIC int
 xfs_file_share_range(
 	struct file	*file_in,
 	loff_t		pos_in,
@@ -1175,6 +1175,62 @@ out_unlock:
 	return ret;
 }
 
+STATIC ssize_t
+xfs_file_copy_range(
+	struct file	*file_in,
+	loff_t		pos_in,
+	struct file	*file_out,
+	loff_t		pos_out,
+	size_t		len,
+	unsigned int	flags)
+{
+	int		error;
+
+	error = xfs_file_share_range(file_in, pos_in, file_out, pos_out,
+				     len, false);
+	if (error)
+		return error;
+	return len;
+}
+
+STATIC int
+xfs_file_clone_range(
+	struct file	*file_in,
+	loff_t		pos_in,
+	struct file	*file_out,
+	loff_t		pos_out,
+	u64		len)
+{
+	return xfs_file_share_range(file_in, pos_in, file_out, pos_out,
+				     len, false);
+}
+
+#define XFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
+STATIC ssize_t
+xfs_file_dedupe_range(
+	struct file	*src_file,
+	u64		loff,
+	u64		len,
+	struct file	*dst_file,
+	u64		dst_loff)
+{
+	int		error;
+
+	/*
+	 * Limit the total length we will dedupe for each operation.
+	 * This is intended to bound the total time spent in this
+	 * ioctl to something sane.
+	 */
+	if (len > XFS_MAX_DEDUPE_LEN)
+		len = XFS_MAX_DEDUPE_LEN;
+
+	error = xfs_file_share_range(src_file, loff, dst_file, dst_loff,
+				     len, true);
+	if (error)
+		return error;
+	return len;
+}
+
 STATIC int
 xfs_file_open(
 	struct inode	*inode,
@@ -1811,6 +1867,9 @@ const struct file_operations xfs_file_operations = {
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
 	.fallocate	= xfs_file_fallocate,
+	.copy_file_range = xfs_file_copy_range,
+	.clone_file_range = xfs_file_clone_range,
+	.dedupe_file_range = xfs_file_dedupe_range,
 };
 
 const struct file_operations xfs_dir_file_operations = {
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 29dc36c..7562f14 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1536,159 +1536,6 @@ xfs_ioc_swapext(
 	return error;
 }
 
-extern int xfs_file_share_range(struct file *file_in, loff_t pos_in,
-		struct file *file_out, loff_t pos_out, size_t len,
-		bool is_dedupe);
-
-/*
- * For reflink, validate the VFS parameters, convert them into the XFS
- * equivalents, and then call the internal reflink function.
- */
-STATIC int
-xfs_ioctl_reflink(
-	struct file	*file_in,
-	loff_t		pos_in,
-	struct file	*file_out,
-	loff_t		pos_out,
-	size_t		len,
-	bool		is_dedupe)
-{
-	int		error;
-
-	/* Do we have the correct permissions? */
-	if (!(file_in->f_mode & FMODE_READ) ||
-	    !(file_out->f_mode & FMODE_WRITE) ||
-	    (file_out->f_flags & O_APPEND))
-		return -EBADF;
-
-	error = mnt_want_write_file(file_out);
-	if (error)
-		return error;
-
-	error = xfs_file_share_range(file_in, pos_in, file_out, pos_out, len,
-			is_dedupe);
-	if (error)
-		goto out_drop;
-
-	fsnotify_access(file_in);
-	add_rchar(current, len);
-	fsnotify_modify(file_out);
-	add_wchar(current, len);
-	inc_syscr(current);
-	inc_syscw(current);
-
-out_drop:
-	mnt_drop_write_file(file_out);
-	return error;
-}
-
-#define XFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
-
-static long
-xfs_ioctl_file_extent_same(
-	struct file			*file,
-	struct xfs_extent_data __user	*argp)
-{
-	struct xfs_extent_data		*same = NULL;
-	struct xfs_extent_data_info	*info;
-	struct inode			*src;
-	u64				off;
-	u64				len;
-	int				i;
-	int				ret;
-	unsigned long			size;
-	bool				is_admin;
-	u16				count;
-
-	is_admin = capable(CAP_SYS_ADMIN);
-	src = file_inode(file);
-	if (!(file->f_mode & FMODE_READ))
-		return -EINVAL;
-
-	if (get_user(count, &argp->dest_count)) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	size = offsetof(struct xfs_extent_data __user,
-			info[count]);
-
-	same = memdup_user(argp, size);
-
-	if (IS_ERR(same)) {
-		ret = PTR_ERR(same);
-		goto out;
-	}
-
-	off = same->logical_offset;
-	len = same->length;
-
-	/*
-	 * Limit the total length we will dedupe for each operation.
-	 * This is intended to bound the total time spent in this
-	 * ioctl to something sane.
-	 */
-	if (len > XFS_MAX_DEDUPE_LEN)
-		len = XFS_MAX_DEDUPE_LEN;
-
-	ret = -EISDIR;
-	if (S_ISDIR(src->i_mode))
-		goto out;
-
-	ret = -EACCES;
-	if (!S_ISREG(src->i_mode))
-		goto out;
-
-	/* pre-format output fields to sane values */
-	for (i = 0; i < count; i++) {
-		same->info[i].bytes_deduped = 0ULL;
-		same->info[i].status = 0;
-	}
-
-	for (i = 0, info = same->info; i < count; i++, info++) {
-		struct inode *dst;
-		struct fd dst_file = fdget(info->fd);
-
-		if (!dst_file.file) {
-			info->status = -EBADF;
-			continue;
-		}
-		dst = file_inode(dst_file.file);
-
-		trace_xfs_ioctl_file_extent_same(file_inode(file), off, len,
-				dst, info->logical_offset);
-
-		info->bytes_deduped = 0;
-		if (!(is_admin || (dst_file.file->f_mode & FMODE_WRITE))) {
-			info->status = -EINVAL;
-		} else if (file->f_path.mnt != dst_file.file->f_path.mnt) {
-			info->status = -EXDEV;
-		} else if (S_ISDIR(dst->i_mode)) {
-			info->status = -EISDIR;
-		} else if (!S_ISREG(dst->i_mode)) {
-			info->status = -EOPNOTSUPP;
-		} else {
-			ret = xfs_ioctl_reflink(file, off, dst_file.file,
-					info->logical_offset, len, true);
-			if (ret == -EBADE)
-				info->status = XFS_EXTENT_DATA_DIFFERS;
-			else if (ret == 0)
-				info->bytes_deduped = len;
-			else
-				info->status = ret;
-		}
-		fdput(dst_file);
-	}
-
-	ret = copy_to_user(argp, same, size);
-	if (ret)
-		ret = -EFAULT;
-
-out:
-	kfree(same);
-	return ret;
-}
-
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1987,52 +1834,6 @@ xfs_file_ioctl(
 		return xfs_icache_free_eofblocks(mp, &keofb);
 	}
 
-	case XFS_IOC_CLONE: {
-		struct fd src;
-
-		src = fdget(p);
-		if (!src.file)
-			return -EBADF;
-
-		trace_xfs_ioctl_clone(file_inode(src.file), file_inode(filp));
-
-		error = xfs_ioctl_reflink(src.file, 0, filp, 0, ~0ULL, false);
-		fdput(src);
-		if (error > 0)
-			error = 0;
-
-		return error;
-	}
-
-	case XFS_IOC_CLONE_RANGE: {
-		struct fd src;
-		struct xfs_clone_args args;
-
-		if (copy_from_user(&args, arg, sizeof(args)))
-			return -EFAULT;
-		src = fdget(args.src_fd);
-		if (!src.file)
-			return -EBADF;
-		if (args.src_length == 0)
-			args.src_length = ~0ULL;
-
-		trace_xfs_ioctl_clone_range(file_inode(src.file),
-				args.src_offset, args.src_length,
-				file_inode(filp), args.dest_offset);
-
-		error = xfs_ioctl_reflink(src.file, args.src_offset, filp,
-					  args.dest_offset, args.src_length,
-					  false);
-		fdput(src);
-		if (error > 0)
-			error = 0;
-
-		return error;
-	}
-
-	case XFS_IOC_FILE_EXTENT_SAME:
-		return xfs_ioctl_file_extent_same(filp, arg);
-
 	default:
 		return -ENOTTY;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
