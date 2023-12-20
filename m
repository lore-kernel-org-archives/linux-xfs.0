Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BEA4777A
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R85uf1ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741E4C433C7;
	Wed, 20 Dec 2023 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092567;
	bh=9EqgKBxA8Q8ZYwKtRw2WZeq0KS8Ssof5JV3v5CUTJ/4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R85uf1udjcJ26l0lg6L5VFptoCOoHq+w1kb9D5Vga3m7WyHynPfkofLt9lfvDzh1Y
	 AD/bpU6+Nkd0NFPGtW71vomjiM1PqRd6h1zRhMVEEQHXuNTiOTJov5H6wGa5eUx8qf
	 Rx++mUpn51lAlzZ8NTAs+Pos2zdDMhIozQmKX/xKyIAeDsm7VaOpWjMLpSby4Tza7t
	 ImzYB8Zt0EHqFigJy6x9HykD22Dgc3WWVaPIBkquXYu+OO+esa9fg+xQWIKRRFYcPI
	 7Jo84Oj38ruzXxvbjnAfcGRC5g5pftLLXilYs2mkl2pblokUsz8QkH18tZ/JWaQAv6
	 B9YHRcybdJdVA==
Date: Wed, 20 Dec 2023 09:16:07 -0800
Subject: [PATCH 3/3] xfs_scrub: try to use XFS_SCRUB_IFLAG_FORCE_REBUILD
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <170309219482.1608293.12323269575979011860.stgit@frogsfrogsfrogs>
In-Reply-To: <170309219443.1608293.8210327879201043663.stgit@frogsfrogsfrogs>
References: <170309219443.1608293.8210327879201043663.stgit@frogsfrogsfrogs>
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

Now that we have a FORCE_REBUILD flag to the scrub ioctl, try to use
that over the (much noisier) error injection knob, which may or may not
even be enabled in the kernel config.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase1.c    |   28 ++++++++++++++++++++++++++++
 scrub/scrub.c     |   45 +++++++++++++++++++++++----------------------
 scrub/scrub.h     |    1 +
 scrub/xfs_scrub.c |    3 +++
 scrub/xfs_scrub.h |    1 +
 5 files changed, 56 insertions(+), 22 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index fd1050c9..2daf5c7b 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -27,6 +27,7 @@
 #include "scrub.h"
 #include "repair.h"
 #include "libfrog/fsgeom.h"
+#include "xfs_errortag.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
@@ -68,6 +69,27 @@ scrub_cleanup(
 	return error;
 }
 
+/* Decide if we're using FORCE_REBUILD or injecting FORCE_REPAIR. */
+static int
+enable_force_repair(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_error_injection	inject = {
+		.fd			= ctx->mnt.fd,
+		.errtag			= XFS_ERRTAG_FORCE_SCRUB_REPAIR,
+	};
+	int				error;
+
+	use_force_rebuild = can_force_rebuild(ctx);
+	if (use_force_rebuild)
+		return 0;
+
+	error = ioctl(ctx->mnt.fd, XFS_IOC_ERROR_INJECTION, &inject);
+	if (error)
+		str_errno(ctx, _("force_repair"));
+	return error;
+}
+
 /*
  * Bind to the mountpoint, read the XFS geometry, bind to the block devices.
  * Anything we've already built will be cleaned up by scrub_cleanup.
@@ -156,6 +178,12 @@ _("Kernel metadata repair facility is not available.  Use -n to scrub."));
 		return ECANCELED;
 	}
 
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+		error = enable_force_repair(ctx);
+		if (error)
+			return error;
+	}
+
 	/* Did we find the log and rt devices, if they're present? */
 	if (ctx->mnt.fsgeom.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
 		str_error(ctx, ctx->mntpoint,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1a450687..1469058b 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -18,7 +18,6 @@
 #include "common.h"
 #include "progress.h"
 #include "scrub.h"
-#include "xfs_errortag.h"
 #include "repair.h"
 #include "descr.h"
 
@@ -500,26 +499,16 @@ static bool
 __scrub_test(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
-	bool				repair)
+	unsigned int			flags)
 {
 	struct xfs_scrub_metadata	meta = {0};
-	struct xfs_error_injection	inject;
-	static bool			injected;
 	int				error;
 
 	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
 		return false;
-	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
-		inject.fd = ctx->mnt.fd;
-		inject.errtag = XFS_ERRTAG_FORCE_SCRUB_REPAIR;
-		error = ioctl(ctx->mnt.fd, XFS_IOC_ERROR_INJECTION, &inject);
-		if (error == 0)
-			injected = true;
-	}
 
 	meta.sm_type = type;
-	if (repair)
-		meta.sm_flags |= XFS_SCRUB_IFLAG_REPAIR;
+	meta.sm_flags = flags;
 	error = -xfrog_scrub_metadata(&ctx->mnt, &meta);
 	switch (error) {
 	case 0:
@@ -532,13 +521,15 @@ _("Filesystem is mounted read-only; cannot proceed."));
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem is mounted norecovery; cannot proceed."));
 		return false;
+	case EINVAL:
 	case EOPNOTSUPP:
 	case ENOTTY:
 		if (debug || verbose)
 			str_info(ctx, ctx->mntpoint,
 _("Kernel %s %s facility not detected."),
 					_(xfrog_scrubbers[type].descr),
-					repair ? _("repair") : _("scrub"));
+					(flags & XFS_SCRUB_IFLAG_REPAIR) ?
+						_("repair") : _("scrub"));
 		return false;
 	case ENOENT:
 		/* Scrubber says not present on this fs; that's fine. */
@@ -553,56 +544,64 @@ bool
 can_scrub_fs_metadata(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, 0);
 }
 
 bool
 can_scrub_inode(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_INODE, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_INODE, 0);
 }
 
 bool
 can_scrub_bmap(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_BMBTD, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_BMBTD, 0);
 }
 
 bool
 can_scrub_dir(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_DIR, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_DIR, 0);
 }
 
 bool
 can_scrub_attr(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_XATTR, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_XATTR, 0);
 }
 
 bool
 can_scrub_symlink(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_SYMLINK, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_SYMLINK, 0);
 }
 
 bool
 can_scrub_parent(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_PARENT, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_PARENT, 0);
 }
 
 bool
 xfs_can_repair(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, true);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, XFS_SCRUB_IFLAG_REPAIR);
+}
+
+bool
+can_force_rebuild(
+	struct scrub_ctx	*ctx)
+{
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE,
+			XFS_SCRUB_IFLAG_REPAIR | XFS_SCRUB_IFLAG_FORCE_REBUILD);
 }
 
 /* General repair routines. */
@@ -624,6 +623,8 @@ xfs_repair_metadata(
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	meta.sm_type = aitem->type;
 	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
+	if (use_force_rebuild)
+		meta.sm_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
 	switch (xfrog_scrubbers[aitem->type].type) {
 	case XFROG_SCRUB_TYPE_AGHEADER:
 	case XFROG_SCRUB_TYPE_PERAG:
diff --git a/scrub/scrub.h b/scrub/scrub.h
index fccd82f2..023069ee 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -33,6 +33,7 @@ bool can_scrub_attr(struct scrub_ctx *ctx);
 bool can_scrub_symlink(struct scrub_ctx *ctx);
 bool can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
+bool can_force_rebuild(struct scrub_ctx *ctx);
 
 int scrub_file(struct scrub_ctx *ctx, int fd, const struct xfs_bulkstat *bstat,
 		unsigned int type, struct action_list *alist);
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 7a0411b0..597be59f 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -157,6 +157,9 @@ bool				stdout_isatty;
  */
 bool				is_service;
 
+/* Set to true if the kernel supports XFS_SCRUB_IFLAG_FORCE_REBUILD */
+bool				use_force_rebuild;
+
 #define SCRUB_RET_SUCCESS	(0)	/* no problems left behind */
 #define SCRUB_RET_CORRUPT	(1)	/* corruption remains on fs */
 #define SCRUB_RET_UNOPTIMIZED	(2)	/* fs could be optimized */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index f6712d36..0d6b9dad 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -21,6 +21,7 @@ extern bool			want_fstrim;
 extern bool			stderr_isatty;
 extern bool			stdout_isatty;
 extern bool			is_service;
+extern bool			use_force_rebuild;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,

