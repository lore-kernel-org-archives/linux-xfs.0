Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E7CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiLaBVR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiLaBVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:21:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D9B26ED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:21:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 121FC61B80
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E27BC433EF;
        Sat, 31 Dec 2022 01:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449674;
        bh=wCui2/BgvRLI7YO668ZjGMi33sk4+8gC9wvI80Ty1w0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZGTcklY8osqWeZGlpO0LkitQibg4qGlCvZsXDRmJ8OAkzVzGeCiM2+o5BquKRSBST
         5DoCDxgjRAogxb43UBGOKjVko83aalTZWAhjC2oX8AB0Gw2lJjk8Hm1luGfxBGVi2m
         dTCI69/Io/UBvyUD2D1M2Me4MKvBXOuPdcDUZpqAis/NqogkSbMYwf+6nab390/6lC
         szw5OdvA1deMrlSJZfHlfZqwXtHZ+MKYdE0Ld5Rzs8B/2f+DM1o4ID6dR08rZm/Bxk
         42x4AJ+Ugex6FSlD3zB9cokRtwFFic63CbHRL30JXGdOMXJlLToIS4I49iRIvROur3
         199SloC5POhuw==
Subject: [PATCH 05/11] xfs: make sure maxlen is still congruent with prod when
 rounding down
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:36 -0800
Message-ID: <167243865688.709511.4014843758115517445.stgit@magnolia>
In-Reply-To: <167243865605.709511.15650588946095003543.stgit@magnolia>
References: <167243865605.709511.15650588946095003543.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 2a6ca4baed62, we tried to fix an overflow problem in the
realtime allocator that was caused by an overly large maxlen value
causing xfs_rtcheck_range to run off the end of the realtime bitmap.
Unfortunately, there is a subtle bug here -- maxlen (and minlen) both
have to be aligned with @prod, but @prod can be larger than 1 if the
user has set an extent size hint on the file, and that extent size hint
is larger than the realtime extent size.

If the rt free space extents are not aligned to this file's extszhint
because other files without extent size hints allocated space (or the
number of rt extents is similarly not aligned), then it's possible that
maxlen after clamping to sb_rextents will no longer be aligned to prod.
The allocation will succeed just fine, but we still trip the assertion.

Fix the problem by reducing maxlen by any misalignment with prod.  While
we're at it, split the assertions into two so that we can tell which
value had the bad alignment.

Fixes: 2a6ca4baed62 ("xfs: make sure the rt allocator doesn't run off the end")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3ac8ca845239..88faf7fb912d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -252,8 +252,13 @@ xfs_rtallocate_extent_block(
 		end = XFS_BLOCKTOBIT(mp, bbno + 1) - 1;
 	     i <= end;
 	     i++) {
-		/* Make sure we don't scan off the end of the rt volume. */
+		/*
+		 * Make sure we don't run off the end of the rt volume.  Be
+		 * careful that adjusting maxlen downwards doesn't cause us to
+		 * fail the alignment checks.
+		 */
 		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+		maxlen -= maxlen % prod;
 
 		/*
 		 * See if there's a free extent of maxlen starting at i.
@@ -360,7 +365,8 @@ xfs_rtallocate_extent_exact(
 	int		isfree;		/* extent is free */
 	xfs_rtblock_t	next;		/* next block to try (dummy) */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
@@ -443,7 +449,9 @@ xfs_rtallocate_extent_near(
 	xfs_rtblock_t	n;		/* next block to try */
 	xfs_rtblock_t	r;		/* result block */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
+
 	/*
 	 * If the block number given is off the end, silently set it to
 	 * the last block.
@@ -451,8 +459,13 @@ xfs_rtallocate_extent_near(
 	if (bno >= mp->m_sb.sb_rextents)
 		bno = mp->m_sb.sb_rextents - 1;
 
-	/* Make sure we don't run off the end of the rt volume. */
+	/*
+	 * Make sure we don't run off the end of the rt volume.  Be careful
+	 * that adjusting maxlen downwards doesn't cause us to fail the
+	 * alignment checks.
+	 */
 	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	maxlen -= maxlen % prod;
 	if (maxlen < minlen) {
 		*rtblock = NULLRTBLOCK;
 		return 0;
@@ -643,7 +656,8 @@ xfs_rtallocate_extent_size(
 	xfs_rtblock_t	r;		/* result block number */
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	ASSERT(maxlen != 0);
 
 	/*

