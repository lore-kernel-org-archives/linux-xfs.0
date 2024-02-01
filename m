Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F26143AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816491; cv=none; b=spwJk7eG2DbTGtebAyRXdiH0PD7GL6VlJcPckvdeR4wVFVbdbAVdymyvAOr/9WIiOaI3TNWCiWx5+BOIEKLzsTYMHKui8xVwCIf75/7PkJBBUi2xvc5ZmzM5Gj1Lkjd0DG+HK9RWn9ho4KmkA/49J2W9ym5XxmdadqF4HPW8uQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816491; c=relaxed/simple;
	bh=NyPqzoNkVsXOG2uJJzBBCBbPbpwD8zn4KfV3Zz+CYEE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tUh+2QGCdNcy0Wk/vXIvmR4qD1XFQMou3u0yryk69ynE5FoXS/5cBjoJ2V80RcKOyBYr+09/xeSwNQY2w4WF/NjDIO+5cUO1oAO7oDzMw38s+HQkAmFZ/qFmVuCRIFHzBo1cz+uqbvrP6zyCzyajfgv6KwDDRVAGmaIGrO0JDMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWAHZHXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWAHZHXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9B3C433F1;
	Thu,  1 Feb 2024 19:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816490;
	bh=NyPqzoNkVsXOG2uJJzBBCBbPbpwD8zn4KfV3Zz+CYEE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hWAHZHXTf4DpM2ahFZyFxpLP+Sm8VmrYqZag49rdrOqqY5IUsyoIcXhDp+RbhMKX9
	 HpdMnPkHwFa5KdRdf0WTCRcFiZLUIoQ0Z3CXGCeFLkT5IiKRnZqfEJ4msvoXjvyyNP
	 kWwdH9X+NsQqIvjZRFxeUXI27ShkG95x8fEy1ZBcqOlsap2389fLxV5nSJLmmfs99u
	 yEfOJBAUMPGB8S3daLS401fnxhloha4o5jDKITwPJi3YrG4A939EPNTwxAI7ND7fca
	 9X7UWc2aPF88e/BlUWUYUXMH/WO9JMfwNvRhGgAFUCg5HoLOJgzWxTVQfHJmp15gxt
	 rCvkluHa9Zgsg==
Date: Thu, 01 Feb 2024 11:41:29 -0800
Subject: [PATCH 07/23] xfs: remove bc_ino.flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334052.1604831.1916669408139634731.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Just move the two flags into bc_flags where there is plenty of space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |   27 +++++++++------------------
 fs/xfs/libxfs/xfs_bmap_btree.c |   14 ++++----------
 fs/xfs/libxfs/xfs_btree.c      |    2 +-
 fs/xfs/libxfs/xfs_btree.h      |   12 ++++++------
 4 files changed, 20 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 22b88bfca7d63..49d398e2b05e6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -651,7 +651,8 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
+	if (wasdel)
+		cur->bc_flags |= XFS_BTREE_BMBT_WASDEL;
 	/*
 	 * Convert to a btree with two levels, one record in root.
 	 */
@@ -1449,8 +1450,7 @@ xfs_bmap_add_extent_delay_real(
 
 	ASSERT(whichfork != XFS_ATTR_FORK);
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!bma->cur ||
-	       (bma->cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
+	ASSERT(!bma->cur || (bma->cur->bc_flags & XFS_BTREE_BMBT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -2709,7 +2709,7 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_bmbt_irec	old;
 
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
+	ASSERT(!cur || !(cur->bc_flags & XFS_BTREE_BMBT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -4229,9 +4229,8 @@ xfs_bmapi_allocate(
 	 */
 	bma->nallocs++;
 
-	if (bma->cur)
-		bma->cur->bc_ino.flags =
-			bma->wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
+	if (bma->cur && bma->wasdel)
+		bma->cur->bc_flags |= XFS_BTREE_BMBT_WASDEL;
 
 	bma->got.br_startoff = bma->offset;
 	bma->got.br_startblock = bma->blkno;
@@ -4766,10 +4765,8 @@ xfs_bmapi_remap(
 	ip->i_nblocks += len;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
-	}
 
 	got.br_startoff = bno;
 	got.br_startblock = startblock;
@@ -5400,7 +5397,6 @@ __xfs_bunmapi(
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
 	} else
 		cur = NULL;
 
@@ -5862,10 +5858,8 @@ xfs_bmap_collapse_extents(
 	if (error)
 		return error;
 
-	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
-	}
 
 	if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &icur, &got)) {
 		*done = true;
@@ -5979,10 +5973,8 @@ xfs_bmap_insert_extents(
 	if (error)
 		return error;
 
-	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
-	}
 
 	if (*next_fsb == NULLFSBLOCK) {
 		xfs_iext_last(ifp, &icur);
@@ -6099,7 +6091,6 @@ xfs_bmap_split_extent(
 
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_ino.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			goto del_cursor;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 69056fe8a51ea..48617627bc83f 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -171,13 +171,8 @@ xfs_bmbt_dup_cursor(
 
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
 
@@ -211,7 +206,7 @@ xfs_bmbt_alloc_block(
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
 			cur->bc_ino.whichfork);
 	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
+	args.wasdel = cur->bc_flags & XFS_BTREE_BMBT_WASDEL;
 	if (!args.wasdel && args.tp->t_blk_res == 0)
 		return -ENOSPC;
 
@@ -557,7 +552,6 @@ xfs_bmbt_init_common(
 
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
-	cur->bc_ino.flags = 0;
 
 	return cur;
 }
@@ -748,7 +742,7 @@ xfs_bmbt_change_owner(
 	ASSERT(xfs_ifork_ptr(ip, whichfork)->if_format == XFS_DINODE_FMT_BTREE);
 
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
-	cur->bc_ino.flags |= XFS_BTCUR_BMBT_INVALID_OWNER;
+	cur->bc_flags |= XFS_BTREE_BMBT_INVALID_OWNER;
 
 	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
 	xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index d0f97357400e6..2661b1648480a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1837,7 +1837,7 @@ xfs_btree_lookup_get_block(
 
 	/* Check the inode owner since the verifiers don't. */
 	if (xfs_has_crc(cur->bc_mp) &&
-	    !(cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER) &&
+	    !(cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER) &&
 	    (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
 			cur->bc_ino.ip->i_ino)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4efae0db58e92..a0daccf765c83 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
 

