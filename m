Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E606B1D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424222; cv=none; b=ocEiHRHcsOnyOwk/FQc5lcW84WA8Rq+RyFFPskSw6K5a74yt9h053eY2G3GuNwghqcuj4zV7pZdwPeDeEALXj0pvxtoQPLi3A9rq0GTw8+LFfiWYBtTe7NpxaYG2l06g0mNk0DGoA35mS98Oxwsld5GqSc54YWOvDgH0BVc2Tdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424222; c=relaxed/simple;
	bh=5DEvZDxbEdi+a+x6FKlnvJ+KFI+BE4/ssl+CGqZczXU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UMYFjjfaTRHoajbYIb8UnR2Uedc8ySUrDuI4rSM4yYOB6HQCcVCbQBhtQGevkBJQBwS6BQznsttj5HRRvvmI06Tgf6tDg/G6TnxU1LYg7wh6MO6x5uGZRzayZ4KOOuMBF4KilRjTKpSeb64C9pXctZd8mLWaVPcqidDeyHnX31s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dm1SS4xT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dm1SS4xT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B929DC433F1;
	Tue, 26 Mar 2024 03:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424221;
	bh=5DEvZDxbEdi+a+x6FKlnvJ+KFI+BE4/ssl+CGqZczXU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dm1SS4xTTdSrQtcmgjmZMFUJ+nXfj3SojRHW95CNabmJamxsBJSPGXs92CJA8ajTO
	 wKhztu6wI1tm/6UHD9iEWVhqtrYTdmtzXvE6MKZpPbF1h5zBdj5vtBPljiihuBskX6
	 aVyUiZ9eL8dpvDOGceL1SkOK0adPBYkTgS5q4Nj1BcFO1bP/Z7FhjivgWU2kx8uPh2
	 uTOgye018GmpiZq3Fv3vC5OctMAmLKkaadBrPCNEUahDSYKYck4HptFbWvU0eShXA0
	 D+FXB1+uXTnVQ21BtMRYSeYL5yukb20ql0Tb3QKWxiC/VhSemElCZb0xEVg1h5Gui3
	 84cEgHqwE+xtg==
Date: Mon, 25 Mar 2024 20:37:01 -0700
Subject: [PATCH 033/110] xfs: remove bc_ino.flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131860.2215168.7368213418762511345.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index 72d35f664110..9e44f4caee16 100644
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
index acb83443fc03..52a1ce460a1b 100644
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
index cd8cb2def194..3b9c95bcfbdd 100644
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
index 5a292d7a7096..17a0324a304e 100644
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
 

