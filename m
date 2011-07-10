Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoLbe153471 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFEBB5CCB5
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JCGS8PBUM4eceEYG for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xF-0002uH-Ak
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:17 +0000
Message-Id: <20110710205017.293539533@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/11] xfs: factor out xfs_dir2_leaf_find_stale
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-add-xfs_dir2_find_stale-helper
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-07-09 12:07:49.518499801 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-07-09 12:19:48.171796748 +0200
@@ -148,6 +148,36 @@ xfs_dir2_block_to_leaf(
 	return 0;
 }
 
+STATIC void
+xfs_dir2_leaf_find_stale(
+	struct xfs_dir2_leaf	*leaf,
+	int			index,
+	int			*lowstale,
+	int			*highstale)
+{
+	/*
+	 * Find the first stale entry before our index, if any.
+	 */
+	for (*lowstale = index - 1;
+	     *lowstale >= 0 &&
+		leaf->ents[*lowstale].address !=
+		cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
+	     --*lowstale)
+		continue;
+
+	/*
+	 * Find the first stale entry at or after our index, if any.
+	 * Stop if the answer would be worse than lowstale.
+	 */
+	for (*highstale = index;
+	     *highstale < be16_to_cpu(leaf->hdr.count) &&
+		leaf->ents[*highstale].address !=
+		cpu_to_be32(XFS_DIR2_NULL_DATAPTR) &&
+		(*lowstale < 0 || index - *lowstale > *highstale - index);
+	     ++*highstale)
+		continue;
+}
+
 struct xfs_dir2_leaf_entry *
 xfs_dir2_leaf_find_entry(
 	xfs_dir2_leaf_t		*leaf,		/* leaf structure */
@@ -190,32 +220,8 @@ xfs_dir2_leaf_find_entry(
 	 * If we didn't compact before, we need to find the nearest stale
 	 * entries before and after our insertion point.
 	 */
-	if (compact == 0) {
-		/*
-		 * Find the first stale entry before the insertion point,
-		 * if any.
-		 */
-		for (lowstale = index - 1;
-		     lowstale >= 0 &&
-			leaf->ents[lowstale].address !=
-			cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-		     lowstale--)
-			continue;
-
-		/*
-		 * Find the next stale entry at or after the insertion point,
-		 * if any.   Stop if we go so far that the lowstale entry
-		 * would be better.
-		 */
-		for (highstale = index;
-		     highstale < be16_to_cpu(leaf->hdr.count) &&
-			leaf->ents[highstale].address !=
-			cpu_to_be32(XFS_DIR2_NULL_DATAPTR) &&
-			(lowstale < 0 ||
-			 index - lowstale - 1 >= highstale - index);
-		     highstale++)
-			continue;
-	}
+	if (compact == 0)
+		xfs_dir2_leaf_find_stale(leaf, index, &lowstale, &highstale);
 
 	/*
 	 * If the low one is better, use it.
@@ -689,26 +695,9 @@ xfs_dir2_leaf_compact_x1(
 	leaf = bp->data;
 	ASSERT(be16_to_cpu(leaf->hdr.stale) > 1);
 	index = *indexp;
-	/*
-	 * Find the first stale entry before our index, if any.
-	 */
-	for (lowstale = index - 1;
-	     lowstale >= 0 &&
-		leaf->ents[lowstale].address !=
-		cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-	     lowstale--)
-		continue;
-	/*
-	 * Find the first stale entry at or after our index, if any.
-	 * Stop if the answer would be worse than lowstale.
-	 */
-	for (highstale = index;
-	     highstale < be16_to_cpu(leaf->hdr.count) &&
-		leaf->ents[highstale].address !=
-		cpu_to_be32(XFS_DIR2_NULL_DATAPTR) &&
-		(lowstale < 0 || index - lowstale > highstale - index);
-	     highstale++)
-		continue;
+
+	xfs_dir2_leaf_find_stale(leaf, index, &lowstale, &highstale);
+
 	/*
 	 * Pick the better of lowstale and highstale.
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
