Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9E6282E5
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348115; cv=none; b=AsrvU+HWTFBMKstEz9bX52U3neIUIhf+l2LG2sceV4oMrmMRljyi1r9l5HDkD+MdT2eFn/taF+utcwpgFxn9yIfXwik/kWIcXBfHWwNX++SMWiiPdKm71WZZnWP1TCVugmAMl9R6fKgkQ9K0mOv/8zTzIO7EOnZE/PIc8UW1CQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348115; c=relaxed/simple;
	bh=XhBPMVZ7P+Qiupt1HUMuzugCf8OfWlCaAwy0ex3gBaM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QkFOeWURGAuDtiI06u3gIjOPtrBMvCboWhs6oA79ffxCAZK+whZKj9Svw4NaD+y/WIiiKL86cUZOtQDE5x3LJRZ5D/Gs1IiGKQjEUesk/kb+WnLeE3yFY0ec71YFQVW1yG7BZbSS2Uzv95QpdBKGeR5Hz3/Ynf5SatGTZaOODgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcfYEEf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcfYEEf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7F9C2BD11;
	Wed, 22 May 2024 03:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716348114;
	bh=XhBPMVZ7P+Qiupt1HUMuzugCf8OfWlCaAwy0ex3gBaM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UcfYEEf4QT1XFjIXMkyoVmZFyHrWqGnADRJnhuuw75rJ6ul5VnbsAQMKHj4Ma6Gou
	 ELy1r4FeLz8kQbV7PVTu02nKARc9lBPra6be7lJ2t1kzcHTT+BBQndSZijxKqpHXOt
	 8A/ajcD5E5CigZVXHrHTgYpvmLLFxCTRkmhqg5yr/9lz/vzmrjf4U1H7pcA+e2aeHj
	 cU9rdUZA5cdYocdzjcIGFt1POqyYly450x/UzoJmeAaNQPNrnHmDbkY+1qAoFVBEnI
	 fWK3+sGSSlIh4saswXIYoi5o+pc4LaQhw1IejtctTgHHbii/OvR97pIeXdUjoEZeKA
	 RQ1yTAC/6GIsQ==
Date: Tue, 21 May 2024 20:21:54 -0700
Subject: [PATCH 3/6] xfs_repair: verify on-disk rmap btrees with in-memory
 btree data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634535433.2483278.6294467241938212956.stgit@frogsfrogsfrogs>
In-Reply-To: <171634535383.2483278.14868148193055852399.stgit@frogsfrogsfrogs>
References: <171634535383.2483278.14868148193055852399.stgit@frogsfrogsfrogs>
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

