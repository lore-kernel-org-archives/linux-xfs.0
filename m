Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46283 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754103AbcJYXEj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:04:39 -0400
Subject: [PATCH 09/39] xfs_db: dump refcount btree data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:04:33 -0700
Message-ID: <147743667365.11035.7315587935264063644.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Add the ability to walk and dump the refcount btree in xfs_db.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/agf.c          |   13 +++++++++++--
 db/btblock.c      |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/btblock.h      |    5 +++++
 db/field.c        |   13 +++++++++++++
 db/field.h        |    6 ++++++
 db/inode.c        |    3 +++
 db/sb.c           |    2 ++
 db/type.c         |    5 +++++
 db/type.h         |    2 +-
 man/man8/xfs_db.8 |   47 +++++++++++++++++++++++++++++++++++++++++++--
 10 files changed, 146 insertions(+), 5 deletions(-)


diff --git a/db/agf.c b/db/agf.c
index 467dd4c..275f407 100644
--- a/db/agf.c
+++ b/db/agf.c
@@ -47,7 +47,7 @@ const field_t	agf_flds[] = {
 	{ "versionnum", FLDT_UINT32D, OI(OFF(versionnum)), C1, 0, TYP_NONE },
 	{ "seqno", FLDT_AGNUMBER, OI(OFF(seqno)), C1, 0, TYP_NONE },
 	{ "length", FLDT_AGBLOCK, OI(OFF(length)), C1, 0, TYP_NONE },
-	{ "roots", FLDT_AGBLOCK, OI(OFF(roots)), CI(XFS_BTNUM_AGF),
+	{ "roots", FLDT_AGBLOCK, OI(OFF(roots)), CI(XFS_BTNUM_AGF) + 1,
 	  FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
 	{ "bnoroot", FLDT_AGBLOCK,
 	  OI(OFF(roots) + XFS_BTNUM_BNO * SZ(roots[XFS_BTNUM_BNO])), C1, 0,
@@ -58,7 +58,10 @@ const field_t	agf_flds[] = {
 	{ "rmaproot", FLDT_AGBLOCKNZ,
 	  OI(OFF(roots) + XFS_BTNUM_RMAP * SZ(roots[XFS_BTNUM_RMAP])), C1, 0,
 	  TYP_RMAPBT },
-	{ "levels", FLDT_UINT32D, OI(OFF(levels)), CI(XFS_BTNUM_AGF),
+	{ "refcntroot", FLDT_AGBLOCKNZ,
+	  OI(OFF(refcount_root)), C1, 0,
+	  TYP_REFCBT },
+	{ "levels", FLDT_UINT32D, OI(OFF(levels)), CI(XFS_BTNUM_AGF) + 1,
 	  FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
 	{ "bnolevel", FLDT_UINT32D,
 	  OI(OFF(levels) + XFS_BTNUM_BNO * SZ(levels[XFS_BTNUM_BNO])), C1, 0,
@@ -69,9 +72,15 @@ const field_t	agf_flds[] = {
 	{ "rmaplevel", FLDT_UINT32D,
 	  OI(OFF(levels) + XFS_BTNUM_RMAP * SZ(levels[XFS_BTNUM_RMAP])), C1, 0,
 	  TYP_NONE },
+	{ "refcntlevel", FLDT_UINT32D,
+	  OI(OFF(refcount_level)), C1, 0,
+	  TYP_NONE },
 	{ "rmapblocks", FLDT_UINT32D,
 	  OI(OFF(rmap_blocks)), C1, 0,
 	  TYP_NONE },
+	{ "refcntblocks", FLDT_UINT32D,
+	  OI(OFF(refcount_blocks)), C1, 0,
+	  TYP_NONE },
 	{ "flfirst", FLDT_UINT32D, OI(OFF(flfirst)), C1, 0, TYP_NONE },
 	{ "fllast", FLDT_UINT32D, OI(OFF(fllast)), C1, 0, TYP_NONE },
 	{ "flcount", FLDT_UINT32D, OI(OFF(flcount)), C1, 0, TYP_NONE },
diff --git a/db/btblock.c b/db/btblock.c
index ce59d18..835a5f0 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -102,6 +102,12 @@ struct xfs_db_btree {
 		sizeof(struct xfs_rmap_rec),
 		sizeof(__be32),
 	},
+	{	XFS_REFC_CRC_MAGIC,
+		XFS_BTREE_SBLOCK_CRC_LEN,
+		sizeof(struct xfs_refcount_key),
+		sizeof(struct xfs_refcount_rec),
+		sizeof(__be32),
+	},
 	{	0,
 	},
 };
@@ -707,3 +713,52 @@ const field_t	rmapbt_rec_flds[] = {
 	{ NULL }
 };
 #undef ROFF
+
+/* refcount btree blocks */
+const field_t	refcbt_crc_hfld[] = {
+	{ "", FLDT_REFCBT_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(struct xfs_btree_block, bb_ ## f))
+const field_t	refcbt_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_REFCBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_REFCBT },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.s.bb_blkno)), C1, 0, TYP_REFCBT },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_REFCBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_REFCBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_REFCBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_REFCBT },
+	{ NULL }
+};
+#undef OFF
+
+#define REFCNTBT_COWFLAG_BITOFF		0
+#define REFCNTBT_STARTBLOCK_BITOFF	(REFCNTBT_COWFLAG_BITOFF + REFCNTBT_COWFLAG_BITLEN)
+
+#define	KOFF(f)	bitize(offsetof(struct xfs_refcount_key, rc_ ## f))
+const field_t	refcbt_key_flds[] = {
+	{ "startblock", FLDT_CAGBLOCK, OI(REFCNTBT_STARTBLOCK_BITOFF), C1, 0, TYP_DATA },
+	{ "cowflag", FLDT_CCOWFLG, OI(REFCNTBT_COWFLAG_BITOFF), C1, 0, TYP_DATA },
+	{ NULL }
+};
+#undef KOFF
+
+#define	ROFF(f)	bitize(offsetof(struct xfs_refcount_rec, rc_ ## f))
+const field_t	refcbt_rec_flds[] = {
+	{ "startblock", FLDT_CAGBLOCK, OI(REFCNTBT_STARTBLOCK_BITOFF), C1, 0, TYP_DATA },
+	{ "blockcount", FLDT_EXTLEN, OI(ROFF(blockcount)), C1, 0, TYP_NONE },
+	{ "refcount", FLDT_UINT32D, OI(ROFF(refcount)), C1, 0, TYP_DATA },
+	{ "cowflag", FLDT_CCOWFLG, OI(REFCNTBT_COWFLAG_BITOFF), C1, 0, TYP_DATA },
+	{ NULL }
+};
+#undef ROFF
diff --git a/db/btblock.h b/db/btblock.h
index 35299b4..fead2f1 100644
--- a/db/btblock.h
+++ b/db/btblock.h
@@ -59,4 +59,9 @@ extern const struct field	rmapbt_crc_hfld[];
 extern const struct field	rmapbt_key_flds[];
 extern const struct field	rmapbt_rec_flds[];
 
+extern const struct field	refcbt_crc_flds[];
+extern const struct field	refcbt_crc_hfld[];
+extern const struct field	refcbt_key_flds[];
+extern const struct field	refcbt_rec_flds[];
+
 extern int	btblock_size(void *obj, int startoff, int idx);
diff --git a/db/field.c b/db/field.c
index ca7642f..1968dd5 100644
--- a/db/field.c
+++ b/db/field.c
@@ -163,6 +163,10 @@ const ftattr_t	ftattrtab[] = {
 	  NULL, NULL },
 	{ FLDT_RBMBTFLG, "rbmbtflag", fp_num, "%u", SI(RMAPBT_BMBTFLAG_BITLEN), 0,
 	  NULL, NULL },
+	{ FLDT_CAGBLOCK, "cagblock", fp_num, "%u", SI(REFCNTBT_AGBLOCK_BITLEN),
+	  FTARG_DONULL, fa_agblock, NULL },
+	{ FLDT_CCOWFLG, "ccowflag", fp_num, "%u", SI(REFCNTBT_COWFLAG_BITLEN), 0,
+	  NULL, NULL },
 	{ FLDT_CNTBT, "cntbt", NULL, (char *)cntbt_flds, btblock_size, FTARG_SIZE,
 	  NULL, cntbt_flds },
 	{ FLDT_CNTBT_CRC, "cntbt", NULL, (char *)cntbt_crc_flds, btblock_size,
@@ -183,6 +187,15 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_RMAPBTREC, "rmapbtrec", fp_sarray, (char *)rmapbt_rec_flds,
 	  SI(bitsz(struct xfs_rmap_rec)), 0, NULL, rmapbt_rec_flds },
 
+	{ FLDT_REFCBT_CRC, "refcntbt", NULL, (char *)refcbt_crc_flds, btblock_size,
+	  FTARG_SIZE, NULL, refcbt_crc_flds },
+	{ FLDT_REFCBTKEY, "refcntbtkey", fp_sarray, (char *)refcbt_key_flds,
+	  SI(bitsz(struct xfs_refcount_key)), 0, NULL, refcbt_key_flds },
+	{ FLDT_REFCBTPTR, "refcntbtptr", fp_num, "%u", SI(bitsz(xfs_refcount_ptr_t)),
+	  0, fa_agblock, NULL },
+	{ FLDT_REFCBTREC, "refcntbtrec", fp_sarray, (char *)refcbt_rec_flds,
+	  SI(bitsz(struct xfs_refcount_rec)), 0, NULL, refcbt_rec_flds },
+
 /* CRC field */
 	{ FLDT_CRC, "crc", fp_crc, "%#x (%s)", SI(bitsz(__uint32_t)),
 	  0, NULL, NULL },
diff --git a/db/field.h b/db/field.h
index 47f562a..53616f1 100644
--- a/db/field.h
+++ b/db/field.h
@@ -80,6 +80,8 @@ typedef enum fldt	{
 	FLDT_REXTFLG,
 	FLDT_RATTRFORKFLG,
 	FLDT_RBMBTFLG,
+	FLDT_CAGBLOCK,
+	FLDT_CCOWFLG,
 	FLDT_CNTBT,
 	FLDT_CNTBT_CRC,
 	FLDT_CNTBTKEY,
@@ -89,6 +91,10 @@ typedef enum fldt	{
 	FLDT_RMAPBTKEY,
 	FLDT_RMAPBTPTR,
 	FLDT_RMAPBTREC,
+	FLDT_REFCBT_CRC,
+	FLDT_REFCBTKEY,
+	FLDT_REFCBTPTR,
+	FLDT_REFCBTREC,
 
 	/* CRC field type */
 	FLDT_CRC,
diff --git a/db/inode.c b/db/inode.c
index 442e6ea..702cdf8 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -175,6 +175,9 @@ const field_t	inode_v3_flds[] = {
 	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
 	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },
+	{ "reflink", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(__uint64_t) - XFS_DIFLAG2_REFLINK_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/sb.c b/db/sb.c
index 79a3c1d..8e7722c 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -694,6 +694,8 @@ version_string(
 		strcat(s, ",SPARSE_INODES");
 	if (xfs_sb_version_hasmetauuid(sbp))
 		strcat(s, ",META_UUID");
+	if (xfs_sb_version_hasreflink(sbp))
+		strcat(s, ",REFLINK");
 	return s;
 }
 
diff --git a/db/type.c b/db/type.c
index 337243a..10fa54e 100644
--- a/db/type.c
+++ b/db/type.c
@@ -61,6 +61,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RMAPBT, NULL },
+	{ TYP_REFCBT, NULL },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld, NULL, TYP_F_NO_CRC_OFF },
@@ -97,6 +98,8 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_allocbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RMAPBT, "rmapbt", handle_struct, rmapbt_crc_hfld,
 		&xfs_rmapbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_REFCBT, "refcntbt", handle_struct, refcbt_crc_hfld,
+		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
 		&xfs_dir3_db_buf_ops, TYP_F_NO_CRC_OFF },
@@ -139,6 +142,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_allocbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RMAPBT, "rmapbt", handle_struct, rmapbt_crc_hfld,
 		&xfs_rmapbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_REFCBT, "refcntbt", handle_struct, refcbt_crc_hfld,
+		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
 		&xfs_dir3_db_buf_ops, TYP_F_NO_CRC_OFF },
diff --git a/db/type.h b/db/type.h
index b5a21a7..87ff107 100644
--- a/db/type.h
+++ b/db/type.h
@@ -24,7 +24,7 @@ struct field;
 typedef enum typnm
 {
 	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
-	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_DATA,
+	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_REFCBT, TYP_DATA,
 	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
 	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
 	TYP_TEXT, TYP_FINOBT, TYP_NONE
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 8056b30..460d89d 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -699,8 +699,8 @@ If no argument is given, show the current data type.
 The possible data types are:
 .BR agf ", " agfl ", " agi ", " attr ", " bmapbta ", " bmapbtd ,
 .BR bnobt ", " cntbt ", " data ", " dir ", " dir2 ", " dqblk ,
-.BR inobt ", " inode ", " log ", " rmapbt ", " rtbitmap ", " rtsummary ,
-.BR sb ", " symlink " and " text .
+.BR inobt ", " inode ", " log ", " refcntbt ", " rmapbt ", " rtbitmap ,
+.BR rtsummary ", " sb ", " symlink " and " text .
 See the TYPES section below for more information on these data types.
 .TP
 .BI "uuid [" uuid " | " generate " | " rewrite " | " restore ]
@@ -1684,6 +1684,49 @@ use
 .BR xfs_logprint (8)
 instead.
 .TP
+.B refcntbt
+There is one set of filesystem blocks forming the reference count Btree for
+each allocation group. The root block of this Btree is designated by the
+.B refcntroot
+field in the corresponding AGF block.  The blocks are linked to sibling left
+and right blocks at each level, as well as by pointers from parent to child
+blocks.  Each block has the following fields:
+.RS 1.4i
+.PD 0
+.TP 1.2i
+.B magic
+REFC block magic number, 0x52334643 ('R3FC').
+.TP
+.B level
+level number of this block, 0 is a leaf.
+.TP
+.B numrecs
+number of data entries in the block.
+.TP
+.B leftsib
+left (logically lower) sibling block, 0 if none.
+.TP
+.B rightsib
+right (logically higher) sibling block, 0 if none.
+.TP
+.B recs
+[leaf blocks only] array of reference count records. Each record contains
+.BR startblock ,
+.BR blockcount ,
+and
+.BR refcount .
+.TP
+.B keys
+[non-leaf blocks only] array of key records. These are the first value
+of each block in the level below this one. Each record contains
+.BR startblock .
+.TP
+.B ptrs
+[non-leaf blocks only] array of child block pointers. Each pointer is a
+block number within the allocation group to the next level in the Btree.
+.PD
+.RE
+.TP
 .B rmapbt
 There is one set of filesystem blocks forming the reverse mapping Btree for
 each allocation group. The root block of this Btree is designated by the

