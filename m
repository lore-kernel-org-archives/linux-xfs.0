Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36D286334
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781346; cv=none; b=NIdh6SOZp+MhgU/S2sOVIEtgZ0RCX3cXh4rABSJ2cEwlTCkFprr8QkELHdTwCSEF5FohINazUxoOQqtRQGfU4oVk+WudKg5ORwaKG4R2SCU7wCRvmDoKlx8mAGzbyD9lCWW1uA9P/uJwASjMJoGiNydHYxkHNXv68lGTJtn+Dm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781346; c=relaxed/simple;
	bh=yMnNfsBhV5gcWSPx2UEcKAXh/e/LDPzgQHSw+nAIJt4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uNj5D0rrlfCZTRT424QShgLP3axH+6mtaLOK5frWiu6k2EpuADegocKUap1XJ43BnYCNz9TYibVksLAR0OILTT3WJtHobQuUNiKIF4ukvlFPJjIPrMGCZ6nHZ+jDMbc9JnKkW+OTHsxw2CfKBfjqIYkJvmpF6Vl8bG97TvyfZ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yxp+QtSI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yxp+QtSI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 833741F000E9;
	Tue, 30 Jun 2026 01:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781344;
	bh=OJ5BDYqZAJyVjXSviMLWOq7DLepcI5QCoaWfraUK+YQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Yxp+QtSIRenwi2jB6so5qB9gWbDXYXuloN0QZxvPR0UQwt96NBJk8i5IRVXb+Sywc
	 UiodfRJh0f382S5qC+Kp6ZzgQsk62egGctMfCpTw72FGhog51vYfNrr4RqvEWULWoc
	 u8KC9yC1ttFgdk7qtVpKtG+AYHVIfyeOA/UVpFyb1P4WASrqhjGc8nWOieimKGuv/3
	 1E5jiSzK1yY8zcCVxRvASVb+Xo07bLV0AVdFfZO3foYkpzE8GACrlTbJVd+jAxUyyt
	 C2AnSk8o2JdUlbUG7CmE81EqJ/nSrNmjWbvdvBlKyxwVctg9RnJRm4xT2+JiRnzT80
	 tj7BKzmOSZwEA==
Date: Mon, 29 Jun 2026 18:02:24 -0700
Subject: [PATCH 1/2] xfs_scrub: fix spacemap external log device scan dev key
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129564.858187.17386795461050444922.stgit@frogsfrogsfrogs>
In-Reply-To: <178278129539.858187.11646178692582297659.stgit@frogsfrogsfrogs>
References: <178278129539.858187.11646178692582297659.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex bizarrely complains about the rtstart>0 logic in scan_log_rmaps,
because it gets confused about the difference between internal logs
(which are scanned by scan_ag_rmaps) and external logs, which this
function handles.  I'm ignoring the report, but we shouldn't open-code
the synthetic device keys so let's fix that by hoisting the fsmap device
helpers from phase6.c to spacemap.h and using them everywhere.

Cc: <linux-xfs@vger.kernel.org> # v6.15.0
Fixes: 37591ef3f4f14c ("xfs_scrub: support internal RT device")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/spacemap.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 scrub/phase6.c   |   42 ------------------------------------------
 scrub/phase7.c   |   11 +----------
 scrub/spacemap.c |   17 +++++------------
 4 files changed, 48 insertions(+), 64 deletions(-)


diff --git a/scrub/spacemap.h b/scrub/spacemap.h
index 759d0f89089a23..0d85285f29ede9 100644
--- a/scrub/spacemap.h
+++ b/scrub/spacemap.h
@@ -23,4 +23,46 @@ static inline unsigned int scrub_scan_spacemaps_nproc(struct scrub_ctx *ctx)
 	return scrub_nproc(ctx);
 }
 
+/* Return XFS device index from fsmap device. */
+static inline enum xfs_device
+from_fsmap_dev(
+	struct scrub_ctx	*ctx,
+	dev_t			dev)
+{
+	if (ctx->mnt.fsgeom.rtstart) {
+		if (dev < XFS_DEV_DATA || dev > XFS_DEV_RT)
+			abort();
+		return dev;
+	}
+
+	if (dev == ctx->fsinfo.fs_datadev)
+		return XFS_DEV_DATA;
+	if (dev == ctx->fsinfo.fs_logdev)
+		return XFS_DEV_LOG;
+	if (dev == ctx->fsinfo.fs_rtdev)
+		return XFS_DEV_RT;
+	abort();
+}
+
+/* Return fsmap device for XFS device index. */
+static inline uint32_t
+to_fsmap_dev(
+	struct scrub_ctx	*ctx,
+	enum xfs_device		dev)
+{
+	if (ctx->mnt.fsgeom.rtstart)
+		return dev;
+
+	switch (dev) {
+	case XFS_DEV_DATA:
+		return ctx->fsinfo.fs_datadev;
+	case XFS_DEV_LOG:
+		return ctx->fsinfo.fs_logdev;
+	case XFS_DEV_RT:
+		return ctx->fsinfo.fs_rtdev;
+	default:
+		abort();
+	}
+}
+
 #endif /* XFS_SCRUB_SPACEMAP_H_ */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index aef817add4157b..c562a07666516b 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -45,48 +45,6 @@ struct media_verify_state {
 	struct read_verify_pool	*rvp[XFS_DEV_RT + 1];
 };
 
-/* Return XFS device index from fsmap device. */
-static enum xfs_device
-from_fsmap_dev(
-	struct scrub_ctx	*ctx,
-	dev_t			dev)
-{
-	if (ctx->mnt.fsgeom.rtstart) {
-		if (dev < XFS_DEV_DATA || dev > XFS_DEV_RT)
-			abort();
-		return dev;
-	}
-
-	if (dev == ctx->fsinfo.fs_datadev)
-		return XFS_DEV_DATA;
-	if (dev == ctx->fsinfo.fs_logdev)
-		return XFS_DEV_LOG;
-	if (dev == ctx->fsinfo.fs_rtdev)
-		return XFS_DEV_RT;
-	abort();
-}
-
-/* Return fsmap device for XFS device index. */
-static uint32_t
-to_fsmap_dev(
-	struct scrub_ctx	*ctx,
-	enum xfs_device		dev)
-{
-	if (ctx->mnt.fsgeom.rtstart)
-		return dev;
-
-	switch (dev) {
-	case XFS_DEV_DATA:
-		return ctx->fsinfo.fs_datadev;
-	case XFS_DEV_LOG:
-		return ctx->fsinfo.fs_logdev;
-	case XFS_DEV_RT:
-		return ctx->fsinfo.fs_rtdev;
-	default:
-		abort();
-	}
-}
-
 struct disk_ioerr_report {
 	struct scrub_ctx	*ctx;
 	enum xfs_device		dev;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 375ba0632c353b..d741865295d043 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -70,19 +70,10 @@ count_block_summary(
 	void			*arg)
 {
 	struct summary_counts	*counts;
-	enum xfs_device		dev;
+	enum xfs_device		dev = from_fsmap_dev(ctx, fsmap->fmr_device);
 	unsigned long long	len;
 	int			ret;
 
-	if (ctx->mnt.fsgeom.rtstart)
-		dev = fsmap->fmr_device;
-	else if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
-		dev = XFS_DEV_LOG;
-	else if (fsmap->fmr_device == ctx->fsinfo.fs_rtdev)
-		dev = XFS_DEV_RT;
-	else
-		dev = XFS_DEV_DATA;
-
 	counts = ptvar_get((struct ptvar *)arg, &ret);
 	if (ret) {
 		str_liberror(ctx, -ret, _("retrieving summary counts"));
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 8f595ad94c5991..45ac61d0942ccb 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -103,10 +103,7 @@ scan_ag_rmaps(
 	bperag = (off_t)ctx->mnt.fsgeom.agblocks *
 		 (off_t)ctx->mnt.fsgeom.blocksize;
 
-	if (ctx->mnt.fsgeom.rtstart)
-		keys[0].fmr_device = XFS_DEV_DATA;
-	else
-		keys[0].fmr_device = ctx->fsinfo.fs_datadev;
+	keys[0].fmr_device = to_fsmap_dev(ctx, XFS_DEV_DATA);
 	keys[0].fmr_physical = agno * bperag;
 	keys[1].fmr_device = keys[0].fmr_device;
 	keys[1].fmr_physical = ((agno + 1) * bperag) - 1;
@@ -143,10 +140,7 @@ scan_rtg_rmaps(
 	off_t			bperrg = bytes_per_rtgroup(&ctx->mnt.fsgeom);
 	int			ret;
 
-	if (ctx->mnt.fsgeom.rtstart)
-		keys[0].fmr_device = XFS_DEV_RT;
-	else
-		keys[0].fmr_device = ctx->fsinfo.fs_rtdev;
+	keys[0].fmr_device = to_fsmap_dev(ctx, XFS_DEV_RT);
 	keys[0].fmr_physical = (xfs_rtblock_t)rgno * bperrg;
 	keys[1].fmr_device = keys[0].fmr_device;
 	keys[1].fmr_physical = ((rgno + 1) * bperrg) - 1;
@@ -210,10 +204,10 @@ scan_rt_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, ctx->fsinfo.fs_rtdev, arg);
+	scan_dev_rmaps(ctx, to_fsmap_dev(ctx, XFS_DEV_RT), arg);
 }
 
-/* Iterate all the reverse mappings of the log device. */
+/* Iterate all the reverse mappings of the external log device. */
 static void
 scan_log_rmaps(
 	struct workqueue	*wq,
@@ -222,8 +216,7 @@ scan_log_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, ctx->mnt.fsgeom.rtstart ? 2 : ctx->fsinfo.fs_logdev,
-			arg);
+	scan_dev_rmaps(ctx, to_fsmap_dev(ctx, XFS_DEV_LOG), arg);
 }
 
 /*

