Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6G8UPY072241 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 10:08:30 -0600
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90B0930407B
	for <xfs@oss.sgi.com>; Tue,  6 Nov 2012 08:10:24 -0800 (PST)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	qA6GAMxf005797
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 10:10:22 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121106161001.654356435@sgi.com>
Date: Tue, 06 Nov 2012 10:08:44 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs_io: [v4] add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20121106160843.150744607@sgi.com>
Content-Disposition: inline;
	filename=v4-xfs_io-support-SEEK_DATA-SEEK_HOLE.patch
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
v1 -> v2 Add "-a" and "-r" options.
	 Simplify the output.
v2 -> v3 Refactor for configure.in -> configure.ac change.
	 SEEK_DATA with -1 offset behaves badly on older Linux.
	 Display error message as "ERR <errno>".
v3 -> v4 Change command name to "seek"
	 Modified detection of first data/hole.
	 Separate output routine.
	 Single loop to handle each data/hole item.

 configure.ac          |    1 
 include/builddefs.in  |    1 
 io/Makefile           |    5 +
 io/init.c             |    1 
 io/io.h               |    6 +
 io/seek.c             |  164 ++++++++++++++++++++++++++++++++++++++++++++++++++
 m4/package_libcdev.m4 |   15 ++++
 man/man8/xfs_io.8     |   35 ++++++++++
 8 files changed, 228 insertions(+)

Index: seek_xfsprogs/configure.ac
===================================================================
--- seek_xfsprogs.orig/configure.ac
+++ seek_xfsprogs/configure.ac
@@ -110,6 +110,7 @@ AC_HAVE_GETMNTINFO
 AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PREADV
+AC_HAVE_SEEK_DATA
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_BLKID_TOPO($enable_blkid)
 
Index: seek_xfsprogs/include/builddefs.in
===================================================================
--- seek_xfsprogs.orig/include/builddefs.in
+++ seek_xfsprogs/include/builddefs.in
@@ -102,6 +102,7 @@ HAVE_GETMNTINFO = @have_getmntinfo@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
+HAVE_SEEK_DATA = @have_seek_data@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
Index: seek_xfsprogs/io/Makefile
===================================================================
--- seek_xfsprogs.orig/io/Makefile
+++ seek_xfsprogs/io/Makefile
@@ -80,6 +80,11 @@ ifeq ($(HAVE_PREADV),yes)
 LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
 endif
 
+ifeq ($(HAVE_SEEK_DATA),yes)
+LCFLAGS += -DHAVE_SEEK_DATA
+CFILES += seek.c
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
Index: seek_xfsprogs/io/init.c
===================================================================
--- seek_xfsprogs.orig/io/init.c
+++ seek_xfsprogs/io/init.c
@@ -64,6 +64,7 @@ init_commands(void)
 	help_init();
 	imap_init();
 	inject_init();
+	seek_init();
 	madvise_init();
 	mincore_init();
 	mmap_init();
Index: seek_xfsprogs/io/io.h
===================================================================
--- seek_xfsprogs.orig/io/io.h
+++ seek_xfsprogs/io/io.h
@@ -108,6 +108,12 @@ extern void		quit_init(void);
 extern void		shutdown_init(void);
 extern void		truncate_init(void);
 
+#ifdef HAVE_SEEK_DATA
+extern void		seek_init(void);
+#else
+#define seek_init()	do { } while (0)
+#endif
+
 #ifdef HAVE_FADVISE
 extern void		fadvise_init(void);
 #else
Index: seek_xfsprogs/io/seek.c
===================================================================
--- /dev/null
+++ seek_xfsprogs/io/seek.c
@@ -0,0 +1,174 @@
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
+#include <libxfs.h>
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
+static cmdinfo_t seek_cmd;
+
+static void
+seek_help(void)
+{
+	printf(_(
+"\n"
+" returns the next hole and/or data offset at or after the specified offset\n"
+"\n"
+" Example:\n"
+" 'seek -d 512'   - offset of data at or following offset 512\n"
+" 'seek -a -r 0'  - offsets of all data and hole in entire file\n"
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
+#define	SEEK_DFLAG	(1 << 0)
+#define	SEEK_HFLAG	(1 << 1)
+#define	SEEK_RFLAG	(1 << 2)
+#define	DATA		0
+#define	HOLE		1
+
+struct seekinfo {
+	char		*name;
+	int		seektype;
+	int		mask;
+} seekinfo[] = {
+		{"DATA", SEEK_DATA, SEEK_DFLAG},
+		{"HOLE", SEEK_HOLE, SEEK_HFLAG}
+};
+
+void
+seek_output(
+	char	*name,
+	off64_t	offset)
+{	
+	if (offset == -1) {
+		if (errno == ENXIO)
+			printf("%s	EOF\n", name);
+		else
+			printf("%s	ERR %d\n", name, errno);
+	} else
+		printf("%s	%ld\n", name, offset);
+}
+
+static int
+seek_f(
+	int	argc,
+	char	**argv)
+{
+	off64_t		offset, result;
+	size_t          fsblocksize, fssectsize;
+	int		flag;
+	int		type;		/* specify data or hole */
+	int		c;
+
+	flag = 0;
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "adhr")) != EOF) {
+		switch (c) {
+		case 'a':
+			flag |= (SEEK_HFLAG | SEEK_DFLAG);
+			break;
+		case 'd':
+			flag |= SEEK_DFLAG;
+			break;
+		case 'h':
+			flag |= SEEK_HFLAG;
+			break;
+		case 'r':
+			flag |= SEEK_RFLAG;
+			break;
+		default:
+			return command_usage(&seek_cmd);
+		}
+	}
+		/* must have hole or data specified and an offset */
+	if (!(flag & (SEEK_DFLAG | SEEK_HFLAG)) ||
+             optind != argc - 1)
+		return command_usage(&seek_cmd);
+
+	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+
+	if (flag & SEEK_HFLAG) {
+		result = lseek64(file->fd, offset, SEEK_HOLE);
+		if ((result == offset) ||
+		    !(flag & SEEK_DFLAG)) {
+			offset = result;	/* in case it was EOF */
+			type = HOLE;
+			goto found_hole;
+		}
+	}
+
+	/* found data or both hole and data results in a -1 */
+	type = DATA;
+	offset = lseek64(file->fd, offset, SEEK_DATA);
+
+found_hole:
+	printf("Type	offset\n");
+
+	/* loop to handle the data / hole entries in assending order. */
+	while (flag) {
+		if (flag & seekinfo[type].mask)
+			seek_output(seekinfo[type].name, offset);
+
+		/* stop on error or when the EOF has been detected */
+		if (offset == -1)
+			break;
+
+		/* For the case of display only a single data and/or hole
+		 * item, mask off the item just displayed. The loop will
+		 * end when all the requested items have been displayed.
+		 */
+		if (!(flag & SEEK_RFLAG))
+			flag ^= seekinfo[type].mask;
+
+		type ^= 1;	/* alternate between data and hole */
+		offset = lseek64(file->fd, offset, seekinfo[type].seektype);
+	}
+	return 0;
+}
+
+void
+seek_init(void)
+{
+	seek_cmd.name = "seek";
+	seek_cmd.altname = "seek";
+	seek_cmd.cfunc = seek_f;
+	seek_cmd.argmin = 2;
+	seek_cmd.argmax = 5;
+	seek_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	seek_cmd.args = _("-a | -d | -h [-r] off");
+	seek_cmd.oneline = _("locate the next data and/or hole");
+	seek_cmd.help = seek_help;
+
+	add_command(&seek_cmd);
+}
Index: seek_xfsprogs/m4/package_libcdev.m4
===================================================================
--- seek_xfsprogs.orig/m4/package_libcdev.m4
+++ seek_xfsprogs/m4/package_libcdev.m4
@@ -153,6 +153,21 @@ AC_DEFUN([AC_HAVE_PREADV],
     AC_SUBST(have_preadv)
   ])
 
+# 
+# Check if we have a working fadvise system call
+# 
+AC_DEFUN([AC_HAVE_SEEK_DATA],
+  [ AC_MSG_CHECKING([for lseek SEEK_DATA])
+    AC_TRY_COMPILE([
+#include <linux/fs.h>
+    ], [
+	lseek(0, 0, SEEK_DATA);
+    ],	have_seek_data=yes
+	AC_MSG_RESULT(yes),
+	AC_MSG_RESULT(no))
+    AC_SUBST(have_seek_data)
+  ])
+
 #
 # Check if we have a sync_file_range libc call (Linux)
 #
Index: seek_xfsprogs/man/man8/xfs_io.8
===================================================================
--- seek_xfsprogs.orig/man/man8/xfs_io.8
+++ seek_xfsprogs/man/man8/xfs_io.8
@@ -377,6 +377,41 @@ must be specified as another open file
 .RB ( \-f )
 or by path
 .RB ( \-i ).
+.TP
+.BI "seek  \-a | \-d | \-h [ \-r ] offset"
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
