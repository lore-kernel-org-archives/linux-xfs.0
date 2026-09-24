Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3749646AA6B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244456; cv=none; b=cIR91kXHJXmuv8bpPXraBoA9kzfn6Y9n5mZY5jst9xwpmKsN/7kz8v+YH554+AGkbykD3YTTn2e3t4KrApHB4pLgJ/YPBOhjOnCemZFfPwFcYVt2cttspV4qqGqbXjce4tUb7wzE6/FS4hCzjHVxysvwYnLNxuwJkkRY4hdyZbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244456; c=relaxed/simple;
	bh=ux0bUTe4sj19LCYAufqR0vFTZSlhiIit+MSRD2TySMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqhTR/CZJvevelRQsWOh/HJm3WJjG7lxL9Zy64ds+4iADhcqaTTFTTFGBneIlrp4s5EEhDN81Ps3e7/POLTWMdZtq8mwsCu7UUYkqIntg+mB2wosp2/Qfy9j8mLYEgUe8mV898oN4Kd2GPX4qqnn1I5mJeFK3/YUpIzYBvPCGxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GNzxpPyX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GNzxpPyX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5VVYO+vB8CpYLYnpkBxQ8XUj4SoE0eUcq73PAjeA2Ww=; b=GNzxpPyXzKyt2ijWsOvzOGJWLb
	TIALu8tWhNra54XJTxdQTNTxlUV8IZq3C6ZEAMHapeKzPQu+TEzvjFsQGBJRYPDDsgTnr0l7B0rd8
	bVWfvEL8Xh3EleSb1RvsuexFCOxXnCXohhSxPkLWYFSI8i3CqSNDRHJemYWW6poXjTmPfHYQah+JO
	SxJV65mguzl8b1fsUT/6j1o4OVmHQRmLG9sT/nUPQN80v24nUnntY2oLWommXTn+hMjVUhnooYb08
	gYnpTY4tZDMSgNsaN3Z87Y/ClmpgpZRAEIfJ0Jn8e8u9cJMegY392uX/Yc2jAmsk2hjjfgbpZtUBC
	cWfzM7XA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gMP-0000000AfZc-3m3r;
	Thu, 24 Sep 2026 10:07:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 30/32] xfs_db: support RT data checksum
Date: Thu, 24 Sep 2026 12:04:20 +0200
Message-ID: <20260924100512.2733748-31-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Support printing the new super block fields, and content of the per-RTG
rtcsum files.

Note that the superblock fields are printed for all metadir file systems
because they reuse space that previously was padding.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/block.c        | 10 +++++++++-
 db/field.c        |  2 ++
 db/field.h        |  1 +
 db/inode.c        |  2 ++
 db/rtgroup.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
 db/rtgroup.h      |  5 +++++
 db/sb.c           | 10 ++++++++--
 db/type.c         |  5 +++++
 db/type.h         |  1 +
 man/man8/xfs_db.8 | 13 ++++++++++++-
 10 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/db/block.c b/db/block.c
index 2f1978c41f30..c6dd50dfa764 100644
--- a/db/block.c
+++ b/db/block.c
@@ -263,7 +263,15 @@ dblock_f(
 		dbprintf(_("no type for file data\n"));
 		return 0;
 	}
-	nex = nb = type == TYP_DIR2 ? mp->m_dir_geo->fsbcount : 1;
+
+	if (type == TYP_DIR2)
+		nb = mp->m_dir_geo->fsbcount;
+	else if (type == TYP_RTCSUM)
+		nb = XFS_B_TO_FSB(mp, 1u << mp->m_sb.sb_rtcsum_blklog);
+	else
+		nb = 1;
+
+	nex = nb;
 	bmp = malloc(nb * sizeof(*bmp));
 	bmap(bno, nb, XFS_DATA_FORK, &nex, bmp);
 	if (nex == 0) {
diff --git a/db/field.c b/db/field.c
index 62c983fc3d49..275f175493df 100644
--- a/db/field.c
+++ b/db/field.c
@@ -441,6 +441,8 @@ const ftattr_t	ftattrtab[] = {
 	  0, NULL, NULL },
 	{ FLDT_RGSUMMARY, "rgsummary", NULL, (char *)rgsummary_flds,
 	  btblock_size, FTARG_SIZE, NULL, rgsummary_flds },
+	{ FLDT_RTCSUM, "rtcsum", NULL, (char *)rtcsum_flds,
+	  rtcsumblock_size, FTARG_SIZE, NULL, rtcsum_flds },
 
 	{ FLDT_ZZZ, NULL }
 };
diff --git a/db/field.h b/db/field.h
index 27df5a0fcd1b..77f84d55cb62 100644
--- a/db/field.h
+++ b/db/field.h
@@ -211,6 +211,7 @@ typedef enum fldt	{
 	FLDT_RGBITMAP,
 	FLDT_SUMINFO,
 	FLDT_RGSUMMARY,
+	FLDT_RTCSUM,
 
 	FLDT_ZZZ			/* mark last entry */
 } fldt_t;
diff --git a/db/inode.c b/db/inode.c
index 46f83f18f083..a77595427c56 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -727,6 +727,8 @@ inode_next_type(void)
 				return TYP_RTRMAPBT;
 			case XFS_METAFILE_RTREFCOUNT:
 				return TYP_RTREFCBT;
+			case XFS_METAFILE_RTCSUM:
+				return TYP_RTCSUM;
 			default:
 				return TYP_DATA;
 			}
diff --git a/db/rtgroup.c b/db/rtgroup.c
index c6b96c9dc79d..666adb2feb33 100644
--- a/db/rtgroup.c
+++ b/db/rtgroup.c
@@ -16,6 +16,8 @@
 #include "output.h"
 #include "init.h"
 #include "rtgroup.h"
+#include "libfrog/crc64.h"
+#include "xfs_rtcsumfile.h"
 
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
 
@@ -152,3 +154,43 @@ const field_t	rgsummary_hfld[] = {
 	{ "", FLDT_RGSUMMARY, OI(0), C1, 0, TYP_NONE },
 	{ NULL }
 };
+
+/*
+ * Get the size of a rtcsum block.
+ */
+int
+rtcsumblock_size(
+	void	*obj,
+	int	startoff,
+	int	idx)
+{
+	return bitize(1u << mp->m_sb.sb_rtcsum_blklog);
+}
+
+static int
+rtcsum_count(
+	void			*obj,
+	int			startoff)
+{
+	return xfs_rtcsum_payload_size(mp) >> mp->m_rtcsum_shift;
+}
+
+#define	OFF(f)	bitize(offsetof(struct xfs_rtbuf_blkinfo, rt_ ## f))
+const field_t rtcsum_flds[] = {
+	{ "magicnum", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(owner)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	/* the checksums are after the blkinfo structure */
+	{ "csums", FLDT_SUMINFO, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),
+	  rtcsum_count, FLD_ARRAY | FLD_COUNT, TYP_DATA },
+	{ NULL }
+};
+#undef OFF
+
+const field_t rtcsum_hfld[] = {
+	{ "", FLDT_RTCSUM, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
diff --git a/db/rtgroup.h b/db/rtgroup.h
index 5b120f2c9a29..b674154fcbad 100644
--- a/db/rtgroup.h
+++ b/db/rtgroup.h
@@ -15,6 +15,11 @@ extern const struct field	rgbitmap_hfld[];
 extern const struct field	rgsummary_flds[];
 extern const struct field	rgsummary_hfld[];
 
+extern const struct field	rtcsum_flds[];
+extern const struct field	rtcsum_hfld[];
+
+int rtcsumblock_size(void *obj, int startoff, int idx);
+
 extern void	rtsb_init(void);
 extern int	rtsb_size(void *obj, int startoff, int idx);
 
diff --git a/db/sb.c b/db/sb.c
index 666207145a86..c565e6535f63 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -144,8 +144,14 @@ const field_t	sb_flds[] = {
 		FLD_COUNT, TYP_NONE },
 	{ "pad", FLDT_UINT8X, OI(OFF(pad)), metadirfld_count,
 		FLD_COUNT, TYP_NONE },
-	{ "rtstart", FLDT_DRFSBNO, OI(OFF(rtstart)), zonedfld_count, FLD_COUNT, TYP_NONE },
-	{ "rtreserved", FLDT_UINT64D, OI(OFF(rtreserved)), zonedfld_count, FLD_COUNT, TYP_NONE },
+	{ "rtcsum_type", FLDT_UINT8D, OI(OFF(rtcsum_type)), metadirfld_count,
+		FLD_COUNT, TYP_NONE },
+	{ "rtcsum_blklog", FLDT_UINT8D, OI(OFF(rtcsum_blklog)), metadirfld_count,
+		FLD_COUNT, TYP_NONE },
+	{ "rtstart", FLDT_DRFSBNO, OI(OFF(rtstart)), zonedfld_count,
+		FLD_COUNT, TYP_NONE },
+	{ "rtreserved", FLDT_UINT64D, OI(OFF(rtreserved)), zonedfld_count,
+		FLD_COUNT, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/type.c b/db/type.c
index 324f416a49cc..2db5b5f6a54d 100644
--- a/db/type.c
+++ b/db/type.c
@@ -71,6 +71,7 @@ static const typ_t	__typtab[] = {
 		TYP_F_NO_CRC_OFF },
 	{ TYP_RGBITMAP, NULL },
 	{ TYP_RGSUMMARY, NULL },
+	{ TYP_RTCSUM, NULL },
 	{ TYP_NONE, NULL }
 };
 
@@ -125,6 +126,8 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
 		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
+	{ TYP_RTCSUM, "rtcsum", handle_struct, rtcsum_hfld,
+		&xfs_rtcsum_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
@@ -179,6 +182,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
 		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
+	{ TYP_RTCSUM, "rtcsum", handle_struct, rtcsum_hfld,
+		&xfs_rtcsum_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
diff --git a/db/type.h b/db/type.h
index a2488a663dbd..d95c83c78d17 100644
--- a/db/type.h
+++ b/db/type.h
@@ -39,6 +39,7 @@ typedef enum typnm
 	TYP_FINOBT,
 	TYP_RGBITMAP,
 	TYP_RGSUMMARY,
+	TYP_RTCSUM,
 	TYP_NONE
 } typnm_t;
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index c2d4065944be..ab89d709b89e 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1356,7 +1356,8 @@ The possible data types are:
 .BR agf ", " agfl ", " agi ", " attr ", " bmapbta ", " bmapbtd ,
 .BR bnobt ", " cntbt ", " data ", " dir ", " dir2 ", " dqblk ,
 .BR inobt ", " inode ", " log ", " refcntbt ", " rmapbt ", " rtbitmap ,
-.BR rtsummary ", " sb ", " symlink ", " rtrmapbt ", " rtrefcbt ", and " text .
+.BR rtsummary ", " sb ", " symlink ", " rtrmapbt ", " rtrefcbt ,
+.BR rtcsum ", and " text .
 See the TYPES section below for more information on these data types.
 .TP
 .BI "timelimit [" OPTIONS ]
@@ -2644,6 +2645,16 @@ The first dimension is the size range,
 the second dimension is the starting bitmap block number
 (adjacent entries are for the same size, adjacent bitmap blocks).
 .TP
+.B rtcsum
+For RT data-checksum enabled file systems, there is one data checksum file
+for each realtime group.  The data checksum file contains the standard
+RT block self-describing metadata header, and an array of the checksums
+for the realtime group.  The size of each entry depends on the checksum
+used: 4 bytes for
+.BR crc32c
+and 8 bytes for
+.BR crc64 .
+.TP
 .B sb
 There is one sb (superblock) structure per allocation group.
 It is the first disk block in the allocation group.
-- 
2.53.0

