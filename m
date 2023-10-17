Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE496CDB483
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344145AbjJQPwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344158AbjJQPwU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:52:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5E8F5
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:52:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E583BC433C7;
        Tue, 17 Oct 2023 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557939;
        bh=ev8AA+uFLKiZVmyGLk5gjhRaey7DwhWhA5SF5RIUCBQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CDmtOlFe6I6SmSDqdxwTEuqc02YFMboh1Z5jhpZO8sKrXoa6/+gFpCfGoAKYN6Fz7
         oVnKDNUo8ELXwDDfxuwAJBk8O/Q4Spwqfa8HX2ObQaGFffd6S2eBZU900pMK5KJYcO
         cKIokML+q5E1TL8+B/ZZ2w2dVzJ4WcIyfk1y7o9/KqdlW/OjxCVXWidviTpmOgNezo
         cVC2/01FhYz4YMf7s06tVvGuyvog8+27yJvofvwIC5qhU9N48wlfI3tTUpa0Dwx1Y4
         o4Uxkq5AEr5l0zKbCUhpmxTBehUtmKkdxT8wNYlf9zayW1Xa062PSsevXfjPDAqKWg
         XpPVdgtaEOZdg==
Date:   Tue, 17 Oct 2023 08:52:18 -0700
Subject: [PATCH 2/8] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755742176.3167663.14278889065955741825.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
References: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h   |    2 --
 fs/xfs/libxfs/xfs_rtbitmap.c |   16 ++++++++--------
 fs/xfs/libxfs/xfs_rtbitmap.h |    2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0e2ee8202402..ac6dd102342d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1142,8 +1142,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 
 #define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
 #define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
-#define	XFS_BLOCKWSIZE(mp)	((mp)->m_blockwsize)
-#define	XFS_BLOCKWMASK(mp)	((mp)->m_blockwmask)
 
 /*
  * RT Summary and bit manipulation macros.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f7c744f1600a..6ec539aa1b92 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -174,7 +174,7 @@ xfs_rtfind_back(
 				return error;
 			}
 			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
+			word = mp->m_blockwsize - 1;
 			b = &bufp[word];
 		} else {
 			/*
@@ -220,7 +220,7 @@ xfs_rtfind_back(
 				return error;
 			}
 			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
+			word = mp->m_blockwsize - 1;
 			b = &bufp[word];
 		} else {
 			/*
@@ -338,7 +338,7 @@ xfs_rtfind_forw(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the previous one.
 			 */
@@ -383,7 +383,7 @@ xfs_rtfind_forw(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
@@ -593,7 +593,7 @@ xfs_rtmodify_range(
 		 * Go on to the next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * Log the changed part of this block.
 			 * Get the next one.
@@ -633,7 +633,7 @@ xfs_rtmodify_range(
 		 * Go on to the next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * Log the changed part of this block.
 			 * Get the next one.
@@ -836,7 +836,7 @@ xfs_rtcheck_range(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
@@ -882,7 +882,7 @@ xfs_rtcheck_range(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 5c4325702cb1..a382b38c6c30 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -146,7 +146,7 @@ xfs_rtx_to_rbmword(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
-	return (rtx >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp);
+	return (rtx >> XFS_NBWORDLOG) & (mp->m_blockwsize - 1);
 }
 
 /* Convert a file block offset in the rt bitmap file to an rt extent number. */

