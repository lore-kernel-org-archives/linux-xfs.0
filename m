Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1DDF58445
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:00:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D58E6304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:24 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id jvG10u4FOeNAJY7X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:22 -0700 (PDT)
Subject: [PATCH 16/29] xfs_db: display the realtime rmap btree contents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:00:17 -0700
Message-ID: <147216961770.7022.4301373430070142149.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Implement all the code we need to dump rtrmapbt contents, starting
from the root inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/bmroot.c              |  149 ++++++++++++++++++++++++++++++++++++++++++++++
 db/bmroot.h              |    2 +
 db/btblock.c             |  100 +++++++++++++++++++++++++++++++
 db/btblock.h             |    5 ++
 db/field.c               |   13 ++++
 db/field.h               |    6 ++
 db/inode.c               |   18 +++++-
 db/sb.c                  |    1 
 db/type.c                |    5 ++
 db/type.h                |    8 +-
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_db.8        |   60 ++++++++++++++++++-
 12 files changed, 362 insertions(+), 6 deletions(-)


diff --git a/db/bmroot.c b/db/bmroot.c
index 7697e61..8ad3637 100644
--- a/db/bmroot.c
+++ b/db/bmroot.c
@@ -36,6 +36,13 @@ static int	bmrootd_key_offset(void *obj, int startoff, int idx);
 static int	bmrootd_ptr_count(void *obj, int startoff);
 static int	bmrootd_ptr_offset(void *obj, int startoff, int idx);
 
+static int	rtrmaproot_rec_count(void *obj, int startoff);
+static int	rtrmaproot_rec_offset(void *obj, int startoff, int idx);
+static int	rtrmaproot_key_count(void *obj, int startoff);
+static int	rtrmaproot_key_offset(void *obj, int startoff, int idx);
+static int	rtrmaproot_ptr_count(void *obj, int startoff);
+static int	rtrmaproot_ptr_offset(void *obj, int startoff, int idx);
+
 #define	OFF(f)	bitize(offsetof(xfs_bmdr_block_t, bb_ ## f))
 const field_t	bmroota_flds[] = {
 	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
@@ -66,6 +73,20 @@ const field_t	bmrootd_key_flds[] = {
 	{ NULL }
 };
 
+/* realtime rmap btree root */
+const field_t	rtrmaproot_flds[] = {
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_RTRMAPBTREC, rtrmaproot_rec_offset, rtrmaproot_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_RTRMAPBTKEY, rtrmaproot_key_offset, rtrmaproot_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_RTRMAPBTPTR, rtrmaproot_ptr_offset, rtrmaproot_ptr_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_RTRMAPBT },
+	{ NULL }
+};
+#undef OFF
+
 static int
 bmroota_key_count(
 	void			*obj,
@@ -253,3 +274,131 @@ bmrootd_size(
 	dip = obj;
 	return bitize((int)XFS_DFORK_DSIZE(dip, mp));
 }
+
+/* realtime rmap root */
+static int
+rtrmaproot_rec_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_rtrmap_root	*block;
+#ifdef DEBUG
+	struct xfs_dinode	*dip = obj;
+#endif
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
+	ASSERT((char *)block == XFS_DFORK_DPTR(dip));
+	if (be16_to_cpu(block->bb_level) > 0)
+		return 0;
+	return be16_to_cpu(block->bb_numrecs);
+}
+
+static int
+rtrmaproot_rec_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_rtrmap_root	*block;
+	struct xfs_rtrmap_rec	*kp;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
+	ASSERT(be16_to_cpu(block->bb_level) == 0);
+	kp = XFS_RTRMAP_ROOT_REC_ADDR(block, idx);
+	return bitize((int)((char *)kp - (char *)block));
+}
+
+static int
+rtrmaproot_key_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_rtrmap_root	*block;
+#ifdef DEBUG
+	struct xfs_dinode	*dip = obj;
+#endif
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
+	ASSERT((char *)block == XFS_DFORK_DPTR(dip));
+	if (be16_to_cpu(block->bb_level) == 0)
+		return 0;
+	return be16_to_cpu(block->bb_numrecs);
+}
+
+static int
+rtrmaproot_key_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_rtrmap_root	*block;
+	struct xfs_rtrmap_key	*kp;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
+	ASSERT(be16_to_cpu(block->bb_level) > 0);
+	kp = XFS_RTRMAP_ROOT_KEY_ADDR(block, idx);
+	return bitize((int)((char *)kp - (char *)block));
+}
+
+static int
+rtrmaproot_ptr_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_rtrmap_root	*block;
+#ifdef DEBUG
+	struct xfs_dinode	*dip = obj;
+#endif
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
+	ASSERT((char *)block == XFS_DFORK_DPTR(dip));
+	if (be16_to_cpu(block->bb_level) == 0)
+		return 0;
+	return be16_to_cpu(block->bb_numrecs);
+}
+
+static int
+rtrmaproot_ptr_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_rtrmap_root	*block;
+	xfs_rtrmap_ptr_t	*pp;
+	struct xfs_dinode	*dip;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	dip = obj;
+	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
+	ASSERT(be16_to_cpu(block->bb_level) > 0);
+	pp = XFS_RTRMAP_ROOT_PTR_ADDR(block, idx,
+			libxfs_rtrmapbt_maxrecs(mp, XFS_DFORK_DSIZE(dip, mp),
+				0));
+	return bitize((int)((char *)pp - (char *)block));
+}
+
+int
+rtrmaproot_size(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_dinode	*dip;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	ASSERT(idx == 0);
+	dip = obj;
+	return bitize((int)XFS_DFORK_DSIZE(dip, mp));
+}
diff --git a/db/bmroot.h b/db/bmroot.h
index 4cb4d23..6e105a7 100644
--- a/db/bmroot.h
+++ b/db/bmroot.h
@@ -20,6 +20,8 @@ extern const struct field	bmroota_flds[];
 extern const struct field	bmroota_key_flds[];
 extern const struct field	bmrootd_flds[];
 extern const struct field	bmrootd_key_flds[];
+extern const struct field	rtrmaproot_flds[];
 
 extern int	bmroota_size(void *obj, int startoff, int idx);
 extern int	bmrootd_size(void *obj, int startoff, int idx);
+extern int	rtrmaproot_size(void *obj, int startoff, int idx);
diff --git a/db/btblock.c b/db/btblock.c
index e0c896b..39037a2 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -102,6 +102,12 @@ struct xfs_db_btree {
 		sizeof(struct xfs_rmap_rec),
 		sizeof(__be32),
 	},
+	{	XFS_RTRMAP_CRC_MAGIC,
+		XFS_BTREE_LBLOCK_CRC_LEN,
+		2 * sizeof(struct xfs_rtrmap_key),
+		sizeof(struct xfs_rtrmap_rec),
+		sizeof(__be64),
+	},
 	{	XFS_REFC_CRC_MAGIC,
 		XFS_BTREE_SBLOCK_CRC_LEN,
 		sizeof(struct xfs_refcount_key),
@@ -714,6 +720,100 @@ const field_t	rmapbt_rec_flds[] = {
 };
 #undef ROFF
 
+/* realtime RMAP btree blocks */
+const field_t	rtrmapbt_crc_hfld[] = {
+	{ "", FLDT_RTRMAPBT_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(struct xfs_btree_block, bb_ ## f))
+const field_t	rtrmapbt_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_DFSBNO, OI(OFF(u.l.bb_leftsib)), C1, 0, TYP_RTRMAPBT },
+	{ "rightsib", FLDT_DFSBNO, OI(OFF(u.l.bb_rightsib)), C1, 0, TYP_RTRMAPBT },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.l.bb_blkno)), C1, 0, TYP_RTRMAPBT },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.l.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.l.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(u.l.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.l.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_RTRMAPBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_RTRMAPBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_RTRMAPBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_RTRMAPBT },
+	{ NULL }
+};
+#undef OFF
+
+#define	KOFF(f)	bitize(offsetof(struct xfs_rtrmap_key, rm_ ## f))
+
+#define RTRMAPBK_STARTBLOCK_BITOFF	0
+#define RTRMAPBK_OWNER_BITOFF		(RTRMAPBK_STARTBLOCK_BITOFF + RTRMAPBT_STARTBLOCK_BITLEN)
+#define RTRMAPBK_ATTRFLAG_BITOFF	(RTRMAPBK_OWNER_BITOFF + RTRMAPBT_OWNER_BITLEN)
+#define RTRMAPBK_BMBTFLAG_BITOFF	(RTRMAPBK_ATTRFLAG_BITOFF + RTRMAPBT_ATTRFLAG_BITLEN)
+#define RTRMAPBK_EXNTFLAG_BITOFF	(RTRMAPBK_BMBTFLAG_BITOFF + RTRMAPBT_BMBTFLAG_BITLEN)
+#define RTRMAPBK_UNUSED_OFFSET_BITOFF	(RTRMAPBK_EXNTFLAG_BITOFF + RTRMAPBT_EXNTFLAG_BITLEN)
+#define RTRMAPBK_OFFSET_BITOFF		(RTRMAPBK_UNUSED_OFFSET_BITOFF + RTRMAPBT_UNUSED_OFFSET_BITLEN)
+
+#define HI_KOFF(f)	bitize(sizeof(struct xfs_rtrmap_key) + offsetof(struct xfs_rtrmap_key, rm_ ## f))
+
+#define RTRMAPBK_STARTBLOCKHI_BITOFF	(bitize(sizeof(struct xfs_rtrmap_key)))
+#define RTRMAPBK_OWNERHI_BITOFF		(RTRMAPBK_STARTBLOCKHI_BITOFF + RTRMAPBT_STARTBLOCK_BITLEN)
+#define RTRMAPBK_ATTRFLAGHI_BITOFF	(RTRMAPBK_OWNERHI_BITOFF + RTRMAPBT_OWNER_BITLEN)
+#define RTRMAPBK_BMBTFLAGHI_BITOFF	(RTRMAPBK_ATTRFLAGHI_BITOFF + RTRMAPBT_ATTRFLAG_BITLEN)
+#define RTRMAPBK_EXNTFLAGHI_BITOFF	(RTRMAPBK_BMBTFLAGHI_BITOFF + RTRMAPBT_BMBTFLAG_BITLEN)
+#define RTRMAPBK_UNUSED_OFFSETHI_BITOFF	(RTRMAPBK_EXNTFLAGHI_BITOFF + RTRMAPBT_EXNTFLAG_BITLEN)
+#define RTRMAPBK_OFFSETHI_BITOFF	(RTRMAPBK_UNUSED_OFFSETHI_BITOFF + RTRMAPBT_UNUSED_OFFSET_BITLEN)
+
+const field_t	rtrmapbt_key_flds[] = {
+	{ "startblock", FLDT_DRTBNO, OI(KOFF(startblock)), C1, 0, TYP_DATA },
+	{ "owner", FLDT_INT64D, OI(KOFF(owner)), C1, 0, TYP_NONE },
+	{ "offset", FLDT_RFILEOFFD, OI(RTRMAPBK_OFFSET_BITOFF), C1, 0, TYP_NONE },
+	{ "attrfork", FLDT_RATTRFORKFLG, OI(RTRMAPBK_ATTRFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "bmbtblock", FLDT_RBMBTFLG, OI(RTRMAPBK_BMBTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "startblock_hi", FLDT_DRTBNO, OI(HI_KOFF(startblock)), C1, 0, TYP_DATA },
+	{ "owner_hi", FLDT_INT64D, OI(HI_KOFF(owner)), C1, 0, TYP_NONE },
+	{ "offset_hi", FLDT_RFILEOFFD, OI(RTRMAPBK_OFFSETHI_BITOFF), C1, 0, TYP_NONE },
+	{ "attrfork_hi", FLDT_RATTRFORKFLG, OI(RTRMAPBK_ATTRFLAGHI_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "bmbtblock_hi", FLDT_RBMBTFLG, OI(RTRMAPBK_BMBTFLAGHI_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ NULL }
+};
+#undef HI_KOFF
+#undef KOFF
+
+#define	ROFF(f)	bitize(offsetof(struct xfs_rtrmap_rec, rm_ ## f))
+
+#define RTRMAPBT_STARTBLOCK_BITOFF	0
+#define RTRMAPBT_BLOCKCOUNT_BITOFF	(RTRMAPBT_STARTBLOCK_BITOFF + RTRMAPBT_STARTBLOCK_BITLEN)
+#define RTRMAPBT_OWNER_BITOFF		(RTRMAPBT_BLOCKCOUNT_BITOFF + RTRMAPBT_BLOCKCOUNT_BITLEN)
+#define RTRMAPBT_ATTRFLAG_BITOFF	(RTRMAPBT_OWNER_BITOFF + RTRMAPBT_OWNER_BITLEN)
+#define RTRMAPBT_BMBTFLAG_BITOFF	(RTRMAPBT_ATTRFLAG_BITOFF + RTRMAPBT_ATTRFLAG_BITLEN)
+#define RTRMAPBT_EXNTFLAG_BITOFF	(RTRMAPBT_BMBTFLAG_BITOFF + RTRMAPBT_BMBTFLAG_BITLEN)
+#define RTRMAPBT_UNUSED_OFFSET_BITOFF	(RTRMAPBT_EXNTFLAG_BITOFF + RTRMAPBT_EXNTFLAG_BITLEN)
+#define RTRMAPBT_OFFSET_BITOFF		(RTRMAPBT_UNUSED_OFFSET_BITOFF + RTRMAPBT_UNUSED_OFFSET_BITLEN)
+
+const field_t	rtrmapbt_rec_flds[] = {
+	{ "startblock", FLDT_DRFSBNO, OI(RTRMAPBT_STARTBLOCK_BITOFF), C1, 0, TYP_DATA },
+	{ "blockcount", FLDT_RTREXTLEN, OI(RTRMAPBT_BLOCKCOUNT_BITOFF), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INT64D, OI(RTRMAPBT_OWNER_BITOFF), C1, 0, TYP_NONE },
+	{ "offset", FLDT_RFILEOFFD, OI(RTRMAPBT_OFFSET_BITOFF), C1, 0, TYP_NONE },
+	{ "extentflag", FLDT_REXTFLG, OI(RTRMAPBT_EXNTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "attrfork", FLDT_RATTRFORKFLG, OI(RTRMAPBT_ATTRFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "bmbtblock", FLDT_RBMBTFLG, OI(RTRMAPBT_BMBTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ NULL }
+};
+#undef ROFF
+
 /* refcount btree blocks */
 const field_t	refcbt_crc_hfld[] = {
 	{ "", FLDT_REFCBT_CRC, OI(0), C1, 0, TYP_NONE },
diff --git a/db/btblock.h b/db/btblock.h
index fead2f1..2c83487 100644
--- a/db/btblock.h
+++ b/db/btblock.h
@@ -59,6 +59,11 @@ extern const struct field	rmapbt_crc_hfld[];
 extern const struct field	rmapbt_key_flds[];
 extern const struct field	rmapbt_rec_flds[];
 
+extern const struct field	rtrmapbt_crc_flds[];
+extern const struct field	rtrmapbt_crc_hfld[];
+extern const struct field	rtrmapbt_key_flds[];
+extern const struct field	rtrmapbt_rec_flds[];
+
 extern const struct field	refcbt_crc_flds[];
 extern const struct field	refcbt_crc_hfld[];
 extern const struct field	refcbt_key_flds[];
diff --git a/db/field.c b/db/field.c
index e0e7066..baac271 100644
--- a/db/field.c
+++ b/db/field.c
@@ -155,6 +155,8 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_CHARS, "chars", fp_num, "%c", SI(bitsz(char)), 0, NULL, NULL },
 	{ FLDT_REXTLEN, "rextlen", fp_num, "%u", SI(RMAPBT_BLOCKCOUNT_BITLEN),
 	  0, NULL, NULL },
+	{ FLDT_RTREXTLEN, "rtrextlen", fp_num, "%llu", SI(bitsz(uint64_t)),
+	  0, NULL, NULL },
 	{ FLDT_RFILEOFFD, "rfileoffd", fp_num, "%llu", SI(RMAPBT_OFFSET_BITLEN),
 	  0, NULL, NULL },
 	{ FLDT_REXTFLG, "rextflag", fp_num, "%u", SI(RMAPBT_EXNTFLAG_BITLEN), 0,
@@ -183,6 +185,17 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_RMAPBTREC, "rmapbtrec", fp_sarray, (char *)rmapbt_rec_flds,
 	  SI(bitsz(struct xfs_rmap_rec)), 0, NULL, rmapbt_rec_flds },
 
+	{ FLDT_RTRMAPBT_CRC, "rtrmapbt", NULL, (char *)rtrmapbt_crc_flds, btblock_size,
+	  FTARG_SIZE, NULL, rtrmapbt_crc_flds },
+	{ FLDT_RTRMAPBTKEY, "rtrmapbtkey", fp_sarray, (char *)rtrmapbt_key_flds,
+	  SI(bitize(2 * sizeof(struct xfs_rtrmap_key))), 0, NULL, rtrmapbt_key_flds },
+	{ FLDT_RTRMAPBTPTR, "rtrmapbtptr", fp_num, "%llu",
+	  SI(bitsz(xfs_rtrmap_ptr_t)), 0, fa_dfsbno, NULL },
+	{ FLDT_RTRMAPBTREC, "rtrmapbtrec", fp_sarray, (char *)rtrmapbt_rec_flds,
+	  SI(bitsz(struct xfs_rtrmap_rec)), 0, NULL, rtrmapbt_rec_flds },
+	{ FLDT_RTRMAPROOT, "rtrmaproot", NULL, (char *)rtrmaproot_flds, rtrmaproot_size,
+	  FTARG_SIZE, NULL, rtrmaproot_flds },
+
 	{ FLDT_REFCBT_CRC, "refcntbt", NULL, (char *)refcbt_crc_flds, btblock_size,
 	  FTARG_SIZE, NULL, refcbt_crc_flds },
 	{ FLDT_REFCBTKEY, "refcntbtkey", fp_sarray, (char *)refcbt_key_flds,
diff --git a/db/field.h b/db/field.h
index ae5f490..4537559 100644
--- a/db/field.h
+++ b/db/field.h
@@ -76,6 +76,7 @@ typedef enum fldt	{
 	FLDT_CHARNS,
 	FLDT_CHARS,
 	FLDT_REXTLEN,
+	FLDT_RTREXTLEN,
 	FLDT_RFILEOFFD,
 	FLDT_REXTFLG,
 	FLDT_RATTRFORKFLG,
@@ -89,6 +90,11 @@ typedef enum fldt	{
 	FLDT_RMAPBTKEY,
 	FLDT_RMAPBTPTR,
 	FLDT_RMAPBTREC,
+	FLDT_RTRMAPBT_CRC,
+	FLDT_RTRMAPBTKEY,
+	FLDT_RTRMAPBTPTR,
+	FLDT_RTRMAPBTREC,
+	FLDT_RTRMAPROOT,
 	FLDT_REFCBT_CRC,
 	FLDT_REFCBTKEY,
 	FLDT_REFCBTPTR,
diff --git a/db/inode.c b/db/inode.c
index cac19fc..70019d8 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -49,6 +49,7 @@ static int	inode_u_muuid_count(void *obj, int startoff);
 static int	inode_u_sfdir2_count(void *obj, int startoff);
 static int	inode_u_sfdir3_count(void *obj, int startoff);
 static int	inode_u_symlink_count(void *obj, int startoff);
+static int	inode_u_rtrmapbt_count(void *obj, int startoff);
 
 static const cmdinfo_t	inode_cmd =
 	{ "inode", NULL, inode_f, 0, 1, 1, "[inode#]",
@@ -204,6 +205,7 @@ const field_t	inode_u_flds[] = {
 	{ "sfdir3", FLDT_DIR3SF, NULL, inode_u_sfdir3_count, FLD_COUNT, TYP_NONE },
 	{ "symlink", FLDT_CHARNS, NULL, inode_u_symlink_count, FLD_COUNT,
 	  TYP_NONE },
+	{ "rtrmapbt", FLDT_RTRMAPROOT, NULL, inode_u_rtrmapbt_count, FLD_COUNT, TYP_NONE },
 	{ NULL }
 };
 
@@ -217,7 +219,7 @@ const field_t	inode_a_flds[] = {
 };
 
 static const char	*dinode_fmt_name[] =
-	{ "dev", "local", "extents", "btree", "uuid" };
+	{ "dev", "local", "extents", "btree", "uuid", "rtrmapbt" };
 static const int	dinode_fmt_name_size =
 	sizeof(dinode_fmt_name) / sizeof(dinode_fmt_name[0]);
 
@@ -585,6 +587,20 @@ inode_u_sfdir3_count(
 	       xfs_sb_version_hasftype(&mp->m_sb);
 }
 
+static int
+inode_u_rtrmapbt_count(
+	void		*obj,
+	int		startoff)
+{
+	xfs_dinode_t	*dip;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	dip = obj;
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_RMAP;
+}
+
 int
 inode_u_size(
 	void		*obj,
diff --git a/db/sb.c b/db/sb.c
index 8e7722c..eb308ad 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -125,6 +125,7 @@ const field_t	sb_flds[] = {
 	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
+	{ "rrmapino", FLDT_INO, OI(OFF(rrmapino)), C1, 0, TYP_INODE },
 	{ NULL }
 };
 
diff --git a/db/type.c b/db/type.c
index 10fa54e..9d74ded 100644
--- a/db/type.c
+++ b/db/type.c
@@ -61,6 +61,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RMAPBT, NULL },
+	{ TYP_RTRMAPBT, NULL },
 	{ TYP_REFCBT, NULL },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld, NULL, TYP_F_NO_CRC_OFF },
@@ -98,6 +99,8 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_allocbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RMAPBT, "rmapbt", handle_struct, rmapbt_crc_hfld,
 		&xfs_rmapbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_RTRMAPBT, "rtrmapbt", handle_struct, rtrmapbt_crc_hfld,
+		&xfs_rtrmapbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_REFCBT, "refcntbt", handle_struct, refcbt_crc_hfld,
 		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
@@ -142,6 +145,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_allocbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RMAPBT, "rmapbt", handle_struct, rmapbt_crc_hfld,
 		&xfs_rmapbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_RTRMAPBT, "rtrmapbt", handle_struct, rtrmapbt_crc_hfld,
+		&xfs_rtrmapbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_REFCBT, "refcntbt", handle_struct, refcbt_crc_hfld,
 		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
diff --git a/db/type.h b/db/type.h
index 87ff107..5a65900 100644
--- a/db/type.h
+++ b/db/type.h
@@ -24,10 +24,10 @@ struct field;
 typedef enum typnm
 {
 	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
-	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_REFCBT, TYP_DATA,
-	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
-	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
-	TYP_TEXT, TYP_FINOBT, TYP_NONE
+	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_RTRMAPBT,
+	TYP_REFCBT, TYP_DATA, TYP_DIR2, TYP_DQBLK, TYP_INOBT,
+	TYP_INODATA, TYP_INODE, TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY,
+	TYP_SB, TYP_SYMLINK, TYP_TEXT, TYP_FINOBT, TYP_NONE
 } typnm_t;
 
 #define DB_WRITE 1
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 8d57a66..c66e31b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -142,5 +142,6 @@
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 #define xfs_refc_block			libxfs_refc_block
+#define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 514e3aa..a9d2c81 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -683,7 +683,7 @@ The possible data types are:
 .BR agf ", " agfl ", " agi ", " attr ", " bmapbta ", " bmapbtd ,
 .BR bnobt ", " cntbt ", " data ", " dir ", " dir2 ", " dqblk ,
 .BR inobt ", " inode ", " log ", " refcntbt ", " rmapbt ", " rtbitmap ,
-.BR rtsummary ", " sb ", " symlink " and " text .
+.BR rtsummary ", " sb ", " symlink ", " rtrmapbt ", and " text .
 See the TYPES section below for more information on these data types.
 .TP
 .BI "uuid [" uuid " | " generate " | " rewrite " | " restore ]
@@ -1764,6 +1764,64 @@ block number within the allocation group to the next level in the Btree.
 .PD
 .RE
 .TP
+.B rtrmapbt
+There is one reverse mapping Btree for the entire realtime device.  The
+.BR startblock " and "
+.B blockcount
+fields are 64 bits wide and record block counts on the realtime device.  The
+root of this Btree is the reverse-mapping inode, which is recorded in the
+superblock
+.B rrmapino
+field.  Blocks are linked to sibling left and right blocks at each level, as
+well as by pointers from parent to child blocks.  Each block has the following
+fields:
+.RS 1.4i
+.PD 0
+.TP 1.2i
+.B magic
+RTRMAP block magic number, 0x4d415052 ('MAPR').
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
