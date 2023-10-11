Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680A5CDB473
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346207AbjJKSCy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346760AbjJKSCx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:02:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A51CF
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:02:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27152C433C8;
        Wed, 11 Oct 2023 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047371;
        bh=j8wiICBBpoygoPIiF7kMr36sc6KtoW7EEm20OByOa9o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pOinHzUMZot/WGQFANGqN7hJyEicJ5ZeXYcJqYwAuNFVi0idh+5VcpkKSt1JePZ+E
         fvCrjDJk/qGevWLoxc1K7R8digTZv+aKlVPplNCYeOsoGLT4L7AU/4TWiSA8Yl4c1k
         /ebpcUNRcVMbhdEXwZ10bzESfbpBJipVXSG57DVQVYqsW8xKQtqTcysupoone4RON0
         788HGxmIJ79Eu+x2G+8b3kOgpsmFPD5Mtghr2lDjq6JMMbjJy7IIeQBtch3gSMwNwP
         0q7WcpZ7eUoi8HFWc5AWOHYPNm+wv8kwFoXWwxIbJtcApNcJ4NtSt7blOtgTc270cg
         i8lVGJJMEg5pw==
Date:   Wed, 11 Oct 2023 11:02:50 -0700
Subject: [PATCH 1/7] xfs: make sure maxlen is still congruent with prod when
 rounding down
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704720745.1773388.12417746971476890450.stgit@frogsfrogsfrogs>
In-Reply-To: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
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
index 5429a019159a6..309ed109d80fc 100644
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

