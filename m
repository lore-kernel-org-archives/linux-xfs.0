Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13E187F50
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 01:04:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC0D78F8074
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 23:04:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xIFhPRBBpLmMhHWp for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 23:04:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WpWyk-0005od-14
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WpWyk-0003lE-0H
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/16] xfs: kill XFS_DIR2...FIRSTDB macros
Date: Wed, 28 May 2014 16:04:30 +1000
Message-Id: <1401257083-13433-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1401257083-13433-1-git-send-email-david@fromorbit.com>
References: <1401257083-13433-1-git-send-email-david@fromorbit.com>
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

They are just simple wrappers around xfs_dir2_byte_to_db(), and
we've already removed one usage earlier in the patch set. Kill
the rest before we start removing the xfs_mount from conversion
functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_da_format.c |  6 ++++--
 fs/xfs/xfs_da_format.h |  6 ------
 fs/xfs/xfs_dir2.c      |  2 +-
 fs/xfs/xfs_dir2_leaf.c |  9 +++++----
 fs/xfs/xfs_dir2_node.c | 11 +++++++----
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index f4a783b..a2d0682 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -611,7 +611,8 @@ xfs_dir2_free_bests_p(struct xfs_dir2_free *free)
 static xfs_dir2_db_t
 xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
-	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir2_free_max_bests(mp);
+	return xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET) +
+			(db / xfs_dir2_free_max_bests(mp));
 }
 
 /*
@@ -642,7 +643,8 @@ xfs_dir3_free_bests_p(struct xfs_dir2_free *free)
 static xfs_dir2_db_t
 xfs_dir3_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
-	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir3_free_max_bests(mp);
+	return xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET) +
+			(db / xfs_dir3_free_max_bests(mp));
 }
 
 /*
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index 32b415c..44d7fac 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -330,8 +330,6 @@ xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
 #define	XFS_DIR2_SPACE_SIZE	(1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
 #define	XFS_DIR2_DATA_SPACE	0
 #define	XFS_DIR2_DATA_OFFSET	(XFS_DIR2_DATA_SPACE * XFS_DIR2_SPACE_SIZE)
-#define	XFS_DIR2_DATA_FIRSTDB(mp)	\
-	xfs_dir2_byte_to_db(mp, XFS_DIR2_DATA_OFFSET)
 
 /*
  * Describe a free area in the data block.
@@ -456,8 +454,6 @@ xfs_dir2_data_unused_tag_p(struct xfs_dir2_data_unused *dup)
  */
 #define	XFS_DIR2_LEAF_SPACE	1
 #define	XFS_DIR2_LEAF_OFFSET	(XFS_DIR2_LEAF_SPACE * XFS_DIR2_SPACE_SIZE)
-#define	XFS_DIR2_LEAF_FIRSTDB(mp)	\
-	xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET)
 
 /*
  * Leaf block header.
@@ -531,8 +527,6 @@ xfs_dir2_leaf_bests_p(struct xfs_dir2_leaf_tail *ltp)
  */
 #define	XFS_DIR2_FREE_SPACE	2
 #define	XFS_DIR2_FREE_OFFSET	(XFS_DIR2_FREE_SPACE * XFS_DIR2_SPACE_SIZE)
-#define	XFS_DIR2_FREE_FIRSTDB(mp)	\
-	xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET)
 
 typedef	struct xfs_dir2_free_hdr {
 	__be32			magic;		/* XFS_DIR2_FREE_MAGIC */
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index acd940d..d48d477 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -744,7 +744,7 @@ xfs_dir2_shrink_inode(
 	/*
 	 * If it's not a data block, we're done.
 	 */
-	if (db >= XFS_DIR2_LEAF_FIRSTDB(mp))
+	if (db >= xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET))
 		return 0;
 	/*
 	 * If the block isn't the last one in the directory, we're done.
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index f571723..dc4ef19 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -347,8 +347,8 @@ xfs_dir3_leaf_get_buf(
 	int			error;
 
 	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
-	ASSERT(bno >= XFS_DIR2_LEAF_FIRSTDB(mp) &&
-	       bno < XFS_DIR2_FREE_FIRSTDB(mp));
+	ASSERT(bno >= xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET) &&
+	       bno < xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET));
 
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, bno), -1, &bp,
 			       XFS_DATA_FORK);
@@ -404,7 +404,7 @@ xfs_dir2_block_to_leaf(
 		return error;
 	}
 	ldb = xfs_dir2_da_to_db(mp, blkno);
-	ASSERT(ldb == XFS_DIR2_LEAF_FIRSTDB(mp));
+	ASSERT(ldb == xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET));
 	/*
 	 * Initialize the leaf block, get a buffer for it.
 	 */
@@ -1798,7 +1798,8 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Get rid of the freespace block.
 	 */
-	error = xfs_dir2_shrink_inode(args, XFS_DIR2_FREE_FIRSTDB(mp), fbp);
+	error = xfs_dir2_shrink_inode(args,
+			xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET), fbp);
 	if (error) {
 		/*
 		 * This can't fail here because it can only happen when
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 9cb91ee..1bcaaa0 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -315,7 +315,7 @@ xfs_dir2_leaf_to_node(
 	if ((error = xfs_dir2_grow_inode(args, XFS_DIR2_FREE_SPACE, &fdb))) {
 		return error;
 	}
-	ASSERT(fdb == XFS_DIR2_FREE_FIRSTDB(mp));
+	ASSERT(fdb == xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET));
 	/*
 	 * Get the buffer for the new freespace block.
 	 */
@@ -1256,7 +1256,7 @@ xfs_dir2_leafn_remove(
 		struct xfs_dir3_icfree_hdr freehdr;
 		dp->d_ops->free_hdr_from_disk(&freehdr, free);
 		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(mp) *
-					  (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
+			  (fdb - xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET)));
 	}
 #endif
 		/*
@@ -1747,7 +1747,8 @@ xfs_dir2_node_addname_int(
 			 * us a freespace block to start with.
 			 */
 			if (++fbno == 0)
-				fbno = XFS_DIR2_FREE_FIRSTDB(mp);
+				fbno = xfs_dir2_byte_to_db(mp,
+							XFS_DIR2_FREE_OFFSET);
 			/*
 			 * If it's ifbno we already looked at it.
 			 */
@@ -1887,7 +1888,9 @@ xfs_dir2_node_addname_int(
 			/*
 			 * Remember the first slot as our empty slot.
 			 */
-			freehdr.firstdb = (fbno - XFS_DIR2_FREE_FIRSTDB(mp)) *
+			freehdr.firstdb =
+				(fbno - xfs_dir2_byte_to_db(mp,
+							XFS_DIR2_FREE_OFFSET)) *
 					dp->d_ops->free_max_bests(mp);
 		} else {
 			free = fbp->b_addr;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
