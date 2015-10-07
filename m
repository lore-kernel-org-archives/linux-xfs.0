Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CACCA7FAA
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:00:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E30BAC007
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:00:50 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id FFz4zCDg0kD0yAA8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:00:48 -0700 (PDT)
Subject: [PATCH 51/58] xfs: add clone file and clone range ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:00:44 -0700
Message-ID: <20151007050044.30457.38096.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Define two ioctls which allow userspace to reflink a range of blocks
between two files or to reflink one file's contents to another.
These ioctls must have the same ABI as the btrfs ioctls with similar
names.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   11 +++
 fs/xfs/xfs_ioctl.c     |  192 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl32.c   |    2 +
 3 files changed, 205 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b6ee5d8..2c8cd04 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -561,6 +561,17 @@ typedef struct xfs_swapext
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
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ea7d85a..ce4812e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -40,6 +40,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans.h"
 #include "xfs_pnfs.h"
+#include "xfs_reflink.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -48,6 +49,8 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/exportfs.h>
+#include <linux/fsnotify.h>
+#include <linux/security.h>
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -1503,6 +1506,153 @@ xfs_ioc_swapext(
 }
 
 /*
+ * Flush all file writes out to disk.
+ */
+static int
+wait_for_io(
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
+	rounding = max_t(xfs_off_t, bs, PAGE_CACHE_SIZE);
+	ioffset = round_down(offset, rounding);
+	iendoffset = round_up(offset + len, rounding) - 1;
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
+					   iendoffset);
+	return ret;
+}
+
+/*
+ * For reflink, validate the VFS parameters, convert them into the XFS
+ * equivalents, and then call the internal reflink function.
+ */
+STATIC int
+xfs_ioctl_reflink(
+	struct file	*file_in,
+	loff_t		pos_in,
+	struct file	*file_out,
+	loff_t		pos_out,
+	size_t		len)
+{
+	struct inode	*inode_in;
+	struct inode	*inode_out;
+	ssize_t		ret;
+	loff_t		bs;
+	loff_t		isize;
+	int		same_inode;
+	loff_t		blen;
+
+	if (len == 0)
+		return 0;
+	else if (len != ~0ULL && (ssize_t)len < 0)
+		return -EINVAL;
+
+	/* Do we have the correct permissions? */
+	if (!(file_in->f_mode & FMODE_READ) ||
+	    !(file_out->f_mode & FMODE_WRITE) ||
+	    (file_out->f_flags & O_APPEND))
+		return -EPERM;
+	ret = security_file_permission(file_out, MAY_WRITE);
+	if (ret)
+		return ret;
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
+	if (inode_in->i_sb != inode_out->i_sb ||
+	    file_in->f_path.mnt != file_out->f_path.mnt)
+		return -EXDEV;
+	same_inode = (inode_in->i_ino == inode_out->i_ino);
+
+	/* Don't reflink dirs, pipes, sockets... */
+	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+		return -EISDIR;
+	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
+		return -ESPIPE;
+	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+		return -EINVAL;
+
+	/* Are we going all the way to the end? */
+	isize = i_size_read(inode_in);
+	if (isize == 0)
+		return 0;
+	if (len  == ~0ULL)
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
+	ret = mnt_want_write_file(file_out);
+	if (ret)
+		return ret;
+
+	/* Wait for the completion of any pending IOs on srcfile */
+	ret = wait_for_io(inode_in, pos_in, len);
+	if (ret)
+		goto out_unlock;
+	ret = wait_for_io(inode_out, pos_out, len);
+	if (ret)
+		goto out_unlock;
+
+	ret = xfs_reflink(XFS_I(inode_in), pos_in, XFS_I(inode_out),
+			pos_out, len);
+	if (ret < 0)
+		goto out_unlock;
+
+	/* Truncate the page cache so we don't see stale data */
+	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+				   PAGE_CACHE_ALIGN(pos_out + len) - 1);
+
+out_unlock:
+	if (ret == 0) {
+		fsnotify_access(file_in);
+		add_rchar(current, len);
+		fsnotify_modify(file_out);
+		add_wchar(current, len);
+	}
+	inc_syscr(current);
+	inc_syscw(current);
+
+	mnt_drop_write_file(file_out);
+	return ret;
+}
+
+/*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
  * So we don't "sign flip" like most other routines.  This means
@@ -1800,6 +1950,48 @@ xfs_file_ioctl(
 		return xfs_icache_free_eofblocks(mp, &keofb);
 	}
 
+	case XFS_IOC_CLONE: {
+		struct fd src;
+
+		src = fdget(p);
+		if (!src.file)
+			return -EBADF;
+
+		trace_xfs_ioctl_clone(file_inode(src.file), file_inode(filp));
+
+		error = xfs_ioctl_reflink(src.file, 0, filp, 0, ~0ULL);
+		fdput(src);
+		if (error > 0)
+			error = 0;
+
+		return error;
+	}
+
+	case XFS_IOC_CLONE_RANGE: {
+		struct fd src;
+		struct xfs_clone_args args;
+
+		if (copy_from_user(&args, arg, sizeof(args)))
+			return -EFAULT;
+		src = fdget(args.src_fd);
+		if (!src.file)
+			return -EBADF;
+		if (args.src_length == 0)
+			args.src_length = ~0ULL;
+
+		trace_xfs_ioctl_clone_range(file_inode(src.file),
+				args.src_offset, args.src_length,
+				file_inode(filp), args.dest_offset);
+
+		error = xfs_ioctl_reflink(src.file, args.src_offset, filp,
+					  args.dest_offset, args.src_length);
+		fdput(src);
+		if (error > 0)
+			error = 0;
+
+		return error;
+	}
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index b88bdc8..76d8729 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -558,6 +558,8 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
+	case XFS_IOC_CLONE:
+	case XFS_IOC_CLONE_RANGE:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
