Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050CE10E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895658; cv=none; b=oXyaSyh6OkoR5MfvWk16cwvBClPfWBuBFsb1HwmsokQm/C7Qc2aPZGqekkBTxtpipjWtGarnGO0HzK6scS7G6viOupJH73eCz7UVo1upc5bWnKXOQb8HwzVBKnPC94gAsS82ueJikedSzXZn5U2FNLDvQd11k7NiwTOvxehAyL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895658; c=relaxed/simple;
	bh=E9/rtuQ5WpZLXQfE773J6V/E4gCM5Ni6zgFSwOpee7c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vf0hPCZZtBt0xhnI2ZO4oWJBGP1yM7wJbEtn57DKJfw+DGrCdvMK6jvwty+Zo1keXH4R4QJ3cS0JD2UwTM8s5p6PpxFkGM5I2M0ZNcFGof2nsrC4jiEOSOBmpKTWnBZXAKJTvGfH49l61N3+lfMrQuFHV5Hknh6vVptc1ji2syg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nVIRHLKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nVIRHLKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FBEC19425;
	Thu, 19 Mar 2026 04:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895657;
	bh=E9/rtuQ5WpZLXQfE773J6V/E4gCM5Ni6zgFSwOpee7c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nVIRHLKGK9wH3U8LsvoctlMkjhGsOvsTzGtSIHql1/0H7ui1rVyjF/pykQSIsg16y
	 5V4baxoeLokZsyM2XA9TYnKli/wIoWkn2z6H72VEMfYb63y+aCY3M90BEFC9m9jibc
	 1Bmob5PAm0see/w2stqYUA0e9A4Wv4DIoOU1ygHbZWQZ/P/MF2oBXAO74BGgnnVYGy
	 cQtk5P8LEoNAiCpzGUooCoQ5uFS0+REDf78zv/28ch+tO0sqxY72bzy3hQrRsJQbV9
	 rBONzlTcngQoxLpONE2efRBEO4YYxMRo8z+ghFYH/TuRIZYReTGSMYVEVGpBw+V5mO
	 GCGagWDLIeynw==
Date: Wed, 18 Mar 2026 21:47:37 -0700
Subject: [PATCH 08/22] scrub: simplify the read_verify_pool_alloc interface
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389507087.3681140.5576858423381378410.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Don't pass the miniosize as that's always the fs block size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: rebase atop another read verify cleanup]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/read_verify.h |    2 +-
 scrub/phase6.c      |    9 +++------
 scrub/read_verify.c |   12 ++----------
 3 files changed, 6 insertions(+), 17 deletions(-)


diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index 383823c3b5c640..a46244334268de 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -23,7 +23,7 @@ typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
 		int error, void *arg);
 
 int read_verify_pool_alloc(struct scrub_ctx *ctx, struct disk *disk,
-		size_t miniosz, read_verify_ioerr_fn_t ioerr_fn,
+		read_verify_ioerr_fn_t ioerr_fn,
 		struct read_verify_pool **prvp);
 void read_verify_pool_abort(struct read_verify_pool *rvp);
 int read_verify_pool_flush(struct read_verify_pool *rvp);
diff --git a/scrub/phase6.c b/scrub/phase6.c
index a28ebee8e7b272..bfd5659590d603 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -761,16 +761,14 @@ phase6_func(
 		goto out_dbad;
 	}
 
-	ret = read_verify_pool_alloc(ctx, ctx->datadev,
-			ctx->mnt.fsgeom.blocksize, remember_ioerr,
+	ret = read_verify_pool_alloc(ctx, ctx->datadev, remember_ioerr,
 			&vs.rvp_data);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
 		goto out_rbad;
 	}
 	if (ctx->logdev) {
-		ret = read_verify_pool_alloc(ctx, ctx->logdev,
-				ctx->mnt.fsgeom.blocksize, remember_ioerr,
+		ret = read_verify_pool_alloc(ctx, ctx->logdev, remember_ioerr,
 				&vs.rvp_log);
 		if (ret) {
 			str_liberror(ctx, ret,
@@ -779,8 +777,7 @@ phase6_func(
 		}
 	}
 	if (ctx->rtdev) {
-		ret = read_verify_pool_alloc(ctx, ctx->rtdev,
-				ctx->mnt.fsgeom.blocksize, remember_ioerr,
+		ret = read_verify_pool_alloc(ctx, ctx->rtdev, remember_ioerr,
 				&vs.rvp_realtime);
 		if (ret) {
 			str_liberror(ctx, ret,
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 2447ed272734be..128df2be86898b 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -74,14 +74,12 @@ struct read_verify_pool {
  * Create a thread pool to run read verifiers.
  *
  * @disk is the disk we want to verify.
- * @miniosz is the minimum size of an IO to expect (in bytes).
  * @ioerr_fn will be called when IO errors occur.
  */
 int
 read_verify_pool_alloc(
 	struct scrub_ctx		*ctx,
 	struct disk			*disk,
-	size_t				miniosz,
 	read_verify_ioerr_fn_t		ioerr_fn,
 	struct read_verify_pool		**prvp)
 {
@@ -89,13 +87,7 @@ read_verify_pool_alloc(
 	unsigned int			verifier_threads = disk_heads(disk);
 	int				ret;
 
-	/*
-	 * The minimum IO size must be a multiple of the disk sector size
-	 * and a factor of the max io size.
-	 */
-	if (miniosz % disk->d_lbasize)
-		return EINVAL;
-	if (rvp_io_max_size() % miniosz)
+	if (rvp_io_max_size() % ctx->mnt.fsgeom.blocksize)
 		return EINVAL;
 
 	rvp = calloc(1, sizeof(struct read_verify_pool));
@@ -109,7 +101,7 @@ read_verify_pool_alloc(
 	ret = ptcounter_alloc(verifier_threads, &rvp->verified_bytes);
 	if (ret)
 		goto out_buf;
-	rvp->miniosz = miniosz;
+	rvp->miniosz = ctx->mnt.fsgeom.blocksize;
 	rvp->ctx = ctx;
 	rvp->disk = disk;
 	rvp->ioerr_fn = ioerr_fn;

