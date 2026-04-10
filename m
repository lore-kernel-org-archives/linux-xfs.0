Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F60B35BDA7
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802124; cv=none; b=tUmRS/Uzh+phuHHu+5VAm+/LzV4s9B6WvYbAy5J0Wfz+SD8PdtHnxlZfpmStU2WWjzVHH2YB5zxvh0rWFrXvxZJOlVwC/VuGDHC2QeulFAwpAWcQMR+sJnWaxzAnq4h8uFw5Iw6Pel+PKaAtQZKQsNa9T1DQPRbHcD6U4GVKkb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802124; c=relaxed/simple;
	bh=3wIFnIV0XLyIKOcgj6+XwAQLnJmb3DLeh9VedJUjjLc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mIUHYNVTpUapJuiqsxh1+4F9oF6RabS7DcLo7qLlek5p1LP8luqsV3wOa1i9cEJVIm3sIOmcfIElOlBr+CmO3H4VwVUxktVB/1fV7vrI33P5B4/7+c/ivROxbt0o8oa41s53YMKXRzXeDAWBbOqlL4xMqiidE9hBb6+3LIoNehE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D8ULH0iB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D8ULH0iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656B5C19421;
	Fri, 10 Apr 2026 06:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802124;
	bh=3wIFnIV0XLyIKOcgj6+XwAQLnJmb3DLeh9VedJUjjLc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D8ULH0iBq2uWTto5XOC7N3v+tvdWyeFtHtF7dhIdQ7l5Nm6DY4nMMn+ghdThlFGm+
	 +ZlK9TcfAjbe4zfsd30m+zTswSQSPK1iXtYiVaBWl2ADoMcq/otFWtKFiM19qVGRgt
	 ybBwcAh/d3feNiuZuFosYyNaz7FyxMtQAIwVT52Qjh07+SzbVmPIIqtUHo18jYjGQO
	 CCYuKhRV95oEPIpgeDj2o9Z2Ifn3OcavOKSaIHnqi/VFLfHM9JNUm95FEcMoCbxaPW
	 WHLlvUUpNF6iMeLBULEH43crQ5HwCZI4FKYgONgXL3xy0Woga1vvO326UZcI7tIjBe
	 MiJsR/XnXjFNQ==
Date: Thu, 09 Apr 2026 23:22:03 -0700
Subject: [PATCH 18/21] xfs_scrub: move failmap and other outputs into
 read_verify_pool
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385364.2090237.16883094695398623817.stgit@frogsfrogsfrogs>
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

Remove all the indirect verify IO error function calls and whatnot by
making the read_verify_pool track the ranges of failed media and other
problems.  Add some new helper functions that report on the outcome of
the read verifciation so that phase6 can report on what happened.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/read_verify.h |   13 +++-
 scrub/phase6.c      |  184 +++++++++++++--------------------------------------
 scrub/read_verify.c |  145 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 184 insertions(+), 158 deletions(-)


diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index 6a338abb896bc3..c46ba1e76a8d03 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -21,7 +21,6 @@ typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
 		int error, void *arg);
 
 int read_verify_pool_alloc(struct scrub_ctx *ctx, enum xfs_device dev,
-		read_verify_ioerr_fn_t ioerr_fn, void *ioerr_arg,
 		struct read_verify_pool **prvp);
 void read_verify_pool_abort(struct read_verify_pool *rvp);
 int read_verify_pool_flush(struct read_verify_pool *rvp);
@@ -31,7 +30,17 @@ int read_verify_schedule_now(struct read_verify_schedule *rs);
 bool try_read_verify_schedule_io(struct read_verify_schedule *rs,
 		struct read_verify_pool *rvp, uint64_t start, uint64_t length);
 
-int read_verify_bytes(struct read_verify_pool *rvp, uint64_t *bytes);
+bool read_verify_ok(const struct read_verify_pool *rvp);
+bool read_verify_truncated(const struct read_verify_pool *rvp);
+uint64_t read_verify_progress(const struct read_verify_pool *rvp);
+
+int read_verify_iterate_failed(struct read_verify_pool *rvp,
+		int (*fn)(uint64_t, uint64_t, void *), void *arg);
+int read_verify_iterate_failed_range(struct read_verify_pool *rvp,
+		uint64_t start, uint64_t length,
+		int (*fn)(uint64_t, uint64_t, void *), void *arg);
+bool read_verify_has_failed(struct read_verify_pool *rvp, uint64_t start,
+		uint64_t len);
 
 unsigned int read_verify_nproc(struct scrub_ctx *ctx);
 
diff --git a/scrub/phase6.c b/scrub/phase6.c
index df907ea816fa0b..ae3b928df0f263 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -43,13 +43,6 @@ struct media_verify_state {
 	struct ptvar		*verify_schedules;
 
 	struct read_verify_pool	*rvp[XFS_DEV_RT + 1];
-
-	struct bitmap		*d_bad;		/* bytes */
-	struct bitmap		*r_bad;		/* bytes */
-	struct bitmap		*l_bad;		/* bytes */
-	bool			d_trunc:1;
-	bool			r_trunc:1;
-	bool			l_trunc:1;
 };
 
 /* Return XFS device index from fsmap device. */
@@ -94,24 +87,6 @@ to_fsmap_dev(
 	}
 }
 
-/* Find the incore bad blocks bitmap for a given disk. */
-static struct bitmap *
-bitmap_for_disk(
-	enum xfs_device			dev,
-	struct media_verify_state	*vs)
-{
-	switch (dev) {
-	case XFS_DEV_DATA:
-		return vs->d_bad;
-	case XFS_DEV_RT:
-		return vs->r_bad;
-	case XFS_DEV_LOG:
-		return vs->l_bad;
-	default:
-		return NULL;
-	}
-}
-
 struct disk_ioerr_report {
 	struct scrub_ctx	*ctx;
 	enum xfs_device		dev;
@@ -190,6 +165,13 @@ _("media error at data offset %llu length %llu."),
 	return 0;
 }
 
+static inline enum xfs_device from_fsx(const struct fsxattr *fsx)
+{
+	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
+		return XFS_DEV_RT;
+	return XFS_DEV_DATA;
+}
+
 /* Report if this extent overlaps a bad region. */
 static int
 report_data_loss(
@@ -202,7 +184,6 @@ report_data_loss(
 {
 	struct badfile_report		*br = arg;
 	struct media_verify_state	*vs = br->vs;
-	struct bitmap			*bmp;
 
 	br->bmap = bmap;
 
@@ -210,13 +191,9 @@ report_data_loss(
 	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
 		return 0;
 
-	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
-		bmp = vs->r_bad;
-	else
-		bmp = vs->d_bad;
-
-	return -bitmap_iterate_range(bmp, bmap->bm_physical, bmap->bm_length,
-			report_badfile, br);
+	return read_verify_iterate_failed_range(vs->rvp[from_fsx(fsx)],
+			bmap->bm_physical, bmap->bm_length, report_badfile,
+			br);
 }
 
 /* Report if the extended attribute data overlaps a bad region. */
@@ -231,7 +208,6 @@ report_attr_loss(
 {
 	struct badfile_report		*br = arg;
 	struct media_verify_state	*vs = br->vs;
-	struct bitmap			*bmp = vs->d_bad;
 
 	/* Complain about attr fork extents that don't look right. */
 	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC)) {
@@ -246,7 +222,8 @@ _("found unexpected realtime attr fork extent."));
 		return 0;
 	}
 
-	if (bitmap_test(bmp, bmap->bm_physical, bmap->bm_length))
+	if (read_verify_has_failed(vs->rvp[XFS_DEV_DATA], bmap->bm_physical,
+				bmap->bm_length))
 		str_corrupt(ctx, br->descr,
 _("media error in extended attribute data."));
 
@@ -530,6 +507,19 @@ report_ioerr(
 			&fr);
 }
 
+static inline const char *trunc_msg(enum xfs_device dev)
+{
+	switch (dev) {
+	case XFS_DEV_DATA:
+		return _("data device truncated");
+	case XFS_DEV_LOG:
+		return _("log device truncated");
+	case XFS_DEV_RT:
+		return _("rt device truncated");
+	}
+	abort();
+}
+
 /* Report all the media errors found on a disk. */
 static int
 report_disk_ioerrs(
@@ -537,15 +527,18 @@ report_disk_ioerrs(
 	struct media_verify_state	*vs,
 	enum xfs_device			dev)
 {
-	struct bitmap			*tree = bitmap_for_disk(dev, vs);
 	struct disk_ioerr_report	dioerr = {
 		.ctx			= ctx,
 		.dev			= dev,
 	};
 
-	if (!tree)
+	if (!vs->rvp[dev])
 		return 0;
-	return -bitmap_iterate(tree, report_ioerr, &dioerr);
+
+	if (read_verify_truncated(vs->rvp[dev]))
+		str_corrupt(ctx, ctx->mntpoint, trunc_msg(dev));
+
+	return read_verify_iterate_failed(vs->rvp[dev], report_ioerr, &dioerr);
 }
 
 /* Given bad extent lists for the data & rtdev, find bad files. */
@@ -556,13 +549,6 @@ report_all_media_errors(
 {
 	int				ret;
 
-	if (vs->d_trunc)
-		str_corrupt(ctx, ctx->mntpoint, _("data device truncated"));
-	if (vs->l_trunc)
-		str_corrupt(ctx, ctx->mntpoint, _("log device truncated"));
-	if (vs->r_trunc)
-		str_corrupt(ctx, ctx->mntpoint, _("rt device truncated"));
-
 	ret = report_disk_ioerrs(ctx, vs, XFS_DEV_DATA);
 	if (ret) {
 		str_liberror(ctx, ret, _("walking datadev io errors"));
@@ -682,10 +668,10 @@ static int
 clean_pool(
 	struct media_verify_state	*vs,
 	enum xfs_device			dev,
-	unsigned long long		*bytes_checked)
+	unsigned long long		*bytes_checked,
+	bool				*ok)
 {
 	struct read_verify_pool		*rvp = vs->rvp[dev];
-	uint64_t			pool_checked;
 	int				ret;
 
 	if (!rvp)
@@ -693,56 +679,12 @@ clean_pool(
 
 	ret = read_verify_pool_flush(rvp);
 	if (ret)
-		goto out_destroy;
+		return ret;
 
-	ret = read_verify_bytes(rvp, &pool_checked);
-	if (ret)
-		goto out_destroy;
-
-	*bytes_checked += pool_checked;
-out_destroy:
-	read_verify_pool_destroy(rvp);
-	return ret;
-}
-
-/* Remember a media error for later. */
-static void
-remember_ioerr(
-	struct scrub_ctx		*ctx,
-	enum xfs_device			dev,
-	uint64_t			start,
-	uint64_t			length,
-	int				error,
-	void				*arg)
-{
-	struct media_verify_state	*vs = arg;
-	struct bitmap			*tree;
-	int				ret;
-
-	if (!length) {
-		switch (dev) {
-		case XFS_DEV_DATA:
-			vs->d_trunc = true;
-			break;
-		case XFS_DEV_LOG:
-			vs->l_trunc = true;
-			break;
-		case XFS_DEV_RT:
-			vs->r_trunc = true;
-			break;
-		}
-		return;
-	}
-
-	tree = bitmap_for_disk(dev, vs);
-	if (!tree) {
-		str_liberror(ctx, ENOENT, _("finding bad block bitmap"));
-		return;
-	}
-
-	ret = -bitmap_set(tree, start, length);
-	if (ret)
-		str_liberror(ctx, ret, _("setting bad block bitmap"));
+	*bytes_checked += read_verify_progress(rvp);
+	if (!read_verify_ok(rvp))
+		*ok = false;
+	return 0;
 }
 
 static inline int
@@ -751,8 +693,7 @@ alloc_pool(
 	struct media_verify_state	*vs,
 	enum xfs_device			dev)
 {
-	return read_verify_pool_alloc(ctx, dev, remember_ioerr, vs,
-			&vs->rvp[dev]);
+	return read_verify_pool_alloc(ctx, dev, &vs->rvp[dev]);
 }
 
 static inline void
@@ -779,30 +720,13 @@ phase6_func(
 	struct scrub_ctx		*ctx)
 {
 	struct media_verify_state	vs = { NULL };
+	bool				ok = true;
 	int				ret, ret2, ret3;
 
-	ret = -bitmap_alloc(&vs.d_bad);
-	if (ret) {
-		str_liberror(ctx, ret, _("creating datadev badblock bitmap"));
-		return ret;
-	}
-
-	ret = -bitmap_alloc(&vs.r_bad);
-	if (ret) {
-		str_liberror(ctx, ret, _("creating realtime badblock bitmap"));
-		goto out_dbad;
-	}
-
-	ret = -bitmap_alloc(&vs.l_bad);
-	if (ret) {
-		str_liberror(ctx, ret, _("creating log badblock bitmap"));
-		goto out_rbad;
-	}
-
 	ret = alloc_pool(ctx, &vs, XFS_DEV_DATA);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
-		goto out_lbad;
+		return ret;
 	}
 	if (ctx->fsinfo.fs_log) {
 		ret = alloc_pool(ctx, &vs, XFS_DEV_LOG);
@@ -839,15 +763,15 @@ phase6_func(
 	ptvar_free(vs.verify_schedules);
 	vs.verify_schedules = NULL;
 
-	ret = clean_pool(&vs, XFS_DEV_DATA, &ctx->bytes_checked);
+	ret = clean_pool(&vs, XFS_DEV_DATA, &ctx->bytes_checked, &ok);
 	if (ret)
 		str_liberror(ctx, ret, _("flushing datadev verify pool"));
 
-	ret2 = clean_pool(&vs, XFS_DEV_LOG, &ctx->bytes_checked);
+	ret2 = clean_pool(&vs, XFS_DEV_LOG, &ctx->bytes_checked, &ok);
 	if (ret2)
 		str_liberror(ctx, ret2, _("flushing logdev verify pool"));
 
-	ret3 = clean_pool(&vs, XFS_DEV_RT, &ctx->bytes_checked);
+	ret3 = clean_pool(&vs, XFS_DEV_RT, &ctx->bytes_checked, &ok);
 	if (ret3)
 		str_liberror(ctx, ret3, _("flushing rtdev verify pool"));
 
@@ -855,22 +779,14 @@ phase6_func(
 	 * If the verify flush didn't work or we found no bad blocks, we're
 	 * done!  No errors detected.
 	 */
-	if (ret || ret2 || ret3) {
+	if (ret || ret2 || ret3 || ok) {
 		ret |= ret2 | ret3; /* caller only cares about non-zero/zero */
-		goto out_lbad;
+		goto out_rtpool;
 	}
-	if (bitmap_empty(vs.d_bad) && !vs.d_trunc &&
-	    bitmap_empty(vs.r_bad) && !vs.r_trunc &&
-	    bitmap_empty(vs.l_bad) && !vs.l_trunc)
-		goto out_lbad;
 
 	/* Scan the whole dir tree to see what matches the bad extents. */
 	ret = report_all_media_errors(ctx, &vs);
-
-	bitmap_free(&vs.l_bad);
-	bitmap_free(&vs.r_bad);
-	bitmap_free(&vs.d_bad);
-	return ret;
+	goto out_rtpool;
 
 out_schedules:
 	ptvar_free(vs.verify_schedules);
@@ -880,12 +796,6 @@ phase6_func(
 	free_pool(&vs, XFS_DEV_LOG);
 out_datapool:
 	free_pool(&vs, XFS_DEV_DATA);
-out_lbad:
-	bitmap_free(&vs.l_bad);
-out_rbad:
-	bitmap_free(&vs.r_bad);
-out_dbad:
-	bitmap_free(&vs.d_bad);
 	return ret;
 }
 
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 66086d6fe2d56d..3334f8d8c79ca2 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -9,6 +9,7 @@
 #include <sys/statvfs.h>
 #include "libfrog/workqueue.h"
 #include "libfrog/paths.h"
+#include "libfrog/bitmap.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "counter.h"
@@ -58,8 +59,6 @@ struct read_verify_pool {
 	struct scrub_ctx	*ctx;		/* scrub context */
 	void			*readbuf;	/* read buffer */
 	struct ptcounter	*verified_bytes;
-	void			*ioerr_arg;
-	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
 	size_t			miniosz;	/* minimum io size, bytes */
 	enum xfs_device		dev;		/* which device? */
 
@@ -68,6 +67,10 @@ struct read_verify_pool {
 	 * return it to the caller.
 	 */
 	int			runtime_error;
+
+	/* outputs: a bad block bitmap and a truncated flag */
+	struct bitmap		*failmap;
+	bool			truncated;
 };
 
 unsigned int
@@ -88,15 +91,11 @@ read_verify_nproc(
 
 /*
  * Create a thread pool to run read verifiers.
- *
- * @ioerr_fn will be called when IO errors occur.
  */
 int
 read_verify_pool_alloc(
 	struct scrub_ctx		*ctx,
 	enum xfs_device			dev,
-	read_verify_ioerr_fn_t		ioerr_fn,
-	void				*ioerr_arg,
 	struct read_verify_pool		**prvp)
 {
 	struct read_verify_pool		*rvp;
@@ -121,8 +120,6 @@ read_verify_pool_alloc(
 	rvp->miniosz = ctx->mnt.fsgeom.blocksize;
 	rvp->ctx = ctx;
 	rvp->dev = dev;
-	rvp->ioerr_fn = ioerr_fn;
-	rvp->ioerr_arg = ioerr_arg;
 	ret = -workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
 			verifier_threads == 1 ? 0 : verifier_threads);
 	if (ret)
@@ -146,7 +143,8 @@ read_verify_pool_abort(
 {
 	if (!rvp->runtime_error)
 		rvp->runtime_error = ECANCELED;
-	workqueue_terminate(&rvp->wq);
+	if (!rvp->wq.terminated)
+		workqueue_terminate(&rvp->wq);
 }
 
 /* Finish up any read verification work. */
@@ -163,6 +161,7 @@ read_verify_pool_destroy(
 	struct read_verify_pool		*rvp)
 {
 	workqueue_destroy(&rvp->wq);
+	bitmap_free(&rvp->failmap);
 	ptcounter_free(rvp->verified_bytes);
 	free(rvp->readbuf);
 	free(rvp);
@@ -286,6 +285,49 @@ read_verify_one(
 			single_step);
 }
 
+/* Remember a media error for later. */
+static int
+read_verify_error(
+	struct read_verify_pool		*rvp,
+	uint64_t			start,
+	uint64_t			length,
+	int				error)
+{
+	static pthread_mutex_t		lock = PTHREAD_MUTEX_INITIALIZER;
+	int				ret;
+
+	if (!length) {
+		rvp->truncated = true;
+		return 0;
+	}
+
+	if (!rvp->failmap) {
+		struct bitmap *failmap;
+
+		ret = -bitmap_alloc(&failmap);
+		if (ret) {
+			str_liberror(rvp->ctx, ret,
+ _("allocating bad block bitmap"));
+			return ret;
+		}
+
+		pthread_mutex_lock(&lock);
+		if (!rvp->failmap)
+			rvp->failmap = failmap;
+		else
+			bitmap_free(&failmap);
+		pthread_mutex_unlock(&lock);
+	}
+
+	ret = -bitmap_set(rvp->failmap, start, length);
+	if (ret) {
+		str_liberror(rvp->ctx, ret, _("setting bad block bitmap"));
+		return ret;
+	}
+
+	return 0;
+}
+
 /*
  * Issue a read-verify IO in big batches.
  */
@@ -302,7 +344,7 @@ read_verify(
 	ssize_t				sz;
 	ssize_t				len;
 	int				read_error;
-	int				ret;
+	int				ret = 0, ret2;
 
 	rvp = (struct read_verify_pool *)wq->wq_ctx;
 	if (rvp->runtime_error)
@@ -356,14 +398,18 @@ read_verify(
 			sz = rvp->miniosz - (rv->io_start % rvp->miniosz);
 			dbg_printf("IOERR %u @ %"PRIu64" %zu err %d\n",
 					rvp->dev, rv->io_start, sz, read_error);
-			rvp->ioerr_fn(rvp->ctx, rvp->dev, rv->io_start, sz,
-					read_error, rvp->ioerr_arg);
+			ret = read_verify_error(rvp, rv->io_start, sz,
+					read_error);
+			if (ret)
+				goto out_err;
 		} else if (sz == 0) {
 			/* No bytes at all?  Did we hit the end of the disk? */
 			dbg_printf("EOF %u @ %"PRIu64" %zu err %d\n",
 					rvp->dev, rv->io_start, sz, read_error);
-			rvp->ioerr_fn(rvp->ctx, rvp->dev, rv->io_start, sz,
-					read_error, rvp->ioerr_arg);
+			ret = read_verify_error(rvp, rv->io_start, sz,
+					read_error);
+			if (ret)
+				goto out_err;
 			break;
 		} else if (sz < len) {
 			/*
@@ -392,8 +438,11 @@ read_verify(
 		background_sleep();
 	}
 
+out_err:
 	free(rv);
-	ret = ptcounter_add(rvp->verified_bytes, verified);
+	ret2 = ptcounter_add(rvp->verified_bytes, verified);
+	if (!ret && ret2)
+		ret = ret2;
 	if (ret)
 		rvp->runtime_error = ret;
 }
@@ -491,11 +540,69 @@ try_read_verify_schedule_io(
 	return false;
 }
 
-/* How many bytes has this process verified? */
+/* Did read verification succeed? */
+bool
+read_verify_ok(
+	const struct read_verify_pool	*rvp)
+{
+	return rvp->failmap == NULL && !rvp->truncated;
+}
+
+/* Did the verification unexpectedly stop early due to short reads? */
+bool
+read_verify_truncated(
+	const struct read_verify_pool	*rvp)
+{
+	return rvp->truncated;
+}
+
+/* How many bytes has this pool verified? */
+uint64_t
+read_verify_progress(
+	const struct read_verify_pool	*rvp)
+{
+	uint64_t			ret = 0;
+
+	ptcounter_value(rvp->verified_bytes, &ret);
+	return ret;
+}
+
+/* Call @fn for every media failure this pool observed. */
 int
-read_verify_bytes(
+read_verify_iterate_failed(
+	struct read_verify_pool		*rvp,
+	int				(*fn)(uint64_t, uint64_t, void *),
+	void				*arg)
+{
+	if (!rvp->failmap)
+		return 0;
+
+	return -bitmap_iterate(rvp->failmap, fn, arg);
+}
+
+/* Call @fn for every media failure this pool observed in the given range. */
+int
+read_verify_iterate_failed_range(
+	struct read_verify_pool		*rvp,
+	uint64_t			start,
+	uint64_t			length,
+	int				(*fn)(uint64_t, uint64_t, void *),
+	void				*arg)
+{
+	if (!rvp->failmap)
+		return 0;
+
+	return -bitmap_iterate_range(rvp->failmap, start, length, fn, arg);
+}
+
+/* Were there any media failures within the given range? */
+bool
+read_verify_has_failed(
 	struct read_verify_pool		*rvp,
-	uint64_t			*bytes_checked)
+	uint64_t			start,
+	uint64_t			length)
 {
-	return ptcounter_value(rvp->verified_bytes, bytes_checked);
+	if (rvp->failmap)
+		return bitmap_test(rvp->failmap, start, length);
+	return false;
 }

