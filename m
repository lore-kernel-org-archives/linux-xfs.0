Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDB221BAFA
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191799; cv=none; b=Ro139GXpqcndRIyBQYXtkirgKBb1wGe4MDaqohFgJTmZbQDRhwpAHYSLTS0h12Gc3JUH2NUYyboBwrpg/X1iURVLCcA4sGH1xJWUueZux6c5GqOri4hLBG2DXdm1I2k+uqVj+nxy3e9If/ozSGE73skcl0yMEW6aM/kgIYTgi/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191799; c=relaxed/simple;
	bh=yPcF5JhnZTt3tbUB1Yn8lYuT5Mc2sdDv/1DImxcR7+o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mk0MifEDJMg9DOvbNM1YwKdbBdAIOgJbaFoJZhb3mDswRS9zn6Nx+w2qE4NVChxfHmMIFCXJL35YkbWtYo6NZkEBr0kzwBB8h/Zv0dMOa0Ql1dzMlUx8PzDE/UyjlCIEyu5WwrJNf39ndbDcmvokWmxW5SFc1s2O1ps239pbwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRSrCz3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRSrCz3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0945FC4CEC3;
	Thu, 17 Oct 2024 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191799;
	bh=yPcF5JhnZTt3tbUB1Yn8lYuT5Mc2sdDv/1DImxcR7+o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KRSrCz3tNmLHqZHl6xE9rAz2EsLkORckC3g0YohWSm5ry8w8aSJ5vXNqNDdXXrcye
	 6JmYzGy1Qsa3aDu27R5ujbrz8Pmv3TkJGIQgoWbci4pPVtUQlU0fc04ZWHH1J2DaQ7
	 zGPcqJ/74gSlY2nzdC55NYJMUg9hs0iI+e1l07hQ/G3pAHfalWMHnNqFmttlB6uy9a
	 cxFlkJ0JxRe+0Um7d9I18dozDtq5WKdg+j+lZFefXJkXKExc3gKZP1/CBdjicQS548
	 xqPMEZuKc3Otxba95u/jRQdsUtOgniEvg/mwSl7++PaHMBoLI9CM6bGvj9Nzd/CK33
	 202BE2la2bxzg==
Date: Thu, 17 Oct 2024 12:03:18 -0700
Subject: [PATCH 20/21] xfs: refactor xfs_rtsummary_blockcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070742.3452315.11671042138976656624.stgit@frogsfrogsfrogs>
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

Make xfs_rtsummary_blockcount take all the required information from
the mount structure and return the number of summary levels from it
as well.  This cleans up many of the callers and prepares for making the
rtsummary files per-rtgroup where they need to look at different value.

This means we recalculate some values in some callers, but as all these
calculations are outside the fast path and cheap, which seems like a
price worth paying.

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
index e9b80ef166c0e8..54079edfe10feb 100644
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
index 58672863053a94..776cca9e41bf05 100644
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
index 0a6b7902a04cbb..4125883c6da080 100644
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
index 400da82443bf1a..2795dd83c23b3f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -173,7 +173,7 @@ typedef struct xfs_mount {
 	uint			m_allocsize_blocks; /* min write size blocks */
 	int			m_logbufs;	/* number of log buffers */
 	int			m_logbsize;	/* size of each log buffer */
-	uint			m_rsumlevels;	/* rt summary levels */
+	unsigned int		m_rsumlevels;	/* rt summary levels */
 	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
 	uint32_t		m_rgblocks;	/* size of rtgroup in rtblocks */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 858013d6f5187d..1fe12d22bc4c2b 100644
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

