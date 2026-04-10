Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCEA339B3D
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802109; cv=none; b=uImDYxU5jhO7ENM135FP0g8jugK7yzt+keVe8+LuvreBryOz7rX876lG7TnjzQWgpjT3qZim6G7lzzIgzV8aDw+EWacUZnMi9Jjm3Lb40OZ9IUydF239GI4XqjuqZjCyZCFWl9lJVM4wHPG2FNITvuCdRqAWEA4QKiNnonOT/+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802109; c=relaxed/simple;
	bh=Q6ANPP262VNzB4Li8t11ij8wPUA2w822cxWBUxW7KGw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f8Sqn8MFPteApfDR9YERQEU5Mu8Fn3tE3CQP+3wnrO1Mrq9H7gKlS3/U9JhVBDqhYhUg9v3aR+rOXuqz5BZbtk30fQKwCSIPE/n1Jv9xyL6Zcr2SJpwxNWJiTxv4ES5zzNvnbmI8sGmQAEXfY6bIZ0IK07kWRlrMJkS4Po4mjwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qFtbWUR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qFtbWUR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CC2C19424;
	Fri, 10 Apr 2026 06:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802108;
	bh=Q6ANPP262VNzB4Li8t11ij8wPUA2w822cxWBUxW7KGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qFtbWUR8hfO69PxsUoOfbYBH5nX+eex4sN/Dlyoo0LZlO9EpxKBcYGKUSmUqN7zln
	 mmKgtX7kRkJ/jGk4FMxxAQDajL+t03AFKF9ua0uQKoVuyl9ZufoWcrxeQu7epscud8
	 iDxOuVLxuRgVHnSL0YRMpZwsg6m30397epWlsi0uhFlERhhnwrwmDLJdoi3pz2JCkS
	 MFsm2fbIFB8o7qKGBmTBidZT7IoURodtYrYh4NYWPJZ6gC+8rzjZyQE7NPnOv+3VMR
	 p4U8YOEFUlPQH3V3xncJOHsrd0+hDIMsbCI6Xp/G3kNqrIFGp088sSp/c/TgzA4Ppv
	 nrPfuu8kVnAjA==
Date: Thu, 09 Apr 2026 23:21:48 -0700
Subject: [PATCH 17/21] xfs_scrub: index read-verify pools by xfs_device ids
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385345.2090237.7994152639432678659.stgit@frogsfrogsfrogs>
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

Refactor the read-verify pool array in struct media_verify_state so that
we can index them via enum xfs_device.  This will enable further
cleanups in the next few patches.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase6.c |  103 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 48 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index e130d7783888c3..df907ea816fa0b 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -42,9 +42,8 @@
 struct media_verify_state {
 	struct ptvar		*verify_schedules;
 
-	struct read_verify_pool	*rvp_data;
-	struct read_verify_pool	*rvp_log;
-	struct read_verify_pool	*rvp_realtime;
+	struct read_verify_pool	*rvp[XFS_DEV_RT + 1];
+
 	struct bitmap		*d_bad;		/* bytes */
 	struct bitmap		*r_bad;		/* bytes */
 	struct bitmap		*l_bad;		/* bytes */
@@ -53,28 +52,24 @@ struct media_verify_state {
 	bool			l_trunc:1;
 };
 
-/* Find the fd for a given device identifier. */
-static struct read_verify_pool *
-dev_to_pool(
-	struct scrub_ctx		*ctx,
-	struct media_verify_state	*vs,
-	dev_t				dev)
+/* Return XFS device index from fsmap device. */
+static enum xfs_device
+from_fsmap_dev(
+	struct scrub_ctx	*ctx,
+	dev_t			dev)
 {
 	if (ctx->mnt.fsgeom.rtstart) {
-		if (dev == XFS_DEV_DATA)
-			return vs->rvp_data;
-		if (dev == XFS_DEV_LOG)
-			return vs->rvp_log;
-		if (dev == XFS_DEV_RT)
-			return vs->rvp_realtime;
-	} else {
-		if (dev == ctx->fsinfo.fs_datadev)
-			return vs->rvp_data;
-		if (dev == ctx->fsinfo.fs_logdev)
-			return vs->rvp_log;
-		if (dev == ctx->fsinfo.fs_rtdev)
-			return vs->rvp_realtime;
+		if (dev < XFS_DEV_DATA || dev > XFS_DEV_RT)
+			abort();
+		return dev;
 	}
+
+	if (dev == ctx->fsinfo.fs_datadev)
+		return XFS_DEV_DATA;
+	if (dev == ctx->fsinfo.fs_logdev)
+		return XFS_DEV_LOG;
+	if (dev == ctx->fsinfo.fs_rtdev)
+		return XFS_DEV_RT;
 	abort();
 }
 
@@ -611,13 +606,12 @@ check_rmap(
 	void				*arg)
 {
 	struct media_verify_state	*vs = arg;
-	struct read_verify_pool		*rvp;
+	struct read_verify_pool		*rvp =
+		vs->rvp[from_fsmap_dev(ctx, map->fmr_device)];
 	struct read_verify_schedule	*rs;
 	bool				scheduled;
 	int				ret;
 
-	rvp = dev_to_pool(ctx, vs, map->fmr_device);
-
 	dbg_printf("rmap dev %d:%d phys %"PRIu64" owner %"PRId64
 			" offset %"PRIu64" len %"PRIu64" flags 0x%x\n",
 			major(map->fmr_device), minor(map->fmr_device),
@@ -686,11 +680,13 @@ force_one_verify(
 /* Wait for read/verify actions to finish, then return # bytes checked. */
 static int
 clean_pool(
-	struct read_verify_pool	*rvp,
-	unsigned long long	*bytes_checked)
+	struct media_verify_state	*vs,
+	enum xfs_device			dev,
+	unsigned long long		*bytes_checked)
 {
-	uint64_t		pool_checked;
-	int			ret;
+	struct read_verify_pool		*rvp = vs->rvp[dev];
+	uint64_t			pool_checked;
+	int				ret;
 
 	if (!rvp)
 		return 0;
@@ -749,6 +745,27 @@ remember_ioerr(
 		str_liberror(ctx, ret, _("setting bad block bitmap"));
 }
 
+static inline int
+alloc_pool(
+	struct scrub_ctx		*ctx,
+	struct media_verify_state	*vs,
+	enum xfs_device			dev)
+{
+	return read_verify_pool_alloc(ctx, dev, remember_ioerr, vs,
+			&vs->rvp[dev]);
+}
+
+static inline void
+free_pool(
+	struct media_verify_state	*vs,
+	enum xfs_device			dev)
+{
+	if (vs->rvp[dev]) {
+		read_verify_pool_abort(vs->rvp[dev]);
+		read_verify_pool_destroy(vs->rvp[dev]);
+	}
+}
+
 /*
  * Read verify all the file data blocks in a filesystem.  Since XFS doesn't
  * do data checksums, we trust that the underlying storage will pass back
@@ -782,15 +799,13 @@ phase6_func(
 		goto out_rbad;
 	}
 
-	ret = read_verify_pool_alloc(ctx, XFS_DEV_DATA, remember_ioerr, &vs,
-			&vs.rvp_data);
+	ret = alloc_pool(ctx, &vs, XFS_DEV_DATA);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
 		goto out_lbad;
 	}
 	if (ctx->fsinfo.fs_log) {
-		ret = read_verify_pool_alloc(ctx, XFS_DEV_LOG, remember_ioerr,
-				&vs, &vs.rvp_log);
+		ret = alloc_pool(ctx, &vs, XFS_DEV_LOG);
 		if (ret) {
 			str_liberror(ctx, ret,
 					_("creating logdev media verifier"));
@@ -798,8 +813,7 @@ phase6_func(
 		}
 	}
 	if (ctx->fsinfo.fs_rt) {
-		ret = read_verify_pool_alloc(ctx, XFS_DEV_RT, remember_ioerr,
-				&vs, &vs.rvp_realtime);
+		ret = alloc_pool(ctx, &vs, XFS_DEV_RT);
 		if (ret) {
 			str_liberror(ctx, ret,
 					_("creating rtdev media verifier"));
@@ -825,15 +839,15 @@ phase6_func(
 	ptvar_free(vs.verify_schedules);
 	vs.verify_schedules = NULL;
 
-	ret = clean_pool(vs.rvp_data, &ctx->bytes_checked);
+	ret = clean_pool(&vs, XFS_DEV_DATA, &ctx->bytes_checked);
 	if (ret)
 		str_liberror(ctx, ret, _("flushing datadev verify pool"));
 
-	ret2 = clean_pool(vs.rvp_log, &ctx->bytes_checked);
+	ret2 = clean_pool(&vs, XFS_DEV_LOG, &ctx->bytes_checked);
 	if (ret2)
 		str_liberror(ctx, ret2, _("flushing logdev verify pool"));
 
-	ret3 = clean_pool(vs.rvp_realtime, &ctx->bytes_checked);
+	ret3 = clean_pool(&vs, XFS_DEV_RT, &ctx->bytes_checked);
 	if (ret3)
 		str_liberror(ctx, ret3, _("flushing rtdev verify pool"));
 
@@ -861,18 +875,11 @@ phase6_func(
 out_schedules:
 	ptvar_free(vs.verify_schedules);
 out_rtpool:
-	if (vs.rvp_realtime) {
-		read_verify_pool_abort(vs.rvp_realtime);
-		read_verify_pool_destroy(vs.rvp_realtime);
-	}
+	free_pool(&vs, XFS_DEV_RT);
 out_logpool:
-	if (vs.rvp_log) {
-		read_verify_pool_abort(vs.rvp_log);
-		read_verify_pool_destroy(vs.rvp_log);
-	}
+	free_pool(&vs, XFS_DEV_LOG);
 out_datapool:
-	read_verify_pool_abort(vs.rvp_data);
-	read_verify_pool_destroy(vs.rvp_data);
+	free_pool(&vs, XFS_DEV_DATA);
 out_lbad:
 	bitmap_free(&vs.l_bad);
 out_rbad:

