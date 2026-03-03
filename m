Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3E422D781
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498234; cv=none; b=ukfdFvU4hDezKJkXqZn8c5SQni+LrC36KMMek5FmP/N+wZHU350GOoIlFJ7XwA8QviBiIQJPf0JWWgBoW8639vI1Uy1sjwDF/bZzE65Zg749UXVDfgJZOr7gCAF2ynmd3SplhTxMDv3k/mmEBxrIxn5dL0FF6oLKI0wdY4CDTZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498234; c=relaxed/simple;
	bh=aFJr5N0MulSbG81T0kJHVTa2/JTv8q5YGTzlUViVHM4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mpFiwymvg+m4hDmHeEFSm4i5dMG8CZh0NsRER/ioG4F4+ezub3fF3JYcGC+yDsYV//PUf6d5+bKJQph4iJaLGg35xT5zkLiur6as4btI+onCPzoJcIEedwh1h1k9I/BmknKne6LqTqZUL41ZioIwZjsgERIh7/qd64fOh3/7iyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnnLoruQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnnLoruQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86346C19423;
	Tue,  3 Mar 2026 00:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498233;
	bh=aFJr5N0MulSbG81T0kJHVTa2/JTv8q5YGTzlUViVHM4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WnnLoruQd8C1H2xwl1K9OrOF76DLyoR7F1kUmoDupeoGn3CrZKabiqgCw8ngnN9qE
	 /gfkk7rkzuGtG4ZK7qEvkZLFgEt6G7hhLBCymWqR7oCJwr8vumAxl5NWzl//NexNz0
	 yCRc64034b7O/PEE70tyAsmJkAhNP8+SKX+yeCFqwvyA9DkLEbtv8uKYM+mV4KvPWs
	 j3kld15vNneVSwtDqZpFPd29oJORgtNaXR1tIaR8NPDizIr2Os5j3Rc/u8k5lRM0sj
	 Tx8xXAFi18vI8NFumfma/ukb58wUej5HrEQuQ/7k1r1tfv1Vv4UnV/0ZS6q7+xXlRK
	 QFWE90HzO6ibA==
Date: Mon, 02 Mar 2026 16:37:13 -0800
Subject: [PATCH 13/26] xfs_healer: create a service to start the per-mount
 healer service
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783527.482027.17759904859193601740.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
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
 configure.ac                       |    5 
 healer/Makefile                    |   27 ++-
 healer/xfs_healer_start.c          |  372 ++++++++++++++++++++++++++++++++++++
 healer/xfs_healer_start.service.in |   85 ++++++++
 include/builddefs.in               |    7 +
 m4/package_libcdev.m4              |   78 ++++++++
 7 files changed, 583 insertions(+), 14 deletions(-)
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
index 78bb87b159b10b..fb1e1973d2f559 100644
--- a/configure.ac
+++ b/configure.ac
@@ -189,6 +189,11 @@ AC_HAVE_BLKID_TOPO
 AC_HAVE_TRIVIAL_AUTO_VAR_INIT
 AC_STRERROR_R_RETURNS_STRING
 AC_HAVE_CLOSE_RANGE
+AC_HAVE_LISTMOUNT
+if test "$have_listmount" = "yes"; then
+	AC_HAVE_LISTMOUNT_NS_FD
+fi
+AC_HAVE_FANOTIFY_MOUNTINFO
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/healer/Makefile b/healer/Makefile
index 86d6f50781f9b6..53cc787c6fcd0c 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -9,6 +9,7 @@ include $(builddefs)
 INSTALL_HEALER = install-healer
 
 LTCOMMAND = xfs_healer
+BUILD_TARGETS = $(LTCOMMAND)
 
 CFILES = \
 fsrepair.c \
@@ -24,13 +25,27 @@ LLDFLAGS = -static
 
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_HEALER += install-systemd
-SYSTEMD_SERVICES=\
+XFS_HEALER_SVCNAME=xfs_healer@.service
+SYSTEMD_SERVICES = \
 	system-xfs_healer.slice \
-	xfs_healer@.service
-OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
-endif
+	$(XFS_HEALER_SVCNAME)
+endif # HAVE_SYSTEMD
 
-default: depend $(LTCOMMAND) $(SYSTEMD_SERVICES)
+ifeq ($(HAVE_HEALER_START_DEPS),yes)
+CFLAGS += -DXFS_HEALER_SVCNAME=\"$(XFS_HEALER_SVCNAME)\"
+ ifeq ($(HAVE_LISTMOUNT_NS_FD),yes)
+  CFLAGS += -DHAVE_LISTMOUNT_NS_FD
+ endif # listmount mnt_ns_fd
+
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
@@ -43,7 +58,7 @@ install: $(INSTALL_HEALER)
 
 install-healer: default
 	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
-	$(INSTALL) -m 755 $(LTCOMMAND) $(PKG_LIBEXEC_DIR)
+	$(INSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)
 
 install-systemd: default
 	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
diff --git a/healer/xfs_healer_start.c b/healer/xfs_healer_start.c
new file mode 100644
index 00000000000000..a4242adc17e6e8
--- /dev/null
+++ b/healer/xfs_healer_start.c
@@ -0,0 +1,372 @@
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
+
+#define DEFAULT_MOUNTNS_FILE		"/proc/self/ns/mnt"
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
+	struct mnt_id_req	req = {
+		.size		= sizeof(req),
+		.mnt_id		= mnt_id,
+#ifdef HAVE_LISTMOUNT_NS_FD
+		.mnt_ns_fd	= mnt_ns_fd,
+#else
+		.spare		= mnt_ns_fd,
+#endif
+		.param		= REQUIRED_STATMOUNT_FIELDS,
+	};
+	size_t			smbuf_size = sizeof(struct statmount) + 4096;
+	struct statmount	*smbuf = alloca(smbuf_size);
+	int			ret;
+
+	ret = syscall(SYS_statmount, &req, smbuf, smbuf_size, 0);
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
+/* Start healer services for existing XFS mounts. */
+static int
+start_existing_mounts(
+	int			mnt_ns_fd)
+{
+	struct mnt_id_req	req = {
+		.size		= sizeof(struct mnt_id_req),
+#ifdef HAVE_LISTMOUNT_NS_FD
+		.mnt_ns_fd	= mnt_ns_fd,
+#else
+		.spare		= mnt_ns_fd,
+#endif
+		.mnt_id		= LSMT_ROOT,
+	};
+	uint64_t		mnt_ids[32];
+	int			i;
+	int			ret;
+
+	while ((ret = syscall(SYS_listmount, &req, &mnt_ids, 32, 0)) > 0) {
+		for (i = 0; i < ret; i++)
+			examine_mount(mnt_ns_fd, mnt_ids[i]);
+
+		req.param = mnt_ids[ret - 1];
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
index 99373ec86215cf..51d24dd854bc17 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -120,6 +120,9 @@ UDEV_RULE_DIR = @udev_rule_dir@
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
 STRERROR_R_RETURNS_STRING = @strerror_r_returns_string@
 HAVE_CLOSE_RANGE = @have_close_range@
+HAVE_LISTMOUNT = @have_listmount@
+HAVE_LISTMOUNT_NS_FD = @have_listmount_ns_fd@
+HAVE_FANOTIFY_MOUNTINFO = @have_fanotify_mountinfo@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -152,6 +155,10 @@ ifeq ($(HAVE_LIBURCU_ATOMIC64),yes)
 PCFLAGS += -DHAVE_LIBURCU_ATOMIC64
 endif
 
+ifeq ($(ENABLE_HEALER)$(HAVE_SYSTEMD)$(HAVE_LISTMOUNT)$(HAVE_FANOTIFY_MOUNTINFO),yesyesyesyes)
+HAVE_HEALER_START_DEPS = yes
+endif
+
 SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@ @autovar_init_cflags@
 SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
 
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index b3d87229d3367a..a1ece2ad71dab7 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -366,3 +366,81 @@ close_range(0, 0, 0);
        AC_MSG_RESULT(no))
     AC_SUBST(have_close_range)
   ])
+
+#
+# Check if listmount and statmount exist.  Note that statmount came first (6.8)
+# and listmount came later (6.9).
+#
+AC_DEFUN([AC_HAVE_LISTMOUNT],
+  [AC_MSG_CHECKING([for listmount])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <unistd.h>
+#include <linux/mount.h>
+#include <sys/syscall.h>
+#include <alloca.h>
+  ]], [[
+	struct mnt_id_req	req = {
+		.size		= sizeof(req),
+	};
+	struct statmount	smbuf;
+
+	syscall(SYS_statmount, &req, &smbuf, 0, 0);
+	syscall(SYS_listmount, &req, NULL, 0, 0);
+  ]])
+    ], have_listmount=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_listmount)
+  ])
+
+#
+# Check if mnt_id_req::mnt_ns_fd exists.  This replaced mnt_id_req::spare in
+# 6.18.
+#
+AC_DEFUN([AC_HAVE_LISTMOUNT_NS_FD],
+  [AC_MSG_CHECKING([for struct mnt_id_req::mnt_ns_fd])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <unistd.h>
+#include <linux/mount.h>
+#include <sys/syscall.h>
+#include <alloca.h>
+  ]], [[
+	struct mnt_id_req	req = {
+		.mnt_ns_fd	= 555,
+	};
+
+	syscall(SYS_listmount, &req, NULL, 0, 0);
+  ]])
+    ], have_listmount_ns_fd=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_listmount_ns_fd)
+  ])
+
+#
+# Check if fanotify will give us mount notifications
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

