Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371FB3BD64B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114309; cv=none; b=fvRdwwyJO10JT8wAO0dqV9vwRocfphOomMFPrn8UiV+GQYOweIyTB4ljws0FAJLrrUpg6J14D4E8XgnI0rkKCRMp5HDeN7wmin15YI73U60bDNuvVDpBqHbWkw+jxZXrjigv+QUtaiZoB6M9G8TIfgnVZU4tOGrdXzdBnAFSKdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114309; c=relaxed/simple;
	bh=2GWJHsyiU9wcXuIVrEz2XUm4Qk+/j/45PHJMZM7uW5c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9pi56mgBgL/0vonyUvr9ITx9Ly2Vi90SihfS9aiTvGDxyLrUiVxoKBN0DKdFnU4VuWgUQqfBJZLr5JL5lnZRLhZS+pSHCxXNnh9L6fwpZ4vHaNa7YskCQYcaWkiY16JTz36FMj7zcTmQPgjAg8VDHtLmDzwJHwZiKdqFWh7v68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+gcj5zL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+gcj5zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73D8C2BC9E;
	Tue, 10 Mar 2026 03:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114308;
	bh=2GWJHsyiU9wcXuIVrEz2XUm4Qk+/j/45PHJMZM7uW5c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S+gcj5zLFWsslJeDNq6990qZ5HiWaWXhrPQZ37g7XHG587fUL0d/4gTXuwWBEe54/
	 LrOvYysJMlfjOTHQGZCD9tv6DUgH1rygEK35gGwGG2tEh91X9wEYdOVQPolWe1to/i
	 V9KbBc50RkMKoLq34RaCrMiG0KbYklBZbLTcottR0sm8jzPuvOOKvJ9XXQjQqSex0U
	 8huH5nuX8RIsUK2TyUSi3WJa9auswUT3uojTlvHvQTYYJP3nvvDxPtQwS9UzTin6kR
	 wzg/lsFhC4WZk4V1SW7SXDbZcoveY19Rk5OPPI84QdPFsN73j4mRfuR6UQHwEq+f8P
	 NEUsGkpcg3MMg==
Date: Mon, 09 Mar 2026 20:45:08 -0700
Subject: [PATCH 10/28] xfs_healer: create daemon to listen for health events
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177311401644.1183235.8515185316327819936.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a daemon program that can listen for and log health events.
Eventually this will be used to self-heal filesystems in real time.

Because events can take a while to process, the main thread reads event
objects from the healthmon fd and dispatches them to a background
workqueue as quickly as it can.  This split of responsibilities is
necessary because the kernel event queue will drop events if the queue
fills up, and each event can take some time to process (logging,
repairs, etc.) so we don't want to lose events.

To be clear, xfs_healer and xfs_scrub are complementary tools:

Scrub walks the whole filesystem, finds stuff that needs fixing or
rebuilding, and rebuilds it.  This is sort of analogous to a patrol
scrub.

Healer listens for metadata corruption messages from the kernel and
issues a targeted repair of that structure.  This is kind of like an
ondemand scrub.

My end goal is that xfs_healer (the service) is active all the time and
can respond instantly to a corruption report, whereas xfs_scrub (the
service) gets run periodically as a cron job.

xfs_healer can decide that it's overwhelmed with problems and start
xfs_scrub to deal with the mess.  Ideally you don't crash the filesystem
and then have to use xfs_repair to smash your way back to a mountable
filesystem.

By default we run xfs_healer as a background service, which means that
we only start two threads -- one to read the events, and another to
process them.  In other words, we try not to use all available hardware
resources for repairs.  The foreground mode switch starts up a large
number of threads to try to increase parallelism, which may or may not
be useful for repairs depending on how much metadata the kernel needs to
scan.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/xfs_healer.h  |   47 ++++++
 Makefile             |    5 +
 configure.ac         |    6 +
 healer/Makefile      |   35 ++++
 healer/xfs_healer.c  |  391 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/builddefs.in |    1 
 6 files changed, 485 insertions(+)
 create mode 100644 healer/xfs_healer.h
 create mode 100644 healer/Makefile
 create mode 100644 healer/xfs_healer.c


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
new file mode 100644
index 00000000000000..bcddde5db0cc47
--- /dev/null
+++ b/healer/xfs_healer.h
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025-2026 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef XFS_HEALER_XFS_HEALER_H_
+#define XFS_HEALER_XFS_HEALER_H_
+
+extern char *progname;
+
+/*
+ * When running in environments with restrictive security policies, healer
+ * might not be allowed to access the global mount tree.  However, processes
+ * are usually still allowed to see their own mount tree, so use this path for
+ * all mount table queries.
+ */
+#define _PATH_PROC_MOUNTS	"/proc/self/mounts"
+
+struct healer_ctx {
+	/* CLI options, must be int */
+	int			debug;
+	int			log;
+	int			everything;
+	int			foreground;
+
+	/* fd and fs geometry for mount */
+	struct xfs_fd		mnt;
+
+	/* Shared reference to the user's mountpoint for logging */
+	const char		*mntpoint;
+
+	/* Shared reference to the getmntent fsname for reconnecting */
+	const char		*fsname;
+
+	/* file stream of monitor and buffer */
+	FILE			*mon_fp;
+	char			*mon_buf;
+
+	/* coordinates logging printfs */
+	pthread_mutex_t		conlock;
+
+	/* event queue */
+	struct workqueue	event_queue;
+	bool			queue_active;
+};
+
+#endif /* XFS_HEALER_XFS_HEALER_H_ */
diff --git a/Makefile b/Makefile
index c73aa391bc5f43..1f499c30f3457e 100644
--- a/Makefile
+++ b/Makefile
@@ -69,6 +69,10 @@ ifeq ("$(ENABLE_SCRUB)","yes")
 TOOL_SUBDIRS += scrub
 endif
 
+ifeq ("$(ENABLE_HEALER)","yes")
+TOOL_SUBDIRS += healer
+endif
+
 ifneq ("$(XGETTEXT)","")
 TOOL_SUBDIRS += po
 endif
@@ -100,6 +104,7 @@ mkfs: libxcmd
 spaceman: libxcmd libhandle
 scrub: libhandle libxcmd
 rtcp: libfrog
+healer: libhandle
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/configure.ac b/configure.ac
index 7e38180745c268..29bb76b236c65b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -110,6 +110,12 @@ AC_ARG_ENABLE(libicu,
 [  --enable-libicu=[yes/no]  Enable Unicode name scanning in xfs_scrub (libicu) [default=probe]],,
 	enable_libicu=probe)
 
+# Enable xfs_healer build
+AC_ARG_ENABLE(healer,
+[  --enable-healer=[yes/no]  Enable build of xfs_healer utility [[default=yes]]],,
+	enable_healer=yes)
+AC_SUBST(enable_healer)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
diff --git a/healer/Makefile b/healer/Makefile
new file mode 100644
index 00000000000000..e82c820883669a
--- /dev/null
+++ b/healer/Makefile
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024-2026 Oracle.  All Rights Reserved.
+#
+
+TOPDIR = ..
+builddefs=$(TOPDIR)/include/builddefs
+include $(builddefs)
+
+INSTALL_HEALER = install-healer
+
+LTCOMMAND = xfs_healer
+
+CFILES = \
+xfs_healer.c
+
+HFILES = \
+xfs_healer.h
+
+LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBURCU) $(LIBPTHREAD)
+LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
+LLDFLAGS = -static
+
+default: depend $(LTCOMMAND)
+
+include $(BUILDRULES)
+
+install: $(INSTALL_HEALER)
+
+install-healer: default
+	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
+	$(INSTALL) -m 755 $(LTCOMMAND) $(PKG_LIBEXEC_DIR)
+
+install-dev:
+
+-include .dep
diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
new file mode 100644
index 00000000000000..e0076fff381632
--- /dev/null
+++ b/healer/xfs_healer.c
@@ -0,0 +1,391 @@
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
+#include "libfrog/fsgeom.h"
+#include "libfrog/paths.h"
+#include "libfrog/healthevent.h"
+#include "libfrog/workqueue.h"
+#include "libfrog/systemd.h"
+#include "xfs_healer.h"
+
+/* Program name; needed for libfrog error reports. */
+char				*progname = "xfs_healer";
+
+/* Return a health monitoring fd. */
+static int
+open_health_monitor(
+	struct healer_ctx		*ctx,
+	int				mnt_fd)
+{
+	struct xfs_health_monitor	hmo = {
+		.format			= XFS_HEALTH_MONITOR_FMT_V0,
+	};
+
+	if (ctx->everything)
+		hmo.flags |= XFS_HEALTH_MONITOR_VERBOSE;
+
+	return ioctl(mnt_fd, XFS_IOC_HEALTH_MONITOR, &hmo);
+}
+
+/* Decide if this event can only be reported upon, and not acted upon. */
+static bool
+event_not_actionable(
+	const struct xfs_health_monitor_event	*hme)
+{
+	switch (hme->type) {
+	case XFS_HEALTH_MONITOR_TYPE_LOST:
+	case XFS_HEALTH_MONITOR_TYPE_RUNNING:
+	case XFS_HEALTH_MONITOR_TYPE_UNMOUNT:
+	case XFS_HEALTH_MONITOR_TYPE_SHUTDOWN:
+		return true;
+	}
+
+	return false;
+}
+
+/* Should this event be logged? */
+static bool
+event_loggable(
+	const struct healer_ctx			*ctx,
+	const struct xfs_health_monitor_event	*hme)
+{
+	return ctx->log || event_not_actionable(hme);
+}
+
+/* Handle an event asynchronously. */
+static void
+handle_event(
+	struct workqueue		*wq,
+	uint32_t			index,
+	void				*arg)
+{
+	struct hme_prefix		pfx;
+	struct xfs_health_monitor_event	*hme = arg;
+	struct healer_ctx		*ctx = wq->wq_ctx;
+	const bool loggable = event_loggable(ctx, hme);
+
+	hme_prefix_init(&pfx, ctx->mntpoint);
+
+	/*
+	 * Non-actionable events should always be logged, because they are 100%
+	 * informational.
+	 */
+	if (loggable) {
+		pthread_mutex_lock(&ctx->conlock);
+		hme_report_event(&pfx, hme);
+		pthread_mutex_unlock(&ctx->conlock);
+	}
+
+	free(hme);
+}
+
+/*
+ * Find the filesystem source name for the mount that we're monitoring.  We
+ * don't use the fs_table_ helpers because we might be running in a restricted
+ * environment where we cannot access device files at all.
+ */
+static int
+try_capture_fsinfo(
+	struct healer_ctx	*ctx)
+{
+	struct mntent		*mnt;
+	FILE			*mtp;
+	char			rpath[PATH_MAX], rmnt_dir[PATH_MAX];
+
+	if (!realpath(ctx->mntpoint, rpath))
+		return -1;
+
+	mtp = setmntent(_PATH_PROC_MOUNTS, "r");
+	if (mtp == NULL)
+		return -1;
+
+	while ((mnt = getmntent(mtp)) != NULL) {
+		if (strcmp(mnt->mnt_type, "xfs"))
+			continue;
+		if (!realpath(mnt->mnt_dir, rmnt_dir))
+			continue;
+
+		if (!strcmp(rpath, rmnt_dir)) {
+			ctx->fsname = strdup(mnt->mnt_fsname);
+			break;
+		}
+	}
+
+	endmntent(mtp);
+
+	return ctx->fsname ? 0 : -1;
+}
+
+static unsigned int
+healer_nproc(
+	const struct healer_ctx	*ctx)
+{
+	/*
+	 * By default, use one event handler thread.  In foreground mode,
+	 * create one thread per cpu.
+	 */
+	return ctx->foreground ? platform_nproc() : 1;
+}
+
+/* Set ourselves up to monitor the given mountpoint for health events. */
+static int
+setup_monitor(
+	struct healer_ctx	*ctx)
+{
+	const long		BUF_SIZE = sysconf(_SC_PAGE_SIZE) * 2;
+	int			mon_fd;
+	int			ret;
+
+	ret = xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
+	if (ret) {
+		perror(ctx->mntpoint);
+		return -1;
+	}
+
+	ret = try_capture_fsinfo(ctx);
+	if (ret) {
+		fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+				_("Not a XFS mount point."));
+		goto out_mnt_fd;
+	}
+
+	/*
+	 * Open the health monitor, then close the mountpoint to avoid pinning
+	 * it.  We can reconnect later if need be.
+	 */
+	mon_fd = open_health_monitor(ctx, ctx->mnt.fd);
+	if (mon_fd < 0) {
+		switch (errno) {
+		case ENOTTY:
+		case EOPNOTSUPP:
+			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+ _("XFS health monitoring not supported."));
+			break;
+		case EEXIST:
+			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+ _("XFS health monitoring already running."));
+			break;
+		default:
+			perror(ctx->mntpoint);
+			break;
+		}
+
+		goto out_mnt_fd;
+	}
+	close(ctx->mnt.fd);
+	ctx->mnt.fd = -1;
+
+	/*
+	 * mon_fp consumes mon_fd.  We intentionally leave mon_fp attached to
+	 * the context so that we keep the monitoring fd open until we've torn
+	 * down all the background threads.
+	 */
+	ctx->mon_fp = fdopen(mon_fd, "r");
+	if (!ctx->mon_fp) {
+		perror(ctx->mntpoint);
+		goto out_mon_fd;
+	}
+
+	/* Increase the buffer size so that we can reduce kernel calls */
+	ctx->mon_buf = malloc(BUF_SIZE);
+	if (ctx->mon_buf)
+		setvbuf(ctx->mon_fp, ctx->mon_buf, _IOFBF, BUF_SIZE);
+
+	/*
+	 * Queue up to 1MB of events before we stop trying to read events from
+	 * the kernel as quickly as we can.  Note that the kernel won't accrue
+	 * more than 32K of internal events before it starts dropping them.
+	 */
+	ret = workqueue_create_bound(&ctx->event_queue, ctx, healer_nproc(ctx),
+			1048576 / sizeof(struct xfs_health_monitor_event));
+	if (ret) {
+		errno = ret;
+		fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
+				_("worker threadpool setup"), strerror(errno));
+		goto out_mon_fp;
+	}
+	ctx->queue_active = true;
+
+	return 0;
+
+out_mon_fp:
+	if (ctx->mon_fp)
+		fclose(ctx->mon_fp);
+	ctx->mon_fp = NULL;
+out_mon_fd:
+	if (mon_fd >= 0)
+		close(mon_fd);
+out_mnt_fd:
+	if (ctx->mnt.fd >= 0)
+		close(ctx->mnt.fd);
+	ctx->mnt.fd = -1;
+	return -1;
+}
+
+/* Monitor the given mountpoint for health events. */
+static void
+monitor(
+	struct healer_ctx	*ctx)
+{
+	bool			mounted = true;
+	size_t			nr;
+
+	do {
+		struct xfs_health_monitor_event	*hme;
+		int		ret;
+
+		hme = malloc(sizeof(*hme));
+		if (!hme) {
+			pthread_mutex_lock(&ctx->conlock);
+			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+					_("could not allocate event object"));
+			pthread_mutex_unlock(&ctx->conlock);
+			break;
+		}
+
+		nr = fread(hme, sizeof(*hme), 1, ctx->mon_fp);
+		if (nr == 0) {
+			free(hme);
+			break;
+		}
+
+		if (hme->type == XFS_HEALTH_MONITOR_TYPE_UNMOUNT)
+			mounted = false;
+
+		/* handle_event owns hme if the workqueue_add succeeds */
+		ret = workqueue_add(&ctx->event_queue, handle_event, 0, hme);
+		if (ret) {
+			pthread_mutex_lock(&ctx->conlock);
+			fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
+					_("could not queue event object"),
+					strerror(ret));
+			pthread_mutex_unlock(&ctx->conlock);
+			free(hme);
+			break;
+		}
+	} while (nr > 0 && mounted);
+}
+
+/* Tear down all the resources that we created for monitoring */
+static void
+teardown_monitor(
+	struct healer_ctx	*ctx)
+{
+	if (ctx->queue_active) {
+		workqueue_terminate(&ctx->event_queue);
+		workqueue_destroy(&ctx->event_queue);
+	}
+	if (ctx->mon_fp) {
+		fclose(ctx->mon_fp);
+		ctx->mon_fp = NULL;
+	}
+	free(ctx->mon_buf);
+	ctx->mon_buf = NULL;
+}
+
+static void __attribute__((noreturn))
+usage(void)
+{
+	fprintf(stderr, "%s %s %s\n", _("Usage:"), progname,
+			_("[OPTIONS] mountpoint"));
+	fprintf(stderr, "\n");
+	fprintf(stderr, _("Options:\n"));
+	fprintf(stderr, _("  --debug       Enable debugging messages.\n"));
+	fprintf(stderr, _("  --everything  Capture all events.\n"));
+	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
+	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
+	fprintf(stderr, _("  -V            Print version.\n"));
+
+	exit(EXIT_FAILURE);
+}
+
+enum long_opt_nr {
+	LOPT_DEBUG,
+	LOPT_EVERYTHING,
+	LOPT_FOREGROUND,
+	LOPT_HELP,
+	LOPT_QUIET,
+
+	LOPT_MAX,
+};
+
+int
+main(
+	int			argc,
+	char			**argv)
+{
+	struct healer_ctx	ctx = {
+		.conlock	= (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER,
+		.log		= 1,
+		.mnt.fd		= -1,
+	};
+	int			option_index;
+	int			vflag = 0;
+	int			c;
+	int			ret;
+
+	progname = basename(argv[0]);
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	struct option long_options[] = {
+		[LOPT_DEBUG]	   = {"debug", no_argument, &ctx.debug, 1 },
+		[LOPT_EVERYTHING]  = {"everything", no_argument, &ctx.everything, 1 },
+		[LOPT_FOREGROUND]  = {"foreground", no_argument, &ctx.foreground, 1 },
+		[LOPT_HELP]	   = {"help", no_argument, NULL, 0 },
+		[LOPT_QUIET]	   = {"quiet", no_argument, &ctx.log, 0 },
+
+		[LOPT_MAX]	   = {NULL, 0, NULL, 0 },
+	};
+
+	while ((c = getopt_long(argc, argv, "V", long_options, &option_index))
+			!= EOF) {
+		switch (c) {
+		case 0:
+			switch (option_index) {
+			case LOPT_HELP:
+				usage();
+				break;
+			default:
+				break;
+			}
+			break;
+		case 'V':
+			vflag++;
+			break;
+		default:
+			usage();
+			break;
+		}
+	}
+
+	if (vflag) {
+		fprintf(stdout, "%s %s %s\n", progname, _("version"), VERSION);
+		fflush(stdout);
+		return EXIT_SUCCESS;
+	}
+
+	if (optind != argc - 1)
+		usage();
+
+	ctx.mntpoint = argv[optind];
+
+	ret = setup_monitor(&ctx);
+	if (ret)
+		goto out_events;
+
+	monitor(&ctx);
+
+out_events:
+	teardown_monitor(&ctx);
+	free((char *)ctx.fsname);
+	return systemd_service_exit(ret);
+}
diff --git a/include/builddefs.in b/include/builddefs.in
index d2d25c8a0ed676..0ab2bf1702f0f0 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -91,6 +91,7 @@ ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
 ENABLE_SCRUB	= @enable_scrub@
+ENABLE_HEALER	= @enable_healer@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 

