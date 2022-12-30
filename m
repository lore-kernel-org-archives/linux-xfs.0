Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E337C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbiLaBYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbiLaBYy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:24:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DAB1DF2B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:24:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10A0561B80
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B405C433D2;
        Sat, 31 Dec 2022 01:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449892;
        bh=2CDTBf24pWABOPZ1nt8f4Ef7HvjmxlPeMKt2q1c/CeI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=myTQSpmbEVIj8qNpc+l36N7VIqyfSTCE3AcF67+n/HXu5KcGuFk+hzLPwZrcPq8v8
         /FqD5DH9RF9dKDoDEBAG8+s6PK3V5clA/VyYZ0ExUYTTGKwm29uudsNL06O1RfhtrY
         5q/DoSXlXGagacOv1ddL8swlJ/Ckm/hlwQaWC1E9mBj8BKGeRItA2AnoL7tjKUmIgU
         uDQNzzAi9j7fo5Ns+CZcjuPR4MACCw2t60Lw2z/id8LS0LAJJzo1/PH2Yyqoe1BfKO
         JSndgPGVGE/ZNV9vb2DkTgzl/NHMJmZyqIx8OtPkY9hE9V1VM+WFL2EKdw9LuKFlxI
         k6v9oOLIUT8SA==
Subject: [PATCH 1/8] xfs: convert the rtbitmap block and bit macros to static
 inline functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:44 -0800
Message-ID: <167243866490.712132.8119683851095782337.stgit@magnolia>
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

Replace these macros with typechecked helper functions.  Eventually
we're going to add more logic to the helpers and it'll be easier if we
don't have to macro it up.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |    5 -----
 fs/xfs/libxfs/xfs_rtbitmap.c |   22 +++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h |   27 +++++++++++++++++++++++++++
 fs/xfs/scrub/rtsummary.c     |    2 +-
 fs/xfs/xfs_rtalloc.c         |   20 ++++++++++----------
 5 files changed, 49 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d93cc0ea20e3..6a3d684900ab 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index de54386cf52f..ce8736666a1e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -123,7 +123,7 @@ xfs_rtfind_back(
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
 	if (error) {
 		return error;
@@ -132,7 +132,7 @@ xfs_rtfind_back(
 	/*
 	 * Get the first word's index & point to it.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = start - limit + 1;
@@ -298,7 +298,7 @@ xfs_rtfind_forw(
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
 	if (error) {
 		return error;
@@ -307,7 +307,7 @@ xfs_rtfind_forw(
 	/*
 	 * Get the first word's index & point to it.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = limit - start + 1;
@@ -559,7 +559,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute starting bitmap block number.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	/*
 	 * Read the bitmap block, and point to its data.
 	 */
@@ -571,7 +571,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	first = b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
@@ -737,7 +737,7 @@ xfs_rtfree_range(
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -749,7 +749,7 @@ xfs_rtfree_range(
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), -1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, end + 1), -1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -760,7 +760,7 @@ xfs_rtfree_range(
 	 */
 	error = xfs_rtmodify_summary(mp, tp,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+		xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
 	return error;
 }
 
@@ -793,7 +793,7 @@ xfs_rtcheck_range(
 	/*
 	 * Compute starting bitmap block number
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	/*
 	 * Read the bitmap block.
 	 */
@@ -805,7 +805,7 @@ xfs_rtcheck_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 9dd791181ca2..e53011bc638d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 7885ddd2d733..fd6fb905904b 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -134,7 +134,7 @@ xchk_rtsum_record_free(
 		return error;
 
 	/* Compute the relevant location in the rtsum file. */
-	rbmoff = XFS_BITTOBLOCK(mp, rec->ar_startext);
+	rbmoff = xfs_rtx_to_rbmblock(mp, rec->ar_startext);
 	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
 	offs = XFS_SUMOFFS(mp, lenlog, rbmoff);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3573dfef5dd7..c63906cf94d1 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -182,7 +182,7 @@ xfs_rtallocate_range(
 	 */
 	error = xfs_rtmodify_summary(mp, tp,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+		xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
 	if (error) {
 		return error;
 	}
@@ -193,7 +193,7 @@ xfs_rtallocate_range(
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -205,7 +205,7 @@ xfs_rtallocate_range(
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), 1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, end + 1), 1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -249,8 +249,8 @@ xfs_rtallocate_extent_block(
 	 * Loop over all the extents starting in this bitmap block,
 	 * looking for one that's long enough.
 	 */
-	for (i = XFS_BLOCKTOBIT(mp, bbno), besti = -1, bestlen = 0,
-		end = XFS_BLOCKTOBIT(mp, bbno + 1) - 1;
+	for (i = xfs_rbmblock_to_rtx(mp, bbno), besti = -1, bestlen = 0,
+		end = xfs_rbmblock_to_rtx(mp, bbno + 1) - 1;
 	     i <= end;
 	     i++) {
 		/*
@@ -487,7 +487,7 @@ xfs_rtallocate_extent_near(
 		*rtx = r;
 		return 0;
 	}
-	bbno = XFS_BITTOBLOCK(mp, start);
+	bbno = xfs_rtx_to_rbmblock(mp, start);
 	i = 0;
 	ASSERT(minlen != 0);
 	log2len = xfs_highbit32(minlen);
@@ -706,8 +706,8 @@ xfs_rtallocate_extent_size(
 			 * allocator is beyond the next bitmap block,
 			 * skip to that bitmap block.
 			 */
-			if (XFS_BITTOBLOCK(mp, n) > i + 1)
-				i = XFS_BITTOBLOCK(mp, n) - 1;
+			if (xfs_rtx_to_rbmblock(mp, n) > i + 1)
+				i = xfs_rtx_to_rbmblock(mp, n) - 1;
 		}
 	}
 	/*
@@ -769,8 +769,8 @@ xfs_rtallocate_extent_size(
 			 * allocator is beyond the next bitmap block,
 			 * skip to that bitmap block.
 			 */
-			if (XFS_BITTOBLOCK(mp, n) > i + 1)
-				i = XFS_BITTOBLOCK(mp, n) - 1;
+			if (xfs_rtx_to_rbmblock(mp, n) > i + 1)
+				i = xfs_rtx_to_rbmblock(mp, n) - 1;
 		}
 	}
 	/*

