Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C72027FA5
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:40:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7F26304039
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:40:28 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7i5Ou0lvRBVwoVGO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:40:26 -0700 (PDT)
Subject: [PATCH 11/14] xfs: emulate the btrfs dedupe extent same ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:40:23 -0700
Message-ID: <20150625234023.4992.3483.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
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
 fs/xfs/libxfs/xfs_fs.h |   28 +++++++++++
 fs/xfs/xfs_ioctl.c     |  121 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_ioctl32.c   |    1 
 fs/xfs/xfs_reflink.c   |  109 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h   |    6 ++
 5 files changed, 258 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 92f21e1..7f4d886 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -560,7 +560,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
-/* reflink ioctls; these should match btrfs */
+/* reflink ioctls; these MUST match the btrfs ioctl definitions */
 struct xfs_ioctl_clone_range_args {
 	__s64 src_fd;
 	__u64 src_offset;
@@ -568,8 +568,34 @@ struct xfs_ioctl_clone_range_args {
 	__u64 dest_offset;
 };
 
+#define XFS_SAME_DATA_DIFFERS	1
+/* For extent-same ioctl */
+struct xfs_ioctl_file_extent_same_info {
+	__s64 fd;		/* in - destination file */
+	__u64 logical_offset;	/* in - start of extent in destination */
+	__u64 bytes_deduped;	/* out - total # of bytes we were able
+				 * to dedupe from this file */
+	/* status of this dedupe operation:
+	 * 0 if dedup succeeds
+	 * < 0 for error
+	 * == XFS_SAME_DATA_DIFFERS if data differs
+	 */
+	__s32 status;		/* out - see above description */
+	__u32 reserved;
+};
+
+struct xfs_ioctl_file_extent_same_args {
+	__u64 logical_offset;	/* in - start of extent in source */
+	__u64 length;		/* in - length of extent */
+	__u16 dest_count;	/* in - total elements in info array */
+	__u16 reserved1;
+	__u32 reserved2;
+	struct xfs_ioctl_file_extent_same_info info[0];
+};
+
 #define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
 #define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_ioctl_clone_range_args)
+#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_ioctl_file_extent_same_args)
 
 #ifndef HAVE_BBMACROS
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c590786..da4d7b7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1534,7 +1534,8 @@ xfs_ioctl_reflink(
 	loff_t		pos_in,
 	struct file	*file_out,
 	loff_t		pos_out,
-	size_t		len)
+	size_t		len,
+	bool		is_dedupe)
 {
 	struct inode	*inode_in;
 	struct inode	*inode_out;
@@ -1543,6 +1544,7 @@ xfs_ioctl_reflink(
 	loff_t		isize;
 	int		same_inode;
 	loff_t		blen;
+	unsigned int	flags;
 
 	if (len == 0)
 		return 0;
@@ -1622,7 +1624,12 @@ xfs_ioctl_reflink(
 	if (ret)
 		goto out_unlock;
 
-	ret = xfs_reflink(XFS_I(inode_in), pos_in, XFS_I(inode_out), pos_out, len);
+	flags = 0;
+	if (is_dedupe)
+		flags |= XFS_REFLINK_DEDUPE;
+
+	ret = xfs_reflink(XFS_I(inode_in), pos_in, XFS_I(inode_out), pos_out,
+			len, flags);
 	if (ret < 0)
 		goto out_unlock;
 
@@ -1644,6 +1651,108 @@ out_unlock:
 	return ret;
 }
 
+#define XFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
+
+static long
+xfs_ioctl_file_extent_same(
+	struct file					*file,
+	struct xfs_ioctl_file_extent_same_args __user	*argp)
+{
+	struct xfs_ioctl_file_extent_same_args	*same;
+	struct xfs_ioctl_file_extent_same_info	*info;
+	struct inode 				*src;
+	u64					off;
+	u64					len;
+	int					i;
+	int					ret;
+	unsigned long				size;
+	bool					is_admin;
+	u16					count;
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
+	size = offsetof(struct xfs_ioctl_file_extent_same_args __user,
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
+		if (!dst_file.file) {
+			info->status = -EBADF;
+			continue;
+		}
+		dst = file_inode(dst_file.file);
+
+		info->bytes_deduped = 0;
+		if (!(is_admin || (dst_file.file->f_mode & FMODE_WRITE))) {
+			info->status = -EINVAL;
+		} else if (file->f_path.mnt != dst_file.file->f_path.mnt) {
+			info->status = -EXDEV;
+		} else if (S_ISDIR(dst->i_mode)) {
+			info->status = -EISDIR;
+		} else if (!S_ISREG(dst->i_mode)) {
+			info->status = -EACCES;
+		} else {
+			info->status = xfs_ioctl_reflink(file, off,
+							 dst_file.file,
+							 info->logical_offset,
+							 len, true);
+			if (info->status == -EBADE)
+				info->status = XFS_SAME_DATA_DIFFERS;
+			else if (info->status == 0)
+				info->bytes_deduped = len;
+		}
+		fdput(dst_file);
+	}
+
+	ret = copy_to_user(argp, same, size);
+	if (ret)
+		ret = -EFAULT;
+
+out:
+	return ret;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1949,7 +2058,7 @@ xfs_file_ioctl(
 		if (!src.file)
 			return -EBADF;
 
-		error = xfs_ioctl_reflink(src.file, 0, filp, 0, ~0ULL);
+		error = xfs_ioctl_reflink(src.file, 0, filp, 0, ~0ULL, false);
 		fdput(src);
 		if (error > 0)
 			error = 0;
@@ -1970,7 +2079,8 @@ xfs_file_ioctl(
 			args.src_length = ~0ULL;
 
 		error = xfs_ioctl_reflink(src.file, args.src_offset, filp,
-					  args.dest_offset, args.src_length);
+					  args.dest_offset, args.src_length,
+					  false);
 		fdput(src);
 		if (error > 0)
 			error = 0;
@@ -1978,6 +2088,9 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case XFS_IOC_FILE_EXTENT_SAME:
+		return xfs_ioctl_file_extent_same(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 76d8729..575c292 100644
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
index 4f027d3..325dd14 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -71,6 +71,94 @@
 				(len) <= (mp)->m_sb.sb_agblocks, label); \
 	} while(0);
 
+/*
+ * Read a page's worth of file data into the page cache.
+ */
+static struct page *
+xfs_get_page(
+	struct inode	*inode,		/* inode */
+	xfs_off_t 	offset)		/* where in the inode to read */
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
+static int
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
+
+	same = true;
+	while (len) {
+		src_poff = srcoff & (PAGE_CACHE_SIZE - 1);
+		dest_poff = destoff & (PAGE_CACHE_SIZE - 1);
+		cmp_len = min(PAGE_CACHE_SIZE - src_poff,
+			      PAGE_CACHE_SIZE - dest_poff);
+		cmp_len = min(cmp_len, len);
+		ASSERT(cmp_len > 0);
+
+		src_page = xfs_get_page(src, srcoff);
+		if (!src_page)
+			return -EINVAL;
+		dest_page = xfs_get_page(dest, destoff);
+		if (!dest_page) {
+			page_cache_release(src_page);
+			return -EINVAL;
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
+}
+
 /**
  * xfs_reflink() - link a range of blocks from one inode to another
  *
@@ -86,7 +174,8 @@ xfs_reflink(
 	xfs_off_t		srcoff, /* offset in source file */
 	struct xfs_inode	*dest,	/* XFS inode to copy extents to */
 	xfs_off_t		destoff,/* offset in destination file */
-	xfs_off_t		len)	/* number of bytes to copy */
+	xfs_off_t		len,	/* number of bytes to copy */
+	unsigned int		flags)	/* reflink flags */
 {
 	struct xfs_mount	*mp = src->i_mount;
 	loff_t			uninitialized_var(offset);
@@ -105,6 +194,7 @@ xfs_reflink(
 	xfs_agnumber_t		agno;		/* allocation group number */
 	xfs_agblock_t		agbno;
 	int			done;
+	bool			is_same;
 	xfs_off_t		blen = ALIGN(len, mp->m_sb.sb_blocksize);
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
@@ -117,6 +207,9 @@ xfs_reflink(
 	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
 		return -EINVAL;
 
+	if (flags & ~XFS_REFLINK_ALL)
+		return -EINVAL;
+
 	/* Lock both files against IO */
 	if (src->i_ino == dest->i_ino) {
 		xfs_ilock(src, XFS_IOLOCK_EXCL);
@@ -127,6 +220,20 @@ xfs_reflink(
 	}
 
 	/*
+	 * Check that the extents are the same.
+	 */
+	if (flags & XFS_REFLINK_DEDUPE) {
+		error = xfs_compare_extents(VFS_I(src), srcoff, VFS_I(dest),
+				destoff, len, &is_same);
+		if (error)
+			goto out_unlock_io;
+		if (!is_same) {
+			error = -EBADE;
+			goto out_unlock_io;
+		}
+	}
+
+	/*
 	 * Ensure the reflink bit is set in both inodes.
 	 */
 	if (!(src->i_d.di_flags & XFS_DIFLAG_REFLINK) ||
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index adfd99c..7f9660d 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -24,8 +24,12 @@ typedef struct xfs_reflink_end_io {
 	struct xfs_efi_log_item	*rlei_efi;
 } xfs_reflink_end_io_t;
 
+#define XFS_REFLINK_DEDUPE	1	/* only reflink if contents match */
+#define XFS_REFLINK_ALL		(XFS_REFLINK_DEDUPE)
+
 extern int xfs_reflink(struct xfs_inode *src, xfs_off_t srcoff,
-	struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len);
+	struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len,
+	unsigned int flags);
 
 extern int xfs_reflink_get_refcount(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t agbno, xfs_extlen_t *len, xfs_nlink_t *nr);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
