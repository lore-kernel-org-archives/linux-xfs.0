Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6110F12BF18
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998976; cv=none; b=J7csM6Wdyi6h+WIaIUmHMFp1YJrRT7SCb3XRiV1+rkHOKwWrQptG7mQwN4SwNofScxzMpt38boMvnuD7q5ZgiOnGxLIU0i6YbwI8XRtxiw2nqOsfNFEprgGTXoRj1lKwIuDesAtDB+Ox+AyMcQjDKTGGDgrCYDDll9WMoJIDTks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998976; c=relaxed/simple;
	bh=nO4TmfvRjwfHglKYbjpy0Qg/7uYkkjdnObJ2lXjU614=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rq+JhHhL8aNTZor0i81lN0Ud9g3/en2WRRtuHKoE273xYWBljCdnfG4E9nchce7ncHix+BB5TVBHl5PTgEGBhP8CHZpi9e5m656XYAqKJaBUgbyC543miyLSBL/M0EQfplybaH3yQRGZQ18iNlVJLSeNdwHlkFiQ/3F4pBGnstg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vl6vACbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vl6vACbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C5AC433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998976;
	bh=nO4TmfvRjwfHglKYbjpy0Qg/7uYkkjdnObJ2lXjU614=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Vl6vACbsANbxO+LbmAnN9QY2r26XCAvWEQKO52Ug9tG7R6repPrUYGafroJtuy/QZ
	 /qOBz4IwQ6ekJTv2CbkCorKLdE6w3vRrLeMYSK4VLsuepYfW1p3bIfsIVZXDpBkQTb
	 xSpDTM5iJlFxGTPVPCOVIEvb5Ve3Cc+XWv9vAycnRMgUojA0zHDf/Xg+GC49hmb9ky
	 oagHA1dlEnh5nC/hT1hu1J2uXaIkEUXMKcnyhyeCiSfwF1ZJQpxrQw0jnFeij7Lxo6
	 SOMrXxmYaVhngb2/9jTKYzG09RS86HrUxMQoyH0dBN2rRc+JGyebLYi5ju1VWZN8tI
	 FKSFPvJtVyfog==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 20/35] xfs: convert rt summary macros to helpers
Date: Thu, 15 Feb 2024 13:08:32 +0100
Message-ID: <20240215120907.1542854-21-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 097b4b7b64ef67a4703b89fd4064480b61557fd5

Convert the realtime summary file macros to helper functions so that we
can improve type checking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 db/check.c            |  5 ++--
 include/libxfs.h      |  1 +
 libxfs/xfs_format.h   |  9 +-------
 libxfs/xfs_rtbitmap.c | 10 ++++----
 libxfs/xfs_rtbitmap.h | 53 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_types.h    |  2 ++
 repair/rt.c           |  5 ++--
 7 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/db/check.c b/db/check.c
index fdf1f6a1e..9d5576c33 100644
--- a/db/check.c
+++ b/db/check.c
@@ -20,6 +20,7 @@
 #include "init.h"
 #include "malloc.h"
 #include "dir2.h"
+#include "xfs_rtbitmap.h"
 
 typedef enum {
 	IS_USER_QUOTA, IS_PROJECT_QUOTA, IS_GROUP_QUOTA,
@@ -3648,7 +3649,7 @@ process_rtbitmap(
 				len = ((int)bmbno - start_bmbno) *
 					bitsperblock + (bit - start_bit);
 				log = XFS_RTBLOCKLOG(len);
-				offs = XFS_SUMOFFS(mp, log, start_bmbno);
+				offs = xfs_rtsumoffs(mp, log, start_bmbno);
 				sumcompute[offs]++;
 				prevbit = 0;
 			}
@@ -3661,7 +3662,7 @@ process_rtbitmap(
 		len = ((int)bmbno - start_bmbno) * bitsperblock +
 			(bit - start_bit);
 		log = XFS_RTBLOCKLOG(len);
-		offs = XFS_SUMOFFS(mp, log, start_bmbno);
+		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		sumcompute[offs]++;
 	}
 }
diff --git a/include/libxfs.h b/include/libxfs.h
index 486566391..9cec394ca 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -44,6 +44,7 @@ struct iomap;
 #define __round_mask(x, y) ((__typeof__(x))((y)-1))
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define unlikely(x) (x)
+#define likely(x) (x)
 
 /*
  * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index ac6dd1023..d48e3a395 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1144,15 +1144,8 @@ static inline bool xfs_dinode_has_large_extent_counts(
 #define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
 
 /*
- * RT Summary and bit manipulation macros.
+ * RT bit manipulation macros.
  */
-#define	XFS_SUMOFFS(mp,ls,bb)	((int)((ls) * (mp)->m_sb.sb_rbmblocks + (bb)))
-#define	XFS_SUMOFFSTOBLOCK(mp,s)	\
-	(((s) * (uint)sizeof(xfs_suminfo_t)) >> (mp)->m_sb.sb_blocklog)
-#define	XFS_SUMPTR(mp,bp,so)	\
-	((xfs_suminfo_t *)((bp)->b_addr + \
-		(((so) * (uint)sizeof(xfs_suminfo_t)) & XFS_BLOCKMASK(mp))))
-
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index fce88c759..c635e8c2e 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -453,17 +453,18 @@ xfs_rtmodify_summary_int(
 	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
 	xfs_fileoff_t	sb;		/* summary fsblock */
-	int		so;		/* index into the summary file */
+	xfs_rtsumoff_t	so;		/* index into the summary file */
 	xfs_suminfo_t	*sp;		/* pointer to returned data */
+	unsigned int	infoword;
 
 	/*
 	 * Compute entry number in the summary file.
 	 */
-	so = XFS_SUMOFFS(mp, log, bbno);
+	so = xfs_rtsumoffs(mp, log, bbno);
 	/*
 	 * Compute the block number in the summary file.
 	 */
-	sb = XFS_SUMOFFSTOBLOCK(mp, so);
+	sb = xfs_rtsumoffs_to_block(mp, so);
 	/*
 	 * If we have an old buffer, and the block number matches, use that.
 	 */
@@ -491,7 +492,8 @@ xfs_rtmodify_summary_int(
 	/*
 	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
-	sp = XFS_SUMPTR(mp, bp, so);
+	infoword = xfs_rtsumoffs_to_infoword(mp, so);
+	sp = xfs_rsumblock_infoptr(bp, infoword);
 	if (delta) {
 		uint first = (uint)((char *)sp - (char *)bp->b_addr);
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 3252ed217..167ea6a08 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -6,6 +6,9 @@
 #ifndef __XFS_RTBITMAP_H__
 #define	__XFS_RTBITMAP_H__
 
+/* For userspace XFS_RT is always defined */
+#define CONFIG_XFS_RT
+
 static inline xfs_rtblock_t
 xfs_rtx_to_rtb(
 	struct xfs_mount	*mp,
@@ -169,6 +172,56 @@ xfs_rbmblock_wordptr(
 	return words + index;
 }
 
+/*
+ * Convert a rt extent length and rt bitmap block number to a xfs_suminfo_t
+ * offset within the rt summary file.
+ */
+static inline xfs_rtsumoff_t
+xfs_rtsumoffs(
+	struct xfs_mount	*mp,
+	int			log2_len,
+	xfs_fileoff_t		rbmoff)
+{
+	return log2_len * mp->m_sb.sb_rbmblocks + rbmoff;
+}
+
+/*
+ * Convert an xfs_suminfo_t offset to a file block offset within the rt summary
+ * file.
+ */
+static inline xfs_fileoff_t
+xfs_rtsumoffs_to_block(
+	struct xfs_mount	*mp,
+	xfs_rtsumoff_t		rsumoff)
+{
+	return XFS_B_TO_FSBT(mp, rsumoff * sizeof(xfs_suminfo_t));
+}
+
+/*
+ * Convert an xfs_suminfo_t offset to an info word offset within an rt summary
+ * block.
+ */
+static inline unsigned int
+xfs_rtsumoffs_to_infoword(
+	struct xfs_mount	*mp,
+	xfs_rtsumoff_t		rsumoff)
+{
+	unsigned int		mask = mp->m_blockmask >> XFS_SUMINFOLOG;
+
+	return rsumoff & mask;
+}
+
+/* Return a pointer to a summary info word within a rt summary block. */
+static inline xfs_suminfo_t *
+xfs_rsumblock_infoptr(
+	struct xfs_buf		*bp,
+	unsigned int		index)
+{
+	xfs_suminfo_t		*info = bp->b_addr;
+
+	return info + index;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index c78237852..533200c4c 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -19,6 +19,7 @@ typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
 typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
+typedef uint32_t	xfs_rtsumoff_t;	/* offset of an rtsummary info word */
 typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
 
 typedef int64_t		xfs_lsn_t;	/* log sequence number */
@@ -149,6 +150,7 @@ typedef uint32_t	xfs_dqid_t;
  */
 #define	XFS_NBBYLOG	3		/* log2(NBBY) */
 #define	XFS_WORDLOG	2		/* log2(sizeof(xfs_rtword_t)) */
+#define	XFS_SUMINFOLOG	2		/* log2(sizeof(xfs_suminfo_t)) */
 #define	XFS_NBWORDLOG	(XFS_NBBYLOG + XFS_WORDLOG)
 #define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
 #define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
diff --git a/repair/rt.c b/repair/rt.c
index a4cca7aa2..abe58b569 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -13,6 +13,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "rt.h"
+#include "xfs_rtbitmap.h"
 
 #define xfs_highbit64 libxfs_highbit64	/* for XFS_RTBLOCKLOG macro */
 
@@ -91,7 +92,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 			} else if (in_extent == 1) {
 				len = (int) (extno - start_ext);
 				log = XFS_RTBLOCKLOG(len);
-				offs = XFS_SUMOFFS(mp, log, start_bmbno);
+				offs = xfs_rtsumoffs(mp, log, start_bmbno);
 				sumcompute[offs]++;
 				in_extent = 0;
 			}
@@ -107,7 +108,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 	if (in_extent == 1) {
 		len = (int) (extno - start_ext);
 		log = XFS_RTBLOCKLOG(len);
-		offs = XFS_SUMOFFS(mp, log, start_bmbno);
+		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		sumcompute[offs]++;
 	}
 
-- 
2.43.0

