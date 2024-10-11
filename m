Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175AA4A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608298; cv=none; b=bkeGDXZkr8fTzfAnHAZ/gZjOVuNaWPbFvYvW499MG7zK+COOqr8R6CcPv/O36go6QssaBdrUlytE3m6o8Xanz2DbjfRY59grEwxWNsCQJM6h7bz8dlFlmDPiMDoD3ROnvrQdZ5iNtLEGrbwwMCwXL5xb4Vfagvod3FHBfGKwPu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608298; c=relaxed/simple;
	bh=ZyKlNO+DWCOkCbx4P+pCbF4+mNW1MTZ3uAT8CKa9vWM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HTaoyx0P7WZRjsT7L/HQ8ThdxLQowmWM8fCkqPVPmyBz5/KFVGinZoKSZ0csdboRCVBP25ja3AoeQ5o/tr3QK2tRFNDo138LFaSf4y76GDyc5RdgbbrO+rG/hDwWhH6y1fIyNCZyzGyii0BbXnk3wzh8o1UQvLR4ZeHY7BAv09w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFAc+ZWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFAc+ZWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4185C4CEC5;
	Fri, 11 Oct 2024 00:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608297;
	bh=ZyKlNO+DWCOkCbx4P+pCbF4+mNW1MTZ3uAT8CKa9vWM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cFAc+ZWjM0ThnIFBnNY4vY6ZBg38QAtOfwlw7sRBpCYAKJCkCQrvPrgeK5rYB+IeG
	 9LLOltbB+c5aM1oP4g0bM0qBCmne2ShtJ658J+phnyPc86tgHg7U7gd9lQ7bPKBBSk
	 k5MtFXvCPlHVVAO872dlDBVlwx/Zj3tJrGVP2OXWpdnIFa9M8yStfvKYbFsX3K3NWV
	 RpM3hI5Ip0pxvg9clBJxr+7aLuP0fO/nDq2dbqmPlbC90ijx33NtpWe6s8Z5XT4PCy
	 lqnCZQ1k6TeO/yIDK1mI00OMPZqwnUIgqGL5yJxg3C8shqd5zlWfgBOLqaPEufTV9/
	 l/d/X1x1pvesw==
Date: Thu, 10 Oct 2024 17:58:17 -0700
Subject: [PATCH 10/21] xfs: cleanup xfs_getfsmap_rtdev_rtbitmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643119.4177836.8171641111761750154.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
---
 fs/xfs/xfs_fsmap.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index a31c748c85b0d8..526a91470ff7d4 100644
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
 

