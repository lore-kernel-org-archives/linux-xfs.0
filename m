Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A323D47C4
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146014; cv=none; b=JyjJz7niFkv8azZwkQUeDJjRNJwt3jj45ueMCoaKAy82zrWIXtizPwJ9QMOYARIlSMwetAxqRtNXzaOlr36GVLWKOwZnFx1vY7vlGL7liEJZWPDOT7LBfCITMXGCvBDR+8xMC90xWElX8HGgWNNHrTjCXqVQC6XCwb0X+QDtZBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146014; c=relaxed/simple;
	bh=86HuWIyZQGKpYCIdvXT/EO5IR7VkTwBG2hvXGT+Eo8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF/EaRJGf7UONAg61+LEYA+FbvBnmw/S3G7NHLYNr8Tqdnu1uR7pRhvbTJXuNTRL18cJrnoX7/J0ePDPDX/289z12zpF1W84fzRDnpxqZ2OYQXInoa/4RoFthfo1hOpKjKBCmLrVcahjTrateSMLXWR8nmec3fCHOr7lih9EldM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmOgArPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmOgArPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F2EC19423;
	Tue, 10 Mar 2026 12:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773146014;
	bh=86HuWIyZQGKpYCIdvXT/EO5IR7VkTwBG2hvXGT+Eo8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmOgArPeWPfVedp3Y5s/AYuQHyy3TSVjsU8uM6H0nnUdyX1eZEZ4me4uc4d+kJpLR
	 5wpLbzlUYX9y/8C0clSraaNDszg0dycZlaAh3hCVtiio7Cqkaysldf0XP8HFxwDKpp
	 /sbS5XkHnmW4KiX+vL9x2J++IHueRnw4qUIVU7XS5sR8ZqEAWzvLfbwc5UkFlVuF6O
	 L67HkdTpxfCEysCyEAukvEgr2pXvdjSfgefXLIF0GXISY4LhkPSeKLEs+prki6l0uv
	 mnJZjChPMwKxboHSvFoYtgaURigODbpdj8ufOh0xNCGMKQiiAx9Hn1zfHQ5cF1hYx+
	 7mRrkuj1nMlYw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH 3/3] xfs: remove owner field from xfs_extent_busy
Date: Tue, 10 Mar 2026 13:33:16 +0100
Message-ID: <20260310123324.339310-4-cem@kernel.org>
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

Now that xfs_busy_extents is not embedded into a cil context, we can
get rid of the owner field.

The struct will be freed upon a call to xfs_discard_extents(), whether
at IO completion or by direct calling xfs_discard_endio_work().

What reamains is xlog_cil_commited now being responsible for freeing
the context itself.

Worth mentioning that the busy extents still need to be manually freed
during filesystem shutdown via xlog_cil_destroy() if there is a
remaining context there.

Also, xlog_cil_committed() now unconditionally calls xfs_discard_extents.
This seems safe because it can handle an empty list, and as a bonus,
it will call xfs_discard_endio_work() for such case, without any extra
wiring needed to free the busy extents list in case it is empty.
xfs_discard_endio_work() is also able to properly handle the empty list.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_discard.c     |  4 ----
 fs/xfs/xfs_extent_busy.h |  7 -------
 fs/xfs/xfs_log_cil.c     | 13 ++++---------
 3 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 2db0ea6eedc6..be4bc16dc85c 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -85,7 +85,6 @@ xfs_discard_endio_work(
 		container_of(work, struct xfs_busy_extents, endio_work);
 
 	xfs_extent_busy_clear(&extents->extent_list, false);
-	kfree(extents->owner);
 	xfs_busy_extents_free(extents);
 }
 
@@ -356,8 +355,6 @@ xfs_trim_perag_extents(
 			break;
 		}
 
-		extents->owner = extents;
-
 		error = xfs_trim_gather_extents(pag, &tcur, extents);
 		if (error) {
 			xfs_busy_extents_free(extents);
@@ -697,7 +694,6 @@ xfs_trim_rtgroup_extents(
 
 		tr.queued = 0;
 		tr.batch = XFS_DISCARD_MAX_EXAMINE;
-		tr.extents->owner = tr.extents;
 
 		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
 		error = xfs_rtalloc_query_range(rtg, tp, low, high,
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 699f97a53530..5deaa1fbe378 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -34,13 +34,6 @@ struct xfs_extent_busy {
 struct xfs_busy_extents {
 	struct list_head	extent_list;
 	struct work_struct	endio_work;
-
-	/*
-	 * Owner is the object containing the struct xfs_busy_extents to free
-	 * once the busy extents have been processed. If only the
-	 * xfs_busy_extents object needs freeing, then point this at itself.
-	 */
-	void			*owner;
 };
 
 static inline struct xfs_busy_extents *
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index bb71b5ad6b55..befc2691f053 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -976,6 +976,7 @@ xlog_cil_committed(
 	struct xfs_cil_ctx	*ctx)
 {
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
+	struct xfs_busy_extents	*busy_extents = ctx->busy_extents;
 	bool			abort = xlog_is_shutdown(ctx->cil->xc_log);
 
 	/*
@@ -994,8 +995,8 @@ xlog_cil_committed(
 
 	xlog_cil_ail_insert(ctx, abort);
 
-	xfs_extent_busy_sort(&ctx->busy_extents->extent_list);
-	xfs_extent_busy_clear(&ctx->busy_extents->extent_list,
+	xfs_extent_busy_sort(&busy_extents->extent_list);
+	xfs_extent_busy_clear(&busy_extents->extent_list,
 			      xfs_has_discard(mp) && !abort);
 
 	spin_lock(&ctx->cil->xc_push_lock);
@@ -1004,13 +1005,7 @@ xlog_cil_committed(
 
 	xlog_cil_free_logvec(&ctx->lv_chain);
 
-	if (!list_empty(&ctx->busy_extents->extent_list)) {
-		ctx->busy_extents->owner = ctx;
-		xfs_discard_extents(mp, ctx->busy_extents);
-		return;
-	}
-
-	xfs_busy_extents_free(ctx->busy_extents);
+	xfs_discard_extents(mp, busy_extents);
 	kfree(ctx);
 }
 
-- 
2.53.0

