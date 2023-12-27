Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC082C2C5
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7znppzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E30C433C8;
	Mon,  1 Jan 2024 00:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067205;
	bh=2xN+H+zHPOKBKqLTQds9f4vNvv9zXtSfL+UTZB9k2fQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n7znppznpvJlp7ocBDsMW1/Hy2E6MAF80rR/a2iPdJzAR/jJSDfXHUjnltjBbusmb
	 Or/9nXDai6wkcK8nbyYOJwm69V5Zj1/vZlUIoBrG1vJVV8SGT+QchUPf/33xf3jCni
	 VlfV7HZFBggETWfSRH/OIazMt/Av309MjHEtKrXasi799QQ9K7hYDvQi7aw5mUDV+F
	 agO5Sb3lepG3ag/OIrhQjsnaGRlQ4liu33LRd0PxSNPDP024k0tXOBC57zkg78tGA8
	 3BufYtzaD3WggPJCZpmsU+WhpQ9qVRiMiFkUIsmYgg5iJaN9VUK8VvxhIXjN89J7Rs
	 UChSQpb0tKqlQ==
Date: Sun, 31 Dec 2023 16:00:04 +9900
Subject: [PATCH 48/52] xfs_scrub: trim realtime volumes too
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012804.1811243.5944991241260262167.stgit@frogsfrogsfrogs>
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

On the kernel side, the XFS realtime groups patchset added support for
FITRIM of the realtime volume.  This support doesn't actually require
there to be any realtime groups, so teach scrub to run through the whole
region.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index c6845555579..25d1ec3693e 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -59,7 +59,8 @@ fstrim_fsblocks(
 	struct scrub_ctx	*ctx,
 	uint64_t		start_fsb,
 	uint64_t		fsbcount,
-	uint64_t		minlen_fsb)
+	uint64_t		minlen_fsb,
+	bool			ignore_einval)
 {
 	uint64_t		start = cvt_off_fsb_to_b(&ctx->mnt, start_fsb);
 	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
@@ -72,6 +73,8 @@ fstrim_fsblocks(
 		run = min(len, FSTRIM_MAX_BYTES);
 
 		error = fstrim(ctx, start, run, minlen);
+		if (error == EINVAL && ignore_einval)
+			error = EOPNOTSUPP;
 		if (error == EOPNOTSUPP) {
 			/* Pretend we finished all the work. */
 			progress_add(len);
@@ -177,7 +180,8 @@ fstrim_datadev(
 		 */
 		progress_add(geo->blocksize);
 		fsbcount = min(geo->datablocks - fsbno + 1, geo->agblocks);
-		error = fstrim_fsblocks(ctx, fsbno + 1, fsbcount, minlen_fsb);
+		error = fstrim_fsblocks(ctx, fsbno + 1, fsbcount, minlen_fsb,
+				false);
 		if (error)
 			return error;
 	}
@@ -185,15 +189,35 @@ fstrim_datadev(
 	return 0;
 }
 
+/* Trim the realtime device. */
+static int
+fstrim_rtdev(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_fsop_geom	*geo = &ctx->mnt.fsgeom;
+
+	/*
+	 * The fstrim ioctl pretends that the realtime volume is in the address
+	 * space immediately after the data volume.  Ignore EINVAL if someone
+	 * tries to run us on an older kernel.
+	 */
+	return fstrim_fsblocks(ctx, geo->datablocks, geo->rtblocks, 0, true);
+}
+
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
 	struct scrub_ctx	*ctx)
 {
+	int			error;
+
 	if (!fstrim_ok(ctx))
 		return 0;
 
-	return fstrim_datadev(ctx);
+	error = fstrim_datadev(ctx);
+	if (error)
+		return error;
+	return fstrim_rtdev(ctx);
 }
 
 /* Estimate how much work we're going to do. */
@@ -207,6 +231,8 @@ phase8_estimate(
 	if (fstrim_ok(ctx)) {
 		*items = cvt_off_fsb_to_b(&ctx->mnt,
 				ctx->mnt.fsgeom.datablocks);
+		*items += cvt_off_fsb_to_b(&ctx->mnt,
+				ctx->mnt.fsgeom.rtblocks);
 	} else {
 		*items = 0;
 	}

