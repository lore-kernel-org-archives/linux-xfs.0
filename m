Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6AFBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EyQ4KNvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C67C433C7;
	Sun, 31 Dec 2023 21:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058025;
	bh=i1QN7aF43H/9EcAB919vyrBARlvIICG5rOe97cW7rxY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EyQ4KNvUq9IjwHi8bBfEvsmJzOXl4/NgG4dSCzVtBQUA4z+w2DZ0Lb85cNnEZJxpH
	 T+eDVTW1/5ykD1gq93g2WYtt1oj8r7VPM/op1cY35hDk5moG8uEvFKyevM8iPRd+Dm
	 mey9ox+4LHL7GhwDWcpd3QoIyr2rK3WJMlX1SeUpU0CioweSz/6cvnE/H6TwVF2Qlo
	 8s/yQ8RjEYHjf44Omo7yqa0xtJDoDSwO0hLaJLJSz7kVyQ5nY+OBNKxLvGezjQHr41
	 yDo/lEwNREn1FbWU3gspmUfGO49pIztNT+lSqveGupIZy4PvfChKEc+ULfaNmEyXvx
	 mbusnoZOMm9cA==
Date: Sun, 31 Dec 2023 13:27:05 -0800
Subject: [PATCH 3/9] xfs: pass the fsbno to xfs_perag_intent_get
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404848385.1764329.9186246888293070127.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
References: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
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
index 234296a37b269..e50276ceceae9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -325,8 +325,6 @@ xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_bmap_intent	*bi)
 {
-	xfs_agnumber_t		agno;
-
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
 		if (xfs_has_rtgroups(mp)) {
 			xfs_rgnumber_t	rgno;
@@ -340,8 +338,6 @@ xfs_bmap_update_get_group(
 		return;
 	}
 
-	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
-
 	/*
 	 * Bump the intent count on behalf of the deferred rmap and refcount
 	 * intent items that that we can queue when we finish this bmap work.
@@ -349,7 +345,7 @@ xfs_bmap_update_get_group(
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
index 190d6a69e40b0..a29105583de96 100644
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
index 20ad8086da60b..ff1fdb759a8d2 100644
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
index 79ad0087aecaf..183544ac74c98 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -355,10 +355,7 @@ xfs_rmap_update_get_group(
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

