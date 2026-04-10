Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEA71A682B
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801609; cv=none; b=Hbo92OWjcjlI8a8oJhLcDsPz/bM2cogVAUj5qFa6whGIRTNnV2Qm72IM7i6JBp2fLtt0VOcYpIlKkKOG3D3CxICd1tytXEiIHnkOKf9/G8hxYjRTAWagE8fmo84Lb8C7n17rAmqUfPuVHUEYpHF1f35ZLkAR4FOj479VEYpxCzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801609; c=relaxed/simple;
	bh=xMdOurcpd26QkXwZwrkcxAEUNLZ2iZmdnLzBUsojLjo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+L4qOaIen4En1S5FAnvYu2TJb4+Nu8OonN+IEID5kdQBPRUBYj9w/xiGWffIlaK2lHTKEp3PP6v0sBw9quDGxXMFcnW2fIy0Wc60xOW6uo2knHJwNb4ZW3K8bbmmZBCT1cBy2GHg5W72FmHkNa7HiB761TY76zgQl/9+2pYrdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifqCkU5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifqCkU5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FBFC19421;
	Fri, 10 Apr 2026 06:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801608;
	bh=xMdOurcpd26QkXwZwrkcxAEUNLZ2iZmdnLzBUsojLjo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ifqCkU5v9fEDGmMgOD+acWTXT/WIyNc87uBlv8SI0ezGD4XUg/iCeInlNwyU8CAqM
	 QcToSNT8OQKFIx1Qh7LJMevwZcBuIGrflDEfBHs5CFXZwGxUgwDQ2LhfU76P/WLLmK
	 Aa+RteKM4nOFhNpwZVA5Yzl2G2X9cHX7ctDtClM9w8h8rM1bLdSXAFnT6F0wRbz0uw
	 GfBgGGm/ZWawU1QKS2p/l4X9sh+UmW+ff1HVhR+eaY9yG3DZ+LHqh9B6kx55i8ZLii
	 3/3ncc1YjcWXA3qMlMohF6/bNO7KM+1/V5L0h95XRLUSg7ZFDtWWw9Ong7eFJeEPGt
	 o/hDYieuG6Lcg==
Date: Thu, 09 Apr 2026 23:13:28 -0700
Subject: [PATCH 11/26] xfs_healer: enable repairing filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384434.2089237.8572753316540770142.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make it so that our health monitoring daemon can initiate repairs in
response to reports of corrupt filesystem metadata.  Repairs are
initiated from the background workers as explained in the previous
patch.

Note that just like xfs_scrub, xfs_healer's ability to repair metadata
relies heavily on back references such as reverse mappings and directory
parent pointers to add redundancy to the filesystem.  Check for these
two features and whine a bit if they are missing, just like scrub.

There's a bit of trickery with the fd that is used to initiate repairs
in the kernel.  Because an open fd will pin the filesystem in memory,
xfs_healer can only hold an open fd to the target filesystem while it's
performing repairs.  Therefore, at startup xfs_healer must sample enough
information about the target filesystem to reconnect to it later on.
Currently, the fs source (aka the data device path) and the root
directory handle are sufficient to do this.

Someday we might be able to have revocable fds, which would eliminate
the need for such efforts in userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/xfs_healer.h   |   28 ++++++
 libfrog/flagmap.h     |    3 +
 libfrog/healthevent.h |   12 ++
 healer/Makefile       |    2 
 healer/fsrepair.c     |  249 +++++++++++++++++++++++++++++++++++++++++++++++++
 healer/weakhandle.c   |  115 +++++++++++++++++++++++
 healer/xfs_healer.c   |   59 ++++++++++++
 libfrog/flagmap.c     |   17 +++
 libfrog/healthevent.c |  117 +++++++++++++++++++++++
 9 files changed, 602 insertions(+)
 create mode 100644 healer/fsrepair.c
 create mode 100644 healer/weakhandle.c


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index bcddde5db0cc47..a4de1ad32a408f 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -8,6 +8,9 @@
 
 extern char *progname;
 
+struct weakhandle;
+struct hme_prefix;
+
 /*
  * When running in environments with restrictive security policies, healer
  * might not be allowed to access the global mount tree.  However, processes
@@ -22,6 +25,7 @@ struct healer_ctx {
 	int			log;
 	int			everything;
 	int			foreground;
+	int			want_repair;
 
 	/* fd and fs geometry for mount */
 	struct xfs_fd		mnt;
@@ -32,6 +36,9 @@ struct healer_ctx {
 	/* Shared reference to the getmntent fsname for reconnecting */
 	const char		*fsname;
 
+	/* weak file handle so we can reattach to filesystem */
+	struct weakhandle	*wh;
+
 	/* file stream of monitor and buffer */
 	FILE			*mon_fp;
 	char			*mon_buf;
@@ -44,4 +51,25 @@ struct healer_ctx {
 	bool			queue_active;
 };
 
+static inline bool healer_has_rmapbt(const struct healer_ctx *ctx)
+{
+	return ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT;
+}
+
+static inline bool healer_has_parent(const struct healer_ctx *ctx)
+{
+	return ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT;
+}
+
+/* repair.c */
+int repair_metadata(struct healer_ctx *ctx, const struct hme_prefix *pfx,
+		const struct xfs_health_monitor_event *hme);
+bool healer_can_repair(struct healer_ctx *ctx);
+
+/* weakhandle.c */
+int weakhandle_alloc(int fd, const char *mountpoint, const char *fsname,
+		struct weakhandle **whp);
+int weakhandle_reopen(struct weakhandle *wh, int *fd);
+void weakhandle_free(struct weakhandle **whp);
+
 #endif /* XFS_HEALER_XFS_HEALER_H_ */
diff --git a/libfrog/flagmap.h b/libfrog/flagmap.h
index 8031d75a7c02a8..05110c3544dc97 100644
--- a/libfrog/flagmap.h
+++ b/libfrog/flagmap.h
@@ -14,6 +14,9 @@ struct flag_map {
 void mask_to_string(const struct flag_map *map, unsigned long long mask,
 		const char *delimiter, char *buf, size_t bufsize);
 
+const char *lowest_set_mask_string(const struct flag_map *map,
+		unsigned long long mask);
+
 const char *value_to_string(const struct flag_map *map,
 		unsigned long long value);
 
diff --git a/libfrog/healthevent.h b/libfrog/healthevent.h
index 6de41bc797100c..4f3c8ba639ec4c 100644
--- a/libfrog/healthevent.h
+++ b/libfrog/healthevent.h
@@ -40,4 +40,16 @@ hme_prefix_init(
 void hme_report_event(const struct hme_prefix *pfx,
 		const struct xfs_health_monitor_event *hme);
 
+enum repair_outcome {
+	REPAIR_SUCCESS,
+	REPAIR_FAILED,
+	REPAIR_PROBABLY_OK,
+	REPAIR_UNNECESSARY,
+};
+
+void report_health_repair(const struct hme_prefix *pfx,
+		const struct xfs_health_monitor_event *hme,
+		uint32_t event_mask,
+		enum repair_outcome outcome);
+
 #endif /* LIBFROG_HEALTHEVENT_H_ */
diff --git a/healer/Makefile b/healer/Makefile
index e82c820883669a..981192b81af626 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -11,6 +11,8 @@ INSTALL_HEALER = install-healer
 LTCOMMAND = xfs_healer
 
 CFILES = \
+fsrepair.c \
+weakhandle.c \
 xfs_healer.c
 
 HFILES = \
diff --git a/healer/fsrepair.c b/healer/fsrepair.c
new file mode 100644
index 00000000000000..907afca3dba8a7
--- /dev/null
+++ b/healer/fsrepair.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025-2026 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+
+#include "platform_defs.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/workqueue.h"
+#include "libfrog/healthevent.h"
+#include "xfs_healer.h"
+
+/* Translate scrub output flags to outcome. */
+static enum repair_outcome from_repair_oflags(uint32_t oflags)
+{
+	if (oflags & (XFS_SCRUB_OFLAG_CORRUPT | XFS_SCRUB_OFLAG_INCOMPLETE))
+		return REPAIR_FAILED;
+
+	if (oflags & XFS_SCRUB_OFLAG_XFAIL)
+		return REPAIR_PROBABLY_OK;
+
+	if (oflags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
+		return REPAIR_UNNECESSARY;
+
+	return REPAIR_SUCCESS;
+}
+
+struct u32_scrub {
+	uint32_t	event_mask;
+	uint32_t	scrub_type;
+};
+
+#define foreach_scrub_type(cur, mask, coll) \
+	for ((cur) = (coll); (cur)->scrub_type != 0; (cur)++) \
+		if ((mask) & (cur)->event_mask)
+
+/* Call the kernel to repair some inode metadata. */
+static inline enum repair_outcome
+xfs_repair_metadata(
+	int			fd,
+	uint32_t		scrub_type,
+	uint32_t		group,
+	uint64_t		ino,
+	uint32_t		gen)
+{
+	struct xfs_scrub_metadata sm = {
+		.sm_type = scrub_type,
+		.sm_flags = XFS_SCRUB_IFLAG_REPAIR,
+		.sm_ino = ino,
+		.sm_gen = gen,
+		.sm_agno = group,
+	};
+	int			ret;
+
+	ret = ioctl(fd, XFS_IOC_SCRUB_METADATA, &sm);
+	if (ret)
+		return REPAIR_FAILED;
+
+	return from_repair_oflags(sm.sm_flags);
+}
+
+/* React to a fs-domain corruption event by repairing it. */
+static void
+try_repair_wholefs(
+	struct healer_ctx			*ctx,
+	const struct hme_prefix			*pfx,
+	int					mnt_fd,
+	const struct xfs_health_monitor_event	*hme)
+{
+#define X(code, type) { XFS_FSOP_GEOM_SICK_ ## code, XFS_SCRUB_TYPE_ ## type }
+	static const struct u32_scrub		FS_STRUCTURES[] = {
+		X(COUNTERS,	FSCOUNTERS),
+		X(UQUOTA,	UQUOTA),
+		X(GQUOTA,	GQUOTA),
+		X(PQUOTA,	PQUOTA),
+		X(RT_BITMAP,	RTBITMAP),
+		X(RT_SUMMARY,	RTSUM),
+		X(QUOTACHECK,	QUOTACHECK),
+		X(NLINKS,	NLINKS),
+		{0,		0},
+	};
+#undef X
+	const struct u32_scrub	*f;
+
+	foreach_scrub_type(f, hme->e.fs.mask, FS_STRUCTURES) {
+		enum repair_outcome	outcome =
+			xfs_repair_metadata(mnt_fd, f->scrub_type, 0, 0, 0);
+
+		pthread_mutex_lock(&ctx->conlock);
+		report_health_repair(pfx, hme, f->event_mask, outcome);
+		pthread_mutex_unlock(&ctx->conlock);
+	}
+}
+
+/* React to an ag corruption event by repairing it. */
+static void
+try_repair_ag(
+	struct healer_ctx			*ctx,
+	const struct hme_prefix			*pfx,
+	int					mnt_fd,
+	const struct xfs_health_monitor_event	*hme)
+{
+#define X(code, type) { XFS_AG_GEOM_SICK_ ## code, XFS_SCRUB_TYPE_ ## type }
+	static const struct u32_scrub		AG_STRUCTURES[] = {
+		X(SB,		SB),
+		X(AGF,		AGF),
+		X(AGFL,		AGFL),
+		X(AGI,		AGI),
+		X(BNOBT,	BNOBT),
+		X(CNTBT,	CNTBT),
+		X(INOBT,	INOBT),
+		X(FINOBT,	FINOBT),
+		X(RMAPBT,	RMAPBT),
+		X(REFCNTBT,	REFCNTBT),
+		{0,		0},
+	};
+#undef X
+	const struct u32_scrub *f;
+
+	foreach_scrub_type(f, hme->e.group.mask, AG_STRUCTURES) {
+		enum repair_outcome	outcome =
+			xfs_repair_metadata(mnt_fd, f->scrub_type,
+					hme->e.group.gno, 0, 0);
+
+		pthread_mutex_lock(&ctx->conlock);
+		report_health_repair(pfx, hme, f->event_mask, outcome);
+		pthread_mutex_unlock(&ctx->conlock);
+	}
+}
+
+/* React to a rtgroup corruption event by repairing it. */
+static void
+try_repair_rtgroup(
+	struct healer_ctx			*ctx,
+	const struct hme_prefix			*pfx,
+	int					mnt_fd,
+	const struct xfs_health_monitor_event	*hme)
+{
+#define X(code, type) { XFS_RTGROUP_GEOM_SICK_ ## code, XFS_SCRUB_TYPE_ ## type }
+	static const struct u32_scrub		RTG_STRUCTURES[] = {
+		X(SUPER,	RGSUPER),
+		X(BITMAP,	RTBITMAP),
+		X(SUMMARY,	RTSUM),
+		X(RMAPBT,	RTRMAPBT),
+		X(REFCNTBT,	RTREFCBT),
+		{0,		0},
+	};
+#undef X
+	const struct u32_scrub *f;
+
+	foreach_scrub_type(f, hme->e.group.mask, RTG_STRUCTURES) {
+		enum repair_outcome	outcome =
+			xfs_repair_metadata(mnt_fd, f->scrub_type,
+					hme->e.group.gno, 0, 0);
+
+		pthread_mutex_lock(&ctx->conlock);
+		report_health_repair(pfx, hme, f->event_mask, outcome);
+		pthread_mutex_unlock(&ctx->conlock);
+	}
+}
+
+/* React to a inode-domain corruption event by repairing it. */
+static void
+try_repair_inode(
+	struct healer_ctx			*ctx,
+	const struct hme_prefix			*pfx,
+	int					mnt_fd,
+	const struct xfs_health_monitor_event	*hme)
+{
+#define X(code, type) { XFS_BS_SICK_ ## code, XFS_SCRUB_TYPE_ ## type }
+	static const struct u32_scrub		INODE_STRUCTURES[] = {
+		X(INODE,	INODE),
+		X(BMBTD,	BMBTD),
+		X(BMBTA,	BMBTA),
+		X(BMBTC,	BMBTC),
+		X(DIR,		DIR),
+		X(XATTR,	XATTR),
+		X(SYMLINK,	SYMLINK),
+		X(PARENT,	PARENT),
+		X(DIRTREE,	DIRTREE),
+		{0,		0},
+	};
+#undef X
+	const struct u32_scrub *f;
+
+	foreach_scrub_type(f, hme->e.inode.mask, INODE_STRUCTURES) {
+		enum repair_outcome	outcome =
+			xfs_repair_metadata(mnt_fd, f->scrub_type,
+					0, hme->e.inode.ino, hme->e.inode.gen);
+
+		pthread_mutex_lock(&ctx->conlock);
+		report_health_repair(pfx, hme, f->event_mask, outcome);
+		pthread_mutex_unlock(&ctx->conlock);
+	}
+}
+
+/* Repair a metadata corruption. */
+int
+repair_metadata(
+	struct healer_ctx			*ctx,
+	const struct hme_prefix			*pfx,
+	const struct xfs_health_monitor_event	*hme)
+{
+	int					repair_fd;
+	int					ret;
+
+	ret = weakhandle_reopen(ctx->wh, &repair_fd);
+	if (ret) {
+		fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
+				_("cannot open filesystem to repair"),
+				strerror(errno));
+		return ret;
+	}
+
+	switch (hme->domain) {
+	case XFS_HEALTH_MONITOR_DOMAIN_FS:
+		try_repair_wholefs(ctx, pfx, repair_fd, hme);
+		break;
+	case XFS_HEALTH_MONITOR_DOMAIN_AG:
+		try_repair_ag(ctx, pfx, repair_fd, hme);
+		break;
+	case XFS_HEALTH_MONITOR_DOMAIN_RTGROUP:
+		try_repair_rtgroup(ctx, pfx, repair_fd, hme);
+		break;
+	case XFS_HEALTH_MONITOR_DOMAIN_INODE:
+		try_repair_inode(ctx, pfx, repair_fd, hme);
+		break;
+	}
+
+	close(repair_fd);
+	return 0;
+}
+
+/* Ask the kernel if it supports repairs. */
+bool
+healer_can_repair(
+	struct healer_ctx	*ctx)
+{
+	struct xfs_scrub_metadata sm = {
+		.sm_type = XFS_SCRUB_TYPE_PROBE,
+		.sm_flags = XFS_SCRUB_IFLAG_REPAIR,
+	};
+	int			ret;
+
+	/* assume any errno means not supported */
+	ret = ioctl(ctx->mnt.fd, XFS_IOC_SCRUB_METADATA, &sm);
+	return ret ? false : true;
+}
diff --git a/healer/weakhandle.c b/healer/weakhandle.c
new file mode 100644
index 00000000000000..53df43b03e16cc
--- /dev/null
+++ b/healer/weakhandle.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025-2026 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include <pthread.h>
+#include <stdlib.h>
+
+#include "platform_defs.h"
+#include "handle.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/workqueue.h"
+#include "xfs_healer.h"
+
+struct weakhandle {
+	/* Shared reference to the user's mountpoint for logging */
+	const char		*mntpoint;
+
+	/* Shared reference to the getmntent fsname for reconnecting */
+	const char		*fsname;
+
+	/* handle to root dir */
+	void			*hanp;
+	size_t			hlen;
+};
+
+/* Capture a handle for a given filesystem, but don't attach to the fd. */
+int
+weakhandle_alloc(
+	int			fd,
+	const char		*mountpoint,
+	const char		*fsname,
+	struct weakhandle	**whp)
+{
+	struct weakhandle	*wh;
+	int			ret;
+
+	*whp = NULL;
+
+	if (fd < 0 || !mountpoint) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	wh = calloc(1, sizeof(struct weakhandle));
+	if (!wh)
+		return -1;
+
+	wh->mntpoint = mountpoint;
+	wh->fsname = fsname;
+
+	ret = fd_to_handle(fd, &wh->hanp, &wh->hlen);
+	if (ret)
+		goto out_wh;
+
+	*whp = wh;
+	return 0;
+
+out_wh:
+	free(wh);
+	return -1;
+}
+
+/* Reopen a file handle obtained via weak reference. */
+int
+weakhandle_reopen(
+	struct weakhandle	*wh,
+	int			*fd)
+{
+	void			*hanp;
+	size_t			hlen;
+	int			mnt_fd;
+	int			ret;
+
+	*fd = -1;
+
+	mnt_fd = open(wh->mntpoint, O_RDONLY);
+	if (mnt_fd < 0)
+		return -1;
+
+	ret = fd_to_handle(mnt_fd, &hanp, &hlen);
+	if (ret)
+		goto out_mntfd;
+
+	if (hlen != wh->hlen || memcmp(hanp, wh->hanp, hlen)) {
+		errno = ESTALE;
+		goto out_handle;
+	}
+
+	free_handle(hanp, hlen);
+	*fd = mnt_fd;
+	return 0;
+
+out_handle:
+	free_handle(hanp, hlen);
+out_mntfd:
+	close(mnt_fd);
+	return -1;
+}
+
+/* Tear down a weak handle */
+void
+weakhandle_free(
+	struct weakhandle	**whp)
+{
+	struct weakhandle	*wh = *whp;
+
+	if (wh) {
+		free_handle(wh->hanp, wh->hlen);
+		free(wh);
+	}
+
+	*whp = NULL;
+}
diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index 076d5350b0d38d..45ec4f28f180d7 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -59,6 +59,22 @@ event_loggable(
 	return ctx->log || event_not_actionable(hme);
 }
 
+/* Are we going to try a repair? */
+static inline bool
+event_repairable(
+	const struct healer_ctx			*ctx,
+	const struct xfs_health_monitor_event	*hme)
+{
+	if (event_not_actionable(hme))
+		return false;
+
+	/*
+	 * We never repair corruptions that are found by xfs_scrub because it
+	 * also knows how to initiate repairs.
+	 */
+	return ctx->want_repair && hme->type == XFS_HEALTH_MONITOR_TYPE_SICK;
+}
+
 /* Handle an event asynchronously. */
 static void
 handle_event(
@@ -70,6 +86,7 @@ handle_event(
 	struct xfs_health_monitor_event	*hme = arg;
 	struct healer_ctx		*ctx = wq->wq_ctx;
 	const bool loggable = event_loggable(ctx, hme);
+	const bool will_repair = event_repairable(ctx, hme);
 
 	hme_prefix_init(&pfx, ctx->mntpoint);
 
@@ -83,6 +100,10 @@ handle_event(
 		pthread_mutex_unlock(&ctx->conlock);
 	}
 
+	/* Initiate a repair if appropriate. */
+	if (will_repair)
+		repair_metadata(ctx, &pfx, hme);
+
 	free(hme);
 }
 
@@ -156,6 +177,40 @@ setup_monitor(
 		goto out_mnt_fd;
 	}
 
+	if (ctx->want_repair) {
+		/* Check that the kernel supports repairs at all. */
+		if (!healer_can_repair(ctx)) {
+			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+ _("XFS online repair is not supported, exiting"));
+			goto out_mnt_fd;
+		}
+
+		/* Check for backref metadata that makes repair effective. */
+		if (!healer_has_rmapbt(ctx))
+			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+ _("XFS online repair is less effective without rmap btrees."));
+
+		if (!healer_has_parent(ctx))
+			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+ _("XFS online repair is less effective without parent pointers."));
+
+	}
+
+	/*
+	 * Open weak-referenced file handle to mountpoint so that we can
+	 * reconnect to the mountpoint to start repairs.
+	 */
+	if (ctx->want_repair) {
+		ret = weakhandle_alloc(ctx->mnt.fd, ctx->mntpoint,
+				ctx->fsname, &ctx->wh);
+		if (ret) {
+			fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
+					_("creating weak fshandle"),
+					strerror(errno));
+			goto out_mnt_fd;
+		}
+	}
+
 	/*
 	 * Open the health monitor, then close the mountpoint to avoid pinning
 	 * it.  We can reconnect later if need be.
@@ -300,6 +355,7 @@ teardown_monitor(
 		ctx->mon_fp = NULL;
 	}
 	free(ctx->mon_buf);
+	weakhandle_free(&ctx->wh);
 	ctx->mon_buf = NULL;
 }
 
@@ -314,6 +370,7 @@ usage(void)
 	fprintf(stderr, _("  --everything  Capture all events.\n"));
 	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
 	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
+	fprintf(stderr, _("  --repair      Repair corrupt metadata found at runtime.\n"));
 	fprintf(stderr, _("  -V            Print version.\n"));
 
 	exit(EXIT_FAILURE);
@@ -325,6 +382,7 @@ enum long_opt_nr {
 	LOPT_FOREGROUND,
 	LOPT_HELP,
 	LOPT_QUIET,
+	LOPT_REPAIR,
 
 	LOPT_MAX,
 };
@@ -355,6 +413,7 @@ main(
 		[LOPT_FOREGROUND]  = {"foreground", no_argument, &ctx.foreground, 1 },
 		[LOPT_HELP]	   = {"help", no_argument, NULL, 0 },
 		[LOPT_QUIET]	   = {"quiet", no_argument, &ctx.log, 0 },
+		[LOPT_REPAIR]	   = {"repair", no_argument, &ctx.want_repair, 1 },
 
 		[LOPT_MAX]	   = {NULL, 0, NULL, 0 },
 	};
diff --git a/libfrog/flagmap.c b/libfrog/flagmap.c
index 1a8bdd238e960b..009ff7e61c0d1b 100644
--- a/libfrog/flagmap.c
+++ b/libfrog/flagmap.c
@@ -44,6 +44,23 @@ mask_to_string(
 		snprintf(buf, bufsize, "%s0x%llx", tag, mask & ~seen);
 }
 
+/*
+ * Given a mapping of bits to strings and a bitmask, return the string
+ * corresponding to the lowest set bit in the mask.
+ */
+const char *
+lowest_set_mask_string(
+	const struct flag_map	*map,
+	unsigned long long	mask)
+{
+	for (; map->string; map++) {
+		if (mask & map->flag)
+			return _(map->string);
+	}
+
+	return _("unknown flag");
+}
+
 /*
  * Given a mapping of values to strings and a value, return the matching string
  * or confusion.
diff --git a/libfrog/healthevent.c b/libfrog/healthevent.c
index 8520cb3218fb03..193738332dbd71 100644
--- a/libfrog/healthevent.c
+++ b/libfrog/healthevent.c
@@ -358,3 +358,120 @@ hme_report_event(
 		break;
 	}
 }
+
+static const char *
+repair_outcome_string(
+	enum repair_outcome	o)
+{
+	switch (o) {
+	case REPAIR_FAILED:
+		return _("Repair unsuccessful; offline repair required.");
+	case REPAIR_PROBABLY_OK:
+		return _("Seems correct but cross-referencing failed; offline repair recommended.");
+	case REPAIR_UNNECESSARY:
+		return _("No modification needed.");
+	case REPAIR_SUCCESS:
+		return _("Repairs successful.");
+	}
+
+	return NULL;
+}
+
+/* Report inode metadata repair */
+static void
+report_inode_repair(
+	const struct hme_prefix			*pfx,
+	const struct xfs_health_monitor_event	*hme,
+	uint32_t				domain_mask,
+	enum repair_outcome			outcome)
+{
+	if (hme_prefix_has_path(pfx))
+		printf("%s %s: %s\n",
+				pfx->path,
+				lowest_set_mask_string(inode_structs,
+						       domain_mask),
+				repair_outcome_string(outcome));
+	else
+		printf("%s %s %llu %s 0x%x %s: %s\n",
+				pfx->mountpoint,
+				_("ino"),
+				(unsigned long long)hme->e.inode.ino,
+				_("gen"),
+				hme->e.inode.gen,
+				lowest_set_mask_string(inode_structs,
+						       domain_mask),
+				repair_outcome_string(outcome));
+	fflush(stdout);
+}
+
+/* Report AG metadata repair */
+static void
+report_ag_repair(
+	const struct hme_prefix			*pfx,
+	const struct xfs_health_monitor_event	*hme,
+	uint32_t				domain_mask,
+	enum repair_outcome			outcome)
+{
+	printf("%s %s 0x%x %s: %s\n", pfx->mountpoint,
+			_("agno"),
+			hme->e.group.gno,
+			lowest_set_mask_string(ag_structs, domain_mask),
+			repair_outcome_string(outcome));
+	fflush(stdout);
+}
+
+/* Report rtgroup metadata repair */
+static void
+report_rtgroup_repair(
+	const struct hme_prefix			*pfx,
+	const struct xfs_health_monitor_event	*hme,
+	uint32_t				domain_mask,
+	enum repair_outcome			outcome)
+{
+	printf("%s %s 0x%x %s: %s\n", pfx->mountpoint,
+			_("rgno"),
+			hme->e.group.gno,
+			lowest_set_mask_string(rtgroup_structs, domain_mask),
+			repair_outcome_string(outcome));
+	fflush(stdout);
+}
+
+/* Report fs-wide metadata repair */
+static void
+report_fs_repair(
+	const struct hme_prefix			*pfx,
+	const struct xfs_health_monitor_event	*hme,
+	uint32_t				domain_mask,
+	enum repair_outcome			outcome)
+{
+	printf("%s %s: %s\n", pfx->mountpoint,
+			lowest_set_mask_string(fs_structs, domain_mask),
+			repair_outcome_string(outcome));
+	fflush(stdout);
+}
+
+/* Log a repair event to stdout. */
+void
+report_health_repair(
+	const struct hme_prefix			*pfx,
+	const struct xfs_health_monitor_event	*hme,
+	uint32_t				domain_mask,
+	enum repair_outcome			outcome)
+{
+	switch (hme->domain) {
+	case XFS_HEALTH_MONITOR_DOMAIN_INODE:
+		report_inode_repair(pfx, hme, domain_mask, outcome);
+		break;
+	case XFS_HEALTH_MONITOR_DOMAIN_AG:
+		report_ag_repair(pfx, hme, domain_mask, outcome);
+		break;
+	case XFS_HEALTH_MONITOR_DOMAIN_RTGROUP:
+		report_rtgroup_repair(pfx, hme, domain_mask, outcome);
+		break;
+	case XFS_HEALTH_MONITOR_DOMAIN_FS:
+		report_fs_repair(pfx, hme, domain_mask, outcome);
+		break;
+	default:
+		break;
+	}
+}

