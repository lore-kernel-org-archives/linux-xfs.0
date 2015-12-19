Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BEBFA29E08
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:07:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0454304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:10 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mMfLIobwDWES9mtw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:08 -0800 (PST)
Subject: [PATCH 20/53] xfs_db: display rmap btree contents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:07:05 -0800
Message-ID: <20151219090705.14255.90435.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

>From : Dave Chinner <david@fromorbit.com>

Teach the debugger how to dump the reverse-mapping btree contents.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[split patch, add commit message]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/agf.c     |    6 ++++++
 db/btblock.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 db/btblock.h |    5 +++++
 db/field.c   |    9 +++++++++
 db/field.h   |    4 ++++
 db/type.c    |    3 +++
 db/type.h    |    2 +-
 7 files changed, 78 insertions(+), 1 deletion(-)


diff --git a/db/agf.c b/db/agf.c
index e10526d..ffdd550 100644
--- a/db/agf.c
+++ b/db/agf.c
@@ -55,6 +55,9 @@ const field_t	agf_flds[] = {
 	{ "cntroot", FLDT_AGBLOCK,
 	  OI(OFF(roots) + XFS_BTNUM_CNT * SZ(roots[XFS_BTNUM_CNT])), C1, 0,
 	  TYP_CNTBT },
+	{ "rmaproot", FLDT_AGBLOCK,
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
index 46140fc..e45ee03 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -96,6 +96,12 @@ struct xfs_db_btree {
 		sizeof(xfs_inobt_rec_t),
 		sizeof(__be32),
 	},
+	{	XFS_RMAP_CRC_MAGIC,
+		XFS_BTREE_SBLOCK_CRC_LEN,
+		sizeof(struct xfs_rmap_key),
+		sizeof(struct xfs_rmap_rec),
+		sizeof(__be32),
+	},
 	{	0,
 	},
 };
@@ -607,3 +613,47 @@ const field_t	cntbt_rec_flds[] = {
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
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.s.bb_blkno)), C1, 0, TYP_CNTBT },
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
+const field_t	rmapbt_key_flds[] = {
+	{ "startblock", FLDT_AGBLOCK, OI(KOFF(startblock)), C1, 0, TYP_DATA },
+	{ NULL }
+};
+#undef KOFF
+
+#define	ROFF(f)	bitize(offsetof(struct xfs_rmap_rec, rm_ ## f))
+const field_t	rmapbt_rec_flds[] = {
+	{ "startblock", FLDT_AGBLOCK, OI(ROFF(startblock)), C1, 0, TYP_DATA },
+	{ "blockcount", FLDT_EXTLEN, OI(ROFF(blockcount)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_UINT64X, OI(ROFF(owner)), C1, 0, TYP_NONE },
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
index 843c385..8298f29 100644
--- a/db/field.c
+++ b/db/field.c
@@ -164,6 +164,15 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_CNTBTREC, "cntbtrec", fp_sarray, (char *)cntbt_rec_flds,
 	  SI(bitsz(xfs_alloc_rec_t)), 0, NULL, cntbt_rec_flds },
 
+	{ FLDT_RMAPBT_CRC, "rmapbt", NULL, (char *)rmapbt_crc_flds, btblock_size,
+	  FTARG_SIZE, NULL, rmapbt_crc_flds },
+	{ FLDT_RMAPBTKEY, "rmapbtkey", fp_sarray, (char *)rmapbt_key_flds,
+	  SI(bitsz(struct xfs_rmap_key)), 0, NULL, rmapbt_key_flds },
+	{ FLDT_RMAPBTPTR, "rmapbtptr", fp_num, "%u",
+	  SI(bitsz(xfs_rmap_ptr_t)), 0, fa_agblock, NULL },
+	{ FLDT_RMAPBTREC, "rmapbtrec", fp_sarray, (char *)rmapbt_rec_flds,
+	  SI(bitsz(struct xfs_rmap_rec)), 0, NULL, rmapbt_rec_flds },
+
 /* CRC field */
 	{ FLDT_CRC, "crc", fp_crc, "%#x (%s)", SI(bitsz(__uint32_t)),
 	  0, NULL, NULL },
diff --git a/db/field.h b/db/field.h
index 11aebc3..82701bb 100644
--- a/db/field.h
+++ b/db/field.h
@@ -80,6 +80,10 @@ typedef enum fldt	{
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
index 1da7ee1..38372b8 100644
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
