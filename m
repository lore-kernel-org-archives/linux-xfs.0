Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737B4C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 06:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4892E2189D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 06:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfH2Gax (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 02:30:53 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54328 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727035AbfH2Gax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 02:30:53 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6733E361556
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:30:48 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3DxG-0000xd-Ki
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 16:30:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3DxG-0006BU-J6
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 16:30:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: factor free block index lookup from xfs_dir2_node_addname_int()
Date:   Thu, 29 Aug 2019 16:30:40 +1000
Message-Id: <20190829063042.22902-4-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190829063042.22902-1-david@fromorbit.com>
References: <20190829063042.22902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=YwdpEuwJOOZGESPBAVIA:9 a=6mgyoGnc6Mb6NQ0A:21 a=jhAKos4K3aSXxJVa:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Simplify the logic in xfs_dir2_node_addname_int() by factoring out
the free block index lookup code that finds a block with enough free
space for the entry to be added. The code that is moved gets a major
cleanup at the same time, but there is no algorithm change here.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 196 ++++++++++++++++++----------------
 1 file changed, 103 insertions(+), 93 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 747d10692bb6..1d3d1c9b5961 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1635,7 +1635,7 @@ xfs_dir2_node_add_datablk(
 	int			error;
 
 	/* Not allowed to allocate, return failure. */
-	if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
+	if (args->total == 0)
 		return -ENOSPC;
 
 	/* Allocate and initialize the new data block.  */
@@ -1732,43 +1732,29 @@ xfs_dir2_node_add_datablk(
 	return 0;
 }
 
-/*
- * Add the data entry for a node-format directory name addition.
- * The leaf entry is added in xfs_dir2_leafn_add.
- * We may enter with a freespace block that the lookup found.
- */
-static int					/* error */
-xfs_dir2_node_addname_int(
-	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_da_state_blk_t	*fblk)		/* optional freespace block */
+static int
+xfs_dir2_node_find_freeblk(
+	struct xfs_da_args	*args,
+	struct xfs_da_state_blk	*fblk,
+	xfs_dir2_db_t		*dbnop,
+	struct xfs_buf		**fbpp,
+	int			*findexp,
+	int			length)
 {
-	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
-	xfs_dir2_db_t		dbno;		/* data block number */
-	struct xfs_buf		*dbp;		/* data block buffer */
-	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
-	xfs_inode_t		*dp;		/* incore directory inode */
-	xfs_dir2_data_unused_t	*dup;		/* data unused entry pointer */
-	int			error;		/* error return value */
-	xfs_dir2_db_t		fbno;		/* freespace block number */
-	struct xfs_buf		*fbp;		/* freespace buffer */
-	int			findex;		/* freespace entry index */
-	xfs_dir2_free_t		*free=NULL;	/* freespace block structure */
-	xfs_dir2_db_t		ifbno;		/* initial freespace block no */
-	xfs_dir2_db_t		lastfbno=0;	/* highest freespace block no */
-	int			length;		/* length of the new entry */
-	int			logfree = 0;	/* need to log free entry */
-	int			needlog = 0;	/* need to log data header */
-	int			needscan = 0;	/* need to rescan data frees */
-	__be16			*tagp;		/* data entry tag pointer */
-	xfs_trans_t		*tp;		/* transaction pointer */
-	__be16			*bests;
 	struct xfs_dir3_icfree_hdr freehdr;
-	struct xfs_dir2_data_free *bf;
-	xfs_dir2_data_aoff_t	aoff;
+	struct xfs_dir2_free	*free = NULL;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_trans	*tp = args->trans;
+	struct xfs_buf		*fbp = NULL;
+	xfs_dir2_db_t		lastfbno;
+	xfs_dir2_db_t		ifbno = -1;
+	xfs_dir2_db_t		dbno = -1;
+	xfs_dir2_db_t		fbno = -1;
+	xfs_fileoff_t		fo;
+	__be16			*bests;
+	int			findex;
+	int			error;
 
-	dp = args->dp;
-	tp = args->trans;
-	length = dp->d_ops->data_entsize(args->namelen);
 	/*
 	 * If we came in with a freespace block that means that lookup
 	 * found an entry with our hash value.  This is the freespace
@@ -1776,56 +1762,44 @@ xfs_dir2_node_addname_int(
 	 */
 	if (fblk) {
 		fbp = fblk->bp;
-		/*
-		 * Remember initial freespace block number.
-		 */
-		ifbno = fblk->blkno;
 		free = fbp->b_addr;
 		findex = fblk->index;
-		bests = dp->d_ops->free_bests_p(free);
-		dp->d_ops->free_hdr_from_disk(&freehdr, free);
-
-		/*
-		 * This means the free entry showed that the data block had
-		 * space for our entry, so we remembered it.
-		 * Use that data block.
-		 */
 		if (findex >= 0) {
+			/* caller already found the freespace for us. */
+			bests = dp->d_ops->free_bests_p(free);
+			dp->d_ops->free_hdr_from_disk(&freehdr, free);
+
 			ASSERT(findex < freehdr.nvalid);
 			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
 			ASSERT(be16_to_cpu(bests[findex]) >= length);
 			dbno = freehdr.firstdb + findex;
-			goto found_block;
-		} else {
-			/*
-			 * The data block looked at didn't have enough room.
-			 * We'll start at the beginning of the freespace entries.
-			 */
-			dbno = -1;
-			findex = 0;
+			goto out;
 		}
-	} else {
+
 		/*
-		 * Didn't come in with a freespace block, so no data block.
+		 * The data block looked at didn't have enough room.
+		 * We'll start at the beginning of the freespace entries.
 		 */
-		ifbno = dbno = -1;
-		fbp = NULL;
-		findex = 0;
+		ifbno = fblk->blkno;
+		fbno = ifbno;
 	}
+	ASSERT(dbno == -1);
+	findex = 0;
 
 	/*
-	 * If we don't have a data block yet, we're going to scan the
-	 * freespace blocks looking for one.  Figure out what the
-	 * highest freespace block number is.
+	 * If we don't have a data block yet, we're going to scan the freespace
+	 * blocks looking for one.  Figure out what the highest freespace block
+	 * number is.
 	 */
-	if (dbno == -1) {
-		xfs_fileoff_t	fo;		/* freespace block number */
+	error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK);
+	if (error)
+		return error;
+	lastfbno = xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)fo);
+
+	/* If we haven't get a search start block, set it now */
+	if (fbno == -1)
+		fbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
 
-		if ((error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK)))
-			return error;
-		lastfbno = xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)fo);
-		fbno = ifbno;
-	}
 	/*
 	 * While we haven't identified a data block, search the freeblock
 	 * data for a good data block.  If we find a null freeblock entry,
@@ -1836,17 +1810,10 @@ xfs_dir2_node_addname_int(
 		 * If we don't have a freeblock in hand, get the next one.
 		 */
 		if (fbp == NULL) {
-			/*
-			 * Happens the first time through unless lookup gave
-			 * us a freespace block to start with.
-			 */
-			if (++fbno == 0)
-				fbno = xfs_dir2_byte_to_db(args->geo,
-							XFS_DIR2_FREE_OFFSET);
 			/*
 			 * If it's ifbno we already looked at it.
 			 */
-			if (fbno == ifbno)
+			if (++fbno == ifbno)
 				fbno++;
 			/*
 			 * If it's off the end we're done.
@@ -1897,35 +1864,77 @@ xfs_dir2_node_addname_int(
 			}
 		}
 	}
+out:
+	*dbnop = dbno;
+	*fbpp = fbp;
+	*findexp = findex;
+	return 0;
+}
+
+
+/*
+ * Add the data entry for a node-format directory name addition.
+ * The leaf entry is added in xfs_dir2_leafn_add.
+ * We may enter with a freespace block that the lookup found.
+ */
+static int
+xfs_dir2_node_addname_int(
+	struct xfs_da_args	*args,		/* operation arguments */
+	struct xfs_da_state_blk	*fblk)		/* optional freespace block */
+{
+	struct xfs_dir2_data_unused *dup;	/* data unused entry pointer */
+	struct xfs_dir2_data_entry *dep;	/* data entry pointer */
+	struct xfs_dir2_data_hdr *hdr;		/* data block header */
+	struct xfs_dir2_data_free *bf;
+	struct xfs_dir2_free	*free = NULL;	/* freespace block structure */
+	struct xfs_trans	*tp = args->trans;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*dbp;		/* data block buffer */
+	struct xfs_buf		*fbp;		/* freespace buffer */
+	xfs_dir2_data_aoff_t	aoff;
+	xfs_dir2_db_t		dbno;		/* data block number */
+	int			error;		/* error return value */
+	int			findex;		/* freespace entry index */
+	int			length;		/* length of the new entry */
+	int			logfree = 0;	/* need to log free entry */
+	int			needlog = 0;	/* need to log data header */
+	int			needscan = 0;	/* need to rescan data frees */
+	__be16			*tagp;		/* data entry tag pointer */
+	__be16			*bests;
+
+	length = dp->d_ops->data_entsize(args->namelen);
+	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &findex,
+					   length);
+	if (error)
+		return error;
+
+	/*
+	 * Now we know if we must allocate blocks, so if we are checking whether
+	 * we can insert without allocation then we can return now.
+	 */
+	if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
+		if (dbno != -1)
+			return 0;
+		return -ENOSPC;
+	}
 
 	/*
 	 * If we don't have a data block, we need to allocate one and make
 	 * the freespace entries refer to it.
 	 */
 	if (dbno == -1) {
-		error = xfs_dir2_node_add_datablk(args, fblk, &dbno, &dbp, &fbp,
-						  &findex);
-		if (error)
-			return error;
-
-		/* setup current free block buffer */
-		free = fbp->b_addr;
-
 		/* we're going to have to log the free block index later */
 		logfree = 1;
+		error = xfs_dir2_node_add_datablk(args, fblk, &dbno, &dbp, &fbp,
+						  &findex);
 	} else {
-found_block:
-		/* If just checking, we succeeded. */
-		if (args->op_flags & XFS_DA_OP_JUSTCHECK)
-			return 0;
-
 		/* Read the data block in. */
 		error = xfs_dir3_data_read(tp, dp,
 					   xfs_dir2_db_to_da(args->geo, dbno),
 					   -1, &dbp);
-		if (error)
-			return error;
 	}
+	if (error)
+		return error;
 
 	/* setup for data block up now */
 	hdr = dbp->b_addr;
@@ -1962,6 +1971,7 @@ xfs_dir2_node_addname_int(
 		xfs_dir2_data_log_header(args, dbp);
 
 	/* If the freespace block entry is now wrong, update it. */
+	free = fbp->b_addr;
 	bests = dp->d_ops->free_bests_p(free);
 	if (bests[findex] != bf[0].length) {
 		bests[findex] = bf[0].length;
-- 
2.23.0.rc1

