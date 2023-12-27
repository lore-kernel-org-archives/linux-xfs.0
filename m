Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CCB389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PgfLcGBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443E1C433C7;
	Mon,  1 Jan 2024 00:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067753;
	bh=GMAfoMqimiJscvoLR7CQenzGGKvZk40u/pbYj/MfZII=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PgfLcGBObOiW+oJkhiTlJGj8XMS3CkaCscHP5ftDsaomEa04/4nV7GFtBhSwW6IxJ
	 9scJ41SPZiM4M8l8ytHJ2vcxL4SB5/l6S1LbXgyyGD1mksuUDlc4vomnRV0yMRiJ+Q
	 1WqejpTnbs0BQXucEG38/5lzEB/aeVQ87gjBxR6ROb9QzNcWQucb22a2/jj3u0Sm6H
	 1GcTG/3K32gZusD2ro3QEmnLJ4h2didsnn13OpwlTaVzSyYaH+MCznDVCFMLEarjvm
	 OH9jCp1AThX/01OcMahy3PxMvqKgMpDvpB5UBav7YcTSK6XGDmZpraaki8+RqdWjSN
	 BlUYMGe7aApjg==
Date: Sun, 31 Dec 2023 16:09:12 +9900
Subject: [PATCH 4/9] xfs: clean up rmap log intent item tracepoint callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014871.1815232.17265076679281352849.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Pass the incore rmap structure to the tracepoints instead of open-coding
the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c |   22 +++++-----------------
 libxfs/xfs_rmap.h |   10 ++++++++++
 2 files changed, 15 insertions(+), 17 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 3c4f705ce59..3c00b05d8d0 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2575,20 +2575,15 @@ xfs_rmap_finish_one(
 	struct xfs_rmap_intent		*ri,
 	struct xfs_btree_cur		**pcur)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
-	int				error = 0;
-	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			bno;
 	bool				unwritten;
+	int				error = 0;
 
-	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock);
-
-	trace_xfs_rmap_deferred(mp, ri->ri_pag->pag_agno, ri->ri_type, bno,
-			ri->ri_owner, ri->ri_whichfork,
-			ri->ri_bmap.br_startoff, ri->ri_bmap.br_blockcount,
-			ri->ri_bmap.br_state);
+	trace_xfs_rmap_deferred(mp, ri);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
 		return -EIO;
@@ -2663,15 +2658,6 @@ __xfs_rmap_add(
 {
 	struct xfs_rmap_intent		*ri;
 
-	trace_xfs_rmap_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			owner, whichfork,
-			bmap->br_startoff,
-			bmap->br_blockcount,
-			bmap->br_state);
-
 	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
@@ -2679,6 +2665,8 @@ __xfs_rmap_add(
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
 
+	trace_xfs_rmap_defer(tp->t_mountp, ri);
+
 	xfs_rmap_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 3a153b4801b..f16b07d851d 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -157,6 +157,16 @@ enum xfs_rmap_intent_type {
 	XFS_RMAP_FREE,
 };
 
+#define XFS_RMAP_INTENT_STRINGS \
+	{ XFS_RMAP_MAP,			"map" }, \
+	{ XFS_RMAP_MAP_SHARED,		"map_shared" }, \
+	{ XFS_RMAP_UNMAP,		"unmap" }, \
+	{ XFS_RMAP_UNMAP_SHARED,	"unmap_shared" }, \
+	{ XFS_RMAP_CONVERT,		"cvt" }, \
+	{ XFS_RMAP_CONVERT_SHARED,	"cvt_shared" }, \
+	{ XFS_RMAP_ALLOC,		"alloc" }, \
+	{ XFS_RMAP_FREE,		"free" }
+
 struct xfs_rmap_intent {
 	struct list_head			ri_list;
 	enum xfs_rmap_intent_type		ri_type;

