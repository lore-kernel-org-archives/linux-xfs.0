Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79DA6FB0
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610499; cv=none; b=dmzz36SOP/PEdZTtSMVr1OgObqqfWhwdEWl5eaD89WCQdD9lq05mSmMmqXxF1dAuDGUZNmnIQZq9LOiGR1otWhm/Gw9PoXx+pZYYLLZLzygJdP4v/Y5GMAxur9dqG0Vto1nhJyhhanq88qVsOqiJsnwKrKygPAnh5LlT1qgcOUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610499; c=relaxed/simple;
	bh=6PczHyDWFVpdry7Fh0Hl3UUtBfEm4AH1hMpXiXXJlZc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hHpQVoamqkoxTfhHqZwaytbiKAuUSN4OwkQHyyP5YoEW7h23Q3458i61yczIYsbEj0s7vxrKEbpPsxdK+4QXzo2dzMRqY+Jrkgr+NDhzi5QCnU7uP0tUaP4x9oIAJtCDqYDwKEivWS8lhDO2FOnpaBx+Lze0G26TBPvKOW9vgUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6caKZJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6caKZJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46C1C4CEC5;
	Fri, 11 Oct 2024 01:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610499;
	bh=6PczHyDWFVpdry7Fh0Hl3UUtBfEm4AH1hMpXiXXJlZc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G6caKZJRVsFYpQsdfa2LHsHBFG/bUHW2NtP3kvELpfOUkokREdJWckyaujK1+xtde
	 ULhMK9ixvkdcunihJuSK6XQHmuu5KVJ3vd5JFMq1cW8zt+E61HuJ5S+FtZNo+Iy58r
	 NUCX1jVlxfthO/M76+HeZ2WTwflE056lM3TWzJG7+H/uycd7H+val3NN7NX1BkMGZ7
	 eiuAVY7eqQYOH4on4vEmAx/rIYgz0Om1pAvh51IKlLtowE4WvZvcEOkm/GeKV4A+CZ
	 u9K1t9QVuv6lmWl/71Xc7PnPk2WFUbgQ358Z+iSVclqVRsg0BBSQjKDC+uv7eyPUqx
	 sHJUcguBhNO9g==
Date: Thu, 10 Oct 2024 18:34:59 -0700
Subject: [PATCH 40/43] xfs_scrub: trim realtime volumes too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655979.4184637.11740469659177574622.stgit@frogsfrogsfrogs>
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

On the kernel side, the XFS realtime groups patchset added support for
FITRIM of the realtime volume.  This support doesn't actually require
there to be any realtime groups, so teach scrub to run through the whole
region.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 1c88460c33962b..adb177ecdafbeb 100644
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
@@ -193,7 +196,8 @@ fstrim_datadev(
 		 */
 		progress_add(geo->blocksize);
 		fsbcount = min(geo->datablocks - fsbno, geo->agblocks);
-		error = fstrim_fsblocks(ctx, fsbno, fsbcount, minlen_fsb);
+		error = fstrim_fsblocks(ctx, fsbno, fsbcount, minlen_fsb,
+				false);
 		if (error)
 			return error;
 	}
@@ -201,15 +205,35 @@ fstrim_datadev(
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
@@ -223,6 +247,8 @@ phase8_estimate(
 	if (fstrim_ok(ctx)) {
 		*items = cvt_off_fsb_to_b(&ctx->mnt,
 				ctx->mnt.fsgeom.datablocks);
+		*items += cvt_off_fsb_to_b(&ctx->mnt,
+				ctx->mnt.fsgeom.rtblocks);
 	} else {
 		*items = 0;
 	}

