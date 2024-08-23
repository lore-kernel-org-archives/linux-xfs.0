Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EC41CD00
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372565; cv=none; b=c/kB4zqSTWET59pVYR8z6ZNXXIWu6MraAhEL2XTy7NxP7OqCDLHfKnyGSWnQUDjujRfQ3Ds1RAyFPyQAFKMDIHPBiBLCA9UUBs0VCjlIJp8nAfEGsmB2m8WYqpneTPkyFWIDxutJ/O0tmXRwgHR0UFZHtTdsa8ML+7MPWQxl/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372565; c=relaxed/simple;
	bh=vVdYHEhp1+MQnI8Nn3HxO9xViZ8yiv0XGLe6p2oPTNc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rkcq9jXfypjlsp6ICzZZcYPmE1hkyqGMN/twOz2nIagreeXGLmNb4fR6Kppv9kfCXg4qpGGdm5fYDrJaQHLBMqcb7X2sK9kq3XqmMQYL7wR2lJCqIvmfXDM2CHw5ij5avz9tdw3ocS4hHLeaNPQgqn2WD6xvgFS/zzgJecAvAF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gkb+v38G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gkb+v38G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F697C4AF0B;
	Fri, 23 Aug 2024 00:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372564;
	bh=vVdYHEhp1+MQnI8Nn3HxO9xViZ8yiv0XGLe6p2oPTNc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gkb+v38G8mGggF3DjIJzyvKBqSd0TyFbFd6SVwFzIDCArd/7sYyUkU8/Jt/NP33Cg
	 htXnRm+8UREAh+1cQrNgwvWRJN5aQPTPXU/ib2TthDa92LIrg7RqZVdDXq+wlAB2s2
	 YiExPor4AL9becg62+/XSYYWkn5hl3dzZ9tAm0Q1N+ljnWTwDt30fLCniyQ9wMvYcK
	 LBcdJU4OiRTU8GMnQz5Oa4BRD7BtbBcSnl6IvCoJjmAMxF7tZhhUDI7wdQlOFFBMvM
	 R6HjkI2S36kEfq9+NFOt+bRCkj42W9EbKSsaPSKj4VHYAOv00wXmlwNRhnZ5hTm/HM
	 mYuTFESALBaQQ==
Date: Thu, 22 Aug 2024 17:22:44 -0700
Subject: [PATCH 06/26] xfs: add a helper to prevent bmap merges across rtgroup
 boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088622.60592.12740637056884834042.stgit@frogsfrogsfrogs>
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
index c056ca8ad6090..f1bf8635a8cf3 100644
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
@@ -5766,6 +5793,8 @@ xfs_bunmapi(
  */
 STATIC bool
 xfs_bmse_can_merge(
+	struct xfs_inode	*ip,
+	int			whichfork,
 	struct xfs_bmbt_irec	*left,	/* preceding extent */
 	struct xfs_bmbt_irec	*got,	/* current extent to shift */
 	xfs_fileoff_t		shift)	/* shift fsb */
@@ -5781,7 +5810,8 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN) ||
+	    !xfs_bmap_same_rtgroup(ip, whichfork, left, got))
 		return false;
 
 	return true;
@@ -5817,7 +5847,7 @@ xfs_bmse_merge(
 	blockcount = left->br_blockcount + got->br_blockcount;
 
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-	ASSERT(xfs_bmse_can_merge(left, got, shift));
+	ASSERT(xfs_bmse_can_merge(ip, whichfork, left, got, shift));
 
 	new = *left;
 	new.br_blockcount = blockcount;
@@ -5979,7 +6009,8 @@ xfs_bmap_collapse_extents(
 			goto del_cursor;
 		}
 
-		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
+		if (xfs_bmse_can_merge(ip, whichfork, &prev, &got,
+				offset_shift_fsb)) {
 			error = xfs_bmse_merge(tp, ip, whichfork,
 					offset_shift_fsb, &icur, &got, &prev,
 					cur, &logflags);
@@ -6115,7 +6146,8 @@ xfs_bmap_insert_extents(
 		 * never find mergeable extents in this scenario.  Check anyways
 		 * and warn if we encounter two extents that could be one.
 		 */
-		if (xfs_bmse_can_merge(&got, &next, offset_shift_fsb))
+		if (xfs_bmse_can_merge(ip, whichfork, &got, &next,
+				offset_shift_fsb))
 			WARN_ON_ONCE(1);
 	}
 

