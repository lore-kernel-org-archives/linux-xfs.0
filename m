Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8878C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJKQZqhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A55AC433C8;
	Sun, 31 Dec 2023 23:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067189;
	bh=CEtZTmxbVAnZ3Tro47FeozPEYk5JuFhbBny8eSRccJg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VJKQZqhBR+e24Lx6P3lvmYyxWRRpggQoCd5R8dj5TcLYoVbQ+YEbAN+G6Pe0SBmX9
	 Evq2tzIR7hV8gxzKz2CxyhPZWGroBHtau3UJCiRsZUWjXeWMokQXyXd68ea5uGYNYp
	 Uwl96HF6KlrcKAaIyujq88bqTlCVY2q6NsGPWEje5AHFuOJkc2U/KDSyLXiOn2UGKW
	 tpxyg16BKHpkr/5sd6VD/SoR/PJFnO7YQkMtI96sVCbunitqedSctTMIm6aJuhFBsv
	 S78z0a40ng6TD8SHndBgxWOboOytYgEM6Ulc+8/xnI0IKpRJ3R9iKjrptSGjWA0iY/
	 FI6qG9mU6Yeqg==
Date: Sun, 31 Dec 2023 15:59:49 -0800
Subject: [PATCH 47/52] xfs_scrub: call GETFSMAP for each rt group in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012791.1811243.12452550709925000648.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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
 scrub/spacemap.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 66 insertions(+), 8 deletions(-)


diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index f20ecfeac5d..8796cb115ea 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -128,6 +128,47 @@ scan_ag_rmaps(
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
+	off64_t			bperrg;
+	int			ret;
+
+	bperrg = (off64_t)ctx->mnt.fsgeom.rgblocks *
+		 (off64_t)ctx->mnt.fsgeom.blocksize;
+
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = ctx->fsinfo.fs_rtdev;
+	keys->fmr_physical = rgno * bperrg;
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
@@ -208,14 +249,6 @@ scrub_scan_all_spacemaps(
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
@@ -232,6 +265,31 @@ scrub_scan_all_spacemaps(
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

