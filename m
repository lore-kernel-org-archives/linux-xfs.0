Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0454CDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjJKSGs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233032AbjJKSGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:06:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533E894
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:06:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80FCC433C7;
        Wed, 11 Oct 2023 18:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047606;
        bh=WxfsDz8iKVi7AZH83WrgQY20Y2NWdpWg8Bk7rxxxWjQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=YK04fwrC+ZgBMdgR5QqkJXxadhVeTn/sl+vPsZM8IAhQ/JiQhDhVOBwXCFSmu8zYO
         SDFNcn7SDRRBL+R84EX8dFl+gssWCGKFFdqodRiG2D/Xqmjp+OJy1XK1bNpHB7qYEG
         sDoEStL2ghIxysBN4dtTyGFWW8dai5UNuKbFOjmf7g//+Xm4S+pcwnZVpLBQl8mv2Z
         ep3ylZhwANfVtne4MCVGpqrNkvvIsHLobqmaaKNo5UdsJsgK+seoAd0vwzDn2H1ezF
         EW6jPLxCqn7yVRpoVjNAi3Jxnw2ZRbF3lvlAfGv534HSZCLs0S2KyjS5qA1hmzfk5W
         k9F3ALV4WO4HQ==
Date:   Wed, 11 Oct 2023 11:06:45 -0700
Subject: [PATCH 2/8] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721662.1773834.1354453014423462886.stgit@frogsfrogsfrogs>
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

Remove these trivial macros since they're not even part of the ondisk
format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |    2 --
 fs/xfs/libxfs/xfs_rtbitmap.c |   16 ++++++++--------
 fs/xfs/libxfs/xfs_rtbitmap.h |    2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 932e22e024d5b..dff9e654087b9 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1213,8 +1213,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 
 #define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
 #define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
-#define	XFS_BLOCKWSIZE(mp)	((mp)->m_blockwsize)
-#define	XFS_BLOCKWMASK(mp)	((mp)->m_blockwmask)
 
 /*
  * RT Summary and bit manipulation macros.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ce8736666a1ef..1f4886287aad0 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -181,7 +181,7 @@ xfs_rtfind_back(
 				return error;
 			}
 			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
+			word = mp->m_blockwsize - 1;
 			b = &bufp[word];
 		} else {
 			/*
@@ -227,7 +227,7 @@ xfs_rtfind_back(
 				return error;
 			}
 			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
+			word = mp->m_blockwsize - 1;
 			b = &bufp[word];
 		} else {
 			/*
@@ -345,7 +345,7 @@ xfs_rtfind_forw(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the previous one.
 			 */
@@ -390,7 +390,7 @@ xfs_rtfind_forw(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
@@ -600,7 +600,7 @@ xfs_rtmodify_range(
 		 * Go on to the next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * Log the changed part of this block.
 			 * Get the next one.
@@ -640,7 +640,7 @@ xfs_rtmodify_range(
 		 * Go on to the next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * Log the changed part of this block.
 			 * Get the next one.
@@ -843,7 +843,7 @@ xfs_rtcheck_range(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
@@ -889,7 +889,7 @@ xfs_rtcheck_range(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e53011bc638d6..5f4a453e29eb6 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -109,7 +109,7 @@ xfs_rtx_to_rbmword(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
-	return (rtx >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp);
+	return (rtx >> XFS_NBWORDLOG) & (mp->m_blockwsize - 1);
 }
 
 /* Convert a file block offset in the rt bitmap file to an rt extent number. */

