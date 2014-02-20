Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AFC067F85
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 16:00:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C664AC00D
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 14:00:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 1FCYdSAfzt4TtmwI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 14:00:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1WGbey-0004ZG-Fd
	for xfs@oss.sgi.com; Thu, 20 Feb 2014 22:00:00 +0000
Date: Thu, 20 Feb 2014 14:00:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs_io: add support for O_TMPFILE opens
Message-ID: <20140220220000.GA17541@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

Add a new -T argument to the open command that supports using the
O_TMPFILE flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>

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
index cc677e6..c97968e 100644
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
@@ -143,10 +159,13 @@ openfile(
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
@@ -248,6 +267,7 @@ open_help(void)
 " -s -- open with O_SYNC\n"
 " -t -- open with O_TRUNC (truncate the file to zero length if it exists)\n"
 " -R -- mark the file as a realtime XFS file immediately after opening it\n"
+" -T -- open with O_TMPFILE (create a file not visible in the namespace)\n"
 " Note1: usually read/write direct IO requests must be blocksize aligned;\n"
 "        some kernels, however, allow sectorsize alignment for direct IO.\n"
 " Note2: the bmap for non-regular files can be obtained provided the file\n"
@@ -272,7 +292,7 @@ open_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "FRacdfm:nrstx")) != EOF) {
+	while ((c = getopt(argc, argv, "FRTacdfm:nrstx")) != EOF) {
 		switch (c) {
 		case 'F':
 			/* Ignored / deprecated now, handled automatically */
@@ -310,6 +330,9 @@ open_f(
 		case 'x':	/* backwards compatibility */
 			flags |= IO_REALTIME;
 			break;
+		case 'T':
+			flags |= IO_TMPFILE;
+			break;
 		default:
 			return command_usage(&open_cmd);
 		}
@@ -325,6 +348,11 @@ open_f(
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
@@ -731,7 +759,7 @@ open_init(void)
 	open_cmd.argmin = 0;
 	open_cmd.argmax = -1;
 	open_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK;
-	open_cmd.args = _("[-acdrstx] [path]");
+	open_cmd.args = _("[-acdrstxT] [path]");
 	open_cmd.oneline = _("open the file specified by path");
 	open_cmd.help = open_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 9543b20..124360d 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
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
+create a temporary file not linked into the filesystem namepspace
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
