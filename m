Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D187ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWA8kWNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B75DC433C7;
	Mon,  1 Jan 2024 00:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068488;
	bh=SyG8m0B2MleUKieVDu7LL4hWatUsGMEHKmFtuloM4v0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UWA8kWNk71FRCuEUpZaVdZDN3bjZr+XotirqBdOSntqo/HyTNeYaOCvWG9Q1YtiQI
	 hlZCr/650SRAKPmLXa2wHYpQQL61h4zluWQnjla/AVFHVKj+mMSpMKSRbsFwSJXcz6
	 GhkjGXZNMhPAYY4O5SWxWcyGB3/RSDgCLjNPztCb5ftHkzBfhtoYgTURIH5IsFGvyg
	 cSOQHJ5cqp34I1qwMASP6/dXi4iVpVzC0Xunb9LqBil43mSExpt3PYcetvhEcCzpLa
	 Ugl0MNF4r9qHTKNcoJlgagjgtjqeJ/kvbWv5tlyWxHFfsM+MwXb8aLUh231LvEajLA
	 42uR11g47AtNg==
Date: Sun, 31 Dec 2023 16:21:27 +9900
Subject: [PATCH 42/47] xfs_repair: check for global free space concerns with
 default btree slack levels
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015873.1815505.13193987272438467777.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

It's possible that before repair was started, the filesystem might have
been nearly full, and its metadata btree blocks could all have been
nearly full.  If we then rebuild the btrees with blocks that are only
75% full, that expansion might be enough to run out of free space.  The
solution to this is to pack the new blocks completely full if we fear
running out of space.

Previously, we only had to check and decide that on a per-AG basis.
However, now that XFS can have filesystems with metadata btrees rooted
in inodes, we have a global free space concern because there might be
enough space in each AG to regenerate the AG btrees at 75%, but that
might not leave enough space to regenerate the inode btrees, even if we
fill those blocks to 100%.

Hence we need to precompute the worst case space usage for all btrees in
the filesystem and compare /that/ against the global free space to
decide if we're going to pack the btrees maximally to conserve space.
That decision can override the per-AG determination.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/globals.c |    6 +++
 repair/globals.h |    2 +
 repair/phase5.c  |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 repair/phase6.c  |   16 +++++--
 4 files changed, 131 insertions(+), 9 deletions(-)


diff --git a/repair/globals.c b/repair/globals.c
index b121d6e2d6d..92ebe5fab8a 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -133,3 +133,9 @@ int		thread_count;
 
 /* If nonzero, simulate failure after this phase. */
 int		fail_after_phase;
+
+/*
+ * Do we think we're going to be so low on disk space that we need to pack
+ * all rebuilt btree blocks completely full to avoid running out of space?
+ */
+bool		need_packed_btrees;
diff --git a/repair/globals.h b/repair/globals.h
index f5dcc11f410..2e11f35a0e4 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -180,4 +180,6 @@ extern int		fail_after_phase;
 
 extern struct libxfs_init x;
 
+extern bool		need_packed_btrees;
+
 #endif /* _XFS_REPAIR_GLOBAL_H */
diff --git a/repair/phase5.c b/repair/phase5.c
index 74594d53a87..5e1dff0aadd 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -479,11 +479,14 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 
 	/*
 	 * Estimate the number of free blocks in this AG after rebuilding
-	 * all btrees.
+	 * all btrees, unless we already decided that we need to pack all
+	 * btree blocks maximally.
 	 */
-	total_btblocks = estimate_agbtree_blocks(pag, num_extents);
-	if (num_freeblocks > total_btblocks)
-		est_agfreeblocks = num_freeblocks - total_btblocks;
+	if (!need_packed_btrees) {
+		total_btblocks = estimate_agbtree_blocks(pag, num_extents);
+		if (num_freeblocks > total_btblocks)
+			est_agfreeblocks = num_freeblocks - total_btblocks;
+	}
 
 	init_ino_cursors(&sc, pag, est_agfreeblocks, &sb_icount_ag[agno],
 			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
@@ -631,6 +634,109 @@ check_rtmetadata(
 	check_rtsummary(mp);
 }
 
+/*
+ * Estimate the amount of free space used by the perag metadata without
+ * building the incore tree.  This is only necessary if realtime btrees are
+ * enabled.
+ */
+static xfs_extlen_t
+estimate_agbtree_blocks_early(
+	struct xfs_perag	*pag,
+	unsigned int		*num_freeblocks)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	xfs_agblock_t		agbno;
+	xfs_agblock_t		ag_end;
+	xfs_extlen_t		extent_len;
+	xfs_extlen_t		blen;
+	unsigned int		num_extents = 0;
+	int			bstate;
+	bool			in_extent = false;
+
+	/* Find the number of free space extents. */
+	ag_end = libxfs_ag_block_count(mp, pag->pag_agno);
+	for (agbno = 0; agbno < ag_end; agbno += blen) {
+		bstate = get_bmap_ext(pag->pag_agno, agbno, ag_end, &blen);
+		if (bstate < XR_E_INUSE)  {
+			if (!in_extent) {
+				/*
+				 * found the start of a free extent
+				 */
+				in_extent = true;
+				num_extents++;
+				extent_len = blen;
+			} else {
+				extent_len += blen;
+			}
+		} else {
+			if (in_extent)  {
+				/*
+				 * free extent ends here
+				 */
+				in_extent = false;
+				*num_freeblocks += extent_len;
+			}
+		}
+	}
+	if (in_extent)
+		*num_freeblocks += extent_len;
+
+	return estimate_agbtree_blocks(pag, num_extents);
+}
+
+/*
+ * Decide if we need to pack every new btree block completely full to conserve
+ * disk space.  Normally we rebuild btree blocks to be 75% full, but we don't
+ * want to start rebuilding AG btrees that way only to discover that there
+ * isn't enough space left in the data volume to rebuild inode-based btrees.
+ */
+static bool
+are_packed_btrees_needed(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
+	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
+	unsigned long long	metadata_blocks = 0;
+	unsigned long long	fdblocks = 0;
+
+	/*
+	 * If we don't have inode-based metadata, we can let the AG btrees
+	 * pack as needed; there are no global space concerns here.
+	 */
+	if (!xfs_has_rtrmapbt(mp))
+		return false;
+
+	for_each_perag(mp, agno, pag) {
+		unsigned int	ag_fdblocks = 0;
+
+		metadata_blocks += estimate_agbtree_blocks_early(pag,
+								 &ag_fdblocks);
+		fdblocks += ag_fdblocks;
+	}
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+	}
+
+	/*
+	 * If we think we'll have more metadata blocks than free space, then
+	 * pack the btree blocks.
+	 */
+	if (metadata_blocks > fdblocks)
+		return true;
+
+	/*
+	 * If the amount of free space after building btrees is less than 9%
+	 * of the data volume, pack the btree blocks.
+	 */
+	fdblocks -= metadata_blocks;
+	if (fdblocks < ((mp->m_sb.sb_dblocks * 3) >> 5))
+		return true;
+	return false;
+}
+
 void
 phase5(xfs_mount_t *mp)
 {
@@ -682,6 +788,8 @@ phase5(xfs_mount_t *mp)
 	if (error)
 		do_error(_("cannot alloc lost block bitmap\n"));
 
+	need_packed_btrees = are_packed_btrees_needed(mp);
+
 	for_each_perag(mp, agno, pag)
 		phase5_func(mp, pag, lost_blocks);
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 4c387557c31..ab5c22ffbb0 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3979,12 +3979,18 @@ reset_rt_metadata_inodes(
 	xfs_filblks_t		est_fdblocks = 0;
 	xfs_rgnumber_t		rgno;
 
-	/* Estimate how much free space will be left after building btrees */
-	for_each_rtgroup(mp, rgno, rtg) {
-		metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+	/*
+	 * Estimate how much free space will be left after building btrees
+	 * unless we already decided that we needed to pack all new blocks
+	 * maximally.
+	 */
+	if (!need_packed_btrees) {
+		for_each_rtgroup(mp, rgno, rtg) {
+			metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+		}
+		if (mp->m_sb.sb_fdblocks > metadata_blocks)
+			est_fdblocks = mp->m_sb.sb_fdblocks - metadata_blocks;
 	}
-	if (mp->m_sb.sb_fdblocks > metadata_blocks)
-		est_fdblocks = mp->m_sb.sb_fdblocks - metadata_blocks;
 
 	for_each_rtgroup(mp, rgno, rtg) {
 		ensure_rtgroup_rmapbt(rtg, est_fdblocks);

