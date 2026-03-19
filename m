Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926F13126B9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895313; cv=none; b=l7PjAUada2myKOgH4l02qED5bSc/ar/x2kIA0gjraU3iqcfgOtNceY2n8oj4HikfE/zrPA4iZTQngZHi1lmd5/YPZT8YCMUQigkEzI3c3I8ucl5YIhW1wDTkL9CY+TnIpwb+yUE/2Uot52breIpDeH6nW9D6UO3HueJUEEkgGNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895313; c=relaxed/simple;
	bh=7yBTg9OKYjqkAl/4cmZDlhZ1cxWSZz73Kzn4JKzZM7g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PaE05dSfzLxk0NznGE0ICWGrl/MnvtB66q3brRzqoq+x5JC17+7SyffZ1R3WmxY4Iu2+0llPy0qI0vIktMIHKV7qiVvFlkKq5t9hPwt2xNyaTowXCGbwIUPB9UkVhiiDa3ERRRNUVAzZe/LDC7JHsVEJz07xybdlYyRM4LWI82A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t/f0KZEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/f0KZEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B45C19425;
	Thu, 19 Mar 2026 04:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895313;
	bh=7yBTg9OKYjqkAl/4cmZDlhZ1cxWSZz73Kzn4JKzZM7g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t/f0KZEOcmLJ8C4uKvO/hjxr1xA7qL041bgqwxkAvzOwYQaEQ014tV4W+Pg04YlJC
	 7AuX7QMElmfsUKksHXnjGnLxKA5IE5KGfr7TMxj+IXeEtd4VDMT0v7cEnnXWih/eEP
	 cVYa0OmvEeIJMVBrg3e/fkJNSrdXmQNh7Aukm3Yx9Gv/Hl/OqFR5QyV3xY3rZ0l9mR
	 frhO+QMwHBhW/HOH1pgwitzdQKFlfWAlkVDI5nt9FeMYHH8pfrRZhHZwZZo1GqtZFS
	 YTEXnAhBcR3Zthqe/uDG8TcC2Y6qNvXeJgTosJ1K7b9HuAhGlKEEnxFhOCSDMeXMfL
	 OhifDj8RWZQ7Q==
Date: Wed, 18 Mar 2026 21:41:52 -0700
Subject: [PATCH 12/26] xfs_healer: use getparents to look up file names
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506366.3680139.13359556524460094413.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
References: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the kernel tells about something that happened to a file, use the
GETPARENTS ioctl to try to look up the path to that file for more
ergonomic reporting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/xfs_healer.h |    6 ++++
 healer/fsrepair.c   |   16 ++++++++-
 healer/weakhandle.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++
 healer/xfs_healer.c |   45 ++++++++++++++++++++++++++-
 4 files changed, 149 insertions(+), 4 deletions(-)


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index a4de1ad32a408f..6d12921245934c 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -61,6 +61,10 @@ static inline bool healer_has_parent(const struct healer_ctx *ctx)
 	return ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT;
 }
 
+void lookup_path(struct healer_ctx *ctx,
+		const struct xfs_health_monitor_event *hme,
+		struct hme_prefix *pfx);
+
 /* repair.c */
 int repair_metadata(struct healer_ctx *ctx, const struct hme_prefix *pfx,
 		const struct xfs_health_monitor_event *hme);
@@ -71,5 +75,7 @@ int weakhandle_alloc(int fd, const char *mountpoint, const char *fsname,
 		struct weakhandle **whp);
 int weakhandle_reopen(struct weakhandle *wh, int *fd);
 void weakhandle_free(struct weakhandle **whp);
+int weakhandle_getpath_for(struct weakhandle *wh, uint64_t ino, uint32_t gen,
+		char *path, size_t pathlen);
 
 #endif /* XFS_HEALER_XFS_HEALER_H_ */
diff --git a/healer/fsrepair.c b/healer/fsrepair.c
index 907afca3dba8a7..4534104f8a6ac1 100644
--- a/healer/fsrepair.c
+++ b/healer/fsrepair.c
@@ -164,7 +164,7 @@ try_repair_rtgroup(
 static void
 try_repair_inode(
 	struct healer_ctx			*ctx,
-	const struct hme_prefix			*pfx,
+	const struct hme_prefix			*orig_pfx,
 	int					mnt_fd,
 	const struct xfs_health_monitor_event	*hme)
 {
@@ -182,13 +182,25 @@ try_repair_inode(
 		{0,		0},
 	};
 #undef X
-	const struct u32_scrub *f;
+	struct hme_prefix	new_pfx;
+	const struct hme_prefix	*pfx = orig_pfx;
+	const struct u32_scrub	*f;
 
 	foreach_scrub_type(f, hme->e.inode.mask, INODE_STRUCTURES) {
 		enum repair_outcome	outcome =
 			xfs_repair_metadata(mnt_fd, f->scrub_type,
 					0, hme->e.inode.ino, hme->e.inode.gen);
 
+		/*
+		 * Try again to find the file path, maybe we fixed the dir
+		 * tree.
+		 */
+		if (!hme_prefix_has_path(pfx)) {
+			lookup_path(ctx, hme, &new_pfx);
+			if (hme_prefix_has_path(&new_pfx))
+				pfx = &new_pfx;
+		}
+
 		pthread_mutex_lock(&ctx->conlock);
 		report_health_repair(pfx, hme, f->event_mask, outcome);
 		pthread_mutex_unlock(&ctx->conlock);
diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 53df43b03e16cc..8950e0eb1e5a43 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -11,6 +11,8 @@
 #include "handle.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/getparents.h"
+#include "libfrog/paths.h"
 #include "xfs_healer.h"
 
 struct weakhandle {
@@ -113,3 +115,87 @@ weakhandle_free(
 
 	*whp = NULL;
 }
+
+struct bufvec {
+	char	*buf;
+	size_t	len;
+};
+
+static int
+render_path(
+	const char		*mntpt,
+	const struct path_list	*path,
+	void			*arg)
+{
+	struct bufvec		*args = arg;
+	int			mntpt_len = strlen(mntpt);
+	ssize_t			ret;
+
+	/* Trim trailing slashes from the mountpoint */
+	while (mntpt_len > 0 && mntpt[mntpt_len - 1] == '/')
+		mntpt_len--;
+
+	ret = snprintf(args->buf, args->len, "%.*s", mntpt_len, mntpt);
+	if (ret < 0 || ret >= args->len)
+		return 0;
+
+	ret = path_list_to_string(path, args->buf + ret, args->len - ret);
+	if (ret < 0)
+		return 0;
+
+	/* magic code that means we found one */
+	return ECANCELED;
+}
+
+/* Render any path to this weakhandle into the specified buffer. */
+int
+weakhandle_getpath_for(
+	struct weakhandle	*wh,
+	uint64_t		ino,
+	uint32_t		gen,
+	char			*path,
+	size_t			pathlen)
+{
+	struct xfs_handle	fakehandle;
+	struct bufvec		bv = {
+		.buf		= path,
+		.len		= pathlen,
+	};
+	int			mnt_fd;
+	int			ret;
+
+	if (wh->hlen != sizeof(fakehandle)) {
+		errno = EINVAL;
+		return -1;
+	}
+	memcpy(&fakehandle, wh->hanp, sizeof(fakehandle));
+	fakehandle.ha_fid.fid_ino = ino;
+	fakehandle.ha_fid.fid_gen = gen;
+
+	ret = weakhandle_reopen(wh, &mnt_fd);
+	if (ret)
+		return ret;
+
+	/*
+	 * In the common case, files only have one parent; and what's the
+	 * chance that we'll need to walk past the second parent to find *one*
+	 * path that goes to the rootdir?  With a max filename length of 255
+	 * bytes, we pick 600 for the buffer size.
+	 */
+	ret = handle_walk_paths_fd(wh->mntpoint, mnt_fd, &fakehandle,
+			sizeof(fakehandle), 600, render_path, &bv);
+	switch (ret) {
+	case ECANCELED:
+		/* found a path */
+		ret = 0;
+		break;
+	default:
+		/* didn't find one */
+		errno = ENOENT;
+		ret = -1;
+		break;
+	}
+
+	close(mnt_fd);
+	return ret;
+}
diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index 488f2a5310d0fd..63baf641cb6ec6 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -34,6 +34,39 @@ open_health_monitor(
 	return ioctl(mnt_fd, XFS_IOC_HEALTH_MONITOR, &hmo);
 }
 
+/* Report either the file handle or its path, if we can. */
+void
+lookup_path(
+	struct healer_ctx			*ctx,
+	const struct xfs_health_monitor_event	*hme,
+	struct hme_prefix			*pfx)
+{
+	uint64_t				ino = 0;
+	uint32_t				gen = 0;
+	int					ret;
+
+	if (!healer_has_parent(ctx))
+		return;
+
+	switch (hme->domain) {
+	case XFS_HEALTH_MONITOR_DOMAIN_INODE:
+		ino = hme->e.inode.ino;
+		gen = hme->e.inode.gen;
+		break;
+	case XFS_HEALTH_MONITOR_DOMAIN_FILERANGE:
+		ino = hme->e.filerange.ino;
+		gen = hme->e.filerange.gen;
+		break;
+	default:
+		return;
+	}
+
+	ret = weakhandle_getpath_for(ctx->wh, ino, gen, pfx->path,
+			sizeof(pfx->path));
+	if (ret)
+		hme_prefix_clear_path(pfx);
+}
+
 /* Decide if this event can only be reported upon, and not acted upon. */
 static bool
 event_not_actionable(
@@ -86,6 +119,13 @@ handle_event(
 
 	hme_prefix_init(&pfx, ctx->mntpoint);
 
+	/*
+	 * Try to look up the file name for the file we're about to log or
+	 * about to repair (which always logs).
+	 */
+	if (loggable || will_repair)
+		lookup_path(ctx, hme, &pfx);
+
 	/*
 	 * Non-actionable events should always be logged, because they are 100%
 	 * informational.
@@ -194,9 +234,10 @@ setup_monitor(
 
 	/*
 	 * Open weak-referenced file handle to mountpoint so that we can
-	 * reconnect to the mountpoint to start repairs.
+	 * reconnect to the mountpoint to start repairs or to look up file
+	 * paths for logging.
 	 */
-	if (ctx->want_repair) {
+	if (ctx->want_repair || healer_has_parent(ctx)) {
 		ret = weakhandle_alloc(ctx->mnt.fd, ctx->mntpoint,
 				ctx->fsname, &ctx->wh);
 		if (ret) {

