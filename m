Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E0A1854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309725; cv=none; b=Donb9AyD0epbvOGWZshwQFt5lk3WfMUyLMSkK8FlRRm8XFtztNk0ZMAkndbNzgvP4P0T6xkg9Pc9KahGoqWqzbmJhHDVk8p0FcSB2TSwSbyxy6DljnM13JCDSU6yjtPQu0RIHteXGcptVNUL58V+NwYJbvuRU81vBsXaaIH4cg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309725; c=relaxed/simple;
	bh=7n1SWZRIg3qfp31ocesCYJY39H6harth53lP5v146Vc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qdIF/oB6Ay8Wg8ivczMoq75GwOvQUPO30p7cQx4Vn46XNlH0Zw3m7HQs9UMcWBS53Tsw4pXBX1bBMt9QlDNg4ZQ25bPmZFg8nDUAKb5nOER9Ydzx8a4FWNi1UIMFLcD/oRE30E4/+5WNwVvenQeRZrTJm16zdVnEn8CmVsbD1Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kr3jGVVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kr3jGVVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0CDC32786;
	Tue, 30 Jul 2024 03:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309724;
	bh=7n1SWZRIg3qfp31ocesCYJY39H6harth53lP5v146Vc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kr3jGVVYY9TWjApPVF5i1W+gCACheyY7MIH/Z+0QQKBiy8782d3JSDxxWG1lEvgf4
	 27/tH8UaVXZQmXvPOdEX6zwH7J8LZyr+qBUmbi1Bd6zaysJVDWQqrOfy+zvyAmqzj9
	 pByKaGXcRoi0VWl7Sl9KKPOkjp9JA/O1adf8l08bQsHZ1O13E/YVWB2V3OIXYreGlC
	 ru//0znaFD9nzW+REZNgP+JR+8LxIPmpLYnSfVQmiOwuP/LccfNH1SxOfXxT0a7kcZ
	 KgEmOrhVi6Z9rWH5wKmU0XYpXTSOupjoeWTKXOC4CFGRQfDB+AdSmbXeCggKqj8r2I
	 HTFP4KcocVHgg==
Date: Mon, 29 Jul 2024 20:22:04 -0700
Subject: [PATCH 2/3] xfs_scrub: allow sysadmin to control background scrubs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230941018.1544039.12505916924928894120.stgit@frogsfrogsfrogs>
In-Reply-To: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
References: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
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

Define a "self_healing" filesystem property so that sysadmins can
indicate their preferences for background online fsck.  Add an extended
option to xfs_scrub so that it selects the operation mode from the self
healing fs property.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_scrub.8 |   44 +++++++++++++++++++++++++++
 scrub/phase1.c       |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.c    |   14 +++++++++
 scrub/xfs_scrub.h    |    7 ++++
 4 files changed, 146 insertions(+)


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index 1fd122f2a242..1e017078019c 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -107,6 +107,14 @@ The
 supported are:
 .RS 1.0i
 .TP
+.B fsprops_advise
+Decide the operating mode from the value of the
+.I self_healing
+filesystem property.
+See the
+.B filesytem properties
+section for more details.
+.TP
 .BI fstrim_pct= percentage
 To constrain the amount of time spent on fstrim activities during phase 8,
 this program tries to balance estimated runtime against completeness of the
@@ -192,6 +200,42 @@ Scheduling a quotacheck for the next mount.
 .PP
 If corrupt metadata is successfully repaired, this program will log that
 a repair has succeeded instead of a corruption report.
+.SH FILESYSTEM PROPERTIES
+System administrators can convey their preferences for scrubbing of a
+particular filesystem by setting the filesystem property
+.B self_healing
+via the
+.B setfsprops
+subcommand of the
+.B xfs_spaceman
+on the filesystem.
+These preferences will be honored if the
+.B -o fsprops_advise
+option is specified.
+
+Recognized values for the
+.B self_healing
+property are:
+.RS
+.TP
+.I none
+Do not scan the filesystem at all.
+.TP
+.I check
+Scan and report corruption and opportunities for optimization, but do not
+change anything.
+.TP
+.I optimize
+Scan the filesystem and optimize where possible.
+Report corruptions, but do not fix them.
+.TP
+.I repair
+Scan the filesystem, fix corruptions, and optimize where possible.
+.RE
+
+If the property is not set, the default is
+.IR check .
+
 .SH EXIT CODE
 The exit code returned by
 .B xfs_scrub
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 091b59e57e7b..5fa215a5bb79 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -28,6 +28,8 @@
 #include "repair.h"
 #include "libfrog/fsgeom.h"
 #include "xfs_errortag.h"
+#include "libfrog/fsprops.h"
+#include "libfrog/fsproperties.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
@@ -130,6 +132,77 @@ enable_force_repair(
 	return error;
 }
 
+#define MAX_SELFHEAL_LEN		128
+/*
+ * Decide the operating mode from filesystem properties.  No fs property or
+ * system errors means we only check.
+ */
+static void
+mode_from_fsprops(
+	struct scrub_ctx		*ctx)
+{
+	struct fsprops_handle		fph = { };
+	char				valuebuf[MAX_SELFHEAL_LEN + 1] = { 0 };
+	size_t				valuelen = MAX_SELFHEAL_LEN;
+	enum fsprop_self_healing	shval;
+	int				ret;
+
+	ret = fsprops_open_handle(&ctx->mnt, &ctx->fsinfo, &fph);
+	if (ret) {
+		ctx->mode = SCRUB_MODE_DRY_RUN;
+		goto summarize;
+	}
+
+	ret = fsprops_get(&fph, FSPROP_SELF_HEALING_NAME, valuebuf, &valuelen);
+	if (ret) {
+		ctx->mode = SCRUB_MODE_DRY_RUN;
+		goto summarize;
+	}
+
+	shval = fsprop_read_self_healing(valuebuf);
+	switch (shval) {
+	case FSPROP_SELFHEAL_NONE:
+		ctx->mode = SCRUB_MODE_NONE;
+		break;
+	case FSPROP_SELFHEAL_OPTIMIZE:
+		ctx->mode = SCRUB_MODE_PREEN;
+		break;
+	case FSPROP_SELFHEAL_REPAIR:
+		ctx->mode = SCRUB_MODE_REPAIR;
+		break;
+	case FSPROP_SELFHEAL_UNSET:
+		str_info(ctx, ctx->mntpoint,
+ _("Unknown self_healing directive \"%s\"."),
+				valuebuf);
+		fallthrough;
+	case FSPROP_SELFHEAL_CHECK:
+		ctx->mode = SCRUB_MODE_DRY_RUN;
+		break;
+	}
+
+	fsprops_free_handle(&fph);
+
+summarize:
+	switch (ctx->mode) {
+	case SCRUB_MODE_NONE:
+		str_info(ctx, ctx->mntpoint,
+ _("Disabling scrub per self_healing directive."));
+		break;
+	case SCRUB_MODE_DRY_RUN:
+		str_info(ctx, ctx->mntpoint,
+ _("Checking per self_healing directive."));
+		break;
+	case SCRUB_MODE_PREEN:
+		str_info(ctx, ctx->mntpoint,
+ _("Optimizing per self_healing directive."));
+		break;
+	case SCRUB_MODE_REPAIR:
+		str_info(ctx, ctx->mntpoint,
+ _("Checking and repairing per self_healing directive."));
+		break;
+	}
+}
+
 /*
  * Bind to the mountpoint, read the XFS geometry, bind to the block devices.
  * Anything we've already built will be cleaned up by scrub_cleanup.
@@ -206,6 +279,14 @@ _("Not an XFS filesystem."));
 		return error;
 	}
 
+	/*
+	 * If we've been instructed to decide the operating mode from the
+	 * fs properties set on the mount point, do that now before we start
+	 * downgrading based on actual fs/kernel capabilities.
+	 */
+	if (ctx->mode == SCRUB_MODE_NONE)
+		mode_from_fsprops(ctx);
+
 	/* Do we have kernel-assisted metadata scrubbing? */
 	if (!can_scrub_fs_metadata(ctx) || !can_scrub_inode(ctx) ||
 	    !can_scrub_bmap(ctx) || !can_scrub_dir(ctx) ||
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index f5b58de12812..a9d7e5ffe6d7 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -526,6 +526,10 @@ _("Scrub aborted after phase %d."),
 		if (ret)
 			break;
 
+		/* Did background scrub get canceled on us? */
+		if (ctx->mode == SCRUB_MODE_NONE)
+			break;
+
 		/* Too many errors? */
 		if (scrub_excessive_errors(ctx)) {
 			ret = ECANCELED;
@@ -630,12 +634,14 @@ report_outcome(
 enum o_opt_nums {
 	IWARN = 0,
 	FSTRIM_PCT,
+	FSPROPS_ADVISE,
 	O_MAX_OPTS,
 };
 
 static char *o_opts[] = {
 	[IWARN]			= "iwarn",
 	[FSTRIM_PCT]		= "fstrim_pct",
+	[FSPROPS_ADVISE]	= "fsprops_advise",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -688,6 +694,14 @@ parse_o_opts(
 
 			ctx->fstrim_block_pct = dval / 100.0;
 			break;
+		case FSPROPS_ADVISE:
+			if (val) {
+				fprintf(stderr,
+ _("-o fsprops_advise does not take an argument\n"));
+				usage();
+			}
+			ctx->mode = SCRUB_MODE_NONE;
+			break;
 		default:
 			usage();
 			break;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 4d9a028921b5..582ec8e579e9 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -26,6 +26,13 @@ extern bool			use_force_rebuild;
 extern bool			info_is_warning;
 
 enum scrub_mode {
+	/*
+	 * Prior to phase 1, this means that xfs_scrub should read the
+	 * "self_healing" fs property from the mount and set the value
+	 * appropriate.  If it's still set after phase 1, this means we should
+	 * exit without doing anything.
+	 */
+	SCRUB_MODE_NONE,
 	SCRUB_MODE_DRY_RUN,
 	SCRUB_MODE_PREEN,
 	SCRUB_MODE_REPAIR,

