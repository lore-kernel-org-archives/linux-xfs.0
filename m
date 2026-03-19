Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953A43126B9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895391; cv=none; b=FN/M79k3eCU9+UvTS3LBqCT4yeNMtFcU+Ulb4i9TPiEimws9hvVAPczB4ENUu1z53hd43zsik+ysa6PNGbkDJHeEV+ccSx4f5wWeTBBFLohGRwcwmIRRD6KLv5jxIW01RBsYwECTGPKbDxjFZ4vvHL9J8iE8S2dlxxMLOJf6cjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895391; c=relaxed/simple;
	bh=eWsHYVd+zIT6RhvxMTOU2w0wGZ8i1uYZQJ6MgL2ie6I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mUrawEsOSulrfiw0ajUtBYd0TEHupKApNR1Ah615vYjqGYX3vTPmQV4XsXG09+tVxdmsKsvyNTqRpHXOTr2qZ2KcZJHJH6b/xI5RXWlwmwu1vzYdi/WQfTvWF6OpEegqgTpV303Yvopm7dlMrpZIz8nyoH2FGuNwjZ0edlARdE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWHIBzhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWHIBzhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F15FC19425;
	Thu, 19 Mar 2026 04:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895391;
	bh=eWsHYVd+zIT6RhvxMTOU2w0wGZ8i1uYZQJ6MgL2ie6I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gWHIBzhmgtzzV6orUYsCbJg2vJkzv68fizks7BsOOLqpB8GaNoHSw+wu7xs8j0zfY
	 sVqMXzqV2UXOB9IgJJ9kFaz6j+jLAB44vcJ/WXM227Yxao28DXdw6gy6bVn8iyBaU4
	 t1S3DtJLCSMPuJ6XbNDj1kbErViRW292JdUeoY3qBs/VPKWOGF9Nmij6jjzvBJ5Rtf
	 OJ/qr52j+IMtJUtvD2J49vYoOrVJNTmoIuF9QMonLjkRZKtxYvvxQKSKTN5nW1lZss
	 591f+GwujTBsZ+iZy6NULsZPqcXDI2XeoQChasqf2qf0i3HF9/fSYJBldJ8AAaHEva
	 aSeh25tn6meWg==
Date: Wed, 18 Mar 2026 21:43:11 -0700
Subject: [PATCH 17/26] xfs_healer: run full scrub after lost corruption events
 or targeted repair failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506458.3680139.3955360030781384396.stgit@frogsfrogsfrogs>
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

If we fail to perform a spot repair of metadata or the kernel tells us
that it lost corruption events due to queue limits, initiate a full run
of the online fsck service to try to fix the error.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/xfs_healer.h  |    3 ++
 healer/Makefile      |    2 +
 healer/fsrepair.c    |   81 +++++++++++++++++++++++++++++++++++++++++++++-----
 healer/weakhandle.c  |   13 ++++++++
 healer/xfs_healer.c  |    7 ++++
 include/builddefs.in |    1 +
 scrub/Makefile       |    7 ++--
 7 files changed, 102 insertions(+), 12 deletions(-)


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index a2a46053928e33..e1370323bbd66a 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -72,6 +72,7 @@ void lookup_path(struct healer_ctx *ctx,
 int repair_metadata(struct healer_ctx *ctx, const struct hme_prefix *pfx,
 		const struct xfs_health_monitor_event *hme);
 bool healer_can_repair(struct healer_ctx *ctx);
+void run_full_repair(struct healer_ctx *ctx);
 
 /* weakhandle.c */
 int weakhandle_alloc(int fd, const char *mountpoint, const char *fsname,
@@ -80,5 +81,7 @@ int weakhandle_reopen(struct weakhandle *wh, int *fd);
 void weakhandle_free(struct weakhandle **whp);
 int weakhandle_getpath_for(struct weakhandle *wh, uint64_t ino, uint32_t gen,
 		char *path, size_t pathlen);
+int weakhandle_instance_unit_name(struct weakhandle *wh, const char *template,
+		char *unitname, size_t unitnamelen);
 
 #endif /* XFS_HEALER_XFS_HEALER_H_ */
diff --git a/healer/Makefile b/healer/Makefile
index 1eeb727682008b..b8ffce33e90d18 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -19,6 +19,8 @@ xfs_healer.c
 HFILES = \
 xfs_healer.h
 
+CFLAGS+=-DXFS_SCRUB_SVCNAME=\"$(XFS_SCRUB_SVCNAME)\"
+
 LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
diff --git a/healer/fsrepair.c b/healer/fsrepair.c
index 4534104f8a6ac1..9f8c128e395ebc 100644
--- a/healer/fsrepair.c
+++ b/healer/fsrepair.c
@@ -9,8 +9,14 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/workqueue.h"
 #include "libfrog/healthevent.h"
+#include "libfrog/systemd.h"
 #include "xfs_healer.h"
 
+enum what_next {
+	NEED_FULL_REPAIR,
+	REPAIR_DONE,
+};
+
 /* Translate scrub output flags to outcome. */
 static enum repair_outcome from_repair_oflags(uint32_t oflags)
 {
@@ -61,7 +67,7 @@ xfs_repair_metadata(
 }
 
 /* React to a fs-domain corruption event by repairing it. */
-static void
+static enum what_next
 try_repair_wholefs(
 	struct healer_ctx			*ctx,
 	const struct hme_prefix			*pfx,
@@ -90,11 +96,16 @@ try_repair_wholefs(
 		pthread_mutex_lock(&ctx->conlock);
 		report_health_repair(pfx, hme, f->event_mask, outcome);
 		pthread_mutex_unlock(&ctx->conlock);
+
+		if (outcome == REPAIR_FAILED)
+			return NEED_FULL_REPAIR;
 	}
+
+	return REPAIR_DONE;
 }
 
 /* React to an ag corruption event by repairing it. */
-static void
+static enum what_next
 try_repair_ag(
 	struct healer_ctx			*ctx,
 	const struct hme_prefix			*pfx,
@@ -126,11 +137,16 @@ try_repair_ag(
 		pthread_mutex_lock(&ctx->conlock);
 		report_health_repair(pfx, hme, f->event_mask, outcome);
 		pthread_mutex_unlock(&ctx->conlock);
+
+		if (outcome == REPAIR_FAILED)
+			return NEED_FULL_REPAIR;
 	}
+
+	return REPAIR_DONE;
 }
 
 /* React to a rtgroup corruption event by repairing it. */
-static void
+static enum what_next
 try_repair_rtgroup(
 	struct healer_ctx			*ctx,
 	const struct hme_prefix			*pfx,
@@ -157,11 +173,16 @@ try_repair_rtgroup(
 		pthread_mutex_lock(&ctx->conlock);
 		report_health_repair(pfx, hme, f->event_mask, outcome);
 		pthread_mutex_unlock(&ctx->conlock);
+
+		if (outcome == REPAIR_FAILED)
+			return NEED_FULL_REPAIR;
 	}
+
+	return REPAIR_DONE;
 }
 
 /* React to a inode-domain corruption event by repairing it. */
-static void
+static enum what_next
 try_repair_inode(
 	struct healer_ctx			*ctx,
 	const struct hme_prefix			*orig_pfx,
@@ -204,7 +225,12 @@ try_repair_inode(
 		pthread_mutex_lock(&ctx->conlock);
 		report_health_repair(pfx, hme, f->event_mask, outcome);
 		pthread_mutex_unlock(&ctx->conlock);
+
+		if (outcome == REPAIR_FAILED)
+			return NEED_FULL_REPAIR;
 	}
+
+	return REPAIR_DONE;
 }
 
 /* Repair a metadata corruption. */
@@ -214,6 +240,7 @@ repair_metadata(
 	const struct hme_prefix			*pfx,
 	const struct xfs_health_monitor_event	*hme)
 {
+	enum what_next				what_next;
 	int					repair_fd;
 	int					ret;
 
@@ -227,19 +254,25 @@ repair_metadata(
 
 	switch (hme->domain) {
 	case XFS_HEALTH_MONITOR_DOMAIN_FS:
-		try_repair_wholefs(ctx, pfx, repair_fd, hme);
+		what_next = try_repair_wholefs(ctx, pfx, repair_fd, hme);
 		break;
 	case XFS_HEALTH_MONITOR_DOMAIN_AG:
-		try_repair_ag(ctx, pfx, repair_fd, hme);
+		what_next = try_repair_ag(ctx, pfx, repair_fd, hme);
 		break;
 	case XFS_HEALTH_MONITOR_DOMAIN_RTGROUP:
-		try_repair_rtgroup(ctx, pfx, repair_fd, hme);
+		what_next = try_repair_rtgroup(ctx, pfx, repair_fd, hme);
 		break;
 	case XFS_HEALTH_MONITOR_DOMAIN_INODE:
-		try_repair_inode(ctx, pfx, repair_fd, hme);
+		what_next = try_repair_inode(ctx, pfx, repair_fd, hme);
 		break;
+	default:
+		what_next = REPAIR_DONE;
 	}
 
+	/* Transform into a full repair if we failed to fix this item. */
+	if (what_next == NEED_FULL_REPAIR)
+		run_full_repair(ctx);
+
 	close(repair_fd);
 	return 0;
 }
@@ -259,3 +292,35 @@ healer_can_repair(
 	ret = ioctl(ctx->mnt.fd, XFS_IOC_SCRUB_METADATA, &sm);
 	return ret ? false : true;
 }
+
+/* Run a full repair of the filesystem using the background fsck service. */
+void
+run_full_repair(
+	struct healer_ctx	*ctx)
+{
+	char			unitname[PATH_MAX];
+	int			ret;
+
+	ret = weakhandle_instance_unit_name(ctx->wh, XFS_SCRUB_SVCNAME,
+			unitname, PATH_MAX);
+	if (ret) {
+		fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+				_("Could not determine xfs_scrub unit name."));
+		return;
+	}
+
+	/*
+	 * Scrub could already be repairing something, so try to start the unit
+	 * and be content if it's already running.
+	 */
+	ret = systemd_manage_unit(UM_START, unitname);
+	if (ret) {
+		fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
+				_("Could not start xfs_scrub service unit"),
+				unitname);
+		return;
+	}
+
+	printf("%s: %s\n", ctx->mntpoint, _("Full repairs in progress."));
+	fflush(stdout);
+}
diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 8950e0eb1e5a43..849aa2882700d4 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -13,6 +13,7 @@
 #include "libfrog/workqueue.h"
 #include "libfrog/getparents.h"
 #include "libfrog/paths.h"
+#include "libfrog/systemd.h"
 #include "xfs_healer.h"
 
 struct weakhandle {
@@ -199,3 +200,15 @@ weakhandle_getpath_for(
 	close(mnt_fd);
 	return ret;
 }
+
+/* Compute the systemd instance unit name for this mountpoint. */
+int
+weakhandle_instance_unit_name(
+	struct weakhandle	*wh,
+	const char		*template,
+	char			*unitname,
+	size_t			unitnamelen)
+{
+	return systemd_path_instance_unit_name(template, wh->mntpoint,
+			unitname, unitnamelen);
+}
diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index f4bee495979324..09b88c754a550c 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -138,6 +138,13 @@ handle_event(
 		pthread_mutex_unlock(&ctx->conlock);
 	}
 
+	/*
+	 * If we didn't ask for all the metadata reports (including the healthy
+	 * ones) and the kernel tells us it lost something, run the full scan.
+	 */
+	if (hme->type == XFS_HEALTH_MONITOR_TYPE_LOST && !ctx->everything)
+		run_full_repair(ctx);
+
 	/* Initiate a repair if appropriate. */
 	if (will_repair)
 		repair_metadata(ctx, &pfx, hme);
diff --git a/include/builddefs.in b/include/builddefs.in
index bdba9cd9037900..3b52d1afd7031c 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -62,6 +62,7 @@ MKFS_CFG_DIR	= @datadir@/@pkg_name@/mkfs
 PKG_STATE_DIR	= @localstatedir@/lib/@pkg_name@
 
 XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP=$(PKG_STATE_DIR)/xfs_scrub_all_media.stamp
+XFS_SCRUB_SVCNAME=xfs_scrub@.service
 
 CC		= @cc@
 BUILD_CC	= @BUILD_CC@
diff --git a/scrub/Makefile b/scrub/Makefile
index ff79a265762332..aee49bfce100e2 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -8,7 +8,6 @@ include $(builddefs)
 
 SCRUB_PREREQS=$(HAVE_GETFSMAP)
 
-scrub_svcname=xfs_scrub@.service
 scrub_media_svcname=xfs_scrub_media@.service
 
 ifeq ($(SCRUB_PREREQS),yes)
@@ -21,7 +20,7 @@ XFS_SCRUB_SERVICE_ARGS = -b -o autofsck
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
-	$(scrub_svcname) \
+	$(XFS_SCRUB_SVCNAME) \
 	xfs_scrub_fail@.service \
 	$(scrub_media_svcname) \
 	xfs_scrub_media_fail@.service \
@@ -123,7 +122,7 @@ xfs_scrub_all.timer: xfs_scrub_all.timer.in $(builddefs)
 $(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext.py
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
-		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
+		   -e "s|@scrub_svcname@|$(XFS_SCRUB_SVCNAME)|g" \
 		   -e "s|@scrub_media_svcname@|$(scrub_media_svcname)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@stampfile@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP)|g" \
@@ -137,7 +136,7 @@ $(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs) $(TOPDIR)/libfrog/g
 xfs_scrub_fail: xfs_scrub_fail.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
-		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
+		   -e "s|@scrub_svcname@|$(XFS_SCRUB_SVCNAME)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g"  < $< > $@
 	$(Q)chmod a+x $@
 

