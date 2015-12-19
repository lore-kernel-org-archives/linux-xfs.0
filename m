Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 97D3E29E1D
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:07:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87EC930404E
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:16 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id qe3FDEGdgH1DTJ9f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:14 -0800 (PST)
Subject: [PATCH 21/53] xfs_dump: display enhanced rmapbt fields
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:07:11 -0800
Message-ID: <20151219090711.14255.27847.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Decode the extra fields in the rmapbt records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/agf.c     |    2 +-
 db/btblock.c |   24 +++++++++++++++++++++---
 db/field.c   |   10 ++++++++++
 db/field.h   |    5 +++++
 db/type.c    |    2 ++
 5 files changed, 39 insertions(+), 4 deletions(-)


diff --git a/db/agf.c b/db/agf.c
index ffdd550..f4c4269 100644
--- a/db/agf.c
+++ b/db/agf.c
@@ -55,7 +55,7 @@ const field_t	agf_flds[] = {
 	{ "cntroot", FLDT_AGBLOCK,
 	  OI(OFF(roots) + XFS_BTNUM_CNT * SZ(roots[XFS_BTNUM_CNT])), C1, 0,
 	  TYP_CNTBT },
-	{ "rmaproot", FLDT_AGBLOCK,
+	{ "rmaproot", FLDT_AGBLOCKNZ,
 	  OI(OFF(roots) + XFS_BTNUM_RMAP * SZ(roots[XFS_BTNUM_RMAP])), C1, 0,
 	  TYP_RMAPBT },
 	{ "levels", FLDT_UINT32D, OI(OFF(levels)), CI(XFS_BTNUM_AGF),
diff --git a/db/btblock.c b/db/btblock.c
index e45ee03..430d84f 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -645,15 +645,33 @@ const field_t	rmapbt_crc_flds[] = {
 #define	KOFF(f)	bitize(offsetof(struct xfs_rmap_key, rm_ ## f))
 const field_t	rmapbt_key_flds[] = {
 	{ "startblock", FLDT_AGBLOCK, OI(KOFF(startblock)), C1, 0, TYP_DATA },
+	{ "owner", FLDT_INT64D, OI(KOFF(owner)), C1, 0, TYP_NONE },
+	{ "offset", FLDT_CFILEOFFD, OI(KOFF(offset)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 #undef KOFF
 
 #define	ROFF(f)	bitize(offsetof(struct xfs_rmap_rec, rm_ ## f))
+
+#define RMAPBT_STARTBLOCK_BITOFF	0
+#define RMAPBT_EXNTFLAG_BITOFF		(RMAPBT_STARTBLOCK_BITOFF + RMAPBT_STARTBLOCK_BITLEN)
+#define RMAPBT_BLOCKCOUNT_BITOFF	(RMAPBT_EXNTFLAG_BITOFF + RMAPBT_EXNTFLAG_BITLEN)
+#define RMAPBT_OWNER_BITOFF		(RMAPBT_BLOCKCOUNT_BITOFF + RMAPBT_BLOCKCOUNT_BITLEN)
+#define RMAPBT_ATTRFLAG_BITOFF		(RMAPBT_OWNER_BITOFF + RMAPBT_OWNER_BITLEN)
+#define RMAPBT_BMBTFLAG_BITOFF		(RMAPBT_ATTRFLAG_BITOFF + RMAPBT_ATTRFLAG_BITLEN)
+#define RMAPBT_OFFSET_BITOFF		(RMAPBT_BMBTFLAG_BITOFF + RMAPBT_BMBTFLAG_BITLEN)
+
 const field_t	rmapbt_rec_flds[] = {
-	{ "startblock", FLDT_AGBLOCK, OI(ROFF(startblock)), C1, 0, TYP_DATA },
-	{ "blockcount", FLDT_EXTLEN, OI(ROFF(blockcount)), C1, 0, TYP_NONE },
-	{ "owner", FLDT_UINT64X, OI(ROFF(owner)), C1, 0, TYP_NONE },
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
 	{ NULL }
 };
 #undef ROFF
diff --git a/db/field.c b/db/field.c
index 8298f29..5664b95 100644
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
diff --git a/db/field.h b/db/field.h
index 82701bb..47f562a 100644
--- a/db/field.h
+++ b/db/field.h
@@ -75,6 +75,11 @@ typedef enum fldt	{
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
diff --git a/db/type.c b/db/type.c
index 38372b8..f78290e 100644
--- a/db/type.c
+++ b/db/type.c
@@ -127,6 +127,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_allocbt_buf_ops },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld,
 		&xfs_allocbt_buf_ops },
+	{ TYP_RMAPBT, "rmapbt", handle_struct, rmapbt_crc_hfld,
+		&xfs_rmapbt_buf_ops },
 	{ TYP_DATA, "data", handle_block, NULL, NULL },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
 		&xfs_dir3_db_buf_ops },

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
