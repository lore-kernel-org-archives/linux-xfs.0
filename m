Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FC2944E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302269; cv=none; b=G3eF96IiVgNBVdt1D4xSxeb/iOyebysXoSwNwz6ZI5qpui6AnHmK7maPmGMoRENqLrneYhP4uuiGjvG6ltSSPFD+Oe4q4KYDNrzZDABM2NdCV7BS+w3vhTQnIpYzci7jk7tpc/eTPC/kT0Yr+qyhGHf1URrJkAsmWCCIrMsBvQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302269; c=relaxed/simple;
	bh=ZIKmKBHFKAycVsHWnJ7ZX38vm7/9GkgWIXJC6ute17I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lmT4LdAKIoRm1IwgNbBKvUMQVJ9qutIH+aSPb9kw4kmEHOt5DGtV/bGjoXgXLRIpid8taIoerVmT86lKrE++d4xGyTW0IIXOybw+ovkyoMV5/rwEnKwOryLFtO5sx3Mvon9TJEGjCM3y3M9dw1X9bO0u6z5N889psfdG+cocjMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4Y7rpjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4Y7rpjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E49C4AF0B;
	Tue, 30 Jul 2024 01:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302268;
	bh=ZIKmKBHFKAycVsHWnJ7ZX38vm7/9GkgWIXJC6ute17I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q4Y7rpjFkTPlO7nhcJ4t/c6CmnU4XiTipiVFRTYkOZEulVS5vy6Bv8GrA8BSo68vo
	 xG3jiOhLljQ51eSTawMH9bi+Lq145MCmmVqIBvH3n5kur2mSX+FGXqW8L6wDIKDb9D
	 DnxQyZikHHCgKCMS1PUemOWqy8e8iKVMwjrabizMJC8iJooOuiOkcnqCLa67Yhwdpa
	 VMsX8aN9xY9XzURGiHn0wKTpJSqzPImwTSoxiaH3K+jDMsP241bhPQp6f+PC8Vl/jg
	 P5zQTEGW3z8wq0GhUjEm+Kly0rJ4a2ddnMxcuW7JinlxtZXpjFqu8NM6diRdF40r71
	 LTgGJgFzmrrww==
Date: Mon, 29 Jul 2024 18:17:48 -0700
Subject: [PATCH 2/6] xfs_scrub: automatic downgrades to dry-run mode in
 service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172229850085.1350643.9970598031270770152.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
References: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase1.c |   13 +++++++++++++
 scrub/repair.c |   33 +++++++++++++++++++++++++++++++++
 scrub/repair.h |    2 ++
 3 files changed, 48 insertions(+)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 516d929d6..095c04591 100644
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
index 19f5c9052..2883f98af 100644
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
index a685e9037..411a379f6 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -102,4 +102,6 @@ repair_item_completely(
 	return repair_item(ctx, sri, XRM_FINAL_WARNING | XRM_NOPROGRESS);
 }
 
+bool repair_want_service_downgrade(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_REPAIR_H_ */

