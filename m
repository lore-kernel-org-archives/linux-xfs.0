Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5992313FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991344; cv=none; b=YrCZVn6FgLa3TtYi7sBTDaU1+Wre0j8BYakq33PPxl2JA8y39PvMMYlY/9CQJl4bPlclp/RFzLq2URjb20Fm+mYyhT1YtgiO8UijJ1Sjyy3pOFd0wN0OvXUpPTqDbyupPYNmK/mAdqjwMGtJGq+oyRlM35nxAbHN9MQEkx5qi+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991344; c=relaxed/simple;
	bh=FjI7VdHnbkUZRX8sqIT9G5ySXOn8zeynbaZj7gXn+28=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQHNS4e+t5e2nRh4WE4e7pGiV88eb1+L5Zgt/8WYoo8PfR9++lZt22yBThBUHLvWsXiA/ze1cZRcmFQ6uxeVuI89oBb6EZwq4Vzc+qbSD/yBkop89hUoFXIiOY1wobf3l5TdsrwgSXapZ4muJlyCYw4cpSWkhCOBhLnb6vkD+zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IV4y7JXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IV4y7JXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DE4C4CED3;
	Mon, 23 Dec 2024 22:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991343;
	bh=FjI7VdHnbkUZRX8sqIT9G5ySXOn8zeynbaZj7gXn+28=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IV4y7JXLqQfhFgv5QGRrDS+1TljmpVs8OMYV1gRaWcBvrBXOLipPPNYU5QgxjbDhE
	 NglfVvKjSFtKoVwL00M8wtenuT4s19oHTXefvdwWYu7I1GSj9xMyqEffRmIJMu0o1B
	 QUOWxD4I/S2AJEAtKmQWk2ksBGJVRZqAs/o36KlzP2x8CfP33P6m9l3wNSir2LRI9C
	 lKNPVuOY1puzkSTAsJ5OSoauEjGGWQizaZ1Pg22jwU89mxj947U22A4V5WVj/IM6C2
	 wVOA0KVykJpY5wt8PX9fOZ4Rhka5uFl4Xsl5w9S4UkGGAi7efip+RHejroeOjfYcDK
	 8+zemKcq4/VtQ==
Date: Mon, 23 Dec 2024 14:02:23 -0800
Subject: [PATCH 16/52] xfs: add a helper to prevent bmap merges across rtgroup
 boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942739.2295836.9511256442104162701.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 8458c4944e10aa8119d9de88e257d60a3537263e

Except for the rt superblock, realtime groups do not store any metadata
at the start (or end) of the group.  There is nothing to prevent the
bmap code from merging allocations from multiple groups into a single
bmap record.  Add a helper to check for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: massage the commit message after pulling this into rtgroups]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |   56 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 48b05c40e23235..d7769f0e70005d 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -34,6 +34,7 @@
 #include "defer_item.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -1420,6 +1421,24 @@ xfs_bmap_last_offset(
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
@@ -1489,7 +1508,8 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
+	    xfs_bmap_same_rtgroup(bma->ip, whichfork, &LEFT, new))
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1513,7 +1533,8 @@ xfs_bmap_add_extent_delay_real(
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= XFS_MAX_BMBT_EXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN) &&
+	    xfs_bmap_same_rtgroup(bma->ip, whichfork, new, &RIGHT))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2058,7 +2079,8 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, &LEFT, new))
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2082,7 +2104,8 @@ xfs_bmap_add_extent_unwritten_real(
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= XFS_MAX_BMBT_EXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN) &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, new, &RIGHT))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2591,7 +2614,8 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, &left, new))
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
@@ -2599,7 +2623,8 @@ xfs_bmap_add_extent_hole_delay(
 	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)) &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, new, &right))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2742,7 +2767,8 @@ xfs_bmap_add_extent_hole_real(
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
 	    left.br_startblock + left.br_blockcount == new->br_startblock &&
 	    left.br_state == new->br_state &&
-	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, &left, new))
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
@@ -2752,7 +2778,8 @@ xfs_bmap_add_extent_hole_real(
 	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     left.br_blockcount + new->br_blockcount +
-	     right.br_blockcount <= XFS_MAX_BMBT_EXTLEN))
+	     right.br_blockcount <= XFS_MAX_BMBT_EXTLEN) &&
+	    xfs_bmap_same_rtgroup(ip, whichfork, new, &right))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -5709,6 +5736,8 @@ xfs_bunmapi(
  */
 STATIC bool
 xfs_bmse_can_merge(
+	struct xfs_inode	*ip,
+	int			whichfork,
 	struct xfs_bmbt_irec	*left,	/* preceding extent */
 	struct xfs_bmbt_irec	*got,	/* current extent to shift */
 	xfs_fileoff_t		shift)	/* shift fsb */
@@ -5724,7 +5753,8 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN) ||
+	    !xfs_bmap_same_rtgroup(ip, whichfork, left, got))
 		return false;
 
 	return true;
@@ -5760,7 +5790,7 @@ xfs_bmse_merge(
 	blockcount = left->br_blockcount + got->br_blockcount;
 
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-	ASSERT(xfs_bmse_can_merge(left, got, shift));
+	ASSERT(xfs_bmse_can_merge(ip, whichfork, left, got, shift));
 
 	new = *left;
 	new.br_blockcount = blockcount;
@@ -5922,7 +5952,8 @@ xfs_bmap_collapse_extents(
 			goto del_cursor;
 		}
 
-		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
+		if (xfs_bmse_can_merge(ip, whichfork, &prev, &got,
+				offset_shift_fsb)) {
 			error = xfs_bmse_merge(tp, ip, whichfork,
 					offset_shift_fsb, &icur, &got, &prev,
 					cur, &logflags);
@@ -6058,7 +6089,8 @@ xfs_bmap_insert_extents(
 		 * never find mergeable extents in this scenario.  Check anyways
 		 * and warn if we encounter two extents that could be one.
 		 */
-		if (xfs_bmse_can_merge(&got, &next, offset_shift_fsb))
+		if (xfs_bmse_can_merge(ip, whichfork, &got, &next,
+				offset_shift_fsb))
 			WARN_ON_ONCE(1);
 	}
 

