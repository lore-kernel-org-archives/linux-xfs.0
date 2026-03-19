Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CB310E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895798; cv=none; b=iQKYEL/F3WirhmxZaq65XePGmHvmGH5AdNVGA0oyROkLz+AoBdyVwCg1j+YkXzVOEV8hm01g4u5nddOTBJNnMHolCr9NNEGYeyuMrIVfKjW223HKmg38cmm0tsynNSOBUBQmOefXGncOxMrPx4W9qGv+mWJk5uygMeNViObbFE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895798; c=relaxed/simple;
	bh=1c0L7CJ19m7bL35LEnV81NJpdnTR8ADi5+wZO57qL9E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ljvHVgm6GIzjnvcpeaDSF3dVZ+rYOXKvVN1A7x5/YoubI8Q9CP2RudQUQoYEStbmB8b4aB+TMZa9MDmv1JxpHiWDZHCipzHbpMd0M8IUjA9YLjKHuoWAQrpQn+0tijxGM+mPLq7t4E36/bgZdV8juluQdGFhevD60ZMhXyr5I2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3Dx5qxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3Dx5qxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB69C19425;
	Thu, 19 Mar 2026 04:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895798;
	bh=1c0L7CJ19m7bL35LEnV81NJpdnTR8ADi5+wZO57qL9E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N3Dx5qxjGCjVj67lT0+ETIjjlcLvzVTqpNZr7jYM0wx+aUefJg/j73KLZ3d7N2Pf3
	 LnfoFDA0tAcwbgrwU6OuwZ0D/Kb7ooY/iB0sDzCmQg2pQF2OwWLoYmw1HtBC6NuFwT
	 LvR2WVTu3EROk7Xgecr+WESJcKBoVkyRZa8ZDMCAuC59hxreowim7dUstEoa4CVTPU
	 vXshk7p+CsxP9AFhtNH1ncfaum1RkZtWbsLKHHpiR9V7UjCm2eRGk8iSE8ep9npMXH
	 NLzpoayUqi/fThzfO4PltSymAndq6efWDwgSvJYJsGzErFfPVIzHSMDT5wp/wdtBpZ
	 ex22mziKv80Pw==
Date: Wed, 18 Mar 2026 21:49:58 -0700
Subject: [PATCH 17/22] xfs_scrub: index read-verify pools by xfs_device ids
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389507252.3681140.8941083932552299301.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Refactor the read-verify pool array in struct media_verify_state so that
we can index them via enum xfs_device.  This will enable further
cleanups in the next few patches.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |  103 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 48 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index c1ce222d4ce99f..a05bd7e1df1728 100644
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

