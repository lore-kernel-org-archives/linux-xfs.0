Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 396667CA3
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 14:45:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF08C8F8040
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 12:45:26 -0700 (PDT)
Received: from mx142.netapp.com (mx142.netapp.com [216.240.21.19]) by
	cuda.sgi.com with ESMTP id CRK1q2Zz9ZJ8wAgG (version=TLSv1.2
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2016 12:45:23 -0700 (PDT)
From: Anna Schumaker <Anna.Schumaker@netapp.com>
Subject: [PATCH] xfs_io: implement 'copy_range' command
Date: Fri, 1 Jul 2016 15:45:20 -0400
Message-ID: <20160701194520.28088-1-Anna.Schumaker@Netapp.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, david@fromorbit.com
Cc: anna.schumaker@netapp.com

Implements a new xfs_io command, named 'copy_range', which is supposed
to be used to copy a range of data from one file to another.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
---
 configure.ac          |   1 +
 include/builddefs.in  |   1 +
 io/Makefile           |   5 ++
 io/copy_file_range.c  | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c             |   1 +
 io/io.h               |   6 ++
 m4/package_libcdev.m4 |  17 ++++++
 7 files changed, 179 insertions(+)
 create mode 100644 io/copy_file_range.c

diff --git a/configure.ac b/configure.ac
index 83f9020..464b314 100644
--- a/configure.ac
+++ b/configure.ac
@@ -122,6 +122,7 @@ AC_HAVE_GETMNTINFO
 AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PREADV
+AC_HAVE_COPY_FILE_RANGE
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_MNTENT
 AC_HAVE_FLS
diff --git a/include/builddefs.in b/include/builddefs.in
index b5ce336..7153d7a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,6 +102,7 @@ HAVE_GETMNTINFO = @have_getmntinfo@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
+HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_READDIR = @have_readdir@
 HAVE_MNTENT = @have_mntent@
diff --git a/io/Makefile b/io/Makefile
index 0b53f41..62bc03b 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -59,6 +59,11 @@ CFILES += inject.c resblks.c
 LCFLAGS += -DHAVE_INJECT -DHAVE_RESBLKS
 endif
 
+ifeq ($(HAVE_COPY_FILE_RANGE),yes)
+CFILES += copy_file_range.c
+LCFLAGS += -DHAVE_COPY_FILE_RANGE
+endif
+
 ifeq ($(HAVE_SYNC_FILE_RANGE),yes)
 CFILES += sync_file_range.c
 LCFLAGS += -DHAVE_SYNC_FILE_RANGE
diff --git a/io/copy_file_range.c b/io/copy_file_range.c
new file mode 100644
index 0000000..eddc634
--- /dev/null
+++ b/io/copy_file_range.c
@@ -0,0 +1,148 @@
+/*
+ *  Copyright (c) 2016 Netapp, Inc. All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <sys/syscall.h>
+#include <sys/uio.h>
+#include <xfs/xfs.h>
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t copy_range_cmd;
+
+static void
+copy_range_help(void)
+{
+	printf(_("\n\
+ Copies a range of bytes from a file into the open file, overwriting any data\n\
+ already there.\n\
+\n\
+ Example:\n\
+ 'copy_range -s 100 -d 200 -l 300 some_file' - copies 300 bytes from some_file\n\
+                                               at offset 100 into the open\n\
+					       file at offset 200\n\
+ 'copy_range some_file' - copies all bytes from some_file into the open file\n\
+                          at position 0\n\
+"));
+}
+
+static loff_t
+copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
+{
+	loff_t ret;
+
+	do {
+		ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst, len, 0);
+		if (ret == -1)
+			return errno;
+		len -= ret;
+	} while (len > 0);
+
+	return 0;
+}
+
+static off64_t
+copy_src_filesize(int fd)
+{
+	struct stat64 st;
+
+	if (fstat64(fd, &st) < 0) {
+		perror("fstat64");
+		return -1;
+	};
+	return st.st_size;
+}
+
+static int
+copy_dst_truncate(void)
+{
+	int ret = ftruncate64(file->fd, 0);
+	if (ret < 0)
+		perror("ftruncate64");
+	return ret;
+}
+
+static int
+copy_range_f(int argc, char **argv)
+{
+	loff_t src = 0;
+	loff_t dst = 0;
+	size_t len = 0;
+	char *sp;
+	int opt;
+	int ret;
+	int fd;
+
+	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
+		switch (opt) {
+		case 's':
+			src = strtoull(optarg, &sp, 10);
+			if (!sp || sp == optarg) {
+				printf(_("invalid source offset -- %s\n"), sp);
+				return 0;
+			}
+			break;
+		case 'd':
+			dst = strtoull(optarg, &sp, 10);
+			if (!sp || sp == optarg) {
+				printf(_("invalid destination offset -- %s\n"), sp);
+				return 0;
+			}
+			break;
+		case 'l':
+			len = strtoull(optarg, &sp, 10);
+			if (!sp || sp == optarg) {
+				printf(_("invalid length -- %s\n"), sp);
+				return 0;
+			}
+			break;
+		}
+	}
+
+	if (optind != argc - 1)
+		return command_usage(&copy_range_cmd);
+
+	fd = openfile(argv[optind], NULL, IO_READONLY, 0);
+	if (fd < 0)
+		return 0;
+
+	if (src == 0 && dst == 0 && len == 0) {
+		len = copy_src_filesize(fd);
+		copy_dst_truncate();
+	}
+
+	ret = copy_file_range(fd, &src, &dst, len);
+	close(fd);
+	return ret;
+}
+
+void
+copy_range_init(void)
+{
+	copy_range_cmd.name = "copy_range";
+	copy_range_cmd.cfunc = copy_range_f;
+	copy_range_cmd.argmin = 1;
+	copy_range_cmd.argmax = 7;
+	copy_range_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	copy_range_cmd.args = _("[-s src_off] [-d dst_off] [-l len] src_file");
+	copy_range_cmd.oneline = _("Copy a range of data between two files");
+	copy_range_cmd.help = copy_range_help;
+
+	add_command(&copy_range_cmd);
+}
diff --git a/io/init.c b/io/init.c
index 51f1f5c..efe7390 100644
--- a/io/init.c
+++ b/io/init.c
@@ -56,6 +56,7 @@ init_commands(void)
 {
 	attr_init();
 	bmap_init();
+	copy_range_init();
 	fadvise_init();
 	file_init();
 	flink_init();
diff --git a/io/io.h b/io/io.h
index 172b1f8..2bc7ac4 100644
--- a/io/io.h
+++ b/io/io.h
@@ -150,6 +150,12 @@ extern void		fiemap_init(void);
 #define fiemap_init()	do { } while (0)
 #endif
 
+#ifdef HAVE_COPY_FILE_RANGE
+extern void		copy_range_init(void);
+#else
+#define copy_range_init()	do { } while (0)
+#endif
+
 #ifdef HAVE_SYNC_FILE_RANGE
 extern void		sync_range_init(void);
 #else
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 0165310..7a847e9 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -154,6 +154,23 @@ AC_DEFUN([AC_HAVE_PREADV],
   ])
 
 #
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
+#
 # Check if we have a sync_file_range libc call (Linux)
 #
 AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
-- 
2.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
