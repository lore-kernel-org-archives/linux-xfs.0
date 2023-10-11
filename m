Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED37CDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjJKSHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbjJKSHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:07:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A392F9D
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:07:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427EEC433C8;
        Wed, 11 Oct 2023 18:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047637;
        bh=ppalEeIl1klPvIK4JBWKILui/AogkdiIbVbquqBxqF8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XNJDqmZddsFVgKEkuRoJBnoACHSG669sGiv7Q/r4VkgJDJ8m0125tRvjB9S16mU9H
         oDM/IWHi5d8xGc4xwSvUQpbzoGkebH3aCxHjZTMx4H7q4K0aPpXN4JkyP1+nyVCNgw
         mMWOzMvjHPPxbdfsaAMXvp0kwEsDyWzJde172Kza0qvgZ5eDIN/wVGpAmzePw8svwz
         zNB6LDK0ZICL/X7LXApTTSeyNvAYmflb0Mx7h1kI6y37eAo1jjIt2aYy6fkCFLhzoF
         X+JSeunEANTbwafHPfkTKjKVuE44VNP8DrfOd9+yYOaLj7dWY3VNSO0PqTLnqSW6yO
         cbr/9yb10p1PQ==
Date:   Wed, 11 Oct 2023 11:07:16 -0700
Subject: [PATCH 4/8] xfs: convert rt summary macros to helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721691.1773834.17832208803682880210.stgit@frogsfrogsfrogs>
In-Reply-To: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the realtime summary file macros to helper functions so that we
can improve type checking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h      |    9 +-----
 fs/xfs/libxfs/xfs_rtbitmap.c    |   10 ++++---
 fs/xfs/libxfs/xfs_rtbitmap.h    |   59 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h       |    2 +
 fs/xfs/scrub/rtsummary.c        |   16 ++++++-----
 fs/xfs/scrub/rtsummary.h        |    4 +--
 fs/xfs/scrub/rtsummary_repair.c |    7 +++--
 7 files changed, 83 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dff9e654087b9..1254834ab5c9e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1215,15 +1215,8 @@ static inline bool xfs_dinode_has_large_extent_counts(
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
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 231622a5ab681..b6a1d240c5545 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -462,17 +462,18 @@ xfs_rtmodify_summary_int(
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
@@ -500,7 +501,8 @@ xfs_rtmodify_summary_int(
 	/*
 	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
-	sp = XFS_SUMPTR(mp, bp, so);
+	infoword = xfs_rtsumoffs_to_infoword(mp, so);
+	sp = xfs_rsumblock_infoptr(bp, infoword);
 	if (delta) {
 		uint first = (uint)((char *)sp - (char *)bp->b_addr);
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index af37afec2b010..f616956b28911 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -141,6 +141,65 @@ xfs_rbmblock_wordptr(
 	return xfs_rbmbuf_wordptr(bp->b_addr, rbmword);
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
+/* Return a pointer to a summary info word within a rt summary block buffer. */
+static inline xfs_suminfo_t *
+xfs_rsumbuf_infoptr(
+	void			*buf,
+	unsigned int		infoword)
+{
+	xfs_suminfo_t		*infop = buf;
+
+	return &infop[infoword];
+}
+
+/* Return a pointer to a summary info word within a rt summary block. */
+static inline xfs_suminfo_t *
+xfs_rsumblock_infoptr(
+	struct xfs_buf		*bp,
+	unsigned int		infoword)
+{
+	return xfs_rsumbuf_infoptr(bp->b_addr, infoword);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index abb07a1c7b0b4..f4615c5be34f2 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -19,6 +19,7 @@ typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
 typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
+typedef uint32_t	xfs_rtsumoff_t;	/* offset of an rtsummary info word */
 typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
 
 typedef int64_t		xfs_lsn_t;	/* log sequence number */
@@ -151,6 +152,7 @@ typedef uint32_t	xfs_dqid_t;
  */
 #define	XFS_NBBYLOG	3		/* log2(NBBY) */
 #define	XFS_WORDLOG	2		/* log2(sizeof(xfs_rtword_t)) */
+#define	XFS_SUMINFOLOG	2		/* log2(sizeof(xfs_suminfo_t)) */
 #define	XFS_NBWORDLOG	(XFS_NBBYLOG + XFS_WORDLOG)
 #define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
 #define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 5d0b9980ea810..901696c593dc9 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -93,7 +93,7 @@ xchk_setup_rtsummary(
 static inline int
 xfsum_load(
 	struct xfs_scrub	*sc,
-	xchk_rtsumoff_t		sumoff,
+	xfs_rtsumoff_t		sumoff,
 	xfs_suminfo_t		*info)
 {
 	return xfile_obj_load(sc->xfile, info, sizeof(xfs_suminfo_t),
@@ -103,7 +103,7 @@ xfsum_load(
 static inline int
 xfsum_store(
 	struct xfs_scrub	*sc,
-	xchk_rtsumoff_t		sumoff,
+	xfs_rtsumoff_t		sumoff,
 	const xfs_suminfo_t	info)
 {
 	return xfile_obj_store(sc->xfile, &info, sizeof(xfs_suminfo_t),
@@ -113,7 +113,7 @@ xfsum_store(
 inline int
 xfsum_copyout(
 	struct xfs_scrub	*sc,
-	xchk_rtsumoff_t		sumoff,
+	xfs_rtsumoff_t		sumoff,
 	xfs_suminfo_t		*info,
 	unsigned int		nr_words)
 {
@@ -133,7 +133,7 @@ xchk_rtsum_record_free(
 	xfs_fileoff_t			rbmoff;
 	xfs_rtxnum_t			rtbno;
 	xfs_filblks_t			rtlen;
-	xchk_rtsumoff_t			offs;
+	xfs_rtsumoff_t			offs;
 	unsigned int			lenlog;
 	xfs_suminfo_t			v = 0;
 	int				error = 0;
@@ -144,7 +144,7 @@ xchk_rtsum_record_free(
 	/* Compute the relevant location in the rtsum file. */
 	rbmoff = xfs_rtx_to_rbmblock(mp, rec->ar_startext);
 	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
-	offs = XFS_SUMOFFS(mp, lenlog, rbmoff);
+	offs = xfs_rtsumoffs(mp, lenlog, rbmoff);
 
 	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
 	rtlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
@@ -193,10 +193,11 @@ xchk_rtsum_compare(
 	struct xfs_buf		*bp;
 	struct xfs_bmbt_irec	map;
 	xfs_fileoff_t		off;
-	xchk_rtsumoff_t		sumoff = 0;
+	xfs_rtsumoff_t		sumoff = 0;
 	int			nmap;
 
 	for (off = 0; off < XFS_B_TO_FSB(mp, mp->m_rsumsize); off++) {
+		xfs_suminfo_t	*ondisk_info;
 		int		error = 0;
 
 		if (xchk_should_terminate(sc, &error))
@@ -228,7 +229,8 @@ xchk_rtsum_compare(
 			return error;
 		}
 
-		if (memcmp(bp->b_addr, sc->buf,
+		ondisk_info = xfs_rsumblock_infoptr(bp, 0);
+		if (memcmp(ondisk_info, sc->buf,
 					mp->m_blockwsize << XFS_WORDLOG) != 0)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
 
diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
index 8c61fda80830c..7a69474293bf1 100644
--- a/fs/xfs/scrub/rtsummary.h
+++ b/fs/xfs/scrub/rtsummary.h
@@ -6,9 +6,9 @@
 #ifndef __XFS_SCRUB_RTSUMMARY_H__
 #define __XFS_SCRUB_RTSUMMARY_H__
 
-typedef unsigned int xchk_rtsumoff_t;
+typedef unsigned int xfs_rtsumoff_t;
 
-int xfsum_copyout(struct xfs_scrub *sc, xchk_rtsumoff_t sumoff,
+int xfsum_copyout(struct xfs_scrub *sc, xfs_rtsumoff_t sumoff,
 		xfs_suminfo_t *info, unsigned int nr_words);
 
 #endif /* __XFS_SCRUB_RTSUMMARY_H__ */
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index 78cc18d82ebb3..57fbe10bf9842 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -18,6 +18,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_swapext.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -30,7 +31,7 @@
 
 struct xrep_rtsummary {
 	/* suminfo position of xfile as we write buffers to disk. */
-	xchk_rtsumoff_t		prep_wordoff;
+	xfs_rtsumoff_t		prep_wordoff;
 };
 
 /* Set us up to repair the rtsummary file. */
@@ -89,8 +90,8 @@ xrep_rtsummary_prep_buf(
 
 	bp->b_ops = &xfs_rtbuf_ops;
 
-	error = xfsum_copyout(sc, rs->prep_wordoff, bp->b_addr,
-			mp->m_blockwsize);
+	error = xfsum_copyout(sc, rs->prep_wordoff,
+			xfs_rsumblock_infoptr(bp, 0), mp->m_blockwsize);
 	if (error)
 		return error;
 

