Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108FAC140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhPTzZ0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6F0C433C8;
	Sun, 31 Dec 2023 23:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063625;
	bh=AZovp/KnxBVwYvU2ATVGT6OvRMDjsLYHTABKSM85VFw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FhPTzZ0sHex0RphP3Rr6Rh8Z+3cttdxSQOUMovOSINIE0EBbM3MU2lbBGesWnrhE3
	 sy4QhdxhTKGnPiULYYge28sY5MImNOd+ViA0Y0YIJ9BcOktsHBIu+AyXOOKevQuAvd
	 khxjzuWtGGa23tREjhTeqpOE0G3BMvk2Pblb+4py0Cez9om0hnC7FsVT63WJxi/5bJ
	 RuRlw67rqqnDQ/EGp3qNjIKY2pkpxG/Ay2JEHg1Q6gmqnJhmMuDnlyeNQX64PWH/Dk
	 w7GDCVQ8t2Nj2FpT3FrnpQXbNIyeZLLjIjQCw8m3dEtSLOJqckV1oW2R2MgxvNTJRE
	 hOoBlo8xZoQ+g==
Date: Sun, 31 Dec 2023 15:00:25 -0800
Subject: [PATCH 1/3] xfs_scrub: automatic downgrades to dry-run mode in
 service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003726.1801869.1123213107844575319.stgit@frogsfrogsfrogs>
In-Reply-To: <170405003711.1801869.9864337837460047947.stgit@frogsfrogsfrogs>
References: <170405003711.1801869.9864337837460047947.stgit@frogsfrogsfrogs>
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

When service mode is enabled, xfs_scrub is being run within the context
of a systemd service.  The service description language doesn't have any
particularly good constructs for adding in a '-n' argument if the
filesystem is readonly, which means that xfs_scrub is passed a path, and
needs to switch to dry-run mode on its own if the fs is mounted
readonly or the kernel doesn't support repairs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |   13 +++++++++++++
 scrub/repair.c |   33 +++++++++++++++++++++++++++++++++
 scrub/repair.h |    2 ++
 3 files changed, 48 insertions(+)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 516d929d626..095c045915a 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -216,6 +216,19 @@ _("Kernel metadata scrubbing facility is not available."));
 		return ECANCELED;
 	}
 
+	/*
+	 * Normally, callers are required to pass -n if the provided path is a
+	 * readonly filesystem or the kernel wasn't built with online repair
+	 * enabled.  However, systemd services are not scripts and cannot
+	 * determine either of these conditions programmatically.  Change the
+	 * behavior to dry-run mode if either condition is detected.
+	 */
+	if (repair_want_service_downgrade(ctx)) {
+		str_info(ctx, ctx->mntpoint,
+_("Filesystem cannot be repaired in service mode, downgrading to dry-run mode."));
+		ctx->mode = SCRUB_MODE_DRY_RUN;
+	}
+
 	/* Do we need kernel-assisted metadata repair? */
 	if (ctx->mode != SCRUB_MODE_DRY_RUN && !can_repair(ctx)) {
 		str_error(ctx, ctx->mntpoint,
diff --git a/scrub/repair.c b/scrub/repair.c
index 19f5c9052af..2883f98af4a 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -45,6 +45,39 @@ static const unsigned int repair_deps[XFS_SCRUB_TYPE_NR] = {
 };
 #undef DEP
 
+/*
+ * Decide if we want an automatic downgrade to dry-run mode.  This is only
+ * for service mode, where we are fed a path and have to figure out if the fs
+ * is repairable or not.
+ */
+bool
+repair_want_service_downgrade(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_metadata	meta = {
+		.sm_type		= XFS_SCRUB_TYPE_PROBE,
+		.sm_flags		= XFS_SCRUB_IFLAG_REPAIR,
+	};
+	int				error;
+
+	if (ctx->mode == SCRUB_MODE_DRY_RUN)
+		return false;
+	if (!is_service)
+		return false;
+	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
+		return false;
+
+	error = -xfrog_scrub_metadata(&ctx->mnt, &meta);
+	switch (error) {
+	case EROFS:
+	case ENOTRECOVERABLE:
+	case EOPNOTSUPP:
+		return true;
+	}
+
+	return false;
+}
+
 /* Repair some metadata. */
 static int
 xfs_repair_metadata(
diff --git a/scrub/repair.h b/scrub/repair.h
index a685e90374c..411a379f6fa 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -102,4 +102,6 @@ repair_item_completely(
 	return repair_item(ctx, sri, XRM_FINAL_WARNING | XRM_NOPROGRESS);
 }
 
+bool repair_want_service_downgrade(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_REPAIR_H_ */

