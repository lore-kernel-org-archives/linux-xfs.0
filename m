Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536198BF0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301438; cv=none; b=bNC+R6y8ZK5NDov3HbQZpOhenW/h3ZuQGDEq7i7IaUvXpWv6uyw7xFdkAkt4u1hWHwgrdWjN6gjp2FkrIzg/oE9F5fUZTl0xJzn4vKFHT/sFXbSTdPz6e4mVIGkA/ox8pE/XD+lOzkqNCn2hAuekaG+dA8DczuK0nsVn40TZsD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301438; c=relaxed/simple;
	bh=G3vN2xh6GYd6VPXdfqNhcp1LF95+GAe9XZ0GzRGl/nc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XN6OyyqVTZaDmj/4M7WrpsDpS1F5B6V+cl7uDRzSf7on6W534NXAetsZZf9uk9eGb20uZmcUTnBH3Tpdzc4KLm1Wa2LqFcQmB707CqNKcqFQfHS6ZNxlhMUCRk53co/3YjqvcFxELHFtfxvOYsdmY008Qw43MP+0JSYW21HnYiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eM5IVTgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eM5IVTgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC670C32786;
	Tue, 30 Jul 2024 01:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301437;
	bh=G3vN2xh6GYd6VPXdfqNhcp1LF95+GAe9XZ0GzRGl/nc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eM5IVTgc5IsaWVb8rXIOxRn1p5gPhq0N9qUKBASt3FFUijekDNwvAMRIVMNDhif7z
	 rhpitGCyDYCbqnBEo1Q4OvW74NtcChozDzmd5LtJRQVmJH+ITS6Z4YXsVZGBJ2tX6d
	 rHJqKZ2uDrlXZpn7HFqKVE8QJ9B8k9dx5rRV44Gjy8wdRa6fxl6krYpzirrvAoorY4
	 C3RK4yxWPF9zx3BhofbcMPpqfCiVAFgef4WPm81TorwrJcqpT+7Q8gB1q94omqpLkP
	 4GHbs3Jj/NiRLjtwXs6WSx4ZuRG60SpMYFliStXMXSXuorI2SUulWPT0SL4goGq1+x
	 QxCK9I5C7iSiA==
Date: Mon, 29 Jul 2024 18:03:57 -0700
Subject: [PATCH 2/5] xfs_scrub: remove enum check_outcome
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846798.1348436.2789704981653044177.stgit@frogsfrogsfrogs>
In-Reply-To: <172229846763.1348436.17732340268176889954.stgit@frogsfrogsfrogs>
References: <172229846763.1348436.17732340268176889954.stgit@frogsfrogsfrogs>
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

Get rid of this enumeration, and just do what we will directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c |   56 ++++++++++++++++++++++----------------------------
 scrub/scrub.c  |   63 +++++++++++++++++++++++++++++---------------------------
 scrub/scrub.h  |    8 -------
 3 files changed, 58 insertions(+), 69 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index a3a8fb311..f888441aa 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -46,7 +46,7 @@ static const unsigned int repair_deps[XFS_SCRUB_TYPE_NR] = {
 #undef DEP
 
 /* Repair some metadata. */
-static enum check_outcome
+static int
 xfs_repair_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_fd			*xfdp,
@@ -88,7 +88,7 @@ xfs_repair_metadata(
 	}
 
 	if (!is_corrupt(&meta) && repair_only)
-		return CHECK_RETRY;
+		return 0;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
 	oldm.sm_flags = sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY;
@@ -112,12 +112,12 @@ xfs_repair_metadata(
 		if (debug || verbose)
 			str_info(ctx, descr_render(&dsc),
 _("Filesystem is busy, deferring repair."));
-		return CHECK_RETRY;
+		return 0;
 	case ESHUTDOWN:
 		/* Filesystem is already shut down, abort. */
 		str_error(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
-		return CHECK_ABORT;
+		return ECANCELED;
 	case ENOTTY:
 	case EOPNOTSUPP:
 		/*
@@ -129,7 +129,7 @@ _("Filesystem is shut down, aborting."));
 		if (is_unoptimized(&oldm) ||
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
 			scrub_item_clean_state(sri, scrub_type);
-			return CHECK_DONE;
+			return 0;
 		}
 		/*
 		 * If we're in no-complain mode, requeue the check for
@@ -140,30 +140,30 @@ _("Filesystem is shut down, aborting."));
 		 * again to see if another repair fixed it.
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
+			return 0;
 		fallthrough;
 	case EINVAL:
 		/* Kernel doesn't know how to repair this? */
 		str_corrupt(ctx, descr_render(&dsc),
 _("Don't know how to fix; offline repair required."));
 		scrub_item_clean_state(sri, scrub_type);
-		return CHECK_DONE;
+		return 0;
 	case EROFS:
 		/* Read-only filesystem, can't fix. */
 		if (verbose || debug || needs_repair(&oldm))
 			str_error(ctx, descr_render(&dsc),
 _("Read-only filesystem; cannot make changes."));
-		return CHECK_ABORT;
+		return ECANCELED;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
 		scrub_item_clean_state(sri, scrub_type);
-		return CHECK_DONE;
+		return 0;
 	case ENOMEM:
 	case ENOSPC:
 		/* Don't care if preen fails due to low resources. */
 		if (is_unoptimized(&oldm) && !needs_repair(&oldm)) {
 			scrub_item_clean_state(sri, scrub_type);
-			return CHECK_DONE;
+			return 0;
 		}
 		fallthrough;
 	default:
@@ -175,10 +175,10 @@ _("Read-only filesystem; cannot make changes."));
 		 * trying to repair it, and bail out.
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
+			return 0;
 		str_liberror(ctx, error, descr_render(&dsc));
 		scrub_item_clean_state(sri, scrub_type);
-		return CHECK_DONE;
+		return 0;
 	}
 
 	/*
@@ -201,7 +201,7 @@ _("Read-only filesystem; cannot make changes."));
 		 * log the error loudly and don't try again.
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
+			return 0;
 		str_corrupt(ctx, descr_render(&dsc),
 _("Repair unsuccessful; offline repair required."));
 	} else if (xref_failed(&meta)) {
@@ -219,7 +219,7 @@ _("Repair unsuccessful; offline repair required."));
 			if (verbose)
 				str_info(ctx, descr_render(&dsc),
  _("Seems correct but cross-referencing failed; will keep checking."));
-			return CHECK_RETRY;
+			return 0;
 		}
 	} else if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
 		if (verbose)
@@ -242,7 +242,7 @@ _("Repair unsuccessful; offline repair required."));
 	}
 
 	scrub_item_clean_state(sri, scrub_type);
-	return CHECK_DONE;
+	return 0;
 }
 
 /*
@@ -543,6 +543,7 @@ repair_item_class(
 	struct xfs_fd			xfd;
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	unsigned int			scrub_type;
+	int				error = 0;
 
 	if (ctx->mode < SCRUB_MODE_REPAIR)
 		return 0;
@@ -559,8 +560,6 @@ repair_item_class(
 	}
 
 	foreach_scrub_type(scrub_type) {
-		enum check_outcome	fix;
-
 		if (scrub_excessive_errors(ctx))
 			return ECANCELED;
 
@@ -576,22 +575,17 @@ repair_item_class(
 		    !repair_item_dependencies_ok(sri, scrub_type))
 			continue;
 
-		fix = xfs_repair_metadata(ctx, xfdp, scrub_type, sri, flags);
-		switch (fix) {
-		case CHECK_DONE:
-			if (!(flags & XRM_NOPROGRESS))
-				progress_add(1);
-			continue;
-		case CHECK_ABORT:
-			return ECANCELED;
-		case CHECK_RETRY:
-			continue;
-		case CHECK_REPAIR:
-			abort();
-		}
+		error = xfs_repair_metadata(ctx, xfdp, scrub_type, sri, flags);
+		if (error)
+			break;
+
+		/* Maybe update progress if we fixed the problem. */
+		if (!(flags & XRM_NOPROGRESS) &&
+		    !(sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY))
+			progress_add(1);
 	}
 
-	return 0;
+	return error;
 }
 
 /*
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 5aa36a964..2c47542ee 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -78,12 +78,12 @@ scrub_warn_incomplete_scrub(
 }
 
 /* Do a read-only check of some metadata. */
-static enum check_outcome
+static int
 xfs_check_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_fd			*xfdp,
 	struct xfs_scrub_metadata	*meta,
-	bool				is_inode)
+	struct scrub_item		*sri)
 {
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	enum xfrog_scrub_group		group;
@@ -106,17 +106,18 @@ xfs_check_metadata(
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
-		return CHECK_DONE;
+		scrub_item_clean_state(sri, meta->sm_type);
+		return 0;
 	case ESHUTDOWN:
 		/* FS already crashed, give up. */
 		str_error(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
-		return CHECK_ABORT;
+		return ECANCELED;
 	case EIO:
 	case ENOMEM:
 		/* Abort on I/O errors or insufficient memory. */
 		str_liberror(ctx, error, descr_render(&dsc));
-		return CHECK_ABORT;
+		return ECANCELED;
 	case EDEADLOCK:
 	case EBUSY:
 	case EFSBADCRC:
@@ -124,13 +125,16 @@ _("Filesystem is shut down, aborting."));
 		/*
 		 * The first two should never escape the kernel,
 		 * and the other two should be reported via sm_flags.
+		 * Log it and move on.
 		 */
 		str_liberror(ctx, error, _("Kernel bug"));
-		return CHECK_DONE;
+		scrub_item_clean_state(sri, meta->sm_type);
+		return 0;
 	default:
-		/* Operational error. */
+		/* Operational error.  Log it and move on. */
 		str_liberror(ctx, error, descr_render(&dsc));
-		return CHECK_DONE;
+		scrub_item_clean_state(sri, meta->sm_type);
+		return 0;
 	}
 
 	/*
@@ -153,12 +157,16 @@ _("Filesystem is shut down, aborting."));
 	 */
 	if (is_corrupt(meta) || xref_disagrees(meta)) {
 		if (ctx->mode < SCRUB_MODE_REPAIR) {
+			/* Dry-run mode, so log an error and forget it. */
 			str_corrupt(ctx, descr_render(&dsc),
 _("Repairs are required."));
-			return CHECK_DONE;
+			scrub_item_clean_state(sri, meta->sm_type);
+			return 0;
 		}
 
-		return CHECK_REPAIR;
+		/* Schedule repairs. */
+		scrub_item_save_state(sri, meta->sm_type, meta->sm_flags);
+		return 0;
 	}
 
 	/*
@@ -167,6 +175,7 @@ _("Repairs are required."));
 	 */
 	if (is_unoptimized(meta)) {
 		if (ctx->mode != SCRUB_MODE_REPAIR) {
+			/* Dry-run mode, so log an error and forget it. */
 			if (group != XFROG_SCRUB_GROUP_INODE) {
 				/* AG or FS metadata, always warn. */
 				str_info(ctx, descr_render(&dsc),
@@ -178,10 +187,13 @@ _("Optimization is possible."));
 					ctx->preen_triggers[meta->sm_type] = true;
 				pthread_mutex_unlock(&ctx->lock);
 			}
-			return CHECK_DONE;
+			scrub_item_clean_state(sri, meta->sm_type);
+			return 0;
 		}
 
-		return CHECK_REPAIR;
+		/* Schedule optimizations. */
+		scrub_item_save_state(sri, meta->sm_type, meta->sm_flags);
+		return 0;
 	}
 
 	/*
@@ -191,11 +203,14 @@ _("Optimization is possible."));
 	 * re-examine the object as repairs progress to see if the kernel will
 	 * deem it completely consistent at some point.
 	 */
-	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR)
-		return CHECK_REPAIR;
+	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR) {
+		scrub_item_save_state(sri, meta->sm_type, meta->sm_flags);
+		return 0;
+	}
 
 	/* Everything is ok. */
-	return CHECK_DONE;
+	scrub_item_clean_state(sri, meta->sm_type);
+	return 0;
 }
 
 /* Bulk-notify user about things that could be optimized. */
@@ -235,7 +250,7 @@ scrub_meta_type(
 	struct xfs_scrub_metadata	meta = {
 		.sm_type		= type,
 	};
-	enum check_outcome		fix;
+	int				error;
 
 	background_sleep();
 
@@ -256,24 +271,12 @@ scrub_meta_type(
 	}
 
 	/* Check the item. */
-	fix = xfs_check_metadata(ctx, xfdp, &meta, false);
+	error = xfs_check_metadata(ctx, xfdp, &meta, sri);
 
 	if (xfrog_scrubbers[type].group != XFROG_SCRUB_GROUP_INODE)
 		progress_add(1);
 
-	switch (fix) {
-	case CHECK_ABORT:
-		return ECANCELED;
-	case CHECK_REPAIR:
-		scrub_item_save_state(sri, type, meta.sm_flags);
-		return 0;
-	case CHECK_DONE:
-		scrub_item_clean_state(sri, type);
-		return 0;
-	default:
-		/* CHECK_RETRY should never happen. */
-		abort();
-	}
+	return error;
 }
 
 /* Schedule scrub for all metadata of a given group. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 1ac0d8aed..24fb24449 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -8,14 +8,6 @@
 
 enum xfrog_scrub_group;
 
-/* Online scrub and repair. */
-enum check_outcome {
-	CHECK_DONE,	/* no further processing needed */
-	CHECK_REPAIR,	/* schedule this for repairs */
-	CHECK_ABORT,	/* end program */
-	CHECK_RETRY,	/* repair failed, try again later */
-};
-
 /*
  * This flag boosts the repair priority of a scrub item when a dependent scrub
  * item is scheduled for repair.  Use a separate flag to preserve the

