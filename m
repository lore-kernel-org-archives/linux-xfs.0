Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7C3C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Blq0RVRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDA8C433C7;
	Sun, 31 Dec 2023 23:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067048;
	bh=l7Mom3IVhH9Em0ysT3xgOkjlgLPgUWS0dFMccaF32lY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Blq0RVRyeWnTretILL85b7R67KqMypDIIHFDfAmVDBIMpWlLnmw2Zk8HeFNgIxa9C
	 Bz8APrfBwsdYAa1DANt0MK69Z5soX3bKjdrgfPCpWzENcchFsXKgZKQ3wodB+G+/KA
	 kTEqLlN0rAwQd/vUCK9WbiO+RssWpzKxudc42VMdlDloduJM0+2bWRB0OV4ZpZioxK
	 AG/MOBLVJKa6/k/q1IydHr5PhsGwFRM55fymW6cf8AKX4x1UWtt806ASuW78Bo9L9l
	 wQJ1JaDVREKscThVQP4zazd+TlQMgvYmD/tXdmiOwqrmw6uZg58yXzmceKDUA+7ahe
	 mvRakIvxWzBXQ==
Date: Sun, 31 Dec 2023 15:57:28 -0800
Subject: [PATCH 38/52] xfs_db: dump rt summary blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012672.1811243.12239088954752934851.stgit@frogsfrogsfrogs>
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

Now that rtsummary blocks have a header, make it so that xfs_db can
analyze the structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/field.c   |    5 +++++
 db/field.h   |    3 +++
 db/inode.c   |    5 ++++-
 db/rtgroup.c |   20 ++++++++++++++++++++
 db/rtgroup.h |    3 +++
 db/type.c    |    5 +++++
 db/type.h    |    1 +
 7 files changed, 41 insertions(+), 1 deletion(-)


diff --git a/db/field.c b/db/field.c
index 7dee8c3735c..4a6a4cf51c3 100644
--- a/db/field.c
+++ b/db/field.c
@@ -397,6 +397,11 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_LE, NULL, NULL },
 	{ FLDT_RGBITMAP, "rgbitmap", NULL, (char *)rgbitmap_flds, btblock_size,
 	  FTARG_SIZE, NULL, rgbitmap_flds },
+	{ FLDT_SUMINFO, "suminfo", fp_num, "%u", SI(bitsz(xfs_suminfo_t)),
+	  0, NULL, NULL },
+	{ FLDT_RGSUMMARY, "rgsummary", NULL, (char *)rgsummary_flds,
+	  btblock_size, FTARG_SIZE, NULL, rgsummary_flds },
+
 	{ FLDT_ZZZ, NULL }
 };
 
diff --git a/db/field.h b/db/field.h
index ce7e7297afa..e9c6142f282 100644
--- a/db/field.h
+++ b/db/field.h
@@ -194,6 +194,9 @@ typedef enum fldt	{
 
 	FLDT_RTWORD,
 	FLDT_RGBITMAP,
+	FLDT_SUMINFO,
+	FLDT_RGSUMMARY,
+
 	FLDT_ZZZ			/* mark last entry */
 } fldt_t;
 
diff --git a/db/inode.c b/db/inode.c
index 5510b2cb663..16033c5ab79 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -646,8 +646,11 @@ inode_next_type(void)
 			if (xfs_has_rtgroups(mp))
 				return TYP_RGBITMAP;
 			return TYP_RTBITMAP;
-		} else if (iocur_top->ino == mp->m_sb.sb_rsumino)
+		} else if (iocur_top->ino == mp->m_sb.sb_rsumino) {
+			if (xfs_has_rtgroups(mp))
+				return TYP_RGSUMMARY;
 			return TYP_RTSUMMARY;
+		}
 		else if (iocur_top->ino == mp->m_sb.sb_uquotino ||
 			 iocur_top->ino == mp->m_sb.sb_gquotino ||
 			 iocur_top->ino == mp->m_sb.sb_pquotino)
diff --git a/db/rtgroup.c b/db/rtgroup.c
index a6cf98de0b8..52d7c0cd378 100644
--- a/db/rtgroup.c
+++ b/db/rtgroup.c
@@ -147,3 +147,23 @@ const field_t	rgbitmap_hfld[] = {
 	{ "", FLDT_RGBITMAP, OI(0), C1, 0, TYP_NONE },
 	{ NULL }
 };
+
+#define	OFF(f)	bitize(offsetof(struct xfs_rtbuf_blkinfo, rt_ ## f))
+const field_t	rgsummary_flds[] = {
+	{ "magicnum", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(owner)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	/* the suminfo array is after the actual structure */
+	{ "suminfo", FLDT_SUMINFO, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),
+	  rtwords_count, FLD_ARRAY | FLD_COUNT, TYP_DATA },
+	{ NULL }
+};
+#undef OFF
+
+const field_t	rgsummary_hfld[] = {
+	{ "", FLDT_RGSUMMARY, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
diff --git a/db/rtgroup.h b/db/rtgroup.h
index 06f554e1862..5b120f2c9a2 100644
--- a/db/rtgroup.h
+++ b/db/rtgroup.h
@@ -12,6 +12,9 @@ extern const struct field	rtsb_hfld[];
 extern const struct field	rgbitmap_flds[];
 extern const struct field	rgbitmap_hfld[];
 
+extern const struct field	rgsummary_flds[];
+extern const struct field	rgsummary_hfld[];
+
 extern void	rtsb_init(void);
 extern int	rtsb_size(void *obj, int startoff, int idx);
 
diff --git a/db/type.c b/db/type.c
index 65e7b24146f..2091b4ac8b1 100644
--- a/db/type.c
+++ b/db/type.c
@@ -68,6 +68,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_FINOBT, "finobt", handle_struct, finobt_hfld, NULL,
 		TYP_F_NO_CRC_OFF },
 	{ TYP_RGBITMAP, NULL },
+	{ TYP_RGSUMMARY, NULL },
 	{ TYP_NONE, NULL }
 };
 
@@ -116,6 +117,8 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RGBITMAP, "rgbitmap", handle_struct, rgbitmap_hfld,
 		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
+	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
+		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
@@ -164,6 +167,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RGBITMAP, "rgbitmap", handle_struct, rgbitmap_hfld,
 		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
+	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
+		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
diff --git a/db/type.h b/db/type.h
index e2148c6351d..e7f0ecc1768 100644
--- a/db/type.h
+++ b/db/type.h
@@ -36,6 +36,7 @@ typedef enum typnm
 	TYP_TEXT,
 	TYP_FINOBT,
 	TYP_RGBITMAP,
+	TYP_RGSUMMARY,
 	TYP_NONE
 } typnm_t;
 

