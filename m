Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C88BC7F5F
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 00:16:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 821E7304051
	for <xfs@oss.sgi.com>; Sun, 23 Nov 2014 22:16:39 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id yKQctHokjzTpR180 (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Nov 2014 22:16:37 -0800 (PST)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NFJ00KBJ5FPS4A0@mailout3.samsung.com> for
	xfs@oss.sgi.com; Mon, 24 Nov 2014 15:16:37 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v6 3/10] ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Mon, 24 Nov 2014 15:16:36 +0900
Message-id: <002c01d007ae$3395e5b0$9ac1b110$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>, linux-kernel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

This patch implements fallocate's FALLOC_FL_INSERT_RANGE for Ext4.

1) Make sure that both offset and len are block size aligned.
2) Update the i_size of inode by len bytes.
3) Compute the file's logical block number against offset. If the computed
   block number is not the starting block of the extent, split the extent
   such that the block number is the starting block of the extent.
4) Shift all the extents which are lying bewteen [offset, last allocated extent]
   towards right by len bytes. This step will make a hole of len bytes
   at offset.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
Changelog

v6:
 - Instead of having seperate functions for shifting extents left/right, the
   current extent shift function is made generic to shift in both directions.

v5:
 - remove allocation part.

 fs/ext4/ext4.h              |   6 +
 fs/ext4/extents.c           | 302 ++++++++++++++++++++++++++++++++++++--------
 include/trace/events/ext4.h |  25 ++++
 3 files changed, 282 insertions(+), 51 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index db3f772..0cf212a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -90,6 +90,11 @@ typedef __u32 ext4_lblk_t;
 /* data type for block group number */
 typedef unsigned int ext4_group_t;
 
+enum SHIFT_DIRECTION {
+	SHIFT_LEFT = 0,
+	SHIFT_RIGHT,
+};
+
 /*
  * Flags used in mballoc's allocation_context flags field.
  *
@@ -2760,6 +2765,7 @@ extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 extern int ext4_ext_precache(struct inode *inode);
 extern int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len);
+extern int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len);
 extern int ext4_swap_extents(handle_t *handle, struct inode *inode1,
 				struct inode *inode2, ext4_lblk_t lblk1,
 			     ext4_lblk_t lblk2,  ext4_lblk_t count,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0b16fb4..0baebc5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4913,7 +4913,8 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
+		     FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
@@ -4933,6 +4934,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (mode & FALLOC_FL_COLLAPSE_RANGE)
 		return ext4_collapse_range(inode, offset, len);
 
+	if (mode & FALLOC_FL_INSERT_RANGE)
+		return ext4_insert_range(inode, offset, len);
+
 	if (mode & FALLOC_FL_ZERO_RANGE)
 		return ext4_zero_range(file, offset, len, mode);
 
@@ -5219,13 +5223,13 @@ ext4_access_path(handle_t *handle, struct inode *inode,
 /*
  * ext4_ext_shift_path_extents:
  * Shift the extents of a path structure lying between path[depth].p_ext
- * and EXT_LAST_EXTENT(path[depth].p_hdr) downwards, by subtracting shift
- * from starting block for each extent.
+ * and EXT_LAST_EXTENT(path[depth].p_hdr), by @shift blocks. @SHIFT tells
+ * if it is right shift or left shift operation.
  */
 static int
 ext4_ext_shift_path_extents(struct ext4_ext_path *path, ext4_lblk_t shift,
 			    struct inode *inode, handle_t *handle,
-			    ext4_lblk_t *start)
+			    enum SHIFT_DIRECTION SHIFT)
 {
 	int depth, err = 0;
 	struct ext4_extent *ex_start, *ex_last;
@@ -5249,19 +5253,25 @@ ext4_ext_shift_path_extents(struct ext4_ext_path *path, ext4_lblk_t shift,
 			if (ex_start == EXT_FIRST_EXTENT(path[depth].p_hdr))
 				update = 1;
 
-			*start = le32_to_cpu(ex_last->ee_block) +
-				ext4_ext_get_actual_len(ex_last);
-
 			while (ex_start <= ex_last) {
-				le32_add_cpu(&ex_start->ee_block, -shift);
-				/* Try to merge to the left. */
-				if ((ex_start >
-				     EXT_FIRST_EXTENT(path[depth].p_hdr)) &&
-				    ext4_ext_try_to_merge_right(inode,
-							path, ex_start - 1))
+				if (SHIFT == SHIFT_LEFT) {
+					le32_add_cpu(&ex_start->ee_block,
+						-shift);
+					/* Try to merge to the left. */
+					if ((ex_start >
+					    EXT_FIRST_EXTENT(path[depth].p_hdr))
+					    &&
+					    ext4_ext_try_to_merge_right(inode,
+					    path, ex_start - 1))
+						ex_last--;
+					else
+						ex_start++;
+				} else {
+					le32_add_cpu(&ex_last->ee_block, shift);
+					ext4_ext_try_to_merge_right(inode, path,
+						ex_last);
 					ex_last--;
-				else
-					ex_start++;
+				}
 			}
 			err = ext4_ext_dirty(handle, inode, path + depth);
 			if (err)
@@ -5276,7 +5286,10 @@ ext4_ext_shift_path_extents(struct ext4_ext_path *path, ext4_lblk_t shift,
 		if (err)
 			goto out;
 
-		le32_add_cpu(&path[depth].p_idx->ei_block, -shift);
+		if (SHIFT == SHIFT_LEFT)
+			le32_add_cpu(&path[depth].p_idx->ei_block, -shift);
+		else
+			le32_add_cpu(&path[depth].p_idx->ei_block, shift);
 		err = ext4_ext_dirty(handle, inode, path + depth);
 		if (err)
 			goto out;
@@ -5294,19 +5307,20 @@ out:
 
 /*
  * ext4_ext_shift_extents:
- * All the extents which lies in the range from start to the last allocated
- * block for the file are shifted downwards by shift blocks.
+ * All the extents which lies in the range from @start to the last allocated
+ * block for the @inode are shifted either towards left or right (depending
+ * upon @SHIFT) by @shift blocks.
  * On success, 0 is returned, error otherwise.
  */
 static int
 ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
-		       ext4_lblk_t start, ext4_lblk_t shift)
+		       ext4_lblk_t start, ext4_lblk_t shift,
+		       enum SHIFT_DIRECTION SHIFT)
 {
 	struct ext4_ext_path *path;
 	int ret = 0, depth;
 	struct ext4_extent *extent;
-	ext4_lblk_t stop_block;
-	ext4_lblk_t ex_start, ex_end;
+	ext4_lblk_t stop, *iterator, ex_start, ex_end;
 
 	/* Let path point to the last extent */
 	path = ext4_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL, 0);
@@ -5318,58 +5332,84 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	if (!extent)
 		goto out;
 
-	stop_block = le32_to_cpu(extent->ee_block) +
+	stop = le32_to_cpu(extent->ee_block) +
 			ext4_ext_get_actual_len(extent);
 
-	/* Nothing to shift, if hole is at the end of file */
-	if (start >= stop_block)
-		goto out;
+       /*
+	 * In case of left shift, Don't start shifting extents until we make
+	 * sure the hole is big enough to accommodate the shift.
+	*/
+	if (SHIFT == SHIFT_LEFT) {
+		path = ext4_find_extent(inode, start - 1, &path, 0);
+		if (IS_ERR(path))
+			return PTR_ERR(path);
+		depth = path->p_depth;
+		extent =  path[depth].p_ext;
+		if (extent) {
+			ex_start = le32_to_cpu(extent->ee_block);
+			ex_end = le32_to_cpu(extent->ee_block) +
+				ext4_ext_get_actual_len(extent);
+		} else {
+			ex_start = 0;
+			ex_end = 0;
+		}
 
-	/*
-	 * Don't start shifting extents until we make sure the hole is big
-	 * enough to accomodate the shift.
-	 */
-	path = ext4_find_extent(inode, start - 1, &path, 0);
-	if (IS_ERR(path))
-		return PTR_ERR(path);
-	depth = path->p_depth;
-	extent =  path[depth].p_ext;
-	if (extent) {
-		ex_start = le32_to_cpu(extent->ee_block);
-		ex_end = le32_to_cpu(extent->ee_block) +
-			ext4_ext_get_actual_len(extent);
-	} else {
-		ex_start = 0;
-		ex_end = 0;
+		if ((start == ex_start && shift > ex_start) ||
+		    (shift > start - ex_end)) {
+			ext4_ext_drop_refs(path);
+			kfree(path);
+			return -EINVAL;
+		}
 	}
 
-	if ((start == ex_start && shift > ex_start) ||
-	    (shift > start - ex_end))
-		return -EINVAL;
+	/*
+	 * In case of left shift, iterator points to start and it is increased
+	 * till we reach stop. In case of right shift, iterator points to stop
+	 * and it is decreased till we reach start.
+	 */
+	if (SHIFT == SHIFT_LEFT)
+		iterator = &start;
+	else
+		iterator = &stop;
 
 	/* Its safe to start updating extents */
-	while (start < stop_block) {
-		path = ext4_find_extent(inode, start, &path, 0);
+	while (start < stop) {
+		path = ext4_find_extent(inode, *iterator, &path, 0);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
 		depth = path->p_depth;
 		extent = path[depth].p_ext;
 		if (!extent) {
 			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
-					 (unsigned long) start);
+					 (unsigned long) *iterator);
 			return -EIO;
 		}
-		if (start > le32_to_cpu(extent->ee_block)) {
+		if (SHIFT == SHIFT_LEFT && *iterator >
+		    le32_to_cpu(extent->ee_block)) {
 			/* Hole, move to the next extent */
 			if (extent < EXT_LAST_EXTENT(path[depth].p_hdr)) {
 				path[depth].p_ext++;
 			} else {
-				start = ext4_ext_next_allocated_block(path);
+				*iterator = ext4_ext_next_allocated_block(path);
 				continue;
 			}
 		}
+
+		if (SHIFT == SHIFT_LEFT) {
+			extent = EXT_LAST_EXTENT(path[depth].p_hdr);
+			*iterator = le32_to_cpu(extent->ee_block) +
+					ext4_ext_get_actual_len(extent);
+		} else {
+			extent = EXT_FIRST_EXTENT(path[depth].p_hdr);
+			*iterator =  le32_to_cpu(extent->ee_block) > 0 ?
+				le32_to_cpu(extent->ee_block) - 1 : 0;
+			/* Update path extent in case we need to stop */
+			while (le32_to_cpu(extent->ee_block) < start)
+				extent++;
+			path[depth].p_ext = extent;
+		}
 		ret = ext4_ext_shift_path_extents(path, shift, inode,
-				handle, &start);
+				handle, SHIFT);
 		if (ret)
 			break;
 	}
@@ -5474,7 +5514,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	ext4_discard_preallocations(inode);
 
 	ret = ext4_ext_shift_extents(inode, handle, punch_stop,
-				     punch_stop - punch_start);
+				     punch_stop - punch_start, SHIFT_LEFT);
 	if (ret) {
 		up_write(&EXT4_I(inode)->i_data_sem);
 		goto out_stop;
@@ -5499,6 +5539,166 @@ out_mutex:
 	return ret;
 }
 
+/*
+ * ext4_insert_range:
+ * This function implements the FALLOC_FL_INSERT_RANGE flag of fallocate.
+ * The data blocks starting from @offset to the EOF are shifted by @len
+ * towards right to create a hole in the @inode. Inode size is increased
+ * by len bytes.
+ * Returns 0 on success, error otherwise.
+ */
+int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
+{
+	struct super_block *sb = inode->i_sb;
+	handle_t *handle;
+	struct ext4_ext_path *path;
+	struct ext4_extent *extent;
+	ext4_lblk_t offset_lblk, len_lblk, ee_start_lblk = 0;
+	unsigned int credits, ee_len;
+	int ret = 0, depth, split_flag = 0;
+	loff_t ioffset;
+
+	/* Insert range works only on fs block size aligned offsets. */
+	if (offset & (EXT4_CLUSTER_SIZE(sb) - 1) ||
+			len & (EXT4_CLUSTER_SIZE(sb) - 1))
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
+	/* Call ext4_force_commit to flush all data in case of data=journal */
+	if (ext4_should_journal_data(inode)) {
+		ret = ext4_force_commit(inode->i_sb);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Need to round down to align start offset to page size boundary
+	 * for page size > block size.
+	 */
+	ioffset = round_down(offset, PAGE_SIZE);
+
+	/* Write out all dirty pages */
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
+			LLONG_MAX);
+	if (ret)
+		return ret;
+
+	/* Take mutex lock */
+	mutex_lock(&inode->i_mutex);
+
+	/* Currently just for extent based files */
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		ret = -EOPNOTSUPP;
+		goto out_mutex;
+	}
+
+	/* Check for wrap through zero */
+	if (inode->i_size + len > inode->i_sb->s_maxbytes) {
+		ret = -EFBIG;
+		goto out_mutex;
+	}
+
+	/* Offset should be less than i_size */
+	if (offset >= i_size_read(inode)) {
+		ret = -EINVAL;
+		goto out_mutex;
+	}
+
+	truncate_pagecache(inode, ioffset);
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
+	/* Expand file to avoid data loss if there is error while shifting */
+	inode->i_size += len;
+	EXT4_I(inode)->i_disksize += len;
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+	ret = ext4_mark_inode_dirty(handle, inode);
+	if (ret)
+		goto out_stop;
+
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_discard_preallocations(inode);
+
+	path = ext4_find_extent(inode, offset_lblk, NULL, 0);
+	if (IS_ERR(path)) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	depth = ext_depth(inode);
+	extent = path[depth].p_ext;
+	if (extent) {
+		ee_start_lblk = le32_to_cpu(extent->ee_block);
+		ee_len = ext4_ext_get_actual_len(extent);
+
+		/*
+		 * If offset_lblk is not the starting block of extent, split
+		 * the extent @offset_lblk
+		 */
+		if ((offset_lblk > ee_start_lblk) &&
+				(offset_lblk < (ee_start_lblk + ee_len))) {
+			if (ext4_ext_is_unwritten(extent))
+				split_flag = EXT4_EXT_MARK_UNWRIT1 |
+					EXT4_EXT_MARK_UNWRIT2;
+			ret = ext4_split_extent_at(handle, inode, &path,
+					offset_lblk, split_flag,
+					EXT4_EX_NOCACHE |
+					EXT4_GET_BLOCKS_PRE_IO |
+					EXT4_GET_BLOCKS_METADATA_NOFAIL);
+		}
+
+		ext4_ext_drop_refs(path);
+		kfree(path);
+		if (ret < 0) {
+			up_write(&EXT4_I(inode)->i_data_sem);
+			goto out_stop;
+		}
+	}
+
+	ret = ext4_es_remove_extent(inode, offset_lblk,
+			EXT_MAX_BLOCKS - offset_lblk);
+	if (ret) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	/*
+	 * if offset_lblk lies in a hole which is at start of file, use
+	 * ee_start_lblk to shift extents
+	 */
+	ret = ext4_ext_shift_extents(inode, handle,
+		ee_start_lblk > offset_lblk ? ee_start_lblk : offset_lblk,
+		len_lblk, SHIFT_RIGHT);
+
+	up_write(&EXT4_I(inode)->i_data_sem);
+	if (IS_SYNC(inode))
+		ext4_handle_sync(handle);
+
+out_stop:
+	ext4_journal_stop(handle);
+out_dio:
+	ext4_inode_resume_unlocked_dio(inode);
+out_mutex:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
 /**
  * ext4_swap_extents - Swap extents between two inodes
  *
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index ff4bd1b..1a88c8b 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2450,6 +2450,31 @@ TRACE_EVENT(ext4_collapse_range,
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
 TRACE_EVENT(ext4_es_shrink,
 	TP_PROTO(struct super_block *sb, int nr_shrunk, u64 scan_time,
 		 int skip_precached, int nr_skipped, int retried),
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
