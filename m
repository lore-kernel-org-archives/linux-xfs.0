Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE18216203
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845592; cv=none; b=i362oHCQh66qC5ZnuwJ2izSWlEBqtmvJQ81eSsSm4pYRgjD8o8UaFDsp5nWgLvXRbljgG4DpuHH5G7CWBf56a79+2TjI+hFwstT7dGeQ2l+K6vbubXYeBY0IpfJ0xfIzBAC4tufwH6BSWyOlH9tkB0ioERC6aT1No43sDKWEKJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845592; c=relaxed/simple;
	bh=cPy+w3P3xrZU4SgfMIyiW/yBXoFfRtlNApIeoaG+FTo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ObdIiEw/c3RU6C1pRK+syGafG2COEySHUa8t0tizzSO4zXeecb+2PQtAqzaRlyoU2MccwgpZZDR+p1H0gZFNW0YZZJH/nAQdlS90owePAIWw2BEaubU80kmPWB/kgKEjVW70cbY3mEaCVfAD6hABgD2VI5EG/c6Mi+Dr9mgjN4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYfHoePn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYfHoePn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7D5C4CECF;
	Tue,  5 Nov 2024 22:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845591;
	bh=cPy+w3P3xrZU4SgfMIyiW/yBXoFfRtlNApIeoaG+FTo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LYfHoePnUsl+LDyzBwhZELh5DAx1zuB3/ySaGCkRA6cx909G7bwQPo/qF/htWGuSH
	 ahvSE+skdMWL6e9eJeMs5Wa1nYlHjjZT44Q7Kfs+EyOytBNH0a6hq/7HB6t/EiWr0W
	 YqcEJukLU5tF/acznUlxVUGyGxx5H8xg2x5n9N0S8GNfq42obvPxpdaOzkONPAOfXZ
	 4LJj+hmC1DNhzyLXc3jIFRtfnMpQ2J2Eu3iRymdTXhYLRTMvwhPwsYGOwydI2CtMQi
	 bFaf3U4wbYjmRhHyvWY4+9G5vbTb4OSY4ROQdIOMwOGuwgN11H7tD2t67tix5hJymV
	 34ND4uZ+I+QIA==
Date: Tue, 05 Nov 2024 14:26:31 -0800
Subject: [PATCH 10/21] xfs: cleanup xfs_getfsmap_rtdev_rtbitmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397110.1871025.1269463296339855423.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Use mp->m_sb.sb_rblocks to calculate the end instead of sb_rextents that
needs a conversion, use consistent names to xfs_rtblock_t types, and
only calculated them by the time they are needed.  Remove the pointless
"high" local variable that only has a single user.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 40beb8d75f26b1..3d42153b4bdb29 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -754,30 +754,29 @@ xfs_getfsmap_rtdev_rtbitmap(
 
 	struct xfs_rtalloc_rec		ahigh = { 0 };
 	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_rtblock_t			start_rtb;
-	xfs_rtblock_t			end_rtb;
-	xfs_rtxnum_t			high;
+	xfs_rtblock_t			start_rtbno, end_rtbno;
 	uint64_t			eofs;
 	int				error;
 
-	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
-	start_rtb = XFS_BB_TO_FSBT(mp,
-				keys[0].fmr_physical + keys[0].fmr_length);
-	end_rtb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
 
 	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
 
 	/* Adjust the low key if we are continuing from where we left off. */
+	start_rtbno = xfs_daddr_to_rtb(mp,
+			keys[0].fmr_physical + keys[0].fmr_length);
 	if (keys[0].fmr_length > 0) {
-		info->low_daddr = xfs_rtb_to_daddr(mp, start_rtb);
+		info->low_daddr = xfs_rtb_to_daddr(mp, start_rtbno);
 		if (info->low_daddr >= eofs)
 			return 0;
 	}
 
-	trace_xfs_fsmap_low_linear_key(mp, info->dev, start_rtb);
-	trace_xfs_fsmap_high_linear_key(mp, info->dev, end_rtb);
+	end_rtbno = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fmr_physical));
+
+	trace_xfs_fsmap_low_linear_key(mp, info->dev, start_rtbno);
+	trace_xfs_fsmap_high_linear_key(mp, info->dev, end_rtbno);
 
 	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
 
@@ -785,9 +784,9 @@ xfs_getfsmap_rtdev_rtbitmap(
 	 * Set up query parameters to return free rtextents covering the range
 	 * we want.
 	 */
-	high = xfs_rtb_to_rtxup(mp, end_rtb);
-	error = xfs_rtalloc_query_range(mp, tp, xfs_rtb_to_rtx(mp, start_rtb),
-			high, xfs_getfsmap_rtdev_rtbitmap_helper, info);
+	error = xfs_rtalloc_query_range(mp, tp, xfs_rtb_to_rtx(mp, start_rtbno),
+			xfs_rtb_to_rtxup(mp, end_rtbno),
+			xfs_getfsmap_rtdev_rtbitmap_helper, info);
 	if (error)
 		goto err;
 

