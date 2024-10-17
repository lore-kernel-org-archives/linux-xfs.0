Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E728F21B43F
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191895; cv=none; b=pwP9ehwLhI9slcXKAnrQm4Ma3Qk9hS7t8l0+KDGkAFGqBT+rjLPwi1xKJrr2+RedWykhqODo10M1h/wp8m0+U4NnM3CV0gbs0/Cd5nGWRkUHgCMoKm4rPUkmZ8j9iefpMapKlsASwyRlLcJJOOYJuP/XibvU6QFe6xSyg2TchxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191895; c=relaxed/simple;
	bh=CGzLs+wLBxbCVotl/MPY8RAwxOm2ol+utwrM6SlqLYw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oYU9CCNx3gISfPtMLus1m+eGlreLiYFBULdzlVX0k5oFZrjrvrqrJHpIcTFtX3mFZfv4tdEC/I3nlLetb8TP2XhfWn3ZXf96RzzZ5hBKR3lTlbiItK8jH5uegUCWPYNVs1kj+q41daclblBVFttq3bQS9NX0+A+UvNcXiCVtxeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P9lLap8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P9lLap8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C320C4CEC3;
	Thu, 17 Oct 2024 19:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191894;
	bh=CGzLs+wLBxbCVotl/MPY8RAwxOm2ol+utwrM6SlqLYw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P9lLap8Q1rjPPeULEY8iGdH7XQzo14vmToo15oPf1eiM4Gj1dbuY/7bIYZg9KGwSn
	 DREhSdYngThWbjyKGUHZPzpv/pf66rUd/+UpG85UuWoof329zgOFgh+slxFP+oThhz
	 DGaY/hWR4pCKuZLqtM+vGijM1sHAhB9KDOuHTMLYuctgHfNbTTmEf3EoI3SekzxMqr
	 yiTQGCkosJFWJJSAJyAbUbkx9Rd/pj1ZjCvdoVzLlTeggjEcEhHVoQ0DXdV94LuHQS
	 DQiflwvBSEIbK87uecmFgJIDxI5wSLFbkHurLOUgumI5hG5/q4G+U3fUek08G50xhq
	 n6KYE1dvr5TMA==
Date: Thu, 17 Oct 2024 12:04:54 -0700
Subject: [PATCH 06/34] xfs: add a helper to prevent bmap merges across rtgroup
 boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071769.3453179.4018870121067601287.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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
index 9bfa8247854d41..482b4c0cd6b193 100644
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
@@ -5715,6 +5742,8 @@ xfs_bunmapi(
  */
 STATIC bool
 xfs_bmse_can_merge(
+	struct xfs_inode	*ip,
+	int			whichfork,
 	struct xfs_bmbt_irec	*left,	/* preceding extent */
 	struct xfs_bmbt_irec	*got,	/* current extent to shift */
 	xfs_fileoff_t		shift)	/* shift fsb */
@@ -5730,7 +5759,8 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN) ||
+	    !xfs_bmap_same_rtgroup(ip, whichfork, left, got))
 		return false;
 
 	return true;
@@ -5766,7 +5796,7 @@ xfs_bmse_merge(
 	blockcount = left->br_blockcount + got->br_blockcount;
 
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-	ASSERT(xfs_bmse_can_merge(left, got, shift));
+	ASSERT(xfs_bmse_can_merge(ip, whichfork, left, got, shift));
 
 	new = *left;
 	new.br_blockcount = blockcount;
@@ -5928,7 +5958,8 @@ xfs_bmap_collapse_extents(
 			goto del_cursor;
 		}
 
-		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
+		if (xfs_bmse_can_merge(ip, whichfork, &prev, &got,
+				offset_shift_fsb)) {
 			error = xfs_bmse_merge(tp, ip, whichfork,
 					offset_shift_fsb, &icur, &got, &prev,
 					cur, &logflags);
@@ -6064,7 +6095,8 @@ xfs_bmap_insert_extents(
 		 * never find mergeable extents in this scenario.  Check anyways
 		 * and warn if we encounter two extents that could be one.
 		 */
-		if (xfs_bmse_can_merge(&got, &next, offset_shift_fsb))
+		if (xfs_bmse_can_merge(ip, whichfork, &got, &next,
+				offset_shift_fsb))
 			WARN_ON_ONCE(1);
 	}
 

