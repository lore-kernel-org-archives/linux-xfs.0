Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B4582D83
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924930; cv=none; b=dl1trWlU7KJswwYstqu7o69swUiq8A+KSqA6qkPS3eZSy+iaf1uwq1IofvI6ji9K/iYlRMumW13nRZi2NcHz7o3wYpbbiM6faT3NN/y9s4rDr+PPgLIXWa3trmIXvjuDSzCivu0tHLEglVcteEEvk67wyw7vtl8VJ2dWBGt9Bq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924930; c=relaxed/simple;
	bh=a+Rzvu6l/J6Bh46pqRv0uIVxt8ZLTpCT2DmmdO3gcBA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ljADuzFpokvCAwJOnuASfSXZIZy+EAGbwTYvof45jOU/NtTOQGlK+ignV06MiA5oRQxvi5MWfMVVS8nYWk1B4DeMIfOzjQbbrhBAiusnPtF8pNzZ0AnegpfKOTx1nwL7xNgIcNgyMYJamL2YM5pAuhJo9Hf6KfWk/mAKMqobwwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/LWKOE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/LWKOE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389D5C2BD10;
	Thu, 20 Jun 2024 23:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924930;
	bh=a+Rzvu6l/J6Bh46pqRv0uIVxt8ZLTpCT2DmmdO3gcBA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V/LWKOE+DQgUDGRYI9U7j9MWsMubnTnTGhds6ENHC7yLHlGx31KmgQ3T0b3FhHzqs
	 O9KE56Xx65hkngdv7BLo7EdYy6o/50TqFcPUgpLAHmbrjEtCiyQnDjB1aa+OCOdhpK
	 QLoepa2KddiaRuFZipR3QoQrmcc3aLZ/WI6aVvOYLAWNobSx1xgczrFbceM6uOSGW+
	 SGgsZrAEeaywkBuSzoRrLMrE52FfialZbH4eKwUndbZkFsMC1IBF9hle3MCfHifMOd
	 zaeDsl9r8mUEd9N9flwirH7cYExh0CKFjgB/Z8suV6NjswFuX12SWURPxSGIneqYB2
	 CvkqkTd8/jDSw==
Date: Thu, 20 Jun 2024 16:08:49 -0700
Subject: [PATCH 7/9] xfs: don't bother calling xfs_rmap_finish_one_cleanup in
 xfs_rmap_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419352.3184396.2508476480535872538.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
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

In xfs_rmap_finish_one we known the cursor is non-zero when calling
xfs_rmap_finish_one_cleanup and we pass a 0 error variable.  This means
xfs_rmap_finish_one_cleanup is just doing a xfs_btree_del_cursor.

Open code that and move xfs_rmap_finish_one_cleanup to
fs/xfs/xfs_rmap_item.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor porting changes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   19 +------------------
 fs/xfs/libxfs/xfs_rmap.h |    2 --
 fs/xfs/xfs_rmap_item.c   |   18 ++++++++++++++++++
 3 files changed, 19 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 637a4b1db9b98..0ee97f1698e9d 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2523,23 +2523,6 @@ xfs_rmap_query_all(
 	return xfs_btree_query_all(cur, xfs_rmap_query_range_helper, &query);
 }
 
-/* Clean up after calling xfs_rmap_finish_one. */
-void
-xfs_rmap_finish_one_cleanup(
-	struct xfs_trans	*tp,
-	struct xfs_btree_cur	*rcur,
-	int			error)
-{
-	struct xfs_buf		*agbp;
-
-	if (rcur == NULL)
-		return;
-	agbp = rcur->bc_ag.agbp;
-	xfs_btree_del_cursor(rcur, error);
-	if (error)
-		xfs_trans_brelse(tp, agbp);
-}
-
 /* Commit an rmap operation into the ondisk tree. */
 int
 __xfs_rmap_finish_intent(
@@ -2604,7 +2587,7 @@ xfs_rmap_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
-		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
+		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
 	}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 731c97137b5a0..9d85dd2a6553c 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -192,8 +192,6 @@ void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
 void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
 		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
 
-void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
-		struct xfs_btree_cur *rcur, int error);
 int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_rmap_intent *ri,
 		struct xfs_btree_cur **pcur);
 int __xfs_rmap_finish_intent(struct xfs_btree_cur *rcur,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 68e4ce0dbd727..44a9b77c17639 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -21,6 +21,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
+#include "xfs_btree.h"
 
 struct kmem_cache	*xfs_rui_cache;
 struct kmem_cache	*xfs_rud_cache;
@@ -386,6 +387,23 @@ xfs_rmap_update_finish_item(
 	return error;
 }
 
+/* Clean up after calling xfs_rmap_finish_one. */
+STATIC void
+xfs_rmap_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	struct xfs_buf		*agbp = NULL;
+
+	if (rcur == NULL)
+		return;
+	agbp = rcur->bc_ag.agbp;
+	xfs_btree_del_cursor(rcur, error);
+	if (error && agbp)
+		xfs_trans_brelse(tp, agbp);
+}
+
 /* Abort all pending RUIs. */
 STATIC void
 xfs_rmap_update_abort_intent(

