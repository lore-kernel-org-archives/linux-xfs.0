Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A3FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiLaAPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiLaAPh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:15:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C62102E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:15:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F18961CF1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF5CC433D2;
        Sat, 31 Dec 2022 00:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445735;
        bh=V4XvCqA9MgxPXkKnPi3E5Crf2AXd3rvM+1hKo9mpFkE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g+TllQlGZK1kZGpGxnYB4EOkXxHhBp9c2bDnOsqXl98U0OQgQeHNtKmIq20xj2Xk1
         MshAYYRkTBZYGpNEx8DgO+awFpEPNPffYlp2U1gJinGURIOA1mQo0sDWLiIzRB03d7
         FvpfVcLfdyp4Jk9v7wCFWAmsvBRbxerHqMzyReXq7OX3VQSE+FVEJDWnk4C46twLrX
         KiptCPgp+kbK2d7V4xVcC2ujiKNS79rxzMNkMOhTG9Fj6QY1CfYteeZHkLfqQaVbuG
         DTFZasKKdNoL/OGlC/Z+vbNS9pJLXKc2xCQsp4iWQ61YH+bLNqt4ZDo0vf1KGFuKSo
         XsegsMmPs4bzQ==
Subject: [PATCH 3/6] xfs_repair: verify on-disk rmap btrees with in-memory
 btree data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:49 -0800
Message-ID: <167243866931.712584.16306225170690494673.stgit@magnolia>
In-Reply-To: <167243866890.712584.9795710743681868714.stgit@magnolia>
References: <167243866890.712584.9795710743681868714.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check the on-disk reverse mappings with the observations we've recorded
in the in-memory btree during the filesystem walk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/rmap.c |   58 +++++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index 64a5786faca..a8d973ecd2a 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1200,11 +1200,11 @@ rmaps_verify_btree(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
+	struct rmap_mem_cur	rm_cur;
+	struct xfs_rmap_irec	rm_rec;
 	struct xfs_rmap_irec	tmp;
-	struct xfs_slab_cursor	*rm_cur;
 	struct xfs_btree_cur	*bt_cur = NULL;
 	struct xfs_buf		*agbp = NULL;
-	struct xfs_rmap_irec	*rm_rec;
 	struct xfs_perag	*pag = NULL;
 	int			have;
 	int			error;
@@ -1217,8 +1217,8 @@ rmaps_verify_btree(
 		return;
 	}
 
-	/* Create cursors to refcount structures */
-	error = rmap_init_cursor(agno, &rm_cur);
+	/* Create cursors to rmap structures */
+	error = rmap_init_mem_cursor(mp, NULL, agno, &rm_cur);
 	if (error) {
 		do_warn(_("Not enough memory to check reverse mappings.\n"));
 		return;
@@ -1241,13 +1241,12 @@ rmaps_verify_btree(
 		goto err_agf;
 	}
 
-	rm_rec = pop_slab_cursor(rm_cur);
-	while (rm_rec) {
-		error = rmap_lookup(bt_cur, rm_rec, &tmp, &have);
+	while ((error = rmap_get_mem_rec(&rm_cur, &rm_rec)) == 1) {
+		error = rmap_lookup(bt_cur, &rm_rec, &tmp, &have);
 		if (error) {
 			do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
-					agno, rm_rec->rm_startblock);
+					agno, rm_rec.rm_startblock);
 			goto err_cur;
 		}
 
@@ -1257,13 +1256,13 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
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
@@ -1271,21 +1270,21 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
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
@@ -1299,20 +1298,17 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
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
@@ -1321,7 +1317,7 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 	libxfs_buf_relse(agbp);
 err_pag:
 	libxfs_perag_put(pag);
-	free_slab_cursor(&rm_cur);
+	rmap_free_mem_cursor(NULL, &rm_cur, error);
 }
 
 /*

