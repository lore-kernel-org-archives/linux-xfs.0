Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7627522FF5D
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882295; cv=none; b=JPgl+9PN5oNmYIfG5Qir8BMrWS/9avrcSi5kDjTI8mhpCXx2l7lCYitpvc4m2d4/WuqjRpj5lIv7ZK/GaMpjbbb7N2SWJMuQOexIKgifDhEuaEgcxJ1q4mCd2K+L9YgtQP11GYRl57XbHoSrxIFgsoKWUVKGj4/Iih0q16ZPc44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882295; c=relaxed/simple;
	bh=rf8sKzhjH7HR06My7ME9mpBuaMECXVPR1QGbTIzhJbQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jlv3xQAxoLzrfidAnkEW3NmZk4ZIGZUzQdny3xW3nvuAyzPrtHZm2NPoMqxaHthv5U5+o4Q5ms8zdOqExYePVsVGWc8OVGYeW8mgybikASCEYrwsl/caTrSq4Cbn4zKaUIbnxI8Fbl67Y2lnQ4zh+YPhTf8f7N+i/vo8wwto1Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hsb4ZDqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hsb4ZDqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1167C4CEDD;
	Thu,  6 Feb 2025 22:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882293;
	bh=rf8sKzhjH7HR06My7ME9mpBuaMECXVPR1QGbTIzhJbQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hsb4ZDqTrfQZimTesTg0TsJO/X1l+e3WyyukfRGfrXozatWK2wmyb1QY9tTpjvpoy
	 DtZfJxdBW2cPsGe0op2qdGd+NlRM4rBbHbw6L7DFx3WyakFqULRpsQ+KOYz+BYU3fj
	 HP5wOVIp+51M5I3OIWZAKSF01XPxGNPPUKyKjaJ9em+lcV+2YVeByBtH9dxUHzxg4G
	 CobFIxoNfyHCpp7Ln5kJZY399lJZDPuxT9QcJMQwvhuhSTU3jRWyOABLBPPG7AQPi+
	 mGnu4ZbbSQyiRMvQaGb/iugUsQLNamPHB+kJIJFvQ6QUyaeBw0YUjJ652/JkNs5WUL
	 pyq2VF1WkVXdA==
Date: Thu, 06 Feb 2025 14:51:33 -0800
Subject: [PATCH 07/27] xfs_db: display the realtime rmap btree contents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088203.2741033.164927994313593176.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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
from the inode root.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/bmroot.c              |  149 ++++++++++++++++++++++++++++++++++++++++++++++
 db/bmroot.h              |    2 +
 db/btblock.c             |  100 +++++++++++++++++++++++++++++++
 db/btblock.h             |    5 ++
 db/field.c               |   11 +++
 db/field.h               |    5 ++
 db/inode.c               |   24 +++++++
 db/type.c                |    5 ++
 db/type.h                |    1 
 libxfs/libxfs_api_defs.h |    5 ++
 man/man8/xfs_db.8        |   60 ++++++++++++++++++-
 11 files changed, 364 insertions(+), 3 deletions(-)


diff --git a/db/bmroot.c b/db/bmroot.c
index 7ef07da181e6ff..19490bd24998c5 100644
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
index a1274cf6a94bdf..a2c5cfb18f0bb2 100644
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
index d5be6adb734cef..5cad166278d98b 100644
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
index 4168c9e2e15ac4..b4013ea8073ec6 100644
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
index ca0fe1826f9a80..60c4e16d781f48 100644
--- a/db/field.c
+++ b/db/field.c
@@ -194,6 +194,17 @@ const ftattr_t	ftattrtab[] = {
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
index 1d7465b4d3e562..67b6cb2a798719 100644
--- a/db/field.h
+++ b/db/field.h
@@ -84,6 +84,11 @@ typedef enum fldt	{
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
index 0a80b8d063603f..45368a3343a17a 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -48,6 +48,7 @@ static int	inode_u_muuid_count(void *obj, int startoff);
 static int	inode_u_sfdir2_count(void *obj, int startoff);
 static int	inode_u_sfdir3_count(void *obj, int startoff);
 static int	inode_u_symlink_count(void *obj, int startoff);
+static int	inode_u_rtrmapbt_count(void *obj, int startoff);
 
 static const cmdinfo_t	inode_cmd =
 	{ "inode", NULL, inode_f, 0, 1, 1, "[inode#]",
@@ -233,6 +234,8 @@ const field_t	inode_u_flds[] = {
 	{ "sfdir3", FLDT_DIR3SF, NULL, inode_u_sfdir3_count, FLD_COUNT, TYP_NONE },
 	{ "symlink", FLDT_CHARNS, NULL, inode_u_symlink_count, FLD_COUNT,
 	  TYP_NONE },
+	{ "rtrmapbt", FLDT_RTRMAPROOT, NULL, inode_u_rtrmapbt_count, FLD_COUNT,
+	  TYP_NONE },
 	{ NULL }
 };
 
@@ -246,7 +249,7 @@ const field_t	inode_a_flds[] = {
 };
 
 static const char	*dinode_fmt_name[] =
-	{ "dev", "local", "extents", "btree", "uuid" };
+	{ "dev", "local", "extents", "btree", "uuid", "meta_btree" };
 static const int	dinode_fmt_name_size =
 	sizeof(dinode_fmt_name) / sizeof(dinode_fmt_name[0]);
 
@@ -299,7 +302,7 @@ fp_dinode_fmt(
 
 static const char	*metatype_name[] =
 	{ "unknown", "dir", "usrquota", "grpquota", "prjquota", "rtbitmap",
-	  "rtsummary"
+	  "rtsummary", "rtrmap"
 	};
 static const int	metatype_name_size = ARRAY_SIZE(metatype_name);
 
@@ -717,6 +720,8 @@ inode_next_type(void)
 				return TYP_RGBITMAP;
 			case XFS_METAFILE_RTSUMMARY:
 				return TYP_RGSUMMARY;
+			case XFS_METAFILE_RTRMAP:
+				return TYP_RTRMAPBT;
 			default:
 				return TYP_DATA;
 			}
@@ -866,6 +871,21 @@ inode_u_sfdir3_count(
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
+	return dip->di_format == XFS_DINODE_FMT_META_BTREE &&
+	       dip->di_metatype == cpu_to_be16(XFS_METAFILE_RTRMAP);
+}
+
 int
 inode_u_size(
 	void			*obj,
diff --git a/db/type.c b/db/type.c
index 2091b4ac8b139b..1dfc33ffb44b87 100644
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
index e7f0ecc17680bf..c98f3640202e87 100644
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
index 6b2dc7a30d2547..fcbcaaa11f1025 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -295,6 +295,8 @@
 #define xfs_rtginode_name		libxfs_rtginode_name
 #define xfs_rtsummary_create		libxfs_rtsummary_create
 
+#define xfs_rtginode_load		libxfs_rtginode_load
+#define xfs_rtginode_load_parent	libxfs_rtginode_load_parent
 #define xfs_rtgroup_alloc		libxfs_rtgroup_alloc
 #define xfs_rtgroup_extents		libxfs_rtgroup_extents
 #define xfs_rtgroup_grab		libxfs_rtgroup_grab
@@ -308,6 +310,9 @@
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
 #define xfs_update_rtsb			libxfs_update_rtsb
+#define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
+#define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
+
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_mount_rextsize		libxfs_sb_mount_rextsize
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index acee900adbda50..ddbabe36b5fc41 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1302,7 +1302,7 @@ .SH COMMANDS
 .BR agf ", " agfl ", " agi ", " attr ", " bmapbta ", " bmapbtd ,
 .BR bnobt ", " cntbt ", " data ", " dir ", " dir2 ", " dqblk ,
 .BR inobt ", " inode ", " log ", " refcntbt ", " rmapbt ", " rtbitmap ,
-.BR rtsummary ", " sb ", " symlink " and " text .
+.BR rtsummary ", " sb ", " symlink ", " rtrmapbt ", and " text .
 See the TYPES section below for more information on these data types.
 .TP
 .BI "timelimit [" OPTIONS ]
@@ -2450,6 +2450,64 @@ .SH TYPES
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

