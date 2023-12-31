Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F375BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMtJtYcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA61EC433C8;
	Sun, 31 Dec 2023 20:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054114;
	bh=rBZKdJ3c68rmJfoj5VWze/+nmVOxFGb5ke+qeqt2P6o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mMtJtYcmBdzFIb1br2ln9AloFhCIrFpcX51XZqdxFdHeXQdrrEKQh0W+KzJ/JlKzX
	 v3pcRyoGthA8UwIOoDubaSG/5s3HdXliZkYen4kBr50hzVVvrWild/MSVi2KFmFQ6F
	 AprlwLrnNMhqWovMDkJuz+qmyg1ZYb+s6wQxFCpI4MIcaQOy518fgSq9+Yi+I3T9T5
	 cKw6qDVsg6doAxcLU6xXbHJfNGFbNMRSEKCayA+eJJn4nD9CXkftN9eMUAiO3vF1Tc
	 N6dgxo59pS21sf74fNmvSad88Q42bBSAyG/ctfV3PEMGVlyVd/zmlcjeVoVYiThYcE
	 cBmj44fwuyRUA==
Date: Sun, 31 Dec 2023 12:21:54 -0800
Subject: [PATCH 6/7] xfs: move xfs_bmap_defer_add to xfs_bmap_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831519.1749708.10735905486343408951.stgit@frogsfrogsfrogs>
In-Reply-To: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move the code that adds the incore xfs_bmap_item deferred work data to a
transaction live with the BUI log item code.  This means that the file
mapping code no longer has to know about the inner workings of the BUI
log items.

As a consequence, we can hide the _get_group helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    6 ++----
 fs/xfs/libxfs/xfs_bmap.h |    3 ---
 fs/xfs/xfs_bmap_item.c   |   15 ++++++++++++++-
 fs/xfs/xfs_bmap_item.h   |    4 ++++
 4 files changed, 20 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0e506e83b4a62..3df6856cf4872 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_health.h"
+#include "xfs_bmap_item.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -6176,10 +6177,7 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
-	trace_xfs_bmap_defer(bi);
-
-	xfs_bmap_update_get_group(tp->t_mountp, bi);
-	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
+	xfs_bmap_defer_add(tp, bi);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b477f92c8508e..a5e37ef7b75d7 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -243,9 +243,6 @@ struct xfs_bmap_intent {
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
-void xfs_bmap_update_get_group(struct xfs_mount *mp,
-		struct xfs_bmap_intent *bi);
-
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 86c543282de73..3315a38f35973 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -25,6 +25,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
+#include "xfs_trace.h"
 
 struct kmem_cache	*xfs_bui_cache;
 struct kmem_cache	*xfs_bud_cache;
@@ -316,7 +317,7 @@ xfs_bmap_update_create_done(
 }
 
 /* Take a passive ref to the AG containing the space we're mapping. */
-void
+static inline void
 xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_bmap_intent	*bi)
@@ -335,6 +336,18 @@ xfs_bmap_update_get_group(
 	bi->bi_pag = xfs_perag_intent_get(mp, agno);
 }
 
+/* Add this deferred BUI to the transaction. */
+void
+xfs_bmap_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_bmap_intent	*bi)
+{
+	trace_xfs_bmap_defer(bi);
+
+	xfs_bmap_update_get_group(tp->t_mountp, bi);
+	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
+}
+
 /* Release a passive AG ref after finishing mapping work. */
 static inline void
 xfs_bmap_update_put_group(
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index 3fafd3881a0bb..6fee6a5083436 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -68,4 +68,8 @@ struct xfs_bud_log_item {
 extern struct kmem_cache	*xfs_bui_cache;
 extern struct kmem_cache	*xfs_bud_cache;
 
+struct xfs_bmap_intent;
+
+void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
+
 #endif	/* __XFS_BMAP_ITEM_H__ */

