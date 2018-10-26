Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeJZTA4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 15:00:56 -0400
Date: Fri, 26 Oct 2018 03:24:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20181026102424.GC29302@infradead.org>
References: <20181024225716.19459-1-david@fromorbit.com>
 <20181024225716.19459-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181024225716.19459-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

> @@ -1767,11 +1767,10 @@ xfs_dir2_node_find_freeblk(
>  		fbp = fblk->bp;
>  		free = fbp->b_addr;
>  		findex = fblk->index;
> +		bests = dp->d_ops->free_bests_p(free);
> +		dp->d_ops->free_hdr_from_disk(&freehdr, free);
>  		if (findex >= 0) {
>  			/* caller already found the freespace for us. */
> -			bests = dp->d_ops->free_bests_p(free);
> -			dp->d_ops->free_hdr_from_disk(&freehdr, free);
> -

This hunk just undoes a move in the previous patch, might be better
idea to just keep it as before there.

> +	for ( ; fbno < lastfbno; fbno++) {
> +		/* If we don't have a freeblock in hand, get the next one. */
>  		if (fbp == NULL) {
> +			/* If it's ifbno we already looked at it. */
> +			if (fbno == ifbno)
> +				continue;
> +

The only case where we have a fbp here is if we had a fblk passed in,
but it it did have the index set to -1.  But as far as I can tell
searching that again doesn't make any sense at all, so I'd apply
something like this in top of your patch (some of this also seems
to be in your next patch, so independent of the logic change might
be worth moving over here):

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 6a6572c5602e..d1fb0ff38584 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1752,10 +1752,7 @@ xfs_dir2_node_find_freeblk(
 	struct xfs_buf		*fbp = NULL;
 	int			findex;
 	xfs_dir2_db_t		lastfbno;
-	xfs_dir2_db_t		ifbno = -1;
-	xfs_dir2_db_t		dbno = -1;
 	xfs_dir2_db_t		fbno = -1;
-	xfs_dir2_free_t		*free = NULL;
 	struct xfs_dir3_icfree_hdr freehdr;
 	__be16			*bests = NULL;
 	xfs_fileoff_t		fo;
@@ -1768,28 +1765,29 @@ xfs_dir2_node_find_freeblk(
 	 */
 	if (fblk) {
 		fbp = fblk->bp;
-		free = fbp->b_addr;
 		findex = fblk->index;
-		bests = dp->d_ops->free_bests_p(free);
-		dp->d_ops->free_hdr_from_disk(&freehdr, free);
+		bests = dp->d_ops->free_bests_p(fbp->b_addr);
+		dp->d_ops->free_hdr_from_disk(&freehdr, fbp->b_addr);
 		if (findex >= 0) {
 			/* caller already found the freespace for us. */
 			ASSERT(findex < freehdr.nvalid);
 			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
 			ASSERT(be16_to_cpu(bests[findex]) >= length);
-			dbno = freehdr.firstdb + findex;
-			goto out;
+			goto found;
 		}
 
 		/*
 		 * The data block looked at didn't have enough room.
-		 * We'll start at the beginning of the freespace entries.
+		 * We'll start searching after this entry.
 		 */
-		ifbno = fblk->blkno;
-		fbno = ifbno;
+		fbno = fblk->blkno + 1;
+
+		xfs_trans_brelse(tp, fbp);
+		fblk->bp = NULL;
+	} else {
+		/* If we haven't got a search start block, set it now */
+		fbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
 	}
-	ASSERT(dbno == -1);
-	findex = 0;
 
 	/*
 	 * If we don't have a data block yet, we're going to scan the freespace
@@ -1801,64 +1799,50 @@ xfs_dir2_node_find_freeblk(
 		return error;
 	lastfbno = xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)fo);
 
-	/* If we haven't get a search start block, set it now */
-	if (fbno == -1)
-		fbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
-
 	/*
-	 * While we haven't identified a data block, search the freeblock
-	 * data for a data block with enough free space in it.
+	 * While we haven't identified a data block, search the freeblock data
+	 * for a data block with enough free space in it.
 	 */
 	for ( ; fbno < lastfbno; fbno++) {
-		/* If we don't have a freeblock in hand, get the next one. */
-		if (fbp == NULL) {
-			/* If it's ifbno we already looked at it. */
-			if (fbno == ifbno)
-				continue;
-
-			/*
-			 * Read the block.  There can be holes in the freespace
-			 * blocks, so this might not succeed.  This should be
-			 * really rare, so there's no reason to avoid it.
-			 */
-			error = xfs_dir2_free_try_read(tp, dp,
-					xfs_dir2_db_to_da(args->geo, fbno),
-					&fbp);
-			if (error)
-				return error;
-			if (!fbp)
-				continue;
+		/*
+		 * Read the block.  There can be holes in the freespace blocks,
+		 * so this might not succeed.  This should be really rare, so
+		 * there's no reason to avoid it.
+		 */
+		error = xfs_dir2_free_try_read(tp, dp,
+				xfs_dir2_db_to_da(args->geo, fbno), &fbp);
+		if (error)
+			return error;
+		if (!fbp)
+			continue;
 
-			findex = 0;
-			free = fbp->b_addr;
-			bests = dp->d_ops->free_bests_p(free);
-			dp->d_ops->free_hdr_from_disk(&freehdr, free);
-		}
+		bests = dp->d_ops->free_bests_p(fbp->b_addr);
+		dp->d_ops->free_hdr_from_disk(&freehdr, fbp->b_addr);
 
 		/* Scan the free entry array for a large enough free space. */
-		do {
-			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
-			    be16_to_cpu(bests[findex]) >= length) {
-				dbno = freehdr.firstdb + findex;
-				goto out;
-			}
-		} while (++findex < freehdr.nvalid);
+		for (findex = 0; findex < freehdr.nvalid; findex++) {
+			u16		best = be16_to_cpu(bests[findex]);
+
+			if (best != NULLDATAOFF && best >= length)
+				goto found;
+		}
 
 		/* Didn't find free space, go on to next free block */
 		xfs_trans_brelse(tp, fbp);
-		fbp = NULL;
-		if (fblk)
-			fblk->bp = NULL;
 	}
 
-out:
-	*dbnop = dbno;
+	*dbnop = -1;
+	*fbpp = NULL;
+	*findexp = 0;
+	return 0;
+
+found:
+	*dbnop = freehdr.firstdb + findex;
 	*fbpp = fbp;
 	*findexp = findex;
 	return 0;
 }
 
-
 /*
  * Add the data entry for a node-format directory name addition.
  * The leaf entry is added in xfs_dir2_leafn_add.
