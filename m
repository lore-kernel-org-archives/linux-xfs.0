Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D5B667F81
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3DB59AC00C
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jAggRozEroorC69q for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:45 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVt-0003vJ-1v
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVn-0001LP-7W
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 25/48] xfs_repair: update for dir/attr crc format changes.
Date: Fri,  7 Jun 2013 10:25:48 +1000
Message-Id: <1370564771-4929-26-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_attr_leaf.h   |    2 +
 include/xfs_dir2_format.h |    3 ++
 libxfs/xfs_dir2_priv.h    |    2 -
 repair/attr_repair.c      |   77 +++++++++++++++++++++++----------------
 repair/dir2.c             |   43 +++++++++++++---------
 repair/dir2.h             |    6 +--
 repair/phase6.c           |   89 ++++++++++++++++++++++++---------------------
 7 files changed, 126 insertions(+), 96 deletions(-)

diff --git a/include/xfs_attr_leaf.h b/include/xfs_attr_leaf.h
index f9d7846..b3e93bb 100644
--- a/include/xfs_attr_leaf.h
+++ b/include/xfs_attr_leaf.h
@@ -332,6 +332,8 @@ int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			struct xfs_buf **bpp);
 void	xfs_attr3_leaf_hdr_from_disk(struct xfs_attr3_icleaf_hdr *to,
 				     struct xfs_attr_leafblock *from);
+void	xfs_attr3_leaf_hdr_to_disk(struct xfs_attr_leafblock *to,
+				   struct xfs_attr3_icleaf_hdr *from);
 
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 
diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
index 6dc884a..47ef5f9 100644
--- a/include/xfs_dir2_format.h
+++ b/include/xfs_dir2_format.h
@@ -512,6 +512,9 @@ struct xfs_dir3_leaf {
 
 #define XFS_DIR3_LEAF_CRC_OFF  offsetof(struct xfs_dir3_leaf_hdr, info.crc)
 
+extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
+		struct xfs_dir2_leaf *from);
+
 static inline int
 xfs_dir3_leaf_hdr_size(struct xfs_dir2_leaf *lp)
 {
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 6743eda..7af3e92 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -104,8 +104,6 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
 		int lowstale, int highstale, int *lfloglow, int *lfloghigh);
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
-extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
-		struct xfs_dir2_leaf *from);
 extern void xfs_dir3_leaf_hdr_to_disk(struct xfs_dir2_leaf *to,
 		struct xfs_dir3_icleaf_hdr *from);
 extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp,
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 13e9034..d42b85f 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -187,7 +187,8 @@ traverse_int_dablock(xfs_mount_t	*mp,
 		btree = xfs_da3_node_tree_p(node);
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 
-		if (nodehdr.magic != XFS_DA_NODE_MAGIC)  {
+		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
+		    nodehdr.magic != XFS_DA3_NODE_MAGIC)  {
 			do_warn(_("bad dir/attr magic number in inode %" PRIu64 ", "
 				  "file bno = %u, fsbno = %" PRIu64 "\n"),
 				da_cursor->ino, bno, fsbno);
@@ -568,7 +569,8 @@ verify_da_path(xfs_mount_t	*mp,
 		 * entry count, verify level
 		 */
 		bad = 0;
-		if (XFS_DA_NODE_MAGIC != nodehdr.magic) {
+		if (nodehdr.magic != XFS_DA_NODE_MAGIC ||
+		    nodehdr.magic != XFS_DA3_NODE_MAGIC)  {
 			do_warn(
 	_("bad magic number %x in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
 				nodehdr.magic,
@@ -1139,27 +1141,29 @@ process_leaf_attr_block(
 	xfs_attr_leaf_entry_t *entry;
 	int  i, start, stop, clearit, usedbs, firstb, thissize;
 	da_freemap_t *attr_freemap;
+	struct xfs_attr3_icleaf_hdr leafhdr;
 
+	xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
 	clearit = usedbs = 0;
 	*repair = 0;
 	firstb = mp->m_sb.sb_blocksize;
-	stop = sizeof(xfs_attr_leaf_hdr_t);
+	stop = xfs_attr3_leaf_hdr_size(leaf);
 
 	/* does the count look sorta valid? */
-	if (be16_to_cpu(leaf->hdr.count) * sizeof(xfs_attr_leaf_entry_t)
-			+ sizeof(xfs_attr_leaf_hdr_t) > XFS_LBSIZE(mp)) {
+	if (leafhdr.count * sizeof(xfs_attr_leaf_entry_t) + stop >
+							XFS_LBSIZE(mp)) {
 		do_warn(
 	_("bad attribute count %d in attr block %u, inode %" PRIu64 "\n"),
-			be16_to_cpu(leaf->hdr.count), da_bno, ino);
-		return (1);
+			leafhdr.count, da_bno, ino);
+		return 1;
 	}
 
 	attr_freemap = alloc_da_freemap(mp);
 	(void) set_da_freemap(mp, attr_freemap, 0, stop);
 
 	/* go thru each entry checking for problems */
-	for (i = 0, entry = &leaf->entries[0]; 
-			i < be16_to_cpu(leaf->hdr.count); i++, entry++) {
+	for (i = 0, entry = xfs_attr3_leaf_entryp(leaf);
+			i < leafhdr.count; i++, entry++) {
 
 		/* check if index is within some boundary. */
 		if (be16_to_cpu(entry->nameidx) > XFS_LBSIZE(mp)) {
@@ -1180,7 +1184,7 @@ process_leaf_attr_block(
 		}
 
 		/* mark the entry used */
-		start = (__psint_t)&leaf->entries[i] - (__psint_t)leaf;
+		start = (__psint_t)entry - (__psint_t)leaf;
 		stop = start + sizeof(xfs_attr_leaf_entry_t);
 		if (set_da_freemap(mp, attr_freemap, start, stop))  {
 			do_warn(
@@ -1226,40 +1230,40 @@ process_leaf_attr_block(
 		 * since the block will get compacted anyhow by the kernel.
 		 */
 
-		if ((leaf->hdr.holes == 0 && 
-				firstb != be16_to_cpu(leaf->hdr.firstused)) ||
-		    		be16_to_cpu(leaf->hdr.firstused) > firstb)  {
+		if ((leafhdr.holes == 0 && 
+				firstb != leafhdr.firstused) ||
+		    		leafhdr.firstused > firstb)  {
 			if (!no_modify)  {
 				do_warn(
 	_("- resetting first used heap value from %d to %d in "
 	  "block %u of attribute fork of inode %" PRIu64 "\n"),
-					be16_to_cpu(leaf->hdr.firstused), 
+					leafhdr.firstused, 
 					firstb, da_bno, ino);
-				leaf->hdr.firstused = cpu_to_be16(firstb);
+				leafhdr.firstused = firstb;
 				*repair = 1;
 			} else  {
 				do_warn(
 	_("- would reset first used value from %d to %d in "
 	  "block %u of attribute fork of inode %" PRIu64 "\n"),
-					be16_to_cpu(leaf->hdr.firstused), 
+					leafhdr.firstused, 
 					firstb, da_bno, ino);
 			}
 		}
 
-		if (usedbs != be16_to_cpu(leaf->hdr.usedbytes))  {
+		if (usedbs != leafhdr.usedbytes)  {
 			if (!no_modify)  {
 				do_warn(
 	_("- resetting usedbytes cnt from %d to %d in "
 	  "block %u of attribute fork of inode %" PRIu64 "\n"),
-					be16_to_cpu(leaf->hdr.usedbytes), 
+					leafhdr.usedbytes, 
 					usedbs, da_bno, ino);
-				leaf->hdr.usedbytes = cpu_to_be16(usedbs);
+				leafhdr.usedbytes = usedbs;
 				*repair = 1;
 			} else  {
 				do_warn(
 	_("- would reset usedbytes cnt from %d to %d in "
 	  "block %u of attribute fork of %" PRIu64 "\n"),
-					be16_to_cpu(leaf->hdr.usedbytes), 
+					leafhdr.usedbytes, 
 					usedbs, da_bno, ino);
 			}
 		}
@@ -1271,6 +1275,8 @@ process_leaf_attr_block(
 		* we can add it then.
 		*/
 	}
+	if (*repair)
+		xfs_attr3_leaf_hdr_to_disk(leaf, &leafhdr);
 
 	free(attr_freemap);
 	return (clearit);  /* and repair */
@@ -1293,6 +1299,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 	xfs_dablk_t		prev_bno;
 	xfs_dahash_t		current_hashval = 0;
 	xfs_dahash_t		greatest_hashval;
+	struct xfs_attr3_icleaf_hdr leafhdr;
 
 	da_bno = da_cursor->level[0].bno;
 	ino = da_cursor->ino;
@@ -1323,13 +1330,15 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 			goto error_out;
 		}
 
-		leaf = (xfs_attr_leafblock_t *)XFS_BUF_PTR(bp);
+		leaf = bp->b_addr;
+		xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
 
 		/* check magic number for leaf directory btree block */
-		if (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC) {
+		if (!(leafhdr.magic == XFS_ATTR_LEAF_MAGIC ||
+		      leafhdr.magic == XFS_ATTR3_LEAF_MAGIC)) {
 			do_warn(
 	_("bad attribute leaf magic %#x for inode %" PRIu64 "\n"),
-				 leaf->hdr.info.magic, ino);
+				 leafhdr.magic, ino);
 			libxfs_putbuf(bp);
 			goto error_out;
 		}
@@ -1354,10 +1363,10 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		da_cursor->level[0].hashval = greatest_hashval;
 		da_cursor->level[0].bp = bp;
 		da_cursor->level[0].bno = da_bno;
-		da_cursor->level[0].index = be16_to_cpu(leaf->hdr.count);
+		da_cursor->level[0].index = leafhdr.count;
 		da_cursor->level[0].dirty = repair;
 
-		if (be32_to_cpu(leaf->hdr.info.back) != prev_bno)  {
+		if (leafhdr.back != prev_bno)  {
 			do_warn(
 	_("bad sibling back pointer for block %u in attribute fork for inode %" PRIu64 "\n"),
 				da_bno, ino);
@@ -1366,7 +1375,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		}
 
 		prev_bno = da_bno;
-		da_bno = be32_to_cpu(leaf->hdr.info.forw);
+		da_bno = leafhdr.forw;
 
 		if (da_bno != 0 && verify_da_path(mp, da_cursor, 0))  {
 			libxfs_putbuf(bp);
@@ -1475,6 +1484,7 @@ process_longform_attr(
 	xfs_buf_t	*bp;
 	xfs_dahash_t	next_hashval;
 	int		repairlinks = 0;
+	struct xfs_attr3_icleaf_hdr leafhdr;
 
 	*repair = 0;
 
@@ -1497,7 +1507,7 @@ process_longform_attr(
 	}
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), 0, NULL);
+				XFS_FSB_TO_BB(mp, 1), 0, &xfs_da3_node_buf_ops);
 	if (!bp) {
 		do_warn(
 	_("can't read block 0 of inode %" PRIu64 " attribute fork\n"),
@@ -1507,19 +1517,20 @@ process_longform_attr(
 
 	/* verify leaf block */
 	leaf = (xfs_attr_leafblock_t *)XFS_BUF_PTR(bp);
+	xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
 
 	/* check sibling pointers in leaf block or root block 0 before
 	* we have to release the btree block
 	*/
-	if (be32_to_cpu(leaf->hdr.info.forw) != 0 || 
-				be32_to_cpu(leaf->hdr.info.back) != 0)  {
+	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
 		if (!no_modify)  {
 			do_warn(
 	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
 				ino);
 			repairlinks = 1;
-			leaf->hdr.info.forw = cpu_to_be32(0);
-			leaf->hdr.info.back = cpu_to_be32(0);
+			leafhdr.forw = 0;
+			leafhdr.back = 0;
+			xfs_attr3_leaf_hdr_to_disk(leaf, &leafhdr);
 		} else  {
 			do_warn(
 	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
@@ -1531,8 +1542,9 @@ process_longform_attr(
 	 * it's possible to have a node or leaf attribute in either an
 	 * extent format or btree format attribute fork.
 	 */
-	switch (be16_to_cpu(leaf->hdr.info.magic)) {
+	switch (leafhdr.magic) {
 	case XFS_ATTR_LEAF_MAGIC:	/* leaf-form attribute */
+	case XFS_ATTR3_LEAF_MAGIC:
 		if (process_leaf_attr_block(mp, leaf, 0, ino, blkmap,
 				0, &next_hashval, repair)) {
 			/* the block is bad.  lose the attribute fork. */
@@ -1543,6 +1555,7 @@ process_longform_attr(
 		break;
 
 	case XFS_DA_NODE_MAGIC:		/* btree-form attribute */
+	case XFS_DA3_NODE_MAGIC:
 		/* must do this now, to release block 0 before the traversal */
 		if (repairlinks) {
 			*repair = 1;
diff --git a/repair/dir2.c b/repair/dir2.c
index a71a276..e41c5f9 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -186,7 +186,8 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 		node = bp->b_addr;
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 
-		if (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC)  {
+		if (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC ||
+		    nodehdr.magic == XFS_DIR3_LEAFN_MAGIC)  {
 			if ( i != -1 ) {
 				do_warn(
 _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
@@ -195,7 +196,8 @@ _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
 			*rbno = 0;
 			libxfs_putbuf(bp);
 			return(1);
-		} else if (nodehdr.magic != XFS_DA_NODE_MAGIC)  {
+		} else if (!(nodehdr.magic == XFS_DA_NODE_MAGIC ||
+			     nodehdr.magic == XFS_DA3_NODE_MAGIC))  {
 			libxfs_putbuf(bp);
 			do_warn(
 _("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
@@ -556,7 +558,8 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 		 * entry count, verify level
 		 */
 		bad = 0;
-		if (XFS_DA_NODE_MAGIC != nodehdr.magic) {
+		if (!(nodehdr.magic == XFS_DA_NODE_MAGIC ||
+		      nodehdr.magic == XFS_DA3_NODE_MAGIC)) {
 			do_warn(
 _("bad magic number %x in block %u for directory inode %" PRIu64 "\n"),
 				nodehdr.magic,
@@ -1219,8 +1222,8 @@ process_dir2_data(
 	xfs_ino_t		ent_ino;
 
 	d = bp->b_addr;
-	bf = d->hdr.bestfree;
-	ptr = (char *)d->u;
+	bf = xfs_dir3_data_bestfree_p(&d->hdr);
+	ptr = (char *)xfs_dir3_data_entry_p(&d->hdr);
 	badbest = lastfree = freeseen = 0;
 	if (be16_to_cpu(bf[0].length) == 0) {
 		badbest |= be16_to_cpu(bf[0].offset) != 0;
@@ -1286,7 +1289,7 @@ process_dir2_data(
 			do_warn(_("\twould junk block\n"));
 		return 1;
 	}
-	ptr = (char *)d->u;
+	ptr = (char *)xfs_dir3_data_entry_p(&d->hdr);
 	/*
 	 * Process the entries now.
 	 */
@@ -1595,7 +1598,8 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 	 * Verify the block
 	 */
 	block = bp->b_addr;
-	if (be32_to_cpu(block->hdr.magic) != XFS_DIR2_BLOCK_MAGIC)
+	if (!(be32_to_cpu(block->hdr.magic) == XFS_DIR2_BLOCK_MAGIC ||
+	      be32_to_cpu(block->hdr.magic) == XFS_DIR3_BLOCK_MAGIC))
 		do_warn(
 _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n"),
 			be32_to_cpu(block->hdr.magic), mp->m_dirdatablk, ino);
@@ -1638,10 +1642,12 @@ process_leaf_block_dir2(
 	int			i;
 	int			stale;
 	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = xfs_dir3_leaf_ents_p(leaf);
 
-	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
+	for (i = stale = 0; i < leafhdr.count; i++) {
 		if ((char *)&ents[i] >= (char *)leaf + mp->m_dirblksize) {
 			do_warn(
 _("bad entry count in block %u of directory inode %" PRIu64 "\n"),
@@ -1658,7 +1664,7 @@ _("bad hash ordering in block %u of directory inode %" PRIu64 "\n"),
 		}
 		*next_hashval = last_hashval = be32_to_cpu(ents[i].hashval);
 	}
-	if (stale != be16_to_cpu(leaf->hdr.stale)) {
+	if (stale != leafhdr.stale) {
 		do_warn(
 _("bad stale count in block %u of directory inode %" PRIu64 "\n"),
 			da_bno, ino);
@@ -1687,6 +1693,7 @@ process_leaf_level_dir2(
 	int			nex;
 	xfs_dablk_t		prev_bno;
 	bmap_ext_t		lbmp;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	da_bno = da_cursor->level[0].bno;
 	ino = da_cursor->ino;
@@ -1723,15 +1730,15 @@ _("can't read file block %u for directory inode %" PRIu64 "\n"),
 			goto error_out;
 		}
 		leaf = bp->b_addr;
+		xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 		/*
 		 * Check magic number for leaf directory btree block.
 		 */
-		if (be16_to_cpu(leaf->hdr.info.magic) !=
-		   XFS_DIR2_LEAFN_MAGIC) {
+		if (!(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
+		      leafhdr.magic == XFS_DIR3_LEAFN_MAGIC)) {
 			do_warn(
 _("bad directory leaf magic # %#x for directory inode %" PRIu64 " block %u\n"),
-				be16_to_cpu(leaf->hdr.info.magic),
-				ino, da_bno);
+				leafhdr.magic, ino, da_bno);
 			libxfs_putbuf(bp);
 			goto error_out;
 		}
@@ -1753,11 +1760,10 @@ _("bad directory leaf magic # %#x for directory inode %" PRIu64 " block %u\n"),
 		da_cursor->level[0].hashval = greatest_hashval;
 		da_cursor->level[0].bp = bp;
 		da_cursor->level[0].bno = da_bno;
-		da_cursor->level[0].index =
-			be16_to_cpu(leaf->hdr.count);
+		da_cursor->level[0].index = leafhdr.count;
 		da_cursor->level[0].dirty = buf_dirty;
 
-		if (be32_to_cpu(leaf->hdr.info.back) != prev_bno) {
+		if (leafhdr.back != prev_bno) {
 			do_warn(
 _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 				da_bno, ino);
@@ -1765,7 +1771,7 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 			goto error_out;
 		}
 		prev_bno = da_bno;
-		da_bno = be32_to_cpu(leaf->hdr.info.forw);
+		da_bno = leafhdr.forw;
 		if (da_bno != 0) {
 			if (verify_dir2_path(mp, da_cursor, 0)) {
 				libxfs_putbuf(bp);
@@ -1908,7 +1914,8 @@ _("can't read block %" PRIu64 " for directory inode %" PRIu64 "\n"),
 			continue;
 		}
 		data = bp->b_addr;
-		if (be32_to_cpu(data->hdr.magic) != XFS_DIR2_DATA_MAGIC)
+		if (!(be32_to_cpu(data->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
+		      be32_to_cpu(data->hdr.magic) == XFS_DIR3_DATA_MAGIC))
 			do_warn(
 _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" PRIu64 "\n"),
 				be32_to_cpu(data->hdr.magic), dbno, ino);
diff --git a/repair/dir2.h b/repair/dir2.h
index 5162028..6ba96bb 100644
--- a/repair/dir2.h
+++ b/repair/dir2.h
@@ -33,13 +33,13 @@ typedef union {
 
 typedef struct xfs_dir2_data {
 	xfs_dir2_data_hdr_t	hdr;		/* magic XFS_DIR2_DATA_MAGIC */
-	xfs_dir2_data_union_t	u[1];
+	xfs_dir2_data_union_t	__u[1];
 } xfs_dir2_data_t;
 
 typedef struct xfs_dir2_block {
 	xfs_dir2_data_hdr_t	hdr;		/* magic XFS_DIR2_BLOCK_MAGIC */
-	xfs_dir2_data_union_t	u[1];
-	xfs_dir2_leaf_entry_t	leaf[1];
+	xfs_dir2_data_union_t	__u[1];
+	xfs_dir2_leaf_entry_t	__leaf[1];
 	xfs_dir2_block_tail_t	tail;
 } xfs_dir2_block_t;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 8b8df10..dc8145b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1421,7 +1421,7 @@ longform_dir2_entry_check_data(
 
 	bp = *bpp;
 	d = bp->b_addr;
-	ptr = (char *)d->u;
+	ptr = (char *)xfs_dir3_data_entry_p(&d->hdr);
 	nbad = 0;
 	needscan = needlog = 0;
 	junkit = 0;
@@ -1432,10 +1432,16 @@ longform_dir2_entry_check_data(
 		endptr = (char *)blp;
 		if (endptr > (char *)btp)
 			endptr = (char *)btp;
-		wantmagic = XFS_DIR2_BLOCK_MAGIC;
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			wantmagic = XFS_DIR3_BLOCK_MAGIC;
+		else
+			wantmagic = XFS_DIR2_BLOCK_MAGIC;
 	} else {
 		endptr = (char *)d + mp->m_dirblksize;
-		wantmagic = XFS_DIR2_DATA_MAGIC;
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			wantmagic = XFS_DIR3_DATA_MAGIC;
+		else
+			wantmagic = XFS_DIR2_DATA_MAGIC;
 	}
 	db = xfs_dir2_da_to_db(mp, da_bno);
 
@@ -1476,8 +1482,8 @@ longform_dir2_entry_check_data(
 				break;
 
 			/* check for block with no data entries */
-			if ((ptr == (char *)d->u) && (ptr +
-					be16_to_cpu(dup->length) >= endptr)) {
+			if ((ptr == (char *)xfs_dir3_data_entry_p(&d->hdr)) &&
+			    (ptr + be16_to_cpu(dup->length) >= endptr)) {
 				junkit = 1;
 				*num_illegal += 1;
 				break;
@@ -1548,7 +1554,7 @@ longform_dir2_entry_check_data(
 			do_warn(_("would fix magic # to %#x\n"), wantmagic);
 	}
 	lastfree = 0;
-	ptr = (char *)d->u;
+	ptr = (char *)xfs_dir3_data_entry_p(&d->hdr);
 	/*
 	 * look at each entry.  reference inode pointed to by each
 	 * entry in the incore inode tree.
@@ -1718,7 +1724,8 @@ longform_dir2_entry_check_data(
 		if (ip->i_ino == inum)  {
 			ASSERT(dep->name[0] == '.' && dep->namelen == 1);
 			add_inode_ref(current_irec, current_ino_offset);
-			if (da_bno != 0 || dep != (xfs_dir2_data_entry_t *)d->u) {
+			if (da_bno != 0 ||
+			    dep != xfs_dir3_data_entry_p(&d->hdr)) {
 				/* "." should be the first entry */
 				nbad++;
 				if (entry_junked(
@@ -1827,6 +1834,7 @@ longform_dir2_check_leaf(
 	xfs_dir2_leaf_tail_t	*ltp;
 	int			seeval;
 	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	da_bno = mp->m_dirleafblk;
 	if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp, XFS_DATA_FORK,
@@ -1837,27 +1845,24 @@ longform_dir2_check_leaf(
 		/* NOTREACHED */
 	}
 	leaf = bp->b_addr;
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = xfs_dir3_leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR2_LEAF1_MAGIC ||
-				be32_to_cpu(leaf->hdr.info.forw) ||
-				be32_to_cpu(leaf->hdr.info.back) ||
-				be16_to_cpu(leaf->hdr.count) <
-					be16_to_cpu(leaf->hdr.stale) ||
-				be16_to_cpu(leaf->hdr.count) >
+	if (!(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
+	      leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) ||
+				leafhdr.forw || leafhdr.back ||
+				leafhdr.count < leaf->hdr.stale ||
+				leafhdr.count >
 					xfs_dir3_max_leaf_ents(mp, leaf) ||
-				(char *)&ents[be16_to_cpu(
-					leaf->hdr.count)] > (char *)bestsp) {
+				(char *)&ents[leafhdr.count] > (char *)bestsp) {
 		do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
 			da_bno, ip->i_ino);
 		libxfs_putbuf(bp);
 		return 1;
 	}
-	seeval = dir_hash_see_all(hashtab, ents,
-				be16_to_cpu(leaf->hdr.count),
-				be16_to_cpu(leaf->hdr.stale));
+	seeval = dir_hash_see_all(hashtab, ents, leafhdr.count, leafhdr.stale);
 	if (dir_hash_check(hashtab, ip, seeval)) {
 		libxfs_putbuf(bp);
 		return 1;
@@ -1899,6 +1904,9 @@ longform_dir2_check_node(
 	int			seeval = 0;
 	int			used;
 	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
+	struct xfs_dir3_icfree_hdr freehdr;
+	__be16			*bests;
 
 	for (da_bno = mp->m_dirleafblk, next_da_bno = 0;
 			next_da_bno != NULLFILEOFF && da_bno < mp->m_dirfreeblk;
@@ -1914,23 +1922,23 @@ longform_dir2_check_node(
 			return 1;
 		}
 		leaf = bp->b_addr;
+		xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 		ents = xfs_dir3_leaf_ents_p(leaf);
-		if (be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR2_LEAFN_MAGIC) {
-			if (be16_to_cpu(leaf->hdr.info.magic) ==
-							XFS_DA_NODE_MAGIC) {
+		if (!(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
+		      leafhdr.magic == XFS_DIR3_LEAFN_MAGIC)) {
+			if (leafhdr.magic == XFS_DA_NODE_MAGIC ||
+			    leafhdr.magic == XFS_DA3_NODE_MAGIC) {
 				libxfs_putbuf(bp);
 				continue;
 			}
 			do_warn(
 	_("unknown magic number %#x for block %u in directory inode %" PRIu64 "\n"),
-				be16_to_cpu(leaf->hdr.info.magic),
-				da_bno, ip->i_ino);
+				leafhdr.magic, da_bno, ip->i_ino);
 			libxfs_putbuf(bp);
 			return 1;
 		}
-		if (be16_to_cpu(leaf->hdr.count) > xfs_dir3_max_leaf_ents(mp, leaf) ||
-					be16_to_cpu(leaf->hdr.count) <
-						be16_to_cpu(leaf->hdr.stale)) {
+		if (leafhdr.count > xfs_dir3_max_leaf_ents(mp, leaf) ||
+		    leafhdr.count < leafhdr.stale) {
 			do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
 				da_bno, ip->i_ino);
@@ -1938,8 +1946,7 @@ longform_dir2_check_node(
 			return 1;
 		}
 		seeval = dir_hash_see_all(hashtab, ents,
-					be16_to_cpu(leaf->hdr.count),
-					be16_to_cpu(leaf->hdr.stale));
+					leafhdr.count, leafhdr.stale);
 		libxfs_putbuf(bp);
 		if (seeval != DIR_HASH_CK_OK)
 			return 1;
@@ -1961,35 +1968,35 @@ longform_dir2_check_node(
 			return 1;
 		}
 		free = bp->b_addr;
+		xfs_dir3_free_hdr_from_disk(&freehdr, free);
+		bests = xfs_dir3_free_bests_p(mp, free);
 		fdb = xfs_dir2_da_to_db(mp, da_bno);
-		if (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC ||
-				be32_to_cpu(free->hdr.firstdb) !=
+		if (!(freehdr.magic == XFS_DIR2_FREE_MAGIC ||
+		      freehdr.magic == XFS_DIR3_FREE_MAGIC) ||
+				freehdr.firstdb !=
 					(fdb - XFS_DIR2_FREE_FIRSTDB(mp)) *
 						xfs_dir3_free_max_bests(mp) ||
-				be32_to_cpu(free->hdr.nvalid) <
-					be32_to_cpu(free->hdr.nused)) {
+				freehdr.nvalid < freehdr.nused) {
 			do_warn(
 	_("free block %u for directory inode %" PRIu64 " bad header\n"),
 				da_bno, ip->i_ino);
 			libxfs_putbuf(bp);
 			return 1;
 		}
-		for (i = used = 0; i < be32_to_cpu(free->hdr.nvalid); i++) {
-			if (i + be32_to_cpu(free->hdr.firstdb) >=
-							freetab->nents ||
-					freetab->ents[i + be32_to_cpu(
-						free->hdr.firstdb)].v !=
-						be16_to_cpu(free->bests[i])) {
+		for (i = used = 0; i < freehdr.nvalid; i++) {
+			if (i + freehdr.firstdb >= freetab->nents ||
+					freetab->ents[i + freehdr.firstdb].v !=
+						be16_to_cpu(bests[i])) {
 				do_warn(
 	_("free block %u entry %i for directory ino %" PRIu64 " bad\n"),
 					da_bno, i, ip->i_ino);
 				libxfs_putbuf(bp);
 				return 1;
 			}
-			used += be16_to_cpu(free->bests[i]) != NULLDATAOFF;
-			freetab->ents[i + be32_to_cpu(free->hdr.firstdb)].s = 1;
+			used += be16_to_cpu(bests[i]) != NULLDATAOFF;
+			freetab->ents[i + freehdr.firstdb].s = 1;
 		}
-		if (used != be32_to_cpu(free->hdr.nused)) {
+		if (used != freehdr.nused) {
 			do_warn(
 	_("free block %u for directory inode %" PRIu64 " bad nused\n"),
 				da_bno, ip->i_ino);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
