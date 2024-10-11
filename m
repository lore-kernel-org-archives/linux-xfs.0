Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EC04A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608392; cv=none; b=ihBKvHqRvqnK6EwUKjKFI2IY01rdt5T4wTc6JlpNHngqDJ5pj1Blr+MwXC/KpXpofbPHVNfCmE+8HLJuiP/GlyOb9OK+pe7l90h+/vPLcemWwsbxNU6949TFSCDtZQkUJsZ5qP8WVYObJHWDaecQtcgzKqIcBr/N1iHVswnYN2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608392; c=relaxed/simple;
	bh=601owp6ZTEPvWA8vyFus+dn/HVtkttMMh0Exk1wahfU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QcKWd8Pvu2EZVpVjXjqiV++jymXDCRIvrdWMxQIgzwUQ7qyCgLYzHLq7blsQB13cv8YpFxE93qamy/PUbXJf7KbyqgfKc14SRB0dcQ9mALhB5xQk44PQzubbsiJUcLjy8E0ZkYFwDnI1SOReDa2Z/MXo2FK6T3tJ6DEIN0jsFEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzgyMqYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzgyMqYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721F2C4CEC5;
	Fri, 11 Oct 2024 00:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608391;
	bh=601owp6ZTEPvWA8vyFus+dn/HVtkttMMh0Exk1wahfU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FzgyMqYrMjbbMl54jeKIC9m1Z65rNtMtTPCGZHuYkwgkJ2bq1nhMCbbCDBbvSHcEV
	 B6cZLL40afredJCkvVFRcKbiXl/nBCFWe4qP4/xQwr4Ztd9tq9Z/9WfSrLbdlVLv0f
	 4x2cVWfitQHQAtyTboCI0UFufrny2HrPBrpdNxMuPQOLu0x8H9s/A4WC/rOiiVKqc0
	 NNk+Xbc8/LAFlM7E2RejwGNjbywpqFS/EJJL9jYwxt09egCJo6EOk71K1l0mYTR9mW
	 WLIl2kN5ZdSi7onG42goAN7UjqU2uOv2t4NtY4Lpcl1HHJLRrt/+yR2l3gfNcI6s8O
	 S8Wkip59g3Mfg==
Date: Thu, 10 Oct 2024 17:59:51 -0700
Subject: [PATCH 16/21] xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643224.4177836.5390615485276709534.stgit@frogsfrogsfrogs>
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

