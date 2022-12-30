Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C9AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiLaBZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiLaBZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:25:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9349FE3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:25:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E47AB81DB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30133C433D2;
        Sat, 31 Dec 2022 01:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449939;
        bh=mKAxpz7i8XhuPQ0WZDcV2gAWpYkEzG7MgSGyJSN3K+w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=isuf9VrwYSnTLrvKWF/157fmSeUz1JPCzk+Y34ff95nyRGbkQ6HoexidfMAEjgaSx
         DFMkpyJofa5Uz8YvDiOi0+LRdjc/qqjqIi8ebQhaWKpQamAZ7VPHkr6uGqOuDC/eeu
         HaPW1a31bcnzFmmGoMRIoEKZ4HaoNhEaS17KEBbD0ZdJTO3dQaA/FQSRETs3YWVkZm
         zbzyzSOaYVO+i/pvFK//Qm3UbswC4cEtdhrKhkOJebxsT+hpVCYKtTIUmh9vZv+o3V
         VA75TxGCssv+tpntUbRM8NEnpYKuof/cMuwmqfrH4yNm3RIvyL9d9HorA7dz97jSPo
         nQuQDHqgeADGw==
Subject: [PATCH 4/8] xfs: convert rt summary macros to helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:45 -0800
Message-ID: <167243866534.712132.11362615977623656654.stgit@magnolia>
In-Reply-To: <167243866468.712132.9606813674941614562.stgit@magnolia>
References: <167243866468.712132.9606813674941614562.stgit@magnolia>
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
index a4278c8fba5f..d95497c064fc 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1198,15 +1198,8 @@ static inline bool xfs_dinode_has_large_extent_counts(
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
index 231622a5ab68..b6a1d240c554 100644
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
index af37afec2b01..f616956b2891 100644
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
index abb07a1c7b0b..f4615c5be34f 100644
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
index fd6fb905904b..98baca261202 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -85,7 +85,7 @@ xchk_setup_rtsummary(
 static inline int
 xfsum_load(
 	struct xfs_scrub	*sc,
-	xchk_rtsumoff_t		sumoff,
+	xfs_rtsumoff_t		sumoff,
 	xfs_suminfo_t		*info)
 {
 	return xfile_obj_load(sc->xfile, info, sizeof(xfs_suminfo_t),
@@ -95,7 +95,7 @@ xfsum_load(
 static inline int
 xfsum_store(
 	struct xfs_scrub	*sc,
-	xchk_rtsumoff_t		sumoff,
+	xfs_rtsumoff_t		sumoff,
 	const xfs_suminfo_t	info)
 {
 	return xfile_obj_store(sc->xfile, &info, sizeof(xfs_suminfo_t),
@@ -105,7 +105,7 @@ xfsum_store(
 inline int
 xfsum_copyout(
 	struct xfs_scrub	*sc,
-	xchk_rtsumoff_t		sumoff,
+	xfs_rtsumoff_t		sumoff,
 	xfs_suminfo_t		*info,
 	unsigned int		nr_words)
 {
@@ -125,7 +125,7 @@ xchk_rtsum_record_free(
 	xfs_fileoff_t			rbmoff;
 	xfs_rtxnum_t			rtbno;
 	xfs_filblks_t			rtlen;
-	xchk_rtsumoff_t			offs;
+	xfs_rtsumoff_t			offs;
 	unsigned int			lenlog;
 	xfs_suminfo_t			v = 0;
 	int				error = 0;
@@ -136,7 +136,7 @@ xchk_rtsum_record_free(
 	/* Compute the relevant location in the rtsum file. */
 	rbmoff = xfs_rtx_to_rbmblock(mp, rec->ar_startext);
 	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
-	offs = XFS_SUMOFFS(mp, lenlog, rbmoff);
+	offs = xfs_rtsumoffs(mp, lenlog, rbmoff);
 
 	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
 	rtlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
@@ -185,10 +185,11 @@ xchk_rtsum_compare(
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
@@ -220,7 +221,8 @@ xchk_rtsum_compare(
 			return error;
 		}
 
-		if (memcmp(bp->b_addr, sc->buf,
+		ondisk_info = xfs_rsumblock_infoptr(bp, 0);
+		if (memcmp(ondisk_info, sc->buf,
 					mp->m_blockwsize << XFS_WORDLOG) != 0)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
 
diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
index e5f3c69c4cbf..f5fd55992957 100644
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
index f5c14c50ebf3..713b79a1f52a 100644
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
 

