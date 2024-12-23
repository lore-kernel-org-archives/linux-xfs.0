Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745C9433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992642; cv=none; b=gkCM3xt8J5yW/P0QPm+YC5/eXuWJQsnlEBYy13Z07p9vXrfx+HEpeSBt6YwxFkG6GJYVtvnKexs/I4iUzWg5OL5ttbhX7Vxgqxhi50tjPwrTTvF+/mkLdFXfI2//tSwYYzHQ/ivM6M+Rn1WXyQy04Pl12SOZReJzDYki75lFPso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992642; c=relaxed/simple;
	bh=5arHIO5FYw3NIDGwznHiIzkWGILViZCCfyBsirXkypM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l16NOoD9pobPY9aQcx286jTeZXCNkCxRQHbJcbesmhJCNVHiT75e8FSYAWYBsTPZlsKpP4bzANtdMPwFZ5SZTGI+ix+Ky66QiNaoWQXyzaCrIixOCn2P3OQo2nXHzAg3nrz7q3EjEQHtDy+Il+MnqoIaC3x6zSA9XLwH8bIKwbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTy3feko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTy3feko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7529C4CED3;
	Mon, 23 Dec 2024 22:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992642;
	bh=5arHIO5FYw3NIDGwznHiIzkWGILViZCCfyBsirXkypM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XTy3fekoddPN98Sy8MDs3W1mir4fzIbR+4uO2p3X5vGIQYqfVagxE/BENSRns+xql
	 CdAIQrVCJEveimA61/lj6ZylUqoWoEPH3Ha6+GZTKNdw2ysVbL1dNBl0UFft/Qj6F7
	 BJiKuH5+QfO/kTjYaOapVY6fUckbwgz2o7sIG4DtHl9Ik8aRFjd6B1S4z40Y+MGPUO
	 Knh+xBd5X88kWMA9RUmFZNBcRArs1P0pgWEfFrBFVMiPmzF6WLvP38xLtRx+6D0k91
	 vFuaXnee56YzjAu0/U0lTkVwzmqTlkA4WGr892WdLvxUg4lRVw697W3dumadspgxa2
	 ThHVE72ZQZfLg==
Date: Mon, 23 Dec 2024 14:24:01 -0800
Subject: [PATCH 47/51] xfs_scrub: call GETFSMAP for each rt group in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944523.2297565.11470905301916508239.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/spacemap.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 62 insertions(+), 8 deletions(-)


diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 4b7fae252d86ca..c293ab44a5286c 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -127,6 +127,43 @@ scan_ag_rmaps(
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
+	struct fsmap		keys[2] = { };
+	off_t			bperrg = bytes_per_rtgroup(&ctx->mnt.fsgeom);
+	int			ret;
+
+	keys[0].fmr_device = ctx->fsinfo.fs_rtdev;
+	keys[0].fmr_physical = (xfs_rtblock_t)rgno * bperrg;
+	keys[1].fmr_device = ctx->fsinfo.fs_rtdev;
+	keys[1].fmr_physical = ((rgno + 1) * bperrg) - 1;
+	keys[1].fmr_owner = ULLONG_MAX;
+	keys[1].fmr_offset = ULLONG_MAX;
+	keys[1].fmr_flags = UINT_MAX;
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
@@ -206,14 +243,6 @@ scrub_scan_all_spacemaps(
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
@@ -230,6 +259,31 @@ scrub_scan_all_spacemaps(
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

