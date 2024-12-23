Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591CA188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992407; cv=none; b=e+BzWtBJvEqiU/aRkrRuBM8q4U2Pc4t1jP28Eyqm7pymdD+e+o1QplCH60yXUs6uoUGo5F8rwpniUMggQy6VHdmqNTA7NVs9LWnAnQ5+Bd02Tru6cYlBz+3BE83oYZDhOug4HyxEPuxf58rsRuz9Lgmzn8kunsVEYJ5bwGYtx3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992407; c=relaxed/simple;
	bh=PEZ2ky32n9Js0ZUsb23cHLS4beIPw4po4MONvRTJ0tI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OQrbGmgHAbG5jgd0j3zZ2VLnnewVW+DWXpVLkG0+J/Vprml7eowwPdPyWg7BYD+LWTEXxDyAMU1MgqPmnqMo3wbGghdoFGHpzsj4nv2xmQVpccHlbycHqN6sn1PrTev+wRT8nyHI+U0d3X9QnxEp3ZDhPQoO/2mNgXfbsZELVlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPLdEmBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPLdEmBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0079FC4CEE5;
	Mon, 23 Dec 2024 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992407;
	bh=PEZ2ky32n9Js0ZUsb23cHLS4beIPw4po4MONvRTJ0tI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aPLdEmBNaBu+2/RS6wFCspA2p4XsLkFRsGKTapI8KyxS+1waKPq9IY+YGA3t4eCFI
	 5gAAlht6ePJLdJI7ez+Z5CkdpOApGfrStDgtDb/EbWaaCoGFN7yMyUOVPuPp9ByZBU
	 TYo6SMEchyb1yUk83uBXnEQqSrLUPqjvGQfWRuu0Gx9qmFysTx+SCrRu4pCZHvzeGb
	 tdgkPXliSlOoq+ICPy27u6vC60e0JrvL1JQY4DHcUI3UKSWNX1UahideCyj3CzsIru
	 LM3V1NUi75lITax25NxlPhyT3NMawq9O3q3cpVZ/KoK6DehJCvKuxaKUAs7YRvueJf
	 jO1FRsEF4JU7Q==
Date: Mon, 23 Dec 2024 14:20:06 -0800
Subject: [PATCH 32/51] xfs_db: dump rt bitmap blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944293.2297565.14382052320051831234.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 07efbb4902be08..d3207510c28265 100644
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
 

