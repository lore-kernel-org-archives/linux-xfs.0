Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 11:11:00 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3QIAufB007236
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 11:10:57 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QIAt0h001522
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 14:10:55 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QIAtlK507150
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 14:10:55 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QIAsd8006026
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 14:10:55 -0400
Date: Thu, 26 Apr 2007 23:41:01 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 3/5] ext4: Extent overlap bugfix
Message-ID: <20070426181101.GC7209@amitarora.in.ibm.com>
References: <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426175056.GA25321@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

This is a fix for an extent-overlap bug. The fallocate() implementation
on ext4 depends on this bugfix. Though this fix had been posted earlier,
but because it is still not part of mainline code, I have attached it
here too.

Signed-off-by: Amit Arora <aarora@in.ibm.com>
---
 fs/ext4/extents.c               |   50 ++++++++++++++++++++++++++++++++++++++--
 include/linux/ext4_fs_extents.h |    1 
 2 files changed, 49 insertions(+), 2 deletions(-)

Index: linux-2.6.21/fs/ext4/extents.c
===================================================================
--- linux-2.6.21.orig/fs/ext4/extents.c
+++ linux-2.6.21/fs/ext4/extents.c
@@ -1129,6 +1129,45 @@ ext4_can_extents_be_merged(struct inode 
 }
 
 /*
+ * ext4_ext_check_overlap:
+ * check if a portion of the "newext" extent overlaps with an
+ * existing extent.
+ *
+ * If there is an overlap discovered, it updates the length of the newext
+ * such that there will be no overlap, and then returns 1.
+ * If there is no overlap found, it returns 0.
+ */
+unsigned int ext4_ext_check_overlap(struct inode *inode,
+					struct ext4_extent *newext,
+					struct ext4_ext_path *path)
+{
+	unsigned long b1, b2;
+	unsigned int depth, len1;
+
+	b1 = le32_to_cpu(newext->ee_block);
+	len1 = le16_to_cpu(newext->ee_len);
+	depth = ext_depth(inode);
+	if (!path[depth].p_ext)
+		goto out;
+	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
+
+	/* get the next allocated block if the extent in the path
+	 * is before the requested block(s) */
+	if (b2 < b1) {
+		b2 = ext4_ext_next_allocated_block(path);
+		if (b2 == EXT_MAX_BLOCK)
+			goto out;
+	}
+
+	if (b1 + len1 > b2) {
+		newext->ee_len = cpu_to_le16(b2 - b1);
+		return 1;
+	}
+out:
+	return 0;
+}
+
+/*
  * ext4_ext_insert_extent:
  * tries to merge requsted extent into the existing extent or
  * inserts requested extent as new one into the tree,
@@ -2032,7 +2071,15 @@ int ext4_ext_get_blocks(handle_t *handle
 
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
@@ -2040,7 +2087,6 @@ int ext4_ext_get_blocks(handle_t *handle
 			goal, newblock, allocated);
 
 	/* try to insert new extent into found leaf and return */
-	newex.ee_block = cpu_to_le32(iblock);
 	ext4_ext_store_pblock(&newex, newblock);
 	newex.ee_len = cpu_to_le16(allocated);
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
Index: linux-2.6.21/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.21.orig/include/linux/ext4_fs_extents.h
+++ linux-2.6.21/include/linux/ext4_fs_extents.h
@@ -190,6 +190,7 @@ ext4_ext_invalidate_cache(struct inode *
 
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
+extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
 extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
