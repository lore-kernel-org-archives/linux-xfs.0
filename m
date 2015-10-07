Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1864029E98
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:07:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 090E68F8035
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:07:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id YqDCfHvGi6d2TUwv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:07:31 -0700 (PDT)
Subject: [PATCH 21/51] xfs_dump: display enhanced rmapbt fields
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:07:28 -0700
Message-ID: <20151007050728.1504.72828.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
 db/agf.c           |    2 +-
 db/btblock.c       |   24 +++++++++++++++++++++---
 db/field.c         |   10 ++++++++++
 db/field.h         |    5 +++++
 libxfs/xfs_alloc.c |    3 ++-
 5 files changed, 39 insertions(+), 5 deletions(-)


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
index 8298f29..850cedb 100644
--- a/db/field.c
+++ b/db/field.c
@@ -153,6 +153,16 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_CHARNS, "charns", fp_charns, NULL, SI(bitsz(char)), 0, NULL,
 	  NULL },
 	{ FLDT_CHARS, "chars", fp_num, "%c", SI(bitsz(char)), 0, NULL, NULL },
+	{ FLDT_REXTLEN, "rextlen", fp_num, "%llu", SI(RMAPBT_BLOCKCOUNT_BITLEN),
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
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 21cb9a1..d7f8302 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1681,6 +1681,8 @@ xfs_free_ag_extent(
 	xfs_extlen_t	nlen;		/* new length of freespace */
 	xfs_perag_t	*pag;		/* per allocation group data */
 
+	bno_cur = cnt_cur = NULL;
+
 	if (oinfo->oi_owner) {
 		error = xfs_rmap_free(tp, agbp, agno, bno, len, oinfo);
 		if (error)
@@ -1692,7 +1694,6 @@ xfs_free_ag_extent(
 	 * Allocate and initialize a cursor for the by-block btree.
 	 */
 	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO);
-	cnt_cur = NULL;
 	/*
 	 * Look for a neighboring block on the left (lower block numbers)
 	 * that is contiguous with this space.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
