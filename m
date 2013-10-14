Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5F247F7B
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 17:18:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 792368F804B
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:18:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JZA1GvrAgvktTJf0 for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 15:18:25 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VVqSm-0004xF-EB
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VVqSm-0005ja-DG
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/19] xfs: vectorise directory data operations part 2
Date: Tue, 15 Oct 2013 09:18:00 +1100
Message-Id: <1381789085-21923-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1381789085-21923-1-git-send-email-david@fromorbit.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
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

Convert the rest of the directory data block encode/decode
operations to vector format.

This further reduces the size of the built binary:

   text    data     bss     dec     hex filename
 794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
 792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
 792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
 789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
 789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_da_format.c    |  68 +++++++++++++++++++++++++++++
 fs/xfs/xfs_da_format.h    |  41 ------------------
 fs/xfs/xfs_dir2.h         |  22 +++++++---
 fs/xfs/xfs_dir2_block.c   |  33 ++++++++-------
 fs/xfs/xfs_dir2_data.c    | 106 +++++++++++++++++++++++++---------------------
 fs/xfs/xfs_dir2_leaf.c    |  26 ++++++------
 fs/xfs/xfs_dir2_node.c    |  16 +++----
 fs/xfs/xfs_dir2_priv.h    |   3 +-
 fs/xfs/xfs_dir2_readdir.c |   6 +--
 fs/xfs/xfs_dir2_sf.c      |   2 +-
 10 files changed, 186 insertions(+), 137 deletions(-)

diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index d0285fd..1e92a24 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -383,6 +383,58 @@ xfs_dir3_data_first_entry_p(
 		((char *)hdr + xfs_dir3_data_first_offset());
 }
 
+static struct xfs_dir2_data_free *
+xfs_dir2_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return hdr->bestfree;
+}
+
+static struct xfs_dir2_data_free *
+xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
+}
+
+static size_t
+xfs_dir2_data_entry_offset(void)
+{
+	return sizeof(struct xfs_dir2_data_hdr);
+}
+
+static struct xfs_dir2_data_entry *
+xfs_dir2_data_entry_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir2_data_entry_offset());
+}
+
+static struct xfs_dir2_data_unused *
+xfs_dir2_data_unused_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_unused *)
+		((char *)hdr + xfs_dir2_data_entry_offset());
+}
+
+static size_t
+xfs_dir3_data_entry_offset(void)
+{
+	return sizeof(struct xfs_dir3_data_hdr);
+}
+
+static struct xfs_dir2_data_entry *
+xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir3_data_entry_offset());
+}
+
+static struct xfs_dir2_data_unused *
+xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_unused *)
+		((char *)hdr + xfs_dir3_data_entry_offset());
+}
+
 const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_entsize = xfs_dir2_sf_entsize,
 	.sf_nextentry = xfs_dir2_sf_nextentry,
@@ -397,13 +449,19 @@ const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_get_ftype = xfs_dir2_data_get_ftype,
 	.data_put_ftype = xfs_dir2_data_put_ftype,
 	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
+	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
 	.data_dot_offset = xfs_dir2_data_dot_offset,
 	.data_dotdot_offset = xfs_dir2_data_dotdot_offset,
 	.data_first_offset = xfs_dir2_data_first_offset,
+	.data_entry_offset = xfs_dir2_data_entry_offset,
+
 	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
 	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
 	.data_first_entry_p = xfs_dir2_data_first_entry_p,
+	.data_entry_p = xfs_dir2_data_entry_p,
+	.data_unused_p = xfs_dir2_data_unused_p,
+
 };
 
 const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -420,13 +478,18 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
+	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
 	.data_dot_offset = xfs_dir2_data_dot_offset,
 	.data_dotdot_offset = xfs_dir2_data_dotdot_offset,
 	.data_first_offset = xfs_dir2_data_first_offset,
+	.data_entry_offset = xfs_dir2_data_entry_offset,
+
 	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
 	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
 	.data_first_entry_p = xfs_dir2_data_first_entry_p,
+	.data_entry_p = xfs_dir2_data_entry_p,
+	.data_unused_p = xfs_dir2_data_unused_p,
 };
 
 const struct xfs_dir_ops xfs_dir3_ops = {
@@ -443,11 +506,16 @@ const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
+	.data_bestfree_p = xfs_dir3_data_bestfree_p,
 
 	.data_dot_offset = xfs_dir3_data_dot_offset,
 	.data_dotdot_offset = xfs_dir3_data_dotdot_offset,
 	.data_first_offset = xfs_dir3_data_first_offset,
+	.data_entry_offset = xfs_dir3_data_entry_offset,
+
 	.data_dot_entry_p = xfs_dir3_data_dot_entry_p,
 	.data_dotdot_entry_p = xfs_dir3_data_dotdot_entry_p,
 	.data_first_entry_p = xfs_dir3_data_first_entry_p,
+	.data_entry_p = xfs_dir3_data_entry_p,
+	.data_unused_p = xfs_dir3_data_unused_p,
 };
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index 5b72dd2..aeca003 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -412,17 +412,6 @@ struct xfs_dir3_data_hdr {
 
 #define XFS_DIR3_DATA_CRC_OFF  offsetof(struct xfs_dir3_data_hdr, hdr.crc)
 
-static inline struct xfs_dir2_data_free *
-xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
-{
-	if (hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
-	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
-		struct xfs_dir3_data_hdr *hdr3 = (struct xfs_dir3_data_hdr *)hdr;
-		return hdr3->best_free;
-	}
-	return hdr->bestfree;
-}
-
 /*
  * Active entry in a data block.
  *
@@ -465,36 +454,6 @@ xfs_dir2_data_unused_tag_p(struct xfs_dir2_data_unused *dup)
 			be16_to_cpu(dup->length) - sizeof(__be16));
 }
 
-static inline size_t
-xfs_dir3_data_hdr_size(bool dir3)
-{
-	if (dir3)
-		return sizeof(struct xfs_dir3_data_hdr);
-	return sizeof(struct xfs_dir2_data_hdr);
-}
-
-static inline size_t
-xfs_dir3_data_entry_offset(struct xfs_dir2_data_hdr *hdr)
-{
-	bool dir3 = hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
-		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
-	return xfs_dir3_data_hdr_size(dir3);
-}
-
-static inline struct xfs_dir2_data_entry *
-xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_entry_offset(hdr));
-}
-
-static inline struct xfs_dir2_data_unused *
-xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_unused *)
-		((char *)hdr + xfs_dir3_data_entry_offset(hdr));
-}
-
 /*
  * Leaf block structures.
  *
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index c0a4592..076010a 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -56,16 +56,24 @@ struct xfs_dir_ops {
 	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
 				__uint8_t ftype);
 	__be16 * (*data_entry_tag_p)(struct xfs_dir2_data_entry *dep);
+	struct xfs_dir2_data_free *
+		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
 
 	xfs_dir2_data_aoff_t (*data_dot_offset)(void);
 	xfs_dir2_data_aoff_t (*data_dotdot_offset)(void);
 	xfs_dir2_data_aoff_t (*data_first_offset)(void);
+	size_t	(*data_entry_offset)(void);
+
 	struct xfs_dir2_data_entry *
 		(*data_dot_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_entry *
 		(*data_dotdot_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_entry *
 		(*data_first_entry_p)(struct xfs_dir2_data_hdr *hdr);
+	struct xfs_dir2_data_entry *
+		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
+	struct xfs_dir2_data_unused *
+		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 };
 
 extern const struct xfs_dir_ops xfs_dir2_ops;
@@ -115,19 +123,21 @@ extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
 extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_inode *dp,
 		struct xfs_buf *bp, struct xfs_dir2_data_entry *dep);
-extern void xfs_dir2_data_log_header(struct xfs_trans *tp,
+extern void xfs_dir2_data_log_header(struct xfs_trans *tp, struct xfs_inode *dp,
 		struct xfs_buf *bp);
 extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_buf *bp,
 		struct xfs_dir2_data_unused *dup);
-extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_buf *bp,
+extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_inode *dp,
+		struct xfs_buf *bp, xfs_dir2_data_aoff_t offset,
+		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
+extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_inode *dp,
+		struct xfs_buf *bp, struct xfs_dir2_data_unused *dup,
 		xfs_dir2_data_aoff_t offset, xfs_dir2_data_aoff_t len,
 		int *needlogp, int *needscanp);
-extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_dir2_data_unused *dup, xfs_dir2_data_aoff_t offset,
-		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
-		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_unused *dup);
+		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
+		struct xfs_dir2_data_unused *dup);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 7d7a8cc..e6f1784 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -168,6 +168,7 @@ xfs_dir3_block_init(
 
 static void
 xfs_dir2_block_need_space(
+	struct xfs_inode		*dp,
 	struct xfs_dir2_data_hdr	*hdr,
 	struct xfs_dir2_block_tail	*btp,
 	struct xfs_dir2_leaf_entry	*blp,
@@ -183,7 +184,7 @@ xfs_dir2_block_need_space(
 	struct xfs_dir2_data_unused	*enddup = NULL;
 
 	*compact = 0;
-	bf = xfs_dir3_data_bestfree_p(hdr);
+	bf = dp->d_ops->data_bestfree_p(hdr);
 
 	/*
 	 * If there are stale entries we'll use one for the leaf.
@@ -313,7 +314,7 @@ xfs_dir2_block_compact(
 	*lfloglow = toidx + 1 - (be32_to_cpu(btp->stale) - 1);
 	*lfloghigh -= be32_to_cpu(btp->stale) - 1;
 	be32_add_cpu(&btp->count, -(be32_to_cpu(btp->stale) - 1));
-	xfs_dir2_data_make_free(tp, bp,
+	xfs_dir2_data_make_free(tp, dp, bp,
 		(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
 		(xfs_dir2_data_aoff_t)((be32_to_cpu(btp->stale) - 1) * sizeof(*blp)),
 		needlog, &needscan);
@@ -383,7 +384,7 @@ xfs_dir2_block_addname(
 	 * Find out if we can reuse stale entries or whether we need extra
 	 * space for entry and new leaf.
 	 */
-	xfs_dir2_block_need_space(hdr, btp, blp, &tagp, &dup,
+	xfs_dir2_block_need_space(dp, hdr, btp, blp, &tagp, &dup,
 				  &enddup, &compact, len);
 
 	/*
@@ -454,7 +455,7 @@ xfs_dir2_block_addname(
 		/*
 		 * Mark the space needed for the new leaf entry, now in use.
 		 */
-		xfs_dir2_data_use_free(tp, bp, enddup,
+		xfs_dir2_data_use_free(tp, dp, bp, enddup,
 			(xfs_dir2_data_aoff_t)
 			((char *)enddup - (char *)hdr + be16_to_cpu(enddup->length) -
 			 sizeof(*blp)),
@@ -541,7 +542,7 @@ xfs_dir2_block_addname(
 	/*
 	 * Mark space for the data entry used.
 	 */
-	xfs_dir2_data_use_free(tp, bp, dup,
+	xfs_dir2_data_use_free(tp, dp, bp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr),
 		(xfs_dir2_data_aoff_t)len, &needlog, &needscan);
 	/*
@@ -559,7 +560,7 @@ xfs_dir2_block_addname(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, bp);
+		xfs_dir2_data_log_header(tp, dp, bp);
 	xfs_dir2_block_log_tail(tp, bp);
 	xfs_dir2_data_log_entry(tp, dp, bp, dep);
 	xfs_dir3_data_check(dp, bp);
@@ -800,7 +801,7 @@ xfs_dir2_block_removename(
 	 * Mark the data entry's space free.
 	 */
 	needlog = needscan = 0;
-	xfs_dir2_data_make_free(tp, bp,
+	xfs_dir2_data_make_free(tp, dp, bp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
 		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
 	/*
@@ -819,7 +820,7 @@ xfs_dir2_block_removename(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, bp);
+		xfs_dir2_data_log_header(tp, dp, bp);
 	xfs_dir3_data_check(dp, bp);
 	/*
 	 * See if the size as a shortform is good enough.
@@ -950,7 +951,7 @@ xfs_dir2_leaf_to_block(
 	while (dp->i_d.di_size > mp->m_dirblksize) {
 		int hdrsz;
 
-		hdrsz = xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&mp->m_sb));
+		hdrsz = dp->d_ops->data_entry_offset();
 		bestsp = xfs_dir2_leaf_bests_p(ltp);
 		if (be16_to_cpu(bestsp[be32_to_cpu(ltp->bestcount) - 1]) ==
 					    mp->m_dirblksize - hdrsz) {
@@ -1000,7 +1001,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Use up the space at the end of the block (blp/btp).
 	 */
-	xfs_dir2_data_use_free(tp, dbp, dup, mp->m_dirblksize - size, size,
+	xfs_dir2_data_use_free(tp, dp, dbp, dup, mp->m_dirblksize - size, size,
 		&needlog, &needscan);
 	/*
 	 * Initialize the block tail.
@@ -1026,7 +1027,7 @@ xfs_dir2_leaf_to_block(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dbp);
+		xfs_dir2_data_log_header(tp, dp, dbp);
 	/*
 	 * Pitch the old leaf block.
 	 */
@@ -1137,9 +1138,9 @@ xfs_dir2_sf_to_block(
 	 * The whole thing is initialized to free by the init routine.
 	 * Say we're using the leaf and tail area.
 	 */
-	dup = xfs_dir3_data_unused_p(hdr);
+	dup = dp->d_ops->data_unused_p(hdr);
 	needlog = needscan = 0;
-	xfs_dir2_data_use_free(tp, bp, dup, mp->m_dirblksize - i, i, &needlog,
+	xfs_dir2_data_use_free(tp, dp, bp, dup, mp->m_dirblksize - i, i, &needlog,
 		&needscan);
 	ASSERT(needscan == 0);
 	/*
@@ -1153,7 +1154,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Remove the freespace, we'll manage it.
 	 */
-	xfs_dir2_data_use_free(tp, bp, dup,
+	xfs_dir2_data_use_free(tp, dp, bp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr),
 		be16_to_cpu(dup->length), &needlog, &needscan);
 	/*
@@ -1215,7 +1216,9 @@ xfs_dir2_sf_to_block(
 			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(
 				((char *)dup - (char *)hdr));
 			xfs_dir2_data_log_unused(tp, bp, dup);
-			xfs_dir2_data_freeinsert(hdr, dup, &dummy);
+			xfs_dir2_data_freeinsert(hdr,
+						 dp->d_ops->data_bestfree_p(hdr),
+						 dup, &dummy);
 			offset += be16_to_cpu(dup->length);
 			continue;
 		}
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 571e173..ef93049 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -66,8 +66,6 @@ __xfs_dir3_data_check(
 
 	mp = bp->b_target->bt_mount;
 	hdr = bp->b_addr;
-	bf = xfs_dir3_data_bestfree_p(hdr);
-	p = (char *)xfs_dir3_data_entry_p(hdr);
 
 	/*
 	 * we can be passed a null dp here froma verifier, so manually configure
@@ -97,6 +95,8 @@ __xfs_dir3_data_check(
 		XFS_ERROR_REPORT("Bad Magic", XFS_ERRLEVEL_LOW, mp);
 		return EFSCORRUPTED;
 	}
+	bf = ops->data_bestfree_p(hdr);
+	p = (char *)ops->data_entry_p(hdr);
 
 	count = lastfree = freeseen = 0;
 	/*
@@ -134,7 +134,7 @@ __xfs_dir3_data_check(
 			XFS_WANT_CORRUPTED_RETURN(
 				be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) ==
 					       (char *)dup - (char *)hdr);
-			dfp = xfs_dir2_data_freefind(hdr, dup);
+			dfp = xfs_dir2_data_freefind(hdr, bf, dup);
 			if (dfp) {
 				i = (int)(dfp - bf);
 				XFS_WANT_CORRUPTED_RETURN(
@@ -340,19 +340,18 @@ xfs_dir3_data_readahead(
  */
 xfs_dir2_data_free_t *
 xfs_dir2_data_freefind(
-	xfs_dir2_data_hdr_t	*hdr,		/* data block */
-	xfs_dir2_data_unused_t	*dup)		/* data unused entry */
+	struct xfs_dir2_data_hdr *hdr,		/* data block header */
+	struct xfs_dir2_data_free *bf,		/* bestfree table pointer */
+	struct xfs_dir2_data_unused *dup)	/* unused space */
 {
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
 	xfs_dir2_data_aoff_t	off;		/* offset value needed */
-	struct xfs_dir2_data_free *bf;
 #ifdef DEBUG
 	int			matched;	/* matched the value */
 	int			seenzero;	/* saw a 0 bestfree entry */
 #endif
 
 	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr);
-	bf = xfs_dir3_data_bestfree_p(hdr);
 
 #ifdef DEBUG
 	/*
@@ -412,11 +411,11 @@ xfs_dir2_data_freefind(
  */
 xfs_dir2_data_free_t *				/* entry inserted */
 xfs_dir2_data_freeinsert(
-	xfs_dir2_data_hdr_t	*hdr,		/* data block pointer */
-	xfs_dir2_data_unused_t	*dup,		/* unused space */
+	struct xfs_dir2_data_hdr *hdr,		/* data block pointer */
+	struct xfs_dir2_data_free *dfp,		/* bestfree table pointer */
+	struct xfs_dir2_data_unused *dup,	/* unused space */
 	int			*loghead)	/* log the data header (out) */
 {
-	xfs_dir2_data_free_t	*dfp;		/* bestfree table pointer */
 	xfs_dir2_data_free_t	new;		/* new bestfree entry */
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
@@ -424,7 +423,6 @@ xfs_dir2_data_freeinsert(
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
-	dfp = xfs_dir3_data_bestfree_p(hdr);
 	new.length = dup->length;
 	new.offset = cpu_to_be16((char *)dup - (char *)hdr);
 
@@ -457,11 +455,11 @@ xfs_dir2_data_freeinsert(
  */
 STATIC void
 xfs_dir2_data_freeremove(
-	xfs_dir2_data_hdr_t	*hdr,		/* data block header */
-	xfs_dir2_data_free_t	*dfp,		/* bestfree entry pointer */
+	struct xfs_dir2_data_hdr *hdr,		/* data block header */
+	struct xfs_dir2_data_free *bf,		/* bestfree table pointer */
+	struct xfs_dir2_data_free *dfp,		/* bestfree entry pointer */
 	int			*loghead)	/* out: log data header */
 {
-	struct xfs_dir2_data_free *bf;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
@@ -471,7 +469,6 @@ xfs_dir2_data_freeremove(
 	/*
 	 * It's the first entry, slide the next 2 up.
 	 */
-	bf = xfs_dir3_data_bestfree_p(hdr);
 	if (dfp == &bf[0]) {
 		bf[0] = bf[1];
 		bf[1] = bf[2];
@@ -518,13 +515,13 @@ xfs_dir2_data_freescan(
 	/*
 	 * Start by clearing the table.
 	 */
-	bf = xfs_dir3_data_bestfree_p(hdr);
+	bf = dp->d_ops->data_bestfree_p(hdr);
 	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
 	*loghead = 1;
 	/*
 	 * Set up pointers.
 	 */
-	p = (char *)xfs_dir3_data_entry_p(hdr);
+	p = (char *)dp->d_ops->data_entry_p(hdr);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		btp = xfs_dir2_block_tail_p(dp->i_mount, hdr);
@@ -542,7 +539,7 @@ xfs_dir2_data_freescan(
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			ASSERT((char *)dup - (char *)hdr ==
 			       be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)));
-			xfs_dir2_data_freeinsert(hdr, dup, loghead);
+			xfs_dir2_data_freeinsert(hdr, bf, dup, loghead);
 			p += be16_to_cpu(dup->length);
 		}
 		/*
@@ -607,8 +604,8 @@ xfs_dir3_data_init(
 	} else
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 
-	bf = xfs_dir3_data_bestfree_p(hdr);
-	bf[0].offset = cpu_to_be16(xfs_dir3_data_entry_offset(hdr));
+	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf[0].offset = cpu_to_be16(dp->d_ops->data_entry_offset());
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
 		bf[i].length = 0;
 		bf[i].offset = 0;
@@ -617,17 +614,17 @@ xfs_dir3_data_init(
 	/*
 	 * Set up an unused entry for the block's body.
 	 */
-	dup = xfs_dir3_data_unused_p(hdr);
+	dup = dp->d_ops->data_unused_p(hdr);
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 
-	t = mp->m_dirblksize - (uint)xfs_dir3_data_entry_offset(hdr);
+	t = mp->m_dirblksize - (uint)dp->d_ops->data_entry_offset();
 	bf[0].length = cpu_to_be16(t);
 	dup->length = cpu_to_be16(t);
 	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)hdr);
 	/*
 	 * Log it and return it.
 	 */
-	xfs_dir2_data_log_header(tp, bp);
+	xfs_dir2_data_log_header(tp, dp, bp);
 	xfs_dir2_data_log_unused(tp, bp, dup);
 	*bpp = bp;
 	return 0;
@@ -661,16 +658,19 @@ xfs_dir2_data_log_entry(
 void
 xfs_dir2_data_log_header(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp)
 {
-	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
+#ifdef DEBUG
+	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
+#endif
 
-	xfs_trans_log_buf(tp, bp, 0, xfs_dir3_data_entry_offset(hdr) - 1);
+	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->data_entry_offset() - 1);
 }
 
 /*
@@ -711,6 +711,7 @@ xfs_dir2_data_log_unused(
 void
 xfs_dir2_data_make_free(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp,
 	xfs_dir2_data_aoff_t	offset,		/* starting byte offset */
 	xfs_dir2_data_aoff_t	len,		/* length in bytes */
@@ -748,7 +749,7 @@ xfs_dir2_data_make_free(
 	 * If this isn't the start of the block, then back up to
 	 * the previous entry and see if it's free.
 	 */
-	if (offset > xfs_dir3_data_entry_offset(hdr)) {
+	if (offset > dp->d_ops->data_entry_offset()) {
 		__be16			*tagp;	/* tag just before us */
 
 		tagp = (__be16 *)((char *)hdr + offset) - 1;
@@ -774,15 +775,15 @@ xfs_dir2_data_make_free(
 	 * Previous and following entries are both free,
 	 * merge everything into a single free entry.
 	 */
-	bf = xfs_dir3_data_bestfree_p(hdr);
+	bf = dp->d_ops->data_bestfree_p(hdr);
 	if (prevdup && postdup) {
 		xfs_dir2_data_free_t	*dfp2;	/* another bestfree pointer */
 
 		/*
 		 * See if prevdup and/or postdup are in bestfree table.
 		 */
-		dfp = xfs_dir2_data_freefind(hdr, prevdup);
-		dfp2 = xfs_dir2_data_freefind(hdr, postdup);
+		dfp = xfs_dir2_data_freefind(hdr, bf, prevdup);
+		dfp2 = xfs_dir2_data_freefind(hdr, bf, postdup);
 		/*
 		 * We need a rescan unless there are exactly 2 free entries
 		 * namely our two.  Then we know what's happening, otherwise
@@ -810,12 +811,13 @@ xfs_dir2_data_make_free(
 				ASSERT(dfp2 == dfp);
 				dfp2 = &bf[1];
 			}
-			xfs_dir2_data_freeremove(hdr, dfp2, needlogp);
-			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
+			xfs_dir2_data_freeremove(hdr, bf, dfp2, needlogp);
+			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
 			/*
 			 * Now insert the new entry.
 			 */
-			dfp = xfs_dir2_data_freeinsert(hdr, prevdup, needlogp);
+			dfp = xfs_dir2_data_freeinsert(hdr, bf, prevdup,
+						       needlogp);
 			ASSERT(dfp == &bf[0]);
 			ASSERT(dfp->length == prevdup->length);
 			ASSERT(!dfp[1].length);
@@ -826,7 +828,7 @@ xfs_dir2_data_make_free(
 	 * The entry before us is free, merge with it.
 	 */
 	else if (prevdup) {
-		dfp = xfs_dir2_data_freefind(hdr, prevdup);
+		dfp = xfs_dir2_data_freefind(hdr, bf, prevdup);
 		be16_add_cpu(&prevdup->length, len);
 		*xfs_dir2_data_unused_tag_p(prevdup) =
 			cpu_to_be16((char *)prevdup - (char *)hdr);
@@ -837,8 +839,8 @@ xfs_dir2_data_make_free(
 		 * the old one and add the new one.
 		 */
 		if (dfp) {
-			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
-			xfs_dir2_data_freeinsert(hdr, prevdup, needlogp);
+			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
+			xfs_dir2_data_freeinsert(hdr, bf, prevdup, needlogp);
 		}
 		/*
 		 * Otherwise we need a scan if the new entry is big enough.
@@ -852,7 +854,7 @@ xfs_dir2_data_make_free(
 	 * The following entry is free, merge with it.
 	 */
 	else if (postdup) {
-		dfp = xfs_dir2_data_freefind(hdr, postdup);
+		dfp = xfs_dir2_data_freefind(hdr, bf, postdup);
 		newdup = (xfs_dir2_data_unused_t *)((char *)hdr + offset);
 		newdup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup->length = cpu_to_be16(len + be16_to_cpu(postdup->length));
@@ -865,8 +867,8 @@ xfs_dir2_data_make_free(
 		 * the old one and add the new one.
 		 */
 		if (dfp) {
-			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
-			xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
+			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
+			xfs_dir2_data_freeinsert(hdr, bf, newdup, needlogp);
 		}
 		/*
 		 * Otherwise we need a scan if the new entry is big enough.
@@ -886,7 +888,7 @@ xfs_dir2_data_make_free(
 		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)hdr);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
-		xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
+		xfs_dir2_data_freeinsert(hdr, bf, newdup, needlogp);
 	}
 	*needscanp = needscan;
 }
@@ -897,6 +899,7 @@ xfs_dir2_data_make_free(
 void
 xfs_dir2_data_use_free(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp,
 	xfs_dir2_data_unused_t	*dup,		/* unused entry */
 	xfs_dir2_data_aoff_t	offset,		/* starting offset to use */
@@ -926,9 +929,9 @@ xfs_dir2_data_use_free(
 	/*
 	 * Look up the entry in the bestfree table.
 	 */
-	dfp = xfs_dir2_data_freefind(hdr, dup);
 	oldlen = be16_to_cpu(dup->length);
-	bf = xfs_dir3_data_bestfree_p(hdr);
+	bf = dp->d_ops->data_bestfree_p(hdr);
+	dfp = xfs_dir2_data_freefind(hdr, bf, dup);
 	ASSERT(dfp || oldlen <= be16_to_cpu(bf[2].length));
 	/*
 	 * Check for alignment with front and back of the entry.
@@ -945,7 +948,8 @@ xfs_dir2_data_use_free(
 		if (dfp) {
 			needscan = (bf[2].offset != 0);
 			if (!needscan)
-				xfs_dir2_data_freeremove(hdr, dfp, needlogp);
+				xfs_dir2_data_freeremove(hdr, bf, dfp,
+							 needlogp);
 		}
 	}
 	/*
@@ -963,8 +967,9 @@ xfs_dir2_data_use_free(
 		 * If it was in the table, remove it and add the new one.
 		 */
 		if (dfp) {
-			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
-			dfp = xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
+			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
+			dfp = xfs_dir2_data_freeinsert(hdr, bf, newdup,
+						       needlogp);
 			ASSERT(dfp != NULL);
 			ASSERT(dfp->length == newdup->length);
 			ASSERT(be16_to_cpu(dfp->offset) == (char *)newdup - (char *)hdr);
@@ -990,8 +995,9 @@ xfs_dir2_data_use_free(
 		 * If it was in the table, remove it and add the new one.
 		 */
 		if (dfp) {
-			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
-			dfp = xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
+			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
+			dfp = xfs_dir2_data_freeinsert(hdr, bf, newdup,
+						       needlogp);
 			ASSERT(dfp != NULL);
 			ASSERT(dfp->length == newdup->length);
 			ASSERT(be16_to_cpu(dfp->offset) == (char *)newdup - (char *)hdr);
@@ -1030,9 +1036,11 @@ xfs_dir2_data_use_free(
 		if (dfp) {
 			needscan = (bf[2].length != 0);
 			if (!needscan) {
-				xfs_dir2_data_freeremove(hdr, dfp, needlogp);
-				xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
-				xfs_dir2_data_freeinsert(hdr, newdup2,
+				xfs_dir2_data_freeremove(hdr, bf, dfp,
+							 needlogp);
+				xfs_dir2_data_freeinsert(hdr, bf, newdup,
+							 needlogp);
+				xfs_dir2_data_freeinsert(hdr, bf, newdup2,
 							 needlogp);
 			}
 		}
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index dd19536..f35b394 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -460,7 +460,7 @@ xfs_dir2_block_to_leaf(
 	xfs_dir3_data_check(dp, dbp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
-	bf = xfs_dir3_data_bestfree_p(hdr);
+	bf = dp->d_ops->data_bestfree_p(hdr);
 	ents = xfs_dir3_leaf_ents_p(leaf);
 
 	/*
@@ -484,7 +484,7 @@ xfs_dir2_block_to_leaf(
 	 * Make the space formerly occupied by the leaf entries and block
 	 * tail be free.
 	 */
-	xfs_dir2_data_make_free(tp, dbp,
+	xfs_dir2_data_make_free(tp, dp, dbp,
 		(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
 		(xfs_dir2_data_aoff_t)((char *)hdr + mp->m_dirblksize -
 				       (char *)blp),
@@ -512,7 +512,7 @@ xfs_dir2_block_to_leaf(
 	 * Log the data header and leaf bests table.
 	 */
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dbp);
+		xfs_dir2_data_log_header(tp, dp, dbp);
 	xfs_dir3_leaf_check(mp, lbp);
 	xfs_dir3_data_check(dp, dbp);
 	xfs_dir3_leaf_log_bests(tp, lbp, 0, 0);
@@ -862,7 +862,7 @@ xfs_dir2_leaf_addname(
 		else
 			xfs_dir3_leaf_log_bests(tp, lbp, use_block, use_block);
 		hdr = dbp->b_addr;
-		bf = xfs_dir3_data_bestfree_p(hdr);
+		bf = dp->d_ops->data_bestfree_p(hdr);
 		bestsp[use_block] = bf[0].length;
 		grown = 1;
 	} else {
@@ -878,7 +878,7 @@ xfs_dir2_leaf_addname(
 			return error;
 		}
 		hdr = dbp->b_addr;
-		bf = xfs_dir3_data_bestfree_p(hdr);
+		bf = dp->d_ops->data_bestfree_p(hdr);
 		grown = 0;
 	}
 	/*
@@ -891,7 +891,7 @@ xfs_dir2_leaf_addname(
 	/*
 	 * Mark the initial part of our freespace in use for the new entry.
 	 */
-	xfs_dir2_data_use_free(tp, dbp, dup,
+	xfs_dir2_data_use_free(tp, dp, dbp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr), length,
 		&needlog, &needscan);
 	/*
@@ -913,7 +913,7 @@ xfs_dir2_leaf_addname(
 	 * Need to log the data block's header.
 	 */
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dbp);
+		xfs_dir2_data_log_header(tp, dp, dbp);
 	xfs_dir2_data_log_entry(tp, dp, dbp, dep);
 	/*
 	 * If the bests table needs to be changed, do it.
@@ -1413,7 +1413,7 @@ xfs_dir2_leaf_removename(
 	leaf = lbp->b_addr;
 	hdr = dbp->b_addr;
 	xfs_dir3_data_check(dp, dbp);
-	bf = xfs_dir3_data_bestfree_p(hdr);
+	bf = dp->d_ops->data_bestfree_p(hdr);
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = xfs_dir3_leaf_ents_p(leaf);
 	/*
@@ -1431,7 +1431,7 @@ xfs_dir2_leaf_removename(
 	/*
 	 * Mark the former data entry unused.
 	 */
-	xfs_dir2_data_make_free(tp, dbp,
+	xfs_dir2_data_make_free(tp, dp, dbp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
 		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
 	/*
@@ -1451,7 +1451,7 @@ xfs_dir2_leaf_removename(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dbp);
+		xfs_dir2_data_log_header(tp, dp, dbp);
 	/*
 	 * If the longest freespace in the data block has changed,
 	 * put the new value in the bests table and log that.
@@ -1465,7 +1465,7 @@ xfs_dir2_leaf_removename(
 	 * If the data block is now empty then get rid of the data block.
 	 */
 	if (be16_to_cpu(bf[0].length) ==
-			mp->m_dirblksize - xfs_dir3_data_entry_offset(hdr)) {
+			mp->m_dirblksize - dp->d_ops->data_entry_offset()) {
 		ASSERT(db != mp->m_dirdatablk);
 		if ((error = xfs_dir2_shrink_inode(args, db, dbp))) {
 			/*
@@ -1659,12 +1659,12 @@ xfs_dir2_leaf_trim_data(
 #ifdef DEBUG
 {
 	struct xfs_dir2_data_hdr *hdr = dbp->b_addr;
-	struct xfs_dir2_data_free *bf = xfs_dir3_data_bestfree_p(hdr);
+	struct xfs_dir2_data_free *bf = dp->d_ops->data_bestfree_p(hdr);
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
 	ASSERT(be16_to_cpu(bf[0].length) ==
-	       mp->m_dirblksize - xfs_dir3_data_entry_offset(hdr));
+	       mp->m_dirblksize - dp->d_ops->data_entry_offset());
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
 }
 #endif
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index c45d452..6644ed6 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1255,10 +1255,10 @@ xfs_dir2_leafn_remove(
 	dbp = dblk->bp;
 	hdr = dbp->b_addr;
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr + off);
-	bf = xfs_dir3_data_bestfree_p(hdr);
+	bf = dp->d_ops->data_bestfree_p(hdr);
 	longest = be16_to_cpu(bf[0].length);
 	needlog = needscan = 0;
-	xfs_dir2_data_make_free(tp, dbp, off,
+	xfs_dir2_data_make_free(tp, dp, dbp, off,
 		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * Rescan the data block freespaces for bestfree.
@@ -1267,7 +1267,7 @@ xfs_dir2_leafn_remove(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dbp);
+		xfs_dir2_data_log_header(tp, dp, dbp);
 	xfs_dir3_data_check(dp, dbp);
 	/*
 	 * If the longest data block freespace changes, need to update
@@ -1308,7 +1308,7 @@ xfs_dir2_leafn_remove(
 		 * (usually).
 		 */
 		if (longest == mp->m_dirblksize -
-			       xfs_dir3_data_entry_offset(hdr)) {
+			       dp->d_ops->data_entry_offset()) {
 			/*
 			 * Try to punch out the data block.
 			 */
@@ -1962,7 +1962,7 @@ xfs_dir2_node_addname_int(
 		 * change again.
 		 */
 		hdr = dbp->b_addr;
-		bf = xfs_dir3_data_bestfree_p(hdr);
+		bf = dp->d_ops->data_bestfree_p(hdr);
 		bests[findex] = bf[0].length;
 		logfree = 1;
 	}
@@ -1984,7 +1984,7 @@ xfs_dir2_node_addname_int(
 		if (error)
 			return error;
 		hdr = dbp->b_addr;
-		bf = xfs_dir3_data_bestfree_p(hdr);
+		bf = dp->d_ops->data_bestfree_p(hdr);
 		logfree = 0;
 	}
 	ASSERT(be16_to_cpu(bf[0].length) >= length);
@@ -1997,7 +1997,7 @@ xfs_dir2_node_addname_int(
 	/*
 	 * Mark the first part of the unused space, inuse for us.
 	 */
-	xfs_dir2_data_use_free(tp, dbp, dup,
+	xfs_dir2_data_use_free(tp, dp, dbp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr), length,
 		&needlog, &needscan);
 	/*
@@ -2020,7 +2020,7 @@ xfs_dir2_node_addname_int(
 	 * Log the data block header if needed.
 	 */
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dbp);
+		xfs_dir2_data_log_header(tp, dp, dbp);
 	/*
 	 * If the freespace entry is now wrong, update it.
 	 */
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 1bad84c..9a69f20 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -59,7 +59,8 @@ extern int xfs_dir3_data_readahead(struct xfs_trans *tp, struct xfs_inode *dp,
 
 extern struct xfs_dir2_data_free *
 xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
-		struct xfs_dir2_data_unused *dup, int *loghead);
+		struct xfs_dir2_data_free *bf, struct xfs_dir2_data_unused *dup,
+		int *loghead);
 extern int xfs_dir3_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 		struct xfs_buf **bpp);
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index b99aa7d..f45ecac 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -213,7 +213,7 @@ xfs_dir2_block_getdents(
 	 * Set up values for the loop.
 	 */
 	btp = xfs_dir2_block_tail_p(mp, hdr);
-	ptr = (char *)xfs_dir3_data_entry_p(hdr);
+	ptr = (char *)dp->d_ops->data_entry_p(hdr);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 
 	/*
@@ -578,13 +578,13 @@ xfs_dir2_leaf_getdents(
 			/*
 			 * Find our position in the block.
 			 */
-			ptr = (char *)xfs_dir3_data_entry_p(hdr);
+			ptr = (char *)dp->d_ops->data_entry_p(hdr);
 			byteoff = xfs_dir2_byte_to_off(mp, curoff);
 			/*
 			 * Skip past the header.
 			 */
 			if (byteoff == 0)
-				curoff += xfs_dir3_data_entry_offset(hdr);
+				curoff += dp->d_ops->data_entry_offset();
 			/*
 			 * Skip past entries until we reach our offset.
 			 */
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 953e194..42bbcff 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -210,7 +210,7 @@ xfs_dir2_block_to_sf(
 	 * Set up to loop over the block's entries.
 	 */
 	btp = xfs_dir2_block_tail_p(mp, hdr);
-	ptr = (char *)xfs_dir3_data_entry_p(hdr);
+	ptr = (char *)dp->d_ops->data_entry_p(hdr);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	/*
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
