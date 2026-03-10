Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764173D47BD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146013; cv=none; b=dV2qTDUSmD+3lhml5G4zIoBheIBk6BbEFT9FOq7c7Ew5nhpEvhq2XJuuNKaelmFZjmYofZl5ItUJhHw1BJm4ATsqc84KWzWvNWvfTg2x4Tmu14MAKxkHLmdV7B6QEBou3PE+434pRXeTrDoviZ9EN97yyYbkPnMs/UuzlnheFCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146013; c=relaxed/simple;
	bh=MhW7nGpIIqc538zhMGvT22/tIXYgnlrerG5vgocZK2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDFwzohip/LTiZNqueg39T1P1y3AZEImqbJp9Q5KswyDw6F/SkQA604/ZLCI7djHOc2annYvjSW4PFhJ1HQmG1wWm4XYr9HKh28nz0ydRoe0zoIZBGysUGc+si2bcnQiQQlYqTe5qjswYQFWOguveWY9G8XhqEe2gZCM/EjyAFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=noNZMbNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noNZMbNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0512BC19423;
	Tue, 10 Mar 2026 12:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773146013;
	bh=MhW7nGpIIqc538zhMGvT22/tIXYgnlrerG5vgocZK2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noNZMbNY+jkovx5Ah0dvIlIS5b0VyvhysvL0S7zjRtktVqMPGzyC75vdIK6Lv9N2m
	 Co3nQu+UFgloCqjcDlcEdxKcXY2pXCGPE/qG0PXQnZK3fqp5yKrCOAmUc1dq3W1k+z
	 BB4oU8ZSliSDVuGHlEWGGwefy4fCdMO2AmdrMaEqwiAvBt8jNjqx2gWfBWwD/e3wGD
	 IWghrLNWuV7xvQXfV6yaU7yM9ApSinSwHPJLVcpMRbBX8PgRmwiB9hjRs/ZZEhbQuT
	 3HICKyEHhRkPs6BSzH5PoTUfoBdr+UNea6KKURdpAfsL2j4fB4MTa5bNZ41JjnEAD7
	 VPeWTCXiYoSmA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH 2/3] xfs: convert busy_extents list to a pointer within cil context
Date: Tue, 10 Mar 2026 13:33:15 +0100
Message-ID: <20260310123324.339310-3-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310123324.339310-1-cem@kernel.org>
References: <20260310123324.339310-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Decouple the busy extents list from the cil context.

By having the object independently allocated, we can transfer
its ownership to the discard code.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_discard.c  |  1 +
 fs/xfs/xfs_log_cil.c  | 17 ++++++++++-------
 fs/xfs/xfs_log_priv.h |  2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index f393be78dc46..2db0ea6eedc6 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -86,6 +86,7 @@ xfs_discard_endio_work(
 
 	xfs_extent_busy_clear(&extents->extent_list, false);
 	kfree(extents->owner);
+	xfs_busy_extents_free(extents);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index edc368938f30..bb71b5ad6b55 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -101,8 +101,8 @@ xlog_cil_ctx_alloc(void)
 	struct xfs_cil_ctx	*ctx;
 
 	ctx = kzalloc_obj(*ctx, GFP_KERNEL | __GFP_NOFAIL);
+	ctx->busy_extents = xfs_busy_extents_alloc(GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ctx->committing);
-	INIT_LIST_HEAD(&ctx->busy_extents.extent_list);
 	INIT_LIST_HEAD(&ctx->log_items);
 	INIT_LIST_HEAD(&ctx->lv_chain);
 	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
@@ -131,7 +131,7 @@ xlog_cil_push_pcp_aggregate(
 
 		if (!list_empty(&cilpcp->busy_extents)) {
 			list_splice_init(&cilpcp->busy_extents,
-					&ctx->busy_extents.extent_list);
+					&ctx->busy_extents->extent_list);
 		}
 		if (!list_empty(&cilpcp->log_items))
 			list_splice_init(&cilpcp->log_items, &ctx->log_items);
@@ -994,8 +994,8 @@ xlog_cil_committed(
 
 	xlog_cil_ail_insert(ctx, abort);
 
-	xfs_extent_busy_sort(&ctx->busy_extents.extent_list);
-	xfs_extent_busy_clear(&ctx->busy_extents.extent_list,
+	xfs_extent_busy_sort(&ctx->busy_extents->extent_list);
+	xfs_extent_busy_clear(&ctx->busy_extents->extent_list,
 			      xfs_has_discard(mp) && !abort);
 
 	spin_lock(&ctx->cil->xc_push_lock);
@@ -1004,12 +1004,13 @@ xlog_cil_committed(
 
 	xlog_cil_free_logvec(&ctx->lv_chain);
 
-	if (!list_empty(&ctx->busy_extents.extent_list)) {
-		ctx->busy_extents.owner = ctx;
-		xfs_discard_extents(mp, &ctx->busy_extents);
+	if (!list_empty(&ctx->busy_extents->extent_list)) {
+		ctx->busy_extents->owner = ctx;
+		xfs_discard_extents(mp, ctx->busy_extents);
 		return;
 	}
 
+	xfs_busy_extents_free(ctx->busy_extents);
 	kfree(ctx);
 }
 
@@ -1595,6 +1596,7 @@ xlog_cil_push_work(
 out_skip:
 	up_write(&cil->xc_ctx_lock);
 	xfs_log_ticket_put(new_ctx->ticket);
+	xfs_busy_extents_free(new_ctx->busy_extents);
 	kfree(new_ctx);
 	memalloc_nofs_restore(nofs_flags);
 	return;
@@ -2058,6 +2060,7 @@ xlog_cil_destroy(
 	if (cil->xc_ctx) {
 		if (cil->xc_ctx->ticket)
 			xfs_log_ticket_put(cil->xc_ctx->ticket);
+		xfs_busy_extents_free(cil->xc_ctx->busy_extents);
 		kfree(cil->xc_ctx);
 	}
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index cf1e4ce61a8c..b0f9923f30cc 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -240,7 +240,7 @@ struct xfs_cil_ctx {
 	struct xlog_in_core	*commit_iclog;
 	struct xlog_ticket	*ticket;	/* chkpt ticket */
 	atomic_t		space_used;	/* aggregate size of regions */
-	struct xfs_busy_extents	busy_extents;
+	struct xfs_busy_extents	*busy_extents;
 	struct list_head	log_items;	/* log items in chkpt */
 	struct list_head	lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
-- 
2.53.0

