Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4CDB47F66
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 01:53:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB299AC004
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 23:53:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PFheBKt2rTDYHhxR for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 23:53:30 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeJyJ-0006r7-O7
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeJy9-0006Vx-Ji
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs_db: update field printing for dir crc format changes.
Date: Mon, 20 May 2013 16:53:01 +1000
Message-Id: <1369032783-24973-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1369032783-24973-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<1369032783-24973-1-git-send-email-david@fromorbit.com>
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

Note that this also requires changing the type parsing to only
allow dir3 data block parsing on CRC enabled filesystems. This is
slighly more complex than it needs to be  because of the way the
type table is walked and the assumption that all the entries are in
type number order.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/dir2.c  |  319 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
 db/dir2.h  |   33 +++++--
 db/field.c |   21 ++++
 db/field.h |   14 +++
 db/type.c  |   14 ++-
 db/type.h  |    2 +-
 6 files changed, 336 insertions(+), 67 deletions(-)

diff --git a/db/dir2.c b/db/dir2.c
index 594d9d2..85240b0 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -260,24 +260,34 @@ dir2_block_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_data_hdr *block = obj;
 
 	ASSERT(startoff == 0);
-	block = obj;
 	return be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC;
 }
 
 static int
+dir3_block_hdr_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dir2_data_hdr *block = obj;
+
+	ASSERT(startoff == 0);
+	return be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC;
+}
+
+static int
 dir2_block_leaf_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_data_hdr *block = obj;
 	struct xfs_dir2_block_tail *btp;
 
 	ASSERT(startoff == 0);
-	block = obj;
-	if (be32_to_cpu(block->magic) != XFS_DIR2_BLOCK_MAGIC)
+	if (be32_to_cpu(block->magic) != XFS_DIR2_BLOCK_MAGIC &&
+	    be32_to_cpu(block->magic) != XFS_DIR3_BLOCK_MAGIC)
 		return 0;
 	btp = xfs_dir2_block_tail_p(mp, block);
 	return be32_to_cpu(btp->count);
@@ -289,13 +299,13 @@ dir2_block_leaf_offset(
 	int			startoff,
 	int			idx)
 {
-	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_data_hdr *block = obj;
 	struct xfs_dir2_block_tail *btp;
 	struct xfs_dir2_leaf_entry *lep;
 
 	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	       be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC);
 	btp = xfs_dir2_block_tail_p(mp, block);
 	lep = xfs_dir2_block_leaf_p(btp) + idx;
 	return bitize((int)((char *)lep - (char *)block));
@@ -306,14 +316,23 @@ dir2_block_tail_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_data_hdr *block = obj;
 
 	ASSERT(startoff == 0);
-	block = obj;
 	return be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC;
 }
 
-/*ARGSUSED*/
+static int
+dir3_block_tail_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dir2_data_hdr *block = obj;
+
+	ASSERT(startoff == 0);
+	return be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC;
+}
+
 static int
 dir2_block_tail_offset(
 	void			*obj,
@@ -322,7 +341,8 @@ dir2_block_tail_offset(
 {
 	struct xfs_dir2_data_hdr *block = obj;
 
-	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	       be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC);
 	return __dir2_block_tail_offset(block, startoff, idx);
 }
 
@@ -335,7 +355,8 @@ dir2_block_u_count(
 	struct xfs_dir2_block_tail *btp;
 
 	ASSERT(startoff == 0);
-	if (be32_to_cpu(block->magic) != XFS_DIR2_BLOCK_MAGIC)
+	if (be32_to_cpu(block->magic) != XFS_DIR2_BLOCK_MAGIC &&
+	    be32_to_cpu(block->magic) != XFS_DIR3_BLOCK_MAGIC)
 		return 0;
 
 	btp = xfs_dir2_block_tail_p(mp, block);
@@ -354,7 +375,8 @@ dir2_block_u_offset(
 	char			*ptr;
 
 	ASSERT(startoff == 0);
-	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	       be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC);
 	btp = xfs_dir2_block_tail_p(mp, block);
 	ptr = __dir2_data_entry_offset((char *)xfs_dir3_data_unused_p(block),
 				       (char *)xfs_dir2_block_leaf_p(btp), idx);
@@ -479,7 +501,6 @@ dir2_data_union_tag_count(
 	return end <= (char *)obj + mp->m_dirblksize;
 }
 
-/*ARGSUSED*/
 static int
 dir2_data_union_tag_offset(
 	void			*obj,
@@ -500,20 +521,28 @@ dir2_data_union_tag_offset(
 			    (char *)dep));
 }
 
-/*ARGSUSED*/
 static int
 dir2_data_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_data_hdr *data;
+	struct xfs_dir2_data_hdr *data = obj;
 
 	ASSERT(startoff == 0);
-	data = obj;
 	return be32_to_cpu(data->magic) == XFS_DIR2_DATA_MAGIC;
 }
 
-/*ARGSUSED*/
+static int
+dir3_data_hdr_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dir2_data_hdr *data = obj;
+
+	ASSERT(startoff == 0);
+	return be32_to_cpu(data->magic) == XFS_DIR3_DATA_MAGIC;
+}
+
 static int
 dir2_data_u_count(
 	void			*obj,
@@ -522,7 +551,8 @@ dir2_data_u_count(
 	struct xfs_dir2_data_hdr *data = obj;
 
 	ASSERT(startoff == 0);
-	if (be32_to_cpu(data->magic) != XFS_DIR2_DATA_MAGIC)
+	if (be32_to_cpu(data->magic) != XFS_DIR2_DATA_MAGIC &&
+	    be32_to_cpu(data->magic) != XFS_DIR3_DATA_MAGIC)
 		return 0;
 
 	return __dir2_data_entries_count((char *)xfs_dir3_data_unused_p(data),
@@ -539,7 +569,8 @@ dir2_data_u_offset(
 	char			*ptr;
 
 	ASSERT(startoff == 0);
-	ASSERT(be32_to_cpu(data->magic) == XFS_DIR2_DATA_MAGIC);
+	ASSERT(be32_to_cpu(data->magic) == XFS_DIR2_DATA_MAGIC ||
+	       be32_to_cpu(data->magic) == XFS_DIR3_DATA_MAGIC);
 	ptr = __dir2_data_entry_offset((char *)xfs_dir3_data_unused_p(data),
 				       (char *)data + mp->m_dirblksize, idx);
 	return bitize((int)(ptr - (char *)data));
@@ -565,160 +596,236 @@ dir2_data_union_size(
 	}
 }
 
-/*ARGSUSED*/
+/*
+ * Free block functions
+ */
 static int
 dir2_free_bests_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_free	*free;
+	struct xfs_dir2_free	*free = obj;
 
 	ASSERT(startoff == 0);
-	free = obj;
 	if (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC)
 		return 0;
 	return be32_to_cpu(free->hdr.nvalid);
 }
 
-/*ARGSUSED*/
+static int
+dir3_free_bests_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dir3_free	*free = obj;
+
+	ASSERT(startoff == 0);
+	if (be32_to_cpu(free->hdr.hdr.magic) != XFS_DIR3_FREE_MAGIC)
+		return 0;
+	return be32_to_cpu(free->hdr.nvalid);
+}
+
 static int
 dir2_free_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_free	*free;
+	struct xfs_dir2_free	*free = obj;
 
 	ASSERT(startoff == 0);
-	free = obj;
 	return be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC;
 }
 
-/*ARGSUSED*/
+static int
+dir3_free_hdr_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dir3_free	*free = obj;
+
+	ASSERT(startoff == 0);
+	return be32_to_cpu(free->hdr.hdr.magic) == XFS_DIR3_FREE_MAGIC;
+}
+
+/*
+ * Leaf block functions
+ */
 static int
 dir2_leaf_bests_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_leaf	*leaf;
+	struct xfs_dir2_leaf	*leaf = obj;
 	struct xfs_dir2_leaf_tail *ltp;
 
 	ASSERT(startoff == 0);
-	leaf = obj;
-	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR2_LEAF1_MAGIC)
+	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR2_LEAF1_MAGIC &&
+	    be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR3_LEAF1_MAGIC)
 		return 0;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	return be32_to_cpu(ltp->bestcount);
 }
 
-/*ARGSUSED*/
 static int
 dir2_leaf_bests_offset(
 	void			*obj,
 	int			startoff,
 	int			idx)
 {
-	struct xfs_dir2_leaf	*leaf;
+	struct xfs_dir2_leaf	*leaf = obj;
 	struct xfs_dir2_leaf_tail *ltp;
 	__be16			*lbp;
 
 	ASSERT(startoff == 0);
-	leaf = obj;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC);
+	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC ||
+	       be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR3_LEAF1_MAGIC);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	lbp = xfs_dir2_leaf_bests_p(ltp) + idx;
 	return bitize((int)((char *)lbp - (char *)leaf));
 }
 
-/*ARGSUSED*/
 static int
 dir2_leaf_ents_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_leaf	*leaf;
+	struct xfs_dir2_leaf	*leaf = obj;
 
 	ASSERT(startoff == 0);
-	leaf = obj;
 	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR2_LEAF1_MAGIC &&
 	    be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR2_LEAFN_MAGIC)
 		return 0;
 	return be16_to_cpu(leaf->hdr.count);
 }
 
-/*ARGSUSED*/
+static int
+dir3_leaf_ents_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dir3_leaf	*leaf = obj;
+
+	ASSERT(startoff == 0);
+	if (be16_to_cpu(leaf->hdr.info.hdr.magic) != XFS_DIR3_LEAF1_MAGIC &&
+	    be16_to_cpu(leaf->hdr.info.hdr.magic) != XFS_DIR3_LEAFN_MAGIC)
+		return 0;
+	return be16_to_cpu(leaf->hdr.count);
+}
+
 static int
 dir2_leaf_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_leaf	*leaf;
+	struct xfs_dir2_leaf	*leaf = obj;
 
 	ASSERT(startoff == 0);
-	leaf = obj;
 	return be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC ||
 	       be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC;
 }
 
-/*ARGSUSED*/
+static int
+dir3_leaf_hdr_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dir3_leaf	*leaf = obj;
+
+	ASSERT(startoff == 0);
+	return be16_to_cpu(leaf->hdr.info.hdr.magic) == XFS_DIR3_LEAF1_MAGIC ||
+	       be16_to_cpu(leaf->hdr.info.hdr.magic) == XFS_DIR3_LEAFN_MAGIC;
+}
+
 static int
 dir2_leaf_tail_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_leaf	*leaf;
+	struct xfs_dir2_leaf	*leaf = obj;
 
 	ASSERT(startoff == 0);
-	leaf = obj;
 	return be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC;
 }
 
-/*ARGSUSED*/
+static int
+dir3_leaf_tail_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dir3_leaf	*leaf = obj;
+
+	ASSERT(startoff == 0);
+	return be16_to_cpu(leaf->hdr.info.hdr.magic) == XFS_DIR3_LEAF1_MAGIC;
+}
+
 static int
 dir2_leaf_tail_offset(
 	void			*obj,
 	int			startoff,
 	int			idx)
 {
-	struct xfs_dir2_leaf	*leaf;
+	struct xfs_dir2_leaf	*leaf = obj;
 	struct xfs_dir2_leaf_tail *ltp;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
-	leaf = obj;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC);
+	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC ||
+	       be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR3_LEAF1_MAGIC);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	return bitize((int)((char *)ltp - (char *)leaf));
 }
 
-/*ARGSUSED*/
+/*
+ * Node format functions
+ */
 static int
 dir2_node_btree_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_da_intnode_t	*node;
+	xfs_da_intnode_t	*node = obj;
 
 	ASSERT(startoff == 0);
-	node = obj;
 	if (be16_to_cpu(node->hdr.info.magic) != XFS_DA_NODE_MAGIC)
 		return 0;
 	return be16_to_cpu(node->hdr.__count);
 }
 
-/*ARGSUSED*/
+static int
+dir3_node_btree_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_da3_intnode	*node = obj;
+
+	ASSERT(startoff == 0);
+	if (be16_to_cpu(node->hdr.info.hdr.magic) != XFS_DA3_NODE_MAGIC)
+		return 0;
+	return be16_to_cpu(node->hdr.__count);
+}
+
 static int
 dir2_node_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_da_intnode	*node;
+	struct xfs_da_intnode	*node = obj;
 
 	ASSERT(startoff == 0);
-	node = obj;
 	return be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC;
 }
 
-/*ARGSUSED*/
+static int
+dir3_node_hdr_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_da3_intnode	*node = obj;
+
+	ASSERT(startoff == 0);
+	return be16_to_cpu(node->hdr.info.hdr.magic) == XFS_DA3_NODE_MAGIC;
+}
+
 int
 dir2_size(
 	void	*obj,
@@ -727,3 +834,105 @@ dir2_size(
 {
 	return bitize(mp->m_dirblksize);
 }
+
+/*
+ * CRC enabled structure definitions
+ */
+const field_t	dir3_hfld[] = {
+	{ "", FLDT_DIR3, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	B3OFF(f)	bitize(offsetof(struct xfs_dir3_data_hdr, f))
+#define	D3OFF(f)	bitize(offsetof(struct xfs_dir3_data_hdr, f))
+#define	F3OFF(f)	bitize(offsetof(struct xfs_dir3_free, f))
+#define	L3OFF(f)	bitize(offsetof(struct xfs_dir3_leaf, f))
+#define	N3OFF(f)	bitize(offsetof(struct xfs_da3_intnode, f))
+const field_t	dir3_flds[] = {
+	{ "bhdr", FLDT_DIR3_DATA_HDR, OI(B3OFF(hdr)), dir3_block_hdr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "bu", FLDT_DIR2_DATA_UNION, dir2_block_u_offset, dir2_block_u_count,
+	  FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "bleaf", FLDT_DIR2_LEAF_ENTRY, dir2_block_leaf_offset,
+	  dir2_block_leaf_count, FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "btail", FLDT_DIR2_BLOCK_TAIL, dir2_block_tail_offset,
+	  dir3_block_tail_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "dhdr", FLDT_DIR3_DATA_HDR, OI(D3OFF(hdr)), dir3_data_hdr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "du", FLDT_DIR2_DATA_UNION, dir2_data_u_offset, dir2_data_u_count,
+	  FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "lhdr", FLDT_DIR3_LEAF_HDR, OI(L3OFF(hdr)), dir3_leaf_hdr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "lbests", FLDT_DIR2_DATA_OFF, dir2_leaf_bests_offset,
+	  dir2_leaf_bests_count, FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "lents", FLDT_DIR2_LEAF_ENTRY, OI(L3OFF(__ents)), dir3_leaf_ents_count,
+	  FLD_ARRAY|FLD_COUNT, TYP_NONE },
+	{ "ltail", FLDT_DIR2_LEAF_TAIL, dir2_leaf_tail_offset,
+	  dir3_leaf_tail_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "nhdr", FLDT_DA3_NODE_HDR, OI(N3OFF(hdr)), dir3_node_hdr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "nbtree", FLDT_DA_NODE_ENTRY, OI(N3OFF(__btree)), dir3_node_btree_count,
+	  FLD_ARRAY|FLD_COUNT, TYP_NONE },
+	{ "fhdr", FLDT_DIR3_FREE_HDR, OI(F3OFF(hdr)), dir3_free_hdr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "fbests", FLDT_DIR2_DATA_OFFNZ, OI(F3OFF(bests)),
+	  dir3_free_bests_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
+	{ NULL }
+};
+
+#define	DBH3OFF(f)	bitize(offsetof(struct xfs_dir3_blk_hdr, f))
+const field_t	dir3_blkhdr_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(DBH3OFF(magic)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(DBH3OFF(crc)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(DBH3OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(DBH3OFF(lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(DBH3OFF(uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(DBH3OFF(owner)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	DH3OFF(f)	bitize(offsetof(struct xfs_dir3_data_hdr, f))
+const field_t	dir3_data_hdr_flds[] = {
+	{ "hdr", FLDT_DIR3_BLKHDR, OI(DH3OFF(hdr)), C1, 0, TYP_NONE },
+	{ "bestfree", FLDT_DIR2_DATA_FREE, OI(DH3OFF(best_free)),
+	  CI(XFS_DIR2_DATA_FD_COUNT), FLD_ARRAY, TYP_NONE },
+	{ NULL }
+};
+
+#define	LH3OFF(f)	bitize(offsetof(struct xfs_dir3_leaf_hdr, f))
+const field_t	dir3_leaf_hdr_flds[] = {
+	{ "info", FLDT_DA3_BLKINFO, OI(LH3OFF(info)), C1, 0, TYP_NONE },
+	{ "count", FLDT_UINT16D, OI(LH3OFF(count)), C1, 0, TYP_NONE },
+	{ "stale", FLDT_UINT16D, OI(LH3OFF(stale)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	FH3OFF(f)	bitize(offsetof(struct xfs_dir3_free_hdr, f))
+const field_t	dir3_free_hdr_flds[] = {
+	{ "hdr", FLDT_DIR3_BLKHDR, OI(FH3OFF(hdr)), C1, 0, TYP_NONE },
+	{ "firstdb", FLDT_INT32D, OI(FH3OFF(firstdb)), C1, 0, TYP_NONE },
+	{ "nvalid", FLDT_INT32D, OI(FH3OFF(nvalid)), C1, 0, TYP_NONE },
+	{ "nused", FLDT_INT32D, OI(FH3OFF(nused)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+
+#define	DB3OFF(f)	bitize(offsetof(struct xfs_da3_blkinfo, f))
+const field_t	da3_blkinfo_flds[] = {
+	{ "hdr", FLDT_DA_BLKINFO, OI(DB3OFF(hdr)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(DB3OFF(crc)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(DB3OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(DB3OFF(lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(DB3OFF(uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(DB3OFF(owner)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	H3OFF(f)	bitize(offsetof(struct xfs_da3_node_hdr, f))
+const field_t	da3_node_hdr_flds[] = {
+	{ "info", FLDT_DA3_BLKINFO, OI(H3OFF(info)), C1, 0, TYP_NONE },
+	{ "count", FLDT_UINT16D, OI(H3OFF(__count)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(H3OFF(__level)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32D, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
+	{ NULL }
+};
diff --git a/db/dir2.h b/db/dir2.h
index 05ab354..d9dc27b 100644
--- a/db/dir2.h
+++ b/db/dir2.h
@@ -16,21 +16,42 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-extern const field_t	dir2_flds[];
-extern const field_t	dir2_hfld[];
+/*
+ * common types across directory formats
+ */
 extern const field_t	dir2_block_tail_flds[];
 extern const field_t	dir2_data_free_flds[];
-extern const field_t	dir2_data_hdr_flds[];
 extern const field_t	dir2_data_union_flds[];
-extern const field_t	dir2_free_hdr_flds[];
+extern const field_t	dir2_leaf_tail_flds[];
 extern const field_t	dir2_leaf_entry_flds[];
+
+extern const field_t	da_node_entry_flds[];
+
+/*
+ * dirv2 specific types
+ */
+extern const field_t	dir2_flds[];
+extern const field_t	dir2_hfld[];
+extern const field_t	dir2_data_hdr_flds[];
+extern const field_t	dir2_free_hdr_flds[];
 extern const field_t	dir2_leaf_hdr_flds[];
-extern const field_t	dir2_leaf_tail_flds[];
 
 extern const field_t	da_blkinfo_flds[];
-extern const field_t	da_node_entry_flds[];
 extern const field_t	da_node_hdr_flds[];
 
+/*
+ * dirv3 specific types
+ */
+extern const field_t	dir3_flds[];
+extern const field_t	dir3_hfld[];
+extern const field_t	dir3_blkhdr_flds[];
+extern const field_t	dir3_data_hdr_flds[];
+extern const field_t	dir3_free_hdr_flds[];
+extern const field_t	dir3_leaf_hdr_flds[];
+
+extern const field_t	da3_blkinfo_flds[];
+extern const field_t	da3_node_hdr_flds[];
+
 static inline xfs_dir2_inou_t *xfs_dir2_sf_inumberp(xfs_dir2_sf_entry_t *sfep)
 {
 	return (xfs_dir2_inou_t *)&(sfep)->name[(sfep)->namelen];
diff --git a/db/field.c b/db/field.c
index 510ad84..cb15318 100644
--- a/db/field.c
+++ b/db/field.c
@@ -166,6 +166,8 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_SIZE|FTARG_OKEMPTY, NULL, inode_u_flds },
 	{ FLDT_DINODE_V3, "dinode_v3", NULL, (char *)inode_v3_flds,
 	  SI(bitsz(xfs_dinode_t)), 0, NULL, inode_v3_flds },
+
+/* dir v2 fields */
 	{ FLDT_DIR2, "dir2", NULL, (char *)dir2_flds, dir2_size, FTARG_SIZE,
 	  NULL, dir2_flds },
 	{ FLDT_DIR2_BLOCK_TAIL, "dir2_block_tail", NULL,
@@ -207,6 +209,20 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(xfs_dir2_sf_off_t)), 0, NULL, NULL },
 	{ FLDT_DIR2SF, "dir2sf", NULL, (char *)dir2sf_flds, dir2sf_size,
 	  FTARG_SIZE, NULL, dir2sf_flds },
+
+/* dir v3 fields */
+	{ FLDT_DIR3, "dir3", NULL, (char *)dir3_flds, dir2_size, FTARG_SIZE,
+	  NULL, dir3_flds },
+	{ FLDT_DIR3_BLKHDR, "dir3_blk_hdr", NULL, (char *)dir3_blkhdr_flds,
+	  SI(bitsz(struct xfs_dir3_blk_hdr)), 0, NULL, dir3_blkhdr_flds },
+	{ FLDT_DIR3_DATA_HDR, "dir3_data_hdr", NULL, (char *)dir3_data_hdr_flds,
+	  SI(bitsz(struct xfs_dir3_data_hdr)), 0, NULL, dir3_data_hdr_flds },
+	{ FLDT_DIR3_FREE_HDR, "dir3_free_hdr", NULL, (char *)dir3_free_hdr_flds,
+	  SI(bitsz(struct xfs_dir3_free_hdr)), 0, NULL, dir3_free_hdr_flds },
+	{ FLDT_DIR3_LEAF_HDR, "dir3_leaf_hdr", NULL, (char *)dir3_leaf_hdr_flds,
+	  SI(bitsz(struct xfs_dir3_leaf_hdr)), 0, NULL, dir3_leaf_hdr_flds },
+
+/* dir v2/3 node fields */
 	{ FLDT_DA_BLKINFO, "dir_blkinfo", NULL, (char *)da_blkinfo_flds,
 	  SI(bitsz(struct xfs_da_blkinfo)), 0, NULL, da_blkinfo_flds },
 	{ FLDT_DA_NODE_ENTRY, "dir_node_entry", fp_sarray,
@@ -214,6 +230,11 @@ const ftattr_t	ftattrtab[] = {
 	  NULL, da_node_entry_flds },
 	{ FLDT_DA_NODE_HDR, "dir_node_hdr", NULL, (char *)da_node_hdr_flds,
 	  SI(bitsz(struct xfs_da_node_hdr)), 0, NULL, da_node_hdr_flds },
+	{ FLDT_DA3_BLKINFO, "dir_blkinfo", NULL, (char *)da3_blkinfo_flds,
+	  SI(bitsz(struct xfs_da3_blkinfo)), 0, NULL, da3_blkinfo_flds },
+	{ FLDT_DA3_NODE_HDR, "dir_node_hdr", NULL, (char *)da3_node_hdr_flds,
+	  SI(bitsz(struct xfs_da3_node_hdr)), 0, NULL, da3_node_hdr_flds },
+
 	{ FLDT_DIRBLOCK, "dirblock", fp_num, "%u", SI(bitsz(__uint32_t)), 0,
 	  fa_dirblock, NULL },
 	{ FLDT_DISK_DQUOT, "disk_dquot", NULL, (char *)disk_dquot_flds,
diff --git a/db/field.h b/db/field.h
index 9b332f5..5671571 100644
--- a/db/field.h
+++ b/db/field.h
@@ -81,6 +81,8 @@ typedef enum fldt	{
 	FLDT_DINODE_FMT,
 	FLDT_DINODE_U,
 	FLDT_DINODE_V3,
+
+	/* dir v2 fields */
 	FLDT_DIR2,
 	FLDT_DIR2_BLOCK_TAIL,
 	FLDT_DIR2_DATA_FREE,
@@ -99,9 +101,21 @@ typedef enum fldt	{
 	FLDT_DIR2_SF_HDR,
 	FLDT_DIR2_SF_OFF,
 	FLDT_DIR2SF,
+
+	/* dir v3 fields */
+	FLDT_DIR3,
+	FLDT_DIR3_BLKHDR,
+	FLDT_DIR3_DATA_HDR,
+	FLDT_DIR3_FREE_HDR,
+	FLDT_DIR3_LEAF_HDR,
+
+	/* dir v2/3 node fields */
 	FLDT_DA_BLKINFO,
 	FLDT_DA_NODE_ENTRY,
 	FLDT_DA_NODE_HDR,
+	FLDT_DA3_BLKINFO,
+	FLDT_DA3_NODE_HDR,
+
 	FLDT_DIRBLOCK,
 	FLDT_DISK_DQUOT,
 	FLDT_DQBLK,
diff --git a/db/type.c b/db/type.c
index 97f3548..0c64422 100644
--- a/db/type.c
+++ b/db/type.c
@@ -59,6 +59,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld },
 	{ TYP_DATA, "data", handle_block, NULL },
 	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld },
+	{ TYP_DIR3, NULL, NULL, NULL },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld },
 	{ TYP_INOBT, "inobt", handle_struct, inobt_hfld },
 	{ TYP_INODATA, "inodata", NULL, NULL },
@@ -82,7 +83,8 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_crc_hfld },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld },
 	{ TYP_DATA, "data", handle_block, NULL },
-	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld },
+	{ TYP_DIR2, NULL, NULL, NULL },
+	{ TYP_DIR3, "dir3", handle_struct, dir3_hfld },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld },
 	{ TYP_INOBT, "inobt", handle_struct, inobt_crc_hfld },
 	{ TYP_INODATA, "inodata", NULL, NULL },
@@ -110,9 +112,9 @@ findtyp(
 {
 	const typ_t	*tt;
 
-	for (tt = typtab; tt->name != NULL; tt++) {
+	for (tt = typtab; tt->typnm != TYP_NONE; tt++) {
 		ASSERT(tt->typnm == (typnm_t)(tt - typtab));
-		if (strcmp(tt->name, name) == 0)
+		if (tt->name && strcmp(tt->name, name) == 0)
 			return tt;
 	}
 	return NULL;
@@ -133,12 +135,14 @@ type_f(
 			dbprintf(_("current type is \"%s\"\n"), cur_typ->name);
 
 		dbprintf(_("\n supported types are:\n "));
-		for (tt = typtab, count = 0; tt->name != NULL; tt++) {
+		for (tt = typtab, count = 0; tt->typnm != TYP_NONE; tt++) {
+			if (tt->name == NULL)
+				continue;
 			if ((tt+1)->name != NULL) {
 				dbprintf("%s, ", tt->name);
 				if ((++count % 8) == 0)
 					dbprintf("\n ");
-			} else {
+			} else if ((tt+1)->typnm == TYP_NONE) {
 				dbprintf("%s\n", tt->name);
 			}
 		}
diff --git a/db/type.h b/db/type.h
index c41aca4..8fd8dc3 100644
--- a/db/type.h
+++ b/db/type.h
@@ -25,7 +25,7 @@ typedef enum typnm
 {
 	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
 	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_DATA,
-	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
+	TYP_DIR2, TYP_DIR3, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
 	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
 	TYP_TEXT, TYP_NONE
 } typnm_t;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
