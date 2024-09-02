Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D1419CC04
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301920; cv=none; b=iqpfsVMiW4OYX3hAyM3a3RHuEtFi3Pb2hZN2Z0qCGDSdwwOFGn4kSNDAMhn7P12qMW2CzzpzLkSP7kKfbeyf/4uQzmttT3ebItJ1kiuGxv9tB07gW5+B8QQAtrz3XrkyNOHPAgvdFAVlkflP1qZnuzHc7dmq0uAWyv0pAATqVkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301920; c=relaxed/simple;
	bh=PLSvqTWky3Mj7Et94DcI+AANmhVH+bn/gGVSBPfnpXI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WCHSo/12/cHBmxLUzFwB+uyYbCbcd6KljhlJ+Ctp11a6yY+aADOBJULh6FrOe0OmpUstHFkQ2WLf843aNgzLKGQ/qh8nlq0gY/hDXDiod4oUfx4O4k+887m2oulY0rqGa63qkieAWFHjvuP4eCU920NsdXoCkalE5FIc9lE9p64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZW+0FRmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZW+0FRmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E120AC4CEC2;
	Mon,  2 Sep 2024 18:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301919;
	bh=PLSvqTWky3Mj7Et94DcI+AANmhVH+bn/gGVSBPfnpXI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZW+0FRmLZGJ2YoLlHhs4k5T677If//hXOi7rbHn9mcLSNBRw86dTsW6e+YVgqirG4
	 B0u4ijo4JOVHpsF72S1q1BdVbXheDp98B506gQIRM6n6Jb++OzdYwA2sMva/llsYdd
	 vTOPigaeYUxPKBmQ+h1XypxvOQbxItvcY9N3TBDijAkxk5S+FNKMFNAG9JYEzXO1XL
	 7E+gV8hyX+nTRTu4dQnLVT3+7YnqgiDQy8ua6tgEopmVjNNzFz3cTgBg3KNHaUmtoB
	 jrCV+mxI7fDVH5W+9EqFwfU2Ldq4dGhyG0mZdS2dlCyCWwYxKJI6y6p+44FUVELljy
	 E0tGgt6Hd6jbw==
Date: Mon, 02 Sep 2024 11:31:59 -0700
Subject: [PATCH 09/10] xfs: rearrange xfs_fsmap.c a little bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106914.3326080.18443901492043365071.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
References: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsmap.c |  268 ++++++++++++++++++++++++++--------------------------
 1 file changed, 134 insertions(+), 134 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index e15446626875..615253406fde 100644
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

