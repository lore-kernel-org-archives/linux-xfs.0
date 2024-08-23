Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AFD2901
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372424; cv=none; b=P0Ssds0cUs9spVhvRMj6rirkodtY9Uamtqr79rNyV8PMPgYilsSNZJoanqhM7NV6CqQtkeZcylv9s3fRCFql7gV2IrnP8FrURUn0KSsu755mNWwP2SzRPbB5OzsSjz7KwXiJHu2OrqHlYQGTpAhuOojFslgsnic6V6Ci8VQGEac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372424; c=relaxed/simple;
	bh=ClvXILjh5I7WtbZPNa54WiIkW1zRpqUa47/PhjV85ms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDFb6zBW7XhE9RQ9AkdGAUoPs411BIMe/5sIUe0Ru7j/OnLSMlpXyDhxLQJ9CqX+O/Cal3IN5E/gYB40sXZ6BeH0TcuAwhgNjugEnMBc2uGBnNsf0gbXUrEGf+CSLFgwcHsneKbwwcXCDMa+rLs25UDKRLczrUu+VSooipALWWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEFQoL3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEFQoL3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D362BC32782;
	Fri, 23 Aug 2024 00:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372423;
	bh=ClvXILjh5I7WtbZPNa54WiIkW1zRpqUa47/PhjV85ms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LEFQoL3x+gg+sPNkVBCvbJfW+lksFgiKMnIHLW2Xbzl9+5gedEUDSJ5WIOv5WEZxz
	 nL1abkTyFhBqBFx6O4d+Cfo+2ZYsIYjFxIim3HJfRpmbAKFAdMhw/ed9a7keiOo8AK
	 3V3sX/TGpcsAXTpfx8Rca21kudwWUR+PQRpNd0KJau/JUuZhaSEceCd2EH1HtJaz6b
	 bGIBZJGyKaXchJ7+xcb4/XW0WODkN+pHOl+QwXFscVF8ecLxJixZoAuW8auHfxhsjo
	 wEHwWC9OvRyDVC4RkRL9D0cUgCUtheJ8OwW2rVcJTwmfwm70YkUgW83dNN/Akaskb1
	 0c6K3SNq1PHaw==
Date: Thu, 22 Aug 2024 17:20:23 -0700
Subject: [PATCH 22/24] xfs: refactor xfs_rtbitmap_blockcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087628.59588.16837067030703641370.stgit@frogsfrogsfrogs>
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
index 41de2f071934f..ea89503213c62 100644
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
index e4994a3e461d3..58672863053a9 100644
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
index 2e6d7bb3b5a2f..5050fbcc37b75 100644
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
index 4a3e9d0302b51..3f090c3e3d11e 100644
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
index a756fb2c4abf8..e96aa24d89f62 100644
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
index 78a3879ad6193..fc35cdf856194 100644
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

