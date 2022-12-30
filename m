Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96E5C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbiLaCik (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbiLaCik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:38:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE38C760
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87AD2B81E00
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ED9C433EF;
        Sat, 31 Dec 2022 02:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454316;
        bh=98a8o8At1AaincSMyMSjH8g0uUZ5tY4rnV42YUuCVDs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KbnuRHazInuaXPTM6p2863CmuBZvvgbLfRbzSTQoqB8K2172rdEbdSdALm5pZlSIL
         VKkiiAHrX3QF0ouwwxNhpkuZOE/yYUemSY2eJ+1pgv41qEmzmKggmUpH17wsOsyKi6
         CxyKoGtna27nQHDloaKzarMaLCDGYSr3s52peLui6Mk8EyJNdfUWbnN+0A5VjLtUoe
         6kL3Lhg7PIZbaPKwkea2wrK0M7whFXFzp7Ub2FDgF6nWD7BB2K7jil5kI/LwIfdMkX
         hyhv/8uyRFJ5N9ahCbYD+0ST2XO4W+TOFtGz53A0+lOzEc5c/C+zRR2sUK6sTIwhs2
         XK2ZsbtrBOLog==
Subject: [PATCH 33/45] xfs_db: dump rt bitmap blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878798.731133.13215106479704174262.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 4c2fd19f446..663487f8b14 100644
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
index c4debc1d394..350677d4687 100644
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
index 49077bee141..3c9b16146fc 100644
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

