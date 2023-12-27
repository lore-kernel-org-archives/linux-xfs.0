Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E2A7EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFGWtbIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72114C433C8;
	Mon,  1 Jan 2024 00:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067565;
	bh=WdeOYutHpocxZ3+2K255r7uBzY1RuvPVQZtAObaNC3A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BFGWtbIFOcJCUrnvvvBI0xMoo+1MvIIHzJR6P69lZOM+eZvGluwedaFGEVKpxnGc4
	 kQeDjeVJWbj17DYpmAZyODFXnKWkpx5vCRhnx9syhaBjHHAQD1ROuk+L1vXf+S2uXn
	 hrVSNQe1rYxFA0+/mn706KQUZMiT94NVvrPqBkulTNKmLdPLN0GFdp2UAPS64xYbu8
	 0ohJPo2t4e3BpGZtMIk+1ZdW+ZAjpoJD6BIkCSPUrP/Uq/F+8vVL/gJx6BK2o+s8nw
	 hVGPNzpyRPSpcTFgSS41+B+WQhXtBrdCIcvzKJt2Zap+BsEzM8iGeKM6yZ/ek5HgOh
	 qfNnye+m5LZgw==
Date: Sun, 31 Dec 2023 16:06:04 +9900
Subject: [PATCH 3/8] xfs: pass the fsbno to xfs_perag_intent_get
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014082.1814860.11583323401594538966.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
References: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
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
index 51a02e69776..1284e848835 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -317,7 +317,8 @@ struct xfs_defer_drain { /* empty */ };
 #define xfs_defer_drain_init(dr)		((void)0)
 #define xfs_defer_drain_free(dr)		((void)0)
 
-#define xfs_perag_intent_get(mp, agno)		xfs_perag_get((mp), (agno))
+#define xfs_perag_intent_get(mp, agno) \
+	xfs_perag_get((mp), XFS_FSB_TO_AGNO((mp), (agno)))
 #define xfs_perag_intent_put(pag)		xfs_perag_put(pag)
 
 static inline void xfs_perag_intent_hold(struct xfs_perag *pag) {}
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index fbd035d9b94..2958dcb85e5 100644
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
@@ -490,8 +481,6 @@ xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_bmap_intent	*bi)
 {
-	xfs_agnumber_t		agno;
-
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
 		if (xfs_has_rtgroups(mp)) {
 			xfs_rgnumber_t	rgno;
@@ -505,8 +494,6 @@ xfs_bmap_update_get_group(
 		return;
 	}
 
-	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
-
 	/*
 	 * Bump the intent count on behalf of the deferred rmap and refcount
 	 * intent items that that we can queue when we finish this bmap work.
@@ -514,7 +501,7 @@ xfs_bmap_update_get_group(
 	 * intent drops the intent count, ensuring that the intent count
 	 * remains nonzero across the transaction roll.
 	 */
-	bi->bi_pag = xfs_perag_intent_get(mp, agno);
+	bi->bi_pag = xfs_perag_intent_get(mp, bi->bi_bmap.br_startblock);
 }
 
 /* Add this deferred BUI to the transaction. */

