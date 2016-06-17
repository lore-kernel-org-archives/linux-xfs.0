Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 01F9981BD
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:36:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CECEF304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:36:11 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id AjAK14nA6cKtusyQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:36:09 -0700 (PDT)
Subject: [PATCH 050/145] xfs_db: display rmap btree contents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:36:01 -0700
Message-ID: <146612736121.16048.14772876071545022810.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Teach the debugger how to dump the reverse-mapping btree contents.
Decode the extra fields in the rmapbt records and keys now that we
support reflink.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: split patch, add commit message, decode extra fields]
[darrick: support overlapped interval btree fields]
[darrick: move unwritten bit to rm_offset]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/agf.c          |    6 +++
 db/btblock.c      |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/btblock.h      |    5 +++
 db/field.c        |   19 ++++++++++
 db/field.h        |    9 +++++
 db/type.c         |    5 +++
 db/type.h         |    2 +
 man/man8/xfs_db.8 |   56 +++++++++++++++++++++++++++++-
 8 files changed, 200 insertions(+), 2 deletions(-)


diff --git a/db/agf.c b/db/agf.c
index e10526d..f4c4269 100644
--- a/db/agf.c
+++ b/db/agf.c
@@ -55,6 +55,9 @@ const field_t	agf_flds[] = {
 	{ "cntroot", FLDT_AGBLOCK,
 	  OI(OFF(roots) + XFS_BTNUM_CNT * SZ(roots[XFS_BTNUM_CNT])), C1, 0,
 	  TYP_CNTBT },
+	{ "rmaproot", FLDT_AGBLOCKNZ,
+	  OI(OFF(roots) + XFS_BTNUM_RMAP * SZ(roots[XFS_BTNUM_RMAP])), C1, 0,
+	  TYP_RMAPBT },
 	{ "levels", FLDT_UINT32D, OI(OFF(levels)), CI(XFS_BTNUM_AGF),
 	  FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
 	{ "bnolevel", FLDT_UINT32D,
@@ -63,6 +66,9 @@ const field_t	agf_flds[] = {
 	{ "cntlevel", FLDT_UINT32D,
 	  OI(OFF(levels) + XFS_BTNUM_CNT * SZ(levels[XFS_BTNUM_CNT])), C1, 0,
 	  TYP_NONE },
+	{ "rmaplevel", FLDT_UINT32D,
+	  OI(OFF(levels) + XFS_BTNUM_RMAP * SZ(levels[XFS_BTNUM_RMAP])), C1, 0,
+	  TYP_NONE },
 	{ "flfirst", FLDT_UINT32D, OI(OFF(flfirst)), C1, 0, TYP_NONE },
 	{ "fllast", FLDT_UINT32D, OI(OFF(fllast)), C1, 0, TYP_NONE },
 	{ "flcount", FLDT_UINT32D, OI(OFF(flcount)), C1, 0, TYP_NONE },
diff --git a/db/btblock.c b/db/btblock.c
index 46140fc..ce59d18 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -96,6 +96,12 @@ struct xfs_db_btree {
 		sizeof(xfs_inobt_rec_t),
 		sizeof(__be32),
 	},
+	{	XFS_RMAP_CRC_MAGIC,
+		XFS_BTREE_SBLOCK_CRC_LEN,
+		2 * sizeof(struct xfs_rmap_key),
+		sizeof(struct xfs_rmap_rec),
+		sizeof(__be32),
+	},
 	{	0,
 	},
 };
@@ -607,3 +613,97 @@ const field_t	cntbt_rec_flds[] = {
 	{ NULL }
 };
 #undef ROFF
+
+/* RMAP btree blocks */
+const field_t	rmapbt_crc_hfld[] = {
+	{ "", FLDT_RMAPBT_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(struct xfs_btree_block, bb_ ## f))
+const field_t	rmapbt_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_RMAPBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_RMAPBT },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.s.bb_blkno)), C1, 0, TYP_RMAPBT },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_RMAPBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_RMAPBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_RMAPBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_RMAPBT },
+	{ NULL }
+};
+#undef OFF
+
+#define	KOFF(f)	bitize(offsetof(struct xfs_rmap_key, rm_ ## f))
+
+#define RMAPBK_STARTBLOCK_BITOFF	0
+#define RMAPBK_OWNER_BITOFF		(RMAPBK_STARTBLOCK_BITOFF + RMAPBT_STARTBLOCK_BITLEN)
+#define RMAPBK_ATTRFLAG_BITOFF		(RMAPBK_OWNER_BITOFF + RMAPBT_OWNER_BITLEN)
+#define RMAPBK_BMBTFLAG_BITOFF		(RMAPBK_ATTRFLAG_BITOFF + RMAPBT_ATTRFLAG_BITLEN)
+#define RMAPBK_EXNTFLAG_BITOFF		(RMAPBK_BMBTFLAG_BITOFF + RMAPBT_BMBTFLAG_BITLEN)
+#define RMAPBK_UNUSED_OFFSET_BITOFF	(RMAPBK_EXNTFLAG_BITOFF + RMAPBT_EXNTFLAG_BITLEN)
+#define RMAPBK_OFFSET_BITOFF		(RMAPBK_UNUSED_OFFSET_BITOFF + RMAPBT_UNUSED_OFFSET_BITLEN)
+
+#define HI_KOFF(f)	bitize(sizeof(struct xfs_rmap_key) + offsetof(struct xfs_rmap_key, rm_ ## f))
+
+#define RMAPBK_STARTBLOCKHI_BITOFF	(bitize(sizeof(struct xfs_rmap_key)))
+#define RMAPBK_OWNERHI_BITOFF		(RMAPBK_STARTBLOCKHI_BITOFF + RMAPBT_STARTBLOCK_BITLEN)
+#define RMAPBK_ATTRFLAGHI_BITOFF	(RMAPBK_OWNERHI_BITOFF + RMAPBT_OWNER_BITLEN)
+#define RMAPBK_BMBTFLAGHI_BITOFF	(RMAPBK_ATTRFLAGHI_BITOFF + RMAPBT_ATTRFLAG_BITLEN)
+#define RMAPBK_EXNTFLAGHI_BITOFF	(RMAPBK_BMBTFLAGHI_BITOFF + RMAPBT_BMBTFLAG_BITLEN)
+#define RMAPBK_UNUSED_OFFSETHI_BITOFF	(RMAPBK_EXNTFLAGHI_BITOFF + RMAPBT_EXNTFLAG_BITLEN)
+#define RMAPBK_OFFSETHI_BITOFF		(RMAPBK_UNUSED_OFFSETHI_BITOFF + RMAPBT_UNUSED_OFFSET_BITLEN)
+
+const field_t	rmapbt_key_flds[] = {
+	{ "startblock", FLDT_AGBLOCK, OI(KOFF(startblock)), C1, 0, TYP_DATA },
+	{ "owner", FLDT_INT64D, OI(KOFF(owner)), C1, 0, TYP_NONE },
+	{ "offset", FLDT_RFILEOFFD, OI(RMAPBK_OFFSET_BITOFF), C1, 0, TYP_NONE },
+	{ "attrfork", FLDT_RATTRFORKFLG, OI(RMAPBK_ATTRFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "bmbtblock", FLDT_RBMBTFLG, OI(RMAPBK_BMBTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "startblock_hi", FLDT_AGBLOCK, OI(HI_KOFF(startblock)), C1, 0, TYP_DATA },
+	{ "owner_hi", FLDT_INT64D, OI(HI_KOFF(owner)), C1, 0, TYP_NONE },
+	{ "offset_hi", FLDT_RFILEOFFD, OI(RMAPBK_OFFSETHI_BITOFF), C1, 0, TYP_NONE },
+	{ "attrfork_hi", FLDT_RATTRFORKFLG, OI(RMAPBK_ATTRFLAGHI_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "bmbtblock_hi", FLDT_RBMBTFLG, OI(RMAPBK_BMBTFLAGHI_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ NULL }
+};
+#undef HI_KOFF
+#undef KOFF
+
+#define	ROFF(f)	bitize(offsetof(struct xfs_rmap_rec, rm_ ## f))
+
+#define RMAPBT_STARTBLOCK_BITOFF	0
+#define RMAPBT_BLOCKCOUNT_BITOFF	(RMAPBT_STARTBLOCK_BITOFF + RMAPBT_STARTBLOCK_BITLEN)
+#define RMAPBT_OWNER_BITOFF		(RMAPBT_BLOCKCOUNT_BITOFF + RMAPBT_BLOCKCOUNT_BITLEN)
+#define RMAPBT_ATTRFLAG_BITOFF		(RMAPBT_OWNER_BITOFF + RMAPBT_OWNER_BITLEN)
+#define RMAPBT_BMBTFLAG_BITOFF		(RMAPBT_ATTRFLAG_BITOFF + RMAPBT_ATTRFLAG_BITLEN)
+#define RMAPBT_EXNTFLAG_BITOFF		(RMAPBT_BMBTFLAG_BITOFF + RMAPBT_BMBTFLAG_BITLEN)
+#define RMAPBT_UNUSED_OFFSET_BITOFF	(RMAPBT_EXNTFLAG_BITOFF + RMAPBT_EXNTFLAG_BITLEN)
+#define RMAPBT_OFFSET_BITOFF		(RMAPBT_UNUSED_OFFSET_BITOFF + RMAPBT_UNUSED_OFFSET_BITLEN)
+
+const field_t	rmapbt_rec_flds[] = {
+	{ "startblock", FLDT_AGBLOCK, OI(RMAPBT_STARTBLOCK_BITOFF), C1, 0, TYP_DATA },
+	{ "blockcount", FLDT_REXTLEN, OI(RMAPBT_BLOCKCOUNT_BITOFF), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INT64D, OI(RMAPBT_OWNER_BITOFF), C1, 0, TYP_NONE },
+	{ "offset", FLDT_RFILEOFFD, OI(RMAPBT_OFFSET_BITOFF), C1, 0, TYP_NONE },
+	{ "extentflag", FLDT_REXTFLG, OI(RMAPBT_EXNTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "attrfork", FLDT_RATTRFORKFLG, OI(RMAPBT_ATTRFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "bmbtblock", FLDT_RBMBTFLG, OI(RMAPBT_BMBTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ NULL }
+};
+#undef ROFF
diff --git a/db/btblock.h b/db/btblock.h
index 228eb36..35299b4 100644
--- a/db/btblock.h
+++ b/db/btblock.h
@@ -54,4 +54,9 @@ extern const struct field	cntbt_crc_hfld[];
 extern const struct field	cntbt_key_flds[];
 extern const struct field	cntbt_rec_flds[];
 
+extern const struct field	rmapbt_crc_flds[];
+extern const struct field	rmapbt_crc_hfld[];
+extern const struct field	rmapbt_key_flds[];
+extern const struct field	rmapbt_rec_flds[];
+
 extern int	btblock_size(void *obj, int startoff, int idx);
diff --git a/db/field.c b/db/field.c
index 843c385..58728a9 100644
--- a/db/field.c
+++ b/db/field.c
@@ -153,6 +153,16 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_CHARNS, "charns", fp_charns, NULL, SI(bitsz(char)), 0, NULL,
 	  NULL },
 	{ FLDT_CHARS, "chars", fp_num, "%c", SI(bitsz(char)), 0, NULL, NULL },
+	{ FLDT_REXTLEN, "rextlen", fp_num, "%u", SI(RMAPBT_BLOCKCOUNT_BITLEN),
+	  0, NULL, NULL },
+	{ FLDT_RFILEOFFD, "rfileoffd", fp_num, "%llu", SI(RMAPBT_OFFSET_BITLEN),
+	  0, NULL, NULL },
+	{ FLDT_REXTFLG, "rextflag", fp_num, "%u", SI(RMAPBT_EXNTFLAG_BITLEN), 0,
+	  NULL, NULL },
+	{ FLDT_RATTRFORKFLG, "rattrforkflag", fp_num, "%u", SI(RMAPBT_ATTRFLAG_BITLEN), 0,
+	  NULL, NULL },
+	{ FLDT_RBMBTFLG, "rbmbtflag", fp_num, "%u", SI(RMAPBT_BMBTFLAG_BITLEN), 0,
+	  NULL, NULL },
 	{ FLDT_CNTBT, "cntbt", NULL, (char *)cntbt_flds, btblock_size, FTARG_SIZE,
 	  NULL, cntbt_flds },
 	{ FLDT_CNTBT_CRC, "cntbt", NULL, (char *)cntbt_crc_flds, btblock_size,
@@ -164,6 +174,15 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_CNTBTREC, "cntbtrec", fp_sarray, (char *)cntbt_rec_flds,
 	  SI(bitsz(xfs_alloc_rec_t)), 0, NULL, cntbt_rec_flds },
 
+	{ FLDT_RMAPBT_CRC, "rmapbt", NULL, (char *)rmapbt_crc_flds, btblock_size,
+	  FTARG_SIZE, NULL, rmapbt_crc_flds },
+	{ FLDT_RMAPBTKEY, "rmapbtkey", fp_sarray, (char *)rmapbt_key_flds,
+	  SI(bitize(2 * sizeof(struct xfs_rmap_key))), 0, NULL, rmapbt_key_flds },
+	{ FLDT_RMAPBTPTR, "rmapbtptr", fp_num, "%u",
+	  SI(bitsz(xfs_rmap_ptr_t)), 0, fa_agblock, NULL },
+	{ FLDT_RMAPBTREC, "rmapbtrec", fp_sarray, (char *)rmapbt_rec_flds,
+	  SI(bitsz(struct xfs_rmap_rec)), 0, NULL, rmapbt_rec_flds },
+
 /* CRC field */
 	{ FLDT_CRC, "crc", fp_crc, "%#x (%s)", SI(bitsz(__uint32_t)),
 	  0, NULL, NULL },
diff --git a/db/field.h b/db/field.h
index 11aebc3..47f562a 100644
--- a/db/field.h
+++ b/db/field.h
@@ -75,11 +75,20 @@ typedef enum fldt	{
 	FLDT_CFSBLOCK,
 	FLDT_CHARNS,
 	FLDT_CHARS,
+	FLDT_REXTLEN,
+	FLDT_RFILEOFFD,
+	FLDT_REXTFLG,
+	FLDT_RATTRFORKFLG,
+	FLDT_RBMBTFLG,
 	FLDT_CNTBT,
 	FLDT_CNTBT_CRC,
 	FLDT_CNTBTKEY,
 	FLDT_CNTBTPTR,
 	FLDT_CNTBTREC,
+	FLDT_RMAPBT_CRC,
+	FLDT_RMAPBTKEY,
+	FLDT_RMAPBTPTR,
+	FLDT_RMAPBTREC,
 
 	/* CRC field type */
 	FLDT_CRC,
diff --git a/db/type.c b/db/type.c
index 1da7ee1..dd192a1 100644
--- a/db/type.c
+++ b/db/type.c
@@ -58,6 +58,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_hfld, NULL },
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld, NULL },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld, NULL },
+	{ TYP_RMAPBT, NULL },
 	{ TYP_DATA, "data", handle_block, NULL, NULL },
 	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld, NULL },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld, NULL },
@@ -88,6 +89,8 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_allocbt_buf_ops },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld,
 		&xfs_allocbt_buf_ops },
+	{ TYP_RMAPBT, "rmapbt", handle_struct, rmapbt_crc_hfld,
+		&xfs_rmapbt_buf_ops },
 	{ TYP_DATA, "data", handle_block, NULL, NULL },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
 		&xfs_dir3_db_buf_ops },
@@ -124,6 +127,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_allocbt_buf_ops },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld,
 		&xfs_allocbt_buf_ops },
+	{ TYP_RMAPBT, "rmapbt", handle_struct, rmapbt_crc_hfld,
+		&xfs_rmapbt_buf_ops },
 	{ TYP_DATA, "data", handle_block, NULL, NULL },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
 		&xfs_dir3_db_buf_ops },
diff --git a/db/type.h b/db/type.h
index d9583e5..1bef8e6 100644
--- a/db/type.h
+++ b/db/type.h
@@ -24,7 +24,7 @@ struct field;
 typedef enum typnm
 {
 	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
-	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_DATA,
+	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_DATA,
 	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
 	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
 	TYP_TEXT, TYP_FINOBT, TYP_NONE
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index ff8f862..a380f78 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -673,7 +673,7 @@ If no argument is given, show the current data type.
 The possible data types are:
 .BR agf ", " agfl ", " agi ", " attr ", " bmapbta ", " bmapbtd ,
 .BR bnobt ", " cntbt ", " data ", " dir ", " dir2 ", " dqblk ,
-.BR inobt ", " inode ", " log ", " rtbitmap ", " rtsummary ,
+.BR inobt ", " inode ", " log ", " rmapbt ", " rtbitmap ", " rtsummary ,
 .BR sb ", " symlink " and " text .
 See the TYPES section below for more information on these data types.
 .TP
@@ -1658,6 +1658,60 @@ use
 .BR xfs_logprint (8)
 instead.
 .TP
+.B rmapbt
+There is one set of filesystem blocks forming the reverse mapping Btree for
+each allocation group. The root block of this Btree is designated by the
+.B rmaproot
+field in the corresponding AGF block.  The blocks are linked to sibling left
+and right blocks at each level, as well as by pointers from parent to child
+blocks.  Each block has the following fields:
+.RS 1.4i
+.PD 0
+.TP 1.2i
+.B magic
+RMAP block magic number, 0x524d4233 ('RMB3').
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
+.BR owner ,
+.BR offset ,
+.BR attr_fork ,
+.BR bmbt_block ,
+and
+.BR unwritten .
+.TP
+.B keys
+[non-leaf blocks only] array of double-key records. The first ("low") key
+contains the first value of each block in the level below this one. The second
+("high") key contains the largest key that can be used to identify any record
+in the subtree. Each record contains
+.BR startblock ,
+.BR owner ,
+.BR offset ,
+.BR attr_fork ,
+and
+.BR bmbt_block .
+.TP
+.B ptrs
+[non-leaf blocks only] array of child block pointers. Each pointer is a
+block number within the allocation group to the next level in the Btree.
+.PD
+.RE
+.TP
 .B rtbitmap
 If the filesystem has a realtime subvolume, then the
 .B rbmino

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
