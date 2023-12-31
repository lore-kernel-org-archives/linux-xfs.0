Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD55BBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0mbL56E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7761EC433C8;
	Sun, 31 Dec 2023 21:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058589;
	bh=7YzAdLPjL9f0cgJVIiioe1voLkSZOtqUaFenqe16OGg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S0mbL56E0uwgxam72L06wS1gzf95aJpe9M20ajNjbfRUju+/cn7S+lCXQEtYAGW+S
	 tRUL2CfIaovoCaX5CFDSqr3B6yv5ueC1C8IpYQishy/JSgwfcmg6q72L2W/oAjcYmH
	 97HE8xLg1/zd07V8ChcduKrPqGw5+Ch4K2/6b8YInRV9LpYEgiJqViPSU/9rqZ5Rfz
	 FlcJ5jqZ4jqjdaWoPeH4faMceYpnucnpblK94QVO3rnAZKAYaCh0Vy8dFiozU6cZ+S
	 HbhkjLm6bIggKa/AwvfUMDjJ55upON82VWgql08ttEV/rMWdAkh1QnxPfJ+CMtDtGC
	 IFyMX96jQRthg==
Date: Sun, 31 Dec 2023 13:36:28 -0800
Subject: [PATCH 18/39] xfs: rearrange xfs_fsmap.c a little bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850190.1764998.8305564725972480539.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_fsmap.c |  270 ++++++++++++++++++++++++++--------------------------
 1 file changed, 135 insertions(+), 135 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index c49a5b01c3e0c..34769cb35c908 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -427,141 +427,6 @@ xfs_getfsmap_set_irec_flags(
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
-	struct xfs_rtalloc_rec		alow = { 0 };
-	struct xfs_rtalloc_rec		ahigh = { 0 };
-	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_rtblock_t			start_rtb;
-	xfs_rtblock_t			end_rtb;
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
-	alow.ar_startext = xfs_rtb_to_rtx(mp, start_rtb);
-	ahigh.ar_startext = xfs_rtb_to_rtxup(mp, end_rtb);
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
-#endif /* CONFIG_XFS_RT */
-
 static inline bool
 rmap_not_shareable(struct xfs_mount *mp, const struct xfs_rmap_irec *r)
 {
@@ -786,6 +651,141 @@ xfs_getfsmap_datadev_bnobt(
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
+	struct xfs_rtalloc_rec		alow = { 0 };
+	struct xfs_rtalloc_rec		ahigh = { 0 };
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_rtblock_t			start_rtb;
+	xfs_rtblock_t			end_rtb;
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
+	alow.ar_startext = xfs_rtb_to_rtx(mp, start_rtb);
+	ahigh.ar_startext = xfs_rtb_to_rtxup(mp, end_rtb);
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
+#endif /* CONFIG_XFS_RT */
+
 /* Do we recognize the device? */
 STATIC bool
 xfs_getfsmap_is_valid_device(

