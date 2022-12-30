Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F470C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiLaCYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiLaCYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:24:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4454719C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1802B81E5E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D630C433EF;
        Sat, 31 Dec 2022 02:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453491;
        bh=JDT7VBraezGkyfVI1KjGY+J0oPFbawltA/ja0IF9G+Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A7kr2b8nUsGg+Z4ZrShJxLwVxwz2A6BYwwQRtNaTjVyow5aaReYbA4WxA5RfYODDn
         HUJ3f5Rztg59UbgeiutWhJ4uwOcZ71fikSMB12EvYZ23aR+6ROfI/U5xeWqkQIEy58
         YtzM9kjw85TLvOaU2af9gnWB18ijNIX0j8WleJZS1nmbXR05/lpSRKHB0z1C3cvnot
         pnNdojNtEbXMtlfjYEm/TBc9OtNIeiTRMTjulFPCvX262kK2azNe/ANk/2vcWgfYLX
         KY2ToCOhlj6AAWORDzfWGJeXsMhJvvEiHMLOm5SEnRPZhBHzP60Y/HOMqQwozPoCwi
         T6dDIGGFbtdmA==
Subject: [PATCH 2/9] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:32 -0800
Message-ID: <167243877255.727982.13244116407945705552.stgit@magnolia>
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

Remove these trivial macros since they're not even part of the ondisk
format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h   |    2 --
 libxfs/xfs_rtbitmap.c |   16 ++++++++--------
 libxfs/xfs_rtbitmap.h |    2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 6a3d684900a..a4278c8fba5 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1196,8 +1196,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 
 #define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
 #define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
-#define	XFS_BLOCKWSIZE(mp)	((mp)->m_blockwsize)
-#define	XFS_BLOCKWMASK(mp)	((mp)->m_blockwmask)
 
 /*
  * RT Summary and bit manipulation macros.
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 62bd2d0eae3..5301b0448f1 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -179,7 +179,7 @@ xfs_rtfind_back(
 				return error;
 			}
 			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
+			word = mp->m_blockwsize - 1;
 			b = &bufp[word];
 		} else {
 			/*
@@ -225,7 +225,7 @@ xfs_rtfind_back(
 				return error;
 			}
 			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
+			word = mp->m_blockwsize - 1;
 			b = &bufp[word];
 		} else {
 			/*
@@ -343,7 +343,7 @@ xfs_rtfind_forw(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the previous one.
 			 */
@@ -388,7 +388,7 @@ xfs_rtfind_forw(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
@@ -598,7 +598,7 @@ xfs_rtmodify_range(
 		 * Go on to the next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * Log the changed part of this block.
 			 * Get the next one.
@@ -638,7 +638,7 @@ xfs_rtmodify_range(
 		 * Go on to the next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * Log the changed part of this block.
 			 * Get the next one.
@@ -841,7 +841,7 @@ xfs_rtcheck_range(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
@@ -887,7 +887,7 @@ xfs_rtcheck_range(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e53011bc638..5f4a453e29e 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -109,7 +109,7 @@ xfs_rtx_to_rbmword(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
-	return (rtx >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp);
+	return (rtx >> XFS_NBWORDLOG) & (mp->m_blockwsize - 1);
 }
 
 /* Convert a file block offset in the rt bitmap file to an rt extent number. */

