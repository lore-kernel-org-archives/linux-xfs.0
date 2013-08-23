Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BF6F29DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 12:49:43 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A095304067
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 10:49:43 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r7NHnfHx002899
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 12:49:41 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130823174827.282748719@sgi.com>
Date: Fri, 23 Aug 2013 12:48:23 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs_io: v8 add the lseek() SEEK_DATA/SEEK_HOLE support
Content-Disposition: inline;
	filename=xfs_io-v8-add-the-lseek-SEEK_DATA-SEEK_HOLE-support.patch
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

Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
The result from the lseek() call will be printed to the output.
For example:

xfs_io> seek -hs 609k
Whence	Start	Result
HOLE	623616	630784

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
The "Wow! I could have had a v8"* patch   * TM of Cambell's Soup Company.
 Fix v7 bug by re-adding the flag mask check before calling seek_output().
 Add Eric's thought to display starting offset to output - using -s flag..
 Add table descriptor.

 io/Makefile       |    3 
 io/init.c         |    1 
 io/io.h           |    1 
 io/seek.c         |  224 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |   39 +++++++++
 5 files changed, 267 insertions(+), 1 deletion(-)

Index: b/io/Makefile
===================================================================
--- a/io/Makefile
+++ b/io/Makefile
@@ -10,7 +10,8 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xf
 HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c mmap.c \
-	open.c parent.c pread.c prealloc.c pwrite.c shutdown.c truncate.c
+	open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
+	truncate.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
Index: b/io/init.c
===================================================================
--- a/io/init.c
+++ b/io/init.c
@@ -64,6 +64,7 @@ init_commands(void)
 	help_init();
 	imap_init();
 	inject_init();
+	seek_init();
 	madvise_init();
 	mincore_init();
 	mmap_init();
Index: b/io/io.h
===================================================================
--- a/io/io.h
+++ b/io/io.h
@@ -105,6 +105,7 @@ extern void		pread_init(void);
 extern void		prealloc_init(void);
 extern void		pwrite_init(void);
 extern void		quit_init(void);
+extern void		seek_init(void);
 extern void		shutdown_init(void);
 extern void		truncate_init(void);
 
Index: b/io/seek.c
===================================================================
--- /dev/null
+++ b/io/seek.c
@@ -0,0 +1,224 @@
+/*
+ * Copyright (c) 2013 SGI
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#include <xfs/xfs.h>
+#include <xfs/command.h>
+#include <xfs/input.h>
+#include <sys/types.h>
+#include <unistd.h>
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
+" returns the next hole and/or data offset at or after the requested offset\n"
+"\n"
+" Example:\n"
+" 'seek -d 512'		- offset of data at or following offset 512\n"
+" 'seek -a -r 0'	- offsets of all data and hole in entire file\n"
+"\n"
+" Returns the offset of the next data and/or hole. There is an implied hole\n"
+" at the end of file. If the specified offset is past end of file, or there\n"
+" is no data past the specified offset, EOF is returned.\n"
+" -a	-- return the next data and hole starting at the specified offset.\n"
+" -d	-- return the next data starting at the specified offset.\n"
+" -h	-- return the next hole starting at the specified offset.\n"
+" -r	-- return all remaining type(s) starting at the specified offset.\n"
+" -s	-- also print the starting offset.\n"
+"\n"));
+}
+
+#ifndef HAVE_SEEK_DATA
+#define	SEEK_DATA	3	/* seek to the next data */
+#define	SEEK_HOLE	4	/* seek to the next hole */
+#endif
+
+/* values for flag variable */
+#define	SEEK_DFLAG	(1 << 0)
+#define	SEEK_HFLAG	(1 << 1)
+#define	SEEK_RFLAG	(1 << 2)
+
+/* indexes into the seekinfo array */
+#define	DATA		0
+#define	HOLE		1
+
+struct seekinfo {
+	char		*name;		/* display item name */
+	int		seektype;	/* data or hole */
+	int		mask;		/* compared for print and looping */
+} seekinfo[] = {
+		{"DATA", SEEK_DATA, SEEK_DFLAG},
+		{"HOLE", SEEK_HOLE, SEEK_HFLAG}
+};
+
+/* print item type and offset. catch special cases of eof and error */
+void
+seek_output(
+	int	startflag,
+	char	*type,
+	off64_t	start,
+	off64_t	offset)
+{
+	if (offset == -1) {
+		if (errno == ENXIO) {
+			if (startflag)
+				printf("%s	%lld	EOF\n", type,
+					 (long long)start);
+			else
+				printf("%s	EOF\n", type);
+		} else {
+			printf("ERR	%lld	", (long long)start);
+			fflush(stdout);	/* so the printf preceded the perror */
+			perror("");
+		}
+	} else {
+		if (startflag)
+			printf("%s	%lld	%lld\n", type,
+				(long long)start, (long long)offset);
+		else
+			printf("%s	%lld\n", type, (long long)offset);
+	}
+}
+
+static int
+seek_f(
+	int	argc,
+	char	**argv)
+{
+	off64_t		offset, start;
+	size_t		fsblocksize, fssectsize;
+	int		c;
+	int		current;	/* specify data or hole */
+	int		flag;
+	int		startflag;
+
+	flag = startflag = 0;
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "adhrs")) != EOF) {
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
+		case 's':
+			startflag = 1;
+			break;
+		default:
+			return command_usage(&seek_cmd);
+		}
+	}
+	if (!(flag & (SEEK_DFLAG | SEEK_HFLAG)) || optind != argc - 1)
+		return command_usage(&seek_cmd);
+
+	start = offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	if (offset < 0)
+		return command_usage(&seek_cmd);
+
+	/*
+	 * check to see if the offset is a data or hole entry and
+	 * decide if we want to display that type of entry.
+	 */
+	if (flag & SEEK_HFLAG) {
+		offset = lseek64(file->fd, start, SEEK_HOLE);
+		if ((start == offset) || !(flag & SEEK_DFLAG)) {
+			/*
+			 * this offset is a hole or are only displaying holes.
+			 * if this offset is for data and we are displaying
+			 * data, then we will fall through below to
+			 * initialize the data search.
+			 */
+			current = HOLE;
+			goto found_hole;
+		}
+	}
+
+	/* The offset is not a hole, or we are looking just for data */
+	current = DATA;
+	offset = lseek64(file->fd, start, SEEK_DATA);
+
+found_hole:
+	/*
+	 * At this point we know which type and the offset of the starting
+	 * item. "current" alternates between data / hole entries in
+	 * assending order - this alternation is needed even if only one
+	 * type is to be displayed.
+	 *
+	 * An error or EOF will terminate the display, otherwise "flag"
+	 * determines if there are more items to be displayed.
+	 */
+	if (startflag)
+		printf("Whence	Start	Result\n");
+	else
+		printf("Whence	Result\n");
+
+	for (c = 0; flag; c++) {
+		if (offset == -1) {
+			/* print error or eof if the only entry */
+			if (errno != ENXIO || c == 0 )
+				seek_output(startflag, seekinfo[current].name,
+					    start, offset);
+			return 0;	/* stop on error or EOF */
+		}
+
+		if (flag & seekinfo[current].mask)
+			seek_output(startflag, seekinfo[current].name, start,
+				    offset);
+
+		/*
+		 * When displaying only a single data and/or hole item, mask
+		 * off the item as it is displayed. The loop will end when all
+		 * requested items have been displayed.
+		 */
+		if (!(flag & SEEK_RFLAG))
+			flag &= ~seekinfo[current].mask;
+
+		current ^= 1;		/* alternate between data and hole */
+		start = offset;
+		offset = lseek64(file->fd, start, seekinfo[current].seektype);
+	}
+	return 0;
+}
+
+void
+seek_init(void)
+{
+	seek_cmd.name = "seek";
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
Index: b/man/man8/xfs_io.8
===================================================================
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -418,6 +418,45 @@ to read (in bytes)
 .RE
 .PD
 .TP
+.TP
+.BI "seek  \-a | \-d | \-h [ \-r ] [ \-s ] offset"
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
+.B \-s
+Display the starting lseek(2) offset. This offset will be a calculated value when
+both data and holes are displayed together or performing a recusively display.
+.TP
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
