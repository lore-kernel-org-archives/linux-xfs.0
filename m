Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9968734D4C1
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114199; cv=none; b=mNav4uPVVdhtPi5nO3XGPiAoH/RkmAakIXUqyd5rISMN4+oOWSbg1drH//qMxInm+Yia2Ry8jLfZNjxAVHEj0igj0D7l5zdZmpNtTro9w2oBj/XHFBLCfW50jHdO3G1LyayFDt8nvv9zenK5CLgqbz24mnahnro49kRCivEwnz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114199; c=relaxed/simple;
	bh=695wlMbZVaV16eTO8l3iBTktC/+SB1ROQ/GezfsoMUQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FfFLm3JAlU6IZtjwG5EQ2y3Jm10tcJd98NjZcW9ZH1aC8fLbzYwZpO4hYRSFaCL6A5zikyYSdYYNdN8XMMcAktvTtaN9AXIvQut/YYWUEeNE6OaHB8Q1Z5nr3Quwex3lAf3uKD62OJtpOE/P2dd9qsBv8P63WOxG8zp6buxKm90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qLr+E8v4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qLr+E8v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C35C4CEF7;
	Tue, 10 Mar 2026 03:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114199;
	bh=695wlMbZVaV16eTO8l3iBTktC/+SB1ROQ/GezfsoMUQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qLr+E8v4o9eYTSqn6l4u4X1wBSeJ7NC4U9XTfd7x1bilO0nhsf4r9jDSi7f4gYshb
	 XwChangMxe2M8zaFAWSZ4+9vg+J2VaogtLDgdf00nP2RT7IXXmvLBbTAaSsUoE5fqb
	 gyWiucUudzMVQZxmMniH4i5Y6GAhyn/FyNhJ3ZCoOwRhm2jSV+7RlVpbuV5QuUa56E
	 ylH8Q+6lrMMpjL5/ysjX1U9YuToAPTZe34qMJvqKv7jaDjiao2/BjeiovOK7y0QX42
	 rjxUi1b4qY3gY8v1wqtkVcGoqzs+pRnZoG0CzIGAxf02knZFi7oXicIFMnCfIPqS20
	 Jg9ZQFFU/F+Rg==
Date: Mon, 09 Mar 2026 20:43:18 -0700
Subject: [PATCH 03/28] libfrog: add support code for starting systemd services
 programmatically
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177311401522.1183235.13255430360161493359.stgit@frogsfrogsfrogs>
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

Add some simple routines for computing the name of systemd service
instances and starting systemd services.  These will be used by the
xfs_healer_start service to start per-filesystem xfs_healer service
instances.

Note that we run systemd helper programs as subprocesses for a couple of
reasons.  First, the path-escaping functionality is not a part of any
library-accessible API, which means it can only be accessed via
systemd-escape(1).  Second, although the service startup functionality
can be reached via dbus, doing so would introduce a new library
dependency.  Systemd is also undergoing a dbus -> varlink RPC transition
so we avoid that mess by calling the cli systemctl(1) program.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/systemd.h     |   20 +++++
 configure.ac          |    1 
 include/builddefs.in  |    1 
 libfrog/Makefile      |    6 ++
 libfrog/systemd.c     |  181 +++++++++++++++++++++++++++++++++++++++++++++++++
 m4/package_libcdev.m4 |   19 +++++
 6 files changed, 228 insertions(+)
 create mode 100644 libfrog/systemd.h
 create mode 100644 libfrog/systemd.c


diff --git a/libfrog/systemd.h b/libfrog/systemd.h
new file mode 100644
index 00000000000000..4f414bc3c1e9c3
--- /dev/null
+++ b/libfrog/systemd.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2026 Oracle.  All rights reserved.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_SYSTEMD_H__
+#define __LIBFROG_SYSTEMD_H__
+
+int systemd_path_instance_unit_name(const char *unit_template,
+		const char *path, char *unitname, size_t unitnamelen);
+
+enum systemd_unit_manage {
+	UM_STOP,
+	UM_START,
+	UM_RESTART,
+};
+
+int systemd_manage_unit(enum systemd_unit_manage how, const char *unitname);
+
+#endif /* __LIBFROG_SYSTEMD_H__ */
diff --git a/configure.ac b/configure.ac
index a8b8f7d5066fb6..8d2bbb9ef88bb9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -182,6 +182,7 @@ AC_CONFIG_UDEV_RULE_DIR
 AC_HAVE_BLKID_TOPO
 AC_HAVE_TRIVIAL_AUTO_VAR_INIT
 AC_STRERROR_R_RETURNS_STRING
+AC_HAVE_CLOSE_RANGE
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/include/builddefs.in b/include/builddefs.in
index b38a099b7d525a..4a2cb757c0bdb3 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -118,6 +118,7 @@ HAVE_UDEV = @have_udev@
 UDEV_RULE_DIR = @udev_rule_dir@
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
 STRERROR_R_RETURNS_STRING = @strerror_r_returns_string@
+HAVE_CLOSE_RANGE = @have_close_range@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/libfrog/Makefile b/libfrog/Makefile
index bccd9289e5dd79..89a0332ae85372 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -36,6 +36,7 @@ ptvar.c \
 radix-tree.c \
 randbytes.c \
 scrub.c \
+systemd.c \
 util.c \
 workqueue.c \
 zones.c
@@ -70,6 +71,7 @@ radix-tree.h \
 randbytes.h \
 scrub.h \
 statx.h \
+systemd.h \
 workqueue.h \
 zones.h
 
@@ -90,6 +92,10 @@ ifeq ($(HAVE_GETRANDOM_NONBLOCK),yes)
 LCFLAGS += -DHAVE_GETRANDOM_NONBLOCK
 endif
 
+ifeq ($(HAVE_CLOSE_RANGE),yes)
+CFLAGS += -DHAVE_CLOSE_RANGE
+endif
+
 default: ltdepend $(LTLIBRARY) $(GETTEXT_PY)
 
 crc32table.h: gen_crc32table.c crc32defs.h
diff --git a/libfrog/systemd.c b/libfrog/systemd.c
new file mode 100644
index 00000000000000..0e04ee04fc2682
--- /dev/null
+++ b/libfrog/systemd.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2026 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/wait.h>
+
+#include "libfrog/systemd.h"
+
+/* Close all fds except for the three standard ones. */
+static void
+close_fds(void)
+{
+	int max_fd = sysconf(_SC_OPEN_MAX);
+	int fd;
+#ifdef HAVE_CLOSE_RANGE
+	int ret;
+#endif
+
+	if (max_fd < 1)
+		max_fd = 1024;
+
+#ifdef HAVE_CLOSE_RANGE
+	ret = close_range(STDERR_FILENO + 1, max_fd, 0);
+	if (!ret)
+		return;
+#endif
+
+	for (fd = STDERR_FILENO + 1; fd < max_fd; fd++)
+		close(fd);
+}
+
+/*
+ * Compute the systemd instance unit name for a given path.
+ *
+ * The escaping logic is implemented directly in systemctl so there's no
+ * library or dbus service that we can call.
+ */
+int
+systemd_path_instance_unit_name(
+	const char		*unit_template,
+	const char		*path,
+	char			*unitname,
+	size_t			unitnamelen)
+{
+	size_t			i;
+	ssize_t			bytes;
+	pid_t			child_pid;
+	int			pipe_fds[2];
+	int			child_status;
+	int			ret;
+
+	ret = pipe(pipe_fds);
+	if (ret)
+		return -1;
+
+	child_pid = fork();
+	if (child_pid < 0)
+		return -1;
+
+	if (!child_pid) {
+		/* child process */
+		char		*argv[] = {
+			"systemd-escape",
+			"--template",
+			(char *)unit_template,
+			"--path",
+			(char *)path,
+			NULL,
+		};
+
+		ret = dup2(pipe_fds[1], STDOUT_FILENO);
+		if (ret < 0) {
+			perror(path);
+			goto fail;
+		}
+
+		close_fds();
+
+		ret = execvp("systemd-escape", argv);
+		if (ret)
+			perror(path);
+
+fail:
+		exit(EXIT_FAILURE);
+	}
+
+	/*
+	 * Close our connection to stdin so that the read won't hang if the
+	 * child exits without writing anything to stdout.
+	 */
+	close(pipe_fds[1]);
+	bytes = read(pipe_fds[0], unitname, unitnamelen - 1);
+	close(pipe_fds[0]);
+
+	waitpid(child_pid, &child_status, 0);
+	if (!WIFEXITED(child_status) || WEXITSTATUS(child_status) != 0) {
+		errno = 0;
+		return -1;
+	}
+
+	/* Terminate string at first newline or end of buffer. */
+	for (i = 0; i < bytes; i++) {
+		if (unitname[i] == '\n') {
+			unitname[i] = 0;
+			break;
+		}
+	}
+	if (i == bytes)
+		unitname[unitnamelen - 1] = 0;
+
+	return 0;
+}
+
+static const char *systemd_unit_manage_string(enum systemd_unit_manage how)
+{
+	switch (how) {
+	case UM_STOP:
+		return "stop";
+	case UM_START:
+		return "start";
+	case UM_RESTART:
+		return "restart";
+	}
+
+	/* shut up gcc */
+	return NULL;
+}
+
+/*
+ * Start/stop/restart a systemd unit and let it run in the background.
+ *
+ * systemctl start wraps a lot of logic around starting a unit, so it's less
+ * work for xfsprogs to invoke systemctl instead of calling through dbus.
+ */
+int
+systemd_manage_unit(
+	enum systemd_unit_manage	how,
+	const char			*unitname)
+{
+	pid_t				child_pid;
+	int				child_status;
+	int				ret;
+
+	child_pid = fork();
+	if (child_pid < 0)
+		return -1;
+
+	if (!child_pid) {
+		/* child starts the process */
+		char		*argv[] = {
+			"systemctl",
+			(char *)systemd_unit_manage_string(how),
+			"--no-block",
+			(char *)unitname,
+			NULL,
+		};
+
+		close_fds();
+
+		ret = execvp("systemctl", argv);
+		if (ret)
+			perror("systemctl");
+
+		exit(EXIT_FAILURE);
+	}
+
+	/* parent waits for process */
+	waitpid(child_pid, &child_status, 0);
+
+	/* systemctl (stop/start/restart) --no-block should return quickly */
+	if (WIFEXITED(child_status) && WEXITSTATUS(child_status) == 0)
+		return 0;
+
+	errno = ENOMEM;
+	return -1;
+}
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index c5538c30d2518a..b3d87229d3367a 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -347,3 +347,22 @@ puts(strerror_r(0, buf, sizeof(buf)));
     CFLAGS="$OLD_CFLAGS"
     AC_SUBST(strerror_r_returns_string)
   ])
+
+#
+# Check if close_range exists
+#
+AC_DEFUN([AC_HAVE_CLOSE_RANGE],
+  [AC_MSG_CHECKING([for close_range])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <unistd.h>
+#include <linux/close_range.h>
+  ]], [[
+close_range(0, 0, 0);
+  ]])
+    ], have_close_range=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_close_range)
+  ])

