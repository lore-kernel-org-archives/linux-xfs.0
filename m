Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9268F54
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608595; cv=none; b=BwpVp7V3lpR5IoHhtPpAvWcM8XMXw9fVg/2u3+ZtEcEWuYyqLD1u0J9GW+iSoYzAZlEkn8ANbLP5QNXVhQrFFNZFgacllvRjGhqAI/AZgSvw8v3yYk/fmN+BLzpy9CTOozmvJVLtrDuDiCE1EfVG9cnYCThUHiEfCrc8fdALY6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608595; c=relaxed/simple;
	bh=JXoUI0ogXsftW0w0zbXbVIngneEvbw80ha1Y8N47NEc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bjoRPOGeZ6V9daO9aGRitpzDVCpD+vDuizNtOenYm9NNbT0d6MhsmMnhIxzU/S2lTvkJHORAuzb+XelSDe49B+OH82RbSXXzkP9ST5k8pMUxvdZiMhut2J4VAVgtL/h0ZaTGTUbkaOdzeoZMMavCkYxCGib9BW6z99mtRBrRgYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rg22Xv+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rg22Xv+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E634C4CEC5;
	Fri, 11 Oct 2024 01:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608595;
	bh=JXoUI0ogXsftW0w0zbXbVIngneEvbw80ha1Y8N47NEc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rg22Xv+B0SbaB9ZDlcTxFcCNNSLnv6yU1o5YKf0JrvYqmKef4sIEOHL5gAU28QHyU
	 th5dy6+c/RBqqtT5hNZ0XIgT+a72QLlbbz/H7pVUJnf4Ld+l1vwa63SX/lDYhwzlLf
	 gVeznB9xl6WD5kLcgOewJb7yMIwL/pzNjDM0NWcMqyu/ByDeopdL28GiXnoEvnzcsq
	 6dLTObqOtS2y9Jg7tl4hycSIXL8WQTkDZfNiGq1g0gKv3iPq8wTLmBkZ3I4JDQdEJ2
	 C4mKyWpy21bnNwheXqUF04kuZFH7TnabcNbNecuKoEzZN5OIi92V9ogy9k9c7L7jta
	 z1MZkc6KlZhHw==
Date: Thu, 10 Oct 2024 18:03:15 -0700
Subject: [PATCH 06/36] xfs: add a helper to prevent bmap merges across rtgroup
 boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644342.4178701.16507067611350965440.stgit@frogsfrogsfrogs>
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

Except for the rt superblock, realtime groups do not store any metadata
at the start (or end) of the group.  There is nothing to prevent the
bmap code from merging allocations from multiple groups into a single
bmap record.  Add a helper to check for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: massage the commit message after pulling this into rtgroups]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   56 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 76dcc394bd817e..de6e90939d93b4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -40,6 +40,7 @@
 #include "xfs_bmap_item.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -1426,6 +1427,24 @@ xfs_bmap_last_offset(
  * Extent tree manipulation functions used during allocation.
  */
 
+static inline bool
+xfs_bmap_same_rtgroup(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*left,
+	struct xfs_bmbt_irec	*right)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (xfs_ifork_is_realtime(ip, whichfork) && xfs_has_rtgroups(mp)) {
+		if (xfs_rtb_to_rgno(mp, left->br_startblock) !=
+		    xfs_rtb_to_rgno(mp, right->br_startblock))
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Convert a delayed allocation to a real allocation.
  */
@@ -1495,7 +1514,8 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
+	    xfs_bmap_same_rtgroup(bma->ip, whichfork, &LEFT, new))
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1519,7 +1539,8 @@ xfs_bmap_add_extent_delay_real(
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= XFS_MAX_BMBT_EXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN) &&
+	    xfs_bmap_same_rtgroup(bma->ip, whichfork, new, &RIGHT))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2064,7 +2085,8 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, &LEFT, new))
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2088,7 +2110,8 @@ xfs_bmap_add_extent_unwritten_real(
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= XFS_MAX_BMBT_EXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN) &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, new, &RIGHT))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2597,7 +2620,8 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, &left, new))
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
@@ -2605,7 +2629,8 @@ xfs_bmap_add_extent_hole_delay(
 	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)) &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, new, &right))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2748,7 +2773,8 @@ xfs_bmap_add_extent_hole_real(
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
 	    left.br_startblock + left.br_blockcount == new->br_startblock &&
 	    left.br_state == new->br_state &&
-	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, &left, new))
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
@@ -2758,7 +2784,8 @@ xfs_bmap_add_extent_hole_real(
 	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     left.br_blockcount + new->br_blockcount +
-	     right.br_blockcount <= XFS_MAX_BMBT_EXTLEN))
+	     right.br_blockcount <= XFS_MAX_BMBT_EXTLEN) &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, new, &right))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -5767,6 +5794,8 @@ xfs_bunmapi(
  */
 STATIC bool
 xfs_bmse_can_merge(
+	struct xfs_inode	*ip,
+	int			whichfork,
 	struct xfs_bmbt_irec	*left,	/* preceding extent */
 	struct xfs_bmbt_irec	*got,	/* current extent to shift */
 	xfs_fileoff_t		shift)	/* shift fsb */
@@ -5782,7 +5811,8 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN) ||
+	    !xfs_bmap_same_rtgroup(ip, whichfork, left, got))
 		return false;
 
 	return true;
@@ -5818,7 +5848,7 @@ xfs_bmse_merge(
 	blockcount = left->br_blockcount + got->br_blockcount;
 
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-	ASSERT(xfs_bmse_can_merge(left, got, shift));
+	ASSERT(xfs_bmse_can_merge(ip, whichfork, left, got, shift));
 
 	new = *left;
 	new.br_blockcount = blockcount;
@@ -5980,7 +6010,8 @@ xfs_bmap_collapse_extents(
 			goto del_cursor;
 		}
 
-		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
+		if (xfs_bmse_can_merge(ip, whichfork, &prev, &got,
+				offset_shift_fsb)) {
 			error = xfs_bmse_merge(tp, ip, whichfork,
 					offset_shift_fsb, &icur, &got, &prev,
 					cur, &logflags);
@@ -6116,7 +6147,8 @@ xfs_bmap_insert_extents(
 		 * never find mergeable extents in this scenario.  Check anyways
 		 * and warn if we encounter two extents that could be one.
 		 */
-		if (xfs_bmse_can_merge(&got, &next, offset_shift_fsb))
+		if (xfs_bmse_can_merge(ip, whichfork, &got, &next,
+				offset_shift_fsb))
 			WARN_ON_ONCE(1);
 	}
 

