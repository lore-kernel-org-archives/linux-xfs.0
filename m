Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A006FC3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883346; cv=none; b=A2XITWwfkuWisz9YjElulycvo0sk5lE64KwVw9PEbGAvnYwgE1Lfq1fyh78SXDr3PJK0u/Zrul7W07dYK0U7HYLGLbphsv5l0aMXCMY9AUcQH+eLrP4Z5hbFpxB9/PZMa2KE/rBrKmDnhwcSYrCU0J0ROm/mbZzhS6Omv9yhhMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883346; c=relaxed/simple;
	bh=JqhNY5zCz1lt4bDuwrcKw9CJ3OZjA67qjCRBgnqC4VY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4X2e5JWoaOl2enlDoEuCxUHJz0TmPAL8sKa/FHqPC/TzKQRKmeq59O5CtrOtl4Vv/zPu8OEvJ/mF6d65BFuxRjp92XuUQINhPndN3IAj0Bjmm0H1URq25QLPPNYEWYQTj74Wb4EaEJMwRQZGeovNrJePcuTW7dulUempQiuPiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4jdeRBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4jdeRBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D246CC116B1;
	Tue,  2 Jul 2024 01:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883345;
	bh=JqhNY5zCz1lt4bDuwrcKw9CJ3OZjA67qjCRBgnqC4VY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K4jdeRBdPfORHoIJNWWfapD0mQIImDQLgMwAYg0L/gIXaBxrm6mn52O+98hxZw0M+
	 P5HAj5LHcIGy7QMxoWZ9E6KPStdjTU5VyrHuOmZAKk0ysZSUUWVtERq2wD4c/auxbh
	 oFYj0XOGvbIrJ805HpHdf7ZWgLgtNztaR0Ge+rTLFmgKbbVgFt/jsjyAZD5QsAelJY
	 VqCTPLlMW1NXUrelRTy+IMCg7k7PCYf/QZCRW/KOYquGXmd/Xi7zWT0VnaKwxRMH6P
	 9SZ7/ileD0IVE1aIhjMD9DCZ9+QlY5OXqIYokylSfKGNBW9qg1rYqygokrkfq79wgp
	 wsUTs8zRRv4mw==
Date: Mon, 01 Jul 2024 18:22:25 -0700
Subject: [PATCH 02/10] libfrog: support vectored scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988123165.2012546.18193316836899391961.stgit@frogsfrogsfrogs>
In-Reply-To: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
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
---
 libfrog/fsgeom.h |    6 ++
 libfrog/scrub.c  |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/scrub.h  |   35 ++++++++++++++
 3 files changed, 178 insertions(+)


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index f327dc7d70d0..df2ca2a408e7 100644
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
index a2146e228f5b..e233c0f9c8e1 100644
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
index 27230c62f71a..b564c0d7bd0f 100644
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

