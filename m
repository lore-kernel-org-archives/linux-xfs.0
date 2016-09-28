Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19821 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933939AbcI1C6D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:58:03 -0400
Subject: [PATCH 41/63] xfs: add clone file and clone range vfs functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:58:00 -0700
Message-ID: <147503148029.30303.17483529725356722703.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Define two VFS functions which allow userspace to reflink a range of
blocks between two files or to reflink one file's contents to another.
These functions fit the new VFS ioctls that standardize the checking
for the btrfs CLONE and CLONE RANGE ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Plug into the VFS function pointers instead of handling ioctls
directly.
---
 fs/xfs/libxfs/xfs_fs.h |   11 ++++
 fs/xfs/xfs_file.c      |  142 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6f4f2c3..788e006 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -533,6 +533,17 @@ typedef struct xfs_swapext
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
+/* reflink ioctls; these MUST match the btrfs ioctl definitions */
+/* from struct btrfs_ioctl_clone_range_args */
+struct xfs_clone_args {
+	__s64 src_fd;
+	__u64 src_offset;
+	__u64 src_length;
+	__u64 dest_offset;
+};
+
+#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
+#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
 
 #ifndef HAVE_BBMACROS
 /*
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 025d52f..3db3f34 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -974,6 +974,146 @@ xfs_file_fallocate(
 	return error;
 }
 
+/*
+ * Flush all file writes out to disk.
+ */
+static int
+xfs_file_wait_for_io(
+	struct inode	*inode,
+	loff_t		offset,
+	size_t		len)
+{
+	loff_t		rounding;
+	loff_t		ioffset;
+	loff_t		iendoffset;
+	loff_t		bs;
+	int		ret;
+
+	bs = inode->i_sb->s_blocksize;
+	inode_dio_wait(inode);
+
+	rounding = max_t(xfs_off_t, bs, PAGE_SIZE);
+	ioffset = round_down(offset, rounding);
+	iendoffset = round_up(offset + len, rounding) - 1;
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
+					   iendoffset);
+	return ret;
+}
+
+/* Hook up to the VFS reflink function */
+STATIC int
+xfs_file_share_range(
+	struct file	*file_in,
+	loff_t		pos_in,
+	struct file	*file_out,
+	loff_t		pos_out,
+	u64		len)
+{
+	struct inode	*inode_in;
+	struct inode	*inode_out;
+	ssize_t		ret;
+	loff_t		bs;
+	loff_t		isize;
+	int		same_inode;
+	loff_t		blen;
+
+	inode_in = file_inode(file_in);
+	inode_out = file_inode(file_out);
+	bs = inode_out->i_sb->s_blocksize;
+
+	/* Don't touch certain kinds of inodes */
+	if (IS_IMMUTABLE(inode_out))
+		return -EPERM;
+	if (IS_SWAPFILE(inode_in) ||
+	    IS_SWAPFILE(inode_out))
+		return -ETXTBSY;
+
+	/* Reflink only works within this filesystem. */
+	if (inode_in->i_sb != inode_out->i_sb)
+		return -EXDEV;
+	same_inode = (inode_in->i_ino == inode_out->i_ino);
+
+	/* Don't reflink dirs, pipes, sockets... */
+	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+		return -EISDIR;
+	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
+		return -EINVAL;
+	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+		return -EINVAL;
+
+	/* Are we going all the way to the end? */
+	isize = i_size_read(inode_in);
+	if (isize == 0)
+		return 0;
+	if (len == 0)
+		len = isize - pos_in;
+
+	/* Ensure offsets don't wrap and the input is inside i_size */
+	if (pos_in + len < pos_in || pos_out + len < pos_out ||
+	    pos_in + len > isize)
+		return -EINVAL;
+
+	/* If we're linking to EOF, continue to the block boundary. */
+	if (pos_in + len == isize)
+		blen = ALIGN(isize, bs) - pos_in;
+	else
+		blen = len;
+
+	/* Only reflink if we're aligned to block boundaries */
+	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
+	    !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
+		return -EINVAL;
+
+	/* Don't allow overlapped reflink within the same file */
+	if (same_inode && pos_out + blen > pos_in && pos_out < pos_in + blen)
+		return -EINVAL;
+
+	/* Wait for the completion of any pending IOs on srcfile */
+	ret = xfs_file_wait_for_io(inode_in, pos_in, len);
+	if (ret)
+		goto out_unlock;
+	ret = xfs_file_wait_for_io(inode_out, pos_out, len);
+	if (ret)
+		goto out_unlock;
+
+	ret = xfs_reflink_remap_range(XFS_I(inode_in), pos_in, XFS_I(inode_out),
+			pos_out, len);
+	if (ret < 0)
+		goto out_unlock;
+
+out_unlock:
+	return ret;
+}
+
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
+				     len);
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
+				     len);
+}
 
 STATIC int
 xfs_file_open(
@@ -1634,6 +1774,8 @@ const struct file_operations xfs_file_operations = {
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
 	.fallocate	= xfs_file_fallocate,
+	.copy_file_range = xfs_file_copy_range,
+	.clone_file_range = xfs_file_clone_range,
 };
 
 const struct file_operations xfs_dir_file_operations = {

