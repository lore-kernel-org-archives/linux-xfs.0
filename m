Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B469ABE46;
	Tue, 26 Nov 2024 01:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584377; cv=none; b=cGLuBpQ/K8bikM9Elp93pbDWA8r6rLtROtAVuEzlpAjEPRGSzvrCMniwo0wsyk5tEzG9zMYjlSNW/0nygOpEsemKz2kz/6Gr/5N/Wy8Hu2ZZhyML97OaP0iAaDtk5+9exhtqk7Jty7q4AyjjClQOxw94qaPXpw+4tzeN3qCDOOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584377; c=relaxed/simple;
	bh=HOrKD3PoWR8/f43f707a6hbU3giSuSbxx7z1a3QieSM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iQ6jkTHIycW+7mZly0CyTNjR00bAY23vy8WdupdiiIKv1PyMgK769R98Sikk02ExSNjPDGnSBZ/Esqor0piH6lh9rGavjc322Z1pmmDBI6NlZoFSqaca+QYJWdHP0WPYSGYvs2EjTuu4GRoGBdqYyCyOA5WdbmrY8wRwlCiyt3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QA5wWp0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QA5wWp0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE58C4CECE;
	Tue, 26 Nov 2024 01:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584377;
	bh=HOrKD3PoWR8/f43f707a6hbU3giSuSbxx7z1a3QieSM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QA5wWp0U78EeutZX209iT7ri9PX3Fn6T84kQTQ6inz4dOlNcYJzpmv6MwhgZjuCLS
	 mNdbd72/+1DVwYDTeAIPYq4BcmSvV5O9Q1BdypDEv5WU3KQWLULDgeBwNUmkkfR7VI
	 Jw5odD+p3niWruvp2hy3boItWt+Yy7wdjr5seRxxcaIDSJXAOZxr+340WTtkWuFmKf
	 tiRtqI5u/XAiZ/hExdZkxeShsTdxb55czLbtyfq2kRpdkyMymoIimVVeljpV2VzZdj
	 an1/E2fNLdLrDdH31nGaay38LxrCd1uKkNltrlvyjnVtPZ4EnBL+D4VpnF15UUntGW
	 0SesBL4uLu7Sw==
Date: Mon, 25 Nov 2024 17:26:16 -0800
Subject: [PATCH 06/21] xfs: separate healthy clearing mask during repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173258397906.4032920.11656317799554030362.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In commit d9041681dd2f53 we introduced some XFS_SICK_*ZAPPED flags so
that the inode record repair code could clean up a damaged inode record
enough to iget the inode but still be able to remember that the higher
level repair code needs to be called.  As part of that, we introduced a
xchk_mark_healthy_if_clean helper that is supposed to cause the ZAPPED
state to be removed if that higher level metadata actually checks out.
This was done by setting additional bits in sick_mask hoping that
xchk_update_health will clear all those bits after a healthy scrub.

Unfortunately, that's not quite what sick_mask means -- bits in that
mask are indeed cleared if the metadata is healthy, but they're set if
the metadata is NOT healthy.  fsck is only intended to set the ZAPPED
bits explicitly.

If something else sets the CORRUPT/XCORRUPT state after the
xchk_mark_healthy_if_clean call, we end up marking the metadata zapped.
This can happen if the following sequence happens:

1. Scrub runs, discovers that the metadata is fine but could be
   optimized and calls xchk_mark_healthy_if_clean on a ZAPPED flag.
   That causes the ZAPPED flag to be set in sick_mask because the
   metadata is not CORRUPT or XCORRUPT.

2. Repair runs to optimize the metadata.

3. Some other metadata used for cross-referencing in (1) becomes
   corrupt.

4. Post-repair scrub runs, but this time it sets CORRUPT or XCORRUPT due
   to the events in (3).

5. Now the xchk_health_update sets the ZAPPED flag on the metadata we
   just repaired.  This is not the correct state.

Fix this by moving the "if healthy" mask to a separate field, and only
ever using it to clear the sick state.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: d9041681dd2f53 ("xfs: set inode sick state flags when we zap either ondisk fork")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/health.c |   57 ++++++++++++++++++++++++++++---------------------
 fs/xfs/scrub/scrub.h  |    6 +++++
 2 files changed, 39 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index ce86bdad37fa42..ccc6ca5934ca6a 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -71,7 +71,8 @@
 /* Map our scrub type to a sick mask and a set of health update functions. */
 
 enum xchk_health_group {
-	XHG_FS = 1,
+	XHG_NONE = 1,
+	XHG_FS,
 	XHG_AG,
 	XHG_INO,
 	XHG_RTGROUP,
@@ -83,6 +84,7 @@ struct xchk_health_map {
 };
 
 static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_PROBE]		= { XHG_NONE,  0 },
 	[XFS_SCRUB_TYPE_SB]		= { XHG_AG,  XFS_SICK_AG_SB },
 	[XFS_SCRUB_TYPE_AGF]		= { XHG_AG,  XFS_SICK_AG_AGF },
 	[XFS_SCRUB_TYPE_AGFL]		= { XHG_AG,  XFS_SICK_AG_AGFL },
@@ -133,7 +135,7 @@ xchk_mark_healthy_if_clean(
 {
 	if (!(sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
 				  XFS_SCRUB_OFLAG_XCORRUPT)))
-		sc->sick_mask |= mask;
+		sc->healthy_mask |= mask;
 }
 
 /*
@@ -189,6 +191,7 @@ xchk_update_health(
 {
 	struct xfs_perag	*pag;
 	struct xfs_rtgroup	*rtg;
+	unsigned int		mask = sc->sick_mask;
 	bool			bad;
 
 	/*
@@ -203,50 +206,56 @@ xchk_update_health(
 		return;
 	}
 
-	if (!sc->sick_mask)
-		return;
-
 	bad = (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
 				   XFS_SCRUB_OFLAG_XCORRUPT));
+	if (!bad)
+		mask |= sc->healthy_mask;
 	switch (type_to_health_flag[sc->sm->sm_type].group) {
+	case XHG_NONE:
+		break;
 	case XHG_AG:
+		if (!mask)
+			return;
 		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
 		if (bad)
-			xfs_group_mark_corrupt(pag_group(pag), sc->sick_mask);
+			xfs_group_mark_corrupt(pag_group(pag), mask);
 		else
-			xfs_group_mark_healthy(pag_group(pag), sc->sick_mask);
+			xfs_group_mark_healthy(pag_group(pag), mask);
 		xfs_perag_put(pag);
 		break;
 	case XHG_INO:
 		if (!sc->ip)
 			return;
-		if (bad) {
-			unsigned int	mask = sc->sick_mask;
-
-			/*
-			 * If we're coming in for repairs then we don't want
-			 * sickness flags to propagate to the incore health
-			 * status if the inode gets inactivated before we can
-			 * fix it.
-			 */
-			if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
-				mask |= XFS_SICK_INO_FORGET;
+		/*
+		 * If we're coming in for repairs then we don't want sickness
+		 * flags to propagate to the incore health status if the inode
+		 * gets inactivated before we can fix it.
+		 */
+		if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+			mask |= XFS_SICK_INO_FORGET;
+		if (!mask)
+			return;
+		if (bad)
 			xfs_inode_mark_corrupt(sc->ip, mask);
-		} else
-			xfs_inode_mark_healthy(sc->ip, sc->sick_mask);
+		else
+			xfs_inode_mark_healthy(sc->ip, mask);
 		break;
 	case XHG_FS:
+		if (!mask)
+			return;
 		if (bad)
-			xfs_fs_mark_corrupt(sc->mp, sc->sick_mask);
+			xfs_fs_mark_corrupt(sc->mp, mask);
 		else
-			xfs_fs_mark_healthy(sc->mp, sc->sick_mask);
+			xfs_fs_mark_healthy(sc->mp, mask);
 		break;
 	case XHG_RTGROUP:
+		if (!mask)
+			return;
 		rtg = xfs_rtgroup_get(sc->mp, sc->sm->sm_agno);
 		if (bad)
-			xfs_group_mark_corrupt(rtg_group(rtg), sc->sick_mask);
+			xfs_group_mark_corrupt(rtg_group(rtg), mask);
 		else
-			xfs_group_mark_healthy(rtg_group(rtg), sc->sick_mask);
+			xfs_group_mark_healthy(rtg_group(rtg), mask);
 		xfs_rtgroup_put(rtg);
 		break;
 	default:
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index a7fda3e2b01377..5dbbe93cb49bfa 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -184,6 +184,12 @@ struct xfs_scrub {
 	 */
 	unsigned int			sick_mask;
 
+	/*
+	 * Clear these XFS_SICK_* flags but only if the scan is ok.  Useful for
+	 * removing ZAPPED flags after a repair.
+	 */
+	unsigned int			healthy_mask;
+
 	/* next time we want to cond_resched() */
 	struct xchk_relax		relax;
 

