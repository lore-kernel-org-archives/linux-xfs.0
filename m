Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49218 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbeKUI2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 03:28:54 -0500
Subject: [PATCH 07/10] fsstress: add copy_file_range support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Nov 2018 13:57:24 -0800
Message-ID: <154275104427.8611.12901910984808681102.stgit@magnolia>
In-Reply-To: <154275100143.8611.10235098565750994724.stgit@magnolia>
References: <154275100143.8611.10235098565750994724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Support the copy_file_range syscall.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    2 +
 include/builddefs.in  |    1 
 ltp/Makefile          |    4 +
 ltp/fsstress.c        |  133 +++++++++++++++++++++++++++++++++++++++++++++++++
 m4/package_libcdev.m4 |   19 +++++++
 5 files changed, 159 insertions(+)


diff --git a/configure.ac b/configure.ac
index aede4f59..19798824 100644
--- a/configure.ac
+++ b/configure.ac
@@ -68,6 +68,8 @@ AC_PACKAGE_WANT_OPEN_BY_HANDLE_AT
 AC_PACKAGE_WANT_LINUX_PRCTL_H
 AC_PACKAGE_WANT_LINUX_FS_H
 
+AC_HAVE_COPY_FILE_RANGE
+
 AC_CHECK_FUNCS([renameat2])
 
 AC_CONFIG_HEADER(include/config.h)
diff --git a/include/builddefs.in b/include/builddefs.in
index fb8e912b..2605e42d 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -67,6 +67,7 @@ HAVE_DMAPI = @have_dmapi@
 HAVE_ATTR_LIST = @have_attr_list@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_FALLOCATE = @have_fallocate@
+HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 
diff --git a/ltp/Makefile b/ltp/Makefile
index 5f784ecf..e4ca45f4 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -28,6 +28,10 @@ ifeq ($(HAVE_FALLOCATE), true)
 LCFLAGS += -DFALLOCATE
 endif
 
+ifeq ($(HAVE_COPY_FILE_RANGE),yes)
+LCFLAGS += -DHAVE_COPY_FILE_RANGE
+endif
+
 default: depend $(TARGETS)
 
 depend: .dep
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index edbb3f2f..dded0cf7 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -26,6 +26,7 @@
 #include <libaio.h>
 io_context_t	io_ctx;
 #endif
+#include <sys/syscall.h>
 
 #ifndef FS_IOC_GETFLAGS
 #define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
@@ -55,6 +56,7 @@ typedef enum {
 	OP_BULKSTAT1,
 	OP_CHOWN,
 	OP_CLONERANGE,
+	OP_COPYRANGE,
 	OP_CREAT,
 	OP_DEDUPERANGE,
 	OP_DREAD,
@@ -163,6 +165,7 @@ void	bulkstat_f(int, long);
 void	bulkstat1_f(int, long);
 void	chown_f(int, long);
 void	clonerange_f(int, long);
+void	copyrange_f(int, long);
 void	creat_f(int, long);
 void	deduperange_f(int, long);
 void	dread_f(int, long);
@@ -212,6 +215,7 @@ opdesc_t	ops[] = {
 	{ OP_BULKSTAT1, "bulkstat1", bulkstat1_f, 1, 0 },
 	{ OP_CHOWN, "chown", chown_f, 3, 1 },
 	{ OP_CLONERANGE, "clonerange", clonerange_f, 4, 1 },
+	{ OP_COPYRANGE, "copyrange", copyrange_f, 4, 1 },
 	{ OP_CREAT, "creat", creat_f, 4, 1 },
 	{ OP_DEDUPERANGE, "deduperange", deduperange_f, 4, 1},
 	{ OP_DREAD, "dread", dread_f, 4, 0 },
@@ -2329,6 +2333,135 @@ clonerange_f(
 #endif
 }
 
+/* copy some arbitrary range of f1 to f2. */
+void
+copyrange_f(
+	int			opno,
+	long			r)
+{
+#ifdef HAVE_COPY_FILE_RANGE
+	struct pathname		fpath1;
+	struct pathname		fpath2;
+	struct stat64		stat1;
+	struct stat64		stat2;
+	char			inoinfo1[1024];
+	char			inoinfo2[1024];
+	loff_t			lr;
+	loff_t			off1;
+	loff_t			off2;
+	loff_t			max_off2;
+	size_t			len;
+	int			v1;
+	int			v2;
+	int			fd1;
+	int			fd2;
+	int			ret;
+	int			e;
+
+	/* Load paths */
+	init_pathname(&fpath1);
+	if (!get_fname(FT_REGm, r, &fpath1, NULL, NULL, &v1)) {
+		if (v1)
+			printf("%d/%d: copyrange read - no filename\n",
+				procid, opno);
+		goto out_fpath1;
+	}
+
+	init_pathname(&fpath2);
+	if (!get_fname(FT_REGm, random(), &fpath2, NULL, NULL, &v2)) {
+		if (v2)
+			printf("%d/%d: copyrange write - no filename\n",
+				procid, opno);
+		goto out_fpath2;
+	}
+
+	/* Open files */
+	fd1 = open_path(&fpath1, O_RDONLY);
+	e = fd1 < 0 ? errno : 0;
+	check_cwd();
+	if (fd1 < 0) {
+		if (v1)
+			printf("%d/%d: copyrange read - open %s failed %d\n",
+				procid, opno, fpath1.path, e);
+		goto out_fpath2;
+	}
+
+	fd2 = open_path(&fpath2, O_WRONLY);
+	e = fd2 < 0 ? errno : 0;
+	check_cwd();
+	if (fd2 < 0) {
+		if (v2)
+			printf("%d/%d: copyrange write - open %s failed %d\n",
+				procid, opno, fpath2.path, e);
+		goto out_fd1;
+	}
+
+	/* Get file stats */
+	if (fstat64(fd1, &stat1) < 0) {
+		if (v1)
+			printf("%d/%d: copyrange read - fstat64 %s failed %d\n",
+				procid, opno, fpath1.path, errno);
+		goto out_fd2;
+	}
+	inode_info(inoinfo1, sizeof(inoinfo1), &stat1, v1);
+
+	if (fstat64(fd2, &stat2) < 0) {
+		if (v2)
+			printf("%d/%d: copyrange write - fstat64 %s failed %d\n",
+				procid, opno, fpath2.path, errno);
+		goto out_fd2;
+	}
+	inode_info(inoinfo2, sizeof(inoinfo2), &stat2, v2);
+
+	/* Calculate offsets */
+	len = (random() % FILELEN_MAX) + 1;
+	if (len == 0)
+		len = stat1.st_blksize;
+	if (len > stat1.st_size)
+		len = stat1.st_size;
+
+	lr = ((int64_t)random() << 32) + random();
+	if (stat1.st_size == len)
+		off1 = 0;
+	else
+		off1 = (off64_t)(lr % MIN(stat1.st_size - len, MAXFSIZE));
+	off1 %= maxfsize;
+
+	/*
+	 * If srcfile == destfile, randomly generate destination ranges
+	 * until we find one that doesn't overlap the source range.
+	 */
+	max_off2 = MIN(stat2.st_size + (1024ULL * stat2.st_blksize), MAXFSIZE);
+	do {
+		lr = ((int64_t)random() << 32) + random();
+		off2 = (off64_t)(lr % max_off2);
+		off2 %= maxfsize;
+	} while (stat1.st_ino == stat2.st_ino && llabs(off2 - off1) < len);
+
+	ret = copy_file_range(fd1, &off1, fd2, &off2, len, 0);
+	e = ret < 0 ? errno : 0;
+	if (v1 || v2) {
+		printf("%d/%d: copyrange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
+			procid, opno,
+			fpath1.path, inoinfo1, (long long)off1, (long long)len,
+			fpath2.path, inoinfo2, (long long)off2, (long long)len);
+
+		if (ret < 0)
+			printf(" error %d", e);
+		printf("\n");
+	}
+
+out_fd2:
+	close(fd2);
+out_fd1:
+	close(fd1);
+out_fpath2:
+	free_pathname(&fpath2);
+out_fpath1:
+	free_pathname(&fpath1);
+#endif
+}
+
 /* dedupe some arbitrary range of f1 to f2...fn. */
 void
 deduperange_f(
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index fb123f33..14e67e18 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -98,3 +98,22 @@ AC_DEFUN([AC_HAVE_GETMNTINFO],
        AC_MSG_RESULT(no))
     AC_SUBST(have_getmntinfo)
   ])
+
+#
+#
+# Check if we have a copy_file_range system call (Linux)
+#
+AC_DEFUN([AC_HAVE_COPY_FILE_RANGE],
+  [ AC_MSG_CHECKING([for copy_file_range])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <unistd.h>
+    ], [
+         syscall(__NR_copy_file_range, 0, 0, 0, 0, 0, 0);
+    ], have_copy_file_range=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_copy_file_range)
+  ])
+
