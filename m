Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4242417CB
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882529; cv=none; b=uW/OJVDFkH09+xnPjvU7agFEYeq9LPo/RFYCh1izaPqRxGnod1RcyluMnuHz9eQEfZlfNC+WEZ5vqSBwOFTSOjv7JaX/hNi5+SkloW/AOeHaZrOcDCukaCnVauo4HwKbIDzwXCaQuKuCI9sFxDv7z+8d/l3+THvTvy5F0GRV3ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882529; c=relaxed/simple;
	bh=xrUchvP9TfMHuwj5Jp4BwvNt7L7NflK8tBjQycwpV18=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yxi41z1s6X1QutLxmRLhwEOi90NomtGaDMq8KXIXcMSB1X12RG6GT5GAovTfYwdhihsmv0z96LoiOCrAtlsGs2dXe2wT/hJkCrO8sk2864qkVlcCofDcdwGcB1gLrRJMoVUB5cHxK83mqWgaCms5q2GqAOdOLjr+8UIOXYxzdSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnN+DLUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnN+DLUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BDEC4CEDD;
	Thu,  6 Feb 2025 22:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882528;
	bh=xrUchvP9TfMHuwj5Jp4BwvNt7L7NflK8tBjQycwpV18=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bnN+DLUA38TLcSd4RHDBtqAL2E5QWzh3XFOOPuTAbGiBlvMsOXn8DO4/o2SMk/nfk
	 xMjXxgdQfQGFgi1L2ZXIGpETaXplF0M/Di5faNqmvUIb30rpzff8c9t7jwlpEYjFcC
	 kXDMC4J8B4fMIHGvRyGI7h0IQS/B1fxnmk76H5cu/ZXwvAYh5EyIQqMUbt6EPfUSpj
	 AIOtud8zjITeSRsTppxkp5LVLkGRy/WvRRa5p2wztpTF8VvJ8V/nkmYTO5RmFY+ohM
	 qPN9oTjMUweXaEZd29lE++IES0hkBji4W5+QPFXQX3BA3Iv0RBohSsZ5ji3hQNIUwN
	 4uk/r6gHSSNLw==
Date: Thu, 06 Feb 2025 14:55:28 -0800
Subject: [PATCH 22/27] xfs_repair: check for global free space concerns with
 default btree slack levels
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088433.2741033.15187806936982398424.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/globals.c |    6 +++
 repair/globals.h |    2 +
 repair/phase5.c  |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 repair/phase6.c  |   16 +++++---
 4 files changed, 129 insertions(+), 9 deletions(-)


diff --git a/repair/globals.c b/repair/globals.c
index 99291d6afd61b9..143b4a8beb53f4 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -114,6 +114,12 @@ int		thread_count;
 /* If nonzero, simulate failure after this phase. */
 int		fail_after_phase;
 
+/*
+ * Do we think we're going to be so low on disk space that we need to pack
+ * all rebuilt btree blocks completely full to avoid running out of space?
+ */
+bool		need_packed_btrees;
+
 /* quota inode numbers */
 enum quotino_state {
 	QI_STATE_UNKNOWN,
diff --git a/repair/globals.h b/repair/globals.h
index b23a06af6cc81b..8bb9bbaeca4fb0 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -159,6 +159,8 @@ extern int		fail_after_phase;
 
 extern struct libxfs_init x;
 
+extern bool		need_packed_btrees;
+
 void set_quota_inode(xfs_dqtype_t type, xfs_ino_t);
 void lose_quota_inode(xfs_dqtype_t type);
 void clear_quota_inode(xfs_dqtype_t type);
diff --git a/repair/phase5.c b/repair/phase5.c
index ac5f04697b7110..cacaf74dda3a60 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -481,11 +481,14 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 
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
@@ -632,6 +635,107 @@ check_rtmetadata(
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
+	struct xfs_mount	*mp = pag_mount(pag);
+	xfs_agblock_t		agbno;
+	xfs_agblock_t		ag_end;
+	xfs_extlen_t		extent_len;
+	xfs_extlen_t		blen;
+	unsigned int		num_extents = 0;
+	int			bstate;
+	bool			in_extent = false;
+
+	/* Find the number of free space extents. */
+	ag_end = libxfs_ag_block_count(mp, pag_agno(pag));
+	for (agbno = 0; agbno < ag_end; agbno += blen) {
+		bstate = get_bmap_ext(pag_agno(pag), agbno, ag_end, &blen,
+				false);
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
+	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
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
+	while ((pag = xfs_perag_next(mp, pag))) {
+		unsigned int	ag_fdblocks = 0;
+
+		metadata_blocks += estimate_agbtree_blocks_early(pag,
+								 &ag_fdblocks);
+		fdblocks += ag_fdblocks;
+	}
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		metadata_blocks += estimate_rtrmapbt_blocks(rtg);
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
@@ -683,6 +787,8 @@ phase5(xfs_mount_t *mp)
 	if (error)
 		do_error(_("cannot alloc lost block bitmap\n"));
 
+	need_packed_btrees = are_packed_btrees_needed(mp);
+
 	while ((pag = xfs_perag_next(mp, pag)))
 		phase5_func(mp, pag, lost_blocks);
 
diff --git a/repair/phase6.c b/repair/phase6.c
index cae9d970481840..2ddfd0526767e0 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3399,12 +3399,18 @@ reset_rt_metadir_inodes(
 		mark_ino_metadata(mp, mp->m_rtdirip->i_ino);
 	}
 
-	/* Estimate how much free space will be left after building btrees */
-	while ((rtg = xfs_rtgroup_next(mp, rtg)))
-		metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+	/*
+	 * Estimate how much free space will be left after building btrees
+	 * unless we already decided that we needed to pack all new blocks
+	 * maximally.
+	 */
+	if (!need_packed_btrees) {
+		while ((rtg = xfs_rtgroup_next(mp, rtg)))
+			metadata_blocks += estimate_rtrmapbt_blocks(rtg);
 
-	if (mp->m_sb.sb_fdblocks > metadata_blocks)
-		est_fdblocks = mp->m_sb.sb_fdblocks - metadata_blocks;
+		if (mp->m_sb.sb_fdblocks > metadata_blocks)
+			est_fdblocks = mp->m_sb.sb_fdblocks - metadata_blocks;
+	}
 
 	/*
 	 * This isn't the whole story, but it keeps the message that we've had

