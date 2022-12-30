Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD54C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiLaCYj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbiLaCYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:24:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F99F1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:24:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B86EF61CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA46C433D2;
        Sat, 31 Dec 2022 02:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453476;
        bh=ADvgJdeuykk1LpsMB0+Pc2Wj3WrfUFUn9V8AnfZ+R94=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RX8IujefflCzDXcQeCkAX6vM/Z/sive8YWJuNPlfefg1jvR41ISfxpMZHvGaavTJZ
         2+HaY/qkXNPpA00QvzRmtWJOOzdByA7ztMzgK3NH2FAl/cqyaSLRVpNYN03KRzN8TC
         qA6ye1WaPtFigQnAcU2PfAP8ar4QG6oMiZAljEUtq+1OmTcZgyXnm9bwH2FwQASqYc
         2rDP0VvuqiG/SyLvjUEgzZPzc7l6E5fHAA2hOKP7PT3ytFOfUC/nyJPqRip44jB7ZN
         uMvT+3r+O2nE+1IQKemwvwSGX2zVKxUzDcWJ4+eHIUmnqA8vf72Mgt80lMIIZUS1M4
         Ha5/7SRPFvhwg==
Subject: [PATCH 1/9] xfs: convert the rtbitmap block and bit macros to static
 inline functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:32 -0800
Message-ID: <167243877242.727982.10280976049351168682.stgit@magnolia>
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

Replace these macros with typechecked helper functions.  Eventually
we're going to add more logic to the helpers and it'll be easier if we
don't have to macro it up.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h   |    5 -----
 libxfs/xfs_rtbitmap.c |   22 +++++++++++-----------
 libxfs/xfs_rtbitmap.h |   27 +++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d93cc0ea20e..6a3d684900a 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1209,11 +1209,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 	((xfs_suminfo_t *)((bp)->b_addr + \
 		(((so) * (uint)sizeof(xfs_suminfo_t)) & XFS_BLOCKMASK(mp))))
 
-#define	XFS_BITTOBLOCK(mp,bi)	((bi) >> (mp)->m_blkbit_log)
-#define	XFS_BLOCKTOBIT(mp,bb)	((bb) << (mp)->m_blkbit_log)
-#define	XFS_BITTOWORD(mp,bi)	\
-	((int)(((bi) >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp)))
-
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index f74618323b4..62bd2d0eae3 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -121,7 +121,7 @@ xfs_rtfind_back(
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
 	if (error) {
 		return error;
@@ -130,7 +130,7 @@ xfs_rtfind_back(
 	/*
 	 * Get the first word's index & point to it.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = start - limit + 1;
@@ -296,7 +296,7 @@ xfs_rtfind_forw(
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
 	if (error) {
 		return error;
@@ -305,7 +305,7 @@ xfs_rtfind_forw(
 	/*
 	 * Get the first word's index & point to it.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = limit - start + 1;
@@ -557,7 +557,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute starting bitmap block number.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	/*
 	 * Read the bitmap block, and point to its data.
 	 */
@@ -569,7 +569,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	first = b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
@@ -735,7 +735,7 @@ xfs_rtfree_range(
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -747,7 +747,7 @@ xfs_rtfree_range(
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), -1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, end + 1), -1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -758,7 +758,7 @@ xfs_rtfree_range(
 	 */
 	error = xfs_rtmodify_summary(mp, tp,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+		xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
 	return error;
 }
 
@@ -791,7 +791,7 @@ xfs_rtcheck_range(
 	/*
 	 * Compute starting bitmap block number
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	/*
 	 * Read the bitmap block.
 	 */
@@ -803,7 +803,7 @@ xfs_rtcheck_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 9dd791181ca..e53011bc638 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -94,6 +94,33 @@ xfs_rtb_rounddown_rtx(
 	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
 }
 
+/* Convert an rt extent number to a file block offset in the rt bitmap file. */
+static inline xfs_fileoff_t
+xfs_rtx_to_rbmblock(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return rtx >> mp->m_blkbit_log;
+}
+
+/* Convert an rt extent number to a word offset within an rt bitmap block. */
+static inline unsigned int
+xfs_rtx_to_rbmword(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return (rtx >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp);
+}
+
+/* Convert a file block offset in the rt bitmap file to an rt extent number. */
+static inline xfs_rtxnum_t
+xfs_rbmblock_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		rbmoff)
+{
+	return rbmoff << mp->m_blkbit_log;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */

