Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3129F29E1D
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 09:54:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8A752AC001
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 07:54:53 -0700 (PDT)
Received: from mail-pb0-f43.google.com (mail-pb0-f43.google.com
	[209.85.160.43]) by cuda.sgi.com with ESMTP id aH2S18NG4LmRX51H
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 31 Mar 2014 07:54:51 -0700 (PDT)
Received: by mail-pb0-f43.google.com with SMTP id um1so8295362pbc.16
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 07:54:51 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 3/3] ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Mon, 31 Mar 2014 23:54:42 +0900
Message-Id: <1396277682-10895-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, hch@infradead.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, lczerner@redhat.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch implements fallocate's FALLOC_FL_INSERT_RANGE for Ext4.

1) Make sure that both offset and len are block size aligned. 
2) Compute the file's logical block number against offset. If the computed
   block number is not the starting block of the extent, split the extent
   such that the block number is the starting block of the extent.
3) Shift all the extents which are lying bewteen [offset, last allocated extent]
   towards right by len bytes. This step will make a hole of len bytes
   at offset.
4) Allocate unwritten extents for the hole created in step 3.
5) Update the i_size of inode by len bytes.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/ext4.h              |    1 +
 fs/ext4/extents.c           |  312 +++++++++++++++++++++++++++++++++++++++++--
 include/trace/events/ext4.h |   25 ++++
 3 files changed, 329 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f4f889e..acb8bab 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2762,6 +2762,7 @@ extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 extern int ext4_ext_precache(struct inode *inode);
 extern int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len);
+extern int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len);
 
 /* move_extent.c */
 extern void ext4_double_down_write_data_sem(struct inode *first,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 243a02e..8e3ba84 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4867,7 +4867,8 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
+			 FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
@@ -4876,6 +4877,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (mode & FALLOC_FL_COLLAPSE_RANGE)
 		return ext4_collapse_range(inode, offset, len);
 
+	if (mode & FALLOC_FL_INSERT_RANGE)
+		return ext4_insert_range(inode, offset, len);
+
 	ret = ext4_convert_inline_data(inode);
 	if (ret)
 		return ret;
@@ -5189,13 +5193,13 @@ ext4_access_path(handle_t *handle, struct inode *inode,
 }
 
 /*
- * ext4_ext_shift_path_extents:
+ * ext4_ext_shift_path_extents_left:
  * Shift the extents of a path structure lying between path[depth].p_ext
- * and EXT_LAST_EXTENT(path[depth].p_hdr) downwards, by subtracting shift
+ * and EXT_LAST_EXTENT(path[depth].p_hdr) to the left, by subtracting shift
  * from starting block for each extent.
  */
 static int
-ext4_ext_shift_path_extents(struct ext4_ext_path *path, ext4_lblk_t shift,
+ext4_ext_shift_path_extents_left(struct ext4_ext_path *path, ext4_lblk_t shift,
 			    struct inode *inode, handle_t *handle,
 			    ext4_lblk_t *start)
 {
@@ -5264,13 +5268,13 @@ out:
 }
 
 /*
- * ext4_ext_shift_extents:
+ * ext4_ext_shift_extents_left:
  * All the extents which lies in the range from start to the last allocated
- * block for the file are shifted downwards by shift blocks.
+ * block for the file are shifted to the left by shift blocks.
  * On success, 0 is returned, error otherwise.
  */
 static int
-ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
+ext4_ext_shift_extents_left(struct inode *inode, handle_t *handle,
 		       ext4_lblk_t start, ext4_lblk_t shift)
 {
 	struct ext4_ext_path *path;
@@ -5335,7 +5339,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 				break;
 			}
 		}
-		ret = ext4_ext_shift_path_extents(path, shift, inode,
+		ret = ext4_ext_shift_path_extents_left(path, shift, inode,
 				handle, &start);
 		ext4_ext_drop_refs(path);
 		kfree(path);
@@ -5429,7 +5433,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		goto out_stop;
 	}
 
-	ret = ext4_ext_shift_extents(inode, handle, punch_stop,
+	ret = ext4_ext_shift_extents_left(inode, handle, punch_stop,
 				     punch_stop - punch_start);
 	if (ret) {
 		up_write(&EXT4_I(inode)->i_data_sem);
@@ -5455,3 +5459,293 @@ out_mutex:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
+
+/*
+ * ext4_ext_shift_path_extents_right:
+ * Shift the extents of a path structure towards right, by adding shift_lblk
+ * to the starting ee_block of each extent. Shifting is done from
+ * the last extent in the path till we reach first extent OR hit start_lblk.
+ * In case the first extent in the path is updated, update extent index will be
+ * updated if it is present.
+ * On success, 0 is returned, error otherwise.
+ */
+static int
+ext4_ext_shift_path_extents_right(struct ext4_ext_path *path,
+		struct inode *inode, handle_t *handle,
+		ext4_lblk_t start_lblk, ext4_lblk_t shift_lblk)
+{
+	int depth, err = 0;
+	struct ext4_extent *ex_start, *ex_last;
+
+	depth = ext_depth(inode);
+	while (depth >= 0) {
+		if (depth == path->p_depth) {
+			ex_start = EXT_FIRST_EXTENT(path[depth].p_hdr);
+
+			ex_last = EXT_LAST_EXTENT(path[depth].p_hdr);
+			if (!ex_last)
+				return -EIO;
+
+			err = ext4_access_path(handle, inode, path + depth);
+			if (err)
+				goto out;
+
+			while ((ex_start <= ex_last) &&
+				(ex_last->ee_block >= start_lblk)) {
+				ex_last->ee_block += shift_lblk;
+				ext4_ext_try_to_merge_right(inode, path,
+						ex_last);
+				ex_last--;
+			}
+			err = ext4_ext_dirty(handle, inode, path + depth);
+			if (err)
+				goto out;
+
+			if (--depth < 0 || ex_start <= ex_last)
+				break;
+		}
+
+		/* Update index too */
+		err = ext4_access_path(handle, inode, path + depth);
+		if (err)
+			goto out;
+		path[depth].p_idx->ei_block += shift_lblk;
+		err = ext4_ext_dirty(handle, inode, path + depth);
+		if (err)
+			goto out;
+
+		/* we are done if current index is not a starting index */
+		if (path[depth].p_idx != EXT_FIRST_INDEX(path[depth].p_hdr))
+			break;
+
+		depth--;
+	}
+
+out:
+	return err;
+}
+
+/*
+ * ext4_ext_shift_extents_right:
+ * All the extents of an inode which lies in the range from start_lblk
+ * to the last allocated block are shifted right by @shift_lblk blocks.
+ * As we will be shifitng complete extents, @start_lblk should be the
+ * starting block of an extent OR it can lie in a hole.
+ * On success, 0 is returned, error otherwise.
+ */
+static int
+ext4_ext_shift_extents_right(struct inode *inode, handle_t *handle,
+		ext4_lblk_t start_lblk, ext4_lblk_t shift_lblk)
+{
+	struct ext4_ext_path *path;
+	struct ext4_extent *ex_start;
+	int ret = 0, depth;
+	ext4_lblk_t current_block = EXT_MAX_BLOCKS - 1;
+
+	/* Its safe to start updating extents */
+	while (start_lblk < current_block) {
+		path = ext4_ext_find_extent(inode, current_block, NULL, 0);
+		if (IS_ERR(path))
+			return PTR_ERR(path);
+
+		depth = ext_depth(inode);
+		if (unlikely(path[depth].p_hdr == NULL)) {
+			ret = -EIO;
+			goto out_stop;
+		}
+
+		ex_start = EXT_FIRST_EXTENT(path[depth].p_hdr);
+		if (!ex_start) {
+			ret = -EIO;
+			goto out_stop;
+		}
+
+		current_block = ex_start->ee_block;
+		ret = ext4_ext_shift_path_extents_right(path, inode, handle,
+				start_lblk, shift_lblk);
+out_stop:
+		ext4_ext_drop_refs(path);
+		kfree(path);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/*
+ * ext4_insert_range:
+ * This function implements the FALLOC_FL_INSERT_RANGE flag of fallocate.
+ * Firstly, the data blocks starting from @offset to the EOF are shifted by
+ * @len towards right to create a hole in the @inode. Secondly, the hole is
+ * filled with uninit extent(s). Inode size is increased by len bytes.
+ * Returns 0 on success, error otherwise.
+ */
+int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
+{
+	struct super_block *sb = inode->i_sb;
+	handle_t *handle;
+	struct ext4_map_blocks map;
+	struct ext4_ext_path *path;
+	struct ext4_extent *extent;
+	ext4_lblk_t offset_lblk, len_lblk, ee_start_lblk, ee_last_lblk;
+	unsigned int credits, ee_len;
+	int ret = 0, depth, split_flag = 0;
+
+	BUG_ON(offset > i_size_read(inode));
+
+	/* Insert range works only on fs block size aligned offsets. */
+	if (offset & (EXT4_BLOCK_SIZE(sb) - 1) ||
+			len & (EXT4_BLOCK_SIZE(sb) - 1))
+		return -EINVAL;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	trace_ext4_insert_range(inode, offset, len);
+
+	offset_lblk = offset >> EXT4_BLOCK_SIZE_BITS(sb);
+	len_lblk = len >> EXT4_BLOCK_SIZE_BITS(sb);
+
+	/* Write out all dirty pages */
+	ret = filemap_write_and_wait_range(inode->i_mapping, offset, -1);
+	if (ret)
+		return ret;
+
+	/* Take mutex lock */
+	mutex_lock(&inode->i_mutex);
+
+	/* It's not possible punch hole on append only file */
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
+		ret = -EPERM;
+		goto out_mutex;
+	}
+
+	if (IS_SWAPFILE(inode)) {
+		ret = -ETXTBSY;
+		goto out_mutex;
+	}
+
+	/* Currently just for extent based files */
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		ret = -EOPNOTSUPP;
+		goto out_mutex;
+	}
+
+	path = ext4_ext_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL, 0);
+	if (IS_ERR(path))
+		return PTR_ERR(path);
+
+	depth = ext_depth(inode);
+	extent = path[depth].p_ext;
+	if (!extent) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+		return ret;
+	}
+
+	ee_last_lblk = extent->ee_block + ext4_ext_get_actual_len(extent);
+	ext4_ext_drop_refs(path);
+	kfree(path);
+
+	/*
+	 * Check if number of blocks of file shifted by insert range can be
+	 * bigger than EXT_MAX_BLOCKS at first.
+	 */
+	if (ee_last_lblk + len_lblk > EXT_MAX_BLOCKS - 1) {
+		mutex_unlock(&inode->i_mutex);
+		return -EINVAL;
+	}
+
+	truncate_pagecache_range(inode, offset, -1);
+
+	/* Wait for existing dio to complete */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
+	credits = ext4_writepage_trans_blocks(inode);
+	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_dio;
+	}
+
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_discard_preallocations(inode);
+
+	path = ext4_ext_find_extent(inode, offset_lblk, NULL, 0);
+	if (IS_ERR(path)) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	depth = ext_depth(inode);
+	extent = path[depth].p_ext;
+	ee_start_lblk = le32_to_cpu(extent->ee_block);
+	ee_len = ext4_ext_get_actual_len(extent);
+
+	/*
+	 * If offset_lblk is not the starting block of extent, split
+	 * the extent @offset_lblk
+	 */
+	if (offset_lblk > ee_start_lblk &&
+			offset_lblk < (ee_start_lblk + ee_len)) {
+		if (ext4_ext_is_uninitialized(extent))
+			split_flag = EXT4_EXT_MARK_UNINIT1 |
+				EXT4_EXT_MARK_UNINIT2;
+
+		ret = ext4_split_extent_at(handle, inode, path,
+				offset_lblk, split_flag, EXT4_EX_NOCACHE |
+				EXT4_GET_BLOCKS_PRE_IO |
+				EXT4_GET_BLOCKS_METADATA_NOFAIL);
+	}
+	ext4_ext_drop_refs(path);
+	kfree(path);
+	if (ret) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	ret = ext4_ext_shift_extents_right(inode, handle, offset_lblk,
+			len_lblk);
+	if (ret) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	map.m_lblk = offset_lblk;
+	map.m_len = len_lblk;
+
+	ret = ext4_ext_map_blocks(handle, inode, &map,
+		EXT4_GET_BLOCKS_CREATE_UNINIT_EXT | EXT4_GET_BLOCKS_NO_LOCK);
+	if (unlikely(ret != map.m_len)) {
+		ret = -EIO;
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	ret = ext4_es_insert_extent(inode, map.m_lblk, map.m_len, map.m_pblk,
+		EXTENT_STATUS_UNWRITTEN);
+	if (ret) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	truncate_setsize(inode, inode->i_size + len);
+	EXT4_I(inode)->i_disksize += len;
+
+	ext4_discard_preallocations(inode);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	if (IS_SYNC(inode))
+		ext4_handle_sync(handle);
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+	ext4_mark_inode_dirty(handle, inode);
+
+out_stop:
+	ext4_journal_stop(handle);
+out_dio:
+	ext4_inode_resume_unlocked_dio(inode);
+out_mutex:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 010ea89..435e976 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2448,6 +2448,31 @@ TRACE_EVENT(ext4_collapse_range,
 		  __entry->offset, __entry->len)
 );
 
+TRACE_EVENT(ext4_insert_range,
+	TP_PROTO(struct inode *inode, loff_t offset, loff_t len),
+
+	TP_ARGS(inode, offset, len),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	offset)
+		__field(loff_t, len)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->offset	= offset;
+		__entry->len	= len;
+	),
+
+	TP_printk("dev %d,%d ino %lu offset %lld len %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->offset, __entry->len)
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
