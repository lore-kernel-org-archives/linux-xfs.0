Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFA71D86E4
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190975; cv=none; b=vCjxv4bFCpVwMjgku+gPyLI4FYtM9XwAYmpfLhxMNF+mP0H9zZd9LkH+hcPPkC306XO+mgNGG1lLbekpBq/Nv8E9qCK911mcHEsWfMGSNmrNRvf6OzmmydjkJYQPOCugkl7AxSMrRITSNNopOhyQAdtdH9EIg28TuesjUjMCuCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190975; c=relaxed/simple;
	bh=sNydzTANHNQSl6G87FPHe0ErqUCrWLtQjC3Ejbo3cIU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGTRxmAfkB9dgbaf0NHxOxeDpBDbxvaJkxp260tkR8+Lbz7CgqZXoi3K23QkyeztLlpnPvKLaXiWfJWtoJWddnTxrCCwl+/I/ajaY2SVjN/kfdDwFbKxNrnPKN/XR15Au0EXhEfMhnWtc+a1Uun8NwPvI/oCs6YanrRDrXw9dBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQMamVLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQMamVLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D47C4CEC3;
	Thu, 17 Oct 2024 18:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190975;
	bh=sNydzTANHNQSl6G87FPHe0ErqUCrWLtQjC3Ejbo3cIU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uQMamVLPYdu5VMSf+kcY9rG9HKCcYZnM/oAqhih0peYZ8mw9R2DW/HslOw4KTu5x3
	 +GF1RUClAAYRWQ/WP3ryptP1PTWOqKp6vGdYpcKZyB3tABobjw65JYgYbcNysp6Nwl
	 jtTANxmT1FV+EwKxkCaGDWz4+gC3ykXBJiAtPRMf+mKzHisXQUDu/VoU5bgg9W/IGr
	 m7v4WOvFou+2/Bo0E+HylUHldZ+VnMbWgf3KUsicgWoQifo4Vowkwz371xfHqbHqgg
	 xSeRFSXGiu3fduuzgJqRFgVs9x0N+SLYgvrV4sf8q2ePfcnsua0Y9kKWluxpkKUPPh
	 9u+0uNR/uzlAA==
Date: Thu, 17 Oct 2024 11:49:34 -0700
Subject: [PATCH 10/22] xfs: remove the mount field from struct
 xfs_busy_extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068033.3449971.12469029926816236610.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The mount field is only passed to xfs_extent_busy_clear, which never uses
it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c     |    5 ++---
 fs/xfs/xfs_extent_busy.c |    1 -
 fs/xfs/xfs_extent_busy.h |    4 +---
 fs/xfs/xfs_log_cil.c     |    3 +--
 fs/xfs/xfs_trans.c       |    2 +-
 5 files changed, 5 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 5c00904e439305..e1b4a8c59d0cc8 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -81,7 +81,7 @@ xfs_discard_endio_work(
 	struct xfs_busy_extents	*extents =
 		container_of(work, struct xfs_busy_extents, endio_work);
 
-	xfs_extent_busy_clear(extents->mount, &extents->extent_list, false);
+	xfs_extent_busy_clear(&extents->extent_list, false);
 	kfree(extents->owner);
 }
 
@@ -301,7 +301,7 @@ xfs_trim_gather_extents(
 	 * we aren't going to issue a discard on them any more.
 	 */
 	if (error)
-		xfs_extent_busy_clear(mp, &extents->extent_list, false);
+		xfs_extent_busy_clear(&extents->extent_list, false);
 out_del_cursor:
 	xfs_btree_del_cursor(cur, error);
 out_trans_cancel:
@@ -347,7 +347,6 @@ xfs_trim_perag_extents(
 			break;
 		}
 
-		extents->mount = pag->pag_mount;
 		extents->owner = extents;
 		INIT_LIST_HEAD(&extents->extent_list);
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 7c0595db29857f..7353f9844684b0 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -545,7 +545,6 @@ xfs_extent_busy_clear_one(
  */
 void
 xfs_extent_busy_clear(
-	struct xfs_mount	*mp,
 	struct list_head	*list,
 	bool			do_discard)
 {
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 72be61912c005f..7241035ce4ef9d 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -33,7 +33,6 @@ struct xfs_extent_busy {
  * to discard completion.
  */
 struct xfs_busy_extents {
-	struct xfs_mount	*mount;
 	struct list_head	extent_list;
 	struct work_struct	endio_work;
 
@@ -54,8 +53,7 @@ xfs_extent_busy_insert_discard(struct xfs_perag *pag, xfs_agblock_t bno,
 	xfs_extlen_t len, struct list_head *busy_list);
 
 void
-xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
-	bool do_discard);
+xfs_extent_busy_clear(struct list_head *list, bool do_discard);
 
 int
 xfs_extent_busy_search(struct xfs_perag *pag, xfs_agblock_t bno,
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 80da0cf87d7a45..2e9157b650e647 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -907,7 +907,7 @@ xlog_cil_committed(
 	xlog_cil_ail_insert(ctx, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents.extent_list);
-	xfs_extent_busy_clear(mp, &ctx->busy_extents.extent_list,
+	xfs_extent_busy_clear(&ctx->busy_extents.extent_list,
 			      xfs_has_discard(mp) && !abort);
 
 	spin_lock(&ctx->cil->xc_push_lock);
@@ -917,7 +917,6 @@ xlog_cil_committed(
 	xlog_cil_free_logvec(&ctx->lv_chain);
 
 	if (!list_empty(&ctx->busy_extents.extent_list)) {
-		ctx->busy_extents.mount = mp;
 		ctx->busy_extents.owner = ctx;
 		xfs_discard_extents(mp, &ctx->busy_extents);
 		return;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bdf3704dc30118..cee7f0564409bd 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -67,7 +67,7 @@ xfs_trans_free(
 	struct xfs_trans	*tp)
 {
 	xfs_extent_busy_sort(&tp->t_busy);
-	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
+	xfs_extent_busy_clear(&tp->t_busy, false);
 
 	trace_xfs_trans_free(tp, _RET_IP_);
 	xfs_trans_clear_context(tp);

