Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 660CC7F86
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 18:30:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 411DF304064
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 16:30:26 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9LXQCKssd80oGvZm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 16:30:15 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1WGe0N-00079i-21
	for xfs@oss.sgi.com; Fri, 21 Feb 2014 00:30:15 +0000
Date: Thu, 20 Feb 2014 16:30:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs_io: add support for O_TMPFILE opens
Message-ID: <20140221003014.GA23416@infradead.org>
References: <20140220220000.GA17541@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140220220000.GA17541@infradead.org>
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
To: xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 02:00:00PM -0800, Christoph Hellwig wrote:
Add a new -T argument to the open command that supports using the
O_TMPFILE flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---

Changes from V1:
 - fix typo in the man page
 - add -T option to the main option parser
 - handle IO_TMPFILE in the file and stat commands

diff --git a/io/file.c b/io/file.c
index db85ffc..73b893f 100644
--- a/io/file.c
+++ b/io/file.c
@@ -36,7 +36,7 @@ print_fileio(
 	int		index,
 	int		braces)
 {
-	printf(_("%c%03d%c %-14s (%s,%s,%s,%s%s%s%s)\n"),
+	printf(_("%c%03d%c %-14s (%s,%s,%s,%s%s%s%s%s)\n"),
 		braces? '[' : ' ', index, braces? ']' : ' ', file->name,
 		file->flags & IO_FOREIGN ? _("foreign") : _("xfs"),
 		file->flags & IO_OSYNC ? _("sync") : _("non-sync"),
@@ -44,7 +44,8 @@ print_fileio(
 		file->flags & IO_READONLY ? _("read-only") : _("read-write"),
 		file->flags & IO_REALTIME ? _(",real-time") : "",
 		file->flags & IO_APPEND ? _(",append-only") : "",
-		file->flags & IO_NONBLOCK ? _(",non-block") : "");
+		file->flags & IO_NONBLOCK ? _(",non-block") : "",
+		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
 }
 
 int
diff --git a/io/init.c b/io/init.c
index ef9e4cb..fd1a52f 100644
--- a/io/init.c
+++ b/io/init.c
@@ -136,7 +136,7 @@ init(
 	pagesize = getpagesize();
 	gettimeofday(&stopwatch, NULL);
 
-	while ((c = getopt(argc, argv, "ac:dFfmp:nrRstVx")) != EOF) {
+	while ((c = getopt(argc, argv, "ac:dFfmp:nrRstTVx")) != EOF) {
 		switch (c) {
 		case 'a':
 			flags |= IO_APPEND;
@@ -179,6 +179,8 @@ init(
 		case 'R':
 			flags |= IO_REALTIME;
 			break;
+		case 'T':
+			flags |= IO_TMPFILE;
 		case 'x':
 			expert = 1;
 			break;
diff --git a/io/io.h b/io/io.h
index 6c3f627..0d2d768 100644
--- a/io/io.h
+++ b/io/io.h
@@ -35,6 +35,7 @@
 #define IO_TRUNC	(1<<6)
 #define IO_FOREIGN	(1<<7)
 #define IO_NONBLOCK	(1<<8)
+#define IO_TMPFILE	(1<<9)
 
 /*
  * Regular file I/O control
diff --git a/io/open.c b/io/open.c
index cc677e6..6bb0d46 100644
--- a/io/open.c
+++ b/io/open.c
@@ -22,6 +22,22 @@
 #include "init.h"
 #include "io.h"
 
+#ifndef __O_TMPFILE
+#if defined __alpha__
+#define __O_TMPFILE	0100000000
+#elif defined(__hppa__)
+#define __O_TMPFILE	 040000000
+#elif defined(__sparc__)
+#define __O_TMPFILE	 0x2000000
+#else
+#define __O_TMPFILE	 020000000
+#endif
+#endif /* __O_TMPFILE */
+
+#ifndef O_TMPFILE
+#define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
+#endif
+
 static cmdinfo_t open_cmd;
 static cmdinfo_t stat_cmd;
 static cmdinfo_t close_cmd;
@@ -77,13 +93,14 @@ stat_f(
 	int		verbose = (argc == 2 && !strcmp(argv[1], "-v"));
 
 	printf(_("fd.path = \"%s\"\n"), file->name);
-	printf(_("fd.flags = %s,%s,%s%s%s%s\n"),
+	printf(_("fd.flags = %s,%s,%s%s%s%s%s\n"),
 		file->flags & IO_OSYNC ? _("sync") : _("non-sync"),
 		file->flags & IO_DIRECT ? _("direct") : _("non-direct"),
 		file->flags & IO_READONLY ? _("read-only") : _("read-write"),
 		file->flags & IO_REALTIME ? _(",real-time") : "",
 		file->flags & IO_APPEND ? _(",append-only") : "",
-		file->flags & IO_NONBLOCK ? _(",non-block") : "");
+		file->flags & IO_NONBLOCK ? _(",non-block") : "",
+		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
 	if (fstat64(file->fd, &st) < 0) {
 		perror("fstat64");
 	} else {
@@ -143,10 +160,13 @@ openfile(
 		oflags |= O_TRUNC;
 	if (flags & IO_NONBLOCK)
 		oflags |= O_NONBLOCK;
+	if (flags & IO_TMPFILE)
+		oflags |= O_TMPFILE;
 
 	fd = open(path, oflags, mode);
 	if (fd < 0) {
-		if ((errno == EISDIR) && (oflags & O_RDWR)) {
+		if (errno == EISDIR &&
+		    ((oflags & (O_RDWR|O_TMPFILE)) == O_RDWR)) {
 			/* make it as if we asked for O_RDONLY & try again */
 			oflags &= ~O_RDWR;
 			oflags |= O_RDONLY;
@@ -248,6 +268,7 @@ open_help(void)
 " -s -- open with O_SYNC\n"
 " -t -- open with O_TRUNC (truncate the file to zero length if it exists)\n"
 " -R -- mark the file as a realtime XFS file immediately after opening it\n"
+" -T -- open with O_TMPFILE (create a file not visible in the namespace)\n"
 " Note1: usually read/write direct IO requests must be blocksize aligned;\n"
 "        some kernels, however, allow sectorsize alignment for direct IO.\n"
 " Note2: the bmap for non-regular files can be obtained provided the file\n"
@@ -272,7 +293,7 @@ open_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "FRacdfm:nrstx")) != EOF) {
+	while ((c = getopt(argc, argv, "FRTacdfm:nrstx")) != EOF) {
 		switch (c) {
 		case 'F':
 			/* Ignored / deprecated now, handled automatically */
@@ -310,6 +331,9 @@ open_f(
 		case 'x':	/* backwards compatibility */
 			flags |= IO_REALTIME;
 			break;
+		case 'T':
+			flags |= IO_TMPFILE;
+			break;
 		default:
 			return command_usage(&open_cmd);
 		}
@@ -325,6 +349,11 @@ open_f(
 	if (!platform_test_xfs_fd(fd))
 		flags |= IO_FOREIGN;
 
+	if ((flags & (IO_READONLY|IO_TMPFILE)) == (IO_READONLY|IO_TMPFILE)) {
+		fprintf(stderr, _("-T and -r options are incompatible\n"));
+		return -1;
+	}
+
 	addfile(argv[optind], fd, &geometry, flags);
 	return 0;
 }
@@ -731,7 +760,7 @@ open_init(void)
 	open_cmd.argmin = 0;
 	open_cmd.argmax = -1;
 	open_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK;
-	open_cmd.args = _("[-acdrstx] [path]");
+	open_cmd.args = _("[-acdrstxT] [path]");
 	open_cmd.oneline = _("open the file specified by path");
 	open_cmd.help = open_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 9543b20..7a92ff6 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -4,7 +4,7 @@ xfs_io \- debug the I/O path of an XFS filesystem
 .SH SYNOPSIS
 .B xfs_io
 [
-.B \-adfmrRstx
+.B \-adfmrRstxT
 ] [
 .B \-c
 .I cmd
@@ -88,7 +88,7 @@ command for more details on any command.
 Display a list of all open files and (optionally) switch to an alternate
 current open file.
 .TP
-.BI "open [[ \-acdfrstR ] " path " ]"
+.BI "open [[ \-acdfrstRT ] " path " ]"
 Closes the current file, and opens the file specified by
 .I path
 instead. Without any arguments, displays statistics about the current
@@ -119,6 +119,14 @@ truncates on open (O_TRUNC).
 .B \-n
 opens in non-blocking mode if possible (O_NONBLOCK).
 .TP
+.B \-T
+create a temporary file not linked into the filesystem namespace
+(O_TMPFILE).  The pathname passed must refer to a directory which
+is treated as virtual parent for the newly created invisible file.
+Can not be used together with the
+.B \-r
+option.
+.TP
 .B \-R
 marks the file as a realtime XFS file after
 opening it, if it is not already marked as such.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
