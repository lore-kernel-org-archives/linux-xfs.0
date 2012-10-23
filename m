Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NK1Ogp101523 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 15:01:24 -0500
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CCFADAC00B
	for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 13:03:04 -0700 (PDT)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	q9NK2rRa015560
	for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 15:02:53 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121023200144.515107339@sgi.com>
Date: Tue, 23 Oct 2012 15:01:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v2] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20121022213759.033667921@sgi.com>
	<20121022213804.616209844@sgi.com> <20121022232931.GD4291@dastard>
Content-Disposition: inline;
	filename=v2-xfs_io-support-SEEK_DATA-SEEK_HOLE.patch
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
The result from the lseek() call will be printed to the output.
For example:

xfs_io> lseek -h 609k
Type	Offset
hole	630784

Signed-off-by: Mark Tinguely <tinguely@sgi.com> 
---
 configure.in          |    1 
 include/builddefs.in  |    1 
 io/Makefile           |    5 +
 io/init.c             |    1 
 io/io.h               |    6 +
 io/lseek.c            |  165 ++++++++++++++++++++++++++++++++++++++++++++++++++
 m4/package_libcdev.m4 |   15 ++++
 man/man8/xfs_io.8     |   35 ++++++++++
 8 files changed, 229 insertions(+)

Index: b/configure.in
===================================================================
--- a/configure.in
+++ b/configure.in
@@ -109,6 +109,7 @@ AC_HAVE_GETMNTINFO
 AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PREADV
+AC_HAVE_LSEEK_DATA
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_BLKID_TOPO($enable_blkid)
 
Index: b/include/builddefs.in
===================================================================
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,6 +102,7 @@ HAVE_GETMNTINFO = @have_getmntinfo@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
+HAVE_LSEEK_DATA = @have_lseek_data@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
Index: b/io/Makefile
===================================================================
--- a/io/Makefile
+++ b/io/Makefile
@@ -80,6 +80,11 @@ ifeq ($(HAVE_PREADV),yes)
 LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
 endif
 
+ifeq ($(HAVE_LSEEK_DATA),yes)
+LCFLAGS += -DHAVE_LSEEK_DATA
+CFILES += lseek.c
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
Index: b/io/init.c
===================================================================
--- a/io/init.c
+++ b/io/init.c
@@ -64,6 +64,7 @@ init_commands(void)
 	help_init();
 	imap_init();
 	inject_init();
+	lseek_init();
 	madvise_init();
 	mincore_init();
 	mmap_init();
Index: b/io/io.h
===================================================================
--- a/io/io.h
+++ b/io/io.h
@@ -108,6 +108,12 @@ extern void		quit_init(void);
 extern void		shutdown_init(void);
 extern void		truncate_init(void);
 
+#ifdef HAVE_LSEEK_DATA
+extern void		lseek_init(void);
+#else
+#define lseek_init()	do { } while (0)
+#endif
+
 #ifdef HAVE_FADVISE
 extern void		fadvise_init(void);
 #else
Index: b/io/lseek.c
===================================================================
--- /dev/null
+++ b/io/lseek.c
@@ -0,0 +1,165 @@
+/*
+ * Copyright (c) 2012 SGI
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
+#include <linux/fs.h>
+
+#include <sys/uio.h>
+#include <xfs/xfs.h>
+#include <xfs/command.h>
+#include <xfs/input.h>
+#include <ctype.h>
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t lseek_cmd;
+
+static void
+lseek_help(void)
+{
+	printf(_(
+"\n"
+" returns the next hole and/or data offset at or after the specified offset\n"
+"\n"
+" Example:\n"
+" 'lseek -d 512'   - offset of data at or following offset 512\n"
+" 'lseek -a -r 0'  - offsets of all data and hole in entire file\n"
+"\n"
+" Returns the offset of the next data and/or hole. There is an implied hole\n"
+" at the end of file. If the specified offset is past end of file, or there\n"
+" is no data past the specied offset, EOF is returned.\n"
+" -a   -- return the next data and hole starting at the specified offset.\n"
+" -d   -- return the next data starting at the specified offset.\n"
+" -h   -- return the next hole starting at the specified offset.\n"
+" -r   -- return all remaining type(s) starting at the specified offset.\n"
+"\n"));
+}
+
+#define	LSEEK_DFLAG	1 << 0
+#define	LSEEK_HFLAG	1 << 1
+#define	LSEEK_RFLAG	1 << 2
+
+static int
+lseek_f(
+	int		argc,
+	char		**argv)
+{
+	off64_t		offset, off, roff;
+	size_t          fsblocksize, fssectsize;
+	int		cseg;
+	int		flag;
+	int		i, c;
+
+	flag = 0;
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "adhr")) != EOF) {
+		switch (c) {
+		case 'a':
+			flag |= LSEEK_HFLAG;
+			/* fall through to pick up the DFLAG */
+		case 'd':
+			flag |= LSEEK_DFLAG;
+			break;
+		case 'h':
+			flag |= LSEEK_HFLAG;
+			break;
+		case 'r':
+			flag |= LSEEK_RFLAG;
+			break;
+		default:
+			return command_usage(&lseek_cmd);
+		}
+	}
+		/* must have hole or data specified and an offset */
+	if (!(flag & (LSEEK_DFLAG | LSEEK_HFLAG)) ||
+             optind != argc - 1)
+		return command_usage(&lseek_cmd);
+
+	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+
+	/* recursively display all information, decide where to start. */
+	off = lseek64(file->fd, offset, SEEK_DATA);
+	if (off == offset)
+		cseg = LSEEK_DFLAG;
+	else
+		cseg = LSEEK_HFLAG;
+	
+	printf("Type	offset\n");
+
+	/* loop to handle the data / hole entries in assending order.
+	 * Only display the EOF when the initial offset was greater
+	 * the end of file.
+	 */
+	for (i = 0; flag & LSEEK_RFLAG || i < 2; i++) {
+		if (cseg == LSEEK_DFLAG) {
+			if (flag & LSEEK_DFLAG) {
+				roff = lseek64(file->fd, offset, SEEK_DATA);
+				if (roff == -1) {
+					if (i < 2) {
+						if (errno == ENXIO)
+							printf("data	EOF\n");
+						else
+							printf("data	%d\n",
+								-errno);
+					}
+					break;
+				} else
+					printf("data	%lld\n", roff);
+			}
+			/* set the offset and type for the next iteration */
+			cseg = LSEEK_HFLAG;
+			offset = lseek64(file->fd, offset, SEEK_HOLE);
+			continue;
+		}
+
+		/* cseg == LSEEK_HFLAG */
+		if (flag & LSEEK_HFLAG) {
+			roff = lseek64(file->fd, offset, SEEK_HOLE);
+			if (roff == -1) {
+				if (i < 2) {
+					if (errno == ENXIO)
+						printf("hole	EOF\n");
+					else
+						printf("hole	%d\n", -errno);
+				}
+				break;
+			} else
+				printf("hole	%lld\n", roff);
+		}
+		/* set the offset and type for the next iteration */
+		cseg = LSEEK_DFLAG;
+		offset = lseek64(file->fd, offset, SEEK_DATA);
+	}
+	return 0;
+}
+
+void
+lseek_init(void)
+{
+	lseek_cmd.name = "lseek";
+	lseek_cmd.altname = "seek";
+	lseek_cmd.cfunc = lseek_f;
+	lseek_cmd.argmin = 2;
+	lseek_cmd.argmax = 5;
+	lseek_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	lseek_cmd.args = _("-a | -d | -h [-r] off");
+	lseek_cmd.oneline = _("locate the next data and/or hole");
+	lseek_cmd.help = lseek_help;
+
+	add_command(&lseek_cmd);
+}
Index: b/m4/package_libcdev.m4
===================================================================
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -153,6 +153,21 @@ AC_DEFUN([AC_HAVE_PREADV],
     AC_SUBST(have_preadv)
   ])
 
+# 
+# Check if we have a working fadvise system call
+# 
+AC_DEFUN([AC_HAVE_LSEEK_DATA],
+  [ AC_MSG_CHECKING([for lseek SEEK_DATA])
+    AC_TRY_COMPILE([
+#include <linux/fs.h>
+    ], [
+	lseek(0, 0, SEEK_DATA);
+    ],	have_lseek_data=yes
+	AC_MSG_RESULT(yes),
+	AC_MSG_RESULT(no))
+    AC_SUBST(have_lseek_data)
+  ])
+
 #
 # Check if we have a sync_file_range libc call (Linux)
 #
Index: b/man/man8/xfs_io.8
===================================================================
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -377,6 +377,41 @@ must be specified as another open file
 .RB ( \-f )
 or by path
 .RB ( \-i ).
+.TP
+.BI "lseek  \-a | \-d | \-h [ \-r ] offset"
+On platforms that support the
+.BR lseek (2)
+.B SEEK_DATA
+and
+.B SEEK_HOLE
+options, display the offsets of the specified segments.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-a
+Display both
+.B data
+and
+.B hole
+segments starting at the specified
+.B offset.
+.TP
+.B \-d
+Display the 
+.B data
+segment starting at the specified
+.B offset.
+.TP
+.B \-h
+Display the 
+.B hole
+segment starting at the specified
+.B offset.
+.TP
+.B \-r
+Recursively display all the specified segments starting at the specified
+.B offset.
+.TP
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
