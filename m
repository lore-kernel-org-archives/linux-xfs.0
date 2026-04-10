Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B21346AFB
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801952; cv=none; b=EUMY9YtTaG569e8C9KNUlLwoLVQROjX2mf4Lbum54puKTKelQQVfAW+/wRZ4GkBp10jn0Narz2dj8Vi4J3CZj69zn9xWrJsqwie/3wobb7xXTEu/l4DNBUq5WoPGgU0T6bYmBPXCzjIZyJtMOdeXxnNusEEVtWkgB5bt/Q61agY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801952; c=relaxed/simple;
	bh=ccpYtXcejRhVkQBdXgrrPNIZt7t8YqL+9fmTv3xbu5A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z17W5YNNm2zyBrCVqofozujw+ezuUpLfw1oBvX0GWNrXvoOt2/xzry8v/rUYq+byHRsw/+8pL9pkfCV7b4vh7vYq57rdpo93XfHm5PohMEpXA+Z/SExga1ezGstui9N9lL5cMAfEATfy/a55IG+/Z8rel7gTRvGiyxDTGrwakgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qr/C6QOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qr/C6QOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3B8C19421;
	Fri, 10 Apr 2026 06:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801952;
	bh=ccpYtXcejRhVkQBdXgrrPNIZt7t8YqL+9fmTv3xbu5A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qr/C6QOZO7//4qwnApY/QeHoXEdiyzrW318SDAMftnivhHKWPgxubKMcb7XPnoktO
	 clG3z+O52Tcqh5L0t5MGkoTWVlEE1jRxIZqdsoCNEkTwSVSXJKNcBTWDERXcjW5AwT
	 OukzQ+pUpjzApRIrLi+Qaz7NBW4whe1zwLeSGKGg4mRSWMMCOHXu0V66uVipoW0h7U
	 KuN5UxvklK5PZNR0sIMg+YGIiQ58FGTqmeLuoclSk27xmZsu40mJ+tgfYBuUoDxQnA
	 qMHS9wsZ4RFIZDiyf4+1NGdT7bShzUiTgTgd0q6vIHTKR21i7KRGpvqxK1HEbq0cSI
	 hLm/QQFDFT2MQ==
Date: Thu, 09 Apr 2026 23:19:12 -0700
Subject: [PATCH 07/21] xfs_scrub: move read verification scheduling to
 phase6.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385160.2090237.7033718373509147615.stgit@frogsfrogsfrogs>
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

Right now there's a weird coupling between read_verify.c and spacemap.c:
Anyone using a read_verify_pool is required to tell the pool how many
threads it's going to use to call read_verify_schedule_io.  This is
because the read_verify_pool accumulates verification requests on a
per-thread basis to try to combine adjacent written regions for media
verification.  However, the verification requests are made from the
phase6.c callback (check_rmap) that is called from the workers created
by scrub_scan_all_spacemaps.

Yeah, that's confusing: implementation details of spacemap.c must be
inferred by phase6.c and passed to read_verify.c.

Let's fix this by moving the per-thread schedule accumulation to
phase6.c before the next patches constrain the number of IO threads
sending verification requests to the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/read_verify.h |   16 +++++--
 scrub/spacemap.h    |    5 ++
 scrub/phase6.c      |   63 ++++++++++++++++++++++-----
 scrub/read_verify.c |  121 ++++++++++++++++++---------------------------------
 4 files changed, 112 insertions(+), 93 deletions(-)


diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index 9d34d839c978b4..383823c3b5c640 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -10,6 +10,13 @@ struct scrub_ctx;
 struct read_verify_pool;
 struct disk;
 
+struct read_verify_schedule {
+	struct read_verify_pool	*rvp;
+	void			*io_end_arg;
+	uint64_t		io_start;	/* bytes */
+	uint64_t		io_length;	/* bytes */
+};
+
 /* Function called when an IO error happens. */
 typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
 		struct disk *disk, uint64_t start, uint64_t length,
@@ -17,15 +24,16 @@ typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
 
 int read_verify_pool_alloc(struct scrub_ctx *ctx, struct disk *disk,
 		size_t miniosz, read_verify_ioerr_fn_t ioerr_fn,
-		unsigned int submitter_threads,
 		struct read_verify_pool **prvp);
 void read_verify_pool_abort(struct read_verify_pool *rvp);
 int read_verify_pool_flush(struct read_verify_pool *rvp);
 void read_verify_pool_destroy(struct read_verify_pool *rvp);
 
-int read_verify_schedule_io(struct read_verify_pool *rvp, uint64_t start,
-		uint64_t length, void *end_arg);
-int read_verify_force_io(struct read_verify_pool *rvp);
+int read_verify_schedule_now(struct read_verify_schedule *rs);
+bool try_read_verify_schedule_io(struct read_verify_schedule *rs,
+		struct read_verify_pool *rvp, uint64_t start, uint64_t length,
+		void *end_arg);
+
 int read_verify_bytes(struct read_verify_pool *rvp, uint64_t *bytes);
 
 #endif /* XFS_SCRUB_READ_VERIFY_H_ */
diff --git a/scrub/spacemap.h b/scrub/spacemap.h
index 51975341b16d6b..759d0f89089a23 100644
--- a/scrub/spacemap.h
+++ b/scrub/spacemap.h
@@ -18,4 +18,9 @@ int scrub_iterate_fsmap(struct scrub_ctx *ctx, struct fsmap *keys,
 int scrub_scan_all_spacemaps(struct scrub_ctx *ctx, scrub_fsmap_iter_fn fn,
 		void *arg);
 
+static inline unsigned int scrub_scan_spacemaps_nproc(struct scrub_ctx *ctx)
+{
+	return scrub_nproc(ctx);
+}
+
 #endif /* XFS_SCRUB_SPACEMAP_H_ */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 41b41aab7e2578..1b71bdb4b221a3 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -23,6 +23,7 @@
 #include "vfs.h"
 #include "common.h"
 #include "libfrog/bulkstat.h"
+#include "libfrog/ptvar.h"
 
 /*
  * Phase 6: Verify data file integrity.
@@ -39,6 +40,8 @@
 /* Verify disk blocks with GETFSMAP */
 
 struct media_verify_state {
+	struct ptvar		*verify_schedules;
+
 	struct read_verify_pool	*rvp_data;
 	struct read_verify_pool	*rvp_log;
 	struct read_verify_pool	*rvp_realtime;
@@ -604,6 +607,8 @@ check_rmap(
 {
 	struct media_verify_state	*vs = arg;
 	struct read_verify_pool		*rvp;
+	struct read_verify_schedule	*rs;
+	bool				scheduled;
 	int				ret;
 
 	rvp = dev_to_pool(ctx, vs, map->fmr_device);
@@ -632,17 +637,42 @@ check_rmap(
 
 	/* XXX: Filter out directory data blocks. */
 
+	rs = ptvar_get(vs->verify_schedules, &ret);
+	if (ret) {
+		str_liberror(ctx, -ret, _("grabbing media verify schedule"));
+		return -ret;
+	}
+
 	/* Schedule the read verify command for (eventual) running. */
-	ret = read_verify_schedule_io(rvp, map->fmr_physical, map->fmr_length,
-			vs);
+	scheduled = try_read_verify_schedule_io(rs, rvp, map->fmr_physical,
+			map->fmr_length, vs);
+	if (scheduled)
+		return 0;
+
+	ret = read_verify_schedule_now(rs);
 	if (ret) {
 		str_liberror(ctx, ret, _("scheduling media verify command"));
 		return ret;
 	}
 
+	scheduled = try_read_verify_schedule_io(rs, rvp, map->fmr_physical,
+			map->fmr_length, vs);
+	assert(scheduled);
 	return 0;
 }
 
+/* Initiate any scheduled verifications now. */
+static int
+force_one_verify(
+	struct ptvar			*ptv,
+	void				*data,
+	void				*foreach_arg)
+{
+	struct read_verify_schedule	*rs = data;
+
+	return -read_verify_schedule_now(rs);
+}
+
 /* Wait for read/verify actions to finish, then return # bytes checked. */
 static int
 clean_pool(
@@ -655,10 +685,6 @@ clean_pool(
 	if (!rvp)
 		return 0;
 
-	ret = read_verify_force_io(rvp);
-	if (ret)
-		return ret;
-
 	ret = read_verify_pool_flush(rvp);
 	if (ret)
 		goto out_destroy;
@@ -737,7 +763,7 @@ phase6_func(
 
 	ret = read_verify_pool_alloc(ctx, ctx->datadev,
 			ctx->mnt.fsgeom.blocksize, remember_ioerr,
-			scrub_nproc(ctx), &vs.rvp_data);
+			&vs.rvp_data);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
 		goto out_rbad;
@@ -745,7 +771,7 @@ phase6_func(
 	if (ctx->logdev) {
 		ret = read_verify_pool_alloc(ctx, ctx->logdev,
 				ctx->mnt.fsgeom.blocksize, remember_ioerr,
-				scrub_nproc(ctx), &vs.rvp_log);
+				&vs.rvp_log);
 		if (ret) {
 			str_liberror(ctx, ret,
 					_("creating logdev media verifier"));
@@ -755,17 +781,32 @@ phase6_func(
 	if (ctx->rtdev) {
 		ret = read_verify_pool_alloc(ctx, ctx->rtdev,
 				ctx->mnt.fsgeom.blocksize, remember_ioerr,
-				scrub_nproc(ctx), &vs.rvp_realtime);
+				&vs.rvp_realtime);
 		if (ret) {
 			str_liberror(ctx, ret,
 					_("creating rtdev media verifier"));
 			goto out_logpool;
 		}
 	}
-	ret = scrub_scan_all_spacemaps(ctx, check_rmap, &vs);
+
+	ret = -ptvar_alloc(scrub_scan_spacemaps_nproc(ctx),
+			sizeof(struct read_verify_schedule), NULL,
+			&vs.verify_schedules);
 	if (ret)
 		goto out_rtpool;
 
+	ret = scrub_scan_all_spacemaps(ctx, check_rmap, &vs);
+	if (ret)
+		goto out_schedules;
+
+	ret = -ptvar_foreach(vs.verify_schedules, force_one_verify, NULL);
+	if (ret) {
+		str_liberror(ctx, ret, _("flushing read verify commands"));
+		goto out_schedules;
+	}
+	ptvar_free(vs.verify_schedules);
+	vs.verify_schedules = NULL;
+
 	ret = clean_pool(vs.rvp_data, &ctx->bytes_checked);
 	if (ret)
 		str_liberror(ctx, ret, _("flushing datadev verify pool"));
@@ -798,6 +839,8 @@ phase6_func(
 	bitmap_free(&vs.d_bad);
 	return ret;
 
+out_schedules:
+	ptvar_free(vs.verify_schedules);
 out_rtpool:
 	if (vs.rvp_realtime) {
 		read_verify_pool_abort(vs.rvp_realtime);
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 56df7a40d6c07a..2447ed272734be 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -7,7 +7,6 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
-#include "libfrog/ptvar.h"
 #include "libfrog/workqueue.h"
 #include "libfrog/paths.h"
 #include "xfs_scrub.h"
@@ -60,7 +59,6 @@ struct read_verify_pool {
 	struct scrub_ctx	*ctx;		/* scrub context */
 	void			*readbuf;	/* read buffer */
 	struct ptcounter	*verified_bytes;
-	struct ptvar		*rvstate;	/* combines read requests */
 	struct disk		*disk;		/* which disk? */
 	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
 	size_t			miniosz;	/* minimum io size, bytes */
@@ -78,8 +76,6 @@ struct read_verify_pool {
  * @disk is the disk we want to verify.
  * @miniosz is the minimum size of an IO to expect (in bytes).
  * @ioerr_fn will be called when IO errors occur.
- * @submitter_threads is the number of threads that may be sending verify
- * requests at any given time.
  */
 int
 read_verify_pool_alloc(
@@ -87,7 +83,6 @@ read_verify_pool_alloc(
 	struct disk			*disk,
 	size_t				miniosz,
 	read_verify_ioerr_fn_t		ioerr_fn,
-	unsigned int			submitter_threads,
 	struct read_verify_pool		**prvp)
 {
 	struct read_verify_pool		*rvp;
@@ -118,19 +113,13 @@ read_verify_pool_alloc(
 	rvp->ctx = ctx;
 	rvp->disk = disk;
 	rvp->ioerr_fn = ioerr_fn;
-	ret = -ptvar_alloc(submitter_threads, sizeof(struct read_verify),
-			NULL, &rvp->rvstate);
-	if (ret)
-		goto out_counter;
 	ret = -workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
 			verifier_threads == 1 ? 0 : verifier_threads);
 	if (ret)
-		goto out_rvstate;
+		goto out_counter;
 	*prvp = rvp;
 	return 0;
 
-out_rvstate:
-	ptvar_free(rvp->rvstate);
 out_counter:
 	ptcounter_free(rvp->verified_bytes);
 out_buf:
@@ -164,7 +153,6 @@ read_verify_pool_destroy(
 	struct read_verify_pool		*rvp)
 {
 	workqueue_destroy(&rvp->wq);
-	ptvar_free(rvp->rvstate);
 	ptcounter_free(rvp->verified_bytes);
 	free(rvp->readbuf);
 	free(rvp);
@@ -285,17 +273,20 @@ read_verify(
 		rvp->runtime_error = ret;
 }
 
-/* Queue a read verify request. */
-static int
-read_verify_queue(
-	struct read_verify_pool		*rvp,
-	struct read_verify		*rv)
+/* Queue a read verify request immediately. */
+int
+read_verify_schedule_now(
+	struct read_verify_schedule	*rs)
 {
+	struct read_verify_pool		*rvp = rs->rvp;
 	struct read_verify		*tmp;
 	bool				ret;
 
+	if (!rvp)
+		return 0;
+
 	dbg_printf("verify fd %d start %"PRIu64" len %"PRIu64"\n",
-			rvp->disk->d_fd, rv->io_start, rv->io_length);
+			rvp->disk->d_fd, rs->io_start, rs->io_length);
 
 	/* Worker thread saw a runtime error, don't queue more. */
 	if (rvp->runtime_error)
@@ -308,7 +299,9 @@ read_verify_queue(
 		return errno;
 	}
 
-	memcpy(tmp, rv, sizeof(*tmp));
+	tmp->io_end_arg = rs->io_end_arg;
+	tmp->io_start = rs->io_start;
+	tmp->io_length = rs->io_length;
 
 	ret = -workqueue_add(&rvp->wq, read_verify, 0, tmp);
 	if (ret) {
@@ -317,25 +310,27 @@ read_verify_queue(
 		return ret;
 	}
 
-	rv->io_length = 0;
+	/* Reset the schedule */
+	rs->rvp = NULL;
+	rs->io_length = 0;
 	return 0;
 }
 
 /*
- * Issue an IO request.  We'll batch subsequent requests if they're
- * within 64k of each other
+ * Schedule a read verification request.  We'll batch subsequent requests if
+ * they're within 64k of each other.  Returns true if the schedule was updated,
+ * or false if the caller should call read_verify_schedule_now().
  */
-int
-read_verify_schedule_io(
+bool
+try_read_verify_schedule_io(
+	struct read_verify_schedule	*rs,
 	struct read_verify_pool		*rvp,
 	uint64_t			start,
 	uint64_t			length,
 	void				*end_arg)
 {
-	struct read_verify		*rv;
 	uint64_t			req_end;
 	uint64_t			rv_end;
-	int				ret;
 
 	assert(rvp->readbuf);
 
@@ -343,67 +338,35 @@ read_verify_schedule_io(
 	start &= ~(rvp->miniosz - 1);
 	length = roundup(length, rvp->miniosz);
 
-	rv = ptvar_get(rvp->rvstate, &ret);
-	if (ret)
-		return -ret;
 	req_end = start + length;
-	rv_end = rv->io_start + rv->io_length;
+	rv_end = rs->io_start + rs->io_length;
+
+	/* If the schedule is empty, stash the new IO. */
+	if (!rs->rvp) {
+		rs->rvp = rvp;
+		rs->io_start = start;
+		rs->io_length = length;
+		rs->io_end_arg = end_arg;
+
+		return true;
+	}
 
 	/*
-	 * If we have a stashed IO, we haven't changed fds, the error
+	 * If we have a stashed IO, we haven't changed pools, the error
 	 * reporting is the same, and the two extents are close,
 	 * we can combine them.
 	 */
-	if (rv->io_length > 0 &&
-	    end_arg == rv->io_end_arg &&
-	    ((start >= rv->io_start && start <= rv_end + RVP_IO_BATCH_LOCALITY) ||
-	     (rv->io_start >= start &&
-	      rv->io_start <= req_end + RVP_IO_BATCH_LOCALITY))) {
-		rv->io_start = min(rv->io_start, start);
-		rv->io_length = max(req_end, rv_end) - rv->io_start;
-	} else  {
-		/* Otherwise, issue the stashed IO (if there is one) */
-		if (rv->io_length > 0) {
-			int	res;
+	if (rs->rvp == rvp && rs->io_length > 0 && end_arg == rs->io_end_arg &&
+	    ((start >= rs->io_start && start <= rv_end + RVP_IO_BATCH_LOCALITY) ||
+	     (rs->io_start >= start &&
+	      rs->io_start <= req_end + RVP_IO_BATCH_LOCALITY))) {
+		rs->io_start = min(rs->io_start, start);
+		rs->io_length = max(req_end, rv_end) - rs->io_start;
 
-			res = read_verify_queue(rvp, rv);
-			if (res)
-				return res;
-		}
-
-		/* Stash the new IO. */
-		rv->io_start = start;
-		rv->io_length = length;
-		rv->io_end_arg = end_arg;
+		return true;
 	}
 
-	return 0;
-}
-
-/* Force any per-thread stashed IOs into the verifier. */
-static int
-force_one_io(
-	struct ptvar		*ptv,
-	void			*data,
-	void			*foreach_arg)
-{
-	struct read_verify_pool	*rvp = foreach_arg;
-	struct read_verify	*rv = data;
-
-	if (rv->io_length == 0)
-		return 0;
-
-	return -read_verify_queue(rvp, rv);
-}
-
-/* Force any stashed IOs into the verifier. */
-int
-read_verify_force_io(
-	struct read_verify_pool		*rvp)
-{
-	assert(rvp->readbuf);
-
-	return -ptvar_foreach(rvp->rvstate, force_one_io, rvp);
+	return false;
 }
 
 /* How many bytes has this process verified? */

