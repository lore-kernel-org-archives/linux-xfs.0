Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881E92F9C37
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802093; cv=none; b=siwkVJX/YKU50keWowxCJMwmc8x3F9bpdJeUMmPA3K7cESD7Pew+D6OCWMLsGcvHPAuMrRiMmPOBNAggQoUuvB3ojtmXuxgTrL/fnTTeYX9MXL2pgQKh8bAxx/v7EL1VWvWiBpSa5MjpSPbt7Sd5SGdXV3UZN+5rTFFDvSqIf+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802093; c=relaxed/simple;
	bh=pr1fK1YJ7C5yoH/RvpH6haoFQH94RZeaQ16+P9SUk84=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B+ZVoJtr6F4oyGUuFni+qsmBc2hQ+rpvcLz0gQ2xpXHCYEN9+cO1NmXr4TnZx3lLlSggUb/q6EssSW1Q42QbGbMKadpz3/23FD08c3LwKf79+dC+YaLV0MLLiUFTlmVprkPf45rZYe9Hv711Qq2Hzc2zqlvRGCRB+jpUNwm8qwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uancImvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uancImvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205DCC19421;
	Fri, 10 Apr 2026 06:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802093;
	bh=pr1fK1YJ7C5yoH/RvpH6haoFQH94RZeaQ16+P9SUk84=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uancImvqHI15Zw0384IEFxdPyZXw2S/f5JrsYgTvTvcsLLhxo6ZpvjbcbyUjGz900
	 LjO940/uccpHNj3zfDKLFaVGJKRQoGYSsT69VfGkxWkqGloXQNl07xJ2ExZiVKdOyo
	 HxyuNiQ1n7JrqrJAbTWlNekVEpSX5tumyQ2uET/lbEGgwH8wuF1w+xR77hMxQZmnrW
	 /MquvwB7I04spNOLXZ5v/SwYTypKOy6Ntepolr1H04JZXP3FCjMo0HNCWSwFko85OR
	 ewIqNVVh+T/Pu1LcFHOmBqQ3hYxErmCagri+957pIgvQc3krmfuuLdQLIFaBlemON8
	 rZrd719Jrf1Qw==
Date: Thu, 09 Apr 2026 23:21:32 -0700
Subject: [PATCH 16/21] xfs_scrub: perform media scanning of the log region
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385326.2090237.15850763722882923968.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
References: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Scan the log area for media errors because a defect in a region could
prevent the user from being able to perform log recovery.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/fscounters.h |    2 +-
 scrub/fscounters.c |    4 +++-
 scrub/phase6.c     |   44 ++++++++++++++++++++++++++++++++++++--------
 scrub/phase7.c     |    7 ++++++-
 4 files changed, 46 insertions(+), 11 deletions(-)


diff --git a/scrub/fscounters.h b/scrub/fscounters.h
index a3dd68837027ed..e444c54d902527 100644
--- a/scrub/fscounters.h
+++ b/scrub/fscounters.h
@@ -9,7 +9,7 @@
 int scrub_scan_estimate_blocks(struct scrub_ctx *ctx,
 		unsigned long long *d_blocks, unsigned long long *d_bfree,
 		unsigned long long *r_blocks, unsigned long long *r_bfree,
-		unsigned long long *f_files_used);
+		unsigned long long *f_files_used, unsigned long long *l_blocks);
 int scrub_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
 
 #endif /* XFS_SCRUB_FSCOUNTERS_H_ */
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 098bf87465ea83..8c054493b9889f 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -125,7 +125,8 @@ scrub_scan_estimate_blocks(
 	unsigned long long		*d_bfree,
 	unsigned long long		*r_blocks,
 	unsigned long long		*r_bfree,
-	unsigned long long		*f_files_used)
+	unsigned long long		*f_files_used,
+	unsigned long long		*l_blocks)
 {
 	struct xfs_fsop_counts		fc;
 	int				error;
@@ -140,6 +141,7 @@ scrub_scan_estimate_blocks(
 	*r_blocks = ctx->mnt.fsgeom.rtblocks;
 	*r_bfree = fc.freertx * ctx->mnt.fsgeom.rtextsize;
 	*f_files_used = fc.allocino - fc.freeino;
+	*l_blocks = ctx->mnt.fsgeom.logblocks;
 
 	return 0;
 }
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 266a2bf0e453ae..e130d7783888c3 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -47,6 +47,7 @@ struct media_verify_state {
 	struct read_verify_pool	*rvp_realtime;
 	struct bitmap		*d_bad;		/* bytes */
 	struct bitmap		*r_bad;		/* bytes */
+	struct bitmap		*l_bad;		/* bytes */
 	bool			d_trunc:1;
 	bool			r_trunc:1;
 	bool			l_trunc:1;
@@ -109,6 +110,8 @@ bitmap_for_disk(
 		return vs->d_bad;
 	case XFS_DEV_RT:
 		return vs->r_bad;
+	case XFS_DEV_LOG:
+		return vs->l_bad;
 	default:
 		return NULL;
 	}
@@ -571,6 +574,12 @@ report_all_media_errors(
 		return ret;
 	}
 
+	ret = report_disk_ioerrs(ctx, vs, XFS_DEV_LOG);
+	if (ret) {
+		str_liberror(ctx, ret, _("walking log device io errors"));
+		return ret;
+	}
+
 	ret = report_disk_ioerrs(ctx, vs, XFS_DEV_RT);
 	if (ret) {
 		str_liberror(ctx, ret, _("walking rtdev io errors"));
@@ -617,9 +626,14 @@ check_rmap(
 			map->fmr_flags);
 
 	/* "Unknown" extents should be verified; they could be data. */
-	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
-			map->fmr_owner == XFS_FMR_OWN_UNKNOWN)
-		map->fmr_flags &= ~FMR_OF_SPECIAL_OWNER;
+	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER)) {
+		switch (map->fmr_owner) {
+		case XFS_FMR_OWN_UNKNOWN:
+		case XFS_FMR_OWN_LOG:
+			map->fmr_flags &= ~FMR_OF_SPECIAL_OWNER;
+			break;
+		}
+	}
 
 	/*
 	 * We only care about read-verifying data extents that have been
@@ -762,11 +776,17 @@ phase6_func(
 		goto out_dbad;
 	}
 
+	ret = -bitmap_alloc(&vs.l_bad);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating log badblock bitmap"));
+		goto out_rbad;
+	}
+
 	ret = read_verify_pool_alloc(ctx, XFS_DEV_DATA, remember_ioerr, &vs,
 			&vs.rvp_data);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
-		goto out_rbad;
+		goto out_lbad;
 	}
 	if (ctx->fsinfo.fs_log) {
 		ret = read_verify_pool_alloc(ctx, XFS_DEV_LOG, remember_ioerr,
@@ -823,16 +843,17 @@ phase6_func(
 	 */
 	if (ret || ret2 || ret3) {
 		ret |= ret2 | ret3; /* caller only cares about non-zero/zero */
-		goto out_rbad;
+		goto out_lbad;
 	}
 	if (bitmap_empty(vs.d_bad) && !vs.d_trunc &&
 	    bitmap_empty(vs.r_bad) && !vs.r_trunc &&
-	    !vs.l_trunc)
-		goto out_rbad;
+	    bitmap_empty(vs.l_bad) && !vs.l_trunc)
+		goto out_lbad;
 
 	/* Scan the whole dir tree to see what matches the bad extents. */
 	ret = report_all_media_errors(ctx, &vs);
 
+	bitmap_free(&vs.l_bad);
 	bitmap_free(&vs.r_bad);
 	bitmap_free(&vs.d_bad);
 	return ret;
@@ -852,6 +873,8 @@ phase6_func(
 out_datapool:
 	read_verify_pool_abort(vs.rvp_data);
 	read_verify_pool_destroy(vs.rvp_data);
+out_lbad:
+	bitmap_free(&vs.l_bad);
 out_rbad:
 	bitmap_free(&vs.r_bad);
 out_dbad:
@@ -872,10 +895,11 @@ phase6_estimate(
 	unsigned long long	r_blocks;
 	unsigned long long	r_bfree;
 	unsigned long long	dontcare;
+	unsigned long long	l_blocks;
 	int			ret;
 
 	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
-			&r_bfree, &dontcare);
+			&r_bfree, &dontcare, &l_blocks);
 	if (ret) {
 		str_liberror(ctx, ret, _("estimating verify work"));
 		return ret;
@@ -884,6 +908,10 @@ phase6_estimate(
 	*items = cvt_off_fsb_to_b(&ctx->mnt,
 			(d_blocks - d_bfree) + (r_blocks - r_bfree));
 
+	/* count external logs now that we scan them */
+	if (ctx->fsinfo.fs_log)
+		*items += cvt_off_fsb_to_b(&ctx->mnt, l_blocks);
+
 	/*
 	 * Each read-verify pool starts a thread pool, and each worker thread
 	 * can contribute to the progress counter.  Hence we need to set
diff --git a/scrub/phase7.c b/scrub/phase7.c
index e25502668b1c41..d52c142cc36114 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -170,6 +170,7 @@ phase7_func(
 	unsigned long long	d_bfree;
 	unsigned long long	r_blocks;
 	unsigned long long	r_bfree;
+	unsigned long long	l_blocks;
 	bool			complain;
 	int			ip;
 	int			error;
@@ -223,7 +224,7 @@ phase7_func(
 	}
 
 	error = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
-			&r_bfree, &used_files);
+			&r_bfree, &used_files, &l_blocks);
 	if (error) {
 		str_liberror(ctx, error, _("estimating verify work"));
 		return error;
@@ -243,6 +244,10 @@ phase7_func(
 	stat_data = totalcount.dbytes;
 	stat_rt = totalcount.rbytes;
 
+	/* only count internal logs for data device summary */
+	if (!ctx->fsinfo.fs_log)
+		used_data += cvt_off_fsb_to_b(&ctx->mnt, l_blocks);
+
 	/*
 	 * Complain if the counts are off by more than 10% unless
 	 * the inaccuracy is less than 32MB worth of blocks or 100 inodes.

