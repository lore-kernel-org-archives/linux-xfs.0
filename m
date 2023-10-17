Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C26CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbjJQPvT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbjJQPvS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:51:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B109E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:51:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE4BC433C7;
        Tue, 17 Oct 2023 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557876;
        bh=Iayk0cD/nyD7tf2aXOlMsDDHITPwn6G3in2HXBTGVfs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iVGjq4V5aI84+axjLOQOwoKIj0deO25B0oYICxe2NwDRcgwAIPkBvimdzyRCFC/gS
         w7dTTPVR3u3FSo+YXloZrddC3YpjRh+VvldgIc697mBFzsZdvfaq2cY7PA8YGk4xGM
         mu2dn9pilRX/S3dS//XSwu2W5nIi2tqFHQE/vAwVuceHOzx6mdCsZ0zLxIJY/vsbNt
         8xv0mq5Xtn73ffc+udlabTGF10Q4/soiJ53wRWedBWr3YUlnRAiAEBO5AG8FdIZpVy
         9CeyXu9YwBYu+4ko6cyYP8fFybZSclgYzSeuMJKt+HPr+haVmeynBFMx1jrF4jHZG9
         sYbqqlpeElEUg==
Date:   Tue, 17 Oct 2023 08:51:14 -0700
Subject: [PATCH 5/7] xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741804.3165781.8862464835111645515.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
References: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c     |    8 ++------
 fs/xfs/libxfs/xfs_rtbitmap.h |   14 ++++++++++++++
 fs/xfs/scrub/rtbitmap.c      |   14 +++++---------
 fs/xfs/xfs_bmap_util.c       |   10 ++++------
 fs/xfs/xfs_fsmap.c           |    7 ++-----
 fs/xfs/xfs_rtalloc.c         |    3 +--
 6 files changed, 28 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fc96aa59a691..be62acffad6c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4826,12 +4826,8 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got->br_startoff <= del->br_startoff);
 	ASSERT(got_endoff >= del_endoff);
 
-	if (isrt) {
-		uint64_t	rtexts = del->br_blockcount;
-
-		do_div(rtexts, mp->m_sb.sb_rextsize);
-		xfs_mod_frextents(mp, rtexts);
-	}
+	if (isrt)
+		xfs_mod_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
 
 	/*
 	 * Update the inode delalloc counter now and wait to update the
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 9df583083407..ff901bf3d1ee 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -70,6 +70,20 @@ xfs_rtb_to_rtxrem(
 	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, off);
 }
 
+/*
+ * Convert an rt block number into an rt extent number, rounding up to the next
+ * rt extent if the rt block is not aligned to an rt extent boundary.
+ */
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtxup(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	if (do_div(rtbno, mp->m_sb.sb_rextsize))
+		rtbno++;
+	return rtbno;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 584a2b8badac..41a1d89ae8e6 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -128,26 +128,22 @@ xchk_rtbitmap(
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
+	startext = xfs_rtb_to_rtx(sc->mp, rtbno);
+	endext = xfs_rtb_to_rtx(sc->mp, rtbno + len - 1);
 	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
-			&is_free);
+	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext,
+			endext - startext + 1, &is_free);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		goto out_unlock;
 	if (is_free)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4f53f784f06d..25a03c1276e3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -156,14 +156,12 @@ xfs_bmap_rtalloc(
 	 * Realtime allocation, done through xfs_rtallocate_extent.
 	 */
 	if (ignore_locality)
-		ap->blkno = 0;
+		rtx = 0;
 	else
-		do_div(ap->blkno, mp->m_sb.sb_rextsize);
-	rtx = ap->blkno;
-	ap->length = ralen;
+		rtx = xfs_rtb_to_rtx(mp, ap->blkno);
 	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
-	error = xfs_rtallocate_extent(ap->tp, ap->blkno, raminlen, ap->length,
-			&ralen, ap->wasdel, prod, &rtx);
+	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
+			ap->wasdel, prod, &rtx);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 1a187bc9da3d..5a72217f5feb 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -539,11 +539,8 @@ xfs_getfsmap_rtdev_rtbitmap(
 	 * Set up query parameters to return free rtextents covering the range
 	 * we want.
 	 */
-	alow.ar_startext = start_rtb;
-	ahigh.ar_startext = end_rtb;
-	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
-	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
-		ahigh.ar_startext++;
+	alow.ar_startext = xfs_rtb_to_rtx(mp, start_rtb);
+	ahigh.ar_startext = xfs_rtb_to_rtxup(mp, end_rtb);
 	error = xfs_rtalloc_query_range(mp, tp, &alow, &ahigh,
 			xfs_getfsmap_rtdev_rtbitmap_helper, info);
 	if (error)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 62faec195040..ac7c269ad547 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1058,8 +1058,7 @@ xfs_growfs_rt(
 		nrblocks_step = (bmbno + 1) * NBBY * nsbp->sb_blocksize *
 				nsbp->sb_rextsize;
 		nsbp->sb_rblocks = min(nrblocks, nrblocks_step);
-		nsbp->sb_rextents = nsbp->sb_rblocks;
-		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);
+		nsbp->sb_rextents = xfs_rtb_to_rtx(nmp, nsbp->sb_rblocks);
 		ASSERT(nsbp->sb_rextents != 0);
 		nsbp->sb_rextslog = xfs_highbit32(nsbp->sb_rextents);
 		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;

