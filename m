Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C5B180D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:03:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1DCA9AC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:51 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 7fs9OnDtchAywOJ6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:48 -0800 (PST)
Subject: [PATCH 66/76] xfs: emulate the btrfs dedupe extent same ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:03:45 -0800
Message-ID: <20151219090345.12713.53530.stgit@birch.djwong.org>
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

Emulate the BTRFS_IOC_EXTENT_SAME ioctl.  This operation is similar
to clone_range, but the kernel must confirm that the contents of the
two extents are identical before performing the reflink.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   30 ++++++++++++
 fs/xfs/xfs_file.c      |   11 +++-
 fs/xfs/xfs_ioctl.c     |  124 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_ioctl32.c   |    1 
 fs/xfs/xfs_reflink.c   |  120 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h   |    6 ++
 6 files changed, 282 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a3cd93e..5c66459 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -580,8 +580,38 @@ struct xfs_clone_args {
 	__u64 dest_offset;
 };
 
+/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
+#define XFS_EXTENT_DATA_SAME	0
+#define XFS_EXTENT_DATA_DIFFERS	1
+
+/* from struct btrfs_ioctl_file_extent_same_info */
+struct xfs_extent_data_info {
+	__s64 fd;		/* in - destination file */
+	__u64 logical_offset;	/* in - start of extent in destination */
+	__u64 bytes_deduped;	/* out - total # of bytes we were able
+				 * to dedupe from this file */
+	/* status of this dedupe operation:
+	 * < 0 for error
+	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
+	 * == XFS_EXTENT_DATA_DIFFERS if data differs
+	 */
+	__s32 status;		/* out - see above description */
+	__u32 reserved;
+};
+
+/* from struct btrfs_ioctl_file_extent_same_args */
+struct xfs_extent_data {
+	__u64 logical_offset;	/* in - start of extent in source */
+	__u64 length;		/* in - length of extent */
+	__u16 dest_count;	/* in - total elements in info array */
+	__u16 reserved1;
+	__u32 reserved2;
+	struct xfs_extent_data_info info[0];
+};
+
 #define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
 #define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
+#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
 
 #ifndef HAVE_BBMACROS
 /*
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 44d89ea..afca713 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1083,7 +1083,8 @@ xfs_file_share_range(
 	loff_t		pos_in,
 	struct file	*file_out,
 	loff_t		pos_out,
-	u64		len)
+	u64		len,
+	bool		is_dedupe)
 {
 	struct inode	*inode_in;
 	struct inode	*inode_out;
@@ -1092,6 +1093,7 @@ xfs_file_share_range(
 	loff_t		isize;
 	int		same_inode;
 	loff_t		blen;
+	unsigned int	flags = 0;
 
 	inode_in = file_inode(file_in);
 	inode_out = file_inode(file_out);
@@ -1153,13 +1155,16 @@ xfs_file_share_range(
 	if (ret)
 		goto out_unlock;
 
+	if (is_dedupe)
+		flags |= XFS_REFLINK_DEDUPE;
 	ret = xfs_reflink_remap_range(XFS_I(inode_in), pos_in, XFS_I(inode_out),
-			pos_out, len);
+			pos_out, len, flags);
 	if (ret < 0)
 		goto out_unlock;
 
 	/* Truncate the page cache so we don't see stale data */
-	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+	if (!is_dedupe)
+		truncate_inode_pages_range(&inode_out->i_data, pos_out,
 				   PAGE_CACHE_ALIGN(pos_out + len) - 1);
 
 out_unlock:
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1d836dc..07c4eb6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1516,7 +1516,8 @@ xfs_ioc_swapext(
 }
 
 extern int xfs_file_share_range(struct file *file_in, loff_t pos_in,
-		struct file *file_out, loff_t pos_out, size_t len);
+		struct file *file_out, loff_t pos_out, size_t len,
+		bool is_dedupe);
 
 /*
  * For reflink, validate the VFS parameters, convert them into the XFS
@@ -1528,7 +1529,8 @@ xfs_ioctl_reflink(
 	loff_t		pos_in,
 	struct file	*file_out,
 	loff_t		pos_out,
-	size_t		len)
+	size_t		len,
+	bool		is_dedupe)
 {
 	int		error;
 
@@ -1542,7 +1544,8 @@ xfs_ioctl_reflink(
 	if (error)
 		return error;
 
-	error = xfs_file_share_range(file_in, pos_in, file_out, pos_out, len);
+	error = xfs_file_share_range(file_in, pos_in, file_out, pos_out, len,
+			is_dedupe);
 	if (error)
 		goto out_drop;
 
@@ -1558,6 +1561,113 @@ out_drop:
 	return error;
 }
 
+#define XFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
+
+static long
+xfs_ioctl_file_extent_same(
+	struct file			*file,
+	struct xfs_extent_data __user	*argp)
+{
+	struct xfs_extent_data		*same = NULL;
+	struct xfs_extent_data_info	*info;
+	struct inode			*src;
+	u64				off;
+	u64				len;
+	int				i;
+	int				ret;
+	unsigned long			size;
+	bool				is_admin;
+	u16				count;
+
+	is_admin = capable(CAP_SYS_ADMIN);
+	src = file_inode(file);
+	if (!(file->f_mode & FMODE_READ))
+		return -EINVAL;
+
+	if (get_user(count, &argp->dest_count)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	size = offsetof(struct xfs_extent_data __user,
+			info[count]);
+
+	same = memdup_user(argp, size);
+
+	if (IS_ERR(same)) {
+		ret = PTR_ERR(same);
+		goto out;
+	}
+
+	off = same->logical_offset;
+	len = same->length;
+
+	/*
+	 * Limit the total length we will dedupe for each operation.
+	 * This is intended to bound the total time spent in this
+	 * ioctl to something sane.
+	 */
+	if (len > XFS_MAX_DEDUPE_LEN)
+		len = XFS_MAX_DEDUPE_LEN;
+
+	ret = -EISDIR;
+	if (S_ISDIR(src->i_mode))
+		goto out;
+
+	ret = -EACCES;
+	if (!S_ISREG(src->i_mode))
+		goto out;
+
+	/* pre-format output fields to sane values */
+	for (i = 0; i < count; i++) {
+		same->info[i].bytes_deduped = 0ULL;
+		same->info[i].status = 0;
+	}
+
+	for (i = 0, info = same->info; i < count; i++, info++) {
+		struct inode *dst;
+		struct fd dst_file = fdget(info->fd);
+
+		if (!dst_file.file) {
+			info->status = -EBADF;
+			continue;
+		}
+		dst = file_inode(dst_file.file);
+
+		trace_xfs_ioctl_file_extent_same(file_inode(file), off, len,
+				dst, info->logical_offset);
+
+		info->bytes_deduped = 0;
+		if (!(is_admin || (dst_file.file->f_mode & FMODE_WRITE))) {
+			info->status = -EINVAL;
+		} else if (file->f_path.mnt != dst_file.file->f_path.mnt) {
+			info->status = -EXDEV;
+		} else if (S_ISDIR(dst->i_mode)) {
+			info->status = -EISDIR;
+		} else if (!S_ISREG(dst->i_mode)) {
+			info->status = -EOPNOTSUPP;
+		} else {
+			ret = xfs_ioctl_reflink(file, off, dst_file.file,
+					info->logical_offset, len, true);
+			if (ret == -EBADE)
+				info->status = XFS_EXTENT_DATA_DIFFERS;
+			else if (ret == 0)
+				info->bytes_deduped = len;
+			else
+				info->status = ret;
+		}
+		fdput(dst_file);
+	}
+
+	ret = copy_to_user(argp, same, size);
+	if (ret)
+		ret = -EFAULT;
+
+out:
+	kfree(same);
+	return ret;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1865,7 +1975,7 @@ xfs_file_ioctl(
 
 		trace_xfs_ioctl_clone(file_inode(src.file), file_inode(filp));
 
-		error = xfs_ioctl_reflink(src.file, 0, filp, 0, ~0ULL);
+		error = xfs_ioctl_reflink(src.file, 0, filp, 0, ~0ULL, false);
 		fdput(src);
 		if (error > 0)
 			error = 0;
@@ -1890,7 +2000,8 @@ xfs_file_ioctl(
 				file_inode(filp), args.dest_offset);
 
 		error = xfs_ioctl_reflink(src.file, args.src_offset, filp,
-					  args.dest_offset, args.src_length);
+					  args.dest_offset, args.src_length,
+					  false);
 		fdput(src);
 		if (error > 0)
 			error = 0;
@@ -1898,6 +2009,9 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case XFS_IOC_FILE_EXTENT_SAME:
+		return xfs_ioctl_file_extent_same(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index dde2c7b..80b7b3c 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -560,6 +560,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_ERROR_CLEARALL:
 	case XFS_IOC_CLONE:
 	case XFS_IOC_CLONE_RANGE:
+	case XFS_IOC_FILE_EXTENT_SAME:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3de3c9a..c686583 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1100,6 +1100,103 @@ err:
 	return error;
 }
 
+/*
+ * Read a page's worth of file data into the page cache.
+ */
+STATIC struct page *
+xfs_get_page(
+	struct inode	*inode,		/* inode */
+	xfs_off_t	offset)		/* where in the inode to read */
+{
+	struct address_space	*mapping;
+	struct page		*page;
+	pgoff_t			n;
+
+	n = offset >> PAGE_CACHE_SHIFT;
+	mapping = inode->i_mapping;
+	page = read_mapping_page(mapping, n, NULL);
+	if (IS_ERR(page))
+		return page;
+	if (!PageUptodate(page)) {
+		page_cache_release(page);
+		return NULL;
+	}
+	return page;
+}
+
+/*
+ * Compare extents of two files to see if they are the same.
+ */
+STATIC int
+xfs_compare_extents(
+	struct inode	*src,		/* first inode */
+	xfs_off_t	srcoff,		/* offset of first inode */
+	struct inode	*dest,		/* second inode */
+	xfs_off_t	destoff,	/* offset of second inode */
+	xfs_off_t	len,		/* length of data to compare */
+	bool		*is_same)	/* out: true if the contents match */
+{
+	xfs_off_t	src_poff;
+	xfs_off_t	dest_poff;
+	void		*src_addr;
+	void		*dest_addr;
+	struct page	*src_page;
+	struct page	*dest_page;
+	xfs_off_t	cmp_len;
+	bool		same;
+	int		error;
+
+	error = -EINVAL;
+	same = true;
+	while (len) {
+		src_poff = srcoff & (PAGE_CACHE_SIZE - 1);
+		dest_poff = destoff & (PAGE_CACHE_SIZE - 1);
+		cmp_len = min(PAGE_CACHE_SIZE - src_poff,
+			      PAGE_CACHE_SIZE - dest_poff);
+		cmp_len = min(cmp_len, len);
+		ASSERT(cmp_len > 0);
+
+		trace_xfs_reflink_compare_extents(XFS_I(src), srcoff, cmp_len,
+				XFS_I(dest), destoff);
+
+		src_page = xfs_get_page(src, srcoff);
+		if (!src_page)
+			goto out_error;
+		dest_page = xfs_get_page(dest, destoff);
+		if (!dest_page) {
+			page_cache_release(src_page);
+			goto out_error;
+		}
+		src_addr = kmap_atomic(src_page);
+		dest_addr = kmap_atomic(dest_page);
+
+		flush_dcache_page(src_page);
+		flush_dcache_page(dest_page);
+
+		if (memcmp(src_addr + src_poff, dest_addr + dest_poff, cmp_len))
+			same = false;
+
+		kunmap_atomic(src_addr);
+		kunmap_atomic(dest_addr);
+		page_cache_release(src_page);
+		page_cache_release(dest_page);
+
+		if (!same)
+			break;
+
+		srcoff += cmp_len;
+		destoff += cmp_len;
+		len -= cmp_len;
+	}
+
+	*is_same = same;
+	return 0;
+
+out_error:
+	trace_xfs_reflink_compare_extents_error(XFS_I(dest), error, _RET_IP_);
+	return error;
+}
+
 /**
  * xfs_reflink_remap_range() -- Link a range of blocks from one file to another.
  *
@@ -1108,6 +1205,7 @@ err:
  * @dest: Inode to clone to
  * @destoff: Offset within @inode to start clone
  * @len: Original length, passed by user, of range to clone
+ * @flags: Flags to modify reflink's behavior
  */
 int
 xfs_reflink_remap_range(
@@ -1115,12 +1213,14 @@ xfs_reflink_remap_range(
 	xfs_off_t		srcoff,
 	struct xfs_inode	*dest,
 	xfs_off_t		destoff,
-	xfs_off_t		len)
+	xfs_off_t		len,
+	unsigned int		flags)
 {
 	struct xfs_mount	*mp = src->i_mount;
 	xfs_fileoff_t		sfsbno, dfsbno;
 	xfs_filblks_t		fsblen;
 	int			error;
+	bool			is_same;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return -EOPNOTSUPP;
@@ -1132,6 +1232,9 @@ xfs_reflink_remap_range(
 	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
 		return -EINVAL;
 
+	if (flags & ~XFS_REFLINK_ALL)
+		return -EINVAL;
+
 	trace_xfs_reflink_remap_range(src, srcoff, len, dest, destoff);
 
 	/* Lock both files against IO */
@@ -1143,6 +1246,21 @@ xfs_reflink_remap_range(
 		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
 	}
 
+	/*
+	 * Check that the extents are the same.
+	 */
+	if (flags & XFS_REFLINK_DEDUPE) {
+		is_same = false;
+		error = xfs_compare_extents(VFS_I(src), srcoff, VFS_I(dest),
+				destoff, len, &is_same);
+		if (error)
+			goto out_error;
+		if (!is_same) {
+			error = -EBADE;
+			goto out_error;
+		}
+	}
+
 	error = xfs_reflink_set_inode_flag(src, dest);
 	if (error)
 		goto out_error;
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index df33044..42eb860 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -37,7 +37,11 @@ extern int xfs_reflink_cancel_pending_cow(struct xfs_inode *ip);
 int	xfs_map_cow_blocks(struct inode *inode, xfs_off_t offset,
 			   struct xfs_bmbt_irec	*imap);
 
+#define XFS_REFLINK_DEDUPE	1	/* only reflink if contents match */
+#define XFS_REFLINK_ALL		(XFS_REFLINK_DEDUPE)
+
 extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
-		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len);
+		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len,
+		unsigned int flags);
 
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
