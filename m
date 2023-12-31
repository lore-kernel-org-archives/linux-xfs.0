Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A604BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLmXnavh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760C8C433C7;
	Sun, 31 Dec 2023 21:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058276;
	bh=iQlosUe3B2IRApZAs3jvS3YzHKFgX7R2KySFzOwZElY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BLmXnavhG0YRz+KreXbzJGaCWKUF+vwvRxAkhhExN4oaqoG+rCCj9KjaEzF3juEHt
	 ACG6Z9x6kxXSncYggYoRvyyFYd+MlNiVRwY6BrOgegRru3pEKDqo4pF/TojsRulKqM
	 DB0gO7xxhUY2dd7DZvx7vMp8+GNeYafaE4xs4frvSe+3rKSaNqUx7eenlH8waAgrKz
	 NWQyfr3hkWJcGkPjoGVLwYDR/WcoprxCZF0Iq/ujVh/OWs5h5q88RGazR9dVua0xZ7
	 CKbvRJZXu1Z8TaUo1nnuTYK3O6aZqlNmIJDsqtnvmdKYoakx3ZjptxG0KqfuMuBMOb
	 7v384S7r7D5yw==
Date: Sun, 31 Dec 2023 13:31:16 -0800
Subject: [PATCH 08/10] xfs: don't bother calling xfs_rmap_finish_one_cleanup
 in xfs_rmap_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404849362.1764703.7318567844489507131.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
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
index 628f337a8eee1..ba33e51a3f2b8 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2514,23 +2514,6 @@ xfs_rmap_query_all(
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
@@ -2595,7 +2578,7 @@ xfs_rmap_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
-		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
+		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
 	}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index f16b07d851d32..2513ee36aa29d 100644
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
index 9ce11e27cb9fd..d13fe835f0313 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -21,6 +21,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
+#include "xfs_btree.h"
 
 struct kmem_cache	*xfs_rui_cache;
 struct kmem_cache	*xfs_rud_cache;
@@ -385,6 +386,23 @@ xfs_rmap_update_finish_item(
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

