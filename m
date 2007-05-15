Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 13:13:37 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4FKDUfB025378
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 13:13:31 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l4FK9pSH002775
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 16:09:51 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4FKDQ8U269646
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 14:13:26 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4FKDPw6006804
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 14:13:26 -0600
Date: Wed, 16 May 2007 01:43:30 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 3/5][TAKE3] ext4: Extent overlap bugfix
Message-ID: <20070515201330.GC5834@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070515193722.GA3487@amitarora.in.ibm.com> <20070515195421.GA2948@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515195421.GA2948@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

This patch adds a check for overlap of extents and cuts short the
new extent to be inserted, if there is a chance of overlap.

Changelog:
---------
Note: The changes below are from the initial post (dated 26th April,
2007) and _not_ from TAKE2. The only difference from TAKE2 is the kernel
version on which this patch is based. TAKE2 was based on 2.6.21 and this
is based on 2.6.22-rc1.
As suggested by Andrew, a check for wrap though zero has been added.

Here is the new patch:

Signed-off-by: Amit Arora <aarora@in.ibm.com>
---
 fs/ext4/extents.c               |   60 ++++++++++++++++++++++++++++++++++++++--
 include/linux/ext4_fs_extents.h |    1 
 2 files changed, 59 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc1/fs/ext4/extents.c
===================================================================
--- linux-2.6.22-rc1.orig/fs/ext4/extents.c
+++ linux-2.6.22-rc1/fs/ext4/extents.c
@@ -1128,6 +1128,55 @@ ext4_can_extents_be_merged(struct inode 
 }
 
 /*
+ * check if a portion of the "newext" extent overlaps with an
+ * existing extent.
+ *
+ * If there is an overlap discovered, it updates the length of the newext
+ * such that there will be no overlap, and then returns 1.
+ * If there is no overlap found, it returns 0.
+ */
+unsigned int ext4_ext_check_overlap(struct inode *inode,
+				    struct ext4_extent *newext,
+				    struct ext4_ext_path *path)
+{
+	unsigned long b1, b2;
+	unsigned int depth, len1;
+	unsigned int ret = 0;
+
+	b1 = le32_to_cpu(newext->ee_block);
+	len1 = le16_to_cpu(newext->ee_len);
+	depth = ext_depth(inode);
+	if (!path[depth].p_ext)
+		goto out;
+	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
+
+	/*
+	 * get the next allocated block if the extent in the path
+	 * is before the requested block(s) 
+	 */
+	if (b2 < b1) {
+		b2 = ext4_ext_next_allocated_block(path);
+		if (b2 == EXT_MAX_BLOCK)
+			goto out;
+	}
+
+	/* check for wrap through zero */
+	if (b1 + len1 < b1) {
+		len1 = EXT_MAX_BLOCK - b1;
+		newext->ee_len = cpu_to_le16(len1);
+		ret = 1;
+	}
+
+	/* check for overlap */
+	if (b1 + len1 > b2) {
+		newext->ee_len = cpu_to_le16(b2 - b1);
+		ret = 1;
+	}
+out:
+	return ret;
+}
+
+/*
  * ext4_ext_insert_extent:
  * tries to merge requsted extent into the existing extent or
  * inserts requested extent as new one into the tree,
@@ -2031,7 +2080,15 @@ int ext4_ext_get_blocks(handle_t *handle
 
 	/* allocate new block */
 	goal = ext4_ext_find_goal(inode, path, iblock);
-	allocated = max_blocks;
+
+	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
+	newex.ee_block = cpu_to_le32(iblock);
+	newex.ee_len = cpu_to_le16(max_blocks);
+	err = ext4_ext_check_overlap(inode, &newex, path);
+	if (err)
+		allocated = le16_to_cpu(newex.ee_len);
+	else
+		allocated = max_blocks;
 	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
 	if (!newblock)
 		goto out2;
@@ -2039,7 +2096,6 @@ int ext4_ext_get_blocks(handle_t *handle
 			goal, newblock, allocated);
 
 	/* try to insert new extent into found leaf and return */
-	newex.ee_block = cpu_to_le32(iblock);
 	ext4_ext_store_pblock(&newex, newblock);
 	newex.ee_len = cpu_to_le16(allocated);
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
Index: linux-2.6.22-rc1/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.22-rc1.orig/include/linux/ext4_fs_extents.h
+++ linux-2.6.22-rc1/include/linux/ext4_fs_extents.h
@@ -190,6 +190,7 @@ ext4_ext_invalidate_cache(struct inode *
 
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
+extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
 extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
