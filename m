Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88BDA7FF6
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 10:38:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7BBDC8F8033
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:38:19 -0800 (PST)
Received: from mail-pd0-f174.google.com (mail-pd0-f174.google.com
	[209.85.192.174]) by cuda.sgi.com with ESMTP id
	RfqP7sB6ux83MEpn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 08:38:17 -0800 (PST)
Received: by mail-pd0-f174.google.com with SMTP id z10so16526080pdj.33
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:38:17 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v5 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Date: Wed, 19 Feb 2014 01:38:09 +0900
Message-Id: <1392741489-20097-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for Ext4.

The semantics of this flag are following:
1) It collapses the range lying between offset and length by removing any data
   blocks which are present in this range and than updates all the logical
   offsets of extents beyond "offset + len" to nullify the hole created by
   removing blocks. In short, it does not leave a hole.
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned
   in case of xfs and ext4.
4) Collaspe range does not work beyond i_size.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---

Changelog
v5: Fix review comments from Lukas Czerner.
- Added checks for immutable files and swap files.
- Move inode flag checks under imutex.
- Remove an obsolete checking.
- truncate_pagecache_range can work on page size aligned byte offsets
  so alignment is not required.

v4:
- move block size aligned check from VFS layer to FS specific layer.

v3:
- fix checkpatch.pl warning

v2:
- Added check to make sure before shifting that the hole is big enough to
  contian the shift.
- Added code to make merging of extent where possible.
- Change semantics of collapse range and contain it within EOF.

 fs/ext4/ext4.h              |   3 +
 fs/ext4/extents.c           | 304 +++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/move_extent.c       |   2 +-
 include/trace/events/ext4.h |  25 ++++
 4 files changed, 332 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ece5556..ca9b115 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2755,6 +2755,7 @@ extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 extern int ext4_ext_precache(struct inode *inode);
+extern int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len);
 
 /* move_extent.c */
 extern void ext4_double_down_write_data_sem(struct inode *first,
@@ -2764,6 +2765,8 @@ extern void ext4_double_up_write_data_sem(struct inode *orig_inode,
 extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			     __u64 start_orig, __u64 start_donor,
 			     __u64 len, __u64 *moved_len);
+extern int mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
+			    struct ext4_extent **extent);
 
 /* page-io.c */
 extern int __init ext4_init_pageio(void);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74bc2d5..db0ebe4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4565,12 +4565,16 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	unsigned int credits, blkbits = inode->i_blkbits;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_COLLAPSE_RANGE))
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return ext4_punch_hole(inode, offset, len);
 
+	if (mode & FALLOC_FL_COLLAPSE_RANGE)
+		return ext4_collapse_range(inode, offset, len);
+
 	ret = ext4_convert_inline_data(inode);
 	if (ret)
 		return ret;
@@ -4869,3 +4873,301 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	ext4_es_lru_add(inode);
 	return error;
 }
+
+/*
+ * ext4_access_path:
+ * Function to access the path buffer for marking it dirty.
+ * It also checks if there are sufficient credits left in the journal handle
+ * to update path.
+ */
+static int
+ext4_access_path(handle_t *handle, struct inode *inode,
+		struct ext4_ext_path *path)
+{
+	int credits, err;
+
+	/*
+	 * Check if need to extend journal credits
+	 * 3 for leaf, sb, and inode plus 2 (bmap and group
+	 * descriptor) for each block group; assume two block
+	 * groups
+	 */
+	if (handle->h_buffer_credits < 7) {
+		credits = ext4_writepage_trans_blocks(inode);
+		err = ext4_ext_truncate_extend_restart(handle, inode, credits);
+		/* EAGAIN is success */
+		if (err && err != -EAGAIN)
+			return err;
+	}
+
+	err = ext4_ext_get_access(handle, inode, path);
+	return err;
+}
+
+/*
+ * ext4_ext_shift_path_extents:
+ * Shift the extents of a path structure lying between path[depth].p_ext
+ * and EXT_LAST_EXTENT(path[depth].p_hdr) downwards, by subtracting shift
+ * from starting block for each extent.
+ */
+static int
+ext4_ext_shift_path_extents(struct ext4_ext_path *path, ext4_lblk_t shift,
+			    struct inode *inode, handle_t *handle,
+			    ext4_lblk_t *start)
+{
+	int depth, err = 0;
+	struct ext4_extent *ex_start, *ex_last;
+	bool update = 0;
+	depth = path->p_depth;
+
+	while (depth >= 0) {
+		if (depth == path->p_depth) {
+			ex_start = path[depth].p_ext;
+			if (!ex_start)
+				return -EIO;
+
+			ex_last = EXT_LAST_EXTENT(path[depth].p_hdr);
+			if (!ex_last)
+				return -EIO;
+
+			err = ext4_access_path(handle, inode, path + depth);
+			if (err)
+				goto out;
+
+			if (ex_start == EXT_FIRST_EXTENT(path[depth].p_hdr))
+				update = 1;
+
+			*start = ex_last->ee_block +
+				ext4_ext_get_actual_len(ex_last);
+
+			while (ex_start <= ex_last) {
+				ex_start->ee_block -= shift;
+				if (ex_start >
+					EXT_FIRST_EXTENT(path[depth].p_hdr)) {
+					if (ext4_ext_try_to_merge_right(inode,
+						path, ex_start - 1))
+						ex_last--;
+				}
+				ex_start++;
+			}
+			err = ext4_ext_dirty(handle, inode, path + depth);
+			if (err)
+				goto out;
+
+			if (--depth < 0 || !update)
+				break;
+		}
+
+		/* Update index too */
+		err = ext4_access_path(handle, inode, path + depth);
+		if (err)
+			goto out;
+
+		path[depth].p_idx->ei_block -= shift;
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
+ * ext4_ext_shift_extents:
+ * All the extents which lies in the range from start to the last allocated
+ * block for the file are shifted downwards by shift blocks.
+ * On success, 0 is returned, error otherwise.
+ */
+static int
+ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
+		       ext4_lblk_t start, ext4_lblk_t shift)
+{
+	struct ext4_ext_path *path;
+	int ret = 0, depth;
+	struct ext4_extent *extent;
+	ext4_lblk_t stop_block, current_block;
+	ext4_lblk_t ex_start, ex_end;
+
+	/* Let path point to the last extent */
+	path = ext4_ext_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL, 0);
+	if (IS_ERR(path))
+		return PTR_ERR(path);
+
+	depth = path->p_depth;
+	extent = path[depth].p_ext;
+	if (!extent) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+		return ret;
+	}
+
+	stop_block = extent->ee_block + ext4_ext_get_actual_len(extent);
+	ext4_ext_drop_refs(path);
+	kfree(path);
+
+	/* Nothing to shift, if hole is at the end of file */
+	if (start >= stop_block)
+		return ret;
+
+	/*
+	 * Don't start shifting extents until we make sure the hole is big
+	 * enough to accomodate the shift.
+	 */
+	path = ext4_ext_find_extent(inode, start - 1, NULL, 0);
+	depth = path->p_depth;
+	extent =  path[depth].p_ext;
+	ex_start = extent->ee_block;
+	ex_end = extent->ee_block + ext4_ext_get_actual_len(extent);
+	ext4_ext_drop_refs(path);
+	kfree(path);
+
+	if ((start == ex_start && shift > ex_start) ||
+	    (shift > start - ex_end)) {
+		return -EINVAL;
+
+	/* Its safe to start updating extents */
+	while (start < stop_block) {
+		path = ext4_ext_find_extent(inode, start, NULL, 0);
+		if (IS_ERR(path))
+			return PTR_ERR(path);
+		depth = path->p_depth;
+		extent = path[depth].p_ext;
+		current_block = extent->ee_block;
+		if (start > current_block) {
+			/* Hole, move to the next extent */
+			ret = mext_next_extent(inode, path, &extent);
+			if (ret != 0) {
+				ext4_ext_drop_refs(path);
+				kfree(path);
+				if (ret == 1)
+					ret = 0;
+				break;
+			}
+		}
+		ret = ext4_ext_shift_path_extents(path, shift, inode,
+				handle, &start);
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
+ * ext4_collapse_range:
+ * This implements the fallocate's collapse range functionality for ext4
+ * Returns: 0 and non-zero on error.
+ */
+int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
+{
+	struct super_block *sb = inode->i_sb;
+	ext4_lblk_t punch_start, punch_stop;
+	handle_t *handle;
+	unsigned int credits;
+	loff_t new_size;
+	int ret;
+
+	BUG_ON(offset + len > i_size_read(inode));
+
+	/* Collapse range works only on fs block size aligned offsets. */
+	if (offset & (EXT4_BLOCK_SIZE(sb) - 1) ||
+	    len & (EXT4_BLOCK_SIZE(sb) - 1))
+		return -EINVAL;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	trace_ext4_collapse_range(inode, offset, len);
+
+	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
+	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
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
+	ret = ext4_es_remove_extent(inode, punch_start,
+				    EXT_MAX_BLOCKS - punch_start - 1);
+	if (ret) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	ret = ext4_ext_remove_space(inode, punch_start, punch_stop - 1);
+	if (ret) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	ret = ext4_ext_shift_extents(inode, handle, punch_stop,
+				     punch_stop - punch_start);
+	if (ret) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto out_stop;
+	}
+
+	new_size = i_size_read(inode) - len;
+	i_size_write(inode, new_size);
+	EXT4_I(inode)->i_disksize = new_size;
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
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index f39a88a..58ee7dc 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -76,7 +76,7 @@ copy_extent_status(struct ext4_extent *src, struct ext4_extent *dest)
  * ext4_ext_path structure refers to the last extent, or a negative error
  * value on failure.
  */
-static int
+int
 mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
 		      struct ext4_extent **extent)
 {
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 197d312..90e2f71 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2410,6 +2410,31 @@ TRACE_EVENT(ext4_es_shrink_exit,
 		  __entry->shrunk_nr, __entry->cache_cnt)
 );
 
+TRACE_EVENT(ext4_collapse_range,
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
1.7.11-rc0


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
