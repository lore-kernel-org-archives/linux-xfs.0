Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k6bO056051 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75B414669F
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:05 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	d92S0RQuvgg2kpT1 for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:05 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIW-0001vh-Qt
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:04 +0000
Message-Id: <20110701094604.795668656@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/27] xfs: factor out xfs_dir2_leaf_find_entry
References: <20110701094321.936534538@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-factor-dir2-leaf-code
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add a new xfs_dir2_leaf_find_entry helper to factor out some duplicate code
from xfs_dir2_leaf_addname xfs_dir2_leafn_add.  Found by Eric Sandeen using
an automated code duplication checker.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-06-29 19:45:24.846962285 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-06-30 09:29:24.446740960 +0200
@@ -152,6 +152,123 @@ xfs_dir2_block_to_leaf(
 	return 0;
 }
 
+struct xfs_dir2_leaf_entry *
+xfs_dir2_leaf_find_entry(
+	xfs_dir2_leaf_t		*leaf,		/* leaf structure */
+	int			index,		/* leaf table position */
+	int			compact,	/* need to compact leaves */
+	int			lowstale,	/* index of prev stale leaf */
+	int			highstale,	/* index of next stale leaf */
+	int			*lfloglow,	/* low leaf logging index */
+	int			*lfloghigh)	/* high leaf logging index */
+{
+	if (!leaf->hdr.stale) {
+		xfs_dir2_leaf_entry_t	*lep;	/* leaf entry table pointer */
+
+		/*
+		 * Now we need to make room to insert the leaf entry.
+		 *
+		 * If there are no stale entries, just insert a hole at index.
+		 */
+		lep = &leaf->ents[index];
+		if (index < be16_to_cpu(leaf->hdr.count))
+			memmove(lep + 1, lep,
+				(be16_to_cpu(leaf->hdr.count) - index) *
+				 sizeof(*lep));
+
+		/*
+		 * Record low and high logging indices for the leaf.
+		 */
+		*lfloglow = index;
+		*lfloghigh = be16_to_cpu(leaf->hdr.count);
+		be16_add_cpu(&leaf->hdr.count, 1);
+		return lep;
+	}
+
+	/*
+	 * There are stale entries.
+	 *
+	 * We will use one of them for the new entry.  It's probably not at
+	 * the right location, so we'll have to shift some up or down first.
+	 *
+	 * If we didn't compact before, we need to find the nearest stale
+	 * entries before and after our insertion point.
+	 */
+	if (compact == 0) {
+		/*
+		 * Find the first stale entry before the insertion point,
+		 * if any.
+		 */
+		for (lowstale = index - 1;
+		     lowstale >= 0 &&
+			be32_to_cpu(leaf->ents[lowstale].address) !=
+			XFS_DIR2_NULL_DATAPTR;
+		     lowstale--)
+			continue;
+
+		/*
+		 * Find the next stale entry at or after the insertion point,
+		 * if any.   Stop if we go so far that the lowstale entry
+		 * would be better.
+		 */
+		for (highstale = index;
+		     highstale < be16_to_cpu(leaf->hdr.count) &&
+			be32_to_cpu(leaf->ents[highstale].address) !=
+			XFS_DIR2_NULL_DATAPTR &&
+			(lowstale < 0 ||
+			 index - lowstale - 1 >= highstale - index);
+		     highstale++)
+			continue;
+	}
+
+	/*
+	 * If the low one is better, use it.
+	 */
+	if (lowstale >= 0 &&
+	    (highstale == be16_to_cpu(leaf->hdr.count) ||
+	     index - lowstale - 1 < highstale - index)) {
+		ASSERT(index - lowstale - 1 >= 0);
+		ASSERT(be32_to_cpu(leaf->ents[lowstale].address) ==
+		       XFS_DIR2_NULL_DATAPTR);
+
+		/*
+		 * Copy entries up to cover the stale entry and make room
+		 * for the new entry.
+		 */
+		if (index - lowstale - 1 > 0) {
+			memmove(&leaf->ents[lowstale],
+				&leaf->ents[lowstale + 1],
+				(index - lowstale - 1) *
+				sizeof(xfs_dir2_leaf_entry_t));
+		}
+		*lfloglow = MIN(lowstale, *lfloglow);
+		*lfloghigh = MAX(index - 1, *lfloghigh);
+		be16_add_cpu(&leaf->hdr.stale, -1);
+		return &leaf->ents[index - 1];
+	}
+
+	/*
+	 * The high one is better, so use that one.
+	 */
+	ASSERT(highstale - index >= 0);
+	ASSERT(be32_to_cpu(leaf->ents[highstale].address) ==
+	       XFS_DIR2_NULL_DATAPTR);
+
+	/*
+	 * Copy entries down to cover the stale entry and make room for the
+	 * new entry.
+	 */
+	if (highstale - index > 0) {
+		memmove(&leaf->ents[index + 1],
+			&leaf->ents[index],
+			(highstale - index) * sizeof(xfs_dir2_leaf_entry_t));
+	}
+	*lfloglow = MIN(index, *lfloglow);
+	*lfloghigh = MAX(highstale, *lfloghigh);
+	be16_add_cpu(&leaf->hdr.stale, -1);
+	return &leaf->ents[index];
+}
+
 /*
  * Add an entry to a leaf form directory.
  */
@@ -430,102 +547,10 @@ xfs_dir2_leaf_addname(
 		if (!grown)
 			xfs_dir2_leaf_log_bests(tp, lbp, use_block, use_block);
 	}
-	/*
-	 * Now we need to make room to insert the leaf entry.
-	 * If there are no stale entries, we just insert a hole at index.
-	 */
-	if (!leaf->hdr.stale) {
-		/*
-		 * lep is still good as the index leaf entry.
-		 */
-		if (index < be16_to_cpu(leaf->hdr.count))
-			memmove(lep + 1, lep,
-				(be16_to_cpu(leaf->hdr.count) - index) * sizeof(*lep));
-		/*
-		 * Record low and high logging indices for the leaf.
-		 */
-		lfloglow = index;
-		lfloghigh = be16_to_cpu(leaf->hdr.count);
-		be16_add_cpu(&leaf->hdr.count, 1);
-	}
-	/*
-	 * There are stale entries.
-	 * We will use one of them for the new entry.
-	 * It's probably not at the right location, so we'll have to
-	 * shift some up or down first.
-	 */
-	else {
-		/*
-		 * If we didn't compact before, we need to find the nearest
-		 * stale entries before and after our insertion point.
-		 */
-		if (compact == 0) {
-			/*
-			 * Find the first stale entry before the insertion
-			 * point, if any.
-			 */
-			for (lowstale = index - 1;
-			     lowstale >= 0 &&
-				be32_to_cpu(leaf->ents[lowstale].address) !=
-				XFS_DIR2_NULL_DATAPTR;
-			     lowstale--)
-				continue;
-			/*
-			 * Find the next stale entry at or after the insertion
-			 * point, if any.   Stop if we go so far that the
-			 * lowstale entry would be better.
-			 */
-			for (highstale = index;
-			     highstale < be16_to_cpu(leaf->hdr.count) &&
-				be32_to_cpu(leaf->ents[highstale].address) !=
-				XFS_DIR2_NULL_DATAPTR &&
-				(lowstale < 0 ||
-				 index - lowstale - 1 >= highstale - index);
-			     highstale++)
-				continue;
-		}
-		/*
-		 * If the low one is better, use it.
-		 */
-		if (lowstale >= 0 &&
-		    (highstale == be16_to_cpu(leaf->hdr.count) ||
-		     index - lowstale - 1 < highstale - index)) {
-			ASSERT(index - lowstale - 1 >= 0);
-			ASSERT(be32_to_cpu(leaf->ents[lowstale].address) ==
-			       XFS_DIR2_NULL_DATAPTR);
-			/*
-			 * Copy entries up to cover the stale entry
-			 * and make room for the new entry.
-			 */
-			if (index - lowstale - 1 > 0)
-				memmove(&leaf->ents[lowstale],
-					&leaf->ents[lowstale + 1],
-					(index - lowstale - 1) * sizeof(*lep));
-			lep = &leaf->ents[index - 1];
-			lfloglow = MIN(lowstale, lfloglow);
-			lfloghigh = MAX(index - 1, lfloghigh);
-		}
-		/*
-		 * The high one is better, so use that one.
-		 */
-		else {
-			ASSERT(highstale - index >= 0);
-			ASSERT(be32_to_cpu(leaf->ents[highstale].address) ==
-			       XFS_DIR2_NULL_DATAPTR);
-			/*
-			 * Copy entries down to cover the stale entry
-			 * and make room for the new entry.
-			 */
-			if (highstale - index > 0)
-				memmove(&leaf->ents[index + 1],
-					&leaf->ents[index],
-					(highstale - index) * sizeof(*lep));
-			lep = &leaf->ents[index];
-			lfloglow = MIN(index, lfloglow);
-			lfloghigh = MAX(highstale, lfloghigh);
-		}
-		be16_add_cpu(&leaf->hdr.stale, -1);
-	}
+
+	lep = xfs_dir2_leaf_find_entry(leaf, index, compact, lowstale,
+				       highstale, &lfloglow, &lfloghigh);
+
 	/*
 	 * Fill in the new leaf entry.
 	 */
Index: xfs/fs/xfs/xfs_dir2_leaf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.h	2011-06-29 19:45:24.856962230 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.h	2011-06-30 09:18:07.263416117 +0200
@@ -248,6 +248,9 @@ extern int xfs_dir2_leaf_search_hash(str
 				     struct xfs_dabuf *lbp);
 extern int xfs_dir2_leaf_trim_data(struct xfs_da_args *args,
 				   struct xfs_dabuf *lbp, xfs_dir2_db_t db);
+extern xfs_dir2_leaf_entry_t *xfs_dir2_leaf_find_entry(xfs_dir2_leaf_t *, int,
+						       int, int, int,
+						       int *, int *);
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
 #endif	/* __XFS_DIR2_LEAF_H__ */
Index: xfs/fs/xfs/xfs_dir2_node.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_node.c	2011-06-29 19:45:24.870295493 +0200
+++ xfs/fs/xfs/xfs_dir2_node.c	2011-06-30 09:27:19.103409194 +0200
@@ -244,89 +244,13 @@ xfs_dir2_leafn_add(
 		lfloglow = be16_to_cpu(leaf->hdr.count);
 		lfloghigh = -1;
 	}
-	/*
-	 * No stale entries, just insert a space for the new entry.
-	 */
-	if (!leaf->hdr.stale) {
-		lep = &leaf->ents[index];
-		if (index < be16_to_cpu(leaf->hdr.count))
-			memmove(lep + 1, lep,
-				(be16_to_cpu(leaf->hdr.count) - index) * sizeof(*lep));
-		lfloglow = index;
-		lfloghigh = be16_to_cpu(leaf->hdr.count);
-		be16_add_cpu(&leaf->hdr.count, 1);
-	}
-	/*
-	 * There are stale entries.  We'll use one for the new entry.
-	 */
-	else {
-		/*
-		 * If we didn't do a compact then we need to figure out
-		 * which stale entry will be used.
-		 */
-		if (compact == 0) {
-			/*
-			 * Find first stale entry before our insertion point.
-			 */
-			for (lowstale = index - 1;
-			     lowstale >= 0 &&
-				be32_to_cpu(leaf->ents[lowstale].address) !=
-				XFS_DIR2_NULL_DATAPTR;
-			     lowstale--)
-				continue;
-			/*
-			 * Find next stale entry after insertion point.
-			 * Stop looking if the answer would be worse than
-			 * lowstale already found.
-			 */
-			for (highstale = index;
-			     highstale < be16_to_cpu(leaf->hdr.count) &&
-				be32_to_cpu(leaf->ents[highstale].address) !=
-				XFS_DIR2_NULL_DATAPTR &&
-				(lowstale < 0 ||
-				 index - lowstale - 1 >= highstale - index);
-			     highstale++)
-				continue;
-		}
-		/*
-		 * Using the low stale entry.
-		 * Shift entries up toward the stale slot.
-		 */
-		if (lowstale >= 0 &&
-		    (highstale == be16_to_cpu(leaf->hdr.count) ||
-		     index - lowstale - 1 < highstale - index)) {
-			ASSERT(be32_to_cpu(leaf->ents[lowstale].address) ==
-			       XFS_DIR2_NULL_DATAPTR);
-			ASSERT(index - lowstale - 1 >= 0);
-			if (index - lowstale - 1 > 0)
-				memmove(&leaf->ents[lowstale],
-					&leaf->ents[lowstale + 1],
-					(index - lowstale - 1) * sizeof(*lep));
-			lep = &leaf->ents[index - 1];
-			lfloglow = MIN(lowstale, lfloglow);
-			lfloghigh = MAX(index - 1, lfloghigh);
-		}
-		/*
-		 * Using the high stale entry.
-		 * Shift entries down toward the stale slot.
-		 */
-		else {
-			ASSERT(be32_to_cpu(leaf->ents[highstale].address) ==
-			       XFS_DIR2_NULL_DATAPTR);
-			ASSERT(highstale - index >= 0);
-			if (highstale - index > 0)
-				memmove(&leaf->ents[index + 1],
-					&leaf->ents[index],
-					(highstale - index) * sizeof(*lep));
-			lep = &leaf->ents[index];
-			lfloglow = MIN(index, lfloglow);
-			lfloghigh = MAX(highstale, lfloghigh);
-		}
-		be16_add_cpu(&leaf->hdr.stale, -1);
-	}
+
 	/*
 	 * Insert the new entry, log everything.
 	 */
+	lep = xfs_dir2_leaf_find_entry(leaf, index, compact, lowstale,
+				       highstale, &lfloglow, &lfloghigh);
+
 	lep->hashval = cpu_to_be32(args->hashval);
 	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(mp,
 				args->blkno, args->index));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
