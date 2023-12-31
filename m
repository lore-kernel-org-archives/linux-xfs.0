Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A642BC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9EfpqPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31098C433C8;
	Sun, 31 Dec 2023 22:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061139;
	bh=tBJIALgruj2WLu7Im/GQs9Yh0uHbEHBty/o6SY6FNzE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g9EfpqPQpvePjP6JATBVhScMLChqYcoSmu9e/Q2XaHtjm5+rRzX9hYYpeaAhj1L2z
	 YaqQ7B9QDq/vSc2eRcs7LwPNZ2BnNPosJRw37c70y7rRtTTAz3/R4kAYCYTwzvhz7x
	 jzIi/mq+KTZjv721q3a8JRibPvkh30UsV6zyabZMxSKeqk6m6Ukh01fy3XGIs4+ZgF
	 qEkxDVszGZXjqY5jHHy21Ap24GQSBnMlTtNm7To1szRr5xLAwwFkTO57zqP9dK32k4
	 VRQaCTHBSaK5uG2aFWJRbSfHrKtG4WQbPe5l0VuW0KnKu0eE6teTywJ7LOnHHWKPwB
	 CfZbhROJ+q1AA==
Date: Sun, 31 Dec 2023 14:18:58 -0800
Subject: [PATCH 3/6] xfs_repair: verify on-disk rmap btrees with in-memory
 btree data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404993628.1794934.1646668124205230327.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993583.1794934.17692508703738477619.stgit@frogsfrogsfrogs>
References: <170404993583.1794934.17692508703738477619.stgit@frogsfrogsfrogs>
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
---
 repair/rmap.c |   58 +++++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index 53b8ac6fcf9..785431b94d7 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1197,11 +1197,11 @@ rmaps_verify_btree(
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
@@ -1214,8 +1214,8 @@ rmaps_verify_btree(
 		return;
 	}
 
-	/* Create cursors to refcount structures */
-	error = rmap_init_cursor(agno, &rm_cur);
+	/* Create cursors to rmap structures */
+	error = rmap_init_mem_cursor(mp, NULL, agno, &rm_cur);
 	if (error) {
 		do_warn(_("Not enough memory to check reverse mappings.\n"));
 		return;
@@ -1238,13 +1238,12 @@ rmaps_verify_btree(
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
 
@@ -1254,13 +1253,13 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
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
@@ -1268,21 +1267,21 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
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
@@ -1296,20 +1295,17 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
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
@@ -1318,7 +1314,7 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 	libxfs_buf_relse(agbp);
 err_pag:
 	libxfs_perag_put(pag);
-	free_slab_cursor(&rm_cur);
+	rmap_free_mem_cursor(NULL, &rm_cur, error);
 }
 
 /*

