Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453761368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3j7fblg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E88C433C8;
	Mon,  1 Jan 2024 00:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069145;
	bh=DW3ecMO6dYEaGb9ju7scjWZGtEQaX39c4JQNiBx5pfc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H3j7fblgoyMbP8OEnn7gNzRemaSLkjkqpqZGvynYwnBnlzJIMayz+uVmUReKiz4mV
	 4fv7Zk1HWyUR6mx7nDuYcazyiN13jsB4pe2s64uLQNuWyXSjfuG9odvVCAXZehJbrV
	 +7pjD4tLQH0+kvgSN+OgO+RL5msIz68HTKt2Q4KgU702z1qJExm2mDlzQbu9tLFt5B
	 DJC3UQzhFaRzpfVrLJhLkihJlrOU52uMihPpXXCHJOxpCyxrXR3uh7HIpiLaGnZb9j
	 KGWZra1Nn/dvMrPxMgK7hJqTr62t+68avkunIxP6nOyjMJXRAEkVj/rOl4X2Yaw2TJ
	 QsYyTafXkSwhg==
Date: Sun, 31 Dec 2023 16:32:24 +9900
Subject: [PATCH 24/42] xfs_db: display the realtime refcount btree contents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017445.1817107.16357495183086399903.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Implement all the code we need to dump rtrefcountbt contents, starting
from the root inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bmroot.c              |  148 ++++++++++++++++++++++++++++++++++++++++++++++
 db/bmroot.h              |    2 +
 db/btblock.c             |   50 ++++++++++++++++
 db/btblock.h             |    5 ++
 db/field.c               |   15 +++++
 db/field.h               |    6 ++
 db/inode.c               |   73 ++++++++++++++++++++++-
 db/inode.h               |    1 
 db/type.c                |    5 ++
 db/type.h                |    1 
 libxfs/libxfs_api_defs.h |    5 ++
 man/man8/xfs_db.8        |   48 +++++++++++++++
 12 files changed, 357 insertions(+), 2 deletions(-)


diff --git a/db/bmroot.c b/db/bmroot.c
index 19490bd2499..cb334aa4583 100644
--- a/db/bmroot.c
+++ b/db/bmroot.c
@@ -31,6 +31,13 @@ static int	rtrmaproot_key_offset(void *obj, int startoff, int idx);
 static int	rtrmaproot_ptr_count(void *obj, int startoff);
 static int	rtrmaproot_ptr_offset(void *obj, int startoff, int idx);
 
+static int	rtrefcroot_rec_count(void *obj, int startoff);
+static int	rtrefcroot_rec_offset(void *obj, int startoff, int idx);
+static int	rtrefcroot_key_count(void *obj, int startoff);
+static int	rtrefcroot_key_offset(void *obj, int startoff, int idx);
+static int	rtrefcroot_ptr_count(void *obj, int startoff);
+static int	rtrefcroot_ptr_offset(void *obj, int startoff, int idx);
+
 #define	OFF(f)	bitize(offsetof(xfs_bmdr_block_t, bb_ ## f))
 const field_t	bmroota_flds[] = {
 	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
@@ -73,6 +80,19 @@ const field_t	rtrmaproot_flds[] = {
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_RTRMAPBT },
 	{ NULL }
 };
+
+/* realtime refcount btree root */
+const field_t	rtrefcroot_flds[] = {
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_RTREFCBTREC, rtrefcroot_rec_offset, rtrefcroot_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_RTREFCBTKEY, rtrefcroot_key_offset, rtrefcroot_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_RTREFCBTPTR, rtrefcroot_ptr_offset, rtrefcroot_ptr_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_RTREFCBT },
+	{ NULL }
+};
 #undef OFF
 
 static int
@@ -390,3 +410,131 @@ rtrmaproot_size(
 	dip = obj;
 	return bitize((int)XFS_DFORK_DSIZE(dip, mp));
 }
+
+/* realtime refcount root */
+static int
+rtrefcroot_rec_count(
+	void				*obj,
+	int				startoff)
+{
+	struct xfs_rtrefcount_root	*block;
+#ifdef DEBUG
+	struct xfs_dinode		*dip = obj;
+#endif
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrefcount_root *)((char *)obj + byteize(startoff));
+	ASSERT((char *)block == XFS_DFORK_DPTR(dip));
+	if (be16_to_cpu(block->bb_level) > 0)
+		return 0;
+	return be16_to_cpu(block->bb_numrecs);
+}
+
+static int
+rtrefcroot_rec_offset(
+	void				*obj,
+	int				startoff,
+	int				idx)
+{
+	struct xfs_rtrefcount_root	*block;
+	struct xfs_refcount_rec		*kp;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrefcount_root *)((char *)obj + byteize(startoff));
+	ASSERT(be16_to_cpu(block->bb_level) == 0);
+	kp = xfs_rtrefcount_droot_rec_addr(block, idx);
+	return bitize((int)((char *)kp - (char *)block));
+}
+
+static int
+rtrefcroot_key_count(
+	void				*obj,
+	int				startoff)
+{
+	struct xfs_rtrefcount_root	*block;
+#ifdef DEBUG
+	struct xfs_dinode		*dip = obj;
+#endif
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrefcount_root *)((char *)obj + byteize(startoff));
+	ASSERT((char *)block == XFS_DFORK_DPTR(dip));
+	if (be16_to_cpu(block->bb_level) == 0)
+		return 0;
+	return be16_to_cpu(block->bb_numrecs);
+}
+
+static int
+rtrefcroot_key_offset(
+	void				*obj,
+	int				startoff,
+	int				idx)
+{
+	struct xfs_rtrefcount_root	*block;
+	struct xfs_refcount_key		*kp;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrefcount_root *)((char *)obj + byteize(startoff));
+	ASSERT(be16_to_cpu(block->bb_level) > 0);
+	kp = xfs_rtrefcount_droot_key_addr(block, idx);
+	return bitize((int)((char *)kp - (char *)block));
+}
+
+static int
+rtrefcroot_ptr_count(
+	void				*obj,
+	int				startoff)
+{
+	struct xfs_rtrefcount_root	*block;
+#ifdef DEBUG
+	struct xfs_dinode		*dip = obj;
+#endif
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	block = (struct xfs_rtrefcount_root *)((char *)obj + byteize(startoff));
+	ASSERT((char *)block == XFS_DFORK_DPTR(dip));
+	if (be16_to_cpu(block->bb_level) == 0)
+		return 0;
+	return be16_to_cpu(block->bb_numrecs);
+}
+
+static int
+rtrefcroot_ptr_offset(
+	void				*obj,
+	int				startoff,
+	int				idx)
+{
+	struct xfs_rtrefcount_root	*block;
+	xfs_rtrefcount_ptr_t		*pp;
+	struct xfs_dinode		*dip;
+	int				dmxr;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	dip = obj;
+	block = (struct xfs_rtrefcount_root *)((char *)obj + byteize(startoff));
+	ASSERT(be16_to_cpu(block->bb_level) > 0);
+	dmxr = libxfs_rtrefcountbt_droot_maxrecs(XFS_DFORK_DSIZE(dip, mp), false);
+	pp = xfs_rtrefcount_droot_ptr_addr(block, idx, dmxr);
+	return bitize((int)((char *)pp - (char *)block));
+}
+
+int
+rtrefcroot_size(
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
index a2c5cfb18f0..70bc8483cd8 100644
--- a/db/bmroot.h
+++ b/db/bmroot.h
@@ -9,7 +9,9 @@ extern const struct field	bmroota_key_flds[];
 extern const struct field	bmrootd_flds[];
 extern const struct field	bmrootd_key_flds[];
 extern const struct field	rtrmaproot_flds[];
+extern const struct field	rtrefcroot_flds[];
 
 extern int	bmroota_size(void *obj, int startoff, int idx);
 extern int	bmrootd_size(void *obj, int startoff, int idx);
 extern int	rtrmaproot_size(void *obj, int startoff, int idx);
+extern int	rtrefcroot_size(void *obj, int startoff, int idx);
diff --git a/db/btblock.c b/db/btblock.c
index 70f6c3f6aed..40913a09437 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -104,6 +104,12 @@ static struct xfs_db_btree {
 		sizeof(struct xfs_refcount_rec),
 		sizeof(__be32),
 	},
+	{	XFS_RTREFC_CRC_MAGIC,
+		XFS_BTREE_LBLOCK_CRC_LEN,
+		sizeof(struct xfs_refcount_key),
+		sizeof(struct xfs_refcount_rec),
+		sizeof(__be64),
+	},
 	{	0,
 	},
 };
@@ -962,3 +968,47 @@ const field_t	refcbt_rec_flds[] = {
 	{ NULL }
 };
 #undef ROFF
+
+/* realtime refcount btree blocks */
+const field_t	rtrefcbt_crc_hfld[] = {
+	{ "", FLDT_RTREFCBT_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(struct xfs_btree_block, bb_ ## f))
+const field_t	rtrefcbt_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_DFSBNO, OI(OFF(u.l.bb_leftsib)), C1, 0, TYP_RTREFCBT },
+	{ "rightsib", FLDT_DFSBNO, OI(OFF(u.l.bb_rightsib)), C1, 0, TYP_RTREFCBT },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.l.bb_blkno)), C1, 0, TYP_REFCBT },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.l.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.l.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(u.l.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.l.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_RTREFCBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY | FLD_ABASE1 | FLD_COUNT | FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_RTREFCBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY | FLD_ABASE1 | FLD_COUNT | FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_RTREFCBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY | FLD_ABASE1 | FLD_COUNT | FLD_OFFSET, TYP_RTREFCBT },
+	{ NULL }
+};
+#undef OFF
+
+const field_t	rtrefcbt_key_flds[] = {
+	{ "startblock", FLDT_CRGBLOCK, OI(REFCNTBT_STARTBLOCK_BITOFF), C1, 0, TYP_DATA },
+	{ "cowflag", FLDT_CCOWFLG, OI(REFCNTBT_COWFLAG_BITOFF), C1, 0, TYP_DATA },
+	{ NULL }
+};
+
+#define	ROFF(f)	bitize(offsetof(struct xfs_refcount_rec, rc_ ## f))
+const field_t	rtrefcbt_rec_flds[] = {
+	{ "startblock", FLDT_CRGBLOCK, OI(REFCNTBT_STARTBLOCK_BITOFF), C1, 0, TYP_DATA },
+	{ "blockcount", FLDT_EXTLEN, OI(ROFF(blockcount)), C1, 0, TYP_NONE },
+	{ "refcount", FLDT_UINT32D, OI(ROFF(refcount)), C1, 0, TYP_DATA },
+	{ "cowflag", FLDT_CCOWFLG, OI(REFCNTBT_COWFLAG_BITOFF), C1, 0, TYP_DATA },
+	{ NULL }
+};
+#undef ROFF
diff --git a/db/btblock.h b/db/btblock.h
index b4013ea8073..5bbe857a7ef 100644
--- a/db/btblock.h
+++ b/db/btblock.h
@@ -63,4 +63,9 @@ extern const struct field	refcbt_crc_hfld[];
 extern const struct field	refcbt_key_flds[];
 extern const struct field	refcbt_rec_flds[];
 
+extern const struct field	rtrefcbt_crc_flds[];
+extern const struct field	rtrefcbt_crc_hfld[];
+extern const struct field	rtrefcbt_key_flds[];
+extern const struct field	rtrefcbt_rec_flds[];
+
 extern int	btblock_size(void *obj, int startoff, int idx);
diff --git a/db/field.c b/db/field.c
index b3efbb5698d..66f3dd28ada 100644
--- a/db/field.c
+++ b/db/field.c
@@ -204,6 +204,21 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_REFCBTREC, "refcntbtrec", fp_sarray, (char *)refcbt_rec_flds,
 	  SI(bitsz(struct xfs_refcount_rec)), 0, NULL, refcbt_rec_flds },
 
+	{ FLDT_CRGBLOCK, "crgblock", fp_num, "%u", SI(REFCNTBT_AGBLOCK_BITLEN),
+	  FTARG_DONULL, NULL, NULL },
+	{ FLDT_RTREFCBT_CRC, "rtrefcntbt", NULL, (char *)rtrefcbt_crc_flds,
+	  btblock_size, FTARG_SIZE, NULL, rtrefcbt_crc_flds },
+	{ FLDT_RTREFCBTKEY, "rtrefcntbtkey", fp_sarray,
+	  (char *)rtrefcbt_key_flds, SI(bitsz(struct xfs_refcount_key)), 0,
+	  NULL, rtrefcbt_key_flds },
+	{ FLDT_RTREFCBTPTR, "rtrefcntbtptr", fp_num, "%u",
+	  SI(bitsz(xfs_rtrefcount_ptr_t)), 0, fa_dfsbno, NULL },
+	{ FLDT_RTREFCBTREC, "rtrefcntbtrec", fp_sarray,
+	  (char *)rtrefcbt_rec_flds, SI(bitsz(struct xfs_refcount_rec)), 0,
+	  NULL, rtrefcbt_rec_flds },
+	{ FLDT_RTREFCROOT, "rtrefcroot", NULL, (char *)rtrefcroot_flds,
+	  rtrefcroot_size, FTARG_SIZE, NULL, rtrefcroot_flds },
+
 /* CRC field */
 	{ FLDT_CRC, "crc", fp_crc, "%#x (%s)", SI(bitsz(uint32_t)),
 	  0, NULL, NULL },
diff --git a/db/field.h b/db/field.h
index db3e13d3927..4a5b35f4a56 100644
--- a/db/field.h
+++ b/db/field.h
@@ -92,6 +92,12 @@ typedef enum fldt	{
 	FLDT_REFCBTKEY,
 	FLDT_REFCBTPTR,
 	FLDT_REFCBTREC,
+	FLDT_CRGBLOCK,
+	FLDT_RTREFCBT_CRC,
+	FLDT_RTREFCBTKEY,
+	FLDT_RTREFCBTPTR,
+	FLDT_RTREFCBTREC,
+	FLDT_RTREFCROOT,
 
 	/* CRC field type */
 	FLDT_CRC,
diff --git a/db/inode.c b/db/inode.c
index 492a8f53ed0..760d47c0f04 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -49,6 +49,7 @@ static int	inode_u_sfdir2_count(void *obj, int startoff);
 static int	inode_u_sfdir3_count(void *obj, int startoff);
 static int	inode_u_symlink_count(void *obj, int startoff);
 static int	inode_u_rtrmapbt_count(void *obj, int startoff);
+static int	inode_u_rtrefcbt_count(void *obj, int startoff);
 
 static const cmdinfo_t	inode_cmd =
 	{ "inode", NULL, inode_f, 0, 1, 1, "[inode#]",
@@ -234,6 +235,8 @@ const field_t	inode_u_flds[] = {
 	  TYP_NONE },
 	{ "rtrmapbt", FLDT_RTRMAPROOT, NULL, inode_u_rtrmapbt_count, FLD_COUNT,
 	  TYP_NONE },
+	{ "rtrefcbt", FLDT_RTREFCROOT, NULL, inode_u_rtrefcbt_count, FLD_COUNT,
+	  TYP_NONE },
 	{ NULL }
 };
 
@@ -247,7 +250,7 @@ const field_t	inode_a_flds[] = {
 };
 
 static const char	*dinode_fmt_name[] =
-	{ "dev", "local", "extents", "btree", "uuid", "rmap" };
+	{ "dev", "local", "extents", "btree", "uuid", "rmap", "refcount" };
 static const int	dinode_fmt_name_size =
 	sizeof(dinode_fmt_name) / sizeof(dinode_fmt_name[0]);
 
@@ -643,6 +646,7 @@ struct rtgroup_inodes {
 
 static struct rtgroup_inodes	*rtgroup_inodes;
 static struct bitmap		*rmap_inodes;
+static struct bitmap		*refcount_inodes;
 
 static inline int
 set_rtgroup_rmap_inode(
@@ -687,6 +691,44 @@ set_rtgroup_rmap_inode(
 	return error;
 }
 
+static inline int
+set_rtgroup_refcount_inode(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_imeta_path	*path;
+	struct xfs_trans	*tp;
+	xfs_ino_t		rtino;
+	int			error;
+
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	error = -libxfs_rtrefcountbt_create_path(mp, rgno, &path);
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
+	error = bitmap_set(refcount_inodes, rtino, 1);
+out_trans:
+	libxfs_trans_cancel(tp);
+out_path:
+	libxfs_imeta_free_path(path);
+	return error;
+}
+
 int
 init_rtmeta_inode_bitmaps(
 	struct xfs_mount	*mp)
@@ -706,10 +748,17 @@ init_rtmeta_inode_bitmaps(
 	if (error)
 		return error;
 
+	error = bitmap_alloc(&refcount_inodes);
+	if (error)
+		return error;
+
 	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
 		int err2 = set_rtgroup_rmap_inode(mp, rgno);
 		if (err2 && !error)
 			error = err2;
+		err2 = set_rtgroup_refcount_inode(mp, rgno);
+		if (err2 && !error)
+			error = err2;
 	}
 
 	return error;
@@ -732,6 +781,11 @@ xfs_rgnumber_t rtgroup_for_rtrmap_ino(struct xfs_mount *mp, xfs_ino_t ino)
 	return NULLRGNUMBER;
 }
 
+bool is_rtrefcount_inode(xfs_ino_t ino)
+{
+	return bitmap_test(refcount_inodes, ino, 1);
+}
+
 typnm_t
 inode_next_type(void)
 {
@@ -764,6 +818,9 @@ inode_next_type(void)
 			return TYP_DQBLK;
 		else if (is_rtrmap_inode(iocur_top->ino))
 			return TYP_RTRMAPBT;
+		else if (is_rtrefcount_inode(iocur_top->ino))
+			return TYP_RTREFCBT;
+
 		return TYP_DATA;
 	default:
 		return TYP_NONE;
@@ -912,6 +969,20 @@ inode_u_rtrmapbt_count(
 	return dip->di_format == XFS_DINODE_FMT_RMAP;
 }
 
+static int
+inode_u_rtrefcbt_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dip;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	dip = obj;
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_REFCOUNT;
+}
+
 int
 inode_u_size(
 	void			*obj,
diff --git a/db/inode.h b/db/inode.h
index 04e606abed3..666bb5201ea 100644
--- a/db/inode.h
+++ b/db/inode.h
@@ -27,3 +27,4 @@ extern void	set_cur_inode(xfs_ino_t ino);
 int init_rtmeta_inode_bitmaps(struct xfs_mount *mp);
 bool is_rtrmap_inode(xfs_ino_t ino);
 xfs_rgnumber_t rtgroup_for_rtrmap_ino(struct xfs_mount *mp, xfs_ino_t ino);
+bool is_rtrefcount_inode(xfs_ino_t ino);
diff --git a/db/type.c b/db/type.c
index 1dfc33ffb44..324f416a49c 100644
--- a/db/type.c
+++ b/db/type.c
@@ -53,6 +53,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_RMAPBT, NULL },
 	{ TYP_RTRMAPBT, NULL },
 	{ TYP_REFCBT, NULL },
+	{ TYP_RTREFCBT, NULL },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld, NULL, TYP_F_NO_CRC_OFF },
@@ -96,6 +97,8 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_rtrmapbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_REFCBT, "refcntbt", handle_struct, refcbt_crc_hfld,
 		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_RTREFCBT, "rtrefcntbt", handle_struct, rtrefcbt_crc_hfld,
+		&xfs_rtrefcountbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
 		&xfs_dir3_db_buf_ops, TYP_F_CRC_FUNC, xfs_dir3_set_crc },
@@ -148,6 +151,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_rtrmapbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_REFCBT, "refcntbt", handle_struct, refcbt_crc_hfld,
 		&xfs_refcountbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_RTREFCBT, "rtrefcntbt", handle_struct, rtrefcbt_crc_hfld,
+		&xfs_rtrefcountbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
 		&xfs_dir3_db_buf_ops, TYP_F_CRC_FUNC, xfs_dir3_set_crc },
diff --git a/db/type.h b/db/type.h
index c98f3640202..a2488a663db 100644
--- a/db/type.h
+++ b/db/type.h
@@ -22,6 +22,7 @@ typedef enum typnm
 	TYP_RMAPBT,
 	TYP_RTRMAPBT,
 	TYP_REFCBT,
+	TYP_RTREFCBT,
 	TYP_DATA,
 	TYP_DIR2,
 	TYP_DQBLK,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index cfa8c474160..1a21eb30f39 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -292,6 +292,11 @@
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
+
+#define xfs_rtrefcountbt_create_path	libxfs_rtrefcountbt_create_path
+#define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
+#define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
+
 #define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
 #define xfs_rtrmapbt_calc_size		libxfs_rtrmapbt_calc_size
 #define xfs_rtrmapbt_commit_staged_btree	libxfs_rtrmapbt_commit_staged_btree
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 778e3f9dd70..71859b3af44 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1201,7 +1201,7 @@ The possible data types are:
 .BR agf ", " agfl ", " agi ", " attr ", " bmapbta ", " bmapbtd ,
 .BR bnobt ", " cntbt ", " data ", " dir ", " dir2 ", " dqblk ,
 .BR inobt ", " inode ", " log ", " refcntbt ", " rmapbt ", " rtbitmap ,
-.BR rtsummary ", " sb ", " symlink ", " rtrmapbt ", and " text .
+.BR rtsummary ", " sb ", " symlink ", " rtrmapbt ", " rtrefcbt ", and " text .
 See the TYPES section below for more information on these data types.
 .TP
 .BI "timelimit [" OPTIONS ]
@@ -2295,6 +2295,52 @@ block number within the allocation group to the next level in the Btree.
 .PD
 .RE
 .TP
+.B rtrefcbt
+There is one reference count Btree for the entire realtime device.  The
+.BR startblock " and "
+.B blockcount
+fields are 32 bits wide and record block counts within a realtime group.
+The root of this Btree is the realtime refcount inode, which is recorded in the
+metadata directory.
+Blocks are linked to sibling left and right blocks at each level, as well as by
+pointers from parent to child blocks.
+Each block has the following fields:
+.RS 1.4i
+.PD 0
+.TP 1.2i
+.B magic
+RTREFC block magic number, 0x52434e54 ('RCNT').
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

