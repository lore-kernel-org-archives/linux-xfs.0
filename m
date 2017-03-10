Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17283 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755050AbdCJXZS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Mar 2017 18:25:18 -0500
Subject: [PATCH 4/9] xfs_db: write / fuzz bad values into dir/attr blocks
 with good CRCs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 10 Mar 2017 15:25:09 -0800
Message-ID: <148918830960.8311.782001002845453533.stgit@birch.djwong.org>
In-Reply-To: <148918828436.8311.8130426069001200240.stgit@birch.djwong.org>
References: <148918828436.8311.8130426069001200240.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Extend typ_t to (optionally) store a pointer to a function to calculate
the CRC of the block, provide functions to do this for the dir3 and
attr3 types, and then wire up the fuzz and write commands so that we can
effectively fuzz directory and extended attribute block fields.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attr.c  |   32 ++++++++++++++++++++++++++++++++
 db/attr.h  |    1 +
 db/dir2.c  |   37 +++++++++++++++++++++++++++++++++++++
 db/dir2.h  |    1 +
 db/fuzz.c  |    3 +++
 db/type.c  |    8 ++++----
 db/type.h  |    2 ++
 db/write.c |    3 +++
 8 files changed, 83 insertions(+), 4 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index 0fffbc2..5a97925 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -582,6 +582,38 @@ const struct field	attr3_remote_crc_flds[] = {
 	{ NULL }
 };
 
+/* Set the CRC. */
+void
+xfs_attr3_set_crc(
+	struct xfs_buf		*bp)
+{
+	__be32			magic32;
+	__be16			magic16;
+
+	magic32 = *(__be32 *)bp->b_addr;
+	magic16 = ((struct xfs_da_blkinfo *)bp->b_addr)->magic;
+
+	switch (magic16) {
+	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+		xfs_buf_update_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF);
+		return;
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		xfs_buf_update_cksum(bp, XFS_DA3_NODE_CRC_OFF);
+		return;
+	default:
+		break;
+	}
+
+	switch (magic32) {
+	case cpu_to_be32(XFS_ATTR3_RMT_MAGIC):
+		xfs_buf_update_cksum(bp, XFS_ATTR3_RMT_CRC_OFF);
+		return;
+	default:
+		dbprintf(_("Unknown attribute buffer type!\n"));
+		break;
+	}
+}
+
 /*
  * Special read verifier for attribute buffers. Detect the magic number
  * appropriately and set the correct verifier and call it.
diff --git a/db/attr.h b/db/attr.h
index d7bb579..9ea7429 100644
--- a/db/attr.h
+++ b/db/attr.h
@@ -34,5 +34,6 @@ extern const field_t	attr3_remote_crc_flds[];
 
 extern int	attr_leaf_name_size(void *obj, int startoff, int idx);
 extern int	attr_size(void *obj, int startoff, int idx);
+extern void	xfs_attr3_set_crc(struct xfs_buf *bp);
 
 extern const struct xfs_buf_ops xfs_attr3_db_buf_ops;
diff --git a/db/dir2.c b/db/dir2.c
index 533f705..3e21a7b 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -981,6 +981,43 @@ const field_t	da3_node_hdr_flds[] = {
 	{ NULL }
 };
 
+/* Set the CRC. */
+void
+xfs_dir3_set_crc(
+	struct xfs_buf		*bp)
+{
+	__be32			magic32;
+	__be16			magic16;
+
+	magic32 = *(__be32 *)bp->b_addr;
+	magic16 = ((struct xfs_da_blkinfo *)bp->b_addr)->magic;
+
+	switch (magic32) {
+	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
+		xfs_buf_update_cksum(bp, XFS_DIR3_DATA_CRC_OFF);
+		return;
+	case cpu_to_be32(XFS_DIR3_FREE_MAGIC):
+		xfs_buf_update_cksum(bp, XFS_DIR3_FREE_CRC_OFF);
+		return;
+	default:
+		break;
+	}
+
+	switch (magic16) {
+	case cpu_to_be16(XFS_DIR3_LEAF1_MAGIC):
+	case cpu_to_be16(XFS_DIR3_LEAFN_MAGIC):
+		xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
+		return;
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		xfs_buf_update_cksum(bp, XFS_DA3_NODE_CRC_OFF);
+		return;
+	default:
+		dbprintf(_("Unknown directory buffer type! %x %x\n"), magic32, magic16);
+		break;
+	}
+}
+
 /*
  * Special read verifier for directory buffers. Detect the magic number
  * appropriately and set the correct verifier and call it.
diff --git a/db/dir2.h b/db/dir2.h
index 0c2a62e..1b87cd2 100644
--- a/db/dir2.h
+++ b/db/dir2.h
@@ -60,5 +60,6 @@ static inline uint8_t *xfs_dir2_sf_inumberp(xfs_dir2_sf_entry_t *sfep)
 
 extern int	dir2_data_union_size(void *obj, int startoff, int idx);
 extern int	dir2_size(void *obj, int startoff, int idx);
+extern void	xfs_dir3_set_crc(struct xfs_buf *bp);
 
 extern const struct xfs_buf_ops xfs_dir3_db_buf_ops;
diff --git a/db/fuzz.c b/db/fuzz.c
index 061ecd1..f294331 100644
--- a/db/fuzz.c
+++ b/db/fuzz.c
@@ -156,6 +156,9 @@ fuzz_f(
 	} else if (iocur_top->ino_buf) {
 		local_ops.verify_write = xfs_verify_recalc_inode_crc;
 		dbprintf(_("Allowing fuzz of corrupted inode with good CRC\n"));
+	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
+		local_ops.verify_write = iocur_top->typ->set_crc;
+		dbprintf(_("Allowing fuzz of corrupted data with good CRC\n"));
 	} else { /* invalid data */
 		local_ops.verify_write = xfs_verify_recalc_crc;
 		dbprintf(_("Allowing fuzz of corrupted data with good CRC\n"));
diff --git a/db/type.c b/db/type.c
index adab10a..740adc0 100644
--- a/db/type.c
+++ b/db/type.c
@@ -88,7 +88,7 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops,
 		XFS_AGI_CRC_OFF },
 	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
-		&xfs_attr3_db_buf_ops, TYP_F_NO_CRC_OFF },
+		&xfs_attr3_db_buf_ops, TYP_F_CRC_FUNC, xfs_attr3_set_crc },
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
 		&xfs_bmbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld,
@@ -103,7 +103,7 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
-		&xfs_dir3_db_buf_ops, TYP_F_NO_CRC_OFF },
+		&xfs_dir3_db_buf_ops, TYP_F_CRC_FUNC, xfs_dir3_set_crc },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld,
 		&xfs_dquot_buf_ops, TYP_F_NO_CRC_OFF },
 	{ TYP_INOBT, "inobt", handle_struct, inobt_crc_hfld,
@@ -132,7 +132,7 @@ static const typ_t	__typtab_spcrc[] = {
 	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops ,
 		XFS_AGI_CRC_OFF },
 	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
-		&xfs_attr3_db_buf_ops, TYP_F_NO_CRC_OFF },
+		&xfs_attr3_db_buf_ops, TYP_F_CRC_FUNC, xfs_attr3_set_crc },
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
 		&xfs_bmbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld,
@@ -147,7 +147,7 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
-		&xfs_dir3_db_buf_ops, TYP_F_NO_CRC_OFF },
+		&xfs_dir3_db_buf_ops, TYP_F_CRC_FUNC, xfs_dir3_set_crc },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld,
 		&xfs_dquot_buf_ops, TYP_F_NO_CRC_OFF },
 	{ TYP_INOBT, "inobt", handle_struct, inobt_spcrc_hfld,
diff --git a/db/type.h b/db/type.h
index a50d705..3971975 100644
--- a/db/type.h
+++ b/db/type.h
@@ -46,6 +46,8 @@ typedef struct typ
 	const struct xfs_buf_ops *bops;
 	unsigned long		crc_off;
 #define TYP_F_NO_CRC_OFF	(-1UL)
+#define TYP_F_CRC_FUNC		(-2UL)
+	void			(*set_crc)(struct xfs_buf *);
 } typ_t;
 extern const typ_t	*typtab, *cur_typ;
 
diff --git a/db/write.c b/db/write.c
index 5c83874..ea87b40 100644
--- a/db/write.c
+++ b/db/write.c
@@ -164,6 +164,9 @@ write_f(
 	if (corrupt) {
 		local_ops.verify_write = xfs_dummy_verify;
 		dbprintf(_("Allowing write of corrupted data and bad CRC\n"));
+	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
+		local_ops.verify_write = iocur_top->typ->set_crc;
+		dbprintf(_("Allowing write of corrupted data with good CRC\n"));
 	} else { /* invalid data */
 		local_ops.verify_write = xfs_verify_recalc_crc;
 		dbprintf(_("Allowing write of corrupted data with good CRC\n"));

