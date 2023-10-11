Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747E2CDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbjJKSFr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235049AbjJKSFq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:05:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5482B93
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:05:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8AAC433C8;
        Wed, 11 Oct 2023 18:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047543;
        bh=wn7y1rE2HpAkRzhNVQmhbUQJcog2OgfSTHV2Gq38DJE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rXOmGic9RKnELpRuXCzgkRSgHt5KpicRvqoChYtwYgI0VdBDP/m4kwd3vD5bqIh20
         DXgi96oEyr1e4Y1HMZYwvwVlk17JquKkgGbwW59ODyXhjPwQ3rvPbztnhPM4VnB8YM
         vsHsV7X3P/vjRtTn8ZQwg5Zs75JPVmyLGcAZ1wjnB5RZalO1NMo5i196SMS4VFU2Ze
         fIIqZsUXl/I74nA7PRnH5tj1npH24FIThzK56LUcFHAGQp/2nYKRMMgFvzCpArHwIk
         8FkxabHzU4+qT3d32/Sx/kmyhHYOWBQajQrzWUouhXonhAiuU65EZMt4TVu67aDKKc
         X20v5doOWWw1Q==
Date:   Wed, 11 Oct 2023 11:05:42 -0700
Subject: [PATCH 5/7] xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721255.1773611.7719978115841778913.stgit@frogsfrogsfrogs>
In-Reply-To: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert these calls to use the helpers, and clean up all these places
where the same variable can have different units depending on where it
is in the function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 ++------
 fs/xfs/scrub/rtbitmap.c  |   14 +++++---------
 fs/xfs/xfs_bmap_util.c   |   10 ++++------
 fs/xfs/xfs_fsmap.c       |    8 ++++----
 fs/xfs/xfs_rtalloc.c     |    3 +--
 5 files changed, 16 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 463174af94333..d322fd5116179 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4883,12 +4883,8 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got->br_startoff <= del->br_startoff);
 	ASSERT(got_endoff >= del_endoff);
 
-	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
-
-		do_div(rtexts, mp->m_sb.sb_rextsize);
-		xfs_mod_frextents(mp, rtexts);
-	}
+	if (isrt)
+		xfs_mod_frextents(mp, xfs_rtb_to_rtxt(mp, del->br_blockcount));
 
 	/*
 	 * Update the inode delalloc counter now and wait to update the
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 01bc5119d612c..a785fb5f317dd 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -140,26 +140,22 @@ xchk_rtbitmap(
 void
 xchk_xref_is_used_rt_space(
 	struct xfs_scrub	*sc,
-	xfs_rtblock_t		fsbno,
+	xfs_rtblock_t		rtbno,
 	xfs_extlen_t		len)
 {
 	xfs_rtxnum_t		startext;
 	xfs_rtxnum_t		endext;
-	xfs_rtxlen_t		extcount;
 	bool			is_free;
 	int			error;
 
 	if (xchk_skip_xref(sc->sm))
 		return;
 
-	startext = fsbno;
-	endext = fsbno + len - 1;
-	do_div(startext, sc->mp->m_sb.sb_rextsize);
-	do_div(endext, sc->mp->m_sb.sb_rextsize);
-	extcount = endext - startext + 1;
+	startext = xfs_rtb_to_rtxt(sc->mp, rtbno);
+	endext = xfs_rtb_to_rtxt(sc->mp, rtbno + len - 1);
 	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
-			&is_free);
+	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext,
+			endext - startext + 1, &is_free);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		goto out_unlock;
 	if (is_free)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c246f25aaad55..8f1e16e49dab2 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -157,14 +157,12 @@ xfs_bmap_rtalloc(
 	 * Realtime allocation, done through xfs_rtallocate_extent.
 	 */
 	if (ignore_locality)
-		ap->blkno = 0;
+		rtx = 0;
 	else
-		do_div(ap->blkno, mp->m_sb.sb_rextsize);
-	rtx = ap->blkno;
-	ap->length = ralen;
+		rtx = xfs_rtb_to_rtxt(mp, ap->blkno);
 	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
-	error = xfs_rtallocate_extent(ap->tp, ap->blkno, raminlen, ap->length,
-			&ralen, ap->wasdel, prod, &rtx);
+	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
+			ap->wasdel, prod, &rtx);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 1a187bc9da3de..32aefaf7d6684 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -512,6 +512,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 	xfs_rtblock_t			start_rtb;
 	xfs_rtblock_t			end_rtb;
 	uint64_t			eofs;
+	xfs_extlen_t			mod;
 	int				error;
 
 	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
@@ -539,10 +540,9 @@ xfs_getfsmap_rtdev_rtbitmap(
 	 * Set up query parameters to return free rtextents covering the range
 	 * we want.
 	 */
-	alow.ar_startext = start_rtb;
-	ahigh.ar_startext = end_rtb;
-	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
-	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
+	alow.ar_startext = xfs_rtb_to_rtxt(mp, start_rtb);
+	ahigh.ar_startext = xfs_rtb_to_rtx(mp, end_rtb, &mod);
+	if (mod)
 		ahigh.ar_startext++;
 	error = xfs_rtalloc_query_range(mp, tp, &alow, &ahigh,
 			xfs_getfsmap_rtdev_rtbitmap_helper, info);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d3a5112f21156..8db8f957a683b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1056,8 +1056,7 @@ xfs_growfs_rt(
 		nrblocks_step = (bmbno + 1) * NBBY * nsbp->sb_blocksize *
 				nsbp->sb_rextsize;
 		nsbp->sb_rblocks = min(nrblocks, nrblocks_step);
-		nsbp->sb_rextents = nsbp->sb_rblocks;
-		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);
+		nsbp->sb_rextents = xfs_rtb_to_rtxt(nmp, nsbp->sb_rblocks);
 		ASSERT(nsbp->sb_rextents != 0);
 		nsbp->sb_rextslog = xfs_highbit32(nsbp->sb_rextents);
 		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;

