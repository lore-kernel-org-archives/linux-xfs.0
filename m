Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DA9B653
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372220; cv=none; b=jTwbl6DetbqKWBio41vrsTjKaHSYVYCXB0q9r5BOcfgN3qcVXT8uhtjF0uO4TTVjMe72nkh9/LqwbwBda4V/Uh/BdEt295Im+mHVAHL9QsWszdWvLOGsRWwOojeSV7VxlH5IjaEbCe6J/BBqdUyrosY4as1G+CNmLKvhft1L00s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372220; c=relaxed/simple;
	bh=lh4PLGHIBMu2AEkauptWL93Ks3QHDDPDP3i43Re1mzI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lg4suA4KIzpDJrkNS9hgrHgkNEdEJ508e54g6w1QOrZPUS10ptaIdg2I7IgXByEeTtyHR+xShHX5ImY+Z66coj5bc7SarMgbf84rMAgKaYM9w8XhcYKnJTuG8HIlxfKEF7NNF82zaUoqp97BmYqp34KomvGeesQsOkmwoZx8Fs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jT1QbCkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jT1QbCkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9909FC32782;
	Fri, 23 Aug 2024 00:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372220;
	bh=lh4PLGHIBMu2AEkauptWL93Ks3QHDDPDP3i43Re1mzI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jT1QbCkGiL85xt9KAvPCSC9BbwRtUBX2x9fcoIjoQ4L6V5csGbovp8aLJ0mHGppkr
	 Z3ykBk/k1XVw6YHzc8+kI8CaHIfmEa1TY9jJ4rSnPHlbHLeySD5UzDwmBM7OmFwRQh
	 tYmi9TB/KigFT0VkopGpS4huGB+lSRT6BKT+/tw7dDhuSvD9w5EI+/ZJnBoqW6On2t
	 CzlRxSbcHt9qqFsIiXL1Y5ZptPKPyiAJbdfMvXJ8zTAuAHCQVPn+nIIB46Iu9k/Pi6
	 OOImmKnMm63w07BptEsnnimbbPXIhsTu57+91cSA1pBOxpoBF7qHFqOMTgdWqhyrpa
	 AleEiZwzropVw==
Date: Thu, 22 Aug 2024 17:17:00 -0700
Subject: [PATCH 09/24] xfs: rearrange xfs_fsmap.c a little bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087398.59588.6301556679404762421.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The order of the functions in this file has gotten a little confusing
over the years.  Specifically, the two data device implementations
(bnobt and rmapbt) could be adjacent in the source code instead of split
in two by the logdev and rtdev fsmap implementations.  We're about to
add more functionality to this file, so rearrange things now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |  268 ++++++++++++++++++++++++++--------------------------
 1 file changed, 134 insertions(+), 134 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index e154466268757..615253406fde1 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -441,140 +441,6 @@ xfs_getfsmap_set_irec_flags(
 		irec->rm_flags |= XFS_RMAP_UNWRITTEN;
 }
 
-/* Execute a getfsmap query against the log device. */
-STATIC int
-xfs_getfsmap_logdev(
-	struct xfs_trans		*tp,
-	const struct xfs_fsmap		*keys,
-	struct xfs_getfsmap_info	*info)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_rmap_irec		rmap;
-	xfs_daddr_t			rec_daddr, len_daddr;
-	xfs_fsblock_t			start_fsb, end_fsb;
-	uint64_t			eofs;
-
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-	if (keys[0].fmr_physical >= eofs)
-		return 0;
-	start_fsb = XFS_BB_TO_FSBT(mp,
-				keys[0].fmr_physical + keys[0].fmr_length);
-	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
-
-	/* Adjust the low key if we are continuing from where we left off. */
-	if (keys[0].fmr_length > 0)
-		info->low_daddr = XFS_FSB_TO_BB(mp, start_fsb);
-
-	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_fsb);
-	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_fsb);
-
-	if (start_fsb > 0)
-		return 0;
-
-	/* Fabricate an rmap entry for the external log device. */
-	rmap.rm_startblock = 0;
-	rmap.rm_blockcount = mp->m_sb.sb_logblocks;
-	rmap.rm_owner = XFS_RMAP_OWN_LOG;
-	rmap.rm_offset = 0;
-	rmap.rm_flags = 0;
-
-	rec_daddr = XFS_FSB_TO_BB(mp, rmap.rm_startblock);
-	len_daddr = XFS_FSB_TO_BB(mp, rmap.rm_blockcount);
-	return xfs_getfsmap_helper(tp, info, &rmap, rec_daddr, len_daddr);
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
-	xfs_rtblock_t			rtbno;
-	xfs_daddr_t			rec_daddr, len_daddr;
-
-	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
-	rec_daddr = XFS_FSB_TO_BB(mp, rtbno);
-	irec.rm_startblock = rtbno;
-
-	rtbno = xfs_rtx_to_rtb(mp, rec->ar_extcount);
-	len_daddr = XFS_FSB_TO_BB(mp, rtbno);
-	irec.rm_blockcount = rtbno;
-
-	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
-	irec.rm_offset = 0;
-	irec.rm_flags = 0;
-
-	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr, len_daddr);
-}
-
-/* Execute a getfsmap query against the realtime device rtbitmap. */
-STATIC int
-xfs_getfsmap_rtdev_rtbitmap(
-	struct xfs_trans		*tp,
-	const struct xfs_fsmap		*keys,
-	struct xfs_getfsmap_info	*info)
-{
-
-	struct xfs_rtalloc_rec		ahigh = { 0 };
-	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_rtblock_t			start_rtb;
-	xfs_rtblock_t			end_rtb;
-	xfs_rtxnum_t			high;
-	uint64_t			eofs;
-	int				error;
-
-	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
-	if (keys[0].fmr_physical >= eofs)
-		return 0;
-	start_rtb = XFS_BB_TO_FSBT(mp,
-				keys[0].fmr_physical + keys[0].fmr_length);
-	end_rtb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
-
-	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
-
-	/* Adjust the low key if we are continuing from where we left off. */
-	if (keys[0].fmr_length > 0) {
-		info->low_daddr = XFS_FSB_TO_BB(mp, start_rtb);
-		if (info->low_daddr >= eofs)
-			return 0;
-	}
-
-	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_rtb);
-	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_rtb);
-
-	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
-
-	/*
-	 * Set up query parameters to return free rtextents covering the range
-	 * we want.
-	 */
-	high = xfs_rtb_to_rtxup(mp, end_rtb);
-	error = xfs_rtalloc_query_range(mp, tp, xfs_rtb_to_rtx(mp, start_rtb),
-			high, xfs_getfsmap_rtdev_rtbitmap_helper, info);
-	if (error)
-		goto err;
-
-	/*
-	 * Report any gaps at the end of the rtbitmap by simulating a null
-	 * rmap starting at the block after the end of the query range.
-	 */
-	info->last = true;
-	ahigh.ar_startext = min(mp->m_sb.sb_rextents, high);
-
-	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, tp, &ahigh, info);
-	if (error)
-		goto err;
-err:
-	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
-	return error;
-}
-#endif /* CONFIG_XFS_RT */
-
 static inline bool
 rmap_not_shareable(struct xfs_mount *mp, const struct xfs_rmap_irec *r)
 {
@@ -799,6 +665,140 @@ xfs_getfsmap_datadev_bnobt(
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
+	xfs_daddr_t			rec_daddr, len_daddr;
+	xfs_fsblock_t			start_fsb, end_fsb;
+	uint64_t			eofs;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	start_fsb = XFS_BB_TO_FSBT(mp,
+				keys[0].fmr_physical + keys[0].fmr_length);
+	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
+
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (keys[0].fmr_length > 0)
+		info->low_daddr = XFS_FSB_TO_BB(mp, start_fsb);
+
+	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_fsb);
+	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_fsb);
+
+	if (start_fsb > 0)
+		return 0;
+
+	/* Fabricate an rmap entry for the external log device. */
+	rmap.rm_startblock = 0;
+	rmap.rm_blockcount = mp->m_sb.sb_logblocks;
+	rmap.rm_owner = XFS_RMAP_OWN_LOG;
+	rmap.rm_offset = 0;
+	rmap.rm_flags = 0;
+
+	rec_daddr = XFS_FSB_TO_BB(mp, rmap.rm_startblock);
+	len_daddr = XFS_FSB_TO_BB(mp, rmap.rm_blockcount);
+	return xfs_getfsmap_helper(tp, info, &rmap, rec_daddr, len_daddr);
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
+	xfs_rtblock_t			rtbno;
+	xfs_daddr_t			rec_daddr, len_daddr;
+
+	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	rec_daddr = XFS_FSB_TO_BB(mp, rtbno);
+	irec.rm_startblock = rtbno;
+
+	rtbno = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+	len_daddr = XFS_FSB_TO_BB(mp, rtbno);
+	irec.rm_blockcount = rtbno;
+
+	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
+	irec.rm_offset = 0;
+	irec.rm_flags = 0;
+
+	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr, len_daddr);
+}
+
+/* Execute a getfsmap query against the realtime device rtbitmap. */
+STATIC int
+xfs_getfsmap_rtdev_rtbitmap(
+	struct xfs_trans		*tp,
+	const struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+
+	struct xfs_rtalloc_rec		ahigh = { 0 };
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_rtblock_t			start_rtb;
+	xfs_rtblock_t			end_rtb;
+	xfs_rtxnum_t			high;
+	uint64_t			eofs;
+	int				error;
+
+	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	start_rtb = XFS_BB_TO_FSBT(mp,
+				keys[0].fmr_physical + keys[0].fmr_length);
+	end_rtb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
+
+	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
+
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (keys[0].fmr_length > 0) {
+		info->low_daddr = XFS_FSB_TO_BB(mp, start_rtb);
+		if (info->low_daddr >= eofs)
+			return 0;
+	}
+
+	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_rtb);
+	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_rtb);
+
+	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
+
+	/*
+	 * Set up query parameters to return free rtextents covering the range
+	 * we want.
+	 */
+	high = xfs_rtb_to_rtxup(mp, end_rtb);
+	error = xfs_rtalloc_query_range(mp, tp, xfs_rtb_to_rtx(mp, start_rtb),
+			high, xfs_getfsmap_rtdev_rtbitmap_helper, info);
+	if (error)
+		goto err;
+
+	/*
+	 * Report any gaps at the end of the rtbitmap by simulating a null
+	 * rmap starting at the block after the end of the query range.
+	 */
+	info->last = true;
+	ahigh.ar_startext = min(mp->m_sb.sb_rextents, high);
+
+	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, tp, &ahigh, info);
+	if (error)
+		goto err;
+err:
+	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+	return error;
+}
+#endif /* CONFIG_XFS_RT */
+
 /* Do we recognize the device? */
 STATIC bool
 xfs_getfsmap_is_valid_device(

