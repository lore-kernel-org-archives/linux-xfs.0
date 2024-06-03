Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5449137C3B
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442727; cv=none; b=YiiTiGqKXNnOU45FM1BXt2IihUvlhfDFoRo+EO/0C82GC/hPRgQb4iYDWifI0//F4Cqf4u3zTyO/8KCchq7hho+z0mmpYEEc498kEpzyVJ3hqKirXdBH7HwokBoNyioMmDs9JR7umPxmtZHE3k0ya6QTrrxXKDNDRC3qmBzqy/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442727; c=relaxed/simple;
	bh=XhBPMVZ7P+Qiupt1HUMuzugCf8OfWlCaAwy0ex3gBaM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gko3wG/O40zkDj4acmje4dSOfWlYtlIjYYLmOdTlz9m+dQUa/5mTX5NASU5fzouZc1PD8o5BZQ6ij1gHrLQwkpG6Yay9URualdiack9TVOwxN5zd9ITyQF+V0nUG1wdUB+BY83uBczH7WQ+xAk/6f3qKhpQ/ZMUJR8NGPIjap/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhgumnc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhgumnc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446CCC2BD10;
	Mon,  3 Jun 2024 19:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442727;
	bh=XhBPMVZ7P+Qiupt1HUMuzugCf8OfWlCaAwy0ex3gBaM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nhgumnc3WmXxQMYDx9moxeKY/bbWD9NcZ1uXCiTEtrBwvbX8NQXJpLJbxU2qdEnkL
	 L8eIqU4N/fZJUmaOq2LEhGPZm3VWs/vsAAZG0hiEoOjOmUEcHNktnuvxYZ0HG6jusX
	 Okxa9NFOyZf031YeYjjL5yLrlKs0KELxXxtW7LHbH+Uv276DiGS5Z/pEejj6OBh8gH
	 Y1I7ca7C6fW43dXZXwVWhO7EwSJRO6OPp80FegkYQnAjcg85eVnA949YNgvHW+15dC
	 UgBeelyIFuBd716Qfo8P2WQJ7iADaT6dHDJvWqI44coOD2VsHHO3Hm0I0tAPQ2Vdyb
	 eki1CC/0LVqLA==
Date: Mon, 03 Jun 2024 12:25:26 -0700
Subject: [PATCH 3/6] xfs_repair: verify on-disk rmap btrees with in-memory
 btree data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744043116.1450153.11936246325825862556.stgit@frogsfrogsfrogs>
In-Reply-To: <171744043069.1450153.1345347577840777304.stgit@frogsfrogsfrogs>
References: <171744043069.1450153.1345347577840777304.stgit@frogsfrogsfrogs>
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

Check the on-disk reverse mappings with the observations we've recorded
in the in-memory btree during the filesystem walk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/rmap.c |   58 +++++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index c1ae7da1e..69f134ed0 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1190,11 +1190,11 @@ rmaps_verify_btree(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
+	struct xfs_btree_cur	*rm_cur;
+	struct xfs_rmap_irec	rm_rec;
 	struct xfs_rmap_irec	tmp;
-	struct xfs_slab_cursor	*rm_cur;
 	struct xfs_btree_cur	*bt_cur = NULL;
 	struct xfs_buf		*agbp = NULL;
-	struct xfs_rmap_irec	*rm_rec;
 	struct xfs_perag	*pag = NULL;
 	int			have;
 	int			error;
@@ -1207,8 +1207,8 @@ rmaps_verify_btree(
 		return;
 	}
 
-	/* Create cursors to refcount structures */
-	error = rmap_init_cursor(agno, &rm_cur);
+	/* Create cursors to rmap structures */
+	error = rmap_init_mem_cursor(mp, NULL, agno, &rm_cur);
 	if (error) {
 		do_warn(_("Not enough memory to check reverse mappings.\n"));
 		return;
@@ -1231,13 +1231,12 @@ rmaps_verify_btree(
 		goto err_agf;
 	}
 
-	rm_rec = pop_slab_cursor(rm_cur);
-	while (rm_rec) {
-		error = rmap_lookup(bt_cur, rm_rec, &tmp, &have);
+	while ((error = rmap_get_mem_rec(rm_cur, &rm_rec)) == 1) {
+		error = rmap_lookup(bt_cur, &rm_rec, &tmp, &have);
 		if (error) {
 			do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
-					agno, rm_rec->rm_startblock);
+					agno, rm_rec.rm_startblock);
 			goto err_cur;
 		}
 
@@ -1247,13 +1246,13 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
 		 * match the observed rmap.
 		 */
 		if (xfs_has_reflink(bt_cur->bc_mp) &&
-				(!have || !rmap_is_good(rm_rec, &tmp))) {
-			error = rmap_lookup_overlapped(bt_cur, rm_rec,
+				(!have || !rmap_is_good(&rm_rec, &tmp))) {
+			error = rmap_lookup_overlapped(bt_cur, &rm_rec,
 					&tmp, &have);
 			if (error) {
 				do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
-						agno, rm_rec->rm_startblock);
+						agno, rm_rec.rm_startblock);
 				goto err_cur;
 			}
 		}
@@ -1261,21 +1260,21 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
 			do_warn(
 _("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \
 %s%soff %"PRIu64"\n"),
-				agno, rm_rec->rm_startblock,
-				(rm_rec->rm_flags & XFS_RMAP_UNWRITTEN) ?
+				agno, rm_rec.rm_startblock,
+				(rm_rec.rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
-				rm_rec->rm_blockcount,
-				rm_rec->rm_owner,
-				(rm_rec->rm_flags & XFS_RMAP_ATTR_FORK) ?
+				rm_rec.rm_blockcount,
+				rm_rec.rm_owner,
+				(rm_rec.rm_flags & XFS_RMAP_ATTR_FORK) ?
 					_("attr ") : "",
-				(rm_rec->rm_flags & XFS_RMAP_BMBT_BLOCK) ?
+				(rm_rec.rm_flags & XFS_RMAP_BMBT_BLOCK) ?
 					_("bmbt ") : "",
-				rm_rec->rm_offset);
-			goto next_loop;
+				rm_rec.rm_offset);
+			continue;
 		}
 
 		/* Compare each refcount observation against the btree's */
-		if (!rmap_is_good(rm_rec, &tmp)) {
+		if (!rmap_is_good(&rm_rec, &tmp)) {
 			do_warn(
 _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 %"PRIu64"; should be (%u/%u) %slen %u owner %"PRId64" %s%soff %"PRIu64"\n"),
@@ -1289,20 +1288,17 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 				(tmp.rm_flags & XFS_RMAP_BMBT_BLOCK) ?
 					_("bmbt ") : "",
 				tmp.rm_offset,
-				agno, rm_rec->rm_startblock,
-				(rm_rec->rm_flags & XFS_RMAP_UNWRITTEN) ?
+				agno, rm_rec.rm_startblock,
+				(rm_rec.rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
-				rm_rec->rm_blockcount,
-				rm_rec->rm_owner,
-				(rm_rec->rm_flags & XFS_RMAP_ATTR_FORK) ?
+				rm_rec.rm_blockcount,
+				rm_rec.rm_owner,
+				(rm_rec.rm_flags & XFS_RMAP_ATTR_FORK) ?
 					_("attr ") : "",
-				(rm_rec->rm_flags & XFS_RMAP_BMBT_BLOCK) ?
+				(rm_rec.rm_flags & XFS_RMAP_BMBT_BLOCK) ?
 					_("bmbt ") : "",
-				rm_rec->rm_offset);
-			goto next_loop;
+				rm_rec.rm_offset);
 		}
-next_loop:
-		rm_rec = pop_slab_cursor(rm_cur);
 	}
 
 err_cur:
@@ -1311,7 +1307,7 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 	libxfs_buf_relse(agbp);
 err_pag:
 	libxfs_perag_put(pag);
-	free_slab_cursor(&rm_cur);
+	libxfs_btree_del_cursor(rm_cur, error);
 }
 
 /*

