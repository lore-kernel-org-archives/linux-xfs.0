Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563DC17BCA
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610281; cv=none; b=p/wD8fZ3JFZzD3+BYBX9YlyqgRfnMENlJ7uKteN71W/TDAtzCS6JTs+saTi+1XKCPt08kjdwQBx6xvycaaqLlWi1KjW1ZWc7xIOWJbDVyLavzV1gvMD4ZJP7ZsrFIYobq71glvRykObQuvPyxZ7ZDvkKQBRyvA+CSdzQdF/HxtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610281; c=relaxed/simple;
	bh=vFhkiublCqf2G9aqEaQ1+dyUfnyvq8/NyR2COfZN6ZQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DJcYRGv0LDeu6WTyNnOmio3aVXuIb5LRjAXHaYym7bB3oX4oVi0VRjt00/yLHSd8+cPFAkGBlrkX5YhrTa3vtCE+vKlv1U+IEjv/XNrGNUjpBe3yrvNYIltICVOzUoDX28dA3zSfn9Gwoc01ULN+LCdqsjEMbS/9BSQJQd68Gu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJzac9ZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJzac9ZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26B3C4CEC5;
	Fri, 11 Oct 2024 01:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610280;
	bh=vFhkiublCqf2G9aqEaQ1+dyUfnyvq8/NyR2COfZN6ZQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BJzac9ZRRIbAYztq/sTEh/POetdYAaZQVLc/5QUe4tIdxQEnFnv8Kg6apI+TcR2wD
	 +/gQLD5umJ5upiY7PSeO/qxjytDHJ2oqm01hqj9kCrD9DsasUaBu7VQoSgDNk3xMmk
	 ew9t/a7cLYtlkjsP+8RBrloBoUbheHv81eOt7iI0JKvQA2LFgWJ6pGn1HCbInXbahD
	 jdbiydsZVnNowExEmK3JedgMllcK2OwZRXW1c/jTri1ohvD716cRH5GiGL39ns6R2D
	 3OwZlJYmUNP6xopk3ZorulRWAExC2QPjv+dVhrfHK064hUImCuPYgKAIjhArK5RvL7
	 v4KgarEc/EunA==
Date: Thu, 10 Oct 2024 18:31:20 -0700
Subject: [PATCH 26/43] xfs_db: dump rt bitmap blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655765.4184637.13261131709242863199.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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
 db/field.c   |    6 ++++++
 db/field.h   |    3 +++
 db/inode.c   |   34 +++++++++++++++++++++++++---------
 db/rtgroup.c |   34 ++++++++++++++++++++++++++++++++++
 db/rtgroup.h |    3 +++
 db/type.c    |    5 +++++
 db/type.h    |    1 +
 7 files changed, 77 insertions(+), 9 deletions(-)


diff --git a/db/field.c b/db/field.c
index f70955ef57a323..ad1ccb9877aca5 100644
--- a/db/field.c
+++ b/db/field.c
@@ -406,6 +406,12 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_UUID, "uuid", fp_uuid, NULL, SI(bitsz(uuid_t)), 0, NULL, NULL },
 	{ FLDT_PARENT_REC, "parent", NULL, (char *)parent_flds,
 	  SI(bitsz(struct xfs_parent_rec)), 0, NULL, parent_flds },
+
+	{ FLDT_RTWORD, "rtword", fp_num, "%#x", SI(bitsz(xfs_rtword_t)),
+	  0, NULL, NULL },
+	{ FLDT_RGBITMAP, "rgbitmap", NULL, (char *)rgbitmap_flds, btblock_size,
+	  FTARG_SIZE, NULL, rgbitmap_flds },
+
 	{ FLDT_ZZZ, NULL }
 };
 
diff --git a/db/field.h b/db/field.h
index 8797a75f669246..aace89c90d79eb 100644
--- a/db/field.h
+++ b/db/field.h
@@ -196,6 +196,9 @@ typedef enum fldt	{
 
 	FLDT_PARENT_REC,
 
+	FLDT_RTWORD,
+	FLDT_RGBITMAP,
+
 	FLDT_ZZZ			/* mark last entry */
 } fldt_t;
 
diff --git a/db/inode.c b/db/inode.c
index 8a7c665bdb54f3..0ecfdd18058c79 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -705,16 +705,32 @@ inode_next_type(void)
 	case S_IFLNK:
 		return TYP_SYMLINK;
 	case S_IFREG:
-		if (iocur_top->ino == mp->m_sb.sb_rbmino)
-			return TYP_RTBITMAP;
-		else if (iocur_top->ino == mp->m_sb.sb_rsumino)
-			return TYP_RTSUMMARY;
-		else if (iocur_top->ino == mp->m_sb.sb_uquotino ||
-			 iocur_top->ino == mp->m_sb.sb_gquotino ||
-			 iocur_top->ino == mp->m_sb.sb_pquotino)
+		if (xfs_has_rtgroups(mp)) {
+			struct xfs_dinode	*dic = iocur_top->data;
+
+			switch (be16_to_cpu(dic->di_metatype)) {
+			case XFS_METAFILE_USRQUOTA:
+			case XFS_METAFILE_GRPQUOTA:
+			case XFS_METAFILE_PRJQUOTA:
+				return TYP_DQBLK;
+			case XFS_METAFILE_RTBITMAP:
+				return TYP_RGBITMAP;
+			default:
+				return TYP_DATA;
+			}
+		} else {
+			if (iocur_top->ino == mp->m_sb.sb_rbmino)
+				return TYP_RTBITMAP;
+			if (iocur_top->ino == mp->m_sb.sb_rsumino)
+				return TYP_RTSUMMARY;
+		}
+
+		if (iocur_top->ino == mp->m_sb.sb_uquotino ||
+		    iocur_top->ino == mp->m_sb.sb_gquotino ||
+		    iocur_top->ino == mp->m_sb.sb_pquotino)
 			return TYP_DQBLK;
-		else
-			return TYP_DATA;
+
+		return TYP_DATA;
 	default:
 		return TYP_NONE;
 	}
diff --git a/db/rtgroup.c b/db/rtgroup.c
index 5cda1a4f35efb6..3ef2dc8fe7f031 100644
--- a/db/rtgroup.c
+++ b/db/rtgroup.c
@@ -44,6 +44,7 @@ const field_t	rtsb_flds[] = {
 	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
 	{ NULL }
 };
+#undef OFF
 
 const field_t	rtsb_hfld[] = {
 	{ "", FLDT_RTSB, OI(0), C1, 0, TYP_NONE },
@@ -98,3 +99,36 @@ rtsb_size(
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
index 85960a3fb9f5c9..06f554e1862851 100644
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
index d875c0c636553b..65e7b24146f170 100644
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
index d4efa4b0fab541..e2148c6351d141 100644
--- a/db/type.h
+++ b/db/type.h
@@ -35,6 +35,7 @@ typedef enum typnm
 	TYP_SYMLINK,
 	TYP_TEXT,
 	TYP_FINOBT,
+	TYP_RGBITMAP,
 	TYP_NONE
 } typnm_t;
 

