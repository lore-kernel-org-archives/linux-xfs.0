Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D95C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbiLaBYN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiLaBYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:24:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA071DF2B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:24:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6732B81DB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB846C433D2;
        Sat, 31 Dec 2022 01:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449845;
        bh=Bh1x6SLkWruWN/YUmfFj/whtSCPzHUthVIR1w/UuM+8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M5U6coV5lWSyIoQz6xHOHczsNHn6tMT4HxjHErv2GcI3tcFIZSFQrbdReBXouasvl
         xopnrgLvHntkLmHZ8/bBMxzyvWIkQOQBd3G8kOcwwPSFVrzvyqc0KDPTel0bcrgMZ4
         PSiGVMXsP7Z3bpSW6UBbVbTGuBhCk6H+l9MG0cZSPpDqcK1jByBH8CYcRTQLwIdpji
         yAaQS8svWKG3LH2bw5X9sb+dSLdQl93yqXCmeJBs++xUiKVR6CHWiOuspNi+poj5kT
         3w47IhVR3l+32wk4p4W/NT8A4l4kF6IBK19cepWN3T3Wl+7g3tS32wh5YGu+fhHz0n
         g3iivjYhYDvPw==
Subject: [PATCH 5/7] xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:41 -0800
Message-ID: <167243866145.711673.6078844218749025305.stgit@magnolia>
In-Reply-To: <167243866067.711673.17279545989126573423.stgit@magnolia>
References: <167243866067.711673.17279545989126573423.stgit@magnolia>
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
index 055432476ef0..1ad8606c1dd9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4921,12 +4921,8 @@ xfs_bmap_del_extent_delay(
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
index af9eee6ed5ce..a50b0580f3d8 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -140,25 +140,21 @@ xchk_rtbitmap(
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
-	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
-			&is_free);
+	startext = xfs_rtb_to_rtxt(sc->mp, rtbno);
+	endext = xfs_rtb_to_rtxt(sc->mp, rtbno + len - 1);
+	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext,
+			endext - startext + 1, &is_free);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (is_free)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a55347c693ed..e595625048f8 100644
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
index 3738dc936d85..8d0a6f480d2a 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -522,6 +522,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	struct xfs_rtalloc_rec		alow = { 0 };
 	struct xfs_rtalloc_rec		ahigh = { 0 };
 	struct xfs_mount		*mp = tp->t_mountp;
+	unsigned int			mod;
 	int				error;
 
 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
@@ -530,10 +531,9 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	 * Set up query parameters to return free rtextents covering the range
 	 * we want.
 	 */
-	alow.ar_startext = info->low.rm_startblock;
-	ahigh.ar_startext = info->high.rm_startblock;
-	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
-	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
+	alow.ar_startext = xfs_rtb_to_rtxt(mp, info->low.rm_startblock);
+	ahigh.ar_startext = xfs_rtb_to_rtx(mp, info->high.rm_startblock, &mod);
+	if (mod)
 		ahigh.ar_startext++;
 	error = xfs_rtalloc_query_range(mp, tp, &alow, &ahigh,
 			xfs_getfsmap_rtdev_rtbitmap_helper, info);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 04a468f4cb8a..1953a00755f4 100644
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

