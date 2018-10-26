Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbeJZUtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 16:49:35 -0400
Date: Fri, 26 Oct 2018 05:12:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20181026121242.GA27890@infradead.org>
References: <20181024225716.19459-1-david@fromorbit.com>
 <20181024225716.19459-5-david@fromorbit.com>
 <20181026102424.GC29302@infradead.org>
 <20181026105842.GG19305@dastard>
 <20181026115623.GA8116@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026115623.GA8116@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 04:56:23AM -0700, Christoph Hellwig wrote:
> I don't think this is a new logic change, as we start at fbno
> already (both in the existing code and with your patch), but we got
> here because that block did not contain a suitable free space.
> 
> That being said with the reverse search in the next patch the + 1
> is pointless as that code changes again.  But many of the other changes
> in this patch or your next patch (which I hadn't looked at yet when
> I did this) should probably be in this one, otherwise we just create
> churn.

Or in other words, we could apply something like this (entirely
based on your next patch) here:

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 6a6572c5602e..919d6597fb19 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1750,7 +1750,7 @@ xfs_dir2_node_find_freeblk(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_buf		*fbp = NULL;
-	int			findex;
+	int			findex = 0;
 	xfs_dir2_db_t		lastfbno;
 	xfs_dir2_db_t		ifbno = -1;
 	xfs_dir2_db_t		dbno = -1;
@@ -1778,7 +1778,7 @@ xfs_dir2_node_find_freeblk(
 			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
 			ASSERT(be16_to_cpu(bests[findex]) >= length);
 			dbno = freehdr.firstdb + findex;
-			goto out;
+			goto found_block;
 		}
 
 		/*
@@ -1787,9 +1787,9 @@ xfs_dir2_node_find_freeblk(
 		 */
 		ifbno = fblk->blkno;
 		fbno = ifbno;
+		xfs_trans_brelse(tp, fbp);
+		fblk->bp = NULL;
 	}
-	ASSERT(dbno == -1);
-	findex = 0;
 
 	/*
 	 * If we don't have a data block yet, we're going to scan the freespace
@@ -1810,48 +1810,42 @@ xfs_dir2_node_find_freeblk(
 	 * data for a data block with enough free space in it.
 	 */
 	for ( ; fbno < lastfbno; fbno++) {
-		/* If we don't have a freeblock in hand, get the next one. */
-		if (fbp == NULL) {
-			/* If it's ifbno we already looked at it. */
-			if (fbno == ifbno)
-				continue;
+		/* If it's ifbno we already looked at it. */
+		if (fbno == ifbno)
+			continue;
 
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
+		 * Read the block.  There can be holes in the freespace
+		 * blocks, so this might not succeed.  This should be
+		 * really rare, so there's no reason to avoid it.
+		 */
+		error = xfs_dir2_free_try_read(tp, dp,
+				xfs_dir2_db_to_da(args->geo, fbno),
+				&fbp);
+		if (error)
+			return error;
+		if (!fbp)
+			continue;
 
-			findex = 0;
-			free = fbp->b_addr;
-			bests = dp->d_ops->free_bests_p(free);
-			dp->d_ops->free_hdr_from_disk(&freehdr, free);
-		}
+		findex = 0;
+		free = fbp->b_addr;
+		bests = dp->d_ops->free_bests_p(free);
+		dp->d_ops->free_hdr_from_disk(&freehdr, free);
 
 		/* Scan the free entry array for a large enough free space. */
-		do {
+		for (findex = freehdr.nvalid - 1; findex >= 0; findex--) {
 			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
 			    be16_to_cpu(bests[findex]) >= length) {
 				dbno = freehdr.firstdb + findex;
-				goto out;
+				goto found_block;
 			}
-		} while (++findex < freehdr.nvalid);
+		}
 
 		/* Didn't find free space, go on to next free block */
 		xfs_trans_brelse(tp, fbp);
-		fbp = NULL;
-		if (fblk)
-			fblk->bp = NULL;
 	}
 
-out:
+found_block:
 	*dbnop = dbno;
 	*fbpp = fbp;
 	*findexp = findex;
