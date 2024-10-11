Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B544C7D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608830; cv=none; b=nDCBS1S8ymRM0kCMex7EtabtCpXzej8n3N3bI0NraPASv9H83JuT/sKAqL7iZTeChiXAoonZOjxmuNLPeJGd4gna3CVUeIwbQ6VBFiWzSqbEZusHC0f6erMXmTSnWO70kFGtL/xvP0iDWevkdEQcSm0991u9zKKxw61KkcArZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608830; c=relaxed/simple;
	bh=4JmGMIa9omNI1ED7DTu6UPbOb14Ud/hO7of8nc2B8Ac=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PvpJUYt3SMWbY0Tr3vb43QEGLobrLd07ESGG9uaX5A5Ds9/8kLT1HZACHEusNv/xTM7JEx8KK6jicjg054ATsUIlWLOi9AaPQGF2EPSWIxmthn8yD/3sCGbZovE748utxOsFY4UZaz42zW6SV+y2gOp3SdsA/A4JWijyhH2vmtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebWc/zYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebWc/zYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956B6C4CEC5;
	Fri, 11 Oct 2024 01:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608829;
	bh=4JmGMIa9omNI1ED7DTu6UPbOb14Ud/hO7of8nc2B8Ac=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ebWc/zYk3L3/qoTBASlAaEqcknOWB6b8XJPN3k1/XJxSG5cyr/v1F/Ic9fx+fiF5A
	 HC2b+UKyrYC55iwCXZLd45XRxZYRx5mJSK07ragTOp0hOo3VtqUI9Q1gGA+9+t3wbm
	 lPH5cUXRW6EqtkpP8jTIPezIQAZkMWvIOHKg35HDNfgsHrgeqAPPP6rw7E5Wa4FGpd
	 AH/spM3MCfqcV+CpiGU/S8UlFOddW2Hoi6XMFIxXx5qA88XhXjxG4wwgADwmr2FhpZ
	 a0xZoWbgVX1754fPXWqFmsQVv4GpaELKcc7BSI0v1fa/MZvjKxYBe30eKSxx34SBTX
	 fJYUJ/BMSeS7w==
Date: Thu, 10 Oct 2024 18:07:09 -0700
Subject: [PATCH 21/36] xfs: make the RT allocator rtgroup aware
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644603.4178701.9116868632667044544.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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
index 14eba7ae601622..d715c72d0dffef 100644
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
index a3858c4363e09e..7aaa42fff8b92b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -225,6 +225,7 @@ typedef struct xfs_mount {
 #endif
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
+	atomic_t		m_rtgrotor;	/* last rtgroup rtpicked */
 
 	/* Memory shrinker to throttle and reprioritize inodegc */
 	struct shrinker		*m_inodegc_shrinker;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 2093cab0cf8cb5..783674fd42ead1 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1660,8 +1660,9 @@ xfs_rtalloc_align_minmax(
 }
 
 static int
-xfs_rtallocate(
+xfs_rtallocate_rtg(
 	struct xfs_trans	*tp,
+	xfs_rgnumber_t		rgno,
 	xfs_rtblock_t		bno_hint,
 	xfs_rtxlen_t		minlen,
 	xfs_rtxlen_t		maxlen,
@@ -1681,16 +1682,33 @@ xfs_rtallocate(
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
 
@@ -1700,7 +1718,7 @@ xfs_rtallocate(
 	 */
 	if (bno_hint)
 		start = xfs_rtb_to_rtx(args.mp, bno_hint);
-	else if (initial_user_data)
+	else if (!xfs_has_rtgroups(args.mp) && initial_user_data)
 		start = xfs_rtpick_extent(args.rtg, tp, maxlen);
 
 	if (start) {
@@ -1721,8 +1739,16 @@ xfs_rtallocate(
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
@@ -1740,6 +1766,53 @@ xfs_rtallocate(
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
@@ -1834,9 +1907,16 @@ xfs_bmap_rtalloc(
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

