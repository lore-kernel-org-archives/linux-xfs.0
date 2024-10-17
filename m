Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208EE21C194
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191757; cv=none; b=uiLWcYwk89RT0Xd25zgs+skPeoCzW3agBPdeMtuaYkXxX2N1n++ndn9/JRFsPSpAJQ9/s3htTHnrbO/Z4oGdIyjipH9GkodulJalxhg02dNoIDLy165hoCIOz0b4D307DNi3taGcs8tWfmqnwsee719ioo9q3HglpVuFCKMDuqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191757; c=relaxed/simple;
	bh=601owp6ZTEPvWA8vyFus+dn/HVtkttMMh0Exk1wahfU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UeKCwNkA4DqYEvOqOMnQ98eOyckdrgfz2njsCO2GOIa+RmLiEm+ma/41LofiHT7Z0Ak/AQ1mx1e1SsytQAtixC3vDu4ZJ45lo52JlYWXhxh5NRhSSRXndTXcZz5TKR0y5gR1hev1OlyJozl3DzDZu8QPyeLmIWlif+xgRJLN4ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qk3SEHbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qk3SEHbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD19C4CECE;
	Thu, 17 Oct 2024 19:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191756;
	bh=601owp6ZTEPvWA8vyFus+dn/HVtkttMMh0Exk1wahfU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qk3SEHbUXVz+tHB2AJtl8CQowvOTO2AfUdVwZnhu2IRRitHl84MUTTz+fwbxZTDJD
	 /yFvF1J+IJOBoTlJ/9VCCZ8Q504dOaTPBUIPUlCIQfJTTkULwf+4mhqIkn9T7LJ6OI
	 wNH2vKoNyQnnrO1E3DwpWISvMUZFXSGAetu8yY3RwAc5D7zt9iBTNDYcYS8o58UWZR
	 L5hnxu5cQbqhsbsCR3e+MRetSp4IFw3nwIEcANMNozxnIvTN6UMcUKa8cueD0S38Qh
	 N804ByL7OZ19K9uZJMF5FtGRmaqYkrmOn/tryDlxzxblcLfbrDaIaWxYo1FIXy8G0l
	 40sDReUWRNI2w==
Date: Thu, 17 Oct 2024 12:02:36 -0700
Subject: [PATCH 16/21] xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070674.3452315.6285713991093575175.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Split the code to set up a fake mount point to calculate new RT
geometry out of xfs_growfs_rt_bmblock so that it can be reused.

Note that this changes the rmblocks calculation method to be based
on the passed in rblocks and extsize and not the explicitly passed
one, but both methods will always lead to the same result.  The new
version just does a little bit more math while being more general.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   52 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 66e8a5973230e8..53503b675f9519 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -734,6 +734,36 @@ xfs_rtginode_ensure(
 	return xfs_rtginode_create(rtg, type, true);
 }
 
+static struct xfs_mount *
+xfs_growfs_rt_alloc_fake_mount(
+	const struct xfs_mount	*mp,
+	xfs_rfsblock_t		rblocks,
+	xfs_agblock_t		rextsize)
+{
+	struct xfs_mount	*nmp;
+
+	nmp = kmemdup(mp, sizeof(*mp), GFP_KERNEL);
+	if (!nmp)
+		return NULL;
+	nmp->m_sb.sb_rextsize = rextsize;
+	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
+	nmp->m_sb.sb_rblocks = rblocks;
+	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
+	nmp->m_sb.sb_rbmblocks = xfs_rtbitmap_blockcount(nmp,
+			nmp->m_sb.sb_rextents);
+	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
+	nmp->m_rsumlevels = nmp->m_sb.sb_rextslog + 1;
+	nmp->m_rsumblocks = xfs_rtsummary_blockcount(nmp, nmp->m_rsumlevels,
+			nmp->m_sb.sb_rbmblocks);
+
+	if (rblocks > 0)
+		nmp->m_features |= XFS_FEAT_REALTIME;
+
+	/* recompute growfsrt reservation from new rsumsize */
+	xfs_trans_resv_calc(nmp, &nmp->m_resv);
+	return nmp;
+}
+
 static int
 xfs_growfs_rt_bmblock(
 	struct xfs_rtgroup	*rtg,
@@ -756,25 +786,15 @@ xfs_growfs_rt_bmblock(
 	xfs_rtbxlen_t		freed_rtx;
 	int			error;
 
-
-	nrblocks_step = (bmbno + 1) * NBBY * mp->m_sb.sb_blocksize * rextsize;
-
-	nmp = nargs.mp = kmemdup(mp, sizeof(*mp), GFP_KERNEL);
-	if (!nmp)
-		return -ENOMEM;
-
 	/*
 	 * Calculate new sb and mount fields for this round.
 	 */
-	nmp->m_sb.sb_rextsize = rextsize;
-	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
-	nmp->m_sb.sb_rbmblocks = bmbno + 1;
-	nmp->m_sb.sb_rblocks = min(nrblocks, nrblocks_step);
-	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
-	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
-	nmp->m_rsumlevels = nmp->m_sb.sb_rextslog + 1;
-	nmp->m_rsumblocks = xfs_rtsummary_blockcount(mp, nmp->m_rsumlevels,
-			nmp->m_sb.sb_rbmblocks);
+	nrblocks_step = (bmbno + 1) * NBBY * mp->m_sb.sb_blocksize * rextsize;
+	nmp = nargs.mp = xfs_growfs_rt_alloc_fake_mount(mp,
+			min(nrblocks, nrblocks_step), rextsize);
+	if (!nmp)
+		return -ENOMEM;
+
 	rtg->rtg_extents = xfs_rtgroup_extents(nmp, rtg_rgno(rtg));
 
 	/*

