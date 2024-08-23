Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2803D51A
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372799; cv=none; b=aFQLBVbC2uFQjQnLuO5Q9zdrDONJYiF66i/ej4mgNCchYi58EvE9ht9AL7dJ3dV3fmGZKlVZOECLsJCAFKc0fi0UGuoacJFCnwL6UwGEujy0Tqnp4pvTfNIMXilNDUmzgAFxf7Xj4tTjzJScOJEf4M/QU0uc9EPxnjyGOIK5db8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372799; c=relaxed/simple;
	bh=gjDglHqQiu11rEXEtgRLRp/ZzI5VqWypRgvgtzpT+e8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gh0RmmNl5S/rkU5SNQry4DxHOkGnkYhJnOcU63gA2hZJaglrB0oQJiN89wNFVmcpa9BOWVlXRXJFzsBxiEIPoYCGYx1gm4oTKLfhp+AiJDrH9UYqKzxDmuhuA2UGluLKBRn0qzdYa4Ra8tAL2FEJ2lphv+wgGUAZLIfIcbijQVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWWMLbZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWWMLbZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE9DC32782;
	Fri, 23 Aug 2024 00:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372799;
	bh=gjDglHqQiu11rEXEtgRLRp/ZzI5VqWypRgvgtzpT+e8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oWWMLbZZ3BPXtzGAgr2qv96yXiAV1PQJIN3Y8Jcl1kFvLolxq6fr/4+Z8qgT79lRC
	 euYzMrkL0uzVFUwY9UL4Sh5Tmh4/Ktnzv6GR+1OiSDth2D6n8xW8Jfk86gWYeygKp6
	 3j4UTp1LXdpKX7pAYxIX2IWGEK9IgpCdUlQRlzcFXrPy6Pa0EIzdjNotjniY9pJdYQ
	 7ep8n5Ui8xb5I3uDfpGQI491+ekQ5dK752do4+zgCN+PNaY8EwMQjZUm9i3yg2ORab
	 L5qSCTSGWQCgVNaNVWUe4Y7QMln9cdzvkN/eENQJ+fZFnfBjoM7dUPnuvQkJxTderz
	 xmvjQyKsd2mpg==
Date: Thu, 22 Aug 2024 17:26:38 -0700
Subject: [PATCH 21/26] xfs: make the RT allocator rtgroup aware
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088886.60592.11418423460788700576.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Make the allocator rtgroup aware by either picking a specific group if
there is a hint, or loop over all groups otherwise.  A simple rotor is
provided to pick the placement for initial allocations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |   13 +++++-
 fs/xfs/libxfs/xfs_rtbitmap.c |    6 ++-
 fs/xfs/xfs_mount.h           |    1 
 fs/xfs/xfs_rtalloc.c         |   98 ++++++++++++++++++++++++++++++++++++++----
 4 files changed, 105 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 126a0d253654a..88c62e1158ac7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3151,8 +3151,17 @@ xfs_bmap_adjacent_valid(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 
 	if (XFS_IS_REALTIME_INODE(ap->ip) &&
-	    (ap->datatype & XFS_ALLOC_USERDATA))
-		return x < mp->m_sb.sb_rblocks;
+	    (ap->datatype & XFS_ALLOC_USERDATA)) {
+		if (x >= mp->m_sb.sb_rblocks)
+			return false;
+		if (!xfs_has_rtgroups(mp))
+			return true;
+
+		return xfs_rtb_to_rgno(mp, x) == xfs_rtb_to_rgno(mp, y) &&
+			xfs_rtb_to_rgno(mp, x) < mp->m_sb.sb_rgcount &&
+			xfs_rtb_to_rtx(mp, x) < mp->m_sb.sb_rgextents;
+
+	}
 
 	return XFS_FSB_TO_AGNO(mp, x) == XFS_FSB_TO_AGNO(mp, y) &&
 		XFS_FSB_TO_AGNO(mp, x) < mp->m_sb.sb_agcount &&
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index c8958d3e0abe0..ef94b67feccd7 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1084,11 +1084,13 @@ xfs_rtfree_extent(
 	 * Mark more blocks free in the superblock.
 	 */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, (long)len);
+
 	/*
 	 * If we've now freed all the blocks, reset the file sequence
-	 * number to 0.
+	 * number to 0 for pre-RTG file systems.
 	 */
-	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
+	if (!xfs_has_rtgroups(mp) &&
+	    tp->t_frextents_delta + mp->m_sb.sb_frextents ==
 	    mp->m_sb.sb_rextents) {
 		if (!(rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
 			rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c4e4f5414a299..7e68812db1be7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -223,6 +223,7 @@ typedef struct xfs_mount {
 #endif
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
+	atomic_t		m_rtgrotor;	/* last rtgroup rtpicked */
 
 	/* Memory shrinker to throttle and reprioritize inodegc */
 	struct shrinker		*m_inodegc_shrinker;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3fedc552b51b0..2b57ff2687bf6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1661,8 +1661,9 @@ xfs_rtalloc_align_minmax(
 }
 
 static int
-xfs_rtallocate(
+xfs_rtallocate_rtg(
 	struct xfs_trans	*tp,
+	xfs_rgnumber_t		rgno,
 	xfs_rtblock_t		bno_hint,
 	xfs_rtxlen_t		minlen,
 	xfs_rtxlen_t		maxlen,
@@ -1682,16 +1683,33 @@ xfs_rtallocate(
 	xfs_rtxlen_t		len = 0;
 	int			error = 0;
 
-	args.rtg = xfs_rtgroup_grab(args.mp, 0);
+	args.rtg = xfs_rtgroup_grab(args.mp, rgno);
 	if (!args.rtg)
 		return -ENOSPC;
 
 	/*
-	 * Lock out modifications to both the RT bitmap and summary inodes.
+	 * We need to lock out modifications to both the RT bitmap and summary
+	 * inodes for finding free space in xfs_rtallocate_extent_{near,size}
+	 * and join the bitmap and summary inodes for the actual allocation
+	 * down in xfs_rtallocate_range.
+	 *
+	 * For RTG-enabled file system we don't want to join the inodes to the
+	 * transaction until we are committed to allocate to allocate from this
+	 * RTG so that only one inode of each type is locked at a time.
+	 *
+	 * But for pre-RTG file systems we need to already to join the bitmap
+	 * inode to the transaction for xfs_rtpick_extent, which bumps the
+	 * sequence number in it, so we'll have to join the inode to the
+	 * transaction early here.
+	 *
+	 * This is all a bit messy, but at least the mess is contained in
+	 * this function.
 	 */
 	if (!*rtlocked) {
 		xfs_rtgroup_lock(args.rtg, XFS_RTGLOCK_BITMAP);
-		xfs_rtgroup_trans_join(tp, args.rtg, XFS_RTGLOCK_BITMAP);
+		if (!xfs_has_rtgroups(args.mp))
+			xfs_rtgroup_trans_join(tp, args.rtg,
+					XFS_RTGLOCK_BITMAP);
 		*rtlocked = true;
 	}
 
@@ -1701,7 +1719,7 @@ xfs_rtallocate(
 	 */
 	if (bno_hint)
 		start = xfs_rtb_to_rtx(args.mp, bno_hint);
-	else if (initial_user_data)
+	else if (!xfs_has_rtgroups(args.mp) && initial_user_data)
 		start = xfs_rtpick_extent(args.rtg, tp, maxlen);
 
 	if (start) {
@@ -1722,8 +1740,16 @@ xfs_rtallocate(
 				prod, &rtx);
 	}
 
-	if (error)
+	if (error) {
+		if (xfs_has_rtgroups(args.mp)) {
+			xfs_rtgroup_unlock(args.rtg, XFS_RTGLOCK_BITMAP);
+			*rtlocked = false;
+		}
 		goto out_release;
+	}
+
+	if (xfs_has_rtgroups(args.mp))
+		xfs_rtgroup_trans_join(tp, args.rtg, XFS_RTGLOCK_BITMAP);
 
 	error = xfs_rtallocate_range(&args, rtx, len);
 	if (error)
@@ -1741,6 +1767,53 @@ xfs_rtallocate(
 	return error;
 }
 
+static int
+xfs_rtallocate_rtgs(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		bno_hint,
+	xfs_rtxlen_t		minlen,
+	xfs_rtxlen_t		maxlen,
+	xfs_rtxlen_t		prod,
+	bool			wasdel,
+	bool			initial_user_data,
+	xfs_rtblock_t		*bno,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rgnumber_t		start_rgno, rgno;
+	int			error;
+
+	/*
+	 * For now this just blindly iterates over the RTGs for an initial
+	 * allocation.  We could try to keep an in-memory rtg_longest member
+	 * to avoid the locking when just looking for big enough free space,
+	 * but for now this keep things simple.
+	 */
+	if (bno_hint != NULLFSBLOCK)
+		start_rgno = xfs_rtb_to_rgno(mp, bno_hint);
+	else
+		start_rgno = (atomic_inc_return(&mp->m_rtgrotor) - 1) %
+				mp->m_sb.sb_rgcount;
+
+	rgno = start_rgno;
+	do {
+		bool		rtlocked = false;
+
+		error = xfs_rtallocate_rtg(tp, rgno, bno_hint, minlen, maxlen,
+				prod, wasdel, initial_user_data, &rtlocked,
+				bno, blen);
+		if (error != -ENOSPC)
+			return error;
+		ASSERT(!rtlocked);
+
+		if (++rgno == mp->m_sb.sb_rgcount)
+			rgno = 0;
+		bno_hint = NULLFSBLOCK;
+	} while (rgno != start_rgno);
+
+	return -ENOSPC;
+}
+
 static int
 xfs_rtallocate_align(
 	struct xfs_bmalloca	*ap,
@@ -1835,9 +1908,16 @@ xfs_bmap_rtalloc(
 	if (xfs_bmap_adjacent(ap))
 		bno_hint = ap->blkno;
 
-	error = xfs_rtallocate(ap->tp, bno_hint, raminlen, ralen, prod,
-			ap->wasdel, initial_user_data, &rtlocked,
-			&ap->blkno, &ap->length);
+	if (xfs_has_rtgroups(ap->ip->i_mount)) {
+		error = xfs_rtallocate_rtgs(ap->tp, bno_hint, raminlen, ralen,
+				prod, ap->wasdel, initial_user_data,
+				&ap->blkno, &ap->length);
+	} else {
+		error = xfs_rtallocate_rtg(ap->tp, 0, bno_hint, raminlen, ralen,
+				prod, ap->wasdel, initial_user_data,
+				&rtlocked, &ap->blkno, &ap->length);
+	}
+
 	if (error == -ENOSPC) {
 		if (!noalign) {
 			/*

