Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFCB9449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882563; cv=none; b=nN0obY5PeNBe6USrkR4WbOvSNLeCugsDuqFCOqwhG565jwNgHG8Hy2BpWNmL+n5UIGw3ykIWk0HgfRqEQJWbBY90od37yYLsNOXr/ou94uPBl2d96ekow67i2/gHAlx56CNd6WEIg+d4+HsBSrQnlzkZmRnr+ifdUR0GxeMwIy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882563; c=relaxed/simple;
	bh=C063k6+XDbR3spQkrqxf6rxZ3QaGatcs1/1WBH4rJmQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vmun1VxwkkExpcU70gAnZVP4Rqkl4wuNVYDT5/mwzgIXWo/u9BQDxV+9PvinKj0uT1HxhGMxJwaIK1J/JhguBPP9TudPuXsqSs9sN3Eo8MMaR851ckJYDt4n8FjQWhLADrW1qtcx2Brg9B1Y24A4r+uCsYerHrxdOBAVgaZ9Jz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sBEww7XB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sBEww7XB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37ACC116B1;
	Tue,  2 Jul 2024 01:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882563;
	bh=C063k6+XDbR3spQkrqxf6rxZ3QaGatcs1/1WBH4rJmQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sBEww7XBmXxkawStKGhmDqQDdysxDvncjekOknZIhHcUNkw6mI8jmvj8Sl3wIouNA
	 ObfpwzNgeAAHoVgSi2LLWxIQ4vMpBlo6wN64K5ciLszbttYue4BlI9RVx2ocYXyZYi
	 MoKs9MtRyFuaJwYwTKV+C5ZsCyBWDql69J6IBEN10eIQ4tIF/D1SWc8vEsGXXishdB
	 wvWSacBhQ9jpHhZLErOtAD3HBEG8Digu0qWs4Rfb3KUxbG05TFbBvIYcSLGa5lUV7X
	 eqR5SXTH5AM9qYYABtYCwJ/6X5P5nfJvdWdLdDBqEvQlXGZaajhXmuiGAAbPi7AQ7B
	 noNmzqfhpGUOQ==
Date: Mon, 01 Jul 2024 18:09:23 -0700
Subject: [PATCH 1/3] xfs_scrub: automatic downgrades to dry-run mode in
 service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988120228.2008941.5724994724680390658.stgit@frogsfrogsfrogs>
In-Reply-To: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
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
index 516d929d6268..095c045915a7 100644
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
index 19f5c9052aff..2883f98af4ab 100644
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
index a685e90374cb..411a379f6faa 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -102,4 +102,6 @@ repair_item_completely(
 	return repair_item(ctx, sri, XRM_FINAL_WARNING | XRM_NOPROGRESS);
 }
 
+bool repair_want_service_downgrade(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_REPAIR_H_ */

