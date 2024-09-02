Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FCF3D7A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301654; cv=none; b=uSRkU41fr2MVOpFCN2JoPHCjnGhHp7FMlMMxVKUZ4HEbhyGlUEXvcGmVPOjdB+HjaYT7mPTvaKdkHWtuDXDk8gJ98ZgMXGU+6aVI3twsXJnGNLlNX7KEmru1ySqyntaSGmYJ8n0atjdppt9pqZBW+8e9ofaomac4U+Jwsjc2sM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301654; c=relaxed/simple;
	bh=tjlWmGjkR52OhhgMTuBYmKtpp/NyJTXxAsU3PEsSLR4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VPXvBFELZqYuwJoSSPO2jJBELgSqoKgs6Q96Hgp+ElM4u3nBmCKq3ZRwJdJne55h/P2VGcygLSZyWteC4w9yAzbMCNdXYlY7tiCI4M8VX0ZvR92qnr5QZf0p3Yh5RaBbUKlq9lhV8JNMFmuhgPR2ozoUqdNCVg0vV2fZdkyk7Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B4ol3Krg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B4ol3Krg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D25C4CEC2;
	Mon,  2 Sep 2024 18:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301654;
	bh=tjlWmGjkR52OhhgMTuBYmKtpp/NyJTXxAsU3PEsSLR4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B4ol3Krgnpr/dbUu08hjpe0FwbqrXhCXdDsGKUEaOqy09IMhyp9p6AFTg3b7rvcjZ
	 ynoQ84OjUcufJvEg5wtLcFuMt58/v96e6l/wUGz4NuF0vcDsZFn5x4pQrrtw/k5dgo
	 9zBP0Uir/8xe5M5ImT4SrUxYZlAJiBD0jkyJn77geIf9TtJDidjHbGG3f/N+6JQU94
	 2ePy6aSqfRyAiXnzG02CdqwaXbOUyfJ89SIvZfpSD+Jl8080IB9lA+7F1WH2nkByFC
	 GLs7kTU29AZIpE6P9VeSujog5sWGh5z7pXx+wf71qRurqlfTT5oPzT3VVGN0ZvKOD9
	 qzuP0Mcqlx7vQ==
Date: Mon, 02 Sep 2024 11:27:33 -0700
Subject: [PATCH 02/10] xfs: ensure rtx mask/shift are correct after growfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106292.3325667.13014911083029207640.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
References: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
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

When growfs sets an extent size, it doesn't updated the m_rtxblklog and
m_rtxblkmask values, which could lead to incorrect usage of them if they
were set before and can't be used for the new extent size.

Add a xfs_mount_sb_set_rextsize helper that updates the two fields, and
also use it when calculating the new RT geometry instead of disabling
the optimization there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |   12 ++++++++++--
 fs/xfs/libxfs/xfs_sb.h |    2 ++
 fs/xfs/xfs_rtalloc.c   |    5 +++--
 3 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f9c3045f71e0..a6fa9aedb28b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -965,6 +965,15 @@ const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
 	.verify_write = xfs_sb_write_verify,
 };
 
+void
+xfs_mount_sb_set_rextsize(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
+	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+}
+
 /*
  * xfs_mount_common
  *
@@ -989,8 +998,7 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
-	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
-	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+	xfs_mount_sb_set_rextsize(mp, sbp);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 796f02191dfd..885c83755991 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -17,6 +17,8 @@ extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
 extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
+void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
+			struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a9f08d96f1fe..4bbb50d5a4b7 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -719,8 +719,8 @@ xfs_growfs_rt_bmblock(
 	/*
 	 * Calculate new sb and mount fields for this round.
 	 */
-	nmp->m_rtxblklog = -1; /* don't use shift or masking */
 	nmp->m_sb.sb_rextsize = rextsize;
+	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
 	nmp->m_sb.sb_rbmblocks = bmbno + 1;
 	nmp->m_sb.sb_rblocks = min(nrblocks, nrblocks_step);
 	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
@@ -807,10 +807,11 @@ xfs_growfs_rt_bmblock(
 	xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_FREXTENTS, freed_rtx);
 
 	/*
-	 * Update mp values into the real mp structure.
+	 * Update the calculated values in the real mount structure.
 	 */
 	mp->m_rsumlevels = nmp->m_rsumlevels;
 	mp->m_rsumsize = nmp->m_rsumsize;
+	xfs_mount_sb_set_rextsize(mp, &mp->m_sb);
 
 	/*
 	 * Recompute the growfsrt reservation from the new rsumsize.

