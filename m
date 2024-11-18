Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429041E7647;
	Mon, 18 Nov 2024 23:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971165; cv=none; b=tZ8inNISTbuFuIie44Q/ovup0PTk+gqhEVAKeSYQgOYXkNIua3swiPSgEez+7VWuC6oIvKwdqvWm8Mq+lbAIBMzr30hyU8qwMfgsuFyg5nrneUOK25UQhP+0JXDIOcw//qbiHgAQMon4jCKO0gZluvPVWSWS5BIzmdPMiAWV//Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971165; c=relaxed/simple;
	bh=XAwLHOUxahG/mP90Mk6jjoZYzomSv9T1f8vvMFpyXlc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dG4V6ErHAIafeq9crtPRn/5pmuCtPCzfSWEfdh7r2m0+KEDw3vQqM7j6+Xaciw2tznkT3AozRv2JF4qepFusQ0CKrugmS8T96OpO+J+0iMKhnvHLfdJ2+hpsnBKFFJs6tosLeq33c85dxcGz/MSgnlxOGkKnY1YvtMrBhNFIdpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWMelyy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWMelyy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21721C4CECC;
	Mon, 18 Nov 2024 23:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971165;
	bh=XAwLHOUxahG/mP90Mk6jjoZYzomSv9T1f8vvMFpyXlc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lWMelyy4NBNjGDdZeb72v46iPFmGnXgnZUaMvOQWbowkA49SmwsUYJZ0xvUKCuz2W
	 JPDMdT9BJu+facIHFx74l0zMRHvonNNEMbvs1roKQeURMNmIiLbdM2yGrc72V5zyj7
	 +ZG6Yk+venE9W3praR9YwQKh6ZZpuZuFPY6u0n5ki783F+5bw2UO8M4suigjyLr9Y9
	 fNc7ub8/maK8MVaMlmUBzparIDIetwQPGwmgedX8ZjEIUBtwlz+tXkhnlut7m7xZkY
	 FFIxkCxvbD1wzzR505d4cldBWNUf8CVXSWW1gC50bHgqESySWI5p0rLzh0tHk0cP3t
	 AQ9kHs5T0lj8A==
Date: Mon, 18 Nov 2024 15:06:04 -0800
Subject: [PATCH 06/10] xfs: separate healthy clearing mask during repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173197084515.911325.13396294816751205852.stgit@frogsfrogsfrogs>
In-Reply-To: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
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
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
 

