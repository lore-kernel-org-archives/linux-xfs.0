Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D88D7F69
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:56:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CD51AC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:07 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zKxnoPU7DLXXc42T (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:06 -0800 (PST)
Subject: [PATCH 8/9] vfs: hoist the btrfs deduplication ioctl to the vfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:55:59 -0800
Message-ID: <20151219085559.12478.33700.stgit@birch.djwong.org>
In-Reply-To: <20151219085505.12478.71157.stgit@birch.djwong.org>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, xfs@oss.sgi.com

Hoist the btrfs EXTENT_SAME ioctl up to the VFS and make the name
more systematic (FIDEDUPERANGE).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/compat_ioctl.c       |    1 
 fs/ioctl.c              |   38 ++++++++++++++++++
 fs/read_write.c         |  100 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |    4 ++
 include/uapi/linux/fs.h |   30 ++++++++++++++
 5 files changed, 173 insertions(+)


diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 70d4b10..eab31e7 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1582,6 +1582,7 @@ COMPAT_SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd,
 
 	case FICLONE:
 	case FICLONERANGE:
+	case FIDEDUPERANGE:
 		goto do_ioctl;
 
 	case FIBMAP:
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 84c6e79..fcdd33b 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -568,6 +568,41 @@ static int ioctl_fsthaw(struct file *filp)
 	return thaw_super(sb);
 }
 
+static long ioctl_file_dedupe_range(struct file *file, void __user *arg)
+{
+	struct file_dedupe_range __user *argp = arg;
+	struct file_dedupe_range *same = NULL;
+	int ret;
+	unsigned long size;
+	u16 count;
+
+	if (get_user(count, &argp->dest_count)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	size = offsetof(struct file_dedupe_range __user, info[count]);
+
+	same = memdup_user(argp, size);
+	if (IS_ERR(same)) {
+		ret = PTR_ERR(same);
+		same = NULL;
+		goto out;
+	}
+
+	ret = vfs_dedupe_file_range(file, same);
+	if (ret)
+		goto out;
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
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -629,6 +664,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FICLONERANGE:
 		return ioctl_file_clone_range(filp, argp);
 
+	case FIDEDUPERANGE:
+		return ioctl_file_dedupe_range(filp, argp);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/fs/read_write.c b/fs/read_write.c
index 0713e28..aaaad52 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1523,3 +1523,103 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	return ret;
 }
 EXPORT_SYMBOL(vfs_clone_file_range);
+
+int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
+{
+	struct file_dedupe_range_info *info;
+	struct inode *src = file_inode(file);
+	u64 off;
+	u64 len;
+	int i;
+	int ret;
+	bool is_admin = capable(CAP_SYS_ADMIN);
+	u16 count = same->dest_count;
+	struct file *dst_file;
+	loff_t dst_off;
+	ssize_t deduped;
+
+	if (!(file->f_mode & FMODE_READ))
+		return -EINVAL;
+
+	if (same->reserved1 || same->reserved2)
+		return -EINVAL;
+
+	off = same->src_offset;
+	len = same->src_length;
+
+	ret = -EISDIR;
+	if (S_ISDIR(src->i_mode))
+		goto out;
+
+	ret = -EINVAL;
+	if (!S_ISREG(src->i_mode))
+		goto out;
+
+	ret = clone_verify_area(file, off, len, false);
+	if (ret < 0)
+		goto out;
+	ret = 0;
+
+	/* pre-format output fields to sane values */
+	for (i = 0; i < count; i++) {
+		same->info[i].bytes_deduped = 0ULL;
+		same->info[i].status = FILE_DEDUPE_RANGE_SAME;
+	}
+
+	for (i = 0, info = same->info; i < count; i++, info++) {
+		struct inode *dst;
+		struct fd dst_fd = fdget(info->dest_fd);
+
+		dst_file = dst_fd.file;
+		if (!dst_file) {
+			info->status = -EBADF;
+			goto next_loop;
+		}
+		dst = file_inode(dst_file);
+
+		ret = mnt_want_write_file(dst_file);
+		if (ret) {
+			info->status = ret;
+			goto next_loop;
+		}
+
+		dst_off = info->dest_offset;
+		ret = clone_verify_area(dst_file, dst_off, len, true);
+		if (ret < 0) {
+			info->status = ret;
+			goto next_file;
+		}
+		ret = 0;
+
+		if (info->reserved) {
+			info->status = -EINVAL;
+		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
+			info->status = -EINVAL;
+		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
+			info->status = -EXDEV;
+		} else if (S_ISDIR(dst->i_mode)) {
+			info->status = -EISDIR;
+		} else if (dst_file->f_op->dedupe_file_range == NULL) {
+			info->status = -EINVAL;
+		} else {
+			deduped = dst_file->f_op->dedupe_file_range(file, off,
+							len, dst_file,
+							info->dest_offset);
+			if (deduped == -EBADE)
+				info->status = FILE_DEDUPE_RANGE_DIFFERS;
+			else if (deduped < 0)
+				info->status = deduped;
+			else
+				info->bytes_deduped += deduped;
+		}
+
+next_file:
+		mnt_drop_write_file(dst_file);
+next_loop:
+		fdput(dst_fd);
+	}
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL(vfs_dedupe_file_range);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 26b7607..bcfa23d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1633,6 +1633,8 @@ struct file_operations {
 			loff_t, size_t, unsigned int);
 	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
 			u64);
+	ssize_t (*dedupe_file_range)(struct file *, u64, u64, struct file *,
+			u64);
 };
 
 struct inode_operations {
@@ -1688,6 +1690,8 @@ extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len);
+extern int vfs_dedupe_file_range(struct file *file,
+				 struct file_dedupe_range *same);
 
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index ad60359..801986e 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -52,6 +52,35 @@ struct fstrim_range {
 	__u64 minlen;
 };
 
+/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
+#define FILE_DEDUPE_RANGE_SAME		0
+#define FILE_DEDUPE_RANGE_DIFFERS	1
+
+/* from struct btrfs_ioctl_file_extent_same_info */
+struct file_dedupe_range_info {
+	__s64 dest_fd;		/* in - destination file */
+	__u64 dest_offset;	/* in - start of extent in destination */
+	__u64 bytes_deduped;	/* out - total # of bytes we were able
+				 * to dedupe from this file. */
+	/* status of this dedupe operation:
+	 * < 0 for error
+	 * == FILE_DEDUPE_RANGE_SAME if dedupe succeeds
+	 * == FILE_DEDUPE_RANGE_DIFFERS if data differs
+	 */
+	__s32 status;		/* out - see above description */
+	__u32 reserved;		/* must be zero */
+};
+
+/* from struct btrfs_ioctl_file_extent_same_args */
+struct file_dedupe_range {
+	__u64 src_offset;	/* in - start of extent in source */
+	__u64 src_length;	/* in - length of extent */
+	__u16 dest_count;	/* in - total elements in info array */
+	__u16 reserved1;	/* must be zero */
+	__u32 reserved2;	/* must be zero */
+	struct file_dedupe_range_info info[0];
+};
+
 /* And dynamically-tunable limits and defaults: */
 struct files_stat_struct {
 	unsigned long nr_files;		/* read only */
@@ -177,6 +206,7 @@ struct blkzeroout2 {
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
 #define FICLONE		_IOW(0x94, 9, int)
 #define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)
+#define FIDEDUPERANGE	_IOWR(0x94, 54, struct file_dedupe_range)
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
