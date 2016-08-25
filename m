Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 556AD7E1B
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:37:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28951304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:17 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3NQUpscuI4QuN2z6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:14 -0700 (PDT)
Subject: [PATCH 47/71] xfs: add dedupe range vfs function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:37:05 -0700
Message-ID: <147216822509.867.1023187653596731818.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Define a VFS function which allows userspace to request that the
kernel reflink a range of blocks between two files if the ranges'
contents match.  The function fits the new VFS ioctl that standardizes
the checking for the btrfs EXTENT SAME ioctl.

v2: Plug into the VFS function pointers instead of handling ioctls
directly, and lock the pages so they don't disappear while we're
trying to compare them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   30 +++++++++++
 fs/xfs/xfs_file.c      |   48 +++++++++++++++++-
 fs/xfs/xfs_reflink.c   |  127 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h   |    5 ++
 4 files changed, 204 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 788e006..6230230 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -542,8 +542,38 @@ struct xfs_clone_args {
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
index 5440207..14ec085 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1065,7 +1065,8 @@ xfs_file_share_range(
 	loff_t		pos_in,
 	struct file	*file_out,
 	loff_t		pos_out,
-	u64		len)
+	u64		len,
+	bool		is_dedupe)
 {
 	struct inode	*inode_in;
 	struct inode	*inode_out;
@@ -1074,6 +1075,7 @@ xfs_file_share_range(
 	loff_t		isize;
 	int		same_inode;
 	loff_t		blen;
+	unsigned int	flags = 0;
 
 	inode_in = file_inode(file_in);
 	inode_out = file_inode(file_out);
@@ -1111,6 +1113,15 @@ xfs_file_share_range(
 	    pos_in + len > isize)
 		return -EINVAL;
 
+	/* Don't allow dedupe past EOF in the dest file */
+	if (is_dedupe) {
+		loff_t	disize;
+
+		disize = i_size_read(inode_out);
+		if (pos_out >= disize || pos_out + len > disize)
+			return -EINVAL;
+	}
+
 	/* If we're linking to EOF, continue to the block boundary. */
 	if (pos_in + len == isize)
 		blen = ALIGN(isize, bs) - pos_in;
@@ -1134,8 +1145,10 @@ xfs_file_share_range(
 	if (ret)
 		goto out_unlock;
 
+	if (is_dedupe)
+		flags |= XFS_REFLINK_DEDUPE;
 	ret = xfs_reflink_remap_range(XFS_I(inode_in), pos_in, XFS_I(inode_out),
-			pos_out, len);
+			pos_out, len, flags);
 	if (ret < 0)
 		goto out_unlock;
 
@@ -1155,7 +1168,7 @@ xfs_file_copy_range(
 	int		error;
 
 	error = xfs_file_share_range(file_in, pos_in, file_out, pos_out,
-				     len);
+				     len, false);
 	if (error)
 		return error;
 	return len;
@@ -1170,7 +1183,33 @@ xfs_file_clone_range(
 	u64		len)
 {
 	return xfs_file_share_range(file_in, pos_in, file_out, pos_out,
-				     len);
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
 }
 
 STATIC int
@@ -1834,6 +1873,7 @@ const struct file_operations xfs_file_operations = {
 	.fallocate	= xfs_file_fallocate,
 	.copy_file_range = xfs_file_copy_range,
 	.clone_file_range = xfs_file_clone_range,
+	.dedupe_file_range = xfs_file_dedupe_range,
 };
 
 const struct file_operations xfs_dir_file_operations = {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4d759a5..d7eea9e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1269,6 +1269,111 @@ err:
 }
 
 /*
+ * Read a page's worth of file data into the page cache.  Return the page
+ * locked.
+ */
+static struct page *
+xfs_get_page(
+	struct inode	*inode,
+	xfs_off_t	offset)
+{
+	struct address_space	*mapping;
+	struct page		*page;
+	pgoff_t			n;
+
+	n = offset >> PAGE_SHIFT;
+	mapping = inode->i_mapping;
+	page = read_mapping_page(mapping, n, NULL);
+	if (IS_ERR(page))
+		return page;
+	if (!PageUptodate(page)) {
+		put_page(page);
+		return ERR_PTR(-EIO);
+	}
+	lock_page(page);
+	return page;
+}
+
+/*
+ * Compare extents of two files to see if they are the same.
+ */
+static int
+xfs_compare_extents(
+	struct inode	*src,
+	xfs_off_t	srcoff,
+	struct inode	*dest,
+	xfs_off_t	destoff,
+	xfs_off_t	len,
+	bool		*is_same)
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
+		src_poff = srcoff & (PAGE_SIZE - 1);
+		dest_poff = destoff & (PAGE_SIZE - 1);
+		cmp_len = min(PAGE_SIZE - src_poff,
+			      PAGE_SIZE - dest_poff);
+		cmp_len = min(cmp_len, len);
+		ASSERT(cmp_len > 0);
+
+		trace_xfs_reflink_compare_extents(XFS_I(src), srcoff, cmp_len,
+				XFS_I(dest), destoff);
+
+		src_page = xfs_get_page(src, srcoff);
+		if (IS_ERR(src_page)) {
+			error = PTR_ERR(src_page);
+			goto out_error;
+		}
+		dest_page = xfs_get_page(dest, destoff);
+		if (IS_ERR(dest_page)) {
+			error = PTR_ERR(dest_page);
+			unlock_page(src_page);
+			put_page(src_page);
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
+		kunmap_atomic(dest_addr);
+		kunmap_atomic(src_addr);
+		unlock_page(dest_page);
+		unlock_page(src_page);
+		put_page(dest_page);
+		put_page(src_page);
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
+/*
  * Link a range of blocks from one file to another.
  */
 int
@@ -1277,12 +1382,14 @@ xfs_reflink_remap_range(
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
@@ -1294,6 +1401,9 @@ xfs_reflink_remap_range(
 	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
 		return -EINVAL;
 
+	if (flags & ~XFS_REFLINK_ALL)
+		return -EINVAL;
+
 	trace_xfs_reflink_remap_range(src, srcoff, len, dest, destoff);
 
 	/* Lock both files against IO */
@@ -1305,6 +1415,21 @@ xfs_reflink_remap_range(
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
index bd9c832..6a67c08 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -44,7 +44,10 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
+#define XFS_REFLINK_DEDUPE	1	/* only reflink if contents match */
+#define XFS_REFLINK_ALL		(XFS_REFLINK_DEDUPE)
 extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
-		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len);
+		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len,
+		unsigned int flags);
 
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
