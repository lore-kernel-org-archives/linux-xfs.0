Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFF237F78
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 07:39:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE7FC8F8035
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 05:39:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SUKr48wGEX5iMdKg for
	<xfs@oss.sgi.com>; Wed, 24 Jul 2013 05:39:32 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6OCdWbE007458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 08:39:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r6OCdVVC012230
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 08:39:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfsprogs/io: add readdir command
Date: Wed, 24 Jul 2013 08:44:27 -0400
Message-Id: <1374669868-14075-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

readdir reads the directory entries from an open directory from
the provided offset (or 0 if not specified). On completion,
readdir prints summary information regarding the number of
operations and bytes transferred. Options are available to specify
the starting offset, length and verbose mode to dump directory
entry information.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Convert from getdents to readdir.
- Use configure mechanism for libc readdir() availability (zab).
- Add extra dirent fields to verbose output (zab).

 configure.ac          |   1 +
 include/builddefs.in  |   1 +
 io/Makefile           |   5 ++
 io/init.c             |   1 +
 io/io.h               |   6 ++
 io/readdir.c          | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++
 m4/package_libcdev.m4 |  15 ++++
 7 files changed, 219 insertions(+)
 create mode 100644 io/readdir.c

diff --git a/configure.ac b/configure.ac
index e5fd94e..da099d8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -112,6 +112,7 @@ AC_HAVE_FIEMAP
 AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_BLKID_TOPO($enable_blkid)
+AC_HAVE_READDIR
 
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
diff --git a/include/builddefs.in b/include/builddefs.in
index 744e8d3..944bcf6 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -103,6 +103,7 @@ HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
+HAVE_READDIR = @have_readdir@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/io/Makefile b/io/Makefile
index 50edf91..d73f9b9 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -80,6 +80,11 @@ ifeq ($(HAVE_PREADV),yes)
 LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
 endif
 
+ifeq ($(HAVE_READDIR),yes)
+CFILES += readdir.c
+LCFLAGS += -DHAVE_READDIR
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/init.c b/io/init.c
index ca3055a..ee99761 100644
--- a/io/init.c
+++ b/io/init.c
@@ -74,6 +74,7 @@ init_commands(void)
 	fiemap_init();
 	pwrite_init();
 	quit_init();
+	readdir_init();
 	resblks_init();
 	sendfile_init();
 	shutdown_init();
diff --git a/io/io.h b/io/io.h
index 91f0e3e..e1f5328 100644
--- a/io/io.h
+++ b/io/io.h
@@ -149,3 +149,9 @@ extern void		sync_range_init(void);
 #else
 #define sync_range_init()	do { } while (0)
 #endif
+
+#ifdef HAVE_READDIR
+extern void		readdir_init(void);
+#else
+#define readdir_init()		do { } while (0)
+#endif
diff --git a/io/readdir.c b/io/readdir.c
new file mode 100644
index 0000000..eb47ac0
--- /dev/null
+++ b/io/readdir.c
@@ -0,0 +1,190 @@
+/*
+ * Copyright (c) 2013 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <xfs/xfs.h>
+#include <xfs/command.h>
+#include <xfs/input.h>
+#include "init.h"
+#include "io.h"
+
+#include <sys/types.h>
+#include <dirent.h>
+
+static struct cmdinfo readdir_cmd;
+
+const char *d_type_str(unsigned int type)
+{
+	const char *str;
+
+	switch (type) {
+	case DT_UNKNOWN:
+		str = "DT_UNKNOWN";
+		break;
+	case DT_FIFO:
+		str = "DT_FIFO";
+		break;
+	case DT_CHR:
+		str = "DT_CHR";
+		break;
+	case DT_DIR:
+		str = "DT_DIR";
+		break;
+	case DT_BLK:
+		str = "DT_BLK";
+		break;
+	case DT_REG:
+		str = "DT_REG";
+		break;
+	case DT_LNK:
+		str = "DT_LNK";
+		break;
+	case DT_SOCK:
+		str = "DT_SOCK";
+		break;
+	case DT_WHT:
+		str = "DT_WHT";
+		break;
+	default:
+		str = "ERROR!";
+		break;
+	}
+
+	return str;
+}
+
+static void
+dump_dirent(
+	long long offset,
+	struct dirent *dirent)
+{
+	printf("%08llx: d_ino: 0x%08lx", offset, dirent->d_ino);
+#ifdef _DIRENT_HAVE_D_OFF
+	printf(" d_off: 0x%08lx", dirent->d_off);
+#endif
+#ifdef _DIRENT_HAVE_D_RECLEN
+	printf(" d_reclen: 0x%x", dirent->d_reclen);
+#endif
+#ifdef _DIRENT_HAVE_D_TYPE
+	printf(" d_type: %s", d_type_str(dirent->d_type));
+#endif
+	printf(" d_name: %s\n", dirent->d_name);
+}
+
+static int
+read_directory(
+	DIR *dir,
+	long long offset,
+	unsigned long long length,
+	int dump,
+	unsigned long long *total)
+{
+	struct dirent *dirent;
+	int count = 0;
+
+	seekdir(dir, offset);
+
+	*total = 0;
+	while (*total < length) {
+		dirent = readdir(dir);
+		if (!dirent)
+			break;
+
+		*total += dirent->d_reclen;
+		count++;
+
+		if (dump) {
+			dump_dirent(offset, dirent);
+			offset = dirent->d_off;
+		}
+	}
+
+	return count;
+}
+
+static int
+readdir_f(
+	int argc,
+	char **argv)
+{
+	int cnt;
+	unsigned long long total;
+	int c;
+	size_t fsblocksize, fssectsize;
+	struct timeval t1, t2;
+	char s1[64], s2[64], ts[64];
+	long long offset = -1;
+	unsigned long long length = -1;		/* max length limit */
+	int verbose = 0;
+	DIR *dir;
+
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "l:o:v")) != EOF) {
+		switch (c) {
+		case 'l':
+			length = cvtnum(fsblocksize, fssectsize, optarg);
+			break;
+		case 'o':
+			offset = cvtnum(fsblocksize, fssectsize, optarg);
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			return command_usage(&readdir_cmd);
+		}
+	}
+
+	dir = fdopendir(file->fd);
+	if (!dir)
+		return -1;
+
+	if (offset == -1) {
+		rewinddir(dir);
+		offset = telldir(dir);
+	}
+
+	gettimeofday(&t1, NULL);
+	cnt = read_directory(dir, offset, length, verbose, &total);
+	gettimeofday(&t2, NULL);
+
+	t2 = tsub(t2, t1);
+	timestr(&t2, ts, sizeof(ts), 0);
+
+	cvtstr(total, s1, sizeof(s1));
+	cvtstr(tdiv(total, t2), s2, sizeof(s2));
+
+	printf(_("read %llu bytes from offset %lld\n"), total, offset);
+	printf(_("%s, %d ops, %s (%s/sec and %.4f ops/sec)\n"),
+		s1, cnt, ts, s2, tdiv(cnt, t2));
+
+	return 0;
+}
+
+void
+readdir_init(void)
+{
+	readdir_cmd.name = "readdir";
+	readdir_cmd.cfunc = readdir_f;
+	readdir_cmd.argmax = 5;
+	readdir_cmd.flags = CMD_NOMAP_OK|CMD_FOREIGN_OK;
+	readdir_cmd.args = _("[-v][-o offset][-l length]");
+	readdir_cmd.oneline = _("read directory entries");
+
+	add_command(&readdir_cmd);
+}
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index f489f52..8267ba0 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -170,3 +170,18 @@ AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
     AC_SUBST(have_sync_file_range)
   ])
 
+#
+# Check if we have a readdir libc call
+#
+AC_DEFUN([AC_HAVE_READDIR],
+  [ AC_MSG_CHECKING([for readdir])
+    AC_TRY_LINK([
+#include <dirent.h>
+    ], [
+         readdir(0);
+    ], have_readdir=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_readdir)
+  ])
+
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
