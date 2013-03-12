Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 688CF7F9C
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:31:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 199B2304048
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:31:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kFYGFaHnIelTyIeF for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:31:21 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UFOML-0001SF-Fr
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:31:13 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UFOMG-0002Md-Cg
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:31:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/21] xfs: add CRC checking to dir2 data blocks
Date: Tue, 12 Mar 2013 23:30:46 +1100
Message-Id: <1363091454-8852-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_dir2_format.h |   21 +++++-----
 fs/xfs/xfs_dir2_leaf.c   |   71 ++++++++++++++++++--------------
 fs/xfs/xfs_dir2_node.c   |   39 ++++++++++--------
 fs/xfs/xfs_dir2_priv.h   |   12 +++---
 fs/xfs/xfs_file.c        |    2 +-
 7 files changed, 162 insertions(+), 105 deletions(-)

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 5189606..de2ae38 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -77,7 +77,7 @@ xfs_dir3_block_verify(
 		if (hdr3->magic != be32_to_cpu(XFS_DIR2_BLOCK_MAGIC))
 			return false;
 	}
-	if (__xfs_dir2_data_check(NULL, bp))
+	if (__xfs_dir3_data_check(NULL, bp))
 		return false;
 	return true;
 }
@@ -553,7 +553,7 @@ xfs_dir2_block_addname(
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir2_block_log_tail(tp, bp);
 	xfs_dir2_data_log_entry(tp, bp, dep);
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
 
@@ -596,7 +596,7 @@ xfs_dir2_block_getdents(
 	 */
 	wantoff = xfs_dir2_dataptr_to_off(mp, *offset);
 	hdr = bp->b_addr;
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	/*
 	 * Set up values for the loop.
 	 */
@@ -720,7 +720,7 @@ xfs_dir2_block_lookup(
 	dp = args->dp;
 	mp = dp->i_mount;
 	hdr = bp->b_addr;
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
@@ -771,7 +771,7 @@ xfs_dir2_block_lookup_int(
 		return error;
 
 	hdr = bp->b_addr;
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
@@ -908,7 +908,7 @@ xfs_dir2_block_removename(
 		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	/*
 	 * See if the size as a shortform is good enough.
 	 */
@@ -965,7 +965,7 @@ xfs_dir2_block_replace(
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
 	xfs_dir2_data_log_entry(args->trans, bp, dep);
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
 
@@ -1046,12 +1046,14 @@ xfs_dir2_leaf_to_block(
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
@@ -1329,6 +1331,6 @@ xfs_dir2_sf_to_block(
 	ASSERT(needscan == 0);
 	xfs_dir2_block_log_leaf(tp, bp, 0, be32_to_cpu(btp->count) - 1);
 	xfs_dir2_block_log_tail(tp, bp);
-	xfs_dir2_data_check(dp, bp);
+	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 8484ec4..86ac9c0 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -31,6 +31,8 @@
 #include "xfs_dir2_format.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
+#include "xfs_buf_item.h"
+#include "xfs_cksum.h"
 
 STATIC xfs_dir2_data_free_t *
 xfs_dir2_data_freefind(xfs_dir2_data_hdr_t *hdr, xfs_dir2_data_unused_t *dup);
@@ -41,7 +43,7 @@ xfs_dir2_data_freefind(xfs_dir2_data_hdr_t *hdr, xfs_dir2_data_unused_t *dup);
  * Return 0 is the buffer is good, otherwise an error.
  */
 int
-__xfs_dir2_data_check(
+__xfs_dir3_data_check(
 	struct xfs_inode	*dp,		/* incore inode pointer */
 	struct xfs_buf		*bp)		/* data block's buffer */
 {
@@ -76,6 +78,7 @@ __xfs_dir2_data_check(
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
 		break;
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 		endp = (char *)hdr + mp->m_dirblksize;
 		break;
@@ -189,21 +192,27 @@ __xfs_dir2_data_check(
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
+	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
-	block_ok = hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC);
-	block_ok = block_ok && __xfs_dir2_data_check(NULL, bp) == 0;
-
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
@@ -212,7 +221,7 @@ xfs_dir2_data_verify(
  * format buffer or a data format buffer on readahead.
  */
 static void
-xfs_dir2_data_reada_verify(
+xfs_dir3_data_reada_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
@@ -225,7 +234,8 @@ xfs_dir2_data_reada_verify(
 		bp->b_ops->verify_read(bp);
 		return;
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
-		xfs_dir2_data_verify(bp);
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
+		xfs_dir3_data_verify(bp);
 		return;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
@@ -235,32 +245,56 @@ xfs_dir2_data_reada_verify(
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
@@ -268,18 +302,18 @@ xfs_dir2_data_read(
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
@@ -309,6 +343,7 @@ xfs_dir2_data_freefind(
 	 * one we're looking for it has to be exact.
 	 */
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 	for (dfp = &bf[0], seenzero = matched = 0;
@@ -458,6 +493,7 @@ xfs_dir2_data_freescan(
 	char			*p;		/* current entry pointer */
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
@@ -534,13 +570,12 @@ xfs_dir3_data_init(
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
 
@@ -591,6 +626,7 @@ xfs_dir2_data_log_entry(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
@@ -610,6 +646,7 @@ xfs_dir2_data_log_header(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
@@ -628,6 +665,7 @@ xfs_dir2_data_log_unused(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
@@ -675,7 +713,8 @@ xfs_dir2_data_make_free(
 	/*
 	 * Figure out where the end of the data area is.
 	 */
-	if (hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC))
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	    hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC))
 		endptr = (char *)hdr + mp->m_dirblksize;
 	else {
 		xfs_dir2_block_tail_t	*btp;	/* block tail */
@@ -857,6 +896,7 @@ xfs_dir2_data_use_free(
 
 	hdr = bp->b_addr;
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 	ASSERT(be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG);
diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
index bec058f..dfc8ccf 100644
--- a/fs/xfs/xfs_dir2_format.h
+++ b/fs/xfs/xfs_dir2_format.h
@@ -283,7 +283,8 @@ struct xfs_dir3_data_hdr {
 	static inline struct xfs_dir2_data_free *
 xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 {
-	if (hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
+	if (hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
+	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		struct xfs_dir3_data_hdr *hdr3 = (struct xfs_dir3_data_hdr *)hdr;
 		return hdr3->best_free;
 	}
@@ -345,17 +346,6 @@ xfs_dir2_data_unused_tag_p(struct xfs_dir2_data_unused *dup)
 			be16_to_cpu(dup->length) - sizeof(__be16));
 }
 
-static inline struct xfs_dir2_data_unused *
-xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
-{
-	if (hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
-		return (struct xfs_dir2_data_unused *)
-			((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
-	}
-	return (struct xfs_dir2_data_unused *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
-}
-
 static inline size_t
 xfs_dir3_data_hdr_size(bool dir3)
 {
@@ -379,6 +369,13 @@ xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
 		((char *)hdr + xfs_dir3_data_entry_offset(hdr));
 }
 
+static inline struct xfs_dir2_data_unused *
+xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_unused *)
+		((char *)hdr + xfs_dir3_data_entry_offset(hdr));
+}
+
 /*
  * Offsets of . and .. in data space (always block 0)
  */
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 979735b..c7dca95 100644
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
@@ -1135,17 +1142,17 @@ xfs_dir2_leaf_getdents(
 				ASSERT(xfs_dir2_byte_to_db(mp, curoff) ==
 				       map_info->curdb);
 			hdr = bp->b_addr;
-			xfs_dir2_data_check(dp, bp);
+			xfs_dir3_data_check(dp, bp);
 			/*
 			 * Find our position in the block.
 			 */
-			ptr = (char *)(hdr + 1);
+			ptr = (char *)xfs_dir3_data_entry_p(hdr);
 			byteoff = xfs_dir2_byte_to_off(mp, curoff);
 			/*
 			 * Skip past the header.
 			 */
 			if (byteoff == 0)
-				curoff += (uint)sizeof(*hdr);
+				curoff += xfs_dir3_data_entry_offset(hdr);
 			/*
 			 * Skip past entries until we reach our offset.
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
@@ -1620,16 +1629,16 @@ xfs_dir2_leaf_removename(
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
+	if (be16_to_cpu(bf[0].length) ==
+			mp->m_dirblksize - xfs_dir3_data_entry_offset(hdr)) {
 		ASSERT(db != mp->m_dirdatablk);
 		if ((error = xfs_dir2_shrink_inode(args, db, dbp))) {
 			/*
@@ -1809,7 +1818,7 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_dir2_data_read(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp);
+	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp);
 	if (error)
 		return error;
 
@@ -1819,10 +1828,12 @@ xfs_dir2_leaf_trim_data(
 #ifdef DEBUG
 {
 	struct xfs_dir2_data_hdr *hdr = dbp->b_addr;
+	struct xfs_dir2_data_free *bf = xfs_dir3_data_bestfree_p(hdr);
 
-	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
-	ASSERT(be16_to_cpu(hdr->bestfree[0].length) ==
-	       mp->m_dirblksize - (uint)sizeof(*hdr));
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+	ASSERT(be16_to_cpu(bf[0].length) ==
+	       mp->m_dirblksize - xfs_dir3_data_entry_offset(hdr));
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
 }
 #endif
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 074fa68..14067a4 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -754,13 +754,13 @@ xfs_dir2_leafn_lookup_for_entry(
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
@@ -788,7 +788,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.index = (int)((char *)dep -
 							(char *)curbp->b_addr);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
-			curbp->b_ops = &xfs_dir2_data_buf_ops;
+			curbp->b_ops = &xfs_dir3_data_buf_ops;
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 		}
@@ -803,7 +803,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.index = -1;
 			state->extrablk.blkno = curdb;
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
-			curbp->b_ops = &xfs_dir2_data_buf_ops;
+			curbp->b_ops = &xfs_dir3_data_buf_ops;
 		} else {
 			/* If the curbp is not the CI match block, drop it */
 			if (state->extrablk.bp != curbp)
@@ -1153,6 +1153,7 @@ xfs_dir2_leafn_remove(
 	int			needlog;	/* need to log data header */
 	int			needscan;	/* need to rescan data frees */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir2_data_free *bf;		/* bestfree table */
 
 	trace_xfs_dir2_leafn_remove(args, index);
 
@@ -1187,7 +1188,8 @@ xfs_dir2_leafn_remove(
 	dbp = dblk->bp;
 	hdr = dbp->b_addr;
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr + off);
-	longest = be16_to_cpu(hdr->bestfree[0].length);
+	bf = xfs_dir3_data_bestfree_p(hdr);
+	longest = be16_to_cpu(bf[0].length);
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, dbp, off,
 		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
@@ -1199,12 +1201,12 @@ xfs_dir2_leafn_remove(
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
@@ -1234,12 +1236,13 @@ xfs_dir2_leafn_remove(
 		 * Calculate which entry we need to fix.
 		 */
 		findex = xfs_dir2_db_to_fdindex(mp, db);
-		longest = be16_to_cpu(hdr->bestfree[0].length);
+		longest = be16_to_cpu(bf[0].length);
 		/*
 		 * If the data block is now empty we can get rid of it
 		 * (usually).
 		 */
-		if (longest == mp->m_dirblksize - (uint)sizeof(*hdr)) {
+		if (longest == mp->m_dirblksize -
+			       xfs_dir3_data_entry_offset(hdr)) {
 			/*
 			 * Try to punch out the data block.
 			 */
@@ -1613,6 +1616,7 @@ xfs_dir2_node_addname_int(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	__be16			*bests;
 	struct xfs_dir3_icfree_hdr freehdr;
+	struct xfs_dir2_data_free *bf;
 
 	dp = args->dp;
 	mp = dp->i_mount;
@@ -1870,7 +1874,8 @@ xfs_dir2_node_addname_int(
 		 * change again.
 		 */
 		hdr = dbp->b_addr;
-		bests[findex] = hdr->bestfree[0].length;
+		bf = xfs_dir3_data_bestfree_p(hdr);
+		bests[findex] = bf[0].length;
 		logfree = 1;
 	}
 	/*
@@ -1886,19 +1891,20 @@ xfs_dir2_node_addname_int(
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
@@ -1930,8 +1936,8 @@ xfs_dir2_node_addname_int(
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
@@ -2121,7 +2127,8 @@ xfs_dir2_node_replace(
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
index 36eb41d..89a32ef 100644
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
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
