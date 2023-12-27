Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF1138B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="biegenIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE74C433C7;
	Mon,  1 Jan 2024 00:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067815;
	bh=qRYFiKy7ItnHSueIs8dGQR6lzI0wsxgysD1J2Z5BaEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=biegenIqpI9Pr91R4fL6JqG7WLGqouW4vxG5r+sA04qxiCbTiNCZOxzEwDyGRReYa
	 z/Ip7FgoWGeTgV5vhzfspfGuZiBCxf6R2qw7PvItcPzMmEy54I+NeQt4r0+rYRfvgs
	 utpxSFGwUM9ICw/5zqoH8YCbV7mx8Vpu66FniTur+KchzN+edOvC/ujpm2tDXZP/cN
	 onpZDp6ToJca4OOcz7qIpz9/dISS7Qj126A0a1sNXDsjnEpEIbKqxq7QIslQkFdAFS
	 soKHJRufQhTgLFkmp/njdhQM/s1lQMUQ1HYBQ1cyIlDkg6p1JCTGGPDiS2qn4XGGOc
	 gTwQ41sCYVzTg==
Date: Sun, 31 Dec 2023 16:10:15 +9900
Subject: [PATCH 8/9] xfs: simplify usage of the rcur local variable in
 xfs_rmap_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014922.1815232.16239681065099082707.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
References: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
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

Only update rcur when we know the final *pcur value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[djwong: don't leave the caller with a dangling ref]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   18 ++++++++++++++++++
 libxfs/xfs_rmap.c   |    6 ++----
 2 files changed, 20 insertions(+), 4 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index e7277b54532..d3df56f0a2b 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -28,6 +28,7 @@
 #include "xfs_ag.h"
 #include "xfs_swapext.h"
 #include "defer_item.h"
+#include "xfs_btree.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -370,6 +371,23 @@ xfs_rmap_update_abort_intent(
 {
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
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.name		= "rmap",
 	.create_intent	= xfs_rmap_update_create_intent,
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index a1a9f4927bd..183e840b7f1 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2560,7 +2560,7 @@ xfs_rmap_finish_one(
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur;
+	struct xfs_btree_cur		*rcur = *pcur;
 	struct xfs_buf			*agbp = NULL;
 	xfs_agblock_t			bno;
 	bool				unwritten;
@@ -2575,7 +2575,6 @@ xfs_rmap_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
@@ -2597,9 +2596,8 @@ xfs_rmap_finish_one(
 			return -EFSCORRUPTED;
 		}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+		*pcur = rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
 	}
-	*pcur = rcur;
 
 	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
 			ri->ri_bmap.br_startoff);

