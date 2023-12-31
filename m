Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D61C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frquTU1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79134C433C8;
	Sun, 31 Dec 2023 23:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064860;
	bh=eReDNuA5zbF7MCYE4cLHGU2ufzck1Ahu/pvpbJFQVDM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=frquTU1wu1rFcJheO/qjYZjgziI+YwqrJDt5/6g/kBDmq2Y7+HyT0D43FA0OTn13n
	 R44m4nRZd10Cg8vwnQfA/o1gwO6iTX97bWqY9TsF0e5mPpKlD2XwvXxgjq/mP0eVj6
	 GYbZ6XcumWjcQK5BfPpWTs6dB2o2XT8g85BqhvTo42DJP9yiIu7TjKW3n498YzpHTs
	 0XX/q/hK2x9zE43Np3QZTnoi+pZ6Y4+bS0iDN1i04PfpomsU9gwJ6y5nRfZDY1zyB4
	 D5WEQup1uXsWSZnClc6wYPmtt3yRGmF/uo24Pd3buioz9042+JeMCk2iaaGCkDOMuo
	 rYeBqeLVDFUqw==
Date: Sun, 31 Dec 2023 15:21:00 -0800
Subject: [PATCH 05/10] xfs_scrub: split the repair epilogue code into a
 separate function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007909.1806194.6961016643522301219.stgit@frogsfrogsfrogs>
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

Move all the code that updates the internal state in response to a
repair ioctl() call completion into a separate function.  This will help
with vectorizing repair calls later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |   69 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 24 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 4fed86134ed..0b99e335191 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -20,6 +20,11 @@
 #include "descr.h"
 #include "scrub_private.h"
 
+static int repair_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
+		struct scrub_item *sri, unsigned int repair_flags,
+		struct xfs_scrub_metadata *oldm,
+		struct xfs_scrub_metadata *meta, int error);
+
 /* General repair routines. */
 
 /*
@@ -133,6 +138,22 @@ xfs_repair_metadata(
 				_("Attempting optimization."));
 
 	error = -xfrog_scrub_metadata(xfdp, &meta);
+	return repair_epilogue(ctx, &dsc, sri, repair_flags, &oldm, &meta,
+			error);
+}
+
+static int
+repair_epilogue(
+	struct scrub_ctx		*ctx,
+	struct descr			*dsc,
+	struct scrub_item		*sri,
+	unsigned int			repair_flags,
+	struct xfs_scrub_metadata	*oldm,
+	struct xfs_scrub_metadata	*meta,
+	int				error)
+{
+	unsigned int			scrub_type = meta->sm_type;
+
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
@@ -141,12 +162,12 @@ xfs_repair_metadata(
 	case EBUSY:
 		/* Filesystem is busy, try again later. */
 		if (debug || verbose)
-			str_info(ctx, descr_render(&dsc),
+			str_info(ctx, descr_render(dsc),
 _("Filesystem is busy, deferring repair."));
 		return 0;
 	case ESHUTDOWN:
 		/* Filesystem is already shut down, abort. */
-		str_error(ctx, descr_render(&dsc),
+		str_error(ctx, descr_render(dsc),
 _("Filesystem is shut down, aborting."));
 		return ECANCELED;
 	case ENOTTY:
@@ -157,7 +178,7 @@ _("Filesystem is shut down, aborting."));
 		 * how to perform the repair, don't requeue the request.  Mark
 		 * it done and move on.
 		 */
-		if (is_unoptimized(&oldm) ||
+		if (is_unoptimized(oldm) ||
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
 			scrub_item_clean_state(sri, scrub_type);
 			return 0;
@@ -175,14 +196,14 @@ _("Filesystem is shut down, aborting."));
 		fallthrough;
 	case EINVAL:
 		/* Kernel doesn't know how to repair this? */
-		str_corrupt(ctx, descr_render(&dsc),
+		str_corrupt(ctx, descr_render(dsc),
 _("Don't know how to fix; offline repair required."));
 		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	case EROFS:
 		/* Read-only filesystem, can't fix. */
-		if (verbose || debug || needs_repair(&oldm))
-			str_error(ctx, descr_render(&dsc),
+		if (verbose || debug || needs_repair(oldm))
+			str_error(ctx, descr_render(dsc),
 _("Read-only filesystem; cannot make changes."));
 		return ECANCELED;
 	case ENOENT:
@@ -192,7 +213,7 @@ _("Read-only filesystem; cannot make changes."));
 	case ENOMEM:
 	case ENOSPC:
 		/* Don't care if preen fails due to low resources. */
-		if (is_unoptimized(&oldm) && !needs_repair(&oldm)) {
+		if (is_unoptimized(oldm) && !needs_repair(oldm)) {
 			scrub_item_clean_state(sri, scrub_type);
 			return 0;
 		}
@@ -207,7 +228,7 @@ _("Read-only filesystem; cannot make changes."));
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
 			return 0;
-		str_liberror(ctx, error, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(dsc));
 		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	}
@@ -218,12 +239,12 @@ _("Read-only filesystem; cannot make changes."));
 	 * the repair again, just in case the fs was busy.  Only retry so many
 	 * times.
 	 */
-	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+	if (want_retry(meta) && scrub_item_schedule_retry(sri, scrub_type))
 		return 0;
 
 	if (repair_flags & XRM_FINAL_WARNING)
-		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
-	if (needs_repair(&meta) || is_incomplete(&meta)) {
+		scrub_warn_incomplete_scrub(ctx, dsc, meta);
+	if (needs_repair(meta) || is_incomplete(meta)) {
 		/*
 		 * Still broken; if we've been told not to complain then we
 		 * just requeue this and try again later.  Otherwise we
@@ -231,9 +252,9 @@ _("Read-only filesystem; cannot make changes."));
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
 			return 0;
-		str_corrupt(ctx, descr_render(&dsc),
+		str_corrupt(ctx, descr_render(dsc),
 _("Repair unsuccessful; offline repair required."));
-	} else if (xref_failed(&meta)) {
+	} else if (xref_failed(meta)) {
 		/*
 		 * This metadata object itself looks ok, but we still noticed
 		 * inconsistencies when comparing it with the other filesystem
@@ -242,31 +263,31 @@ _("Repair unsuccessful; offline repair required."));
 		 * reverify the cross-referencing as repairs progress.
 		 */
 		if (repair_flags & XRM_FINAL_WARNING) {
-			str_info(ctx, descr_render(&dsc),
+			str_info(ctx, descr_render(dsc),
  _("Seems correct but cross-referencing failed; offline repair recommended."));
 		} else {
 			if (verbose)
-				str_info(ctx, descr_render(&dsc),
+				str_info(ctx, descr_render(dsc),
  _("Seems correct but cross-referencing failed; will keep checking."));
 			return 0;
 		}
-	} else if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
+	} else if (meta->sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
 		if (verbose)
-			str_info(ctx, descr_render(&dsc),
+			str_info(ctx, descr_render(dsc),
 					_("No modification needed."));
 	} else {
 		/* Clean operation, no corruption detected. */
-		if (is_corrupt(&oldm))
-			record_repair(ctx, descr_render(&dsc),
+		if (is_corrupt(oldm))
+			record_repair(ctx, descr_render(dsc),
  _("Repairs successful."));
-		else if (xref_disagrees(&oldm))
-			record_repair(ctx, descr_render(&dsc),
+		else if (xref_disagrees(oldm))
+			record_repair(ctx, descr_render(dsc),
  _("Repairs successful after discrepancy in cross-referencing."));
-		else if (xref_failed(&oldm))
-			record_repair(ctx, descr_render(&dsc),
+		else if (xref_failed(oldm))
+			record_repair(ctx, descr_render(dsc),
  _("Repairs successful after cross-referencing failure."));
 		else
-			record_preen(ctx, descr_render(&dsc),
+			record_preen(ctx, descr_render(dsc),
  _("Optimization successful."));
 	}
 

