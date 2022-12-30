Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8C9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbiLaBlf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235936AbiLaBle (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:41:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B7426D2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:41:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3030261C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E6DC433D2;
        Sat, 31 Dec 2022 01:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450892;
        bh=2mktnCrPNxsL0nffwGyx7h+5D/kPy8LJcKodNHMmxMs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MJVMPwLgu1lYhGfW30QCMWDMruDCRtllQGE/1SAu/RgFGJX5QP2teFgn8wvQiVP8H
         san7+Cl/nRPDkSWVhWp04OCYy7VLJ3v5sreTf9JZRI5mQB4yEmuoAVD+Z+oR/QS7Ut
         bG+XNauzFmR4Vw/+NLDKi0ymiEMf4HL1gyqWKsZw3Q4oRSShxQAaJs16PeR6VDXswI
         AFZ5B7/oDIYOTJtZWVpPwIf26SeLWWAj2EEIUwWXgkag7fztIgdGFbtDcYTekwDOnG
         TwqjyqRV7o9f532mFdi0nlk2Hab7pUCypUlqDgmwkpVFeEzInOLQ1NmimFnJUVx+P+
         HqLpzadT/zjlQ==
Subject: [PATCH 18/38] xfs: rearrange xfs_fsmap.c a little bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:18 -0800
Message-ID: <167243869855.715303.10438659359522602528.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The order of the functions in this file has gotten a little confusing
over the years.  Specifically, the two data device implementations
(bnobt and rmapbt) could be adjacent in the source code instead of split
in two by the logdev and rtdev fsmap implementations.  We're about to
add more functionality to this file, so rearrange things now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |  366 ++++++++++++++++++++++++++--------------------------
 1 file changed, 183 insertions(+), 183 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 71053f840ea4..dfd9e39ded6e 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -343,6 +343,21 @@ xfs_getfsmap_helper(
 	return 0;
 }
 
+/* Set rmap flags based on the getfsmap flags */
+static void
+xfs_getfsmap_set_irec_flags(
+	struct xfs_rmap_irec	*irec,
+	const struct xfs_fsmap	*fmr)
+{
+	irec->rm_flags = 0;
+	if (fmr->fmr_flags & FMR_OF_ATTR_FORK)
+		irec->rm_flags |= XFS_RMAP_ATTR_FORK;
+	if (fmr->fmr_flags & FMR_OF_EXTENT_MAP)
+		irec->rm_flags |= XFS_RMAP_BMBT_BLOCK;
+	if (fmr->fmr_flags & FMR_OF_PREALLOC)
+		irec->rm_flags |= XFS_RMAP_UNWRITTEN;
+}
+
 /* Transform a rmapbt irec into a fsmap */
 STATIC int
 xfs_getfsmap_datadev_helper(
@@ -385,189 +400,6 @@ xfs_getfsmap_datadev_bnobt_helper(
 	return xfs_getfsmap_helper(cur->bc_tp, info, &irec, rec_daddr);
 }
 
-/* Set rmap flags based on the getfsmap flags */
-static void
-xfs_getfsmap_set_irec_flags(
-	struct xfs_rmap_irec	*irec,
-	const struct xfs_fsmap	*fmr)
-{
-	irec->rm_flags = 0;
-	if (fmr->fmr_flags & FMR_OF_ATTR_FORK)
-		irec->rm_flags |= XFS_RMAP_ATTR_FORK;
-	if (fmr->fmr_flags & FMR_OF_EXTENT_MAP)
-		irec->rm_flags |= XFS_RMAP_BMBT_BLOCK;
-	if (fmr->fmr_flags & FMR_OF_PREALLOC)
-		irec->rm_flags |= XFS_RMAP_UNWRITTEN;
-}
-
-/* Execute a getfsmap query against the log device. */
-STATIC int
-xfs_getfsmap_logdev(
-	struct xfs_trans		*tp,
-	const struct xfs_fsmap		*keys,
-	struct xfs_getfsmap_info	*info)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_rmap_irec		rmap;
-	int				error;
-
-	/* Set up search keys */
-	info->low.rm_startblock = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
-	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
-	error = xfs_fsmap_owner_to_rmap(&info->low, keys);
-	if (error)
-		return error;
-	info->low.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
-
-	error = xfs_fsmap_owner_to_rmap(&info->high, keys + 1);
-	if (error)
-		return error;
-	info->high.rm_startblock = -1U;
-	info->high.rm_owner = ULLONG_MAX;
-	info->high.rm_offset = ULLONG_MAX;
-	info->high.rm_blockcount = 0;
-	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
-	info->missing_owner = XFS_FMR_OWN_FREE;
-
-	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
-	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
-
-	if (keys[0].fmr_physical > 0)
-		return 0;
-
-	/* Fabricate an rmap entry for the external log device. */
-	rmap.rm_startblock = 0;
-	rmap.rm_blockcount = mp->m_sb.sb_logblocks;
-	rmap.rm_owner = XFS_RMAP_OWN_LOG;
-	rmap.rm_offset = 0;
-	rmap.rm_flags = 0;
-
-	return xfs_getfsmap_helper(tp, info, &rmap, 0);
-}
-
-#ifdef CONFIG_XFS_RT
-/* Transform a rtbitmap "record" into a fsmap */
-STATIC int
-xfs_getfsmap_rtdev_rtbitmap_helper(
-	struct xfs_mount		*mp,
-	struct xfs_trans		*tp,
-	const struct xfs_rtalloc_rec	*rec,
-	void				*priv)
-{
-	struct xfs_getfsmap_info	*info = priv;
-	struct xfs_rmap_irec		irec;
-	xfs_daddr_t			rec_daddr;
-
-	irec.rm_startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
-	rec_daddr = XFS_FSB_TO_BB(mp, irec.rm_startblock);
-	irec.rm_blockcount = xfs_rtx_to_rtb(mp, rec->ar_extcount);
-	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
-	irec.rm_offset = 0;
-	irec.rm_flags = 0;
-
-	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
-}
-
-/* Execute a getfsmap query against the realtime device. */
-STATIC int
-__xfs_getfsmap_rtdev(
-	struct xfs_trans		*tp,
-	const struct xfs_fsmap		*keys,
-	int				(*query_fn)(struct xfs_trans *,
-						    struct xfs_getfsmap_info *),
-	struct xfs_getfsmap_info	*info)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_fsblock_t			start_fsb;
-	xfs_fsblock_t			end_fsb;
-	uint64_t			eofs;
-	int				error = 0;
-
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
-	if (keys[0].fmr_physical >= eofs)
-		return 0;
-	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
-	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
-
-	/* Set up search keys */
-	info->low.rm_startblock = start_fsb;
-	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
-	if (error)
-		return error;
-	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
-	info->low.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
-
-	info->high.rm_startblock = end_fsb;
-	error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
-	if (error)
-		return error;
-	info->high.rm_offset = XFS_BB_TO_FSBT(mp, keys[1].fmr_offset);
-	info->high.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
-
-	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
-	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
-
-	return query_fn(tp, info);
-}
-
-/* Actually query the realtime bitmap. */
-STATIC int
-xfs_getfsmap_rtdev_rtbitmap_query(
-	struct xfs_trans		*tp,
-	struct xfs_getfsmap_info	*info)
-{
-	struct xfs_rtalloc_rec		alow = { 0 };
-	struct xfs_rtalloc_rec		ahigh = { 0 };
-	struct xfs_mount		*mp = tp->t_mountp;
-	unsigned int			mod;
-	int				error;
-
-	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
-
-	/*
-	 * Set up query parameters to return free rtextents covering the range
-	 * we want.
-	 */
-	alow.ar_startext = xfs_rtb_to_rtxt(mp, info->low.rm_startblock);
-	ahigh.ar_startext = xfs_rtb_to_rtx(mp, info->high.rm_startblock, &mod);
-	if (mod)
-		ahigh.ar_startext++;
-	error = xfs_rtalloc_query_range(mp, tp, &alow, &ahigh,
-			xfs_getfsmap_rtdev_rtbitmap_helper, info);
-	if (error)
-		goto err;
-
-	/*
-	 * Report any gaps at the end of the rtbitmap by simulating a null
-	 * rmap starting at the block after the end of the query range.
-	 */
-	info->last = true;
-	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext);
-
-	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, tp, &ahigh, info);
-	if (error)
-		goto err;
-err:
-	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
-	return error;
-}
-
-/* Execute a getfsmap query against the realtime device rtbitmap. */
-STATIC int
-xfs_getfsmap_rtdev_rtbitmap(
-	struct xfs_trans		*tp,
-	const struct xfs_fsmap		*keys,
-	struct xfs_getfsmap_info	*info)
-{
-	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
-	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rtbitmap_query,
-			info);
-}
-#endif /* CONFIG_XFS_RT */
-
 /* Execute a getfsmap query against the regular data device. */
 STATIC int
 __xfs_getfsmap_datadev(
@@ -766,6 +598,174 @@ xfs_getfsmap_datadev_bnobt(
 			xfs_getfsmap_datadev_bnobt_query, &akeys[0]);
 }
 
+/* Execute a getfsmap query against the log device. */
+STATIC int
+xfs_getfsmap_logdev(
+	struct xfs_trans		*tp,
+	const struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rmap_irec		rmap;
+	int				error;
+
+	/* Set up search keys */
+	info->low.rm_startblock = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
+	error = xfs_fsmap_owner_to_rmap(&info->low, keys);
+	if (error)
+		return error;
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+
+	error = xfs_fsmap_owner_to_rmap(&info->high, keys + 1);
+	if (error)
+		return error;
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+	info->missing_owner = XFS_FMR_OWN_FREE;
+
+	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
+	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
+
+	if (keys[0].fmr_physical > 0)
+		return 0;
+
+	/* Fabricate an rmap entry for the external log device. */
+	rmap.rm_startblock = 0;
+	rmap.rm_blockcount = mp->m_sb.sb_logblocks;
+	rmap.rm_owner = XFS_RMAP_OWN_LOG;
+	rmap.rm_offset = 0;
+	rmap.rm_flags = 0;
+
+	return xfs_getfsmap_helper(tp, info, &rmap, 0);
+}
+
+#ifdef CONFIG_XFS_RT
+/* Transform a rtbitmap "record" into a fsmap */
+STATIC int
+xfs_getfsmap_rtdev_rtbitmap_helper(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct xfs_getfsmap_info	*info = priv;
+	struct xfs_rmap_irec		irec;
+	xfs_daddr_t			rec_daddr;
+
+	irec.rm_startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	rec_daddr = XFS_FSB_TO_BB(mp, irec.rm_startblock);
+	irec.rm_blockcount = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
+	irec.rm_offset = 0;
+	irec.rm_flags = 0;
+
+	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
+}
+
+/* Execute a getfsmap query against the realtime device. */
+STATIC int
+__xfs_getfsmap_rtdev(
+	struct xfs_trans		*tp,
+	const struct xfs_fsmap		*keys,
+	int				(*query_fn)(struct xfs_trans *,
+						    struct xfs_getfsmap_info *),
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	uint64_t			eofs;
+	int				error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
+	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
+
+	/* Set up search keys */
+	info->low.rm_startblock = start_fsb;
+	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
+	if (error)
+		return error;
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+
+	info->high.rm_startblock = end_fsb;
+	error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
+	if (error)
+		return error;
+	info->high.rm_offset = XFS_BB_TO_FSBT(mp, keys[1].fmr_offset);
+	info->high.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
+
+	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
+	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
+
+	return query_fn(tp, info);
+}
+
+/* Actually query the realtime bitmap. */
+STATIC int
+xfs_getfsmap_rtdev_rtbitmap_query(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_rtalloc_rec		alow = { 0 };
+	struct xfs_rtalloc_rec		ahigh = { 0 };
+	struct xfs_mount		*mp = tp->t_mountp;
+	unsigned int			mod;
+	int				error;
+
+	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
+
+	/*
+	 * Set up query parameters to return free rtextents covering the range
+	 * we want.
+	 */
+	alow.ar_startext = xfs_rtb_to_rtxt(mp, info->low.rm_startblock);
+	ahigh.ar_startext = xfs_rtb_to_rtx(mp, info->high.rm_startblock, &mod);
+	if (mod)
+		ahigh.ar_startext++;
+	error = xfs_rtalloc_query_range(mp, tp, &alow, &ahigh,
+			xfs_getfsmap_rtdev_rtbitmap_helper, info);
+	if (error)
+		goto err;
+
+	/*
+	 * Report any gaps at the end of the rtbitmap by simulating a null
+	 * rmap starting at the block after the end of the query range.
+	 */
+	info->last = true;
+	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext);
+
+	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, tp, &ahigh, info);
+	if (error)
+		goto err;
+err:
+	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+	return error;
+}
+
+/* Execute a getfsmap query against the realtime device rtbitmap. */
+STATIC int
+xfs_getfsmap_rtdev_rtbitmap(
+	struct xfs_trans		*tp,
+	const struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
+	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rtbitmap_query,
+			info);
+}
+#endif /* CONFIG_XFS_RT */
+
 /* Do we recognize the device? */
 STATIC bool
 xfs_getfsmap_is_valid_device(

