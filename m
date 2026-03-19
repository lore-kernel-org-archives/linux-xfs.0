Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAFB1F16B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895673; cv=none; b=IJ7vNxc6kBLYObruq4JymUCq2MD5BHF5djxLcEfN/O+Es2XMWEUEwEaqJNtdJXqIRsntWRdun5bCJgc8y1TKQAVgP90Fj2dP4RzmlP9b39idDmSiIBeD38bbEl65JFLSOwoCyaHLmFr3T1TjfNUNIIq9tKewT1J2mPIpW7jC6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895673; c=relaxed/simple;
	bh=2o1ClrwIYuH5GdVQfeDH9WYeGXSOBh4q8Y9bNPOUSAM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uyIXnpjfcfqt2+SsQlEpEiNe68fY5CABl023vwHKXrzsfwQfuNv17OjmxjeCWnUPZwBIa1142O93dZq85FNDVhQQ6nDee3GWukWI/SEdB8l+JGx8UNKK8zEaCWGXE6Gw46Hkg8Am3BzWIAiLk2pGcV7LvGpnFQXv4driQR+Y+5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVPAF019; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVPAF019"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DA2C19425;
	Thu, 19 Mar 2026 04:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895673;
	bh=2o1ClrwIYuH5GdVQfeDH9WYeGXSOBh4q8Y9bNPOUSAM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eVPAF019CSUkdjzcqxf3ftFOjEWvLXYfC0BSP1942bk6QFBu48INKRUi1BgnKY69r
	 2i37rY1RPtlMDkfs7o/ugNemssa86Mnri40Nmt/TJjhMF657iXhblkbGjx4g/isNse
	 Gdu8MImP4oFd7BF1yWQ6dzlREDIa85lDKHmbm1+PILI2+iQ/NEryPLGCJdBSGv7i81
	 40PK26MVaK+8cXliKHTpN9GI3cjSWI0aGPLEv1OhtAVrpOhi4dZ2vesk8TSwu8MTW2
	 I5EvOKTEnzRWyr2SjchBu9+uWAi8+r3IlPSSNtkNw2oihryaiGkaAFCE5mYlpJIpvo
	 2L8baXQ0SkB+g==
Date: Wed, 18 Mar 2026 21:47:52 -0700
Subject: [PATCH 09/22] xfs_scrub: don't pass the io_end_arg around everywhere
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389507105.3681140.8365829305308981282.stgit@frogsfrogsfrogs>
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

The value is the same across all callers and read-verify pools, so let's
just pass it into read_verify_pool_alloc instead of making temporary
aliases everywhere and increasing memory usage.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/read_verify.h |    6 ++----
 scrub/phase6.c      |   10 +++++-----
 scrub/read_verify.c |   15 +++++++--------
 3 files changed, 14 insertions(+), 17 deletions(-)


diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index a46244334268de..165ad8f7af7b6c 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -12,7 +12,6 @@ struct disk;
 
 struct read_verify_schedule {
 	struct read_verify_pool	*rvp;
-	void			*io_end_arg;
 	uint64_t		io_start;	/* bytes */
 	uint64_t		io_length;	/* bytes */
 };
@@ -23,7 +22,7 @@ typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
 		int error, void *arg);
 
 int read_verify_pool_alloc(struct scrub_ctx *ctx, struct disk *disk,
-		read_verify_ioerr_fn_t ioerr_fn,
+		read_verify_ioerr_fn_t ioerr_fn, void *ioerr_arg,
 		struct read_verify_pool **prvp);
 void read_verify_pool_abort(struct read_verify_pool *rvp);
 int read_verify_pool_flush(struct read_verify_pool *rvp);
@@ -31,8 +30,7 @@ void read_verify_pool_destroy(struct read_verify_pool *rvp);
 
 int read_verify_schedule_now(struct read_verify_schedule *rs);
 bool try_read_verify_schedule_io(struct read_verify_schedule *rs,
-		struct read_verify_pool *rvp, uint64_t start, uint64_t length,
-		void *end_arg);
+		struct read_verify_pool *rvp, uint64_t start, uint64_t length);
 
 int read_verify_bytes(struct read_verify_pool *rvp, uint64_t *bytes);
 
diff --git a/scrub/phase6.c b/scrub/phase6.c
index bfd5659590d603..3e6a236d010a6b 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -645,7 +645,7 @@ check_rmap(
 
 	/* Schedule the read verify command for (eventual) running. */
 	scheduled = try_read_verify_schedule_io(rs, rvp, map->fmr_physical,
-			map->fmr_length, vs);
+			map->fmr_length);
 	if (scheduled)
 		return 0;
 
@@ -656,7 +656,7 @@ check_rmap(
 	}
 
 	scheduled = try_read_verify_schedule_io(rs, rvp, map->fmr_physical,
-			map->fmr_length, vs);
+			map->fmr_length);
 	assert(scheduled);
 	return 0;
 }
@@ -761,7 +761,7 @@ phase6_func(
 		goto out_dbad;
 	}
 
-	ret = read_verify_pool_alloc(ctx, ctx->datadev, remember_ioerr,
+	ret = read_verify_pool_alloc(ctx, ctx->datadev, remember_ioerr, &vs,
 			&vs.rvp_data);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
@@ -769,7 +769,7 @@ phase6_func(
 	}
 	if (ctx->logdev) {
 		ret = read_verify_pool_alloc(ctx, ctx->logdev, remember_ioerr,
-				&vs.rvp_log);
+				&vs, &vs.rvp_log);
 		if (ret) {
 			str_liberror(ctx, ret,
 					_("creating logdev media verifier"));
@@ -778,7 +778,7 @@ phase6_func(
 	}
 	if (ctx->rtdev) {
 		ret = read_verify_pool_alloc(ctx, ctx->rtdev, remember_ioerr,
-				&vs.rvp_realtime);
+				&vs, &vs.rvp_realtime);
 		if (ret) {
 			str_liberror(ctx, ret,
 					_("creating rtdev media verifier"));
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 128df2be86898b..bcd923e5f3cbc3 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -49,7 +49,6 @@ rvp_io_max_size(void)
 #define RVP_IO_BATCH_LOCALITY	(65536)
 
 struct read_verify {
-	void			*io_end_arg;
 	uint64_t		io_start;	/* bytes */
 	uint64_t		io_length;	/* bytes */
 };
@@ -60,6 +59,7 @@ struct read_verify_pool {
 	void			*readbuf;	/* read buffer */
 	struct ptcounter	*verified_bytes;
 	struct disk		*disk;		/* which disk? */
+	void			*ioerr_arg;
 	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
 	size_t			miniosz;	/* minimum io size, bytes */
 
@@ -81,6 +81,7 @@ read_verify_pool_alloc(
 	struct scrub_ctx		*ctx,
 	struct disk			*disk,
 	read_verify_ioerr_fn_t		ioerr_fn,
+	void				*ioerr_arg,
 	struct read_verify_pool		**prvp)
 {
 	struct read_verify_pool		*rvp;
@@ -105,6 +106,7 @@ read_verify_pool_alloc(
 	rvp->ctx = ctx;
 	rvp->disk = disk;
 	rvp->ioerr_fn = ioerr_fn;
+	rvp->ioerr_arg = ioerr_arg;
 	ret = -workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
 			verifier_threads == 1 ? 0 : verifier_threads);
 	if (ret)
@@ -223,14 +225,14 @@ read_verify(
 					rvp->disk->d_fd, rv->io_start, sz,
 					read_error);
 			rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start, sz,
-					read_error, rv->io_end_arg);
+					read_error, rvp->ioerr_arg);
 		} else if (sz == 0) {
 			/* No bytes at all?  Did we hit the end of the disk? */
 			dbg_printf("EOF %d @ %"PRIu64" %zu err %d\n",
 					rvp->disk->d_fd, rv->io_start, sz,
 					read_error);
 			rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start, sz,
-					read_error, rv->io_end_arg);
+					read_error, rvp->ioerr_arg);
 			break;
 		} else if (sz < len) {
 			/*
@@ -291,7 +293,6 @@ read_verify_schedule_now(
 		return errno;
 	}
 
-	tmp->io_end_arg = rs->io_end_arg;
 	tmp->io_start = rs->io_start;
 	tmp->io_length = rs->io_length;
 
@@ -318,8 +319,7 @@ try_read_verify_schedule_io(
 	struct read_verify_schedule	*rs,
 	struct read_verify_pool		*rvp,
 	uint64_t			start,
-	uint64_t			length,
-	void				*end_arg)
+	uint64_t			length)
 {
 	uint64_t			req_end;
 	uint64_t			rv_end;
@@ -338,7 +338,6 @@ try_read_verify_schedule_io(
 		rs->rvp = rvp;
 		rs->io_start = start;
 		rs->io_length = length;
-		rs->io_end_arg = end_arg;
 
 		return true;
 	}
@@ -348,7 +347,7 @@ try_read_verify_schedule_io(
 	 * reporting is the same, and the two extents are close,
 	 * we can combine them.
 	 */
-	if (rs->rvp == rvp && rs->io_length > 0 && end_arg == rs->io_end_arg &&
+	if (rs->rvp == rvp && rs->io_length > 0 &&
 	    ((start >= rs->io_start && start <= rv_end + RVP_IO_BATCH_LOCALITY) ||
 	     (rs->io_start >= start &&
 	      rs->io_start <= req_end + RVP_IO_BATCH_LOCALITY))) {

