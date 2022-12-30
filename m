Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC309C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbiLaBZN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbiLaBZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:25:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4699FE3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:25:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9006161B80
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BAEC433EF;
        Sat, 31 Dec 2022 01:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449908;
        bh=Obk5YgiX4WJMro0lPmMz6PordUO0v1LKJTwTmqzqOdE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mTfqSk9DUYxMCUT/EetmUqoMu8Dq7BC4KrfjXfWQFVN7N9cfDOzv4QhBvZFnuWpNc
         t6N771KItFj0kD29DStU1P4GJoxonkc45GozO3H7BAxQtzmQ6gdooike+H41mP7CjH
         eJ258z5gXjP//QqhvyMLigjF+Dm3WDBCVpAsdm91fEXctDK5s1ZqEKR3O5t6aiArz8
         MvXfFY7SgXz62ChNOOmk1Xc+9N14TO50exrnxfFU3qfYG3rI7hp+heoRqAbnaE8+wy
         yQe00kcy+3nsJQlbGr30//0juf3R8eaObCGxRbHQPWxnRspceiNUWvnx6gqCjLb9s4
         FjTzKqKhnj4QQ==
Subject: [PATCH 2/8] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:45 -0800
Message-ID: <167243866505.712132.2502556337531749406.stgit@magnolia>
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

Remove these trivial macros since they're not even part of the ondisk
format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |    2 --
 fs/xfs/libxfs/xfs_rtbitmap.c |   16 ++++++++--------
 fs/xfs/libxfs/xfs_rtbitmap.h |    2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 6a3d684900ab..a4278c8fba5f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1196,8 +1196,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 
 #define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
 #define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
-#define	XFS_BLOCKWSIZE(mp)	((mp)->m_blockwsize)
-#define	XFS_BLOCKWMASK(mp)	((mp)->m_blockwmask)
 
 /*
  * RT Summary and bit manipulation macros.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ce8736666a1e..1f4886287aad 100644
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
index e53011bc638d..5f4a453e29eb 100644
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

