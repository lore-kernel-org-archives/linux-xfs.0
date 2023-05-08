Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D068C7EE22
	for <linux-xfs@archiver.kernel.org>; Mon,  8 May 2023 15:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjEHPbM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 May 2023 11:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjEHPbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2023 11:31:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC5D97
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2023 08:31:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 318B662E50
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2023 15:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1CCC433D2;
        Mon,  8 May 2023 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683559867;
        bh=n3xfwPsKssf5M0K19u/ZFFzb+SpsWdzdzluEfmhV4bM=;
        h=Date:From:To:Cc:Subject:From;
        b=FpbuwV9js03LCGRP1bnlQ1bikQLySTHc4+jmGynDEYy+ipgyQFvcQqEYSZfk0XLHS
         Dpuv+LX+W8wvMARED/S6D8mPtvxD4isV50BqaeolfA75geGU/pVFVpc7h/xH921FNM
         JmMM6HaBmUlt9d9zj0tPojOM3Wf8vrd1UpNUb2stW+hVupveOoj35o12y9b48/Dtpv
         jOguJHn8lEmPo3nKiymotW5SJ6oHs0TLLxOM/BLUEGhjowkXUfBwHDmJDS66i332en
         D8REypsASxG84kYrOv/V9zU7nlszO4Uc9dAng9ZVSGplBzmY0HauUe29ekRGZRmHgA
         pyIBkK3JJozWg==
Date:   Mon, 8 May 2023 08:31:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix broken logic when detecting mergeable bmap records
Message-ID: <20230508153107.GB858799@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Commit 6bc6c99a944c was a well-intentioned effort to initiate
consolidation of adjacent bmbt mapping records by setting the PREEN
flag.  Consolidation can only happen if the length of the combined
record doesn't overflow the 21-bit blockcount field of the bmbt
recordset.  Unfortunately, the length test is inverted, leading to it
triggering on data forks like these:

 EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET               TOTAL
   0: [0..16777207]:        76110848..92888055  0 (76110848..92888055) 16777208
   1: [16777208..20639743]: 92888056..96750591  0 (92888056..96750591)  3862536

Note that record 0 has a length of 16777208 512b blocks.  This
corresponds to 2097151 4k fsblocks, which is the maximum.  Hence the two
records cannot be merged.

However, the logic is still wrong even if we change the in-loop
comparison, because the scope of our examination isn't broad enough
inside the loop to detect mappings like this:

   0: [0..9]:               76110838..76110847  0 (76110838..76110847)       10
   1: [10..16777217]:       76110848..92888055  0 (76110848..92888055) 16777208
   2: [16777218..20639753]: 92888056..96750591  0 (92888056..96750591)  3862536

These three records could be merged into two, but one cannot determine
this purely from looking at records 0-1 or 1-2 in isolation.

Hoist the mergability detection outside the loop, and base its decision
making on whether or not a merged mapping could be expressed in fewer
bmbt records.  While we're at it, fix the incorrect return type of the
iter function.

Fixes: 6bc6c99a944c ("xfs: alert the user about data/attr fork mappings that could be merged")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 69bc89d0fc68..5bf4326e9783 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -769,14 +769,14 @@ xchk_are_bmaps_contiguous(
  * mapping or false if there are no more mappings.  Caller must ensure that
  * @info.icur is zeroed before the first call.
  */
-static int
+static bool
 xchk_bmap_iext_iter(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
 	struct xfs_bmbt_irec	got;
 	struct xfs_ifork	*ifp;
-	xfs_filblks_t		prev_len;
+	unsigned int		nr = 0;
 
 	ifp = xfs_ifork_ptr(info->sc->ip, info->whichfork);
 
@@ -790,12 +790,12 @@ xchk_bmap_iext_iter(
 				irec->br_startoff);
 		return false;
 	}
+	nr++;
 
 	/*
 	 * Iterate subsequent iextent records and merge them with the one
 	 * that we just read, if possible.
 	 */
-	prev_len = irec->br_blockcount;
 	while (xfs_iext_peek_next_extent(ifp, &info->icur, &got)) {
 		if (!xchk_are_bmaps_contiguous(irec, &got))
 			break;
@@ -805,20 +805,21 @@ xchk_bmap_iext_iter(
 					got.br_startoff);
 			return false;
 		}
-
-		/*
-		 * Notify the user of mergeable records in the data or attr
-		 * forks.  CoW forks only exist in memory so we ignore them.
-		 */
-		if (info->whichfork != XFS_COW_FORK &&
-		    prev_len + got.br_blockcount > BMBT_BLOCKCOUNT_MASK)
-			xchk_ino_set_preen(info->sc, info->sc->ip->i_ino);
+		nr++;
 
 		irec->br_blockcount += got.br_blockcount;
-		prev_len = got.br_blockcount;
 		xfs_iext_next(ifp, &info->icur);
 	}
 
+	/*
+	 * If the merged mapping could be expressed with fewer bmbt records
+	 * than we actually found, notify the user that this fork could be
+	 * optimized.  CoW forks only exist in memory so we ignore them.
+	 */
+	if (nr > 1 && info->whichfork != XFS_COW_FORK &&
+	    howmany_64(irec->br_blockcount, XFS_MAX_BMBT_EXTLEN) < nr)
+		xchk_ino_set_preen(info->sc, info->sc->ip->i_ino);
+
 	return true;
 }
 
