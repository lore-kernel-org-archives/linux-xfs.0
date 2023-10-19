Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B19CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbjJSQWy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbjJSQWx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:22:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39080130
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:22:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0912C433C9;
        Thu, 19 Oct 2023 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732570;
        bh=7eLiYmBiX7WNH/bHAFq6T4dNgDjxW7UIFt5XTB0VXL8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=A78J/eEUJtPzb66DPxx8mY7feGyAMvMTwmWeBblPoNCL2BzEz2Eme54j2yk/O1FAt
         bqZChLa1UBq37dlsgRvoTXM+Ht98XX3YUSZx57CN5G6FNo5Cj7pAg/abG8zq2oAQZA
         p3qMpNmthZLrRiUrWmzalGMiEJXuLWEsI2wxXiq0mHOzSSDXZSBTYBN+k6KX/g8iWn
         0tE9DoienSnZfJmC/9JZF36P7giHvocc/NJXwwx2DkYNcPnzoWghPIEtFS3mivZ8g1
         dK0cBc3Sh2rcFsNQmkU7IH2fgeo1n67VBaOE6zPpsUKzNRL3PUSFuf7Z+53cBqNORB
         JPrEyA49fqFYw==
Date:   Thu, 19 Oct 2023 09:22:50 -0700
Subject: [PATCH 2/8] xfs: make sure maxlen is still congruent with prod when
 rounding down
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210154.225045.2314510908164674643.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
References: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 31fd65b3aaa9..0e4e2df08aed 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -211,6 +211,23 @@ xfs_rtallocate_range(
 	return error;
 }
 
+/*
+ * Make sure we don't run off the end of the rt volume.  Be careful that
+ * adjusting maxlen downwards doesn't cause us to fail the alignment checks.
+ */
+static inline xfs_extlen_t
+xfs_rtallocate_clamp_len(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		startrtx,
+	xfs_extlen_t		rtxlen,
+	xfs_extlen_t		prod)
+{
+	xfs_extlen_t		ret;
+
+	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
+	return rounddown(ret, prod);
+}
+
 /*
  * Attempt to allocate an extent minlen<=len<=maxlen starting from
  * bitmap block bbno.  If we don't get maxlen then use prod to trim
@@ -248,7 +265,7 @@ xfs_rtallocate_extent_block(
 	     i <= end;
 	     i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
-		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+		maxlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
 
 		/*
 		 * See if there's a free extent of maxlen starting at i.
@@ -355,7 +372,8 @@ xfs_rtallocate_extent_exact(
 	int		isfree;		/* extent is free */
 	xfs_rtblock_t	next;		/* next block to try (dummy) */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
@@ -438,7 +456,9 @@ xfs_rtallocate_extent_near(
 	xfs_rtblock_t	n;		/* next block to try */
 	xfs_rtblock_t	r;		/* result block */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
+
 	/*
 	 * If the block number given is off the end, silently set it to
 	 * the last block.
@@ -447,7 +467,7 @@ xfs_rtallocate_extent_near(
 		bno = mp->m_sb.sb_rextents - 1;
 
 	/* Make sure we don't run off the end of the rt volume. */
-	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	maxlen = xfs_rtallocate_clamp_len(mp, bno, maxlen, prod);
 	if (maxlen < minlen) {
 		*rtblock = NULLRTBLOCK;
 		return 0;
@@ -638,7 +658,8 @@ xfs_rtallocate_extent_size(
 	xfs_rtblock_t	r;		/* result block number */
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	ASSERT(maxlen != 0);
 
 	/*

