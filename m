Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 05:51:46 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DCpgbm001955
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 05:51:43 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6DCqueu005665
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:52:56 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6DCpiEl367848
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:51:44 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6DCphLQ028678
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:51:44 -0400
Date: Fri, 13 Jul 2007 18:22:00 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 5/6][TAKE7] ext4: write support for preallocated blocks
Message-ID: <20070713125200.GE22961@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713123816.GA18000@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com

From:  Amit Arora <aarora@in.ibm.com>

write support for preallocated blocks

This patch adds write support to the uninitialized extents that get
created when a preallocation is done using fallocate(). It takes care of
splitting the extents into multiple (upto three) extents and merging the
new split extents with neighbouring ones, if possible.

Signed-off-by: Amit Arora <aarora@in.ibm.com>

Index: linux-2.6.22/fs/ext4/extents.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/extents.c
+++ linux-2.6.22/fs/ext4/extents.c
@@ -1140,6 +1140,53 @@ ext4_can_extents_be_merged(struct inode 
 }
 
 /*
+ * This function tries to merge the "ex" extent to the next extent in the tree.
+ * It always tries to merge towards right. If you want to merge towards
+ * left, pass "ex - 1" as argument instead of "ex".
+ * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
+ * 1 if they got merged.
+ */
+int ext4_ext_try_to_merge(struct inode *inode,
+			  struct ext4_ext_path *path,
+			  struct ext4_extent *ex)
+{
+	struct ext4_extent_header *eh;
+	unsigned int depth, len;
+	int merge_done = 0;
+	int uninitialized = 0;
+
+	depth = ext_depth(inode);
+	BUG_ON(path[depth].p_hdr == NULL);
+	eh = path[depth].p_hdr;
+
+	while (ex < EXT_LAST_EXTENT(eh)) {
+		if (!ext4_can_extents_be_merged(inode, ex, ex + 1))
+			break;
+		/* merge with next extent! */
+		if (ext4_ext_is_uninitialized(ex))
+			uninitialized = 1;
+		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
+				+ ext4_ext_get_actual_len(ex + 1));
+		if (uninitialized)
+			ext4_ext_mark_uninitialized(ex);
+
+		if (ex + 1 < EXT_LAST_EXTENT(eh)) {
+			len = (EXT_LAST_EXTENT(eh) - ex - 1)
+				* sizeof(struct ext4_extent);
+			memmove(ex + 1, ex + 2, len);
+		}
+		eh->eh_entries = cpu_to_le16(le16_to_cpu(eh->eh_entries) - 1);
+		merge_done = 1;
+		WARN_ON(eh->eh_entries == 0);
+		if (!eh->eh_entries)
+			ext4_error(inode->i_sb, "ext4_ext_try_to_merge",
+			   "inode#%lu, eh->eh_entries = 0!", inode->i_ino);
+	}
+
+	return merge_done;
+}
+
+/*
  * check if a portion of the "newext" extent overlaps with an
  * existing extent.
  *
@@ -1327,25 +1374,7 @@ has_space:
 
 merge:
 	/* try to merge extents to the right */
-	while (nearex < EXT_LAST_EXTENT(eh)) {
-		if (!ext4_can_extents_be_merged(inode, nearex, nearex + 1))
-			break;
-		/* merge with next extent! */
-		if (ext4_ext_is_uninitialized(nearex))
-			uninitialized = 1;
-		nearex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(nearex)
-					+ ext4_ext_get_actual_len(nearex + 1));
-		if (uninitialized)
-			ext4_ext_mark_uninitialized(nearex);
-
-		if (nearex + 1 < EXT_LAST_EXTENT(eh)) {
-			len = (EXT_LAST_EXTENT(eh) - nearex - 1)
-					* sizeof(struct ext4_extent);
-			memmove(nearex + 1, nearex + 2, len);
-		}
-		eh->eh_entries = cpu_to_le16(le16_to_cpu(eh->eh_entries)-1);
-		BUG_ON(eh->eh_entries == 0);
-	}
+	ext4_ext_try_to_merge(inode, path, nearex);
 
 	/* try to merge extents to the left */
 
@@ -2011,15 +2040,158 @@ void ext4_ext_release(struct super_block
 #endif
 }
 
+/*
+ * This function is called by ext4_ext_get_blocks() if someone tries to write
+ * to an uninitialized extent. It may result in splitting the uninitialized
+ * extent into multiple extents (upto three - one initialized and two
+ * uninitialized).
+ * There are three possibilities:
+ *   a> There is no split required: Entire extent should be initialized
+ *   b> Splits in two extents: Write is happening at either end of the extent
+ *   c> Splits in three extents: Somone is writing in middle of the extent
+ */
+int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
+					struct ext4_ext_path *path,
+					ext4_fsblk_t iblock,
+					unsigned long max_blocks)
+{
+	struct ext4_extent *ex, newex;
+	struct ext4_extent *ex1 = NULL;
+	struct ext4_extent *ex2 = NULL;
+	struct ext4_extent *ex3 = NULL;
+	struct ext4_extent_header *eh;
+	unsigned int allocated, ee_block, ee_len, depth;
+	ext4_fsblk_t newblock;
+	int err = 0;
+	int ret = 0;
+
+	depth = ext_depth(inode);
+	eh = path[depth].p_hdr;
+	ex = path[depth].p_ext;
+	ee_block = le32_to_cpu(ex->ee_block);
+	ee_len = ext4_ext_get_actual_len(ex);
+	allocated = ee_len - (iblock - ee_block);
+	newblock = iblock - ee_block + ext_pblock(ex);
+	ex2 = ex;
+
+	/* ex1: ee_block to iblock - 1 : uninitialized */
+	if (iblock > ee_block) {
+		ex1 = ex;
+		ex1->ee_len = cpu_to_le16(iblock - ee_block);
+		ext4_ext_mark_uninitialized(ex1);
+		ex2 = &newex;
+	}
+	/*
+	 * for sanity, update the length of the ex2 extent before
+	 * we insert ex3, if ex1 is NULL. This is to avoid temporary
+	 * overlap of blocks.
+	 */
+	if (!ex1 && allocated > max_blocks)
+		ex2->ee_len = cpu_to_le16(max_blocks);
+	/* ex3: to ee_block + ee_len : uninitialised */
+	if (allocated > max_blocks) {
+		unsigned int newdepth;
+		ex3 = &newex;
+		ex3->ee_block = cpu_to_le32(iblock + max_blocks);
+		ext4_ext_store_pblock(ex3, newblock + max_blocks);
+		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
+		ext4_ext_mark_uninitialized(ex3);
+		err = ext4_ext_insert_extent(handle, inode, path, ex3);
+		if (err)
+			goto out;
+		/*
+		 * The depth, and hence eh & ex might change
+		 * as part of the insert above.
+		 */
+		newdepth = ext_depth(inode);
+		if (newdepth != depth) {
+			depth = newdepth;
+			path = ext4_ext_find_extent(inode, iblock, NULL);
+			if (IS_ERR(path)) {
+				err = PTR_ERR(path);
+				path = NULL;
+				goto out;
+			}
+			eh = path[depth].p_hdr;
+			ex = path[depth].p_ext;
+			if (ex2 != &newex)
+				ex2 = ex;
+		}
+		allocated = max_blocks;
+	}
+	/*
+	 * If there was a change of depth as part of the
+	 * insertion of ex3 above, we need to update the length
+	 * of the ex1 extent again here
+	 */
+	if (ex1 && ex1 != ex) {
+		ex1 = ex;
+		ex1->ee_len = cpu_to_le16(iblock - ee_block);
+		ext4_ext_mark_uninitialized(ex1);
+		ex2 = &newex;
+	}
+	/* ex2: iblock to iblock + maxblocks-1 : initialised */
+	ex2->ee_block = cpu_to_le32(iblock);
+	ex2->ee_start = cpu_to_le32(newblock);
+	ext4_ext_store_pblock(ex2, newblock);
+	ex2->ee_len = cpu_to_le16(allocated);
+	if (ex2 != ex)
+		goto insert;
+	err = ext4_ext_get_access(handle, inode, path + depth);
+	if (err)
+		goto out;
+	/*
+	 * New (initialized) extent starts from the first block
+	 * in the current extent. i.e., ex2 == ex
+	 * We have to see if it can be merged with the extent
+	 * on the left.
+	 */
+	if (ex2 > EXT_FIRST_EXTENT(eh)) {
+		/*
+		 * To merge left, pass "ex2 - 1" to try_to_merge(),
+		 * since it merges towards right _only_.
+		 */
+		ret = ext4_ext_try_to_merge(inode, path, ex2 - 1);
+		if (ret) {
+			err = ext4_ext_correct_indexes(handle, inode, path);
+			if (err)
+				goto out;
+			depth = ext_depth(inode);
+			ex2--;
+		}
+	}
+	/*
+	 * Try to Merge towards right. This might be required
+	 * only when the whole extent is being written to.
+	 * i.e. ex2 == ex and ex3 == NULL.
+	 */
+	if (!ex3) {
+		ret = ext4_ext_try_to_merge(inode, path, ex2);
+		if (ret) {
+			err = ext4_ext_correct_indexes(handle, inode, path);
+			if (err)
+				goto out;
+		}
+	}
+	/* Mark modified extent as dirty */
+	err = ext4_ext_dirty(handle, inode, path + depth);
+	goto out;
+insert:
+	err = ext4_ext_insert_extent(handle, inode, path, &newex);
+out:
+	return err ? err : allocated;
+}
+
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
 			int create, int extend_disksize)
 {
 	struct ext4_ext_path *path = NULL;
+	struct ext4_extent_header *eh;
 	struct ext4_extent newex, *ex;
 	ext4_fsblk_t goal, newblock;
-	int err = 0, depth;
+	int err = 0, depth, ret;
 	unsigned long allocated = 0;
 
 	__clear_bit(BH_New, &bh_result->b_state);
@@ -2032,8 +2204,10 @@ int ext4_ext_get_blocks(handle_t *handle
 	if (goal) {
 		if (goal == EXT4_EXT_CACHE_GAP) {
 			if (!create) {
-				/* block isn't allocated yet and
-				 * user doesn't want to allocate it */
+				/*
+				 * block isn't allocated yet and
+				 * user doesn't want to allocate it
+				 */
 				goto out2;
 			}
 			/* we should allocate requested block */
@@ -2067,6 +2241,7 @@ int ext4_ext_get_blocks(handle_t *handle
 	 * this is why assert can't be put in ext4_ext_find_extent()
 	 */
 	BUG_ON(path[depth].p_ext == NULL && depth != 0);
+	eh = path[depth].p_hdr;
 
 	ex = path[depth].p_ext;
 	if (ex) {
@@ -2075,13 +2250,9 @@ int ext4_ext_get_blocks(handle_t *handle
 		unsigned short ee_len;
 
 		/*
-		 * Allow future support for preallocated extents to be added
-		 * as an RO_COMPAT feature:
 		 * Uninitialized extents are treated as holes, except that
-		 * we avoid (fail) allocating new blocks during a write.
+		 * we split out initialized portions during a write.
 		 */
-		if (le16_to_cpu(ex->ee_len) > EXT_MAX_LEN)
-			goto out2;
 		ee_len = ext4_ext_get_actual_len(ex);
 		/* if found extent covers block, simply return it */
 		if (iblock >= ee_block && iblock < ee_block + ee_len) {
@@ -2090,12 +2261,27 @@ int ext4_ext_get_blocks(handle_t *handle
 			allocated = ee_len - (iblock - ee_block);
 			ext_debug("%d fit into %lu:%d -> %llu\n", (int) iblock,
 					ee_block, ee_len, newblock);
+
 			/* Do not put uninitialized extent in the cache */
-			if (!ext4_ext_is_uninitialized(ex))
+			if (!ext4_ext_is_uninitialized(ex)) {
 				ext4_ext_put_in_cache(inode, ee_block,
 							ee_len, ee_start,
 							EXT4_EXT_CACHE_EXTENT);
-			goto out;
+				goto out;
+			}
+			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
+				goto out;
+			if (!create)
+				goto out2;
+
+			ret = ext4_ext_convert_to_initialized(handle, inode,
+								path, iblock,
+								max_blocks);
+			if (ret <= 0)
+				goto out2;
+			else
+				allocated = ret;
+			goto outnew;
 		}
 	}
 
@@ -2104,8 +2290,10 @@ int ext4_ext_get_blocks(handle_t *handle
 	 * we couldn't try to create block if create flag is zero
 	 */
 	if (!create) {
-		/* put just found gap into cache to speed up
-		 * subsequent requests */
+		/*
+		 * put just found gap into cache to speed up
+		 * subsequent requests
+		 */
 		ext4_ext_put_gap_in_cache(inode, path, iblock);
 		goto out2;
 	}
@@ -2151,6 +2339,7 @@ int ext4_ext_get_blocks(handle_t *handle
 
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
+outnew:
 	__set_bit(BH_New, &bh_result->b_state);
 
 	/* Cache only when it is _not_ an uninitialized extent */
@@ -2220,7 +2409,8 @@ void ext4_ext_truncate(struct inode * in
 	err = ext4_ext_remove_space(inode, last_block);
 
 	/* In a multi-transaction truncate, we only make the final
-	 * transaction synchronous. */
+	 * transaction synchronous.
+	 */
 	if (IS_SYNC(inode))
 		handle->h_sync = 1;
 
Index: linux-2.6.22/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.22.orig/include/linux/ext4_fs_extents.h
+++ linux-2.6.22/include/linux/ext4_fs_extents.h
@@ -205,6 +205,9 @@ static inline int ext4_ext_get_actual_le
 
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
+extern int ext4_ext_try_to_merge(struct inode *inode,
+				 struct ext4_ext_path *path,
+				 struct ext4_extent *);
 extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
