Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9563770E8;
	Tue,  6 Aug 2024 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968500; cv=none; b=QOM/2GopgJeyWUSL199qXH5TjqYC4WES3lQosri35zNDp7BQZrvOxC5Uow4x5VF9upqr4PJrAbLLC2YmGIlOpnnY5YRRQtSeHexFXRelnEy+csvCEeXRNFVxuy9bqJee6aVXP0dY8HxnxeUqjP8Ed5OZMtCsHYdofKWUOPTK4vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968500; c=relaxed/simple;
	bh=1ugh6sTJnKCqRwrwmuXt+AbRnSKae7dfMjsCvwj3kTM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=peagpcWZ0uQBYDwcWPKwcCianiKdyvgOBVP8Q13bR953i4z6Y5u8YcLM7IrE5Fp1Lg+qzQDbSRLizMcNCujtYoLgLw9GA+TesfdovpH7OecytI/7taagzu+J6BYc1agNM+JF496jn2MgP9Bqe+Yle5CYtc8C13JhJeWc6lVUlY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oUqnMg6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUqnMg6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9358FC32786;
	Tue,  6 Aug 2024 18:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968500;
	bh=1ugh6sTJnKCqRwrwmuXt+AbRnSKae7dfMjsCvwj3kTM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oUqnMg6OlikEg5G4TboI89SgPg2exXLsfXwKq46CLifSYwbpCeSGBg69rShUwcssB
	 aO4RBEWoJZb9ZsS6Ilv7RWM5hJcOwchuXjt9HqNjgSikG7DfVHJFuMNtMypvgsbJmI
	 t2h7wWCTEu/RZHq7u+I1cm1MDUXsP7DCsT9EVwb/SR6hM8ehQri9ctZi3myWpyw/eo
	 4e6+ivapqpo+FuksqYH466yoUcqHzYPWL75TExNSQv3AQXUGcwCcVrFVqpBXGX6KT+
	 MZ/fR3BFLXT41FADzItiVtWnbbczsrHW1nKBTAkBEOJiU0/quh2HvmLuzgcCUCiTJZ
	 yQSP3zaQvgkaw==
Date: Tue, 06 Aug 2024 11:21:40 -0700
Subject: [PATCH 2/4] xfs_scrub: allow sysadmin to control background scrubs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825628.3193344.3037756123720880069.stgit@frogsfrogsfrogs>
In-Reply-To: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs>
References: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs>
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

Add an extended option -o autofsck to xfs_scrub so that it selects the
operation mode from the "autofsck" filesystem property.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_property.8 |    8 ++++
 man/man8/xfs_scrub.8    |   46 ++++++++++++++++++++++++
 scrub/phase1.c          |   91 +++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.c       |   14 +++++++
 scrub/xfs_scrub.h       |    7 ++++
 5 files changed, 166 insertions(+)


diff --git a/man/man8/xfs_property.8 b/man/man8/xfs_property.8
index 19c1c0e37..9fb1fd7cc 100644
--- a/man/man8/xfs_property.8
+++ b/man/man8/xfs_property.8
@@ -59,3 +59,11 @@ was set.
 remove
 .IR name ...
 Unsets the given filesystem properties.
+
+.SH FILESYSTEM PROPERTIES
+Known filesystem properties for XFS are:
+
+.I autofsck
+See
+.BR xfs_scrub (8)
+for more information.
diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index 1fd122f2a..1ed4b176b 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -107,6 +107,14 @@ The
 supported are:
 .RS 1.0i
 .TP
+.B autofsck
+Decide the operating mode from the value of the
+.I autofsck
+filesystem property.
+See the
+.B filesystem properties
+section for more details.
+.TP
 .BI fstrim_pct= percentage
 To constrain the amount of time spent on fstrim activities during phase 8,
 this program tries to balance estimated runtime against completeness of the
@@ -192,6 +200,44 @@ Scheduling a quotacheck for the next mount.
 .PP
 If corrupt metadata is successfully repaired, this program will log that
 a repair has succeeded instead of a corruption report.
+.SH FILESYSTEM PROPERTIES
+System administrators can convey their preferences for scrubbing of a
+particular filesystem by setting the filesystem property
+.B autofsck
+via the
+.BR xfs_property (8)
+command on the filesystem.
+These preferences will be honored if the
+.B -o autofsck
+option is specified.
+
+Recognized values for the
+.B autofsck
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
+.I check
+if the filesystem has either reverse mapping btrees or parent pointers enabled,
+or
+.I none
+otherwise.
+
 .SH EXIT CODE
 The exit code returned by
 .B xfs_scrub
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 091b59e57..d03a9099a 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -28,6 +28,8 @@
 #include "repair.h"
 #include "libfrog/fsgeom.h"
 #include "xfs_errortag.h"
+#include "libfrog/fsprops.h"
+#include "libfrog/fsproperties.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
@@ -130,6 +132,87 @@ enable_force_repair(
 	return error;
 }
 
+/*
+ * Decide the operating mode from the autofsck fs property.  No fs property or
+ * system errors means we check the fs if rmapbt or pptrs are enabled, or none
+ * if it doesn't.
+ */
+static void
+mode_from_autofsck(
+	struct scrub_ctx	*ctx)
+{
+	struct fsprops_handle	fph = { };
+	char			valuebuf[FSPROP_MAX_VALUELEN + 1] = { 0 };
+	size_t			valuelen = FSPROP_MAX_VALUELEN;
+	enum fsprop_autofsck	shval;
+	int			ret;
+
+	ret = fsprops_open_handle(&ctx->mnt, &ctx->fsinfo, &fph);
+	if (ret)
+		goto no_property;
+
+	ret = fsprops_get(&fph, FSPROP_AUTOFSCK_NAME, valuebuf, &valuelen);
+	if (ret)
+		goto no_property;
+
+	shval = fsprop_autofsck_read(valuebuf);
+	switch (shval) {
+	case FSPROP_AUTOFSCK_NONE:
+		ctx->mode = SCRUB_MODE_NONE;
+		break;
+	case FSPROP_AUTOFSCK_OPTIMIZE:
+		ctx->mode = SCRUB_MODE_PREEN;
+		break;
+	case FSPROP_AUTOFSCK_REPAIR:
+		ctx->mode = SCRUB_MODE_REPAIR;
+		break;
+	case FSPROP_AUTOFSCK_UNSET:
+		str_info(ctx, ctx->mntpoint,
+ _("Unknown autofsck directive \"%s\"."),
+				valuebuf);
+		goto no_property;
+	case FSPROP_AUTOFSCK_CHECK:
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
+ _("Disabling scrub per autofsck directive."));
+		break;
+	case SCRUB_MODE_DRY_RUN:
+		str_info(ctx, ctx->mntpoint,
+ _("Checking per autofsck directive."));
+		break;
+	case SCRUB_MODE_PREEN:
+		str_info(ctx, ctx->mntpoint,
+ _("Optimizing per autofsck directive."));
+		break;
+	case SCRUB_MODE_REPAIR:
+		str_info(ctx, ctx->mntpoint,
+ _("Checking and repairing per autofsck directive."));
+		break;
+	}
+
+	return;
+no_property:
+	/*
+	 * If we don't find an autofsck property, check the metadata if any
+	 * backrefs are available for cross-referencing.  Otherwise do no
+	 * checking.
+	 */
+	if (ctx->mnt.fsgeom.flags & (XFS_FSOP_GEOM_FLAGS_PARENT |
+				     XFS_FSOP_GEOM_FLAGS_RMAPBT))
+		ctx->mode = SCRUB_MODE_DRY_RUN;
+	else
+		ctx->mode = SCRUB_MODE_NONE;
+	goto summarize;
+}
+
 /*
  * Bind to the mountpoint, read the XFS geometry, bind to the block devices.
  * Anything we've already built will be cleaned up by scrub_cleanup.
@@ -206,6 +289,14 @@ _("Not an XFS filesystem."));
 		return error;
 	}
 
+	/*
+	 * If we've been instructed to decide the operating mode from the
+	 * autofsck fs property, do that now before we start downgrading based
+	 * on actual fs/kernel capabilities.
+	 */
+	if (ctx->mode == SCRUB_MODE_NONE)
+		mode_from_autofsck(ctx);
+
 	/* Do we have kernel-assisted metadata scrubbing? */
 	if (!can_scrub_fs_metadata(ctx) || !can_scrub_inode(ctx) ||
 	    !can_scrub_bmap(ctx) || !can_scrub_dir(ctx) ||
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index f5b58de12..3e7d9138f 100644
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
+	AUTOFSCK,
 	O_MAX_OPTS,
 };
 
 static char *o_opts[] = {
 	[IWARN]			= "iwarn",
 	[FSTRIM_PCT]		= "fstrim_pct",
+	[AUTOFSCK]		= "autofsck",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -688,6 +694,14 @@ parse_o_opts(
 
 			ctx->fstrim_block_pct = dval / 100.0;
 			break;
+		case AUTOFSCK:
+			if (val) {
+				fprintf(stderr,
+ _("-o autofsck does not take an argument\n"));
+				usage();
+			}
+			ctx->mode = SCRUB_MODE_NONE;
+			break;
 		default:
 			usage();
 			break;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 4d9a02892..5d336cb55 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -26,6 +26,13 @@ extern bool			use_force_rebuild;
 extern bool			info_is_warning;
 
 enum scrub_mode {
+	/*
+	 * Prior to phase 1, this means that xfs_scrub should read the
+	 * "autofsck" fs property from the mount and set the value
+	 * appropriate.  If it's still set after phase 1, this means we should
+	 * exit without doing anything.
+	 */
+	SCRUB_MODE_NONE,
 	SCRUB_MODE_DRY_RUN,
 	SCRUB_MODE_PREEN,
 	SCRUB_MODE_REPAIR,

