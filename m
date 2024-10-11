Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAB4E56C
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610484; cv=none; b=k7UlU5ue1mLIxU1ihbWl7M+HMNIJKMh+z0C2l7Zz09gMhqZHMxG/StDo2OwzoRZ0nv1ewuVUEx/iyqTq7VsLMkymraC9+uh4uxVZSPLKHzx1k9sHz5hGt6Yhv9Yso7fLQCzio5BvWKYAlkHGpwaHFrqsw9GoETlli4iYgt4Jc0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610484; c=relaxed/simple;
	bh=oibpk91hle7pdGsqXM3lNmqVgnqHaLD8N76BKyQqtdA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aX3fdYweHLWnVxaI2d9fehjuIL493WlmxkhsAjXsrX9n8ZGTDNI25Bk+KJ4je1r2rNr5FX+yD9AXStfdxYGGRtT+mVEEd0449L9O/ONlTiRlBPLjtJiuAbDc9KP4UeqGngL+b+iJmqRbV6oKGbkF2lhQwSzvs350um4B+fBDYIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srbbGabn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srbbGabn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37D5C4CEC5;
	Fri, 11 Oct 2024 01:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610484;
	bh=oibpk91hle7pdGsqXM3lNmqVgnqHaLD8N76BKyQqtdA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=srbbGabnwPiuRSdCKid9r8ggqXPC1f30MlzH5K8X3cInZI8ocUZI/1f2g2t607MoT
	 P6CIsUswL9xTZ0kZIjHim9LhzszRge6+iZdTSCkCdNSkcE4LYwgZb5ynbo3vvU+dRI
	 c11f9L+ALMG2phtYowaamQdIrAxSqBRY6O7VvIb0qBRALrMvR0sgwnZf/T8QaMWQcW
	 u4QEAlJAPtdLVnn5z24k3FDSBEdC17opQqPwUk3iUxlWvWayAWVrdTcb/WYREizru8
	 HS5DSFea8yxEpXmz0wK3Fv83PSz26TmwuspEwg3iVFTsycEYZRjfJ+bm0sWKrjUWWT
	 3ZwD/xNjTNJSw==
Date: Thu, 10 Oct 2024 18:34:43 -0700
Subject: [PATCH 39/43] xfs_scrub: call GETFSMAP for each rt group in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655964.4184637.5523079884832597347.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

If realtime groups are enabled, we should take advantage of the sharding
to speed up the spacemap scans.  Do so by issuing per-rtgroup GETFSMAP
calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/spacemap.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 8 deletions(-)


diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index e35756db2eed43..5b6bad138ce502 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -128,6 +128,45 @@ scan_ag_rmaps(
 	}
 }
 
+/* Iterate all the reverse mappings of a realtime group. */
+static void
+scan_rtg_rmaps(
+	struct workqueue	*wq,
+	xfs_agnumber_t		rgno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct scan_blocks	*sbx = arg;
+	struct fsmap		keys[2];
+	off_t			bperrg = bytes_per_rtgroup(&ctx->mnt.fsgeom);
+	int			ret;
+
+
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = ctx->fsinfo.fs_rtdev;
+	keys->fmr_physical = (xfs_rtblock_t)rgno * bperrg;
+	(keys + 1)->fmr_device = ctx->fsinfo.fs_rtdev;
+	(keys + 1)->fmr_physical = ((rgno + 1) * bperrg) - 1;
+	(keys + 1)->fmr_owner = ULLONG_MAX;
+	(keys + 1)->fmr_offset = ULLONG_MAX;
+	(keys + 1)->fmr_flags = UINT_MAX;
+
+	if (sbx->aborted)
+		return;
+
+	ret = scrub_iterate_fsmap(ctx, keys, sbx->fn, sbx->arg);
+	if (ret) {
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, DESCR_BUFSZ, _("dev %d:%d rtgroup %u fsmap"),
+					major(ctx->fsinfo.fs_datadev),
+					minor(ctx->fsinfo.fs_datadev),
+					rgno);
+		str_liberror(ctx, ret, descr);
+		sbx->aborted = true;
+	}
+}
+
 /* Iterate all the reverse mappings of a standalone device. */
 static void
 scan_dev_rmaps(
@@ -208,14 +247,6 @@ scrub_scan_all_spacemaps(
 		str_liberror(ctx, ret, _("creating fsmap workqueue"));
 		return ret;
 	}
-	if (ctx->fsinfo.fs_rt) {
-		ret = -workqueue_add(&wq, scan_rt_rmaps, 0, &sbx);
-		if (ret) {
-			sbx.aborted = true;
-			str_liberror(ctx, ret, _("queueing rtdev fsmap work"));
-			goto out;
-		}
-	}
 	if (ctx->fsinfo.fs_log) {
 		ret = -workqueue_add(&wq, scan_log_rmaps, 0, &sbx);
 		if (ret) {
@@ -232,6 +263,31 @@ scrub_scan_all_spacemaps(
 			break;
 		}
 	}
+	if (ctx->fsinfo.fs_rt) {
+		for (agno = 0; agno < ctx->mnt.fsgeom.rgcount; agno++) {
+			ret = -workqueue_add(&wq, scan_rtg_rmaps, agno, &sbx);
+			if (ret) {
+				sbx.aborted = true;
+				str_liberror(ctx, ret,
+						_("queueing rtgroup fsmap work"));
+				break;
+			}
+		}
+
+		/*
+		 * If the fs doesn't have any realtime groups, scan the entire
+		 * volume all at once, since the above loop did nothing.
+		 */
+		if (ctx->mnt.fsgeom.rgcount == 0) {
+			ret = -workqueue_add(&wq, scan_rt_rmaps, 0, &sbx);
+			if (ret) {
+				sbx.aborted = true;
+				str_liberror(ctx, ret,
+						_("queueing rtdev fsmap work"));
+				goto out;
+			}
+		}
+	}
 out:
 	ret = -workqueue_terminate(&wq);
 	if (ret) {

