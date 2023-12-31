Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC45C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/0gXBN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986DBC433C8;
	Sun, 31 Dec 2023 23:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064813;
	bh=rLEWCoTbexiKW/OGN75uYpHafbeupx1GvUJVdpvp63o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f/0gXBN3gv2ppz0AsOsiyaLSwvi8IQbLzhnoY6aBS/Xa+l7HHge0jvONdFkKP5yth
	 9dGAJvdzeFiKImmYcl90QmdcP+qgpncXSLxUVTC45nGyZ05p7YGkksvJ+b0V1tNksJ
	 130gtSMC6IeF/+cH/ctmUBA8hH4m/lsNW9Jh3dM4jI3+npxGF8zwa4TAbjiP36MV95
	 K+1rNbV+34BB1evRgCOp3GFOzG82BoE5oi7vk78O9FdDR/azYjAsNYAgJG3YJ5N2+P
	 0CovVXjiT3YKgCeT9v+BhBMUBX6keiOkNSmxNy+CsC3llcOa64S6Y7TLFvxSoD1s6o
	 F0XQ06YoPUQAA==
Date: Sun, 31 Dec 2023 15:20:13 -0800
Subject: [PATCH 02/10] libfrog: support vectored scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007870.1806194.6377941671214699137.stgit@frogsfrogsfrogs>
In-Reply-To: <170405007836.1806194.11810681886556560484.stgit@frogsfrogsfrogs>
References: <170405007836.1806194.11810681886556560484.stgit@frogsfrogsfrogs>
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
 libfrog/fsgeom.h |    6 +++
 libfrog/scrub.c  |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/scrub.h  |    4 ++
 3 files changed, 134 insertions(+)


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 7e002c5137a..4f3542eafec 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -56,6 +56,12 @@ struct xfs_fd {
 /* Only use XFS_IOC_EXCHANGE_RANGE for file data exchanges. */
 #define XFROG_FLAG_FORCE_EXCH_RANGE	(1 << 3)
 
+/* Only use the older one-at-a-time scrub ioctl. */
+#define XFROG_FLAG_SCRUB_FORCE_SINGLE	(1 << 4)
+
+/* Only use the vectored scrub ioctl. */
+#define XFROG_FLAG_SCRUB_FORCE_VECTOR	(1 << 5)
+
 /* Static initializers */
 #define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
 #define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index a2146e228f5..8264aab00ef 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -171,3 +171,127 @@ xfrog_scrub_metadata(
 
 	return 0;
 }
+
+/* Decide if there have been any scrub failures up to this point. */
+static inline int
+xfrog_scrubv_previous_failures(
+	struct xfs_scrub_vec_head	*vhead,
+	struct xfs_scrub_vec		*barrier_vec)
+{
+	struct xfs_scrub_vec		*v;
+	__u32				failmask;
+
+	failmask = barrier_vec->sv_flags & XFS_SCRUB_FLAGS_OUT;
+	for (v = vhead->svh_vecs; v < barrier_vec; v++) {
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER)
+			continue;
+
+		/*
+		 * Runtime errors count as a previous failure, except the ones
+		 * used to ask userspace to retry.
+		 */
+		if (v->sv_ret && v->sv_ret != -EBUSY && v->sv_ret != -ENOENT &&
+		    v->sv_ret != -EUSERS)
+			return -ECANCELED;
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
+	struct xfs_scrub_vec_head	*vhead)
+{
+	struct xfs_scrub_vec		*v;
+	unsigned int			i;
+
+	if (vhead->svh_flags & ~XFS_SCRUB_VEC_FLAGS_ALL)
+		return -EINVAL;
+	for (i = 0, v = vhead->svh_vecs; i < vhead->svh_nr; i++, v++) {
+		if (v->sv_reserved)
+			return -EINVAL;
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER &&
+		    (v->sv_flags & ~XFS_SCRUB_FLAGS_OUT))
+			return -EINVAL;
+	}
+
+	/* Run all the scrubbers. */
+	for (i = 0, v = vhead->svh_vecs; i < vhead->svh_nr; i++, v++) {
+		struct xfs_scrub_metadata	sm = {
+			.sm_type	= v->sv_type,
+			.sm_flags	= v->sv_flags,
+			.sm_ino		= vhead->svh_ino,
+			.sm_gen		= vhead->svh_gen,
+			.sm_agno	= vhead->svh_agno,
+		};
+		struct timespec	tv;
+
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER) {
+			v->sv_ret = xfrog_scrubv_previous_failures(vhead, v);
+			if (v->sv_ret)
+				break;
+			continue;
+		}
+
+		v->sv_ret = xfrog_scrub_metadata(xfd, &sm);
+		v->sv_flags = sm.sm_flags;
+
+		if (vhead->svh_rest_us) {
+			tv.tv_sec = 0;
+			tv.tv_nsec = vhead->svh_rest_us * 1000;
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
+	struct xfs_scrub_vec_head	*vhead)
+{
+	int				error = 0;
+
+	if (xfd->flags & XFROG_FLAG_SCRUB_FORCE_SINGLE)
+		goto try_single;
+
+	error = xfrog_scrubv_call(xfd, vhead);
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
+	return xfrog_scrubv_fallback(xfd, vhead);
+}
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 27230c62f71..43456230479 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -28,4 +28,8 @@ extern const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR];
 
 int xfrog_scrub_metadata(struct xfs_fd *xfd, struct xfs_scrub_metadata *meta);
 
+struct xfs_scrub_vec_head;
+
+int xfrog_scrubv_metadata(struct xfs_fd *xfd, struct xfs_scrub_vec_head *vhead);
+
 #endif	/* __LIBFROG_SCRUB_H__ */

