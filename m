Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3F6C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJKhHUYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06CEC433C7;
	Sun, 31 Dec 2023 23:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064844;
	bh=iFg5y5bJBv2Zu0qkjo8DB3chWZdmc9qW+a0QrfO/EpA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UJKhHUYi9JAD50zHHkeMgp9IhoHWIGGIIat5fw5jBuMB/YFHyfIEKEDL6hNsZZ/De
	 nUAoWMJNpCqNPsn3uJBNMlPsk4srQ6+o2jPGzkZbIt96uIfggibHU4ASGbiCGurNrH
	 Kbqmh97/MCJqog/GqK6/oZlHaSrAyYgc2TAJP7mVOxz5cnVpNRjXJqFnNYoUH3oB2f
	 mg1vmlKo336bx8cB8ouPE9iLgKCJWNC5ubkJlpoE6qdIXci6pdFBXk4ScrzOdlty6O
	 GrmWNmbhXNcE/nfJZTB5ZGQBuVG2+dpuCtSUdLSnFp8bdyHnRDn2Z0njTKTPXfWXS4
	 AYM16QcI1l/lg==
Date: Sun, 31 Dec 2023 15:20:44 -0800
Subject: [PATCH 04/10] xfs_scrub: split the scrub epilogue code into a
 separate function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007896.1806194.3798646198924879346.stgit@frogsfrogsfrogs>
In-Reply-To: <170405007836.1806194.11810681886556560484.stgit@frogsfrogsfrogs>
References: <170405007836.1806194.11810681886556560484.stgit@frogsfrogsfrogs>
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
---
 scrub/scrub.c |   52 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 14 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1b0609e7418..c4b4367e458 100644
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
 

