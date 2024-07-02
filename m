Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D0238B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883393; cv=none; b=pbclaPFRkVfFjtk0Bg7ho0UOhZU1Dco16SYYDvpDISysWMAFx8zCgipnTJt3Gm6T7eRRAUbLQlv3XrLKAgaJky0n0OlI0vTXXgamwMJF02dcHFRM9V//g9rcn50oVzzEu1XO61Bvjujt10lpkxgOKOGftAqsUmZy78Qbsow3uUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883393; c=relaxed/simple;
	bh=iKqnMeyIew8hY6Psz62yCGimihIXwufc4I6mvnBvWRU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sFzkC6Re6csMwnZrynni94hnSb9kxMnpXHyHZoH4xkSXZTNM0JETskNkkId0LaNAchHATGZJ7rmZHoAOxQYxYK456rM6rOgK/3ePfPDz9ctmclr1q/MzUXKuLLtKOgJ949njue73GB7nQ/ZMVx7Opc4axKg9w3/+ljM1jA1BIiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vJHHJK+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vJHHJK+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DA7C116B1;
	Tue,  2 Jul 2024 01:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883392;
	bh=iKqnMeyIew8hY6Psz62yCGimihIXwufc4I6mvnBvWRU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vJHHJK+pmxBRK5gKzJ6rSj9ithvLipiZYcSaGSeqAeSSFEFFeGl7QkIr+DBw3p6Dv
	 R5FVbHGzUhRGCXJla6FCMwCUl/Bu5N22ENGSUK1jCqjvJOVeXZmLhLwIp18XSlpFyw
	 7rjMjcXaI/hH1FzFA96EBo5T4yMSlSEP8sgmDf9RCMf7Ffp7sw+89FzqtMVP58K6XG
	 qhwLF6QXO0Jz3K7QMkn88cA88kK5uAoreriJjpyaU9RqPBWga4B1RapI8NqKejGTQE
	 PBV7TVqwB0HL9fqCCPgjmapiE+Lxh4bKGrlIHLxtKJXak7hfU8cCeTFb5uwxkP16QU
	 ScWDptltEs3gg==
Date: Mon, 01 Jul 2024 18:23:12 -0700
Subject: [PATCH 05/10] xfs_scrub: split the repair epilogue code into a
 separate function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988123211.2012546.6968675746772396260.stgit@frogsfrogsfrogs>
In-Reply-To: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
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
index 4fed86134eda..0b99e3351918 100644
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
 

