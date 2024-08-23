Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D3E2901
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372439; cv=none; b=HeyHjGorxw49+OUeaqzBsuld7JsTGWmAB/T5H+VTDkLVqArQYTM57vdtYFyqc+D1jYy3JjwUOdOm0f0ObpWMq8gYSfifqr5+6QjHEE7P7LKj5nWLKdDKcZH2+R9NEyWVA5Y0pZH6xaNHfDt6WcmtENnXrbBM0pD9l4hB0Ztulps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372439; c=relaxed/simple;
	bh=lEEF5NOlpRmqvVg8r1MKXkx3Bfjq8kfFlDg2wBYe6OE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rsAa48cCo0lAzdKVUiPXq2UtglxOEKm4Mh9ehio7T7/8opC9xeJGV8Td8iDa1QCByu60HFoWtR6eVF6JCIt03ueonts3/WItEaglwIJZlntUZGxbCqNh833xCee1wG+pZx5pIA4Lr72rHzbbwmcwT0f01loIdBu+vkmx+hX7ou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOcHLoYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOcHLoYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B2DC32782;
	Fri, 23 Aug 2024 00:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372439;
	bh=lEEF5NOlpRmqvVg8r1MKXkx3Bfjq8kfFlDg2wBYe6OE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZOcHLoYLGPEJ2o4iZlfBC/5XCWKEVWZCcmNSzU0B4Y6U0Iq6t4HWbbvMVYxInXFhN
	 7NeirvhSgvCmLw66B58ESHJ2iXF63jQT8NWOQgZqnCcdFR/lxTEVkUpwbirtTAPCDm
	 Ntt5LG0y7+sbiFAOxyEJ4OWCuD+6CeAZNkpeRc4tjWJUupCZUGoHogCwo6N7iAlEMM
	 kAN5Ejm6wS2oljar/bZiVSnKEVq7o216peorg4J8uDBU5NzCDQbPfYYtiVCSGOG4AG
	 OcldaZxHucLiZUcCjkMgYPfVJBXaTG94V1HRFSrXdbVCTAD71nDm4tPbQhGoY2tEk+
	 CnVu2iQjmzfiw==
Date: Thu, 22 Aug 2024 17:20:39 -0700
Subject: [PATCH 23/24] xfs: refactor xfs_rtsummary_blockcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087646.59588.8776169412633182390.stgit@frogsfrogsfrogs>
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

Make xfs_rtsummary_blockcount take all the required information from
the mount structure and return the number of summary levels from it
as well.  This cleans up many of the callers and prepares for making the
rtsummary files per-rtgroup where they need to look at different value.

This means we recalculate some values in some callers, but as all these
calculations are outside the fast path and cheap that seems like a price
worth paying.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   13 +++++++++----
 fs/xfs/libxfs/xfs_rtbitmap.h |    3 +--
 fs/xfs/scrub/rtsummary.c     |    8 ++------
 fs/xfs/xfs_mount.h           |    2 +-
 fs/xfs/xfs_rtalloc.c         |   13 ++++---------
 5 files changed, 17 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ea89503213c62..7a848cacd561d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
+#include "xfs_sb.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -1166,16 +1167,20 @@ xfs_rtbitmap_blockcount(
 	return xfs_rtbitmap_blockcount_len(mp, mp->m_sb.sb_rextents);
 }
 
-/* Compute the number of rtsummary blocks needed to track the given rt space. */
+/*
+ * Compute the geometry of the rtsummary file needed to track the given rt
+ * space.
+ */
 xfs_filblks_t
 xfs_rtsummary_blockcount(
 	struct xfs_mount	*mp,
-	unsigned int		rsumlevels,
-	xfs_extlen_t		rbmblocks)
+	unsigned int		*rsumlevels)
 {
 	unsigned long long	rsumwords;
 
-	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+	*rsumlevels = xfs_compute_rextslog(mp->m_sb.sb_rextents) + 1;
+
+	rsumwords = xfs_rtbitmap_blockcount(mp) * (*rsumlevels);
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 58672863053a9..776cca9e41bf0 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -311,7 +311,7 @@ xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp);
 xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
-		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+		unsigned int *rsumlevels);
 
 int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
 		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
@@ -342,7 +342,6 @@ xfs_rtbitmap_blockcount_len(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	/* shut up gcc */
 	return 0;
 }
-# define xfs_rtsummary_blockcount(mp, l, b)		(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index e96aa24d89f62..3e2357f50b9d3 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -102,14 +102,10 @@ xchk_setup_rtsummary(
 	 */
 	xchk_rtgroup_lock(&sc->sr, XFS_RTGLOCK_BITMAP);
 	if (mp->m_sb.sb_rblocks) {
-		int		rextslog;
-
 		rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
-		rextslog = xfs_compute_rextslog(mp->m_sb.sb_rextents);
-		rts->rsumlevels = rextslog + 1;
 		rts->rbmblocks = xfs_rtbitmap_blockcount(mp);
-		rts->rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
-				rts->rbmblocks);
+		rts->rsumblocks =
+			xfs_rtsummary_blockcount(mp, &rts->rsumlevels);
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2518977150295..137fb5f88307b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -139,7 +139,7 @@ typedef struct xfs_mount {
 	uint			m_allocsize_blocks; /* min write size blocks */
 	int			m_logbufs;	/* number of log buffers */
 	int			m_logbsize;	/* size of each log buffer */
-	uint			m_rsumlevels;	/* rt summary levels */
+	unsigned int		m_rsumlevels;	/* rt summary levels */
 	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
 	uint32_t		m_rgblocks;	/* size of rtgroup in rtblocks */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index fc35cdf856194..28d8cea4f84e3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -751,9 +751,7 @@ xfs_growfs_rt_alloc_fake_mount(
 	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
 	nmp->m_sb.sb_rbmblocks = xfs_rtbitmap_blockcount(nmp);
 	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
-	nmp->m_rsumlevels = nmp->m_sb.sb_rextslog + 1;
-	nmp->m_rsumblocks = xfs_rtsummary_blockcount(nmp, nmp->m_rsumlevels,
-			nmp->m_sb.sb_rbmblocks);
+	nmp->m_rsumblocks = xfs_rtsummary_blockcount(nmp, &nmp->m_rsumlevels);
 
 	if (rblocks > 0)
 		nmp->m_features |= XFS_FEAT_REALTIME;
@@ -1138,21 +1136,18 @@ xfs_rtmount_init(
 	struct xfs_mount	*mp)	/* file system mount structure */
 {
 	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
-	struct xfs_sb		*sbp;	/* filesystem superblock copy in mount */
 	xfs_daddr_t		d;	/* address of last block of subvolume */
 	int			error;
 
-	sbp = &mp->m_sb;
-	if (sbp->sb_rblocks == 0)
+	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 	if (mp->m_rtdev_targp == NULL) {
 		xfs_warn(mp,
 	"Filesystem has a realtime volume, use rtdev=device option");
 		return -ENODEV;
 	}
-	mp->m_rsumlevels = sbp->sb_rextslog + 1;
-	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
-			mp->m_sb.sb_rbmblocks);
+
+	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, &mp->m_rsumlevels);
 
 	/*
 	 * Check that the realtime section is an ok size.

