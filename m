Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6D7GvdM071972 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 02:16:57 -0500
Date: Wed, 13 Jul 2011 03:16:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/11] xfs: factor out xfs_dir2_leaf_find_stale
Message-ID: <20110713071654.GA21252@infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.293539533@bombadil.infradead.org>
	<1310423573.7019.55.camel@doink> <20110713064936.GP23038@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110713064936.GP23038@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Wed, Jul 13, 2011 at 04:49:36PM +1000, Dave Chinner wrote:
> > > +	     --*lowstale)
> > > +		continue;
> 
> Only thing I was conerned about was the indenting on these loops.
> Something like this:
> 
> 	for (*lowstale = index - 1;
> 	     *lowstale >= 0 &&
> 			leaf->ents[*lowstale].address !=
> 			cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
> 	     --*lowstale)
> 		continue;
> 
> means that at a glance it is easy to separate the loop control
> statements from the body of the loop just by indentation.

I tried to avoid changing anything here, but now that other people
like me hate these uglies I think I have to ite the bullet and
actually untangle those loops.  The version below is what I'm submitting
to testing now:



From: Christoph Hellwig <hch@lst.de>
Subject: xfs: factor out xfs_dir2_leaf_find_stale

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-07-13 09:00:10.333246566 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-07-13 09:08:52.217085945 +0200
@@ -148,6 +148,38 @@ xfs_dir2_block_to_leaf(
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
+	for (*lowstale = index - 1; *lowstale >= 0; --*lowstale) {
+		if (leaf->ents[*lowstale].address ==
+		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+			break;
+	}
+
+	/*
+	 * Find the first stale entry at or after our index, if any.
+	 * Stop if the result would require moving more entries than using
+	 * lowstale.
+	 */
+	for (*highstale = index;
+	     *highstale < be16_to_cpu(leaf->hdr.count);
+	     ++*highstale) {
+		if (leaf->ents[*highstale].address ==
+		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+			break;
+		if (*lowstale >= 0 && index - *lowstale <= *highstale - index)
+			break;
+	}
+}
+
 struct xfs_dir2_leaf_entry *
 xfs_dir2_leaf_find_entry(
 	xfs_dir2_leaf_t		*leaf,		/* leaf structure */
@@ -190,32 +222,8 @@ xfs_dir2_leaf_find_entry(
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
@@ -689,26 +697,9 @@ xfs_dir2_leaf_compact_x1(
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
