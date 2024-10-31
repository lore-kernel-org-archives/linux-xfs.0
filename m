Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E91D0DE6
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416732; cv=none; b=B12iESuxT7IhttKJ0o3WgxAh/O7NdjpmsEtC9IYnK4IxiMAHNZcgaxw9IwR5nfavrAbxfKR5YKl2zxYBBvoNZUnXD9nz0dGswfI1Abxc9lcXwOYISJv04uViFYYRoSZBqq7rOarZaPHYd8fMPQrYfO17n3UKgcL2wJ4FJbIrt8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416732; c=relaxed/simple;
	bh=6NroAplWALLEeAyjg48XYUwcYT3J15sjccejh+39Mt4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nFz0aeUEskCI9yXvGkP/+Vxt80OPEQWSx9uH6QgX2Ut69CJiC0pP0VYFUTerkBGFHQH+OQqFuKafbT+4x4OdVYrXY/eQDakF48WsnexdLF3ogMNdkGAQTEWwV0cLp97Rg4dmfytvfeCdFURTB3gMzuBQkprRuYDuzxNHEOYRZdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rst7vR67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rst7vR67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBC4C4CEC3;
	Thu, 31 Oct 2024 23:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416732;
	bh=6NroAplWALLEeAyjg48XYUwcYT3J15sjccejh+39Mt4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rst7vR67Kly+/6Ahn3iMTwFL3olX+//VcBBgD7tgnDomo6lXtoJfYyg7lxPPiCLfm
	 R+DotPF+tQqmHV18xLrx1+zkFz+eecGHrIusHQ0Q/nieGZw/BZyU0eihYKPHNOz3O5
	 rKRYa1uobhIguu5AywsbBFWbsfiWrTVH5RZ+tVk5XWRy1L9H6O7g0YRc2+aXzHntE+
	 xL3CDEZXUzksXANWlyQqL26/HS+lmCHtMXmIQb2HI9nF+BBEr34msddQK90WA3uKNv
	 sEIgTif57Vn0EnxGuZTLYD+aRN3yNh/IO1E3ZRsgSJtVnFHLGh/ojEvx9uxOi0N4LE
	 OMLb1kjLB7OeA==
Date: Thu, 31 Oct 2024 16:18:51 -0700
Subject: [PATCH 39/41] xfs: merge the perag freeing helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566512.962545.11813970395122379028.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: aa67ec6a25617e36eba4fb28a88159f500a6cac6

There is no good reason to have two different routines for freeing perag
structures for the unmount and error cases.  Add two arguments to specify
the range of AGs to free to xfs_free_perag, and use that to replace
xfs_free_unused_perag_range.

The addition RCU grace period for the error case is harmless, and the
extra check for the AG to actually exist is not required now that the
callers pass the exact known allocated range.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/init.c            |    6 +++---
 libxfs/libxfs_api_defs.h |    2 +-
 libxfs/xfs_ag.c          |   40 ++++++++++------------------------------
 libxfs/xfs_ag.h          |    5 ++---
 4 files changed, 16 insertions(+), 37 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 733ab3f1abc557..483cd99546052f 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -789,8 +789,8 @@ libxfs_mount(
 			libxfs_buf_relse(bp);
 	}
 
-	error = libxfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
-			&mp->m_maxagi);
+	error = libxfs_initialize_perag(mp, 0, sbp->sb_agcount,
+			sbp->sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		fprintf(stderr, _("%s: perag init failed\n"),
 			progname);
@@ -930,7 +930,7 @@ libxfs_umount(
 	 * first place.
 	 */
 	if (xfs_is_perag_data_loaded(mp))
-		libxfs_free_perag(mp);
+		libxfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
 
 	xfs_da_unmount(mp);
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a4173e5f7a595c..b9986a00681c1e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -166,7 +166,7 @@
 #define xfs_finobt_init_cursor		libxfs_finobt_init_cursor
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_free_extent_later		libxfs_free_extent_later
-#define xfs_free_perag			libxfs_free_perag
+#define xfs_free_perag_range		libxfs_free_perag_range
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_get_initial_prid		libxfs_get_initial_prid
 #define xfs_highbit32			libxfs_highbit32
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 3bbfefe5e46935..a9993215bf9a30 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -183,17 +183,20 @@ xfs_initialize_perag_data(
 }
 
 /*
- * Free up the per-ag resources associated with the mount structure.
+ * Free up the per-ag resources  within the specified AG range.
  */
 void
-xfs_free_perag(
-	struct xfs_mount	*mp)
+xfs_free_perag_range(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		first_agno,
+	xfs_agnumber_t		end_agno)
+
 {
-	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		pag = xa_erase(&mp->m_perags, agno);
+	for (agno = first_agno; agno < end_agno; agno++) {
+		struct xfs_perag	*pag = xa_erase(&mp->m_perags, agno);
+
 		ASSERT(pag);
 		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
@@ -268,29 +271,6 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
-/*
- * Free perag within the specified AG range, it is only used to free unused
- * perags under the error handling path.
- */
-void
-xfs_free_unused_perag_range(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agstart,
-	xfs_agnumber_t		agend)
-{
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		index;
-
-	for (index = agstart; index < agend; index++) {
-		pag = xa_erase(&mp->m_perags, index);
-		if (!pag)
-			break;
-		xfs_buf_cache_destroy(&pag->pag_bcache);
-		xfs_defer_drain_free(&pag->pag_intents_drain);
-		kfree(pag);
-	}
-}
-
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
@@ -364,7 +344,7 @@ xfs_initialize_perag(
 out_free_pag:
 	kfree(pag);
 out_unwind_new_pags:
-	xfs_free_unused_perag_range(mp, old_agcount, index);
+	xfs_free_perag_range(mp, old_agcount, index);
 	return error;
 }
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 69fc31e7b84728..6e68d6a3161a0f 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -144,13 +144,12 @@ __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
 __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
 __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
 
-void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
-			xfs_agnumber_t agend);
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
 		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
 		xfs_agnumber_t *maxagi);
+void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
+		xfs_agnumber_t end_agno);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
-void xfs_free_perag(struct xfs_mount *mp);
 
 /* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);

