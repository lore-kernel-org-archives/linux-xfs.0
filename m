Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B4C21B42B
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191789; cv=none; b=r/svki1rDsSNH2CAlJxfg4RTZb4q+mB0MR1PCm7NQLBFfT2hjfjFKJVdDut3a3417CWred+ccOUaghL0Yp1zHmV4EoH2IJhZAl+eF+xcVK3+2X7pia0rvFBkwGxLy3fsW0F9Xii3x2okOetcvU5GmUVP5cPFNrN6jfQUMYGkUPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191789; c=relaxed/simple;
	bh=iqn+HSDKPDnEm4BEBrm5XoXXu0NogVWTn3pP8RZCPnc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RpTdavoTMZcZrsQnZURVZ2aodsCMdj/sszn+Z5EnzNRNPc/ZOHOrEgqL7aKP4xDcVRWiA4Dpy9OUxAJvcpnByuLvJ5s3fezliQuYdpCdLAoNCy/QI6t7aa2Lc/3TA9wQTXH3hx6NLsK1LdLuxjyCwuopZEBet7ezXekwQRSZOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1POK0f5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1POK0f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7370FC4CEC3;
	Thu, 17 Oct 2024 19:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191788;
	bh=iqn+HSDKPDnEm4BEBrm5XoXXu0NogVWTn3pP8RZCPnc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y1POK0f5kQfsZSpyAAPG5VHh35RtZwyfOx3IYFkTjycyIKYO+e6DMG7N9YLyaH0z9
	 d3MrOz1t5caTLoK8f8L2sll/C2/H9aKzcG9gGKDNjrp7Zh+LlN8Z5APz0XkmXyGB5I
	 eJA3YUP3ViCpiXBxBjt6BFOCFqN1AbVgWwDdPc6ky9jb3bZsKzk8obKFudFIYD8fvl
	 +umui0CoBONUePwMQSLFYoDJ9pzuDRPynmAkgy35W6ty+AiRmKFf9cOC3Z5OxGDd8e
	 wyPDVmkD7/YQYBkhEHVPxuZdBmylp0R3nPoW6i200/SkmQBifZ125OhE/nfVJE7XXl
	 pXyLj1FUmzI2Q==
Date: Thu, 17 Oct 2024 12:03:08 -0700
Subject: [PATCH 19/21] xfs: refactor xfs_rtbitmap_blockcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070725.3452315.14904524459307607582.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Rename the existing xfs_rtbitmap_blockcount to
xfs_rtbitmap_blockcount_len and add a new xfs_rtbitmap_blockcount wrapper
around it that takes the number of extents from the mount structure.

This will simplify the move to per-rtgroup bitmaps as those will need to
pass in the number of extents per rtgroup instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c   |   12 +++++++++++-
 fs/xfs/libxfs/xfs_rtbitmap.h   |    7 ++++---
 fs/xfs/libxfs/xfs_trans_resv.c |    2 +-
 fs/xfs/scrub/rtbitmap.c        |    3 +--
 fs/xfs/scrub/rtsummary.c       |    7 ++-----
 fs/xfs/xfs_rtalloc.c           |    3 +--
 6 files changed, 20 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 6c3354c8efdafa..e9b80ef166c0e8 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1149,13 +1149,23 @@ xfs_rtalloc_extent_is_free(
  * extents.
  */
 xfs_filblks_t
-xfs_rtbitmap_blockcount(
+xfs_rtbitmap_blockcount_len(
 	struct xfs_mount	*mp,
 	xfs_rtbxlen_t		rtextents)
 {
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
+/*
+ * Compute the number of rtbitmap blocks used for a given file system.
+ */
+xfs_filblks_t
+xfs_rtbitmap_blockcount(
+	struct xfs_mount	*mp)
+{
+	return xfs_rtbitmap_blockcount_len(mp, mp->m_sb.sb_rextents);
+}
+
 /* Compute the number of rtsummary blocks needed to track the given rt space. */
 xfs_filblks_t
 xfs_rtsummary_blockcount(
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e4994a3e461d33..58672863053a94 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -307,8 +307,9 @@ int xfs_rtfree_extent(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 int xfs_rtfree_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		xfs_fsblock_t rtbno, xfs_filblks_t rtlen);
 
-xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
-		rtextents);
+xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp);
+xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
+		xfs_rtbxlen_t rtextents);
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 
@@ -336,7 +337,7 @@ static inline int xfs_rtfree_blocks(struct xfs_trans *tp,
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 static inline xfs_filblks_t
-xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
+xfs_rtbitmap_blockcount_len(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 {
 	/* shut up gcc */
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 1a7f95bcf06955..bab402340b5da8 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -224,7 +224,7 @@ xfs_rtalloc_block_count(
 	xfs_rtxlen_t		rtxlen;
 
 	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
-	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, rtxlen);
+	rtbmp_blocks = xfs_rtbitmap_blockcount_len(mp, rtxlen);
 	return (rtbmp_blocks + 1) * num_ops;
 }
 
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 5b42e01a07ac8b..ababbf4068d600 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -67,8 +67,7 @@ xchk_setup_rtbitmap(
 	if (mp->m_sb.sb_rblocks) {
 		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
 		rtb->rextslog = xfs_compute_rextslog(rtb->rextents);
-		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp,
-				mp->m_sb.sb_rextents);
+		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp);
 	}
 
 	return 0;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 7c2b6add44e8c9..0a6b7902a04cbb 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -107,8 +107,7 @@ xchk_setup_rtsummary(
 		rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
 		rextslog = xfs_compute_rextslog(mp->m_sb.sb_rextents);
 		rts->rsumlevels = rextslog + 1;
-		rts->rbmblocks = xfs_rtbitmap_blockcount(mp,
-				mp->m_sb.sb_rextents);
+		rts->rbmblocks = xfs_rtbitmap_blockcount(mp);
 		rts->rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
 				rts->rbmblocks);
 	}
@@ -215,11 +214,9 @@ xchk_rtsum_compute(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
-	unsigned long long	rtbmp_blocks;
 
 	/* If the bitmap size doesn't match the computed size, bail. */
-	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, mp->m_sb.sb_rextents);
-	if (XFS_FSB_TO_B(mp, rtbmp_blocks) !=
+	if (XFS_FSB_TO_B(mp, xfs_rtbitmap_blockcount(mp)) !=
 	    rtg->rtg_inodes[XFS_RTGI_BITMAP]->i_disk_size)
 		return -EFSCORRUPTED;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 785ff3e49295b5..858013d6f5187d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -749,8 +749,7 @@ xfs_growfs_rt_alloc_fake_mount(
 	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
 	nmp->m_sb.sb_rblocks = rblocks;
 	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
-	nmp->m_sb.sb_rbmblocks = xfs_rtbitmap_blockcount(nmp,
-			nmp->m_sb.sb_rextents);
+	nmp->m_sb.sb_rbmblocks = xfs_rtbitmap_blockcount(nmp);
 	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
 	nmp->m_rsumlevels = nmp->m_sb.sb_rextslog + 1;
 	nmp->m_rsumblocks = xfs_rtsummary_blockcount(nmp, nmp->m_rsumlevels,

