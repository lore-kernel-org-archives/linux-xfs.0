Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F063CC2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YP7i9oVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF9BC433C7;
	Sun, 31 Dec 2023 22:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060920;
	bh=5i+acDtRVhCdulkqeCuKSbhLevar39VNrwdR/ipPfh4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YP7i9oVIoNHvPGBdDyZ8e9NkVIpMPw5zLbDuTyNi3eDRy6LkDajdXHSWQg5ey6QWa
	 hg9x2MeFdX5b8oYGBZ4jk6057uxPF3SZH9txVbjjgr0XQOivXjHsBxE2Ed5Cn612tB
	 ppFSgfi6f9RlbFlFrd8/D54coWlL93dK+7eA+f7kcAminvDKNiwnvisq02c0dIhXyh
	 +g0R4RQlIlmiEwLr/m7AxD9NE6pY8l9ZgZlDJbhp+hNANneGKwvi54DFPkMx9vtCwB
	 Lk2TYZfwOLkrf3UfY225pCGt2agi/Ju3MMWAK6VYwicNS6IJnoiySXEaM64ZjDJn+N
	 SxRLZECH7hyYA==
Date: Sun, 31 Dec 2023 14:15:19 -0800
Subject: [PATCH 03/10] libxfs: add xfile support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992822.1794490.7073871301856851913.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
References: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
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

Port the xfile functionality (anonymous pageable file-index memory) from
the kernel.  In userspace, we try to use memfd() to create tmpfs files
that are not in any namespace, matching the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    4 +
 include/builddefs.in  |    4 +
 libxfs/Makefile       |   15 +++
 libxfs/xfile.c        |  265 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfile.h        |   56 ++++++++++
 m4/package_libcdev.m4 |   66 ++++++++++++
 repair/xfs_repair.c   |   15 +++
 7 files changed, 425 insertions(+)
 create mode 100644 libxfs/xfile.c
 create mode 100644 libxfs/xfile.h


diff --git a/configure.ac b/configure.ac
index 2034f02e59e..38b62619a7a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -253,6 +253,10 @@ AC_CHECK_SIZEOF([char *])
 AC_TYPE_UMODE_T
 AC_MANUAL_FORMAT
 AC_HAVE_LIBURCU_ATOMIC64
+AC_HAVE_MEMFD_CLOEXEC
+AC_HAVE_MEMFD_NOEXEC_SEAL
+AC_HAVE_O_TMPFILE
+AC_HAVE_MKOSTEMP_CLOEXEC
 
 AC_CONFIG_FILES([include/builddefs])
 AC_OUTPUT
diff --git a/include/builddefs.in b/include/builddefs.in
index 43025ba4fcc..eb7f6ba4f03 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -130,6 +130,10 @@ CROND_DIR = @crond_dir@
 HAVE_UDEV = @have_udev@
 UDEV_RULE_DIR = @udev_rule_dir@
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
+HAVE_MEMFD_CLOEXEC = @have_memfd_cloexec@
+HAVE_MEMFD_NOEXEC_SEAL = @have_memfd_noexec_seal@
+HAVE_O_TMPFILE = @have_o_tmpfile@
+HAVE_MKOSTEMP_CLOEXEC = @have_mkostemp_cloexec@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 6f688c0ad25..68b366072da 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -26,6 +26,7 @@ HFILES = \
 	libxfs_priv.h \
 	linux-err.h \
 	topology.h \
+	xfile.h \
 	xfs_ag_resv.h \
 	xfs_alloc.h \
 	xfs_alloc_btree.h \
@@ -66,6 +67,7 @@ CFILES = cache.c \
 	topology.c \
 	trans.c \
 	util.c \
+	xfile.c \
 	xfs_ag.c \
 	xfs_ag_resv.c \
 	xfs_alloc.c \
@@ -112,6 +114,19 @@ CFILES = cache.c \
 #
 #LCFLAGS +=
 
+ifeq ($(HAVE_MEMFD_CLOEXEC),yes)
+	LCFLAGS += -DHAVE_MEMFD_CLOEXEC
+endif
+ifeq ($(HAVE_MEMFD_NOEXEC_SEAL),yes)
+	LCFLAGS += -DHAVE_MEMFD_NOEXEC_SEAL
+endif
+ifeq ($(HAVE_O_TMPFILE),yes)
+	LCFLAGS += -DHAVE_O_TMPFILE
+endif
+ifeq ($(HAVE_MKOSTEMP_CLOEXEC),yes)
+	LCFLAGS += -DHAVE_MKOSTEMP_CLOEXEC
+endif
+
 FCFLAGS = -I.
 
 LTLIBS = $(LIBPTHREAD) $(LIBRT)
diff --git a/libxfs/xfile.c b/libxfs/xfile.c
new file mode 100644
index 00000000000..57694d33498
--- /dev/null
+++ b/libxfs/xfile.c
@@ -0,0 +1,265 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "libxfs.h"
+#include "libxfs/xfile.h"
+#ifdef HAVE_MEMFD_NOEXEC_SEAL
+# include <linux/memfd.h>
+#endif
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+/*
+ * Swappable Temporary Memory
+ * ==========================
+ *
+ * Offline checking sometimes needs to be able to stage a large amount of data
+ * in memory.  This information might not fit in the available memory and it
+ * doesn't all need to be accessible at all times.  In other words, we want an
+ * indexed data buffer to store data that can be paged out.
+ *
+ * memfd files meet those requirements.  Therefore, the xfile mechanism uses
+ * one to store our staging data.  The xfile must be freed with xfile_destroy.
+ *
+ * xfiles assume that the caller will handle all required concurrency
+ * management; file locks are not taken.
+ */
+
+/*
+ * Open a memory-backed fd to back an xfile.  We require close-on-exec here,
+ * because these memfd files function as windowed RAM and hence should never
+ * be shared with other processes.
+ */
+static int
+xfile_create_fd(
+	const char		*description)
+{
+	int			fd = -1;
+	int			ret;
+
+#ifdef HAVE_MEMFD_CLOEXEC
+
+# ifdef HAVE_MEMFD_NOEXEC_SEAL
+	/*
+	 * Starting with Linux 6.3, there's a new MFD_NOEXEC_SEAL flag that
+	 * disables the longstanding memfd behavior that files are created with
+	 * the executable bit set, and seals the file against it being turned
+	 * back on.  Using this bit on older kernels produces EINVAL, so we
+	 * try this twice.
+	 */
+	fd = memfd_create(description, MFD_CLOEXEC | MFD_NOEXEC_SEAL);
+	if (fd >= 0)
+		goto got_fd;
+# endif /* HAVE_MEMFD_NOEXEC_SEAL */
+
+	/* memfd_create exists in kernel 3.17 (2014) and glibc 2.27 (2018). */
+	fd = memfd_create(description, MFD_CLOEXEC);
+	if (fd >= 0)
+		goto got_fd;
+#endif /* HAVE_MEMFD_CLOEXEC */
+
+#ifdef HAVE_O_TMPFILE
+	/*
+	 * O_TMPFILE exists as of kernel 3.11 (2013), which means that if we
+	 * find it, we're pretty safe in assuming O_CLOEXEC exists too.
+	 */
+	fd = open("/dev/shm", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
+	if (fd >= 0)
+		goto got_fd;
+
+	fd = open("/tmp", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
+	if (fd >= 0)
+		goto got_fd;
+#endif
+
+#ifdef HAVE_MKOSTEMP_CLOEXEC
+	/*
+	 * mkostemp exists as of glibc 2.7 (2007) and O_CLOEXEC exists as of
+	 * kernel 2.6.23 (2007).
+	 */
+	fd = mkostemp("libxfsXXXXXX", O_CLOEXEC);
+	if (fd >= 0)
+		goto got_fd;
+#endif
+
+#if !defined(HAVE_MEMFD_CLOEXEC) && \
+    !defined(HAVE_O_TMPFILE) && \
+    !defined(HAVE_MKOSTEMP_CLOEXEC)
+# error System needs memfd_create, O_TMPFILE, or O_CLOEXEC to build!
+#endif
+
+	if (!errno)
+		errno = EOPNOTSUPP;
+	return -1;
+got_fd:
+	/*
+	 * Turn off mode bits we don't want -- group members and others should
+	 * not have access to the xfile, nor it be executable.  memfds are
+	 * created with mode 0777, but we'll be careful just in case the other
+	 * implementations fail to set 0600.
+	 */
+	ret = fchmod(fd, 0600);
+	if (ret)
+		perror("disabling xfile executable bit");
+
+	return fd;
+}
+
+/*
+ * Create an xfile of the given size.  The description will be used in the
+ * trace output.
+ */
+int
+xfile_create(
+	const char		*description,
+	struct xfile		**xfilep)
+{
+	struct xfile		*xf;
+	int			error;
+
+	xf = kmem_alloc(sizeof(struct xfile), KM_MAYFAIL);
+	if (!xf)
+		return -ENOMEM;
+
+	xf->fd = xfile_create_fd(description);
+	if (xf->fd < 0) {
+		error = -errno;
+		kmem_free(xf);
+		return error;
+	}
+
+	*xfilep = xf;
+	return 0;
+}
+
+/* Close the file and release all resources. */
+void
+xfile_destroy(
+	struct xfile		*xf)
+{
+	close(xf->fd);
+	kmem_free(xf);
+}
+
+static inline loff_t
+xfile_maxbytes(
+	struct xfile		*xf)
+{
+	if (sizeof(loff_t) == 8)
+		return LLONG_MAX;
+	return LONG_MAX;
+}
+
+/*
+ * Read a memory object directly from the xfile's page cache.  Unlike regular
+ * pread, we return -E2BIG and -EFBIG for reads that are too large or at too
+ * high an offset, instead of truncating the read.  Otherwise, we return
+ * bytes read or an error code, like regular pread.
+ */
+ssize_t
+xfile_pread(
+	struct xfile		*xf,
+	void			*buf,
+	size_t			count,
+	loff_t			pos)
+{
+	ssize_t			ret;
+
+	if (count > INT_MAX)
+		return -E2BIG;
+	if (xfile_maxbytes(xf) - pos < count)
+		return -EFBIG;
+
+	ret = pread(xf->fd, buf, count, pos);
+	if (ret >= 0)
+		return ret;
+	return -errno;
+}
+
+/*
+ * Write a memory object directly to the xfile's page cache.  Unlike regular
+ * pwrite, we return -E2BIG and -EFBIG for writes that are too large or at too
+ * high an offset, instead of truncating the write.  Otherwise, we return
+ * bytes written or an error code, like regular pwrite.
+ */
+ssize_t
+xfile_pwrite(
+	struct xfile		*xf,
+	const void		*buf,
+	size_t			count,
+	loff_t			pos)
+{
+	ssize_t			ret;
+
+	if (count > INT_MAX)
+		return -E2BIG;
+	if (xfile_maxbytes(xf) - pos < count)
+		return -EFBIG;
+
+	ret = pwrite(xf->fd, buf, count, pos);
+	if (ret >= 0)
+		return ret;
+	return -errno;
+}
+
+/* Compute the number of bytes used by a xfile. */
+unsigned long long
+xfile_bytes(
+	struct xfile		*xf)
+{
+	struct xfile_stat	xs;
+	int			ret;
+
+	ret = xfile_stat(xf, &xs);
+	if (ret)
+		return 0;
+
+	return xs.bytes;
+}
+
+/* Query stat information for an xfile. */
+int
+xfile_stat(
+	struct xfile		*xf,
+	struct xfile_stat	*statbuf)
+{
+	struct stat		ks;
+	int			error;
+
+	error = fstat(xf->fd, &ks);
+	if (error)
+		return -errno;
+
+	statbuf->size = ks.st_size;
+	statbuf->bytes = (unsigned long long)ks.st_blocks << 9;
+	return 0;
+}
+
+/* Dump an xfile to stdout. */
+int
+xfile_dump(
+	struct xfile		*xf)
+{
+	char			*argv[] = {"od", "-tx1", "-Ad", "-c", NULL};
+	pid_t			child;
+	int			i;
+
+	child = fork();
+	if (child != 0) {
+		int		wstatus;
+
+		wait(&wstatus);
+		return wstatus == 0 ? 0 : -EIO;
+	}
+
+	/* reroute our xfile to stdin and shut everything else */
+	dup2(xf->fd, 0);
+	for (i = 3; i < 1024; i++)
+		close(i);
+
+	return execvp("od", argv);
+}
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
new file mode 100644
index 00000000000..4218c17e8bf
--- /dev/null
+++ b/libxfs/xfile.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBXFS_XFILE_H__
+#define __LIBXFS_XFILE_H__
+
+struct xfile {
+	int		fd;
+};
+
+int xfile_create(const char *description, struct xfile **xfilep);
+void xfile_destroy(struct xfile *xf);
+
+ssize_t xfile_pread(struct xfile *xf, void *buf, size_t count, loff_t pos);
+ssize_t xfile_pwrite(struct xfile *xf, const void *buf, size_t count, loff_t pos);
+
+/*
+ * Load an object.  Since we're treating this file as "memory", any error or
+ * short IO is treated as a failure to allocate memory.
+ */
+static inline int
+xfile_obj_load(struct xfile *xf, void *buf, size_t count, loff_t pos)
+{
+	ssize_t	ret = xfile_pread(xf, buf, count, pos);
+
+	if (ret < 0 || ret != count)
+		return -ENOMEM;
+	return 0;
+}
+
+/*
+ * Store an object.  Since we're treating this file as "memory", any error or
+ * short IO is treated as a failure to allocate memory.
+ */
+static inline int
+xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t pos)
+{
+	ssize_t	ret = xfile_pwrite(xf, buf, count, pos);
+
+	if (ret < 0 || ret != count)
+		return -ENOMEM;
+	return 0;
+}
+
+struct xfile_stat {
+	loff_t			size;
+	unsigned long long	bytes;
+};
+
+int xfile_stat(struct xfile *xf, struct xfile_stat *statbuf);
+unsigned long long xfile_bytes(struct xfile *xf);
+int xfile_dump(struct xfile *xf);
+
+#endif /* __LIBXFS_XFILE_H__ */
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 174070651ec..c81a7a031d2 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -531,3 +531,69 @@ AC_DEFUN([AC_PACKAGE_CHECK_LTO],
     AC_SUBST(lto_cflags)
     AC_SUBST(lto_ldflags)
   ])
+
+#
+# Check if we have a memfd_create syscall with a MFD_CLOEXEC flag
+#
+AC_DEFUN([AC_HAVE_MEMFD_CLOEXEC],
+  [ AC_MSG_CHECKING([for memfd_fd and MFD_CLOEXEC])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/mman.h>
+    ]], [[
+         return memfd_create("xfs", MFD_CLOEXEC);
+    ]])],[have_memfd_cloexec=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_memfd_cloexec)
+  ])
+
+#
+# Check if we have a memfd_create syscall with a MFD_NOEXEC_SEAL flag
+#
+AC_DEFUN([AC_HAVE_MEMFD_NOEXEC_SEAL],
+  [ AC_MSG_CHECKING([for memfd_fd and MFD_NOEXEC_SEAL])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <linux/memfd.h>
+#include <sys/mman.h>
+    ]], [[
+         return memfd_create("xfs", MFD_NOEXEC_SEAL);
+    ]])],[have_memfd_noexec_seal=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_memfd_noexec_seal)
+  ])
+
+#
+# Check if we have the O_TMPFILE flag
+#
+AC_DEFUN([AC_HAVE_O_TMPFILE],
+  [ AC_MSG_CHECKING([for O_TMPFILE])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+    ]], [[
+         return open("nowhere", O_TMPFILE, 0600);
+    ]])],[have_o_tmpfile=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_o_tmpfile)
+  ])
+
+#
+# Check if we have mkostemp with the O_CLOEXEC flag
+#
+AC_DEFUN([AC_HAVE_MKOSTEMP_CLOEXEC],
+  [ AC_MSG_CHECKING([for mkostemp and O_CLOEXEC])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdlib.h>
+    ]], [[
+         return mkostemp("nowhere", O_TMPFILE);
+    ]])],[have_mkostemp_cloexec=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_mkostemp_cloexec)
+  ])
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d4f99f36f71..01f92e841f2 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -953,6 +953,20 @@ phase_end(
 		platform_crash();
 }
 
+/* Try to allow as many memfds as possible. */
+static void
+bump_max_fds(void)
+{
+	struct rlimit	rlim = { };
+	int		ret;
+
+	ret = getrlimit(RLIMIT_NOFILE, &rlim);
+	if (!ret) {
+		rlim.rlim_cur = rlim.rlim_max;
+		setrlimit(RLIMIT_NOFILE, &rlim);
+	}
+}
+
 int
 main(int argc, char **argv)
 {
@@ -972,6 +986,7 @@ main(int argc, char **argv)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 	dinode_bmbt_translation_init();
+	bump_max_fds();
 
 	temp_mp = &xfs_m;
 	setbuf(stdout, NULL);

