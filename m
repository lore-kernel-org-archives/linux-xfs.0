Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 93E5B7F6D
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 19:32:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72D60304039
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 17:32:33 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qSykXts8KqNVJsnr for <xfs@oss.sgi.com>;
	Sun, 24 Feb 2013 17:32:30 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1U9mv3-0002sv-CY
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:31:53 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1U9mut-0003IX-9Z
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:31:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/16] xfs: add CRC checking to dir2 data blocks
Date: Mon, 25 Feb 2013 12:31:37 +1100
Message-Id: <1361755901-12453-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1361755901-12453-1-git-send-email-david@fromorbit.com>
References: <1361755901-12453-1-git-send-email-david@fromorbit.com>
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

This addition follows the same pattern as the dir2 block CRCs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_block.c  |   22 +++++-----
 fs/xfs/xfs_dir2_data.c   |  100 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_dir2_format.h |    9 +++--
 fs/xfs/xfs_dir2_leaf.c   |   64 ++++++++++++++++-------------
 fs/xfs/xfs_dir2_node.c   |   36 ++++++++++-------
 fs/xfs/xfs_dir2_priv.h   |   12 +++---
 fs/xfs/xfs_file.c        |    2 +-
 7 files changed, 153 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index f2b34b2..175db20 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -76,7 +76,7 @@ xfs_dir3_block_verify(
 		if (hdr3->magic != be32_to_cpu(XFS_DIR2_BLOCK_MAGIC))
 			return false;
 	}
-	if (__xfs_dir2_data_check(NULL, bp))
+	if (__xfs_dir3_data_check(NULL, bp))
 		return false;
 	return true;
 }
@@ -552,7 +552,7 @@ xfs_dir2_block_addname(
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir2_block_log_tail(tp, bp);
 	xfs_dir2_data_log_entry(tp, bp, dep);
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
 
@@ -595,7 +595,7 @@ xfs_dir2_block_getdents(
 	 */
 	wantoff = xfs_dir2_dataptr_to_off(mp, *offset);
 	hdr = bp->b_addr;
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	/*
 	 * Set up values for the loop.
 	 */
@@ -719,7 +719,7 @@ xfs_dir2_block_lookup(
 	dp = args->dp;
 	mp = dp->i_mount;
 	hdr = bp->b_addr;
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
@@ -770,7 +770,7 @@ xfs_dir2_block_lookup_int(
 		return error;
 
 	hdr = bp->b_addr;
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
@@ -907,7 +907,7 @@ xfs_dir2_block_removename(
 		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	/*
 	 * See if the size as a shortform is good enough.
 	 */
@@ -964,7 +964,7 @@ xfs_dir2_block_replace(
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
 	xfs_dir2_data_log_entry(args->trans, bp, dep);
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
 
@@ -1042,12 +1042,14 @@ xfs_dir2_leaf_to_block(
 	 * Read the data block if we don't already have it, give up if it fails.
 	 */
 	if (!dbp) {
-		error = xfs_dir2_data_read(tp, dp, mp->m_dirdatablk, -1, &dbp);
+		error = xfs_dir3_data_read(tp, dp, mp->m_dirdatablk, -1, &dbp);
 		if (error)
 			return error;
 	}
 	hdr = dbp->b_addr;
-	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+
 	/*
 	 * Size of the "leaf" area in the block.
 	 */
@@ -1325,6 +1327,6 @@ xfs_dir2_sf_to_block(
 	ASSERT(needscan == 0);
 	xfs_dir2_block_log_leaf(tp, bp, 0, be32_to_cpu(btp->count) - 1);
 	xfs_dir2_block_log_tail(tp, bp);
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 93bc123..f0284fa 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -30,6 +30,8 @@
 #include "xfs_dir2_format.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
+#include "xfs_buf_item.h"
+#include "xfs_cksum.h"
 
 STATIC xfs_dir2_data_free_t *
 xfs_dir2_data_freefind(xfs_dir2_data_hdr_t *hdr, xfs_dir2_data_unused_t *dup);
@@ -40,7 +42,7 @@ xfs_dir2_data_freefind(xfs_dir2_data_hdr_t *hdr, xfs_dir2_data_unused_t *dup);
  * Return 0 is the buffer is good, otherwise an error.
  */
 int
-__xfs_dir2_data_check(
+__xfs_dir3_data_check(
 	struct xfs_inode	*dp,		/* incore inode pointer */
 	struct xfs_buf		*bp)		/* data block's buffer */
 {
@@ -75,6 +77,7 @@ __xfs_dir2_data_check(
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
 		break;
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 		endp = (char *)hdr + mp->m_dirblksize;
 		break;
@@ -188,21 +191,27 @@ __xfs_dir2_data_check(
 	return 0;
 }
 
-static void
-xfs_dir2_data_verify(
+static bool
+xfs_dir3_data_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
-	int			block_ok = 0;
-
-	block_ok = hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC);
-	block_ok = block_ok && __xfs_dir2_data_check(NULL, bp) == 0;
+	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
-	if (!block_ok) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (hdr3->magic != be32_to_cpu(XFS_DIR3_DATA_MAGIC))
+			return false;
+		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
+			return false;
+		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
+			return false;
+	} else {
+		if (hdr3->magic != be32_to_cpu(XFS_DIR2_DATA_MAGIC))
+			return false;
 	}
+	if (__xfs_dir3_data_check(NULL, bp))
+		return false;
+	return true;
 }
 
 /*
@@ -211,7 +220,7 @@ xfs_dir2_data_verify(
  * format buffer or a data format buffer on readahead.
  */
 static void
-xfs_dir2_data_reada_verify(
+xfs_dir3_data_reada_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
@@ -224,7 +233,8 @@ xfs_dir2_data_reada_verify(
 		bp->b_ops->verify_read(bp);
 		return;
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
-		xfs_dir2_data_verify(bp);
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
+		xfs_dir3_data_verify(bp);
 		return;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
@@ -234,32 +244,56 @@ xfs_dir2_data_reada_verify(
 }
 
 static void
-xfs_dir2_data_read_verify(
+xfs_dir3_data_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_data_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					  XFS_DIR3_DATA_CRC_OFF)) ||
+	    !xfs_dir3_data_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
 }
 
 static void
-xfs_dir2_data_write_verify(
+xfs_dir3_data_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_data_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+
+	if (!xfs_dir3_data_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_DATA_CRC_OFF);
 }
 
-const struct xfs_buf_ops xfs_dir2_data_buf_ops = {
-	.verify_read = xfs_dir2_data_read_verify,
-	.verify_write = xfs_dir2_data_write_verify,
+const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
+	.verify_read = xfs_dir3_data_read_verify,
+	.verify_write = xfs_dir3_data_write_verify,
 };
 
-static const struct xfs_buf_ops xfs_dir2_data_reada_buf_ops = {
-	.verify_read = xfs_dir2_data_reada_verify,
-	.verify_write = xfs_dir2_data_write_verify,
+static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
+	.verify_read = xfs_dir3_data_reada_verify,
+	.verify_write = xfs_dir3_data_write_verify,
 };
 
 
 int
-xfs_dir2_data_read(
+xfs_dir3_data_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
@@ -267,18 +301,18 @@ xfs_dir2_data_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
-				XFS_DATA_FORK, &xfs_dir2_data_buf_ops);
+				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
 }
 
 int
-xfs_dir2_data_readahead(
+xfs_dir3_data_readahead(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mapped_bno)
 {
 	return xfs_da_reada_buf(tp, dp, bno, mapped_bno,
-				XFS_DATA_FORK, &xfs_dir2_data_reada_buf_ops);
+				XFS_DATA_FORK, &xfs_dir3_data_reada_buf_ops);
 }
 
 /*
@@ -308,6 +342,7 @@ xfs_dir2_data_freefind(
 	 * one we're looking for it has to be exact.
 	 */
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 	for (dfp = &bf[0], seenzero = matched = 0;
@@ -455,6 +490,7 @@ xfs_dir2_data_freescan(
 	char			*p;		/* current entry pointer */
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
@@ -531,13 +567,12 @@ xfs_dir3_data_init(
 		XFS_DATA_FORK);
 	if (error)
 		return error;
-	bp->b_ops = &xfs_dir2_data_buf_ops;
+	bp->b_ops = &xfs_dir3_data_buf_ops;
 
 	/*
 	 * Initialize the header.
 	 */
 	hdr = bp->b_addr;
-
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
@@ -588,6 +623,7 @@ xfs_dir2_data_log_entry(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
@@ -607,6 +643,7 @@ xfs_dir2_data_log_header(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
@@ -625,6 +662,7 @@ xfs_dir2_data_log_unused(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
@@ -672,7 +710,8 @@ xfs_dir2_data_make_free(
 	/*
 	 * Figure out where the end of the data area is.
 	 */
-	if (hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC))
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	    hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC))
 		endptr = (char *)hdr + mp->m_dirblksize;
 	else {
 		xfs_dir2_block_tail_t	*btp;	/* block tail */
@@ -854,6 +893,7 @@ xfs_dir2_data_use_free(
 
 	hdr = bp->b_addr;
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 	ASSERT(be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG);
diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
index 96390ef..358efab 100644
--- a/fs/xfs/xfs_dir2_format.h
+++ b/fs/xfs/xfs_dir2_format.h
@@ -282,7 +282,8 @@ struct xfs_dir3_data_hdr {
 static inline struct xfs_dir2_data_free *
 xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 {
-	if (hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
+	if (hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
+	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		struct xfs_dir3_data_hdr *hdr3 = (struct xfs_dir3_data_hdr *)hdr;
 		return hdr3->best_free;
 	}
@@ -347,7 +348,8 @@ xfs_dir2_data_unused_tag_p(struct xfs_dir2_data_unused *dup)
 static inline struct xfs_dir2_data_unused *
 xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 {
-	if (hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
+	if (hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
+	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		return (struct xfs_dir2_data_unused *)
 			((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
 	}
@@ -358,7 +360,8 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 static inline size_t
 xfs_dir3_data_entry_offset(struct xfs_dir2_data_hdr *hdr)
 {
-	if (hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
+	if (hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
+	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
 		return sizeof(struct xfs_dir3_data_hdr);
 	return sizeof(struct xfs_dir2_data_hdr);
 }
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 4adee8b..78d3182 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -149,7 +149,7 @@ xfs_dir2_block_to_leaf(
 	int			needlog;	/* need to log block header */
 	int			needscan;	/* need to rescan bestfree */
 	xfs_trans_t		*tp;		/* transaction pointer */
-	struct xfs_dir2_data_free	*bf;
+	struct xfs_dir2_data_free *bf;
 
 	trace_xfs_dir2_block_to_leaf(args);
 
@@ -175,7 +175,7 @@ xfs_dir2_block_to_leaf(
 	ASSERT(lbp != NULL);
 	leaf = lbp->b_addr;
 	hdr = dbp->b_addr;
-	xfs_dir2_data_check(dp, dbp);
+	xfs_dir3_data_check(dp, dbp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	bf = xfs_dir3_data_bestfree_p(hdr);
@@ -204,8 +204,12 @@ xfs_dir2_block_to_leaf(
 	/*
 	 * Fix up the block header, make it a data block.
 	 */
-	dbp->b_ops = &xfs_dir2_data_buf_ops;
-	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
+	dbp->b_ops = &xfs_dir3_data_buf_ops;
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
+		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
+	else
+		hdr->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
+
 	if (needscan)
 		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	/*
@@ -221,7 +225,7 @@ xfs_dir2_block_to_leaf(
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	xfs_dir2_leaf_check(dp, lbp);
-	xfs_dir2_data_check(dp, dbp);
+	xfs_dir3_data_check(dp, dbp);
 	xfs_dir2_leaf_log_bests(tp, lbp, 0, 0);
 	return 0;
 }
@@ -385,6 +389,7 @@ xfs_dir2_leaf_addname(
 	__be16			*tagp;		/* end of data entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	xfs_dir2_db_t		use_block;	/* data block number */
+	struct xfs_dir2_data_free *bf;		/* bestfree table */
 
 	trace_xfs_dir2_leaf_addname(args);
 
@@ -568,14 +573,15 @@ xfs_dir2_leaf_addname(
 		else
 			xfs_dir2_leaf_log_bests(tp, lbp, use_block, use_block);
 		hdr = dbp->b_addr;
-		bestsp[use_block] = hdr->bestfree[0].length;
+		bf = xfs_dir3_data_bestfree_p(hdr);
+		bestsp[use_block] = bf[0].length;
 		grown = 1;
 	} else {
 		/*
 		 * Already had space in some data block.
 		 * Just read that one in.
 		 */
-		error = xfs_dir2_data_read(tp, dp,
+		error = xfs_dir3_data_read(tp, dp,
 					   xfs_dir2_db_to_da(mp, use_block),
 					   -1, &dbp);
 		if (error) {
@@ -583,13 +589,14 @@ xfs_dir2_leaf_addname(
 			return error;
 		}
 		hdr = dbp->b_addr;
+		bf = xfs_dir3_data_bestfree_p(hdr);
 		grown = 0;
 	}
 	/*
 	 * Point to the biggest freespace in our data block.
 	 */
 	dup = (xfs_dir2_data_unused_t *)
-	      ((char *)hdr + be16_to_cpu(hdr->bestfree[0].offset));
+	      ((char *)hdr + be16_to_cpu(bf[0].offset));
 	ASSERT(be16_to_cpu(dup->length) >= length);
 	needscan = needlog = 0;
 	/*
@@ -622,8 +629,8 @@ xfs_dir2_leaf_addname(
 	 * If the bests table needs to be changed, do it.
 	 * Log the change unless we've already done that.
 	 */
-	if (be16_to_cpu(bestsp[use_block]) != be16_to_cpu(hdr->bestfree[0].length)) {
-		bestsp[use_block] = hdr->bestfree[0].length;
+	if (be16_to_cpu(bestsp[use_block]) != be16_to_cpu(bf[0].length)) {
+		bestsp[use_block] = bf[0].length;
 		if (!grown)
 			xfs_dir2_leaf_log_bests(tp, lbp, use_block, use_block);
 	}
@@ -643,7 +650,7 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_leaf_log_header(tp, lbp);
 	xfs_dir2_leaf_log_ents(tp, lbp, lfloglow, lfloghigh);
 	xfs_dir2_leaf_check(dp, lbp);
-	xfs_dir2_data_check(dp, dbp);
+	xfs_dir3_data_check(dp, dbp);
 	return 0;
 }
 
@@ -967,7 +974,7 @@ xfs_dir2_leaf_readbuf(
 	 * Read the directory block starting at the first mapping.
 	 */
 	mip->curdb = xfs_dir2_da_to_db(mp, map->br_startoff);
-	error = xfs_dir2_data_read(NULL, dp, map->br_startoff,
+	error = xfs_dir3_data_read(NULL, dp, map->br_startoff,
 			map->br_blockcount >= mp->m_dirblkfsbs ?
 			    XFS_FSB_TO_DADDR(mp, map->br_startblock) : -1, &bp);
 
@@ -996,7 +1003,7 @@ xfs_dir2_leaf_readbuf(
 		 */
 		if (i > mip->ra_current &&
 		    map[mip->ra_index].br_blockcount >= mp->m_dirblkfsbs) {
-			xfs_dir2_data_readahead(NULL, dp,
+			xfs_dir3_data_readahead(NULL, dp,
 				map[mip->ra_index].br_startoff + mip->ra_offset,
 				XFS_FSB_TO_DADDR(mp,
 					map[mip->ra_index].br_startblock +
@@ -1009,7 +1016,7 @@ xfs_dir2_leaf_readbuf(
 		 * use our mapping, but this is a very rare case.
 		 */
 		else if (i > mip->ra_current) {
-			xfs_dir2_data_readahead(NULL, dp,
+			xfs_dir3_data_readahead(NULL, dp,
 					map[mip->ra_index].br_startoff +
 							mip->ra_offset, -1);
 			mip->ra_current = i;
@@ -1135,7 +1142,7 @@ xfs_dir2_leaf_getdents(
 				ASSERT(xfs_dir2_byte_to_db(mp, curoff) ==
 				       map_info->curdb);
 			hdr = bp->b_addr;
-			xfs_dir2_data_check(dp, bp);
+			xfs_dir3_data_check(dp, bp);
 			/*
 			 * Find our position in the block.
 			 */
@@ -1481,7 +1488,7 @@ xfs_dir2_leaf_lookup_int(
 		if (newdb != curdb) {
 			if (dbp)
 				xfs_trans_brelse(tp, dbp);
-			error = xfs_dir2_data_read(tp, dp,
+			error = xfs_dir3_data_read(tp, dp,
 						   xfs_dir2_db_to_da(mp, newdb),
 						   -1, &dbp);
 			if (error) {
@@ -1522,7 +1529,7 @@ xfs_dir2_leaf_lookup_int(
 		ASSERT(cidb != -1);
 		if (cidb != curdb) {
 			xfs_trans_brelse(tp, dbp);
-			error = xfs_dir2_data_read(tp, dp,
+			error = xfs_dir3_data_read(tp, dp,
 						   xfs_dir2_db_to_da(mp, cidb),
 						   -1, &dbp);
 			if (error) {
@@ -1568,6 +1575,7 @@ xfs_dir2_leaf_removename(
 	int			needscan;	/* need to rescan data frees */
 	xfs_dir2_data_off_t	oldbest;	/* old value of best free */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir2_data_free *bf;		/* bestfree table */
 
 	trace_xfs_dir2_leaf_removename(args);
 
@@ -1582,7 +1590,8 @@ xfs_dir2_leaf_removename(
 	mp = dp->i_mount;
 	leaf = lbp->b_addr;
 	hdr = dbp->b_addr;
-	xfs_dir2_data_check(dp, dbp);
+	bf = xfs_dir3_data_bestfree_p(hdr);
+	xfs_dir3_data_check(dp, dbp);
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
@@ -1591,7 +1600,7 @@ xfs_dir2_leaf_removename(
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 	needscan = needlog = 0;
-	oldbest = be16_to_cpu(hdr->bestfree[0].length);
+	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	ASSERT(be16_to_cpu(bestsp[db]) == oldbest);
@@ -1620,16 +1629,15 @@ xfs_dir2_leaf_removename(
 	 * If the longest freespace in the data block has changed,
 	 * put the new value in the bests table and log that.
 	 */
-	if (be16_to_cpu(hdr->bestfree[0].length) != oldbest) {
-		bestsp[db] = hdr->bestfree[0].length;
+	if (be16_to_cpu(bf[0].length) != oldbest) {
+		bestsp[db] = bf[0].length;
 		xfs_dir2_leaf_log_bests(tp, lbp, db, db);
 	}
-	xfs_dir2_data_check(dp, dbp);
+	xfs_dir3_data_check(dp, dbp);
 	/*
 	 * If the data block is now empty then get rid of the data block.
 	 */
-	if (be16_to_cpu(hdr->bestfree[0].length) ==
-	    mp->m_dirblksize - (uint)sizeof(*hdr)) {
+	if (be16_to_cpu(bf[0].length) == mp->m_dirblksize - (uint)sizeof(*hdr)) {
 		ASSERT(db != mp->m_dirdatablk);
 		if ((error = xfs_dir2_shrink_inode(args, db, dbp))) {
 			/*
@@ -1809,7 +1817,7 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_dir2_data_read(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp);
+	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp);
 	if (error)
 		return error;
 
@@ -1819,9 +1827,11 @@ xfs_dir2_leaf_trim_data(
 #ifdef DEBUG
 {
 	struct xfs_dir2_data_hdr *hdr = dbp->b_addr;
+	struct xfs_dir2_data_free *bf = xfs_dir3_data_bestfree_p(hdr);
 
-	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
-	ASSERT(be16_to_cpu(hdr->bestfree[0].length) ==
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+	ASSERT(be16_to_cpu(bf[0].length) ==
 	       mp->m_dirblksize - (uint)sizeof(*hdr));
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
 }
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 480228a..3b33d7d 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -753,13 +753,13 @@ xfs_dir2_leafn_lookup_for_entry(
 				ASSERT(state->extravalid);
 				curbp = state->extrablk.bp;
 			} else {
-				error = xfs_dir2_data_read(tp, dp,
+				error = xfs_dir3_data_read(tp, dp,
 						xfs_dir2_db_to_da(mp, newdb),
 						-1, &curbp);
 				if (error)
 					return error;
 			}
-			xfs_dir2_data_check(dp, curbp);
+			xfs_dir3_data_check(dp, curbp);
 			curdb = newdb;
 		}
 		/*
@@ -787,7 +787,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.index = (int)((char *)dep -
 							(char *)curbp->b_addr);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
-			curbp->b_ops = &xfs_dir2_data_buf_ops;
+			curbp->b_ops = &xfs_dir3_data_buf_ops;
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 		}
@@ -802,7 +802,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.index = -1;
 			state->extrablk.blkno = curdb;
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
-			curbp->b_ops = &xfs_dir2_data_buf_ops;
+			curbp->b_ops = &xfs_dir3_data_buf_ops;
 		} else {
 			/* If the curbp is not the CI match block, drop it */
 			if (state->extrablk.bp != curbp)
@@ -1152,6 +1152,7 @@ xfs_dir2_leafn_remove(
 	int			needlog;	/* need to log data header */
 	int			needscan;	/* need to rescan data frees */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir2_data_free *bf;		/* bestfree table */
 
 	trace_xfs_dir2_leafn_remove(args, index);
 
@@ -1186,7 +1187,8 @@ xfs_dir2_leafn_remove(
 	dbp = dblk->bp;
 	hdr = dbp->b_addr;
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr + off);
-	longest = be16_to_cpu(hdr->bestfree[0].length);
+	bf = xfs_dir3_data_bestfree_p(hdr);
+	longest = be16_to_cpu(bf[0].length);
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, dbp, off,
 		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
@@ -1198,12 +1200,12 @@ xfs_dir2_leafn_remove(
 		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
-	xfs_dir2_data_check(dp, dbp);
+	xfs_dir3_data_check(dp, dbp);
 	/*
 	 * If the longest data block freespace changes, need to update
 	 * the corresponding freeblock entry.
 	 */
-	if (longest < be16_to_cpu(hdr->bestfree[0].length)) {
+	if (longest < be16_to_cpu(bf[0].length)) {
 		int		error;		/* error return value */
 		struct xfs_buf	*fbp;		/* freeblock buffer */
 		xfs_dir2_db_t	fdb;		/* freeblock block number */
@@ -1233,7 +1235,7 @@ xfs_dir2_leafn_remove(
 		 * Calculate which entry we need to fix.
 		 */
 		findex = xfs_dir2_db_to_fdindex(mp, db);
-		longest = be16_to_cpu(hdr->bestfree[0].length);
+		longest = be16_to_cpu(bf[0].length);
 		/*
 		 * If the data block is now empty we can get rid of it
 		 * (usually).
@@ -1612,6 +1614,7 @@ xfs_dir2_node_addname_int(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	__be16			*bests;
 	struct xfs_dir3_icfree_hdr freehdr;
+	struct xfs_dir2_data_free *bf;
 
 	dp = args->dp;
 	mp = dp->i_mount;
@@ -1869,7 +1872,8 @@ xfs_dir2_node_addname_int(
 		 * change again.
 		 */
 		hdr = dbp->b_addr;
-		bests[findex] = hdr->bestfree[0].length;
+		bf = xfs_dir3_data_bestfree_p(hdr);
+		bests[findex] = bf[0].length;
 		logfree = 1;
 	}
 	/*
@@ -1885,19 +1889,20 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Read the data block in.
 		 */
-		error = xfs_dir2_data_read(tp, dp, xfs_dir2_db_to_da(mp, dbno),
+		error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(mp, dbno),
 					   -1, &dbp);
 		if (error)
 			return error;
 		hdr = dbp->b_addr;
+		bf = xfs_dir3_data_bestfree_p(hdr);
 		logfree = 0;
 	}
-	ASSERT(be16_to_cpu(hdr->bestfree[0].length) >= length);
+	ASSERT(be16_to_cpu(bf[0].length) >= length);
 	/*
 	 * Point to the existing unused space.
 	 */
 	dup = (xfs_dir2_data_unused_t *)
-	      ((char *)hdr + be16_to_cpu(hdr->bestfree[0].offset));
+	      ((char *)hdr + be16_to_cpu(bf[0].offset));
 	needscan = needlog = 0;
 	/*
 	 * Mark the first part of the unused space, inuse for us.
@@ -1929,8 +1934,8 @@ xfs_dir2_node_addname_int(
 	 * If the freespace entry is now wrong, update it.
 	 */
 	bests = xfs_dir3_free_bests_p(mp, free); /* gcc is so stupid */
-	if (be16_to_cpu(bests[findex]) != be16_to_cpu(hdr->bestfree[0].length)) {
-		bests[findex] = hdr->bestfree[0].length;
+	if (be16_to_cpu(bests[findex]) != be16_to_cpu(bf[0].length)) {
+		bests[findex] = bf[0].length;
 		logfree = 1;
 	}
 	/*
@@ -2120,7 +2125,8 @@ xfs_dir2_node_replace(
 		 * Point to the data entry.
 		 */
 		hdr = state->extrablk.bp->b_addr;
-		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
+		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(state->mp, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index e6f2e0a..910e644 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -43,17 +43,17 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 
 /* xfs_dir2_data.c */
 #ifdef DEBUG
-#define	xfs_dir2_data_check(dp,bp) __xfs_dir2_data_check(dp, bp);
+#define	xfs_dir3_data_check(dp,bp) __xfs_dir3_data_check(dp, bp);
 #else
-#define	xfs_dir2_data_check(dp,bp)
+#define	xfs_dir3_data_check(dp,bp)
 #endif
 
-extern const struct xfs_buf_ops xfs_dir2_data_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_data_buf_ops;
 
-extern int __xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
-extern int xfs_dir2_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
+extern int __xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
+extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
-extern int xfs_dir2_data_readahead(struct xfs_trans *tp, struct xfs_inode *dp,
+extern int xfs_dir3_data_readahead(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno);
 
 extern struct xfs_dir2_data_free *
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 21b6f0b..967dad6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -915,7 +915,7 @@ xfs_dir_open(
 	 */
 	mode = xfs_ilock_map_shared(ip);
 	if (ip->i_d.di_nextents > 0)
-		xfs_dir2_data_readahead(NULL, ip, 0, -1);
+		xfs_dir3_data_readahead(NULL, ip, 0, -1);
 	xfs_iunlock(ip, mode);
 	return 0;
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
