Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D447C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924727; cv=none; b=YirnVd00z0awP5oN52F4udqwvhWyp41qGukazF17ek557PDZKk1cuQ70GZk/5dzIFtDvVGc8rxl/ENijIeBp/omTVgrs75cu+rmKGOtkA3woGH4ywiW7CjywqL2CDQ4P32yr3Y9+ijmEZBW+iqPLdQdHoLF9kcYB+9jayCZSbmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924727; c=relaxed/simple;
	bh=HciaT8xwQApKcWbvAuOc+DEO4HubAYzSb9ltBveoNII=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D1xAqn4HR8I3uLVyhPA4cBQY/V8uB1qo2oVutg2NgHXPbnNMmTqu4vgWNgDQFCMVjT4Zxn1EWl/zgOk+VHh5Wm4wQsOF/2WPRlVHmIR4r2qy1QkdKKT4O9gDceEajffHiBrhbwEK33v9pWsafH5KCEnrKPG+NykKgNRjvVG3rto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+dNKLTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+dNKLTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E826FC2BD10;
	Thu, 20 Jun 2024 23:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924727;
	bh=HciaT8xwQApKcWbvAuOc+DEO4HubAYzSb9ltBveoNII=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b+dNKLTL0M8eVhBYvRf1eXa7Lg6+mRdNELEV4yWAinGc0FjI7kjZNalE/AanSWcjk
	 4pppXjXgOSPEll/cNpHqti5JT9FmZ99malMlaZA1L6F6fOZQphiWrES4/O1u/oa+U1
	 U3lDQxmCxgn5f47jof4/ZGtRcMAOz9Ey47m4r4uHzcKgkBttkwUpstj2+mWzluB5QM
	 Wt8UFVGZwpdTpERxvoF7yzsCTyQnrA5PwAD7AiY3+XnnKb15+QHoKXJAPg9A8D15Jo
	 ZOO5vQj727wl9vbevFyyFd/4eSWDx/p2FuzI8F/+jgAL1b8uxKv7sU/gKg6mqq2iSD
	 wtLjP8bHCabQA==
Date: Thu, 20 Jun 2024 16:05:26 -0700
Subject: [PATCH 3/9] xfs: pass the fsbno to xfs_perag_intent_get
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418749.3183906.963532464357317175.stgit@frogsfrogsfrogs>
In-Reply-To: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_bmap_item.c     |    6 +-----
 fs/xfs/xfs_drain.c         |    8 ++++----
 fs/xfs/xfs_drain.h         |    5 +++--
 fs/xfs/xfs_extfree_item.c  |    5 +----
 fs/xfs/xfs_refcount_item.c |    5 +----
 fs/xfs/xfs_rmap_item.c     |    5 +----
 6 files changed, 11 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index a19d62e78aa1e..e224b49b7cff6 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -324,13 +324,9 @@ xfs_bmap_update_get_group(
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
@@ -338,7 +334,7 @@ xfs_bmap_update_get_group(
 	 * intent drops the intent count, ensuring that the intent count
 	 * remains nonzero across the transaction roll.
 	 */
-	bi->bi_pag = xfs_perag_intent_get(mp, agno);
+	bi->bi_pag = xfs_perag_intent_get(mp, bi->bi_bmap.br_startblock);
 }
 
 /* Add this deferred BUI to the transaction. */
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index 005a66be44a25..7bdb9688c0f5e 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -94,17 +94,17 @@ static inline int xfs_defer_drain_wait(struct xfs_defer_drain *dr)
 }
 
 /*
- * Get a passive reference to an AG and declare an intent to update its
- * metadata.
+ * Get a passive reference to the AG that contains a fsbno and declare an intent
+ * to update its metadata.
  */
 struct xfs_perag *
 xfs_perag_intent_get(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
+	xfs_fsblock_t		fsbno)
 {
 	struct xfs_perag	*pag;
 
-	pag = xfs_perag_get(mp, agno);
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsbno));
 	if (!pag)
 		return NULL;
 
diff --git a/fs/xfs/xfs_drain.h b/fs/xfs/xfs_drain.h
index 50a5772a8296c..775164f54ea6d 100644
--- a/fs/xfs/xfs_drain.h
+++ b/fs/xfs/xfs_drain.h
@@ -62,7 +62,7 @@ void xfs_drain_wait_enable(void);
  * until the item is finished or cancelled.
  */
 struct xfs_perag *xfs_perag_intent_get(struct xfs_mount *mp,
-		xfs_agnumber_t agno);
+		xfs_fsblock_t fsbno);
 void xfs_perag_intent_put(struct xfs_perag *pag);
 
 void xfs_perag_intent_hold(struct xfs_perag *pag);
@@ -76,7 +76,8 @@ struct xfs_defer_drain { /* empty */ };
 #define xfs_defer_drain_free(dr)		((void)0)
 #define xfs_defer_drain_init(dr)		((void)0)
 
-#define xfs_perag_intent_get(mp, agno)		xfs_perag_get((mp), (agno))
+#define xfs_perag_intent_get(mp, fsbno) \
+	xfs_perag_get((mp), XFS_FSB_TO_AGNO(mp, fsbno))
 #define xfs_perag_intent_put(pag)		xfs_perag_put(pag)
 
 static inline void xfs_perag_intent_hold(struct xfs_perag *pag) { }
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 5d5628903e16f..349d78b3f38aa 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -424,10 +424,7 @@ xfs_extent_free_get_group(
 	struct xfs_mount		*mp,
 	struct xfs_extent_free_item	*xefi)
 {
-	xfs_agnumber_t			agno;
-
-	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
-	xefi->xefi_pag = xfs_perag_intent_get(mp, agno);
+	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
 }
 
 /* Release a passive AG ref after some freeing work. */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 14919b33e4fe2..78e106d05aa20 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -330,10 +330,7 @@ xfs_refcount_update_get_group(
 	struct xfs_mount		*mp,
 	struct xfs_refcount_intent	*ri)
 {
-	xfs_agnumber_t			agno;
-
-	agno = XFS_FSB_TO_AGNO(mp, ri->ri_startblock);
-	ri->ri_pag = xfs_perag_intent_get(mp, agno);
+	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_startblock);
 }
 
 /* Release a passive AG ref after finishing refcounting work. */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e473124e29ccb..2e732aded58e0 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -356,10 +356,7 @@ xfs_rmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_rmap_intent	*ri)
 {
-	xfs_agnumber_t		agno;
-
-	agno = XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock);
-	ri->ri_pag = xfs_perag_intent_get(mp, agno);
+	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_bmap.br_startblock);
 }
 
 /* Release a passive AG ref after finishing rmapping work. */

