Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73E457CAC
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346643; cv=none; b=Xe9mYIjehg7hV5HmTJcDFJEo0huaZVk7GWxY4RwqTzYxBOgYcg9Dju5AK3mmv08BCdCpsSH8ypJ4cDgeKoAHGEFw4Tmb174Hw0YBOX3EZbT/h8i/SKhV+V5ZclZ0i+ncIdTrd/rY/LxQf2KfxrJCN0UqD2r4T6XseqXu81BROG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346643; c=relaxed/simple;
	bh=dgOXIGLfFZZ/qUHfJIqDRFShMpiVmvbrV2hJMO/wgOA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=idGjYsaPG0LsMoVU06RnREcEINgulsHU3ugX/I1aY5TiMBPyV4lZMRYred0KbN1j9LQB1chwP7xIuqJTkIJcIXH7mRY/aqpH4fIc4Rl7S19ZcP/WHPYJp0jLJdPvLyxfcPpBdwDcOmWpv39tspWC9rvgn4KAonC6eNKj9B9eKmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6C7mvJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6C7mvJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A8BC2BD11;
	Wed, 22 May 2024 02:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346643;
	bh=dgOXIGLfFZZ/qUHfJIqDRFShMpiVmvbrV2hJMO/wgOA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z6C7mvJOwfyOw3/9GbbUrY4nM5BJS2Jo4aWuI4jkkEsUzOCoDPa/K3ivdZ3RP5Ys8
	 7x20kXaDQIcqaqUXpRBv7pnA2v6+SiQf7fMkLKJpmIECNwoB11Q9nl1L4GnndwqBc+
	 aKQbqeg54gn7Fjimyv1rAX7Dzu3WxA358rZLHPv1PmESt23zRdzuLR2lmjFDF3HTM4
	 ICsT56EuCM8Mz1Bkh5+r3cvgOrcRf37a0rVdSTOEyZqLBYhkcG3xmBRfQjBnssnDm5
	 pso1Z5pMNouhNZMvapup7fUB9SjkkAaA7kOYRJqaznm367yfigehNiU6Pu0MlmUrnx
	 y+SJL3qgUYnIg==
Date: Tue, 21 May 2024 19:57:22 -0700
Subject: [PATCH 033/111] xfs: remove bc_ino.flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532207.2478931.14220560814710574687.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: e9e66df8bfa4132d905543a6b099ec8a3380b732

Just move the two flags into bc_flags where there is plenty of space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c       |   27 +++++++++------------------
 libxfs/xfs_bmap_btree.c |   14 ++++----------
 libxfs/xfs_btree.c      |    2 +-
 libxfs/xfs_btree.h      |   12 ++++++------
 4 files changed, 20 insertions(+), 35 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 72d35f664..9e44f4cae 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -645,7 +645,8 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
+	if (wasdel)
+		cur->bc_flags |= XFS_BTREE_BMBT_WASDEL;
 	/*
 	 * Convert to a btree with two levels, one record in root.
 	 */
@@ -1443,8 +1444,7 @@ xfs_bmap_add_extent_delay_real(
 
 	ASSERT(whichfork != XFS_ATTR_FORK);
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!bma->cur ||
-	       (bma->cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
+	ASSERT(!bma->cur || (bma->cur->bc_flags & XFS_BTREE_BMBT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -2703,7 +2703,7 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_bmbt_irec	old;
 
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
+	ASSERT(!cur || !(cur->bc_flags & XFS_BTREE_BMBT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -4223,9 +4223,8 @@ xfs_bmapi_allocate(
 	 */
 	bma->nallocs++;
 
-	if (bma->cur)
-		bma->cur->bc_ino.flags =
-			bma->wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
+	if (bma->cur && bma->wasdel)
+		bma->cur->bc_flags |= XFS_BTREE_BMBT_WASDEL;
 
 	bma->got.br_startoff = bma->offset;
 	bma->got.br_startblock = bma->blkno;
@@ -4760,10 +4759,8 @@ xfs_bmapi_remap(
 	ip->i_nblocks += len;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
-	}
 
 	got.br_startoff = bno;
 	got.br_startblock = startblock;
@@ -5394,7 +5391,6 @@ __xfs_bunmapi(
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
 	} else
 		cur = NULL;
 
@@ -5855,10 +5851,8 @@ xfs_bmap_collapse_extents(
 	if (error)
 		return error;
 
-	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
-	}
 
 	if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &icur, &got)) {
 		*done = true;
@@ -5972,10 +5966,8 @@ xfs_bmap_insert_extents(
 	if (error)
 		return error;
 
-	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
-	}
 
 	if (*next_fsb == NULLFSBLOCK) {
 		xfs_iext_last(ifp, &icur);
@@ -6092,7 +6084,6 @@ xfs_bmap_split_extent(
 
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			goto del_cursor;
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index acb83443f..52a1ce460 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -170,13 +170,8 @@ xfs_bmbt_dup_cursor(
 
 	new = xfs_bmbt_init_cursor(cur->bc_mp, cur->bc_tp,
 			cur->bc_ino.ip, cur->bc_ino.whichfork);
-
-	/*
-	 * Copy the firstblock, dfops, and flags values,
-	 * since init cursor doesn't get them.
-	 */
-	new->bc_ino.flags = cur->bc_ino.flags;
-
+	new->bc_flags |= (cur->bc_flags &
+		(XFS_BTREE_BMBT_INVALID_OWNER | XFS_BTREE_BMBT_WASDEL));
 	return new;
 }
 
@@ -210,7 +205,7 @@ xfs_bmbt_alloc_block(
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
 			cur->bc_ino.whichfork);
 	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
+	args.wasdel = cur->bc_flags & XFS_BTREE_BMBT_WASDEL;
 	if (!args.wasdel && args.tp->t_blk_res == 0)
 		return -ENOSPC;
 
@@ -556,7 +551,6 @@ xfs_bmbt_init_common(
 
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
-	cur->bc_ino.flags = 0;
 
 	return cur;
 }
@@ -747,7 +741,7 @@ xfs_bmbt_change_owner(
 	ASSERT(xfs_ifork_ptr(ip, whichfork)->if_format == XFS_DINODE_FMT_BTREE);
 
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
-	cur->bc_ino.flags |= XFS_BTCUR_BMBT_INVALID_OWNER;
+	cur->bc_flags |= XFS_BTREE_BMBT_INVALID_OWNER;
 
 	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
 	xfs_btree_del_cursor(cur, error);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index cd8cb2def..3b9c95bcf 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1834,7 +1834,7 @@ xfs_btree_lookup_get_block(
 
 	/* Check the inode owner since the verifiers don't. */
 	if (xfs_has_crc(cur->bc_mp) &&
-	    !(cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER) &&
+	    !(cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER) &&
 	    (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
 			cur->bc_ino.ip->i_ino)
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 5a292d7a70..17a0324a3 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -249,12 +249,6 @@ struct xfs_btree_cur_ino {
 	int				allocated;
 	short				forksize;
 	char				whichfork;
-	char				flags;
-/* We are converting a delalloc reservation */
-#define	XFS_BTCUR_BMBT_WASDEL		(1 << 0)
-
-/* For extent swap, ignore owner check in verifier */
-#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
 };
 
 struct xfs_btree_level {
@@ -321,6 +315,12 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
  */
 #define XFS_BTREE_STAGING		(1U << 0)
 
+/* We are converting a delalloc reservation (only for bmbt btrees) */
+#define	XFS_BTREE_BMBT_WASDEL		(1U << 1)
+
+/* For extent swap, ignore owner check in verifier (only for bmbt btrees) */
+#define	XFS_BTREE_BMBT_INVALID_OWNER	(1U << 2)
+
 #define	XFS_BTREE_NOERROR	0
 #define	XFS_BTREE_ERROR		1
 

