Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1BB17E0
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530415; cv=none; b=gQ4fnw1M2wF6FzCIULFJR9Ws+Zr75cEIVpJcGsAkyf/1lF6Ygwc5yBpL917ht1MsnOD675B9UxsabkExknTXPyq5du1Ue8Klet9uHrV+CS8JbbfwKfPoDEnzOHjRm440Tcdc6+B40P2jE4S9dLMFvyowLl7IMmSfkPmSYSmHhM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530415; c=relaxed/simple;
	bh=3ey4M8dc7EhRB94eOd0SC4pJ7ZRpxn/p5QJwl/wy7iY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pA5RFF9lAKLQpZlSolUtAEeyeMTyGdTJUyewp9s+ks6pv9tjuTpn9Bnq1MSiA96/jy/sDM7A1gw45W7o7A6rl1Nn+3dCuI51g6VRX6GrCfr25wJJB0lBDGkVrhCvT8jptFr+yC4o6dC6dl2PQ75Fs7V5MFqtRc8cxEC5JLIEsVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exI9ue0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exI9ue0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8196DC4CED1;
	Sat,  7 Dec 2024 00:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530414;
	bh=3ey4M8dc7EhRB94eOd0SC4pJ7ZRpxn/p5QJwl/wy7iY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=exI9ue0EjDmo2yqiWGMzdd/0ePI+M9s8hK+6QMKYw8iFih/4AX+S5UIChs9NL2AMd
	 Oxgu15IUEp/6UkmMIZx/SEKzI40Z2g/5iWf0Jppf7xcwTOy01yZkguVMzud+gEFhvv
	 zepKg+R4tAu188w+z+Q71oJi7G/wUnaGU8Z7ePQFOeQUUseRH4/gOj6Z2r7upvZ6mc
	 TC1oOTbieyy9MsU2bovKy/iBklw5D/QQYc9sNn6kWTafVKHm0obKvroUx2KJSqSy18
	 zO7UOtWbavYSGcHfgToURv6K18NZz+1KsubStYEp9rj8PCd9zJNhfaKmwcV3Jc2d5v
	 8tZ0+D8awD32w==
Date: Fri, 06 Dec 2024 16:13:34 -0800
Subject: [PATCH 33/50] xfs_db: dump rt bitmap blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752449.126362.12190261909488631960.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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
 

