Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbeCOA3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 20:29:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2F0R3cY157995
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:29:39 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2gqdhrg34y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:29:39 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2F0Tb7o004979
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:29:38 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2F0Tbvt026587
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:29:37 GMT
Subject: [PATCH 1/9] xfs: sanity-check the unused space before trying to use
 it
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Mar 2018 17:29:36 -0700
Message-ID: <152107377649.19571.3126019873391787136.stgit@magnolia>
In-Reply-To: <152107377037.19571.8618901963505842632.stgit@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_dir2_data_use_free, we examine on-disk metadata and ASSERT if
it doesn't make sense.  Since a carefully crafted fuzzed image can cause
the kernel to crash after blowing a bunch of assertions, let's move
those checks into a validator function and rig everything up to return
EFSCORRUPTED to userspace.  Found by lastbit fuzzing ltail.bestcount via
xfs/391.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h       |    2 +
 fs/xfs/libxfs/xfs_dir2_block.c |   38 ++++++++++++-------
 fs/xfs/libxfs/xfs_dir2_data.c  |   78 +++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_dir2_leaf.c  |    6 +++
 fs/xfs/libxfs/xfs_dir2_node.c  |    4 ++
 5 files changed, 93 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 388d67c..989e95a 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -173,7 +173,7 @@ extern void xfs_dir2_data_log_unused(struct xfs_da_args *args,
 extern void xfs_dir2_data_make_free(struct xfs_da_args *args,
 		struct xfs_buf *bp, xfs_dir2_data_aoff_t offset,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
-extern void xfs_dir2_data_use_free(struct xfs_da_args *args,
+extern int xfs_dir2_data_use_free(struct xfs_da_args *args,
 		struct xfs_buf *bp, struct xfs_dir2_data_unused *dup,
 		xfs_dir2_data_aoff_t offset, xfs_dir2_data_aoff_t len,
 		int *needlogp, int *needscanp);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 2da86a3..5726402 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -454,12 +454,15 @@ xfs_dir2_block_addname(
 		/*
 		 * Mark the space needed for the new leaf entry, now in use.
 		 */
-		xfs_dir2_data_use_free(args, bp, enddup,
+		error = xfs_dir2_data_use_free(args, bp, enddup,
 			(xfs_dir2_data_aoff_t)
 			((char *)enddup - (char *)hdr + be16_to_cpu(enddup->length) -
 			 sizeof(*blp)),
 			(xfs_dir2_data_aoff_t)sizeof(*blp),
 			&needlog, &needscan);
+		if (error)
+			return error;
+
 		/*
 		 * Update the tail (entry count).
 		 */
@@ -541,9 +544,11 @@ xfs_dir2_block_addname(
 	/*
 	 * Mark space for the data entry used.
 	 */
-	xfs_dir2_data_use_free(args, bp, dup,
+	error = xfs_dir2_data_use_free(args, bp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr),
 		(xfs_dir2_data_aoff_t)len, &needlog, &needscan);
+	if (error)
+		return error;
 	/*
 	 * Create the new data entry.
 	 */
@@ -997,8 +1002,10 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Use up the space at the end of the block (blp/btp).
 	 */
-	xfs_dir2_data_use_free(args, dbp, dup, args->geo->blksize - size, size,
-		&needlog, &needscan);
+	error = xfs_dir2_data_use_free(args, dbp, dup,
+		args->geo->blksize - size, size, &needlog, &needscan);
+	if (error)
+		return error;
 	/*
 	 * Initialize the block tail.
 	 */
@@ -1110,18 +1117,14 @@ xfs_dir2_sf_to_block(
 	 * Add block 0 to the inode.
 	 */
 	error = xfs_dir2_grow_inode(args, XFS_DIR2_DATA_SPACE, &blkno);
-	if (error) {
-		kmem_free(sfp);
-		return error;
-	}
+	if (error)
+		goto out_free;
 	/*
 	 * Initialize the data block, then convert it to block format.
 	 */
 	error = xfs_dir3_data_init(args, blkno, &bp);
-	if (error) {
-		kmem_free(sfp);
-		return error;
-	}
+	if (error)
+		goto out_free;
 	xfs_dir3_block_init(mp, tp, bp, dp);
 	hdr = bp->b_addr;
 
@@ -1136,8 +1139,10 @@ xfs_dir2_sf_to_block(
 	 */
 	dup = dp->d_ops->data_unused_p(hdr);
 	needlog = needscan = 0;
-	xfs_dir2_data_use_free(args, bp, dup, args->geo->blksize - i,
+	error = xfs_dir2_data_use_free(args, bp, dup, args->geo->blksize - i,
 			       i, &needlog, &needscan);
+	if (error)
+		goto out_free;
 	ASSERT(needscan == 0);
 	/*
 	 * Fill in the tail.
@@ -1150,9 +1155,11 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Remove the freespace, we'll manage it.
 	 */
-	xfs_dir2_data_use_free(args, bp, dup,
+	error = xfs_dir2_data_use_free(args, bp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr),
 		be16_to_cpu(dup->length), &needlog, &needscan);
+	if (error)
+		goto out_free;
 	/*
 	 * Create entry for .
 	 */
@@ -1256,4 +1263,7 @@ xfs_dir2_sf_to_block(
 	xfs_dir2_block_log_tail(tp, bp);
 	xfs_dir3_data_check(dp, bp);
 	return 0;
+out_free:
+	kmem_free(sfp);
+	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 9202794..167503d 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -932,10 +932,51 @@ xfs_dir2_data_make_free(
 	*needscanp = needscan;
 }
 
+/* Check our free data for obvious signs of corruption. */
+static inline xfs_failaddr_t
+xfs_dir2_data_check_free(
+	struct xfs_dir2_data_hdr	*hdr,
+	struct xfs_dir2_data_unused	*dup,
+	xfs_dir2_data_aoff_t		offset,
+	xfs_dir2_data_aoff_t		len)
+{
+	if (hdr->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC) &&
+	    hdr->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC) &&
+	    hdr->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) &&
+	    hdr->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
+		return __this_address;
+	if (be16_to_cpu(dup->freetag) != XFS_DIR2_DATA_FREE_TAG)
+		return __this_address;
+	if (offset < (char *)dup - (char *)hdr)
+		return __this_address;
+	if (offset + len > (char *)dup + be16_to_cpu(dup->length) - (char *)hdr)
+		return __this_address;
+	if ((char *)dup - (char *)hdr !=
+	    be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)))
+		return __this_address;
+	return NULL;
+}
+
+/* Sanity-check a new bestfree entry. */
+static inline xfs_failaddr_t
+xfs_dir2_data_check_new_free(
+	struct xfs_dir2_data_hdr	*hdr,
+	struct xfs_dir2_data_free	*dfp,
+	struct xfs_dir2_data_unused	*newdup)
+{
+	if (dfp == NULL)
+		return __this_address;
+	if (dfp->length != newdup->length)
+		return __this_address;
+	if (be16_to_cpu(dfp->offset) != (char *)newdup - (char *)hdr)
+		return __this_address;
+	return NULL;
+}
+
 /*
  * Take a byte range out of an existing unused space and make it un-free.
  */
-void
+int
 xfs_dir2_data_use_free(
 	struct xfs_da_args	*args,
 	struct xfs_buf		*bp,
@@ -947,23 +988,19 @@ xfs_dir2_data_use_free(
 {
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_free_t	*dfp;		/* bestfree pointer */
+	xfs_dir2_data_unused_t	*newdup;	/* new unused entry */
+	xfs_dir2_data_unused_t	*newdup2;	/* another new unused entry */
+	struct xfs_dir2_data_free *bf;
+	xfs_failaddr_t		fa;
 	int			matchback;	/* matches end of freespace */
 	int			matchfront;	/* matches start of freespace */
 	int			needscan;	/* need to regen bestfree */
-	xfs_dir2_data_unused_t	*newdup;	/* new unused entry */
-	xfs_dir2_data_unused_t	*newdup2;	/* another new unused entry */
 	int			oldlen;		/* old unused entry's length */
-	struct xfs_dir2_data_free *bf;
 
 	hdr = bp->b_addr;
-	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
-	ASSERT(be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG);
-	ASSERT(offset >= (char *)dup - (char *)hdr);
-	ASSERT(offset + len <= (char *)dup + be16_to_cpu(dup->length) - (char *)hdr);
-	ASSERT((char *)dup - (char *)hdr == be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)));
+	fa = xfs_dir2_data_check_free(hdr, dup, offset, len);
+	if (fa)
+		goto corrupt;
 	/*
 	 * Look up the entry in the bestfree table.
 	 */
@@ -1008,9 +1045,9 @@ xfs_dir2_data_use_free(
 			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
 			dfp = xfs_dir2_data_freeinsert(hdr, bf, newdup,
 						       needlogp);
-			ASSERT(dfp != NULL);
-			ASSERT(dfp->length == newdup->length);
-			ASSERT(be16_to_cpu(dfp->offset) == (char *)newdup - (char *)hdr);
+			fa = xfs_dir2_data_check_new_free(hdr, dfp, newdup);
+			if (fa)
+				goto corrupt;
 			/*
 			 * If we got inserted at the last slot,
 			 * that means we don't know if there was a better
@@ -1036,9 +1073,9 @@ xfs_dir2_data_use_free(
 			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
 			dfp = xfs_dir2_data_freeinsert(hdr, bf, newdup,
 						       needlogp);
-			ASSERT(dfp != NULL);
-			ASSERT(dfp->length == newdup->length);
-			ASSERT(be16_to_cpu(dfp->offset) == (char *)newdup - (char *)hdr);
+			fa = xfs_dir2_data_check_new_free(hdr, dfp, newdup);
+			if (fa)
+				goto corrupt;
 			/*
 			 * If we got inserted at the last slot,
 			 * that means we don't know if there was a better
@@ -1084,6 +1121,11 @@ xfs_dir2_data_use_free(
 		}
 	}
 	*needscanp = needscan;
+	return 0;
+corrupt:
+	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount,
+			hdr, __FILE__, __LINE__, fa);
+	return -EFSCORRUPTED;
 }
 
 /* Find the end of the entry data in a data/block format dir block. */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index d61d52d..f746921 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -877,9 +877,13 @@ xfs_dir2_leaf_addname(
 	/*
 	 * Mark the initial part of our freespace in use for the new entry.
 	 */
-	xfs_dir2_data_use_free(args, dbp, dup,
+	error = xfs_dir2_data_use_free(args, dbp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr), length,
 		&needlog, &needscan);
+	if (error) {
+		xfs_trans_brelse(tp, lbp);
+		return error;
+	}
 	/*
 	 * Initialize our new entry (at last).
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 0839ffe..641b352 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2023,9 +2023,11 @@ xfs_dir2_node_addname_int(
 	/*
 	 * Mark the first part of the unused space, inuse for us.
 	 */
-	xfs_dir2_data_use_free(args, dbp, dup,
+	error = xfs_dir2_data_use_free(args, dbp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr), length,
 		&needlog, &needscan);
+	if (error)
+		return error;
 	/*
 	 * Fill in the new entry and log it.
 	 */

