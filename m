Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC2E18E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846123; cv=none; b=UM6ZZQ6Ix4U/m3hZVY5McvZvkST2siSclQ0pKvJTfVup3th9wulxoNRwAVR8h0/Hw49kn7IZ32ZGRMqhp4eLObgbJ3FX8nCneIatzG4jOldC2VxMsntOeWpDGt3DcPITk0HAU0rfNn+oLPt7cYZDLNXc6WkrlNacdzvtRerAqpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846123; c=relaxed/simple;
	bh=/qHBdNys8BfqUUM4z55R2mxH1YoQOattGi9wIxAsJic=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTLD5OQTw0hx352MA3LW+TD3kHhhwMYV7c6dGVH6wpEXDSeCCeZX3vEaSz+vkP/CzM7lsKLeKJ93muk44u0ax6sG7hGN9GHjGr7Nfscp1auqTUvPU0H2oQJ50PfM1dDS7FaYnro9WyC08pfTbYERRatS0vp0AayM0kjuWRXHuGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chxzRq2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chxzRq2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB237C4CECF;
	Tue,  5 Nov 2024 22:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846122;
	bh=/qHBdNys8BfqUUM4z55R2mxH1YoQOattGi9wIxAsJic=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=chxzRq2fzvEDKDAQvTu27Xrbbuz9VoBJoVz0mposHXm2RvpouA/mPoCKIrBUWEeNq
	 VXOAicN5DQQifUOraHF8pSWFDCmJ6cdNGhsPj/wAEaF4y0ZqLQaAXEwZOR0E46rsrO
	 lKRhT7fUtWnAUYd4bZ+ZxlhMqnRQL6K186l08ClW8NCQhC3+W6n7U5uoCIqBFTu/9o
	 rjpnXCeqnAe/x8I8sajjuWpoqjgr20lnitFymL5szUpdp4y08TaXBNSmJNEmi0hfs9
	 eLxkOCsACiG6SZaTRyMKj5r5MrsibJvAzEpB1saV7toywNGDJLCBr3GqIKhM+MtMVR
	 HGepPoGYzbaVA==
Date: Tue, 05 Nov 2024 14:35:22 -0800
Subject: [PATCH 21/34] xfs: make the RT allocator rtgroup aware
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398543.1871887.8767096560682916710.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
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
index b15a43c18b0a57..3498d7b4fbc54e 100644
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
index c73826aa4425af..5abfd84852ce3b 100644
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
index 1f228047639587..62c251b3a385d4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -255,6 +255,7 @@ typedef struct xfs_mount {
 #endif
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
+	atomic_t		m_rtgrotor;	/* last rtgroup rtpicked */
 
 	/* Memory shrinker to throttle and reprioritize inodegc */
 	struct shrinker		*m_inodegc_shrinker;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 1f53d5e07a91a0..b27d23bcc06418 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1662,8 +1662,9 @@ xfs_rtalloc_align_minmax(
 }
 
 static int
-xfs_rtallocate(
+xfs_rtallocate_rtg(
 	struct xfs_trans	*tp,
+	xfs_rgnumber_t		rgno,
 	xfs_rtblock_t		bno_hint,
 	xfs_rtxlen_t		minlen,
 	xfs_rtxlen_t		maxlen,
@@ -1683,16 +1684,33 @@ xfs_rtallocate(
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
 
@@ -1702,7 +1720,7 @@ xfs_rtallocate(
 	 */
 	if (bno_hint)
 		start = xfs_rtb_to_rtx(args.mp, bno_hint);
-	else if (initial_user_data)
+	else if (!xfs_has_rtgroups(args.mp) && initial_user_data)
 		start = xfs_rtpick_extent(args.rtg, tp, maxlen);
 
 	if (start) {
@@ -1723,8 +1741,16 @@ xfs_rtallocate(
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
@@ -1742,6 +1768,53 @@ xfs_rtallocate(
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
+	 * but for now this keeps things simple.
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
@@ -1836,9 +1909,16 @@ xfs_bmap_rtalloc(
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

