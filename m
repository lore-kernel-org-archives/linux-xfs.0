Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A2DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbiLaCZ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiLaCZZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:25:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11BC1A833
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:25:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5985761CC2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E9DC433EF;
        Sat, 31 Dec 2022 02:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453522;
        bh=tBbH2apdIRE/lBrPVg30s6uUJSks/pZLVPntfIE/XO8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eTxnUlgOmXnH+QcPyy/EFSuvM+kNutQk+DBhFLH/FN0U/B2rSSsZDQn7t7ip+GK5y
         flisf52eOZWiVlN8orV8Rc3o3EmROLSCrqfugNFRSkumlusX1WVP0SGdz3N/L2sNix
         Wv34RacJfPBI4wTpJVGY0BcKWitWDp6ZNh9PA5cZT7Ykw8rY2VETEPXm2G4wfJsaAi
         b2vI062QiZWN42zjtEVfBPrnjZNqwc7IYbuPgBHpUFEhh6dZcRP3e6yQGKvSAIQHCU
         dZnupJR7k0cqT6BV/ygd6kmycxe9BYCbXsSe0LgqVdbgMyde1IDfLuH4WKyixY+80s
         rxBdSf+1RsToQ==
Subject: [PATCH 4/9] xfs: convert rt summary macros to helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:32 -0800
Message-ID: <167243877282.727982.128490008596996579.stgit@magnolia>
In-Reply-To: <167243877226.727982.8292582053571487702.stgit@magnolia>
References: <167243877226.727982.8292582053571487702.stgit@magnolia>
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
 db/check.c            |    4 ++-
 libxfs/xfs_format.h   |    9 +------
 libxfs/xfs_rtbitmap.c |   10 +++++---
 libxfs/xfs_rtbitmap.h |   59 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_types.h    |    2 ++
 repair/rt.c           |    4 ++-
 6 files changed, 72 insertions(+), 16 deletions(-)


diff --git a/db/check.c b/db/check.c
index 185be6352b8..4e1d3c6d366 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3663,7 +3663,7 @@ process_rtbitmap(
 				len = ((int)bmbno - start_bmbno) *
 					bitsperblock + (bit - start_bit);
 				log = XFS_RTBLOCKLOG(len);
-				offs = XFS_SUMOFFS(mp, log, start_bmbno);
+				offs = xfs_rtsumoffs(mp, log, start_bmbno);
 				sumcompute[offs]++;
 				prevbit = 0;
 			}
@@ -3676,7 +3676,7 @@ process_rtbitmap(
 		len = ((int)bmbno - start_bmbno) * bitsperblock +
 			(bit - start_bit);
 		log = XFS_RTBLOCKLOG(len);
-		offs = XFS_SUMOFFS(mp, log, start_bmbno);
+		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		sumcompute[offs]++;
 	}
 }
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index a4278c8fba5..d95497c064f 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 8fec2b769d5..e17af3b9d28 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -460,17 +460,18 @@ xfs_rtmodify_summary_int(
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
@@ -498,7 +499,8 @@ xfs_rtmodify_summary_int(
 	/*
 	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
-	sp = XFS_SUMPTR(mp, bp, so);
+	infoword = xfs_rtsumoffs_to_infoword(mp, so);
+	sp = xfs_rsumblock_infoptr(bp, infoword);
 	if (delta) {
 		uint first = (uint)((char *)sp - (char *)bp->b_addr);
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index af37afec2b0..f616956b289 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index abb07a1c7b0..f4615c5be34 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
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
diff --git a/repair/rt.c b/repair/rt.c
index 947382e9ede..8f3b9082a9b 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -91,7 +91,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 			} else if (in_extent == 1) {
 				len = (int) (extno - start_ext);
 				log = XFS_RTBLOCKLOG(len);
-				offs = XFS_SUMOFFS(mp, log, start_bmbno);
+				offs = xfs_rtsumoffs(mp, log, start_bmbno);
 				sumcompute[offs]++;
 				in_extent = 0;
 			}
@@ -107,7 +107,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 	if (in_extent == 1) {
 		len = (int) (extno - start_ext);
 		log = XFS_RTBLOCKLOG(len);
-		offs = XFS_SUMOFFS(mp, log, start_bmbno);
+		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		sumcompute[offs]++;
 	}
 

