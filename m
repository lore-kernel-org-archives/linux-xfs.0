Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090A31B86FF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303036; cv=none; b=acboIdDlwiG7xVwMn4AQP7FSgY9qRPFZ20uaR5+hveU+UJAnQ+YbjECn+z/CEbiPoVHeV8ujD92a3CubtwhnHDom4Qm9HRFgEGeC+XyQf24iWY8cqaOvIZZ1rk7etXlJGx9loXEPLU4lntn4/I1pPTbSgPB52QzMSI4jm30Lylw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303036; c=relaxed/simple;
	bh=rtLGbItGhO3xv1VXZFYrr/YNN7RME6n0Q0e64ieTQPY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GPLo3bnY+aY+dIsZVBLcIacN0FkoNtdeuPXWGHlPNcSSAFfteEXG/1/axokvKqxrO4DF4wEz9CLb/sxvmTJYjj0QO670mpddRwYZQMfQK+7bczARnujLbQAnkhGDnaFs7DJosrsjdSlcaNmEuafUgg6LHA0KCwEKVbkfvTghjQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWrNjdmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWrNjdmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D18C4AF0A;
	Tue, 30 Jul 2024 01:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722303035;
	bh=rtLGbItGhO3xv1VXZFYrr/YNN7RME6n0Q0e64ieTQPY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fWrNjdmvQuNwMhCfZVK/i0+x8PTLvmOK0oymYbqeHbdNhDVA56F8pC5z/BiAGkknm
	 czVb/VxvPMPtHQOC0xARePWzBBkkYadBH1WOO42ZCPsotxARWewNZcgRV1DnVAj9CC
	 AxRF+cgGvTAnedf7R3Nm4UCndq9T36sV+Iki5Hv80QcGFwahjywJfAikSiwCZjXqyw
	 3GOVyBRjuwZosOdhr93ZAdfnDZ+NYERlaUg6g0Dh+5iVlPaLM7cJUW/tlLOJe27cFN
	 W6MHJICbMx/ezkYJTeTdh7He+slgP/5h5iI5m6YBbluXjs5JeDg8zN81qTZcwpLNul
	 FAmx7p7cFaGUg==
Date: Mon, 29 Jul 2024 18:30:35 -0700
Subject: [PATCH 02/10] libfrog: support vectored scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852386.1353240.6715611447946612146.stgit@frogsfrogsfrogs>
In-Reply-To: <172229852355.1353240.6151017907178495656.stgit@frogsfrogsfrogs>
References: <172229852355.1353240.6151017907178495656.stgit@frogsfrogsfrogs>
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

Enhance libfrog to support performing vectored metadata scrub.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.h |    6 ++
 libfrog/scrub.c  |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/scrub.h  |   35 ++++++++++++++
 3 files changed, 178 insertions(+)


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index f327dc7d7..df2ca2a40 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -50,6 +50,12 @@ struct xfs_fd {
 /* Only use v5 bulkstat/inumbers ioctls. */
 #define XFROG_FLAG_BULKSTAT_FORCE_V5	(1 << 1)
 
+/* Only use the older one-at-a-time scrub ioctl. */
+#define XFROG_FLAG_SCRUB_FORCE_SINGLE	(1 << 2)
+
+/* Only use the vectored scrub ioctl. */
+#define XFROG_FLAG_SCRUB_FORCE_VECTOR	(1 << 3)
+
 /* Static initializers */
 #define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
 #define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index a2146e228..e233c0f9c 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -171,3 +171,140 @@ xfrog_scrub_metadata(
 
 	return 0;
 }
+
+/* Decide if there have been any scrub failures up to this point. */
+static inline int
+xfrog_scrubv_check_barrier(
+	const struct xfs_scrub_vec	*vectors,
+	const struct xfs_scrub_vec	*stop_vec)
+{
+	const struct xfs_scrub_vec	*v;
+	__u32				failmask;
+
+	failmask = stop_vec->sv_flags & XFS_SCRUB_FLAGS_OUT;
+
+	for (v = vectors; v < stop_vec; v++) {
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER)
+			continue;
+
+		/*
+		 * Runtime errors count as a previous failure, except the ones
+		 * used to ask userspace to retry.
+		 */
+		switch (v->sv_ret) {
+		case -EBUSY:
+		case -ENOENT:
+		case -EUSERS:
+		case 0:
+			break;
+		default:
+			return -ECANCELED;
+		}
+
+		/*
+		 * If any of the out-flags on the scrub vector match the mask
+		 * that was set on the barrier vector, that's a previous fail.
+		 */
+		if (v->sv_flags & failmask)
+			return -ECANCELED;
+	}
+
+	return 0;
+}
+
+static int
+xfrog_scrubv_fallback(
+	struct xfs_fd			*xfd,
+	struct xfrog_scrubv		*scrubv)
+{
+	struct xfs_scrub_vec		*vectors = scrubv->vectors;
+	struct xfs_scrub_vec		*v;
+	unsigned int			i;
+
+	if (scrubv->head.svh_flags & ~XFS_SCRUB_VEC_FLAGS_ALL)
+		return -EINVAL;
+
+	foreach_xfrog_scrubv_vec(scrubv, i, v) {
+		if (v->sv_reserved)
+			return -EINVAL;
+
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER &&
+		    (v->sv_flags & ~XFS_SCRUB_FLAGS_OUT))
+			return -EINVAL;
+	}
+
+	/* Run all the scrubbers. */
+	foreach_xfrog_scrubv_vec(scrubv, i, v) {
+		struct xfs_scrub_metadata	sm = {
+			.sm_type		= v->sv_type,
+			.sm_flags		= v->sv_flags,
+			.sm_ino			= scrubv->head.svh_ino,
+			.sm_gen			= scrubv->head.svh_gen,
+			.sm_agno		= scrubv->head.svh_agno,
+		};
+		struct timespec	tv;
+
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER) {
+			v->sv_ret = xfrog_scrubv_check_barrier(vectors, v);
+			if (v->sv_ret)
+				break;
+			continue;
+		}
+
+		v->sv_ret = xfrog_scrub_metadata(xfd, &sm);
+		v->sv_flags = sm.sm_flags;
+
+		if (scrubv->head.svh_rest_us) {
+			tv.tv_sec = 0;
+			tv.tv_nsec = scrubv->head.svh_rest_us * 1000;
+			nanosleep(&tv, NULL);
+		}
+	}
+
+	return 0;
+}
+
+/* Invoke the vectored scrub ioctl. */
+static int
+xfrog_scrubv_call(
+	struct xfs_fd			*xfd,
+	struct xfs_scrub_vec_head	*vhead)
+{
+	int				ret;
+
+	ret = ioctl(xfd->fd, XFS_IOC_SCRUBV_METADATA, vhead);
+	if (ret)
+		return -errno;
+
+	return 0;
+}
+
+/* Invoke the vectored scrub ioctl.  Returns zero or negative error code. */
+int
+xfrog_scrubv_metadata(
+	struct xfs_fd			*xfd,
+	struct xfrog_scrubv		*scrubv)
+{
+	int				error = 0;
+
+	if (scrubv->head.svh_nr > XFROG_SCRUBV_MAX_VECTORS)
+		return -EINVAL;
+
+	if (xfd->flags & XFROG_FLAG_SCRUB_FORCE_SINGLE)
+		goto try_single;
+
+	error = xfrog_scrubv_call(xfd, &scrubv->head);
+	if (error == 0 || (xfd->flags & XFROG_FLAG_SCRUB_FORCE_VECTOR))
+		return error;
+
+	/* If the vectored scrub ioctl wasn't found, force single mode. */
+	switch (error) {
+	case -EOPNOTSUPP:
+	case -ENOTTY:
+		xfd->flags |= XFROG_FLAG_SCRUB_FORCE_SINGLE;
+		break;
+	}
+
+try_single:
+	return xfrog_scrubv_fallback(xfd, scrubv);
+}
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 27230c62f..b564c0d7b 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -28,4 +28,39 @@ extern const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR];
 
 int xfrog_scrub_metadata(struct xfs_fd *xfd, struct xfs_scrub_metadata *meta);
 
+/*
+ * Allow enough space to call all scrub types with a barrier between each.
+ * This is overkill for every caller in xfsprogs.
+ */
+#define XFROG_SCRUBV_MAX_VECTORS	(XFS_SCRUB_TYPE_NR * 2)
+
+struct xfrog_scrubv {
+	struct xfs_scrub_vec_head	head;
+	struct xfs_scrub_vec		vectors[XFROG_SCRUBV_MAX_VECTORS];
+};
+
+/* Initialize a scrubv structure; callers must have zeroed @scrubv. */
+static inline void
+xfrog_scrubv_init(struct xfrog_scrubv *scrubv)
+{
+	scrubv->head.svh_vectors = (uintptr_t)scrubv->vectors;
+}
+
+/* Return the next free vector from the scrubv structure. */
+static inline struct xfs_scrub_vec *
+xfrog_scrubv_next_vector(struct xfrog_scrubv *scrubv)
+{
+	if (scrubv->head.svh_nr >= XFROG_SCRUBV_MAX_VECTORS)
+		return NULL;
+
+	return &scrubv->vectors[scrubv->head.svh_nr++];
+}
+
+#define foreach_xfrog_scrubv_vec(scrubv, i, vec) \
+	for ((i) = 0, (vec) = (scrubv)->vectors; \
+	     (i) < (scrubv)->head.svh_nr; \
+	     (i)++, (vec)++)
+
+int xfrog_scrubv_metadata(struct xfs_fd *xfd, struct xfrog_scrubv *scrubv);
+
 #endif	/* __LIBFROG_SCRUB_H__ */

