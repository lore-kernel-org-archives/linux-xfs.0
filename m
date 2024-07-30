Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A08A23
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303067; cv=none; b=ttlb4hbRe1gcmi5GW7OFjkE07CVaqySfIrUGFnt0njgGzRYfDXqSruYfI/m+8RJiWlFdr7Xx3nFampZlqAPpKVRyx8LfATMMyT176XFxe1etgTR3499NfWDlv6wqtrmRbFPjx6pCLvkCjd3DtBNsOHq5zopOpjzrkCA1CO1KVoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303067; c=relaxed/simple;
	bh=WyZaDkk03G+e0/4crnNDnf5T10NvJwNOHG0mzv9pLZM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jIV+vwX6OBXAQ5NYg1E4FQ0HhQDtR+h+VQD7bS+POoaI/ursuPbAOueEmdfbmteIje369R4+QK37OiICWeRxPeHltKnZMEZIFKzqjqHOkd0CUcWeEGsbJs3bDYKZwdVx77gEbXUuuCTjwkbLMmutJBZa/bHvBSpxt5YTp8VqK4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPZN+3r8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPZN+3r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DFEC32786;
	Tue, 30 Jul 2024 01:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722303067;
	bh=WyZaDkk03G+e0/4crnNDnf5T10NvJwNOHG0mzv9pLZM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VPZN+3r8sK254cxPf28rFkkPBR3z1QbYoynuXVUyWWJMf1EZvZ8WfLnjMFzqqkkoX
	 weQZjPBaoupn+TTVDFNX27xv5rCGBiXI2R3mKhjo7bJHxl4Yz6OMVo2/WgVRr8Efph
	 kF2p5gQmGclvKjRJBc00GxXfY7Qz8kP8HqMDJN69wp4t+NS9kSui9DbcQLs7deS8fB
	 rqvBv5DAGQvZ0DLZErSfKrUolHB1TKM8F875IMNHBd7avE3Um8el4audA2fTYJOGcX
	 uXoAp+rcEYlRB1NsE1KYiW+swlu17KNSVnPhxC2CVMLSW8MugeyDZ1y9C7wClzIKED
	 Yui4D1tlkBaqQ==
Date: Mon, 29 Jul 2024 18:31:06 -0700
Subject: [PATCH 04/10] xfs_scrub: split the scrub epilogue code into a
 separate function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852411.1353240.3386877096069644914.stgit@frogsfrogsfrogs>
In-Reply-To: <172229852355.1353240.6151017907178495656.stgit@frogsfrogsfrogs>
References: <172229852355.1353240.6151017907178495656.stgit@frogsfrogsfrogs>
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

Move all the code that updates the internal state in response to a scrub
ioctl() call completion into a separate function.  This will help with
vectorizing scrub calls later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/scrub.c |   52 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 14 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1b0609e74..c4b4367e4 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -22,6 +22,10 @@
 #include "descr.h"
 #include "scrub_private.h"
 
+static int scrub_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
+		struct scrub_item *sri, struct xfs_scrub_metadata *meta,
+		int error);
+
 /* Online scrub and repair wrappers. */
 
 /* Format a scrub description. */
@@ -117,12 +121,32 @@ xfs_check_metadata(
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
 
 	error = -xfrog_scrub_metadata(xfdp, &meta);
+	return scrub_epilogue(ctx, &dsc, sri, &meta, error);
+}
+
+/*
+ * Update all internal state after a scrub ioctl call.
+ * Returns 0 for success, or ECANCELED to abort the program.
+ */
+static int
+scrub_epilogue(
+	struct scrub_ctx		*ctx,
+	struct descr			*dsc,
+	struct scrub_item		*sri,
+	struct xfs_scrub_metadata	*meta,
+	int				error)
+{
+	unsigned int			scrub_type = meta->sm_type;
+	enum xfrog_scrub_group		group;
+
+	group = xfrog_scrubbers[scrub_type].group;
+
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
 		if (!sri->sri_revalidate &&
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-			meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+			meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
@@ -130,13 +154,13 @@ xfs_check_metadata(
 		return 0;
 	case ESHUTDOWN:
 		/* FS already crashed, give up. */
-		str_error(ctx, descr_render(&dsc),
+		str_error(ctx, descr_render(dsc),
 _("Filesystem is shut down, aborting."));
 		return ECANCELED;
 	case EIO:
 	case ENOMEM:
 		/* Abort on I/O errors or insufficient memory. */
-		str_liberror(ctx, error, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(dsc));
 		return ECANCELED;
 	case EDEADLOCK:
 	case EBUSY:
@@ -152,7 +176,7 @@ _("Filesystem is shut down, aborting."));
 		return 0;
 	default:
 		/* Operational error.  Log it and move on. */
-		str_liberror(ctx, error, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(dsc));
 		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	}
@@ -163,27 +187,27 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+	if (want_retry(meta) && scrub_item_schedule_retry(sri, scrub_type))
 		return 0;
 
 	/* Complain about incomplete or suspicious metadata. */
-	scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
+	scrub_warn_incomplete_scrub(ctx, dsc, meta);
 
 	/*
 	 * If we need repairs or there were discrepancies, schedule a
 	 * repair if desired, otherwise complain.
 	 */
-	if (is_corrupt(&meta) || xref_disagrees(&meta)) {
+	if (is_corrupt(meta) || xref_disagrees(meta)) {
 		if (ctx->mode != SCRUB_MODE_REPAIR) {
 			/* Dry-run mode, so log an error and forget it. */
-			str_corrupt(ctx, descr_render(&dsc),
+			str_corrupt(ctx, descr_render(dsc),
 _("Repairs are required."));
 			scrub_item_clean_state(sri, scrub_type);
 			return 0;
 		}
 
 		/* Schedule repairs. */
-		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
 		return 0;
 	}
 
@@ -191,12 +215,12 @@ _("Repairs are required."));
 	 * If we could optimize, schedule a repair if desired,
 	 * otherwise complain.
 	 */
-	if (is_unoptimized(&meta)) {
+	if (is_unoptimized(meta)) {
 		if (ctx->mode == SCRUB_MODE_DRY_RUN) {
 			/* Dry-run mode, so log an error and forget it. */
 			if (group != XFROG_SCRUB_GROUP_INODE) {
 				/* AG or FS metadata, always warn. */
-				str_info(ctx, descr_render(&dsc),
+				str_info(ctx, descr_render(dsc),
 _("Optimization is possible."));
 			} else if (!ctx->preen_triggers[scrub_type]) {
 				/* File metadata, only warn once per type. */
@@ -210,7 +234,7 @@ _("Optimization is possible."));
 		}
 
 		/* Schedule optimizations. */
-		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
 		return 0;
 	}
 
@@ -221,8 +245,8 @@ _("Optimization is possible."));
 	 * re-examine the object as repairs progress to see if the kernel will
 	 * deem it completely consistent at some point.
 	 */
-	if (xref_failed(&meta) && ctx->mode == SCRUB_MODE_REPAIR) {
-		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
+	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR) {
+		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
 		return 0;
 	}
 

