Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 05:52:46 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DCqebm003090
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 05:52:42 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6DCrtQa007487
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:53:55 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6DCqgWH479890
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:52:42 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6DCqgwv032721
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:52:42 -0400
Date: Fri, 13 Jul 2007 18:22:58 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 6/6][TAKE7] ext4: change for better extent-to-group alignment
Message-ID: <20070713125258.GF22961@amitarora.in.ibm.com>
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

From: Amit Arora <aarora@in.ibm.com>

Change on-disk format for extent to represent uninitialized/initialized extents

This change was suggested by Andreas Dilger. 
This patch changes the EXT_MAX_LEN value and extent code which marks/checks
uninitialized extents. With this change it will be possible to have
initialized extents with 2^15 blocks (earlier the max blocks we could have
was 2^15 - 1). This way we can have better extent-to-block alignment.
Now, maximum number of blocks we can have in an initialized extent is 2^15
and in an uninitialized extent is 2^15 - 1.

This patch takes care of Andreas's suggestion of using EXT_INIT_MAX_LEN
instead of 0x8000 at some places.

Signed-off-by: Amit Arora <aarora@in.ibm.com>

Index: linux-2.6.22/fs/ext4/extents.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/extents.c
+++ linux-2.6.22/fs/ext4/extents.c
@@ -1106,7 +1106,7 @@ static int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
-	unsigned short ext1_ee_len, ext2_ee_len;
+	unsigned short ext1_ee_len, ext2_ee_len, max_len;
 
 	/*
 	 * Make sure that either both extents are uninitialized, or
@@ -1115,6 +1115,11 @@ ext4_can_extents_be_merged(struct inode 
 	if (ext4_ext_is_uninitialized(ex1) ^ ext4_ext_is_uninitialized(ex2))
 		return 0;
 
+	if (ext4_ext_is_uninitialized(ex1))
+		max_len = EXT_UNINIT_MAX_LEN;
+	else
+		max_len = EXT_INIT_MAX_LEN;
+
 	ext1_ee_len = ext4_ext_get_actual_len(ex1);
 	ext2_ee_len = ext4_ext_get_actual_len(ex2);
 
@@ -1127,7 +1132,7 @@ ext4_can_extents_be_merged(struct inode 
 	 * as an RO_COMPAT feature, refuse to merge to extents if
 	 * this can result in the top bit of ee_len being set.
 	 */
-	if (ext1_ee_len + ext2_ee_len > EXT_MAX_LEN)
+	if (ext1_ee_len + ext2_ee_len > max_len)
 		return 0;
 #ifdef AGGRESSIVE_TEST
 	if (le16_to_cpu(ex1->ee_len) >= 4)
@@ -1814,7 +1819,11 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 
 		ex->ee_block = cpu_to_le32(block);
 		ex->ee_len = cpu_to_le16(num);
-		if (uninitialized)
+		/*
+		 * Do not mark uninitialized if all the blocks in the
+		 * extent have been removed.
+		 */
+		if (uninitialized && num)
 			ext4_ext_mark_uninitialized(ex);
 
 		err = ext4_ext_dirty(handle, inode, path + depth);
@@ -2307,6 +2316,19 @@ int ext4_ext_get_blocks(handle_t *handle
 	/* allocate new block */
 	goal = ext4_ext_find_goal(inode, path, iblock);
 
+	/*
+	 * See if request is beyond maximum number of blocks we can have in
+	 * a single extent. For an initialized extent this limit is
+	 * EXT_INIT_MAX_LEN and for an uninitialized extent this limit is
+	 * EXT_UNINIT_MAX_LEN.
+	 */
+	if (max_blocks > EXT_INIT_MAX_LEN &&
+	    create != EXT4_CREATE_UNINITIALIZED_EXT)
+		max_blocks = EXT_INIT_MAX_LEN;
+	else if (max_blocks > EXT_UNINIT_MAX_LEN &&
+		 create == EXT4_CREATE_UNINITIALIZED_EXT)
+		max_blocks = EXT_UNINIT_MAX_LEN;
+
 	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
 	newex.ee_block = cpu_to_le32(iblock);
 	newex.ee_len = cpu_to_le16(max_blocks);
Index: linux-2.6.22/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.22.orig/include/linux/ext4_fs_extents.h
+++ linux-2.6.22/include/linux/ext4_fs_extents.h
@@ -141,7 +141,25 @@ typedef int (*ext_prepare_callback)(stru
 
 #define EXT_MAX_BLOCK	0xffffffff
 
-#define EXT_MAX_LEN	((1UL << 15) - 1)
+/*
+ * EXT_INIT_MAX_LEN is the maximum number of blocks we can have in an
+ * initialized extent. This is 2^15 and not (2^16 - 1), since we use the
+ * MSB of ee_len field in the extent datastructure to signify if this
+ * particular extent is an initialized extent or an uninitialized (i.e.
+ * preallocated).
+ * EXT_UNINIT_MAX_LEN is the maximum number of blocks we can have in an
+ * uninitialized extent.
+ * If ee_len is <= 0x8000, it is an initialized extent. Otherwise, it is an
+ * uninitialized one. In other words, if MSB of ee_len is set, it is an
+ * uninitialized extent with only one special scenario when ee_len = 0x8000.
+ * In this case we can not have an uninitialized extent of zero length and
+ * thus we make it as a special case of initialized extent with 0x8000 length.
+ * This way we get better extent-to-group alignment for initialized extents.
+ * Hence, the maximum number of blocks we can have in an *initialized*
+ * extent is 2^15 (32768) and in an *uninitialized* extent is 2^15-1 (32767).
+ */
+#define EXT_INIT_MAX_LEN	(1UL << 15)
+#define EXT_UNINIT_MAX_LEN	(EXT_INIT_MAX_LEN - 1)
 
 
 #define EXT_FIRST_EXTENT(__hdr__) \
@@ -190,17 +208,22 @@ ext4_ext_invalidate_cache(struct inode *
 
 static inline void ext4_ext_mark_uninitialized(struct ext4_extent *ext)
 {
-	ext->ee_len |= cpu_to_le16(0x8000);
+	/* We can not have an uninitialized extent of zero length! */
+	BUG_ON((le16_to_cpu(ext->ee_len) & ~EXT_INIT_MAX_LEN) == 0);
+	ext->ee_len |= cpu_to_le16(EXT_INIT_MAX_LEN);
 }
 
 static inline int ext4_ext_is_uninitialized(struct ext4_extent *ext)
 {
-	return (int)(le16_to_cpu((ext)->ee_len) & 0x8000);
+	/* Extent with ee_len of 0x8000 is treated as an initialized extent */
+	return (le16_to_cpu(ext->ee_len) > EXT_INIT_MAX_LEN);
 }
 
 static inline int ext4_ext_get_actual_len(struct ext4_extent *ext)
 {
-	return (int)(le16_to_cpu((ext)->ee_len) & 0x7FFF);
+	return (le16_to_cpu(ext->ee_len) <= EXT_INIT_MAX_LEN ?
+		le16_to_cpu(ext->ee_len) :
+		(le16_to_cpu(ext->ee_len) - EXT_INIT_MAX_LEN));
 }
 
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
