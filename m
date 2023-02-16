Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C383C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjBPVGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjBPVGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:06:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD71505D3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:06:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7462B8217A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B27C433D2;
        Thu, 16 Feb 2023 21:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581562;
        bh=49CSVlrWibAsZstRHwNy0rgc8vpFgWoeaHThscIc0Uw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ezNZk218xsHD7YOYE/VGXxdUMYYgHAwlPuSdQx/MR9BvSfb4zH67yd67fwqVNkJR9
         63yAvtx1k57eJjFEYbl11QB9LvB2kNAyDuDNL2q14KSbfPLVK/Y+KTQtURu21sW2Yi
         liucyOONqz6TjSldZ2nWCgLTV0WTwOZR2Qhq2l/GgEha/PmPTenXb5SZ9czv5rs+pm
         5W3jxseWCt8TvKrhHsNbgZuZ95Mh8Qiv0AyKu8JrhL6CYGC82eEiky8zfL97BxplaX
         E42L0UTsfT3KvJj2BBhmlfnK0CrlZmZ4UGwcVkjUqIAZGbA2Zud0CpImSlhlW/Af/l
         nDhbRvgAvbO2Q==
Date:   Thu, 16 Feb 2023 13:06:02 -0800
Subject: [PATCH 1/4] libxfs: add xfile support
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880693.3477371.11194291382483826413.stgit@magnolia>
In-Reply-To: <167657880680.3477371.18364607478868446486.stgit@magnolia>
References: <167657880680.3477371.18364607478868446486.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port the xfile functionality (anonymous pageable file-index memory) from
the kernel.  In userspace, we try to use memfd() to create tmpfs files
that are not in any namespace, matching the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    3 +
 include/builddefs.in  |    3 +
 libxfs/Makefile       |   12 +++
 libxfs/xfile.c        |  224 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfile.h        |   56 ++++++++++++
 m4/package_libcdev.m4 |   50 +++++++++++
 repair/xfs_repair.c   |   15 +++
 7 files changed, 363 insertions(+)
 create mode 100644 libxfs/xfile.c
 create mode 100644 libxfs/xfile.h


diff --git a/configure.ac b/configure.ac
index 63cc18cc..2472b32f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -251,6 +251,9 @@ AC_CHECK_SIZEOF([char *])
 AC_TYPE_UMODE_T
 AC_MANUAL_FORMAT
 AC_HAVE_LIBURCU_ATOMIC64
+AC_HAVE_MEMFD_CLOEXEC
+AC_HAVE_O_TMPFILE
+AC_HAVE_MKOSTEMP_CLOEXEC
 
 AC_CONFIG_FILES([include/builddefs])
 AC_OUTPUT
diff --git a/include/builddefs.in b/include/builddefs.in
index e0a2f3cb..60c1320a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -127,6 +127,9 @@ SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
 HAVE_CROND = @have_crond@
 CROND_DIR = @crond_dir@
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
+HAVE_MEMFD_CLOEXEC = @have_memfd_cloexec@
+HAVE_O_TMPFILE = @have_o_tmpfile@
+HAVE_MKOSTEMP_CLOEXEC = @have_mkostemp_cloexec@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 89d29dc9..17978006 100644
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
@@ -113,6 +115,16 @@ CFILES = cache.c \
 #
 #LCFLAGS +=
 
+ifeq ($(HAVE_MEMFD_CLOEXEC),yes)
+	LCFLAGS += -DHAVE_MEMFD_CLOEXEC
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
index 00000000..f551aef5
--- /dev/null
+++ b/libxfs/xfile.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "libxfs.h"
+#include "libxfs/xfile.h"
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
+
+#ifdef HAVE_MEMFD_CLOEXEC
+	/* memfd_create exists in kernel 3.17 (2014) and glibc 2.27 (2018). */
+	fd = memfd_create(description, MFD_CLOEXEC);
+	if (fd >= 0)
+		return fd;
+#endif
+
+#ifdef HAVE_O_TMPFILE
+	/*
+	 * O_TMPFILE exists as of kernel 3.11 (2013), which means that if we
+	 * find it, we're pretty safe in assuming O_CLOEXEC exists too.
+	 */
+	fd = open("/dev/shm", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
+	if (fd >= 0)
+		return fd;
+
+	fd = open("/tmp", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
+	if (fd >= 0)
+		return fd;
+#endif
+
+#ifdef HAVE_MKOSTEMP_CLOEXEC
+	/*
+	 * mkostemp exists as of glibc 2.7 (2007) and O_CLOEXEC exists as of
+	 * kernel 2.6.23 (2007).
+	 */
+	fd = mkostemp("libxfsXXXXXX", O_CLOEXEC);
+	if (fd >= 0)
+		return fd;
+#endif
+
+#if !defined(HAVE_MEMFD_CLOEXEC) && \
+    !defined(HAVE_O_TMPFILE) && \
+    !defined(HAVE_MKOSTEMP_CLOEXEC)
+# error System needs memfd_create, O_TMPFILE, or O_CLOEXEC to build!
+#endif
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
+	struct xfs_mount	*mp,
+	const char		*description,
+	struct xfile		**xfilep)
+{
+	struct xfile		*xf;
+	char			fname[MAXNAMELEN];
+	int			error;
+
+	snprintf(fname, MAXNAMELEN - 1, "XFS (%s): %s", mp->m_fsname,
+			description);
+	fname[MAXNAMELEN - 1] = 0;
+
+	xf = kmem_alloc(sizeof(struct xfile), KM_MAYFAIL);
+	if (!xf)
+		return -ENOMEM;
+
+	xf->fd = xfile_create_fd(fname);
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
index 00000000..1389ff8f
--- /dev/null
+++ b/libxfs/xfile.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBXFS_XFILE_H__
+#define __LIBXFS_XFILE_H__
+
+struct xfile {
+	int		fd;
+};
+
+int xfile_create(struct xfs_mount *mp, const char *description,
+		struct xfile **xfilep);
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
+int xfile_dump(struct xfile *xf);
+
+#endif /* __LIBXFS_XFILE_H__ */
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index bb1ab49c..119d1bda 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -507,3 +507,53 @@ AC_DEFUN([AC_PACKAGE_CHECK_LTO],
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
index ff29bea9..65cb9387 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -953,6 +953,20 @@ phase_end(int phase)
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

