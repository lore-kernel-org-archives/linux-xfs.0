Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0339D2C11E8
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114372; cv=none; b=LoochoFsvk9oqS4OZTi4q1xgiyLaQXfLmxE7GUi3niL4baY0GgfXvQhjpqheluvlf2viYEpcdk56tR2RmWHS9YrJ4+PYU0gq64B8Hp+LlFh59+NfkDieEQC2BtQ2ELvN6GhWLjLxXMq2B1Xe219/mNb7VOelM4iDzHCqTI0vuQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114372; c=relaxed/simple;
	bh=z0iS2HhLg8Xv0T6FuYEPLHzhzg02YpXqZ00DEZp1srQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YvS9eYVeUaupv1rcNuZidC+5hWheXJJ9gDvSdebWsLKFUPDx54eWhHmRZXOZNjwSkVqpowmeKF3EjoY7ZWmNZl7Pth0uwGmmOPW0+QVsdii/86i4JAdI1OG2Ls+W4oYeef8J0LYremwydzsRB6Vw8kndDseCaKdRUrCi+1fdLqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BK2SWBRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BK2SWBRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4F8C4CEF7;
	Tue, 10 Mar 2026 03:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114371;
	bh=z0iS2HhLg8Xv0T6FuYEPLHzhzg02YpXqZ00DEZp1srQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BK2SWBRC4On6RzcvSiLv3V/ov5iV4pEmT9L2r/kgjIpfCsUi1cNAMVQVoOohJNS2b
	 5kQJshHGlMMVtLU+5SIRUoqpe+J5zZyDNQnsg/wK4PkjCBcTd4r1DS9qAn3wp93xU6
	 roqnI/A5D9m441igLoCbRyC8nhItNtMB01M8kBdEfUqnwv98O6fSILZUsHvvwrLAQD
	 McIzJ7X7/Rz8/QMaV+T1ZzcaYqNqyxC0c2Y+S7uhfOSwB9Ash5VUcFdWsueCtPoTqW
	 sc9L+ZLBJHhf2zqHOlvMP18cWmwFrojf+AVkSokcESu/RLi5zCNTeLnEyHce6oIUP+
	 zdZBGiSiEbiLg==
Date: Mon, 09 Mar 2026 20:46:11 -0700
Subject: [PATCH 14/28] xfs_healer: create a service to start the per-mount
 healer service
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177311401718.1183235.13807931515634815060.stgit@frogsfrogsfrogs>
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

Create a daemon to wait for xfs mount events via fsnotify and start up
the per-mount healer service.  It's important that we're running in the
same mount namespace as the mount, so we're a fanotify client to avoid
having to filter the mount namespaces ourselves.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/systemd.h                  |   23 +-
 configure.ac                       |    1 
 healer/Makefile                    |   16 +-
 healer/xfs_healer_start.c          |  368 ++++++++++++++++++++++++++++++++++++
 healer/xfs_healer_start.service.in |   85 ++++++++
 include/builddefs.in               |    5 
 m4/package_libcdev.m4              |   24 ++
 7 files changed, 511 insertions(+), 11 deletions(-)
 create mode 100644 healer/xfs_healer_start.c
 create mode 100644 healer/xfs_healer_start.service.in


diff --git a/libfrog/systemd.h b/libfrog/systemd.h
index c96df4afa39aa6..8a0970282d1080 100644
--- a/libfrog/systemd.h
+++ b/libfrog/systemd.h
@@ -22,6 +22,20 @@ static inline bool systemd_is_service(void)
 	return getenv("SERVICE_MODE") != NULL;
 }
 
+/* Special processing for a service/daemon program that is exiting. */
+static inline int
+systemd_service_exit_now(int ret)
+{
+	/*
+	 * If we're being run as a service, the return code must fit the LSB
+	 * init script action error guidelines, which is to say that we
+	 * compress all errors to 1 ("generic or unspecified error", LSB 5.0
+	 * section 22.2) and hope the admin will scan the log for what actually
+	 * happened.
+	 */
+	return ret != 0 ? EXIT_FAILURE : EXIT_SUCCESS;
+}
+
 /* Special processing for a service/daemon program that is exiting. */
 static inline int
 systemd_service_exit(int ret)
@@ -35,14 +49,7 @@ systemd_service_exit(int ret)
 	 */
 	sleep(2);
 
-	/*
-	 * If we're being run as a service, the return code must fit the LSB
-	 * init script action error guidelines, which is to say that we
-	 * compress all errors to 1 ("generic or unspecified error", LSB 5.0
-	 * section 22.2) and hope the admin will scan the log for what actually
-	 * happened.
-	 */
-	return ret != 0 ? EXIT_FAILURE : EXIT_SUCCESS;
+	return systemd_service_exit_now(ret);
 }
 
 #endif /* __LIBFROG_SYSTEMD_H__ */
diff --git a/configure.ac b/configure.ac
index 29bb76b236c65b..bbea169432b8ce 100644
--- a/configure.ac
+++ b/configure.ac
@@ -194,6 +194,7 @@ if test "$have_listmount" = "yes"; then
 	AC_HAVE_LISTMOUNT_NS_FD
 	AC_HAVE_STATMOUNT_SUPPORTED_MASK
 fi
+AC_HAVE_FANOTIFY_MOUNTINFO
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/healer/Makefile b/healer/Makefile
index 9f176d294deaae..60bc31004ed423 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -9,6 +9,7 @@ include $(builddefs)
 INSTALL_HEALER = install-healer
 
 LTCOMMAND = xfs_healer
+BUILD_TARGETS = $(LTCOMMAND)
 
 CFILES = \
 fsrepair.c \
@@ -31,9 +32,18 @@ SYSTEMD_SERVICES=\
 	system-xfs_healer.slice \
 	$(XFS_HEALER_SVCNAME)
 OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
-endif
+endif # HAVE_SYSTEMD
 
-default: depend $(LTCOMMAND) $(SYSTEMD_SERVICES)
+ifeq ($(HAVE_HEALER_START_DEPS),yes)
+BUILD_TARGETS += xfs_healer_start
+SYSTEMD_SERVICES += xfs_healer_start.service
+endif # xfs_healer_start deps
+
+default: depend $(BUILD_TARGETS) $(SYSTEMD_SERVICES)
+
+xfs_healer_start: $(SUBDIRS) xfs_healer_start.o $(LTDEPENDENCIES)
+	@echo "    [LD]     $@"
+	$(Q)$(LTLINK) -o $@ $(LDFLAGS) xfs_healer_start.o $(LDLIBS)
 
 %.service: %.service.in $(builddefs)
 	@echo "    [SED]    $@"
@@ -46,7 +56,7 @@ install: $(INSTALL_HEALER)
 
 install-healer: default
 	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
-	$(INSTALL) -m 755 $(LTCOMMAND) $(PKG_LIBEXEC_DIR)
+	$(INSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)
 
 install-systemd: default
 	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
diff --git a/healer/xfs_healer_start.c b/healer/xfs_healer_start.c
new file mode 100644
index 00000000000000..c016e915da79a4
--- /dev/null
+++ b/healer/xfs_healer_start.c
@@ -0,0 +1,368 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2026 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+
+#include <errno.h>
+#include <err.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <sys/fanotify.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <linux/mount.h>
+#include <sys/syscall.h>
+#include <string.h>
+#include <limits.h>
+
+#include "platform_defs.h"
+#include "libfrog/systemd.h"
+#include "libfrog/statmount.h"
+
+static int debug = 0;
+static const char *progname = "xfs_healer_start";
+
+/* Start the xfs_healer service for a given mountpoint. */
+static void
+start_healer(
+	const char	*mntpoint)
+{
+	char		unitname[PATH_MAX];
+	int		ret;
+
+	ret = systemd_path_instance_unit_name(XFS_HEALER_SVCNAME, mntpoint,
+			unitname, PATH_MAX);
+	if (ret) {
+		fprintf(stderr, "%s: %s\n", mntpoint,
+				_("Could not determine xfs_healer unit name."));
+		return;
+	}
+
+	/*
+	 * Restart so that we aren't foiled by an existing unit that's slowly
+	 * working its way off a cycled mount.
+	 */
+	ret = systemd_manage_unit(UM_RESTART, unitname);
+	if (ret) {
+		fprintf(stderr, "%s: %s: %s\n", mntpoint,
+				_("Could not start xfs_healer service unit"),
+				unitname);
+		return;
+	}
+
+	printf("%s: %s\n", mntpoint, _("xfs_healer service started."));
+	fflush(stdout);
+}
+
+#define REQUIRED_STATMOUNT_FIELDS (STATMOUNT_FS_TYPE | \
+				   STATMOUNT_MNT_POINT | \
+				   STATMOUNT_MNT_ROOT)
+
+/* Process a newly discovered mountpoint. */
+static void
+examine_mount(
+	int			mnt_ns_fd,
+	uint64_t		mnt_id)
+{
+	size_t			smbuf_size = libfrog_statmount_sizeof(4096);
+	struct statmount	*smbuf = alloca(smbuf_size);
+	int			ret;
+
+	ret = libfrog_statmount(mnt_id, mnt_ns_fd, REQUIRED_STATMOUNT_FIELDS,
+			smbuf, smbuf_size);
+	if (ret) {
+		perror("statmount");
+		return;
+	}
+
+	if (debug) {
+		printf("mount: id 0x%llx fstype %s mountpoint %s mntroot %s\n",
+				(unsigned long long)mnt_id,
+				(smbuf->mask & STATMOUNT_FS_TYPE) ?
+					smbuf->str + smbuf->fs_type : "null",
+				(smbuf->mask & STATMOUNT_MNT_POINT) ?
+					smbuf->str + smbuf->mnt_point : "null",
+				(smbuf->mask & STATMOUNT_MNT_ROOT) ?
+					smbuf->str + smbuf->mnt_root : "null");
+		fflush(stdout);
+	}
+
+	/* Look for mount points for the root dir of an XFS filesystem. */
+	if ((smbuf->mask & REQUIRED_STATMOUNT_FIELDS) !=
+			   REQUIRED_STATMOUNT_FIELDS)
+		return;
+
+	if (!strcmp(smbuf->str + smbuf->fs_type, "xfs") &&
+	    !strcmp(smbuf->str + smbuf->mnt_root, "/"))
+		start_healer(smbuf->str + smbuf->mnt_point);
+}
+
+/* Translate fanotify mount events into something we can process. */
+static void
+handle_mount_event(
+	const struct fanotify_event_metadata	*event,
+	int					mnt_ns_fd)
+{
+	const struct fanotify_event_info_header	*info;
+	const struct fanotify_event_info_mnt	*mnt;
+	int					off;
+
+	if (event->fd != FAN_NOFD) {
+		if (debug)
+			fprintf(stderr, "Expected FAN_NOFD, got fd=%d\n",
+					event->fd);
+		return;
+	}
+
+	switch (event->mask) {
+	case FAN_MNT_ATTACH:
+		if (debug) {
+			printf("FAN_MNT_ATTACH (len=%d)\n", event->event_len);
+			fflush(stdout);
+		}
+		break;
+	default:
+		/* should never get here */
+		return;
+	}
+
+	for (off = sizeof(*event) ; off < event->event_len;
+	     off += info->len) {
+		info = (struct fanotify_event_info_header *)
+			((char *) event + off);
+
+		switch (info->info_type) {
+		case FAN_EVENT_INFO_TYPE_MNT:
+			mnt = (struct fanotify_event_info_mnt *) info;
+
+			if (debug) {
+				printf( "Mount record: len=%d mnt_id=0x%llx\n",
+						mnt->hdr.len, mnt->mnt_id);
+				fflush(stdout);
+			}
+
+			examine_mount(mnt_ns_fd, mnt->mnt_id);
+			break;
+
+		default:
+			if (debug)
+				fprintf(stderr,
+ "Unexpected fanotify event info_type=%d len=%d\n",
+						info->info_type, info->len);
+			break;
+		}
+	}
+}
+
+/* Extract mount attachment notifications from fanotify. */
+static void
+handle_notifications(
+	char				*buffer,
+	ssize_t				len,
+	int				mnt_ns_fd)
+{
+	struct fanotify_event_metadata	*event =
+		(struct fanotify_event_metadata *) buffer;
+
+	for (; FAN_EVENT_OK(event, len); event = FAN_EVENT_NEXT(event, len)) {
+
+		switch (event->mask) {
+		case FAN_MNT_ATTACH:
+			handle_mount_event(event, mnt_ns_fd);
+			break;
+		default:
+			if (debug)
+				fprintf(stderr,
+ "Unexpected fanotify mark: 0x%llx\n",
+					(unsigned long long)event->mask);
+			break;
+		}
+	}
+}
+
+#define NR_MNT_IDS		(32)
+
+/* Start healer services for existing XFS mounts. */
+static int
+start_existing_mounts(
+	int			mnt_ns_fd)
+{
+	uint64_t		mnt_ids[NR_MNT_IDS];
+	uint64_t		cursor = LISTMOUNT_INIT_CURSOR;
+	int			i;
+	int			ret;
+
+	while ((ret = libfrog_listmount(LSMT_ROOT, mnt_ns_fd, &cursor,
+					mnt_ids, NR_MNT_IDS)) > 0) {
+		for (i = 0; i < ret; i++)
+			examine_mount(mnt_ns_fd, mnt_ids[i]);
+	}
+
+	if (ret < 0) {
+		if (errno == ENOSYS)
+			fprintf(stderr, "%s\n",
+ _("This program requires the listmount system call."));
+		else
+			perror("listmount");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void __attribute__((noreturn))
+usage(void)
+{
+	fprintf(stderr, "%s %s %s\n", _("Usage:"), progname, _("[OPTIONS]"));
+	fprintf(stderr, "\n");
+	fprintf(stderr, _("Options:\n"));
+	fprintf(stderr, _("  --debug      Enable debugging messages.\n"));
+	fprintf(stderr, _("  --mountns    Path to the mount namespace file.\n"));
+	fprintf(stderr, _("  --supported  Make sure we can actually run.\n"));
+	fprintf(stderr, _("  -V           Print version.\n"));
+
+	exit(EXIT_FAILURE);
+}
+
+enum long_opt_nr {
+	LOPT_DEBUG,
+	LOPT_HELP,
+	LOPT_MOUNTNS,
+	LOPT_SUPPORTED,
+
+	LOPT_MAX,
+};
+
+int
+main(
+	int		argc,
+	char		*argv[])
+{
+	char		buffer[BUFSIZ];
+	const char	*mntns = NULL;
+	int		mnt_ns_fd;
+	int		fan_fd;
+	int		c;
+	int		option_index;
+	int		support_check = 0;
+	int		ret = 0;
+
+	struct option long_options[] = {
+		[LOPT_SUPPORTED] = {"supported", no_argument, &support_check, 1 },
+		[LOPT_DEBUG]	 = {"debug", no_argument, &debug, 1 },
+		[LOPT_HELP]	 = {"help", no_argument, NULL, 0 },
+		[LOPT_MOUNTNS]	 = {"mountns", required_argument, NULL, 0 },
+		[LOPT_MAX]	 = {NULL, 0, NULL, 0 },
+	};
+
+	while ((c = getopt_long(argc, argv, "V", long_options, &option_index))
+			!= EOF) {
+		switch (c) {
+		case 0:
+			switch (option_index) {
+			case LOPT_MOUNTNS:
+				mntns = optarg;
+				break;
+			case LOPT_HELP:
+				usage();
+				break;
+			default:
+				break;
+			}
+			break;
+		case 'V':
+			fprintf(stdout, "%s %s %s\n", progname, _("version"),
+					VERSION);
+			fflush(stdout);
+			return EXIT_SUCCESS;
+		default:
+			usage();
+			break;
+		}
+	}
+
+	/*
+	 * Try to open the mount namespace file for the current process.
+	 * fanotify requires this mount namespace file to send mount attachment
+	 * events, so this is required for correct functionality.
+	 */
+	mnt_ns_fd = open(mntns ? mntns : DEFAULT_MOUNTNS_FILE, O_RDONLY);
+	if (mnt_ns_fd < 0) {
+		if (errno == ENOENT && !mntns) {
+			perror(DEFAULT_MOUNTNS_FILE);
+			fprintf(stderr, "%s\n",
+ _("This program requires mount namespace support."));
+		} else {
+			perror(mntns ? mntns : DEFAULT_MOUNTNS_FILE);
+		}
+		ret = 1;
+		goto out;
+	}
+	if (mnt_ns_fd == DEFAULT_MOUNTNS_FD && mntns != NULL) {
+		/*
+		 * We specified a path to a mount namespace file but got fd 0,
+		 * which (for listmount and statmount) means to use the current
+		 * process' mount namespace.  That's probably not what the user
+		 * wanted.
+		 */
+		fprintf(stderr,
+ _("%s: got bad file descriptor for mount namespace\n"),
+				mntns);
+		ret = 1;
+		goto out;
+	}
+
+	fan_fd = fanotify_init(FAN_REPORT_MNT, O_RDONLY);
+	if (fan_fd < 0) {
+		perror("fanotify_init");
+		if (errno == EINVAL)
+			fprintf(stderr, "%s\n",
+ _("This program requires fanotify mount event support."));
+		ret = 1;
+		goto out;
+	}
+
+	ret = fanotify_mark(fan_fd, FAN_MARK_ADD | FAN_MARK_MNTNS,
+			FAN_MNT_ATTACH, mnt_ns_fd, NULL);
+	if (ret) {
+		perror("fanotify_mark");
+		goto out;
+	}
+
+	if (support_check) {
+		/*
+		 * We're being run as an ExecCondition process and we've
+		 * decided to start the main service.  There is no need to wait
+		 * for journald because the ExecStart version of ourselves will
+		 * take care of the waiting for us.
+		 */
+		return systemd_service_exit_now(0);
+	}
+
+	if (debug) {
+		printf("fanotify active\n");
+		fflush(stdout);
+	}
+
+	ret = start_existing_mounts(mnt_ns_fd);
+	if (ret)
+		goto out;
+
+	while (1) {
+		ssize_t bytes_read = read(fan_fd, buffer, BUFSIZ);
+
+		if (bytes_read < 0) {
+			perror("fanotify");
+			ret = 1;
+			break;
+		}
+
+		handle_notifications(buffer, bytes_read, mnt_ns_fd);
+	}
+
+out:
+	return systemd_service_exit(ret);
+}
diff --git a/healer/xfs_healer_start.service.in b/healer/xfs_healer_start.service.in
new file mode 100644
index 00000000000000..6fd34eafa48c33
--- /dev/null
+++ b/healer/xfs_healer_start.service.in
@@ -0,0 +1,85 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Start Self Healing of XFS Metadata
+
+[Service]
+Type=exec
+Environment=SERVICE_MODE=1
+ExecCondition=@pkg_libexec_dir@/xfs_healer_start --supported
+ExecStart=@pkg_libexec_dir@/xfs_healer_start
+
+# This service starts more services, so we want it to try to restart any time
+# the program exits or crashes.
+Restart=on-failure
+
+# Create the service underneath the healer background service slice so that we
+# can control resource usage.
+Slice=system-xfs_healer.slice
+
+# No realtime CPU scheduling
+RestrictRealtime=true
+
+# Must run with full privileges in a shared mount namespace so that we can
+# see new mounts and tell systemd to start the per-mount healer service.
+DynamicUser=false
+ProtectSystem=false
+ProtectHome=no
+PrivateTmp=true
+PrivateDevices=true
+
+# Don't let healer complain about paths in /etc/projects that have been hidden
+# by our sandboxing.  healer doesn't care about project ids anyway.
+InaccessiblePaths=-/etc/projects
+
+# No network access except to the systemd control socket
+PrivateNetwork=true
+ProtectHostname=true
+RestrictAddressFamilies=AF_UNIX
+IPAddressDeny=any
+
+# Don't let the program mess with the kernel configuration at all
+ProtectKernelLogs=true
+ProtectKernelModules=true
+ProtectKernelTunables=true
+ProtectControlGroups=true
+ProtectProc=invisible
+RestrictNamespaces=true
+
+# Hide everything in /proc, even /proc/mounts
+ProcSubset=pid
+
+# Only allow the default personality Linux
+LockPersonality=true
+
+# No writable memory pages
+MemoryDenyWriteExecute=true
+
+# Don't let our mounts leak out to the host
+PrivateMounts=true
+
+# Restrict system calls to the native arch and fanotify
+SystemCallArchitectures=native
+SystemCallFilter=@system-service
+SystemCallFilter=~@privileged
+SystemCallFilter=~@resources
+SystemCallFilter=~@mount
+SystemCallFilter=fanotify_init fanotify_mark
+
+# xfs_healer_start needs these privileges to open the rootdir and monitor
+CapabilityBoundingSet=CAP_SYS_ADMIN CAP_DAC_OVERRIDE
+AmbientCapabilities=CAP_SYS_ADMIN CAP_DAC_OVERRIDE
+NoNewPrivileges=true
+
+# xfs_healer_start doesn't create files
+UMask=7777
+
+# No access to hardware /dev files except for block devices
+ProtectClock=true
+DevicePolicy=closed
+
+[Install]
+WantedBy=multi-user.target
diff --git a/include/builddefs.in b/include/builddefs.in
index 0ab2bf1702f0f0..bdba9cd9037900 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -124,6 +124,7 @@ HAVE_LISTMOUNT = @have_listmount@
 HAVE_LISTMOUNT_NS_FD = @have_listmount_ns_fd@
 HAVE_STATMOUNT_SUPPORTED_MASK = @have_statmount_supported_mask@
 NEED_INTERNAL_STATMOUNT = @need_internal_statmount@
+HAVE_FANOTIFY_MOUNTINFO = @have_fanotify_mountinfo@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -159,6 +160,10 @@ ifeq ($(HAVE_LIBURCU_ATOMIC64),yes)
 PCFLAGS += -DHAVE_LIBURCU_ATOMIC64
 endif
 
+ifeq ($(ENABLE_HEALER)$(HAVE_SYSTEMD)$(HAVE_LISTMOUNT)$(HAVE_FANOTIFY_MOUNTINFO),yesyesyesyes)
+HAVE_HEALER_START_DEPS = yes
+endif
+
 SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@ @autovar_init_cflags@
 SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
 
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index ec4a3ef444b705..9586bc01fe0f25 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -452,3 +452,27 @@ AC_DEFUN([AC_HAVE_STATMOUNT_SUPPORTED_MASK],
     AC_SUBST(have_statmount_supported_mask)
     AC_SUBST(need_internal_statmount)
   ])
+
+#
+# Check if fanotify will give us mount notifications (6.15).
+#
+AC_DEFUN([AC_HAVE_FANOTIFY_MOUNTINFO],
+  [AC_MSG_CHECKING([for fanotify mount events])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <fcntl.h>
+#include <sys/fanotify.h>
+  ]], [[
+	struct fanotify_event_info_mnt info;
+
+	int fan_fd = fanotify_init(FAN_REPORT_MNT, 0);
+	fanotify_mark(fan_fd, FAN_MARK_ADD | FAN_MARK_MNTNS, FAN_MNT_ATTACH,
+			-1, NULL);
+  ]])
+    ], have_fanotify_mountinfo=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_fanotify_mountinfo)
+  ])

