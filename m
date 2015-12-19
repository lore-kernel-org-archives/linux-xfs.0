Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1CE837F59
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:56:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B041EAC006
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:17 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2PpzmkKEoKfBEouz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:13 -0800 (PST)
Subject: [PATCH 9/9] btrfs: use new dedupe data function pointer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:56:05 -0800
Message-ID: <20151219085605.12478.48627.stgit@birch.djwong.org>
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

Now that the VFS encapsulates the dedupe ioctl, wire up btrfs to it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/ctree.h |    2 +
 fs/btrfs/file.c  |    1 
 fs/btrfs/ioctl.c |  110 ++++++------------------------------------------------
 3 files changed, 16 insertions(+), 97 deletions(-)


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dd4733f..b7e4e34 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4024,6 +4024,8 @@ void btrfs_get_block_group_info(struct list_head *groups_list,
 				struct btrfs_ioctl_space_info *space);
 void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
 			       struct btrfs_ioctl_balance_args *bargs);
+ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
+			   struct file *dst_file, u64 dst_loff);
 
 /* file.c */
 int btrfs_auto_defrag_init(void);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 232e300..d012e0a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2926,6 +2926,7 @@ const struct file_operations btrfs_file_operations = {
 #endif
 	.copy_file_range = btrfs_copy_file_range,
 	.clone_file_range = btrfs_clone_file_range,
+	.dedupe_file_range = btrfs_dedupe_file_range,
 };
 
 void btrfs_auto_defrag_exit(void)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 85b1cae..e219973 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2962,7 +2962,7 @@ static int btrfs_cmp_data(struct inode *src, u64 loff, struct inode *dst,
 		flush_dcache_page(dst_page);
 
 		if (memcmp(addr, dst_addr, cmp_len))
-			ret = BTRFS_SAME_DATA_DIFFERS;
+			ret = -EBADE;
 
 		kunmap_atomic(addr);
 		kunmap_atomic(dst_addr);
@@ -3098,53 +3098,16 @@ out_unlock:
 
 #define BTRFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
 
-static long btrfs_ioctl_file_extent_same(struct file *file,
-			struct btrfs_ioctl_same_args __user *argp)
+ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
+				struct file *dst_file, u64 dst_loff)
 {
-	struct btrfs_ioctl_same_args *same = NULL;
-	struct btrfs_ioctl_same_extent_info *info;
-	struct inode *src = file_inode(file);
-	u64 off;
-	u64 len;
-	int i;
-	int ret;
-	unsigned long size;
+	struct inode *src = file_inode(src_file);
+	struct inode *dst = file_inode(dst_file);
 	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
-	bool is_admin = capable(CAP_SYS_ADMIN);
-	u16 count;
-
-	if (!(file->f_mode & FMODE_READ))
-		return -EINVAL;
+	ssize_t res;
 
-	ret = mnt_want_write_file(file);
-	if (ret)
-		return ret;
-
-	if (get_user(count, &argp->dest_count)) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	size = offsetof(struct btrfs_ioctl_same_args __user, info[count]);
-
-	same = memdup_user(argp, size);
-
-	if (IS_ERR(same)) {
-		ret = PTR_ERR(same);
-		same = NULL;
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
-	if (len > BTRFS_MAX_DEDUPE_LEN)
-		len = BTRFS_MAX_DEDUPE_LEN;
+	if (olen > BTRFS_MAX_DEDUPE_LEN)
+		olen = BTRFS_MAX_DEDUPE_LEN;
 
 	if (WARN_ON_ONCE(bs < PAGE_CACHE_SIZE)) {
 		/*
@@ -3152,58 +3115,13 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 		 * result, btrfs_cmp_data() won't correctly handle
 		 * this situation without an update.
 		 */
-		ret = -EINVAL;
-		goto out;
-	}
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
-		if (!dst_file.file) {
-			info->status = -EBADF;
-			continue;
-		}
-		dst = file_inode(dst_file.file);
-
-		if (!(is_admin || (dst_file.file->f_mode & FMODE_WRITE))) {
-			info->status = -EINVAL;
-		} else if (file->f_path.mnt != dst_file.file->f_path.mnt) {
-			info->status = -EXDEV;
-		} else if (S_ISDIR(dst->i_mode)) {
-			info->status = -EISDIR;
-		} else if (!S_ISREG(dst->i_mode)) {
-			info->status = -EACCES;
-		} else {
-			info->status = btrfs_extent_same(src, off, len, dst,
-							info->logical_offset);
-			if (info->status == 0)
-				info->bytes_deduped += len;
-		}
-		fdput(dst_file);
+		return -EINVAL;
 	}
 
-	ret = copy_to_user(argp, same, size);
-	if (ret)
-		ret = -EFAULT;
-
-out:
-	mnt_drop_write_file(file);
-	kfree(same);
-	return ret;
+	res = btrfs_extent_same(src, loff, olen, dst, dst_loff);
+	if (res)
+		return res;
+	return olen;
 }
 
 static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
@@ -5536,8 +5454,6 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(file, argp);
 	case BTRFS_IOC_SET_FSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
-	case BTRFS_IOC_FILE_EXTENT_SAME:
-		return btrfs_ioctl_file_extent_same(file, argp);
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		return btrfs_ioctl_get_supported_features(file, argp);
 	case BTRFS_IOC_GET_FEATURES:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
