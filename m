Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CD5165F16
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895689; cv=none; b=jbJVnFsY+MHunaZTixlVsayzn7XU7wxB0mecTO3ymGTRWg6QOS38A+q9AuATEgvldJsHbrq41p0mATBPL7zE4T2rfGX+dEzwrwjcUp5TFg9ecmO0D9Y4xDnLuSnu1a6l7ATuMxDB4QEhf8+kVfR7e0RVHO3UOA21Vf/+aNbpGcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895689; c=relaxed/simple;
	bh=joyr0goYlcUzcsNsH+J156wj3ltprtGScPOI8fk1myY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YExyzArKZbP3tVYp51uE9u/7VCko3lsIiKgXdlG+SGHCiJrKGKVsk3yV1UWtHBcLzrABL1R1ceS5luYVK0lBMzUeg8ShHdV8M/ndHcXcZzd89Yw0EoVOTidwDd0hVW6El62XbrWVIaVPpdw1ZN63pN0qRRX5zK1dSJv27Ieqxig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fua/h4mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fua/h4mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271B4C19425;
	Thu, 19 Mar 2026 04:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895689;
	bh=joyr0goYlcUzcsNsH+J156wj3ltprtGScPOI8fk1myY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fua/h4mbRiFab9deFc6JdKRQnBVDrZhZhtGR+/h/B6jf7e4KpntwGzSFM26bFGc4s
	 tULaM4fZSqbl1xIUPQxEPcohv3DL8RoEEmRd8yNk1PIYSdUlPdp4ozw2w8v+nQDB1w
	 vjJLfXBTj2WbdIspaIess8DTifjqi8Xf+liGs5JtyzKSixDHypqSCcQrfvVvkAChkp
	 WUz1/Qu4OIPDsCPps0GhbvWp44PhqpvIT8YCi6WoBLwJbGOXWDveE+P7sB3wtQdzY5
	 P7Bla07EZbiZWWrn+RprWqKl8XWOK98/Oo2k4NKsTtWPqi+a3EmSfjbVwbRvdXEFOD
	 Simf9w07wGmYA==
Date: Wed, 18 Mar 2026 21:48:08 -0700
Subject: [PATCH 10/22] scrub: use enum xfs_device for read verification
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389507123.3681140.14473276707876841296.stgit@frogsfrogsfrogs>
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

Passing the disk pointer and then translating back to an index is a bit
confusing.  Rewrite the read_verify and related code to pass around an
enum xfs_device and use that to identify the device.

The disks are placed in an array so that they can be trivially indexed using
the xfs device.  Because the value start at 1 this adds an unused slot, but
such a minor waste does not matter in the overall scheme of things.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: fix minor merge conflicts]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/read_verify.h |    5 +--
 scrub/xfs_scrub.h   |    6 +--
 scrub/phase1.c      |   26 +++++++------
 scrub/phase6.c      |  101 ++++++++++++++++++++++++++-------------------------
 scrub/read_verify.c |   38 +++++++++----------
 5 files changed, 86 insertions(+), 90 deletions(-)


diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index 165ad8f7af7b6c..e4b36f6aaa20e1 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -8,7 +8,6 @@
 
 struct scrub_ctx;
 struct read_verify_pool;
-struct disk;
 
 struct read_verify_schedule {
 	struct read_verify_pool	*rvp;
@@ -18,10 +17,10 @@ struct read_verify_schedule {
 
 /* Function called when an IO error happens. */
 typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
-		struct disk *disk, uint64_t start, uint64_t length,
+		enum xfs_device dev, uint64_t start, uint64_t length,
 		int error, void *arg);
 
-int read_verify_pool_alloc(struct scrub_ctx *ctx, struct disk *disk,
+int read_verify_pool_alloc(struct scrub_ctx *ctx, enum xfs_device dev,
 		read_verify_ioerr_fn_t ioerr_fn, void *ioerr_arg,
 		struct read_verify_pool **prvp);
 void read_verify_pool_abort(struct read_verify_pool *rvp);
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 041c0fadaa93c0..a7e67c37469beb 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -57,10 +57,8 @@ struct scrub_ctx {
 	struct statvfs		mnt_sv;
 	struct statfs		mnt_sf;
 
-	/* Open block devices */
-	struct disk		*datadev;
-	struct disk		*logdev;
-	struct disk		*rtdev;
+	/* Open block devices for legacy verify */
+	struct disk		*verify_disks[XFS_DEV_RT + 1];
 
 	/* What does the user want us to do? */
 	enum scrub_mode		mode;
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 10e9aa1892b701..954a62b7e8d711 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -96,12 +96,12 @@ scrub_cleanup(
 
 	if (ctx->fshandle)
 		free_handle(ctx->fshandle, ctx->fshandle_len);
-	if (ctx->rtdev)
-		disk_close(ctx->rtdev);
-	if (ctx->logdev)
-		disk_close(ctx->logdev);
-	if (ctx->datadev)
-		disk_close(ctx->datadev);
+	if (ctx->verify_disks[XFS_DEV_DATA])
+		disk_close(ctx->verify_disks[XFS_DEV_DATA]);
+	if (ctx->verify_disks[XFS_DEV_LOG])
+		disk_close(ctx->verify_disks[XFS_DEV_LOG]);
+	if (ctx->verify_disks[XFS_DEV_RT])
+		disk_close(ctx->verify_disks[XFS_DEV_RT]);
 	fshandle_destroy();
 	error = -xfd_close(&ctx->mnt);
 	if (error)
@@ -349,13 +349,13 @@ _("Unable to find realtime device path."));
 	}
 
 	/* Open the raw devices. */
-	ctx->datadev = disk_open(ctx->fsinfo.fs_name);
-	if (!ctx->datadev) {
+	ctx->verify_disks[XFS_DEV_DATA] = disk_open(ctx->fsinfo.fs_name);
+	if (!ctx->verify_disks[XFS_DEV_DATA]) {
 		str_error(ctx, ctx->mntpoint, _("Unable to open data device."));
 		return ECANCELED;
 	}
 
-	ctx->nr_io_threads = disk_heads(ctx->datadev);
+	ctx->nr_io_threads = disk_heads(ctx->verify_disks[XFS_DEV_DATA]);
 	if (verbose) {
 		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
 				ctx->mntpoint, scrub_nproc(ctx));
@@ -363,16 +363,16 @@ _("Unable to find realtime device path."));
 	}
 
 	if (ctx->fsinfo.fs_log) {
-		ctx->logdev = disk_open(ctx->fsinfo.fs_log);
-		if (!ctx->logdev) {
+		ctx->verify_disks[XFS_DEV_LOG] = disk_open(ctx->fsinfo.fs_log);
+		if (!ctx->verify_disks[XFS_DEV_LOG]) {
 			str_error(ctx, ctx->mntpoint,
 				_("Unable to open external log device."));
 			return ECANCELED;
 		}
 	}
 	if (ctx->fsinfo.fs_rt) {
-		ctx->rtdev = disk_open(ctx->fsinfo.fs_rt);
-		if (!ctx->rtdev) {
+		ctx->verify_disks[XFS_DEV_RT] = disk_open(ctx->fsinfo.fs_rt);
+		if (!ctx->verify_disks[XFS_DEV_RT]) {
 			str_error(ctx, ctx->mntpoint,
 				_("Unable to open realtime device."));
 			return ECANCELED;
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 3e6a236d010a6b..02b25fe73aa656 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -77,47 +77,46 @@ dev_to_pool(
 	abort();
 }
 
-/* Find the device major/minor for a given file descriptor. */
-static dev_t
-disk_to_dev(
+/* Return fsmap device for XFS device index. */
+static uint32_t
+to_fsmap_dev(
 	struct scrub_ctx	*ctx,
-	struct disk		*disk)
+	enum xfs_device		dev)
 {
-	if (ctx->mnt.fsgeom.rtstart) {
-		if (disk == ctx->datadev)
-			return XFS_DEV_DATA;
-		if (disk == ctx->logdev)
-			return XFS_DEV_LOG;
-		if (disk == ctx->rtdev)
-			return XFS_DEV_RT;
-	} else {
-		if (disk == ctx->datadev)
-			return ctx->fsinfo.fs_datadev;
-		if (disk == ctx->logdev)
-			return ctx->fsinfo.fs_logdev;
-		if (disk == ctx->rtdev)
-			return ctx->fsinfo.fs_rtdev;
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
 	}
-	abort();
 }
 
 /* Find the incore bad blocks bitmap for a given disk. */
 static struct bitmap *
 bitmap_for_disk(
-	struct scrub_ctx		*ctx,
-	struct disk			*disk,
+	enum xfs_device			dev,
 	struct media_verify_state	*vs)
 {
-	if (disk == ctx->datadev)
+	switch (dev) {
+	case XFS_DEV_DATA:
 		return vs->d_bad;
-	if (disk == ctx->rtdev)
+	case XFS_DEV_RT:
 		return vs->r_bad;
-	return NULL;
+	default:
+		return NULL;
+	}
 }
 
 struct disk_ioerr_report {
 	struct scrub_ctx	*ctx;
-	struct disk		*disk;
+	enum xfs_device		dev;
 };
 
 struct owner_decode {
@@ -522,7 +521,7 @@ report_ioerr(
 	struct disk_ioerr_report	*dioerr = arg;
 
 	/* Go figure out which blocks are bad from the fsmap. */
-	keys[0].fmr_device = disk_to_dev(dioerr->ctx, dioerr->disk);
+	keys[0].fmr_device = to_fsmap_dev(dioerr->ctx, dioerr->dev);
 	keys[0].fmr_physical = start;
 	keys[1].fmr_device = keys[0].fmr_device;
 	keys[1].fmr_physical = start + length - 1;
@@ -537,18 +536,15 @@ report_ioerr(
 static int
 report_disk_ioerrs(
 	struct scrub_ctx		*ctx,
-	struct disk			*disk,
-	struct media_verify_state	*vs)
+	struct media_verify_state	*vs,
+	enum xfs_device			dev)
 {
+	struct bitmap			*tree = bitmap_for_disk(dev, vs);
 	struct disk_ioerr_report	dioerr = {
 		.ctx			= ctx,
-		.disk			= disk,
+		.dev			= dev,
 	};
-	struct bitmap			*tree;
 
-	if (!disk)
-		return 0;
-	tree = bitmap_for_disk(ctx, disk, vs);
 	if (!tree)
 		return 0;
 	return -bitmap_iterate(tree, report_ioerr, &dioerr);
@@ -569,13 +565,13 @@ report_all_media_errors(
 	if (vs->r_trunc)
 		str_corrupt(ctx, ctx->mntpoint, _("rt device truncated"));
 
-	ret = report_disk_ioerrs(ctx, ctx->datadev, vs);
+	ret = report_disk_ioerrs(ctx, vs, XFS_DEV_DATA);
 	if (ret) {
 		str_liberror(ctx, ret, _("walking datadev io errors"));
 		return ret;
 	}
 
-	ret = report_disk_ioerrs(ctx, ctx->rtdev, vs);
+	ret = report_disk_ioerrs(ctx, vs, XFS_DEV_RT);
 	if (ret) {
 		str_liberror(ctx, ret, _("walking rtdev io errors"));
 		return ret;
@@ -703,7 +699,7 @@ clean_pool(
 static void
 remember_ioerr(
 	struct scrub_ctx		*ctx,
-	struct disk			*disk,
+	enum xfs_device			dev,
 	uint64_t			start,
 	uint64_t			length,
 	int				error,
@@ -714,16 +710,21 @@ remember_ioerr(
 	int				ret;
 
 	if (!length) {
-		if (disk == ctx->datadev)
+		switch (dev) {
+		case XFS_DEV_DATA:
 			vs->d_trunc = true;
-		else if (disk == ctx->logdev)
+			break;
+		case XFS_DEV_LOG:
 			vs->l_trunc = true;
-		else if (disk == ctx->rtdev)
+			break;
+		case XFS_DEV_RT:
 			vs->r_trunc = true;
+			break;
+		}
 		return;
 	}
 
-	tree = bitmap_for_disk(ctx, disk, vs);
+	tree = bitmap_for_disk(dev, vs);
 	if (!tree) {
 		str_liberror(ctx, ENOENT, _("finding bad block bitmap"));
 		return;
@@ -761,14 +762,14 @@ phase6_func(
 		goto out_dbad;
 	}
 
-	ret = read_verify_pool_alloc(ctx, ctx->datadev, remember_ioerr, &vs,
+	ret = read_verify_pool_alloc(ctx, XFS_DEV_DATA, remember_ioerr, &vs,
 			&vs.rvp_data);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
 		goto out_rbad;
 	}
-	if (ctx->logdev) {
-		ret = read_verify_pool_alloc(ctx, ctx->logdev, remember_ioerr,
+	if (ctx->fsinfo.fs_log) {
+		ret = read_verify_pool_alloc(ctx, XFS_DEV_LOG, remember_ioerr,
 				&vs, &vs.rvp_log);
 		if (ret) {
 			str_liberror(ctx, ret,
@@ -776,8 +777,8 @@ phase6_func(
 			goto out_datapool;
 		}
 	}
-	if (ctx->rtdev) {
-		ret = read_verify_pool_alloc(ctx, ctx->rtdev, remember_ioerr,
+	if (ctx->fsinfo.fs_rt) {
+		ret = read_verify_pool_alloc(ctx, XFS_DEV_RT, remember_ioerr,
 				&vs, &vs.rvp_realtime);
 		if (ret) {
 			str_liberror(ctx, ret,
@@ -888,11 +889,11 @@ phase6_estimate(
 	 * can contribute to the progress counter.  Hence we need to set
 	 * nr_threads appropriately to handle that many threads.
 	 */
-	*nr_threads = disk_heads(ctx->datadev);
-	if (ctx->rtdev)
-		*nr_threads += disk_heads(ctx->rtdev);
-	if (ctx->logdev)
-		*nr_threads += disk_heads(ctx->logdev);
+	*nr_threads = disk_heads(ctx->verify_disks[XFS_DEV_DATA]);
+	if (ctx->verify_disks[XFS_DEV_RT])
+		*nr_threads += disk_heads(ctx->verify_disks[XFS_DEV_RT]);
+	if (ctx->verify_disks[XFS_DEV_LOG])
+		*nr_threads += disk_heads(ctx->verify_disks[XFS_DEV_LOG]);
 	*rshift = 20;
 	return 0;
 }
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index bcd923e5f3cbc3..9b692a923dfdf3 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -58,10 +58,10 @@ struct read_verify_pool {
 	struct scrub_ctx	*ctx;		/* scrub context */
 	void			*readbuf;	/* read buffer */
 	struct ptcounter	*verified_bytes;
-	struct disk		*disk;		/* which disk? */
 	void			*ioerr_arg;
 	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
 	size_t			miniosz;	/* minimum io size, bytes */
+	enum xfs_device		dev;		/* which device? */
 
 	/*
 	 * Store a runtime error code here so that we can stop the pool and
@@ -73,19 +73,19 @@ struct read_verify_pool {
 /*
  * Create a thread pool to run read verifiers.
  *
- * @disk is the disk we want to verify.
  * @ioerr_fn will be called when IO errors occur.
  */
 int
 read_verify_pool_alloc(
 	struct scrub_ctx		*ctx,
-	struct disk			*disk,
+	enum xfs_device			dev,
 	read_verify_ioerr_fn_t		ioerr_fn,
 	void				*ioerr_arg,
 	struct read_verify_pool		**prvp)
 {
 	struct read_verify_pool		*rvp;
-	unsigned int			verifier_threads = disk_heads(disk);
+	unsigned int			verifier_threads =
+		disk_heads(ctx->verify_disks[XFS_DEV_DATA]);
 	int				ret;
 
 	if (rvp_io_max_size() % ctx->mnt.fsgeom.blocksize)
@@ -104,7 +104,7 @@ read_verify_pool_alloc(
 		goto out_buf;
 	rvp->miniosz = ctx->mnt.fsgeom.blocksize;
 	rvp->ctx = ctx;
-	rvp->disk = disk;
+	rvp->dev = dev;
 	rvp->ioerr_fn = ioerr_fn;
 	rvp->ioerr_arg = ioerr_arg;
 	ret = -workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
@@ -179,10 +179,10 @@ read_verify(
 	while (rv->io_length > 0) {
 		read_error = 0;
 		len = min(rv->io_length, io_max_size);
-		dbg_printf("diskverify %d %"PRIu64" %zu\n", rvp->disk->d_fd,
+		dbg_printf("diskverify %u %"PRIu64" %zu\n", rvp->dev,
 				rv->io_start, len);
-		sz = disk_read_verify(rvp->disk, rvp->readbuf, rv->io_start,
-				len);
+		sz = disk_read_verify(rvp->ctx->verify_disks[rvp->dev],
+				rvp->readbuf, rv->io_start, len);
 		if (sz == len && io_max_size < rvp->miniosz) {
 			/*
 			 * If the verify request was 100% successful and less
@@ -221,17 +221,15 @@ read_verify(
 			 * io_start to the next miniosz block.
 			 */
 			sz = rvp->miniosz - (rv->io_start % rvp->miniosz);
-			dbg_printf("IOERR %d @ %"PRIu64" %zu err %d\n",
-					rvp->disk->d_fd, rv->io_start, sz,
-					read_error);
-			rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start, sz,
+			dbg_printf("IOERR %u @ %"PRIu64" %zu err %d\n",
+					rvp->dev, rv->io_start, sz, read_error);
+			rvp->ioerr_fn(rvp->ctx, rvp->dev, rv->io_start, sz,
 					read_error, rvp->ioerr_arg);
 		} else if (sz == 0) {
 			/* No bytes at all?  Did we hit the end of the disk? */
-			dbg_printf("EOF %d @ %"PRIu64" %zu err %d\n",
-					rvp->disk->d_fd, rv->io_start, sz,
-					read_error);
-			rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start, sz,
+			dbg_printf("EOF %u @ %"PRIu64" %zu err %d\n",
+					rvp->dev, rv->io_start, sz, read_error);
+			rvp->ioerr_fn(rvp->ctx, rvp->dev, rv->io_start, sz,
 					read_error, rvp->ioerr_arg);
 			break;
 		} else if (sz < len) {
@@ -245,8 +243,8 @@ read_verify(
 			 * next full block.
 			 */
 			io_max_size = rvp->miniosz - (sz % rvp->miniosz);
-			dbg_printf("SHORT %d READ @ %"PRIu64" %zu try for %zd\n",
-					rvp->disk->d_fd, rv->io_start, sz,
+			dbg_printf("SHORT %u READ @ %"PRIu64" %zu try for %zd\n",
+					rvp->dev, rv->io_start, sz,
 					io_max_size);
 		} else {
 			/* We should never get back more bytes than we asked. */
@@ -279,8 +277,8 @@ read_verify_schedule_now(
 	if (!rvp)
 		return 0;
 
-	dbg_printf("verify fd %d start %"PRIu64" len %"PRIu64"\n",
-			rvp->disk->d_fd, rs->io_start, rs->io_length);
+	dbg_printf("verify dev %u start %"PRIu64" len %"PRIu64"\n",
+			rvp->dev, rs->io_start, rs->io_length);
 
 	/* Worker thread saw a runtime error, don't queue more. */
 	if (rvp->runtime_error)

