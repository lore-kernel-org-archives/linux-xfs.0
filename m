Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726E6CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbjJSQ0u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSQ0t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:26:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8548D114
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:26:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CEDC433C9;
        Thu, 19 Oct 2023 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732806;
        bh=lZPIHJTt2M/bdPKN9jxHr1rzJ66LAyjFoyQ4d2g7BkM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=a09gLXtzBy2aktslkcxs9Eru66laFZhAVSSbi2bFzY/5BXxYTxqObWv1792PV0el1
         +5aJ2le67l268UVaJ/qAFtV4fGk7U3CxEZSH00WGzvi9J8vu0/RocRPWS2DY4Hgr1I
         pW4pJrU85Brn3JMMj6AnFX2zAC/4n5yFSxZ3zqFEVjJs1PIdsE7R79/husrKftb/xR
         8OkdDSb9Hp8b2N9dwhSBhzIWmvhLdcDXcIGX4RyA/TQZnXmv82X6WFi5yOOibdVo5m
         yF9rwunRjloRlGJ8NgQK5C49KhO8pX0UPXH4Y1TFdYJABmy3u6rbXCdUgCjoZuudP9
         22s3Hrfykkxkg==
Date:   Thu, 19 Oct 2023 09:26:45 -0700
Subject: [PATCH 2/5] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210998.225536.6256557801317974934.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210961.225536.12900854938759335651.stgit@frogsfrogsfrogs>
References: <169773210961.225536.12900854938759335651.stgit@frogsfrogsfrogs>
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
index 9ef336d22861..63caad17dd88 100644
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

