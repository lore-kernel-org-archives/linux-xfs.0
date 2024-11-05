Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A691EC01B
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845686; cv=none; b=U6MljRHZeOqaG5JNkgoqdsBcQuI1irvgUQ62sHXUSVp9Ls+xe25NbTvgq7i29sErWwX0wRXWVYiU9CtKrPgFmwRc/RRtbquVMUkDHjv4gpfaLhyG1bch4a1j9DT8QEsgsk3owH0YqB3PLTn5RU1tnl334XxulYCmPMHtAePolAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845686; c=relaxed/simple;
	bh=qMml6oVWm2m8nnJ1TQUuCVyF1vM2qQhAAKpL39Y17aA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XP/1moKc/FSNLPVCUBpcls51CenyCy1dXi88YSwexNjpTqpfo/itwvAJG7gnhpRfboiXXyCwJepaGAVFoWbG8pd/Jhl43Fvnzdr3XNyxmhd5YSfO0sOlq0k1qi7X0bIUKLx1TLzF/AQwEYznMNjfd+XW73Rz55+OKy5TjgS8jaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UhGCKY5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhGCKY5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890B6C4CECF;
	Tue,  5 Nov 2024 22:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845685;
	bh=qMml6oVWm2m8nnJ1TQUuCVyF1vM2qQhAAKpL39Y17aA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UhGCKY5MIePbtV66bHTUrvtGlj8VaBpxnKh6P6WJHL+wH9VhnD2HJmQCkl7zot6CI
	 kbAfecp5oDGwzS3dpltCR9y3c7ZA0pNeTZkKBmjyZa33P5vIrmYWQbqRBFXvGWkSGa
	 Yj5BSWhM0eZeDU+JGTH4vQJvsswk44y6DsbfcY8NvgruCrgH2sTGyeHLTlbeVwYDTg
	 scCuOg7A2Q5Qw/8qA+qGFJmFB9afZV2CWdJFQ4di9xcx+rE4XKXMOM+57/Vj67flzx
	 YwUc6845A1zgj5Qcq6uLrha037hHrka78tMfDRTHbpeK0EJRqI9+8pW187q314QxIo
	 BYPg21HHpPHfg==
Date: Tue, 05 Nov 2024 14:28:05 -0800
Subject: [PATCH 16/21] xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397213.1871025.3550938466031250511.stgit@frogsfrogsfrogs>
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
index 7f3b5e24458bf3..e557eee5210419 100644
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

