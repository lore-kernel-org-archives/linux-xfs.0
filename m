Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E20238B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYXWkah9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE78C433C7;
	Mon,  1 Jan 2024 00:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068175;
	bh=rY7RJt3suAAogSI03g3v9KhoUp+H/w98o98GLnrZyPQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DYXWkah9HtU5BHzGT0NJX2eesNZAhD9pwGtN3jy4yXhsFixUEc8JpHUqK8JGfsr2B
	 xNkmGXgtGHxF0Zvwp8wRCihq6DY0bxC5Epza0bS1HKRglp38ZFPWzf3+QZCBOaW5qR
	 Cincz5VkMp/LmVF2yI46M0xYx0bttCOprWc/D/CucuQiTmPoKv8wcxgrNtLBuN+xA1
	 VMuqMtehGCtEFtzMQrWLRw6zeLQ/umUlOhhKVzMV7VuI1YsVAmOCS4/5nNwWI0S+rm
	 eQFO34ttkX90MF+8K2fJ3ISvImYFK4c35ZV8FPDG3pv5/R71Zq1uyP/c+xhoaPtbAw
	 uwUkQxwhTxUqQ==
Date: Sun, 31 Dec 2023 16:16:15 +9900
Subject: [PATCH 22/47] xfs_db: display the realtime rmap btree contents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015605.1815505.2804667863138728521.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Implement all the code we need to dump rtrmapbt contents, starting
from the root inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bmroot.c              |  149 ++++++++++++++++++++++++++++++++++++++++++++++
 db/bmroot.h              |    2 +
 db/btblock.c             |  100 +++++++++++++++++++++++++++++++
 db/btblock.h             |    5 ++
 db/field.c               |   11 +++
 db/field.h               |    5 ++
 db/inode.c               |  102 +++++++++++++++++++++++++++++++
 db/inode.h               |    3 +
 db/type.c                |    5 ++
 db/type.h                |    1 
 libxfs/libxfs_api_defs.h |    4 +
 man/man8/xfs_db.8        |   60 ++++++++++++++++++-
 12 files changed, 443 insertions(+), 4 deletions(-)


diff --git a/db/bmroot.c b/db/bmroot.c
index 7ef07da181e..19490bd2499 100644
--- a/db/bmroot.c
+++ b/db/bmroot.c
@@ -24,6 +24,13 @@ static int	bmrootd_key_offset(void *obj, int startoff, int idx);
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
@@ -54,6 +61,20 @@ const field_t	bmrootd_key_flds[] = {
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
@@ -241,3 +262,131 @@ bmrootd_size(
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
+	struct xfs_rmap_rec	*kp;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
+	ASSERT(be16_to_cpu(block->bb_level) == 0);
+	kp = xfs_rtrmap_droot_rec_addr(block, idx);
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
+	struct xfs_rmap_key	*kp;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
+	ASSERT(be16_to_cpu(block->bb_level) > 0);
+	kp = xfs_rtrmap_droot_key_addr(block, idx);
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
+	int			dmxr;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	dip = obj;
+	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
+	ASSERT(be16_to_cpu(block->bb_level) > 0);
+	dmxr = libxfs_rtrmapbt_droot_maxrecs(XFS_DFORK_DSIZE(dip, mp), false);
+	pp = xfs_rtrmap_droot_ptr_addr(block, idx, dmxr);
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
index a1274cf6a94..a2c5cfb18f0 100644
--- a/db/bmroot.h
+++ b/db/bmroot.h
@@ -8,6 +8,8 @@ extern const struct field	bmroota_flds[];
 extern const struct field	bmroota_key_flds[];
 extern const struct field	bmrootd_flds[];
 extern const struct field	bmrootd_key_flds[];
+extern const struct field	rtrmaproot_flds[];
 
 extern int	bmroota_size(void *obj, int startoff, int idx);
 extern int	bmrootd_size(void *obj, int startoff, int idx);
+extern int	rtrmaproot_size(void *obj, int startoff, int idx);
diff --git a/db/btblock.c b/db/btblock.c
index d5be6adb734..5cad166278d 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -92,6 +92,12 @@ static struct xfs_db_btree {
 		sizeof(struct xfs_rmap_rec),
 		sizeof(__be32),
 	},
+	{	XFS_RTRMAP_CRC_MAGIC,
+		XFS_BTREE_LBLOCK_CRC_LEN,
+		2 * sizeof(struct xfs_rmap_key),
+		sizeof(struct xfs_rmap_rec),
+		sizeof(__be64),
+	},
 	{	XFS_REFC_CRC_MAGIC,
 		XFS_BTREE_SBLOCK_CRC_LEN,
 		sizeof(struct xfs_refcount_key),
@@ -813,6 +819,100 @@ const field_t	rmapbt_rec_flds[] = {
 	{ NULL }
 };
 
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
+#define	KOFF(f)	bitize(offsetof(struct xfs_rmap_key, rm_ ## f))
+
+#define RTRMAPBK_STARTBLOCK_BITOFF	0
+#define RTRMAPBK_OWNER_BITOFF		(RTRMAPBK_STARTBLOCK_BITOFF + RMAPBT_STARTBLOCK_BITLEN)
+#define RTRMAPBK_ATTRFLAG_BITOFF	(RTRMAPBK_OWNER_BITOFF + RMAPBT_OWNER_BITLEN)
+#define RTRMAPBK_BMBTFLAG_BITOFF	(RTRMAPBK_ATTRFLAG_BITOFF + RMAPBT_ATTRFLAG_BITLEN)
+#define RTRMAPBK_EXNTFLAG_BITOFF	(RTRMAPBK_BMBTFLAG_BITOFF + RMAPBT_BMBTFLAG_BITLEN)
+#define RTRMAPBK_UNUSED_OFFSET_BITOFF	(RTRMAPBK_EXNTFLAG_BITOFF + RMAPBT_EXNTFLAG_BITLEN)
+#define RTRMAPBK_OFFSET_BITOFF		(RTRMAPBK_UNUSED_OFFSET_BITOFF + RMAPBT_UNUSED_OFFSET_BITLEN)
+
+#define HI_KOFF(f)	bitize(sizeof(struct xfs_rmap_key) + offsetof(struct xfs_rmap_key, rm_ ## f))
+
+#define RTRMAPBK_STARTBLOCKHI_BITOFF	(bitize(sizeof(struct xfs_rmap_key)))
+#define RTRMAPBK_OWNERHI_BITOFF		(RTRMAPBK_STARTBLOCKHI_BITOFF + RMAPBT_STARTBLOCK_BITLEN)
+#define RTRMAPBK_ATTRFLAGHI_BITOFF	(RTRMAPBK_OWNERHI_BITOFF + RMAPBT_OWNER_BITLEN)
+#define RTRMAPBK_BMBTFLAGHI_BITOFF	(RTRMAPBK_ATTRFLAGHI_BITOFF + RMAPBT_ATTRFLAG_BITLEN)
+#define RTRMAPBK_EXNTFLAGHI_BITOFF	(RTRMAPBK_BMBTFLAGHI_BITOFF + RMAPBT_BMBTFLAG_BITLEN)
+#define RTRMAPBK_UNUSED_OFFSETHI_BITOFF	(RTRMAPBK_EXNTFLAGHI_BITOFF + RMAPBT_EXNTFLAG_BITLEN)
+#define RTRMAPBK_OFFSETHI_BITOFF	(RTRMAPBK_UNUSED_OFFSETHI_BITOFF + RMAPBT_UNUSED_OFFSET_BITLEN)
+
+const field_t	rtrmapbt_key_flds[] = {
+	{ "startblock", FLDT_RGBLOCK, OI(KOFF(startblock)), C1, 0, TYP_DATA },
+	{ "owner", FLDT_INT64D, OI(KOFF(owner)), C1, 0, TYP_NONE },
+	{ "offset", FLDT_RFILEOFFD, OI(RTRMAPBK_OFFSET_BITOFF), C1, 0, TYP_NONE },
+	{ "attrfork", FLDT_RATTRFORKFLG, OI(RTRMAPBK_ATTRFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "bmbtblock", FLDT_RBMBTFLG, OI(RTRMAPBK_BMBTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "startblock_hi", FLDT_RGBLOCK, OI(HI_KOFF(startblock)), C1, 0, TYP_DATA },
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
+#define	ROFF(f)	bitize(offsetof(struct xfs_rmap_rec, rm_ ## f))
+
+#define RTRMAPBT_STARTBLOCK_BITOFF	0
+#define RTRMAPBT_BLOCKCOUNT_BITOFF	(RTRMAPBT_STARTBLOCK_BITOFF + RMAPBT_STARTBLOCK_BITLEN)
+#define RTRMAPBT_OWNER_BITOFF		(RTRMAPBT_BLOCKCOUNT_BITOFF + RMAPBT_BLOCKCOUNT_BITLEN)
+#define RTRMAPBT_ATTRFLAG_BITOFF	(RTRMAPBT_OWNER_BITOFF + RMAPBT_OWNER_BITLEN)
+#define RTRMAPBT_BMBTFLAG_BITOFF	(RTRMAPBT_ATTRFLAG_BITOFF + RMAPBT_ATTRFLAG_BITLEN)
+#define RTRMAPBT_EXNTFLAG_BITOFF	(RTRMAPBT_BMBTFLAG_BITOFF + RMAPBT_BMBTFLAG_BITLEN)
+#define RTRMAPBT_UNUSED_OFFSET_BITOFF	(RTRMAPBT_EXNTFLAG_BITOFF + RMAPBT_EXNTFLAG_BITLEN)
+#define RTRMAPBT_OFFSET_BITOFF		(RTRMAPBT_UNUSED_OFFSET_BITOFF + RMAPBT_UNUSED_OFFSET_BITLEN)
+
+const field_t	rtrmapbt_rec_flds[] = {
+	{ "startblock", FLDT_RGBLOCK, OI(RTRMAPBT_STARTBLOCK_BITOFF), C1, 0, TYP_DATA },
+	{ "blockcount", FLDT_EXTLEN, OI(RTRMAPBT_BLOCKCOUNT_BITOFF), C1, 0, TYP_NONE },
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
index 4168c9e2e15..b4013ea8073 100644
--- a/db/btblock.h
+++ b/db/btblock.h
@@ -53,6 +53,11 @@ extern const struct field	rmapbt_crc_hfld[];
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
index 4a6a4cf51c3..b3efbb5698d 100644
--- a/db/field.c
+++ b/db/field.c
@@ -184,6 +184,17 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_RMAPBTREC, "rmapbtrec", fp_sarray, (char *)rmapbt_rec_flds,
 	  SI(bitsz(struct xfs_rmap_rec)), 0, NULL, rmapbt_rec_flds },
 
+	{ FLDT_RTRMAPBT_CRC, "rtrmapbt", NULL, (char *)rtrmapbt_crc_flds, btblock_size,
+	  FTARG_SIZE, NULL, rtrmapbt_crc_flds },
+	{ FLDT_RTRMAPBTKEY, "rtrmapbtkey", fp_sarray, (char *)rtrmapbt_key_flds,
+	  SI(bitize(2 * sizeof(struct xfs_rmap_key))), 0, NULL, rtrmapbt_key_flds },
+	{ FLDT_RTRMAPBTPTR, "rtrmapbtptr", fp_num, "%llu",
+	  SI(bitsz(xfs_rtrmap_ptr_t)), 0, fa_dfsbno, NULL },
+	{ FLDT_RTRMAPBTREC, "rtrmapbtrec", fp_sarray, (char *)rtrmapbt_rec_flds,
+	  SI(bitsz(struct xfs_rmap_rec)), 0, NULL, rtrmapbt_rec_flds },
+	{ FLDT_RTRMAPROOT, "rtrmaproot", NULL, (char *)rtrmaproot_flds, rtrmaproot_size,
+	  FTARG_SIZE, NULL, rtrmaproot_flds },
+
 	{ FLDT_REFCBT_CRC, "refcntbt", NULL, (char *)refcbt_crc_flds, btblock_size,
 	  FTARG_SIZE, NULL, refcbt_crc_flds },
 	{ FLDT_REFCBTKEY, "refcntbtkey", fp_sarray, (char *)refcbt_key_flds,
diff --git a/db/field.h b/db/field.h
index e9c6142f282..db3e13d3927 100644
--- a/db/field.h
+++ b/db/field.h
@@ -83,6 +83,11 @@ typedef enum fldt	{
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
index 16033c5ab79..6867f5c5427 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -17,6 +17,7 @@
 #include "bit.h"
 #include "output.h"
 #include "init.h"
+#include "libfrog/bitmap.h"
 
 static int	inode_a_bmbt_count(void *obj, int startoff);
 static int	inode_a_bmx_count(void *obj, int startoff);
@@ -47,6 +48,7 @@ static int	inode_u_muuid_count(void *obj, int startoff);
 static int	inode_u_sfdir2_count(void *obj, int startoff);
 static int	inode_u_sfdir3_count(void *obj, int startoff);
 static int	inode_u_symlink_count(void *obj, int startoff);
+static int	inode_u_rtrmapbt_count(void *obj, int startoff);
 
 static const cmdinfo_t	inode_cmd =
 	{ "inode", NULL, inode_f, 0, 1, 1, "[inode#]",
@@ -230,6 +232,8 @@ const field_t	inode_u_flds[] = {
 	{ "sfdir3", FLDT_DIR3SF, NULL, inode_u_sfdir3_count, FLD_COUNT, TYP_NONE },
 	{ "symlink", FLDT_CHARNS, NULL, inode_u_symlink_count, FLD_COUNT,
 	  TYP_NONE },
+	{ "rtrmapbt", FLDT_RTRMAPROOT, NULL, inode_u_rtrmapbt_count, FLD_COUNT,
+	  TYP_NONE },
 	{ NULL }
 };
 
@@ -243,7 +247,7 @@ const field_t	inode_a_flds[] = {
 };
 
 static const char	*dinode_fmt_name[] =
-	{ "dev", "local", "extents", "btree", "uuid" };
+	{ "dev", "local", "extents", "btree", "uuid", "rmap" };
 static const int	dinode_fmt_name_size =
 	sizeof(dinode_fmt_name) / sizeof(dinode_fmt_name[0]);
 
@@ -633,9 +637,86 @@ inode_init(void)
 	add_command(&inode_cmd);
 }
 
+static struct bitmap	*rmap_inodes;
+
+static inline int
+set_rtgroup_rmap_inode(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_imeta_path	*path;
+	struct xfs_trans	*tp;
+	xfs_ino_t		rtino;
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	error = -libxfs_rtrmapbt_create_path(mp, rgno, &path);
+	if (error)
+		return error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		goto out_path;
+
+	error = -libxfs_imeta_lookup(tp, path, &rtino);
+	if (error)
+		goto out_trans;
+
+	if (rtino == NULLFSINO) {
+		error = EFSCORRUPTED;
+		goto out_trans;
+	}
+
+	error = bitmap_set(rmap_inodes, rtino, 1);
+
+out_trans:
+	libxfs_trans_cancel(tp);
+out_path:
+	libxfs_imeta_free_path(path);
+	return error;
+}
+
+int
+init_rtmeta_inode_bitmaps(
+	struct xfs_mount	*mp)
+{
+	xfs_rgnumber_t		rgno;
+	int			error;
+
+	if (rmap_inodes)
+		return 0;
+
+	error = bitmap_alloc(&rmap_inodes);
+	if (error)
+		return error;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		int err2 = set_rtgroup_rmap_inode(mp, rgno);
+		if (err2 && !error)
+			error = err2;
+	}
+
+	return error;
+}
+
+bool is_rtrmap_inode(xfs_ino_t ino)
+{
+	return bitmap_test(rmap_inodes, ino, 1);
+}
+
 typnm_t
 inode_next_type(void)
 {
+	int		error;
+
+	error = init_rtmeta_inode_bitmaps(mp);
+	if (error) {
+		dbprintf(_("error %d setting up rt metadata inode bitmaps\n"),
+				error);
+	}
+
 	switch (iocur_top->mode & S_IFMT) {
 	case S_IFDIR:
 		return TYP_DIR2;
@@ -655,8 +736,9 @@ inode_next_type(void)
 			 iocur_top->ino == mp->m_sb.sb_gquotino ||
 			 iocur_top->ino == mp->m_sb.sb_pquotino)
 			return TYP_DQBLK;
-		else
-			return TYP_DATA;
+		else if (is_rtrmap_inode(iocur_top->ino))
+			return TYP_RTRMAPBT;
+		return TYP_DATA;
 	default:
 		return TYP_NONE;
 	}
@@ -790,6 +872,20 @@ inode_u_sfdir3_count(
 	       xfs_has_ftype(mp);
 }
 
+static int
+inode_u_rtrmapbt_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dip;
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
 	void			*obj,
diff --git a/db/inode.h b/db/inode.h
index 31a2ebbba6a..a47b0575a15 100644
--- a/db/inode.h
+++ b/db/inode.h
@@ -23,3 +23,6 @@ extern int	inode_size(void *obj, int startoff, int idx);
 extern int	inode_u_size(void *obj, int startoff, int idx);
 extern void	xfs_inode_set_crc(struct xfs_buf *);
 extern void	set_cur_inode(xfs_ino_t ino);
+
+int init_rtmeta_inode_bitmaps(struct xfs_mount *mp);
+bool is_rtrmap_inode(xfs_ino_t ino);
diff --git a/db/type.c b/db/type.c
index 2091b4ac8b1..1dfc33ffb44 100644
--- a/db/type.c
+++ b/db/type.c
@@ -51,6 +51,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RMAPBT, NULL },
+	{ TYP_RTRMAPBT, NULL },
 	{ TYP_REFCBT, NULL },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld, NULL, TYP_F_NO_CRC_OFF },
@@ -91,6 +92,8 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_cntbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RMAPBT, "rmapbt", handle_struct, rmapbt_crc_hfld,
 		&xfs_rmapbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_RTRMAPBT, "rtrmapbt", handle_struct, rtrmapbt_crc_hfld,
+		&xfs_rtrmapbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_REFCBT, "refcntbt", handle_struct, refcbt_crc_hfld,
 		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
@@ -141,6 +144,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_cntbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RMAPBT, "rmapbt", handle_struct, rmapbt_crc_hfld,
 		&xfs_rmapbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_RTRMAPBT, "rtrmapbt", handle_struct, rtrmapbt_crc_hfld,
+		&xfs_rtrmapbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_REFCBT, "refcntbt", handle_struct, refcbt_crc_hfld,
 		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
diff --git a/db/type.h b/db/type.h
index e7f0ecc1768..c98f3640202 100644
--- a/db/type.h
+++ b/db/type.h
@@ -20,6 +20,7 @@ typedef enum typnm
 	TYP_BNOBT,
 	TYP_CNTBT,
 	TYP_RMAPBT,
+	TYP_RTRMAPBT,
 	TYP_REFCBT,
 	TYP_DATA,
 	TYP_DIR2,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c5dad34f3d2..e961453052a 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -286,6 +286,10 @@
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
+#define xfs_rtrmapbt_create_path	libxfs_rtrmapbt_create_path
+#define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
+#define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
+
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
 #define xfs_sb_read_secondary		libxfs_sb_read_secondary
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index d0115075888..0e20108fb51 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1200,7 +1200,7 @@ The possible data types are:
 .BR agf ", " agfl ", " agi ", " attr ", " bmapbta ", " bmapbtd ,
 .BR bnobt ", " cntbt ", " data ", " dir ", " dir2 ", " dqblk ,
 .BR inobt ", " inode ", " log ", " refcntbt ", " rmapbt ", " rtbitmap ,
-.BR rtsummary ", " sb ", " symlink " and " text .
+.BR rtsummary ", " sb ", " symlink ", " rtrmapbt ", and " text .
 See the TYPES section below for more information on these data types.
 .TP
 .BI "timelimit [" OPTIONS ]
@@ -2348,6 +2348,64 @@ block number within the allocation group to the next level in the Btree.
 .PD
 .RE
 .TP
+.B rtrmapbt
+There is one reverse mapping Btree for each realtime group.
+The
+.BR startblock " and "
+.B blockcount
+fields are 32 bits wide and record blocks within a realtime group.
+The root of this Btree is the reverse-mapping inode, which is recorded in the
+metadata directory.
+Blocks are linked to sibling left and right blocks at each level, as well as by
+pointers from parent to child blocks.
+Each block has the following fields:
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

