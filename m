Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C0C3D7F6F
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 19:32:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF86D304039
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 17:32:33 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HHT2JqFgVeSeRQvY for <xfs@oss.sgi.com>;
	Sun, 24 Feb 2013 17:32:30 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1U9mv3-0002su-BH
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:31:53 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1U9mut-0003IS-8Y
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:31:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/16] xfs: add CRC checking to dir2 free blocks
Date: Mon, 25 Feb 2013 12:31:36 +1100
Message-Id: <1361755901-12453-12-git-send-email-david@fromorbit.com>
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

This addition follows the same pattern as the dir2 block CRCs, but
with a few differences. The main difference is that the free block
header is different between the v2 and v3 formats, so an "in-core"
free block header has been added and _todisk/_from_disk functions
used to abstract the differences in structure format from the code.
This is similar to the on-disk superblock versus the in-core
superblock setup. The in-core strucutre is populated when the buffer
is read from disk, all the in memory checks and modifications are
done on the in-core version of the structure which is written back
to the buffer before the buffer is logged.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_format.h |   52 ++++-
 fs/xfs/xfs_dir2_leaf.c   |    2 +-
 fs/xfs/xfs_dir2_node.c   |  475 +++++++++++++++++++++++++++++++---------------
 3 files changed, 373 insertions(+), 156 deletions(-)

diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
index ccd15a29..96390ef 100644
--- a/fs/xfs/xfs_dir2_format.h
+++ b/fs/xfs/xfs_dir2_format.h
@@ -65,6 +65,7 @@
 
 #define	XFS_DIR3_BLOCK_MAGIC	0x58444233	/* XDB3: single block dirs */
 #define	XFS_DIR3_DATA_MAGIC	0x58444433	/* XDD3: multiblock dirs */
+#define	XFS_DIR3_FREE_MAGIC	0x58444633	/* XDF3: free index blocks */
 
 /*
  * Byte offset in data block and shortform entry.
@@ -654,19 +655,62 @@ typedef struct xfs_dir2_free {
 						/* unused entries are -1 */
 } xfs_dir2_free_t;
 
-static inline int xfs_dir2_free_max_bests(struct xfs_mount *mp)
+struct xfs_dir3_free_hdr {
+	struct xfs_dir3_blk_hdr	hdr;
+	__be32			firstdb;	/* db of first entry */
+	__be32			nvalid;		/* count of valid entries */
+	__be32			nused;		/* count of used entries */
+};
+
+struct xfs_dir3_free {
+	struct xfs_dir3_free_hdr hdr;
+	__be16			bests[];	/* best free counts */
+						/* unused entries are -1 */
+};
+
+#define XFS_DIR3_FREE_CRC_OFF  offsetof(struct xfs_dir3_free, hdr.hdr.crc)
+
+/*
+ * In core version of the free block header, abstracted away from on-disk format
+ * differences. Use this in the code, and convert to/from the disk version using
+ * xfs_dir3_free_hdr_from_disk/xfs_dir3_free_hdr_to_disk.
+ */
+struct xfs_dir3_icfree_hdr {
+	__uint32_t	magic;
+	__uint32_t	firstdb;
+	__uint32_t	nvalid;
+	__uint32_t	nused;
+
+};
+
+static inline int
+xfs_dir3_free_hdr_size(struct xfs_mount *mp)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return sizeof(struct xfs_dir3_free_hdr);
+	return sizeof(struct xfs_dir2_free_hdr);
+}
+
+static inline int
+xfs_dir3_free_max_bests(struct xfs_mount *mp)
 {
-	return (mp->m_dirblksize - sizeof(struct xfs_dir2_free_hdr)) /
+	return (mp->m_dirblksize - xfs_dir3_free_hdr_size(mp)) /
 		sizeof(xfs_dir2_data_off_t);
 }
 
+static inline __be16 *
+xfs_dir3_free_bests_p(struct xfs_mount *mp, struct xfs_dir2_free *free)
+{
+	return (__be16 *)((char *)free + xfs_dir3_free_hdr_size(mp));
+}
+
 /*
  * Convert data space db to the corresponding free db.
  */
 static inline xfs_dir2_db_t
 xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
-	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir2_free_max_bests(mp);
+	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir3_free_max_bests(mp);
 }
 
 /*
@@ -675,7 +719,7 @@ xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
 static inline int
 xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
-	return db % xfs_dir2_free_max_bests(mp);
+	return db % xfs_dir3_free_max_bests(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index ef163f0..4adee8b 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1971,7 +1971,7 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Set up the leaf bests table.
 	 */
-	memcpy(xfs_dir2_leaf_bests_p(ltp), free->bests,
+	memcpy(xfs_dir2_leaf_bests_p(ltp), xfs_dir3_free_bests_p(mp, free),
 		be32_to_cpu(ltp->bestcount) * sizeof(xfs_dir2_data_off_t));
 	xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 	xfs_dir2_leaf_log_tail(tp, lbp);
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 985d70b..480228a 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -32,6 +32,8 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_buf_item.h"
+#include "xfs_cksum.h"
 
 /*
  * Function declarations.
@@ -55,44 +57,78 @@ static int xfs_dir2_leafn_remove(xfs_da_args_t *args, struct xfs_buf *bp,
 static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
 				     xfs_da_state_blk_t *fblk);
 
-static void
-xfs_dir2_free_verify(
+static bool
+xfs_dir3_free_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_free_hdr *hdr = bp->b_addr;
-	int			block_ok = 0;
 
-	block_ok = hdr->magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC);
-	if (!block_ok) {
-		XFS_CORRUPTION_ERROR("xfs_dir2_free_verify magic",
-				     XFS_ERRLEVEL_LOW, mp, hdr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
+
+		if (hdr3->magic != be32_to_cpu(XFS_DIR3_FREE_MAGIC))
+			return false;
+		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
+			return false;
+		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
+			return false;
+	} else {
+		if (hdr->magic != be32_to_cpu(XFS_DIR2_FREE_MAGIC))
+			return false;
 	}
+
+	/* XXX: should bounds check the xfs_dir3_icfree_hdr here */
+
+	return true;
 }
 
 static void
-xfs_dir2_free_read_verify(
+xfs_dir3_free_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_free_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					  XFS_DIR3_FREE_CRC_OFF)) ||
+	    !xfs_dir3_free_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
 }
 
 static void
-xfs_dir2_free_write_verify(
+xfs_dir3_free_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_free_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+
+	if (!xfs_dir3_free_verify(bp)) {
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
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_FREE_CRC_OFF);
 }
 
-static const struct xfs_buf_ops xfs_dir2_free_buf_ops = {
-	.verify_read = xfs_dir2_free_read_verify,
-	.verify_write = xfs_dir2_free_write_verify,
+static const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
+	.verify_read = xfs_dir3_free_read_verify,
+	.verify_write = xfs_dir3_free_write_verify,
 };
 
 
 static int
-__xfs_dir2_free_read(
+__xfs_dir3_free_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		fbno,
@@ -100,7 +136,7 @@ __xfs_dir2_free_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-				XFS_DATA_FORK, &xfs_dir2_free_buf_ops);
+				XFS_DATA_FORK, &xfs_dir3_free_buf_ops);
 }
 
 int
@@ -110,7 +146,7 @@ xfs_dir2_free_read(
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir2_free_read(tp, dp, fbno, -1, bpp);
+	return __xfs_dir3_free_read(tp, dp, fbno, -1, bpp);
 }
 
 static int
@@ -120,7 +156,95 @@ xfs_dir2_free_try_read(
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir2_free_read(tp, dp, fbno, -2, bpp);
+	return __xfs_dir3_free_read(tp, dp, fbno, -2, bpp);
+}
+
+
+static void
+xfs_dir3_free_hdr_from_disk(
+	struct xfs_dir3_icfree_hdr	*to,
+	struct xfs_dir2_free		*from)
+{
+	if (from->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC)) {
+		to->magic = be32_to_cpu(from->hdr.magic);
+		to->firstdb = be32_to_cpu(from->hdr.firstdb);
+		to->nvalid = be32_to_cpu(from->hdr.nvalid);
+		to->nused = be32_to_cpu(from->hdr.nused);
+	} else {
+		struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)from;
+
+		to->magic = be32_to_cpu(hdr3->hdr.magic);
+		to->firstdb = be32_to_cpu(hdr3->firstdb);
+		to->nvalid = be32_to_cpu(hdr3->nvalid);
+		to->nused = be32_to_cpu(hdr3->nused);
+	}
+
+	ASSERT(to->magic == XFS_DIR2_FREE_MAGIC ||
+	       to->magic == XFS_DIR3_FREE_MAGIC);
+}
+
+static void
+xfs_dir3_free_hdr_to_disk(
+	struct xfs_dir2_free		*to,
+	struct xfs_dir3_icfree_hdr	*from)
+{
+	ASSERT(from->magic == XFS_DIR2_FREE_MAGIC ||
+	       from->magic == XFS_DIR3_FREE_MAGIC);
+
+	if (from->magic == XFS_DIR2_FREE_MAGIC) {
+		to->hdr.magic = cpu_to_be32(from->magic);
+		to->hdr.firstdb = cpu_to_be32(from->firstdb);
+		to->hdr.nvalid = cpu_to_be32(from->nvalid);
+		to->hdr.nused = cpu_to_be32(from->nused);
+	} else {
+		struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)to;
+
+		hdr3->hdr.magic = cpu_to_be32(from->magic);
+		hdr3->firstdb = cpu_to_be32(from->firstdb);
+		hdr3->nvalid = cpu_to_be32(from->nvalid);
+		hdr3->nused = cpu_to_be32(from->nused);
+	}
+}
+
+static int
+xfs_dir3_free_get_buf(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dir2_db_t		fbno,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*bp;
+	int			error;
+	struct xfs_dir3_icfree_hdr hdr;
+
+	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, fbno),
+				   -1, &bp, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	bp->b_ops = &xfs_dir3_free_buf_ops;;
+
+	/*
+	 * Initialize the new block to be empty, and remember
+	 * its first slot as our empty slot.
+	 */
+	hdr.magic = XFS_DIR2_FREE_MAGIC;
+	hdr.firstdb = 0;
+	hdr.nused = 0;
+	hdr.nvalid = 0;
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
+
+		hdr.magic = XFS_DIR3_FREE_MAGIC;
+		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
+		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
+		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_uuid);
+
+	}
+	xfs_dir3_free_hdr_to_disk(bp->b_addr, &hdr);
+	*bpp = bp;
+	return 0;
 }
 
 /*
@@ -134,13 +258,16 @@ xfs_dir2_free_log_bests(
 	int			last)		/* last entry to log */
 {
 	xfs_dir2_free_t		*free;		/* freespace structure */
+	__be16			*bests;
 
 	free = bp->b_addr;
-	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
+	bests = xfs_dir3_free_bests_p(tp->t_mountp, free);
+	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
+	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	xfs_trans_log_buf(tp, bp,
-		(uint)((char *)&free->bests[first] - (char *)free),
-		(uint)((char *)&free->bests[last] - (char *)free +
-		       sizeof(free->bests[0]) - 1));
+		(uint)((char *)&bests[first] - (char *)free),
+		(uint)((char *)&bests[last] - (char *)free +
+		       sizeof(bests[0]) - 1));
 }
 
 /*
@@ -154,9 +281,9 @@ xfs_dir2_free_log_header(
 	xfs_dir2_free_t		*free;		/* freespace structure */
 
 	free = bp->b_addr;
-	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
-	xfs_trans_log_buf(tp, bp, (uint)((char *)&free->hdr - (char *)free),
-		(uint)(sizeof(xfs_dir2_free_hdr_t) - 1));
+	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
+	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
+	xfs_trans_log_buf(tp, bp, 0, xfs_dir3_free_hdr_size(tp->t_mountp) - 1);
 }
 
 /*
@@ -183,6 +310,7 @@ xfs_dir2_leaf_to_node(
 	xfs_dir2_data_off_t	off;		/* freespace entry value */
 	__be16			*to;		/* pointer to freespace entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir3_icfree_hdr freehdr;
 
 	trace_xfs_dir2_leaf_to_node(args);
 
@@ -199,43 +327,43 @@ xfs_dir2_leaf_to_node(
 	/*
 	 * Get the buffer for the new freespace block.
 	 */
-	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, fdb), -1, &fbp,
-				XFS_DATA_FORK);
+	error = xfs_dir3_free_get_buf(tp, dp, fdb, &fbp);
 	if (error)
 		return error;
-	fbp->b_ops = &xfs_dir2_free_buf_ops;
 
 	free = fbp->b_addr;
+	xfs_dir3_free_hdr_from_disk(&freehdr, free);
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
-	/*
-	 * Initialize the freespace block header.
-	 */
-	free->hdr.magic = cpu_to_be32(XFS_DIR2_FREE_MAGIC);
-	free->hdr.firstdb = 0;
-	ASSERT(be32_to_cpu(ltp->bestcount) <= (uint)dp->i_d.di_size / mp->m_dirblksize);
-	free->hdr.nvalid = ltp->bestcount;
+	ASSERT(be32_to_cpu(ltp->bestcount) <=
+				(uint)dp->i_d.di_size / mp->m_dirblksize);
+
 	/*
 	 * Copy freespace entries from the leaf block to the new block.
 	 * Count active entries.
 	 */
-	for (i = n = 0, from = xfs_dir2_leaf_bests_p(ltp), to = free->bests;
-	     i < be32_to_cpu(ltp->bestcount); i++, from++, to++) {
+	from = xfs_dir2_leaf_bests_p(ltp);
+	to = xfs_dir3_free_bests_p(mp, free);
+	for (i = n = 0; i < be32_to_cpu(ltp->bestcount); i++, from++, to++) {
 		if ((off = be16_to_cpu(*from)) != NULLDATAOFF)
 			n++;
 		*to = cpu_to_be16(off);
 	}
-	free->hdr.nused = cpu_to_be32(n);
-
-	lbp->b_ops = &xfs_dir2_leafn_buf_ops;
-	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
 
 	/*
-	 * Log everything.
+	 * Now initialize the freespace block header.
 	 */
-	xfs_dir2_leaf_log_header(tp, lbp);
+	freehdr.nused = n;
+	freehdr.nvalid = be32_to_cpu(ltp->bestcount);
+
+	xfs_dir3_free_hdr_to_disk(fbp->b_addr, &freehdr);
+	xfs_dir2_free_log_bests(tp, fbp, 0, freehdr.nvalid - 1);
 	xfs_dir2_free_log_header(tp, fbp);
-	xfs_dir2_free_log_bests(tp, fbp, 0, be32_to_cpu(free->hdr.nvalid) - 1);
+
+	/* convert the leaf to a leafnode */
+	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
+	lbp->b_ops = &xfs_dir2_leafn_buf_ops;
+	xfs_dir2_leaf_log_header(tp, lbp);
 	xfs_dir2_leafn_check(dp, lbp);
 	return 0;
 }
@@ -354,6 +482,23 @@ xfs_dir2_leafn_check(
 	}
 	ASSERT(be16_to_cpu(leaf->hdr.stale) == stale);
 }
+
+static void
+xfs_dir2_free_hdr_check(
+	struct xfs_mount *mp,
+	struct xfs_buf	*bp,
+	xfs_dir2_db_t	db)
+{
+	struct xfs_dir3_icfree_hdr hdr;
+
+	xfs_dir3_free_hdr_from_disk(&hdr, bp->b_addr);
+
+	ASSERT((hdr.firstdb % xfs_dir3_free_max_bests(mp)) == 0);
+	ASSERT(hdr.firstdb <= db);
+	ASSERT(db < hdr.firstdb + hdr.nvalid);
+}
+#else
+#define xfs_dir2_free_hdr_check(mp, dp, db)
 #endif	/* DEBUG */
 
 /*
@@ -424,7 +569,8 @@ xfs_dir2_leafn_lookup_for_addname(
 		curbp = state->extrablk.bp;
 		curfdb = state->extrablk.blkno;
 		free = curbp->b_addr;
-		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
+		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
+		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	}
 	length = xfs_dir2_data_entsize(args->namelen);
 	/*
@@ -451,6 +597,8 @@ xfs_dir2_leafn_lookup_for_addname(
 		 * in hand, take a look at it.
 		 */
 		if (newdb != curdb) {
+			__be16 *bests;
+
 			curdb = newdb;
 			/*
 			 * Convert the data block to the free block
@@ -473,13 +621,8 @@ xfs_dir2_leafn_lookup_for_addname(
 				if (error)
 					return error;
 				free = curbp->b_addr;
-				ASSERT(be32_to_cpu(free->hdr.magic) ==
-					XFS_DIR2_FREE_MAGIC);
-				ASSERT((be32_to_cpu(free->hdr.firstdb) %
-					xfs_dir2_free_max_bests(mp)) == 0);
-				ASSERT(be32_to_cpu(free->hdr.firstdb) <= curdb);
-				ASSERT(curdb < be32_to_cpu(free->hdr.firstdb) +
-					be32_to_cpu(free->hdr.nvalid));
+
+				xfs_dir2_free_hdr_check(mp, curbp, curdb);
 			}
 			/*
 			 * Get the index for our entry.
@@ -488,8 +631,8 @@ xfs_dir2_leafn_lookup_for_addname(
 			/*
 			 * If it has room, return it.
 			 */
-			if (unlikely(free->bests[fi] ==
-			    cpu_to_be16(NULLDATAOFF))) {
+			bests = xfs_dir3_free_bests_p(mp, free);
+			if (unlikely(bests[fi] == cpu_to_be16(NULLDATAOFF))) {
 				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
 							XFS_ERRLEVEL_LOW, mp);
 				if (curfdb != newfdb)
@@ -497,7 +640,7 @@ xfs_dir2_leafn_lookup_for_addname(
 				return XFS_ERROR(EFSCORRUPTED);
 			}
 			curfdb = newfdb;
-			if (be16_to_cpu(free->bests[fi]) >= length)
+			if (be16_to_cpu(bests[fi]) >= length)
 				goto out;
 		}
 	}
@@ -511,6 +654,12 @@ out:
 		state->extrablk.bp = curbp;
 		state->extrablk.index = fi;
 		state->extrablk.blkno = curfdb;
+
+		/*
+		 * Important: this magic number is not in the buffer - it's for
+		 * buffer type information and therefore only the free/data type
+		 * matters here, not whether CRCs are enabled or not.
+		 */
 		state->extrablk.magic = XFS_DIR2_FREE_MAGIC;
 	} else {
 		state->extravalid = 0;
@@ -898,7 +1047,7 @@ xfs_dir2_leafn_rebalance(
 }
 
 static int
-xfs_dir2_data_block_free(
+xfs_dir3_data_block_free(
 	xfs_da_args_t		*args,
 	struct xfs_dir2_data_hdr *hdr,
 	struct xfs_dir2_free	*free,
@@ -909,59 +1058,68 @@ xfs_dir2_data_block_free(
 {
 	struct xfs_trans	*tp = args->trans;
 	int			logfree = 0;
+	__be16			*bests;
+	struct xfs_dir3_icfree_hdr freehdr;
 
-	if (!hdr) {
-		/* One less used entry in the free table.  */
-		be32_add_cpu(&free->hdr.nused, -1);
-		xfs_dir2_free_log_header(tp, fbp);
 
-		/*
-		 * If this was the last entry in the table, we can trim the
-		 * table size back.  There might be other entries at the end
-		 * referring to non-existent data blocks, get those too.
-		 */
-		if (findex == be32_to_cpu(free->hdr.nvalid) - 1) {
-			int	i;		/* free entry index */
+	xfs_dir3_free_hdr_from_disk(&freehdr, free);
 
-			for (i = findex - 1; i >= 0; i--) {
-				if (free->bests[i] != cpu_to_be16(NULLDATAOFF))
-					break;
-			}
-			free->hdr.nvalid = cpu_to_be32(i + 1);
-			logfree = 0;
-		} else {
-			/* Not the last entry, just punch it out.  */
-			free->bests[findex] = cpu_to_be16(NULLDATAOFF);
-			logfree = 1;
-		}
+	bests = xfs_dir3_free_bests_p(tp->t_mountp, free);
+	if (hdr) {
 		/*
-		 * If there are no useful entries left in the block,
-		 * get rid of the block if we can.
+		 * Data block is not empty, just set the free entry to the new
+		 * value.
 		 */
-		if (!free->hdr.nused) {
-			int error;
+		bests[findex] = cpu_to_be16(longest);
+		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
+		return 0;
+	}
 
-			error = xfs_dir2_shrink_inode(args, fdb, fbp);
-			if (error == 0) {
-				fbp = NULL;
-				logfree = 0;
-			} else if (error != ENOSPC || args->total != 0)
-				return error;
-			/*
-			 * It's possible to get ENOSPC if there is no
-			 * space reservation.  In this case some one
-			 * else will eventually get rid of this block.
-			 */
+	/*
+	 * One less used entry in the free table. Unused is not converted
+	 * because we only need to know if it zero
+	 */
+	freehdr.nused--;
+
+	if (findex == freehdr.nvalid - 1) {
+		int	i;		/* free entry index */
+
+		for (i = findex - 1; i >= 0; i--) {
+			if (bests[i] != cpu_to_be16(NULLDATAOFF))
+				break;
 		}
+		freehdr.nvalid = i + 1;
+		logfree = 0;
 	} else {
+		/* Not the last entry, just punch it out.  */
+		bests[findex] = cpu_to_be16(NULLDATAOFF);
+		logfree = 1;
+	}
+
+	xfs_dir3_free_hdr_to_disk(free, &freehdr);
+	xfs_dir2_free_log_header(tp, fbp);
+
+	/*
+	 * If there are no useful entries left in the block, get rid of the
+	 * block if we can.
+	 */
+	if (!freehdr.nused) {
+		int error;
+
+		error = xfs_dir2_shrink_inode(args, fdb, fbp);
+		if (error == 0) {
+			fbp = NULL;
+			logfree = 0;
+		} else if (error != ENOSPC || args->total != 0)
+			return error;
 		/*
-		 * Data block is not empty, just set the free entry to the new
-		 * value.
+		 * It's possible to get ENOSPC if there is no
+		 * space reservation.  In this case some one
+		 * else will eventually get rid of this block.
 		 */
-		free->bests[findex] = cpu_to_be16(longest);
-		logfree = 1;
 	}
 
+
 	/* Log the free entry that changed, unless we got rid of it.  */
 	if (logfree)
 		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
@@ -1062,10 +1220,15 @@ xfs_dir2_leafn_remove(
 		if (error)
 			return error;
 		free = fbp->b_addr;
-		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
-		ASSERT(be32_to_cpu(free->hdr.firstdb) ==
-		       xfs_dir2_free_max_bests(mp) *
-		       (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
+#ifdef DEBUG
+	{
+		struct xfs_dir3_icfree_hdr freehdr;
+		xfs_dir3_free_hdr_from_disk(&freehdr, free);
+		ASSERT(be32_to_cpu(freehdr.firstdb) ==
+				       xfs_dir3_free_max_bests(mp) *
+				       (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
+	}
+#endif
 		/*
 		 * Calculate which entry we need to fix.
 		 */
@@ -1096,7 +1259,7 @@ xfs_dir2_leafn_remove(
 		 * If we got rid of the data block, we can eliminate that entry
 		 * in the free block.
 		 */
-		error = xfs_dir2_data_block_free(args, hdr, free,
+		error = xfs_dir3_data_block_free(args, hdr, free,
 						 fdb, findex, fbp, longest);
 		if (error)
 			return error;
@@ -1447,6 +1610,8 @@ xfs_dir2_node_addname_int(
 	int			needscan;	/* need to rescan data frees */
 	__be16			*tagp;		/* data entry tag pointer */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	__be16			*bests;
+	struct xfs_dir3_icfree_hdr freehdr;
 
 	dp = args->dp;
 	mp = dp->i_mount;
@@ -1464,36 +1629,37 @@ xfs_dir2_node_addname_int(
 		 */
 		ifbno = fblk->blkno;
 		free = fbp->b_addr;
-		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 		findex = fblk->index;
+		bests = xfs_dir3_free_bests_p(mp, free);
+		xfs_dir3_free_hdr_from_disk(&freehdr, free);
+
 		/*
 		 * This means the free entry showed that the data block had
 		 * space for our entry, so we remembered it.
 		 * Use that data block.
 		 */
 		if (findex >= 0) {
-			ASSERT(findex < be32_to_cpu(free->hdr.nvalid));
-			ASSERT(be16_to_cpu(free->bests[findex]) != NULLDATAOFF);
-			ASSERT(be16_to_cpu(free->bests[findex]) >= length);
-			dbno = be32_to_cpu(free->hdr.firstdb) + findex;
-		}
-		/*
-		 * The data block looked at didn't have enough room.
-		 * We'll start at the beginning of the freespace entries.
-		 */
-		else {
+			ASSERT(findex < freehdr.nvalid);
+			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
+			ASSERT(be16_to_cpu(bests[findex]) >= length);
+			dbno = freehdr.firstdb + findex;
+		} else {
+			/*
+			 * The data block looked at didn't have enough room.
+			 * We'll start at the beginning of the freespace entries.
+			 */
 			dbno = -1;
 			findex = 0;
 		}
-	}
-	/*
-	 * Didn't come in with a freespace block, so don't have a data block.
-	 */
-	else {
+	} else {
+		/*
+		 * Didn't come in with a freespace block, so no data block.
+		 */
 		ifbno = dbno = -1;
 		fbp = NULL;
 		findex = 0;
 	}
+
 	/*
 	 * If we don't have a data block yet, we're going to scan the
 	 * freespace blocks looking for one.  Figure out what the
@@ -1547,20 +1713,26 @@ xfs_dir2_node_addname_int(
 			if (!fbp)
 				continue;
 			free = fbp->b_addr;
-			ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 			findex = 0;
 		}
 		/*
 		 * Look at the current free entry.  Is it good enough?
+		 *
+		 * The bests initialisation should be wher eteh bufer is read in
+		 * the above branch. But gcc is too stupid to realise that bests
+		 * iand the freehdr are actually initialised if they are placed
+		 * there, so we have to do it here to avoid warnings. Blech.
 		 */
-		if (be16_to_cpu(free->bests[findex]) != NULLDATAOFF &&
-		    be16_to_cpu(free->bests[findex]) >= length)
-			dbno = be32_to_cpu(free->hdr.firstdb) + findex;
+		bests = xfs_dir3_free_bests_p(mp, free);
+		xfs_dir3_free_hdr_from_disk(&freehdr, free);
+		if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
+		    be16_to_cpu(bests[findex]) >= length)
+			dbno = freehdr.firstdb + findex;
 		else {
 			/*
 			 * Are we done with the freeblock?
 			 */
-			if (++findex == be32_to_cpu(free->hdr.nvalid)) {
+			if (++findex == freehdr.nvalid) {
 				/*
 				 * Drop the block.
 				 */
@@ -1614,11 +1786,11 @@ xfs_dir2_node_addname_int(
 		 * If there wasn't a freespace block, the read will
 		 * return a NULL fbp.  Allocate and initialize a new one.
 		 */
-		if( fbp == NULL ) {
-			if ((error = xfs_dir2_grow_inode(args, XFS_DIR2_FREE_SPACE,
-							&fbno))) {
+		if(!fbp) {
+			error = xfs_dir2_grow_inode(args, XFS_DIR2_FREE_SPACE,
+						    &fbno);
+			if (error)
 				return error;
-			}
 
 			if (unlikely(xfs_dir2_db_to_fdb(mp, dbno) != fbno)) {
 				xfs_alert(mp,
@@ -1646,27 +1818,24 @@ xfs_dir2_node_addname_int(
 			/*
 			 * Get a buffer for the new block.
 			 */
-			error = xfs_da_get_buf(tp, dp,
-					       xfs_dir2_db_to_da(mp, fbno),
-					       -1, &fbp, XFS_DATA_FORK);
+			error = xfs_dir3_free_get_buf(tp, dp, fbno, &fbp);
 			if (error)
 				return error;
-			fbp->b_ops = &xfs_dir2_free_buf_ops;
+			free = fbp->b_addr;
+			bests = xfs_dir3_free_bests_p(mp, free);
+			xfs_dir3_free_hdr_from_disk(&freehdr, free);
 
 			/*
-			 * Initialize the new block to be empty, and remember
-			 * its first slot as our empty slot.
+			 * Remember the first slot as our empty slot.
 			 */
-			free = fbp->b_addr;
-			free->hdr.magic = cpu_to_be32(XFS_DIR2_FREE_MAGIC);
-			free->hdr.firstdb = cpu_to_be32(
-				(fbno - XFS_DIR2_FREE_FIRSTDB(mp)) *
-				xfs_dir2_free_max_bests(mp));
+			freehdr.firstdb = (fbno - XFS_DIR2_FREE_FIRSTDB(mp)) *
+					xfs_dir3_free_max_bests(mp);
 			free->hdr.nvalid = 0;
 			free->hdr.nused = 0;
 		} else {
 			free = fbp->b_addr;
-			ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
+			bests = xfs_dir3_free_bests_p(mp, free);
+			xfs_dir3_free_hdr_from_disk(&freehdr, free);
 		}
 
 		/*
@@ -1677,20 +1846,21 @@ xfs_dir2_node_addname_int(
 		 * If it's after the end of the current entries in the
 		 * freespace block, extend that table.
 		 */
-		if (findex >= be32_to_cpu(free->hdr.nvalid)) {
-			ASSERT(findex < xfs_dir2_free_max_bests(mp));
-			free->hdr.nvalid = cpu_to_be32(findex + 1);
+		if (findex >= freehdr.nvalid) {
+			ASSERT(findex < xfs_dir3_free_max_bests(mp));
+			freehdr.nvalid = findex + 1;
 			/*
 			 * Tag new entry so nused will go up.
 			 */
-			free->bests[findex] = cpu_to_be16(NULLDATAOFF);
+			bests[findex] = cpu_to_be16(NULLDATAOFF);
 		}
 		/*
 		 * If this entry was for an empty data block
 		 * (this should always be true) then update the header.
 		 */
-		if (free->bests[findex] == cpu_to_be16(NULLDATAOFF)) {
-			be32_add_cpu(&free->hdr.nused, 1);
+		if (bests[findex] == cpu_to_be16(NULLDATAOFF)) {
+			freehdr.nused++;
+			xfs_dir3_free_hdr_to_disk(fbp->b_addr, &freehdr);
 			xfs_dir2_free_log_header(tp, fbp);
 		}
 		/*
@@ -1699,7 +1869,7 @@ xfs_dir2_node_addname_int(
 		 * change again.
 		 */
 		hdr = dbp->b_addr;
-		free->bests[findex] = hdr->bestfree[0].length;
+		bests[findex] = hdr->bestfree[0].length;
 		logfree = 1;
 	}
 	/*
@@ -1758,8 +1928,9 @@ xfs_dir2_node_addname_int(
 	/*
 	 * If the freespace entry is now wrong, update it.
 	 */
-	if (be16_to_cpu(free->bests[findex]) != be16_to_cpu(hdr->bestfree[0].length)) {
-		free->bests[findex] = hdr->bestfree[0].length;
+	bests = xfs_dir3_free_bests_p(mp, free); /* gcc is so stupid */
+	if (be16_to_cpu(bests[findex]) != be16_to_cpu(hdr->bestfree[0].length)) {
+		bests[findex] = hdr->bestfree[0].length;
 		logfree = 1;
 	}
 	/*
@@ -1995,6 +2166,7 @@ xfs_dir2_node_trim_free(
 	xfs_dir2_free_t		*free;		/* freespace structure */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir3_icfree_hdr freehdr;
 
 	dp = args->dp;
 	mp = dp->i_mount;
@@ -2012,11 +2184,12 @@ xfs_dir2_node_trim_free(
 	if (!bp)
 		return 0;
 	free = bp->b_addr;
-	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
+	xfs_dir3_free_hdr_from_disk(&freehdr, free);
+
 	/*
 	 * If there are used entries, there's nothing to do.
 	 */
-	if (be32_to_cpu(free->hdr.nused) > 0) {
+	if (freehdr.nused > 0) {
 		xfs_trans_brelse(tp, bp);
 		*rvalp = 0;
 		return 0;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
