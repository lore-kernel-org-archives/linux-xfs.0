Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42281C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/3W3bhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D845C433C8;
	Sun, 31 Dec 2023 23:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067033;
	bh=IelE2Rp+EOK1JRBmWG4IZ0OBip0+SMEub5VdyVNWlf0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z/3W3bhjj7XK4PbwYsTuwtiK0ZxJ9yhaxFVLLiwxLGC3ILlQwt+8HnfCNTqChNsx6
	 YWehXxVwp7lWtsVtdTHt9r3L+xAYGNser1Kw5UjqmbhexLZ/sBGVE/XunjwkQbp/pW
	 2D5DDZY5mm5nx7M4fQS2OPqx2ucDx2meObUwy3gG6EbmuXqZQATLGLe6a9VPh3OCUq
	 HPBaNzJId5oIXjDMB1azrWBXoX/Cm7jmxJDGwQuB79M6poJi+Q3Srjjy0GBqoiEfbX
	 1oyGG1Kd731PSLlhK37Q0bwdNx3ZI1CRbkA/EsTK6JR48LM+2EBtCH+xG3p0fy8oqi
	 w4YfF/ZenH6Kw==
Date: Sun, 31 Dec 2023 15:57:12 -0800
Subject: [PATCH 37/52] xfs_db: dump rt bitmap blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012659.1811243.17211113693049510150.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Now that rtbitmap blocks have a header, make it so that xfs_db can
analyze the structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bit.c           |   24 +++++++++++++++++++-----
 db/bit.h           |    1 +
 db/field.c         |    5 +++++
 db/field.h         |    4 ++++
 db/fprint.c        |   11 +++++++++--
 db/inode.c         |    6 ++++--
 db/rtgroup.c       |   34 ++++++++++++++++++++++++++++++++++
 db/rtgroup.h       |    3 +++
 db/type.c          |    5 +++++
 db/type.h          |    1 +
 include/xfs_arch.h |    6 ++++++
 11 files changed, 91 insertions(+), 9 deletions(-)


diff --git a/db/bit.c b/db/bit.c
index c9bfd2eb025..84f46290b5a 100644
--- a/db/bit.c
+++ b/db/bit.c
@@ -55,6 +55,7 @@ getbitval(
 	char		*p;
 	int64_t		rval;
 	int		signext;
+	bool		is_le = (flags & BV_LE);
 	int		z1, z2, z3, z4;
 
 	ASSERT(nbits<=64);
@@ -63,21 +64,34 @@ getbitval(
 	bit = bitoffs(bitoff);
 	signext = (flags & BVSIGNED) != 0;
 	z4 = ((intptr_t)p & 0xf) == 0 && bit == 0;
-	if (nbits == 64 && z4)
+	if (nbits == 64 && z4) {
+		if (is_le)
+			return le64_to_cpu(*(__be64 *)p);
 		return be64_to_cpu(*(__be64 *)p);
+	}
 	z3 = ((intptr_t)p & 0x7) == 0 && bit == 0;
 	if (nbits == 32 && z3) {
-		if (signext)
+		if (signext) {
+			if (is_le)
+				return (__s32)le32_to_cpu(*(__le32 *)p);
 			return (__s32)be32_to_cpu(*(__be32 *)p);
-		else
+		} else {
+			if (is_le)
+				return (__u32)le32_to_cpu(*(__le32 *)p);
 			return (__u32)be32_to_cpu(*(__be32 *)p);
+		}
 	}
 	z2 = ((intptr_t)p & 0x3) == 0 && bit == 0;
 	if (nbits == 16 && z2) {
-		if (signext)
+		if (signext) {
+			if (is_le)
+				return (__s16)le16_to_cpu(*(__le16 *)p);
 			return (__s16)be16_to_cpu(*(__be16 *)p);
-		else
+		} else {
+			if (is_le)
+				return (__u16)le16_to_cpu(*(__le16 *)p);
 			return (__u16)be16_to_cpu(*(__be16 *)p);
+		}
 	}
 	z1 = ((intptr_t)p & 0x1) == 0 && bit == 0;
 	if (nbits == 8 && z1) {
diff --git a/db/bit.h b/db/bit.h
index 4df86030abc..912283a7348 100644
--- a/db/bit.h
+++ b/db/bit.h
@@ -13,6 +13,7 @@
 
 #define	BVUNSIGNED	0
 #define	BVSIGNED	1
+#define	BV_LE		(1U << 1) /* little endian */
 
 extern int64_t		getbitval(void *obj, int bitoff, int nbits, int flags);
 extern void		setbitval(void *obuf, int bitoff, int nbits, void *ibuf);
diff --git a/db/field.c b/db/field.c
index cee5c661595..7dee8c3735c 100644
--- a/db/field.c
+++ b/db/field.c
@@ -392,6 +392,11 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_UINT8X, "uint8x", fp_num, "%#x", SI(bitsz(uint8_t)), 0, NULL,
 	  NULL },
 	{ FLDT_UUID, "uuid", fp_uuid, NULL, SI(bitsz(uuid_t)), 0, NULL, NULL },
+
+	{ FLDT_RTWORD, "rtword", fp_num, "%#x", SI(bitsz(xfs_rtword_t)),
+	  FTARG_LE, NULL, NULL },
+	{ FLDT_RGBITMAP, "rgbitmap", NULL, (char *)rgbitmap_flds, btblock_size,
+	  FTARG_SIZE, NULL, rgbitmap_flds },
 	{ FLDT_ZZZ, NULL }
 };
 
diff --git a/db/field.h b/db/field.h
index 226753490ad..ce7e7297afa 100644
--- a/db/field.h
+++ b/db/field.h
@@ -191,6 +191,9 @@ typedef enum fldt	{
 	FLDT_UINT8O,
 	FLDT_UINT8X,
 	FLDT_UUID,
+
+	FLDT_RTWORD,
+	FLDT_RGBITMAP,
 	FLDT_ZZZ			/* mark last entry */
 } fldt_t;
 
@@ -246,6 +249,7 @@ extern const ftattr_t	ftattrtab[];
 #define	FTARG_SIZE	16	/* size field is a function */
 #define	FTARG_SKIPNMS	32	/* skip printing names this time */
 #define	FTARG_OKEMPTY	64	/* ok if this (union type) is empty */
+#define FTARG_LE	(1U << 7) /* little endian */
 
 extern int		bitoffset(const field_t *f, void *obj, int startoff,
 				  int idx);
diff --git a/db/fprint.c b/db/fprint.c
index 65accfda3fe..ac916d511e8 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -68,13 +68,20 @@ fp_num(
 	int		bitpos;
 	int		i;
 	int		isnull;
+	int		bvflags = 0;
 	int64_t		val;
 
+	if (arg & FTARG_LE)
+		bvflags |= BV_LE;
+	if (arg & FTARG_SIGNED)
+		bvflags |= BVSIGNED;
+	else
+		bvflags |= BVUNSIGNED;
+
 	for (i = 0, bitpos = bit;
 	     i < count && !seenint();
 	     i++, bitpos += size) {
-		val = getbitval(obj, bitpos, size,
-			(arg & FTARG_SIGNED) ? BVSIGNED : BVUNSIGNED);
+		val = getbitval(obj, bitpos, size, bvflags);
 		if ((arg & FTARG_SKIPZERO) && val == 0)
 			continue;
 		isnull = (arg & FTARG_SIGNED) || size == 64 ?
diff --git a/db/inode.c b/db/inode.c
index 4e2be6a1156..5510b2cb663 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -642,9 +642,11 @@ inode_next_type(void)
 	case S_IFLNK:
 		return TYP_SYMLINK;
 	case S_IFREG:
-		if (iocur_top->ino == mp->m_sb.sb_rbmino)
+		if (iocur_top->ino == mp->m_sb.sb_rbmino) {
+			if (xfs_has_rtgroups(mp))
+				return TYP_RGBITMAP;
 			return TYP_RTBITMAP;
-		else if (iocur_top->ino == mp->m_sb.sb_rsumino)
+		} else if (iocur_top->ino == mp->m_sb.sb_rsumino)
 			return TYP_RTSUMMARY;
 		else if (iocur_top->ino == mp->m_sb.sb_uquotino ||
 			 iocur_top->ino == mp->m_sb.sb_gquotino ||
diff --git a/db/rtgroup.c b/db/rtgroup.c
index 4a719215d6a..a6cf98de0b8 100644
--- a/db/rtgroup.c
+++ b/db/rtgroup.c
@@ -54,6 +54,7 @@ const field_t	rtsb_flds[] = {
 	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
 	{ NULL }
 };
+#undef OFF
 
 const field_t	rtsb_hfld[] = {
 	{ "", FLDT_RTSB, OI(0), C1, 0, TYP_NONE },
@@ -113,3 +114,36 @@ rtsb_size(
 {
 	return bitize(mp->m_sb.sb_blocksize);
 }
+
+static int
+rtwords_count(
+	void			*obj,
+	int			startoff)
+{
+	unsigned int		blksz = mp->m_sb.sb_blocksize;
+
+	if (xfs_has_rtgroups(mp))
+		blksz -= sizeof(struct xfs_rtbuf_blkinfo);
+
+	return blksz >> XFS_WORDLOG;
+}
+
+#define	OFF(f)	bitize(offsetof(struct xfs_rtbuf_blkinfo, rt_ ## f))
+const field_t	rgbitmap_flds[] = {
+	{ "magicnum", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(owner)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	/* the rtword array is after the actual structure */
+	{ "rtwords", FLDT_RTWORD, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),
+	  rtwords_count, FLD_ARRAY | FLD_COUNT, TYP_DATA },
+	{ NULL }
+};
+#undef OFF
+
+const field_t	rgbitmap_hfld[] = {
+	{ "", FLDT_RGBITMAP, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
diff --git a/db/rtgroup.h b/db/rtgroup.h
index 85960a3fb9f..06f554e1862 100644
--- a/db/rtgroup.h
+++ b/db/rtgroup.h
@@ -9,6 +9,9 @@
 extern const struct field	rtsb_flds[];
 extern const struct field	rtsb_hfld[];
 
+extern const struct field	rgbitmap_flds[];
+extern const struct field	rgbitmap_hfld[];
+
 extern void	rtsb_init(void);
 extern int	rtsb_size(void *obj, int startoff, int idx);
 
diff --git a/db/type.c b/db/type.c
index d875c0c6365..65e7b24146f 100644
--- a/db/type.c
+++ b/db/type.c
@@ -67,6 +67,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_FINOBT, "finobt", handle_struct, finobt_hfld, NULL,
 		TYP_F_NO_CRC_OFF },
+	{ TYP_RGBITMAP, NULL },
 	{ TYP_NONE, NULL }
 };
 
@@ -113,6 +114,8 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_FINOBT, "finobt", handle_struct, finobt_crc_hfld,
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_RGBITMAP, "rgbitmap", handle_struct, rgbitmap_hfld,
+		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
@@ -159,6 +162,8 @@ static const typ_t	__typtab_spcrc[] = {
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_FINOBT, "finobt", handle_struct, finobt_spcrc_hfld,
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_RGBITMAP, "rgbitmap", handle_struct, rgbitmap_hfld,
+		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
diff --git a/db/type.h b/db/type.h
index d4efa4b0fab..e2148c6351d 100644
--- a/db/type.h
+++ b/db/type.h
@@ -35,6 +35,7 @@ typedef enum typnm
 	TYP_SYMLINK,
 	TYP_TEXT,
 	TYP_FINOBT,
+	TYP_RGBITMAP,
 	TYP_NONE
 } typnm_t;
 
diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index d46ae47094a..6312e62b0a1 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -200,6 +200,9 @@ static __inline__ void __swab64s(__u64 *addr)
 	((__force __le32)___constant_swab32((__u32)(val)))
 #define __constant_cpu_to_be32(val)	\
 	((__force __be32)(__u32)(val))
+
+#define le64_to_cpu(val)	(__swab64((__force __u64)(__le64)(val)))
+#define le16_to_cpu(val)	(__swab16((__force __u16)(__le16)(val)))
 #else
 #define cpu_to_be16(val)	((__force __be16)__swab16((__u16)(val)))
 #define cpu_to_be32(val)	((__force __be32)__swab32((__u32)(val)))
@@ -215,6 +218,9 @@ static __inline__ void __swab64s(__u64 *addr)
 	((__force __le32)(__u32)(val))
 #define __constant_cpu_to_be32(val)	\
 	((__force __be32)___constant_swab32((__u32)(val)))
+
+#define le64_to_cpu(val)	((__force __u64)(__le64)(val))
+#define le16_to_cpu(val)	((__force __u16)(__le16)(val))
 #endif
 
 static inline void be16_add_cpu(__be16 *a, __s16 b)

