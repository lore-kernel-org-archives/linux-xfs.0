Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8257B440C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831817; cv=none; b=aa60GVsJEPN6m4gli9ZBSH0J/DKqhzcbBEifa2gxsqkYqrOyhwAuqV9qn+j6gpeUjmrYLAYB9j6fml1JgVkLpyR0ydXOV0+VEoY3uqXMGKhVwSnUrt7r1lcrRxDLnF77d384Qb6jKMChOuC8DjenUZrSKsC5fh1CcQ7C9C8Fr4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831817; c=relaxed/simple;
	bh=wChfyRlWjaUnPBHHGd+DrvIHE2BKkzsvYcW2KSxTQGM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PdDUMPTNoO+teNT2PAypCBXni3x1y+RNxcZfQw+cfMJsko00ksq3diSAhC7nhDjJBFmk1lPdMHdEW1vP2QGlShsT2qjvihbZtF9Rs4LSQ8u6WCB3sr2fuMjwjBkymLsW7pZkATAX5lJU/bZjABnPzMC6C1K7zoNH1W2o5OY5tt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gcCunsE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gcCunsE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3FFC4CEC6;
	Wed,  2 Oct 2024 01:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831817;
	bh=wChfyRlWjaUnPBHHGd+DrvIHE2BKkzsvYcW2KSxTQGM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gcCunsE3ghQfP+lD5uUGx1FyKfugmQ/P6rO9XbFev5/Oqm/XetmrrL9NXptz3xPFT
	 zrcvLwKqy6XBLXwKrJzc4Kp365Bzw+6PLk5mEtfe1s0vCZmyN0FiVVpkXosmNGFzR4
	 RUaSDWZEhd8pHMV3JkC/N0YQbbe3kkdS/rA5ntkWY1qZ06IPn9h9x83o42efQcgM4G
	 4eH109DdIYv6FVioL+txrXXeQIY+mH+NgyRAWYcBflSLFCcIVvooYJ7j8c8E6eW2/u
	 hjrny07cuHzPl2FBAABkLNNNUMFprD8pL2Nli7JGWS3EOdn497gpI7wKbjyFrwGClG
	 nOTfTsOsGPajQ==
Date: Tue, 01 Oct 2024 18:16:56 -0700
Subject: [PATCH 35/64] xfs: pass the fsbno to xfs_perag_intent_get
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102308.4036371.13809692517073671265.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 62d597a197e390a89eadff60b98231e91b32ab83

All callers of xfs_perag_intent_get have a fsbno and need boilerplate
code to turn that into an agno.  Just pass the fsbno to
xfs_perag_intent_get and look up the agno there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |    3 ++-
 libxfs/defer_item.c |   21 ++++-----------------
 2 files changed, 6 insertions(+), 18 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 4492a2f28..a60474a8d 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -298,7 +298,8 @@ struct xfs_defer_drain { /* empty */ };
 #define xfs_defer_drain_init(dr)		((void)0)
 #define xfs_defer_drain_free(dr)		((void)0)
 
-#define xfs_perag_intent_get(mp, agno)		xfs_perag_get((mp), (agno))
+#define xfs_perag_intent_get(mp, agno) \
+	xfs_perag_get((mp), XFS_FSB_TO_AGNO((mp), (agno)))
 #define xfs_perag_intent_put(pag)		xfs_perag_put(pag)
 
 static inline void xfs_perag_intent_hold(struct xfs_perag *pag) {}
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 77a368e6f..fb40a6625 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -79,10 +79,7 @@ xfs_extent_free_get_group(
 	struct xfs_mount		*mp,
 	struct xfs_extent_free_item	*xefi)
 {
-	xfs_agnumber_t			agno;
-
-	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
-	xefi->xefi_pag = xfs_perag_intent_get(mp, agno);
+	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
 }
 
 /* Release an active AG ref after some freeing work. */
@@ -256,10 +253,7 @@ xfs_rmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_rmap_intent	*ri)
 {
-	xfs_agnumber_t	agno;
-
-	agno = XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock);
-	ri->ri_pag = xfs_perag_intent_get(mp, agno);
+	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_bmap.br_startblock);
 }
 
 /* Release an active AG ref after finishing rmapping work. */
@@ -369,10 +363,7 @@ xfs_refcount_update_get_group(
 	struct xfs_mount		*mp,
 	struct xfs_refcount_intent	*ri)
 {
-	xfs_agnumber_t			agno;
-
-	agno = XFS_FSB_TO_AGNO(mp, ri->ri_startblock);
-	ri->ri_pag = xfs_perag_intent_get(mp, agno);
+	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_startblock);
 }
 
 /* Release an active AG ref after finishing refcounting work. */
@@ -490,13 +481,9 @@ xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_bmap_intent	*bi)
 {
-	xfs_agnumber_t		agno;
-
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
 		return;
 
-	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
-
 	/*
 	 * Bump the intent count on behalf of the deferred rmap and refcount
 	 * intent items that that we can queue when we finish this bmap work.
@@ -504,7 +491,7 @@ xfs_bmap_update_get_group(
 	 * intent drops the intent count, ensuring that the intent count
 	 * remains nonzero across the transaction roll.
 	 */
-	bi->bi_pag = xfs_perag_intent_get(mp, agno);
+	bi->bi_pag = xfs_perag_intent_get(mp, bi->bi_bmap.br_startblock);
 }
 
 /* Add this deferred BUI to the transaction. */

