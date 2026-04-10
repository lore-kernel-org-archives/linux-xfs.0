Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0904B312814
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801484; cv=none; b=JNdkYnXDvfR7W5yT8JqTgUP6RrsD/kbVpOGRVnpK4+10cnJWixVY52Hl5ykTuFmiZjnurZ2+UKPBtKqlLpNVHPm2N3ltfVaMdYRLCT2e11mJvW4yPcHx2RU/cJML9WrnLQo6IKPi09KE7hGuF8EwMvd3Fdv/vnKFISY+uVI0vpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801484; c=relaxed/simple;
	bh=7D7TTPikLzdUPVQ/it9kAM1/DpcqPvu8h9weepHaCkc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pYOwCDbRXn0fMOQ7rM6Qs8nJC4/R7ZXJ55S7nDv5VaNe0vUnZyeBn8L+UFqycYH+KmKjE+jmh6/I0DBcp4PV+gR9NqW34oIQf1O50wVo+35vCgA68VcOx1MJqQNAnEgJtlcvypidUlDJWkp4da8YRjF+dRh0XwHUbvzIVuCXKF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qEx432hH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qEx432hH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9607BC19421;
	Fri, 10 Apr 2026 06:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801483;
	bh=7D7TTPikLzdUPVQ/it9kAM1/DpcqPvu8h9weepHaCkc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qEx432hH2oesqLVEdf6LnfV+Zz4/axI0clHJitPA6nbshg2kXphOcIvFXCQCCobHO
	 GwsVDRQjwKhzHsHA6+xNYJc5rYxVNX93y5Lt6Y7CSPzQIRVW6gtXRQU5jr/KXZs9/P
	 IiUphUTRq0UEQSumzd7GM+r++zAP6Gn4+3ZkF5l5xMA8pTxlRqBS3P8OsOwUw7i1f8
	 YHm+o7Zzh4uCxQxvlQtR+WTaSpQb8Bl8WxoaDpEMusRxpeyflFnUd/vESG/p2xDRxU
	 sSFnG3h8QudZwKeQVymGFeCNRuJyUMdxUNIQPUS5KhOLnmadEVY0ouEryqmas/RUPU
	 odtuvBvcdTRog==
Date: Thu, 09 Apr 2026 23:11:23 -0700
Subject: [PATCH 03/26] libfrog: add support code for starting systemd services
 programmatically
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384286.2089237.11605812095696332975.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/systemd.h     |   20 +++++
 configure.ac          |    1 
 include/builddefs.in  |    1 
 libfrog/Makefile      |    6 ++
 libfrog/systemd.c     |  188 +++++++++++++++++++++++++++++++++++++++++++++++++
 m4/package_libcdev.m4 |   19 +++++
 6 files changed, 235 insertions(+)
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
index 8092b8656ef94b..a9febabc71cfc7 100644
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
index 00000000000000..5bff45bb23818b
--- /dev/null
+++ b/libfrog/systemd.c
@@ -0,0 +1,188 @@
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
+	int	max_fd = sysconf(_SC_OPEN_MAX);
+	int	fd;
+
+	if (max_fd < 1)
+		max_fd = 1024;
+
+#ifdef HAVE_CLOSE_RANGE
+	if (close_range(STDERR_FILENO + 1, max_fd, 0) == 0)
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
+		errno = ENODATA;
+		return -1;
+	}
+
+	if (bytes < 0) {
+		errno = EIO;
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
+	if (i == bytes) {
+		/*
+		 * Didn't find a newline to zero out?  That means the unit name
+		 * is longer than the bufffer.
+		 */
+		errno = E2BIG;
+		return -1;
+	}
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

