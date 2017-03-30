Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932318AbdC3Jwu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 05:52:50 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] xfs_io: Allow -P and -L to be given to open for O_PATH and O_NOFOLLOW [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14285.1490867566.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Mar 2017 10:52:46 +0100
Message-ID: <14286.1490867566@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: dhowells@redhat.com, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

    
Allow "open -P" to specify O_PATH so that paths which would otherwise be
unopenable might be opened for stat()'ing.  Such things include files that
would incur an access error or device files for which no corresponding
driver is available.

Allow "-L" to be given in conjunction with O_PATH to specify O_NOFOLLOW
also.

We also have to avoid calling xfsctl() if O_PATH is given as ioctls are
forbidden on such fds.  This means we cannot retrieve the geometry
information on an XFS filesystem, so the record gets cleared instead.  For
the moment, only the xfsctl() calls in the 'open' command are
conditionalised.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 io/io.h           |    2 ++
 io/open.c         |   29 +++++++++++++++++++++++++----
 man/man8/xfs_io.8 |   12 +++++++++++-
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/io/io.h b/io/io.h
index c40aad0..15934d8 100644
--- a/io/io.h
+++ b/io/io.h
@@ -38,6 +38,8 @@
 #define IO_FOREIGN	(1<<7)
 #define IO_NONBLOCK	(1<<8)
 #define IO_TMPFILE	(1<<9)
+#define IO_PATH		(1<<10)
+#define IO_NOFOLLOW	(1<<11)
 
 /*
  * Regular file I/O control
diff --git a/io/open.c b/io/open.c
index 941fdc1..5488bf9 100644
--- a/io/open.c
+++ b/io/open.c
@@ -164,6 +164,10 @@ openfile(
 		oflags |= O_NONBLOCK;
 	if (flags & IO_TMPFILE)
 		oflags |= O_TMPFILE;
+	if (flags & IO_PATH)
+		oflags |= O_PATH;
+	if (flags & IO_NOFOLLOW)
+		oflags |= O_NOFOLLOW;
 
 	fd = open(path, oflags, mode);
 	if (fd < 0) {
@@ -187,13 +191,16 @@ openfile(
 	if (!geom || !platform_test_xfs_fd(fd))
 		return fd;
 
-	if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
+	if (flags & IO_PATH) {
+		/* Can't call ioctl() on O_PATH fds */
+		memset(geom, 0, sizeof(*geom));
+	} else if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
 		perror("XFS_IOC_FSGEOMETRY");
 		close(fd);
 		return -1;
 	}
 
-	if (!(flags & IO_READONLY) && (flags & IO_REALTIME)) {
+	if (!(flags & (IO_READONLY | IO_PATH)) && (flags & IO_REALTIME)) {
 		struct fsxattr	attr;
 
 		if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &attr) < 0) {
@@ -271,6 +278,8 @@ open_help(void)
 " -t -- open with O_TRUNC (truncate the file to zero length if it exists)\n"
 " -R -- mark the file as a realtime XFS file immediately after opening it\n"
 " -T -- open with O_TMPFILE (create a file not visible in the namespace)\n"
+" -P -- open with O_PATH (create an fd that is merely a location reference)\n"
+" -L -- open with O_NOFOLLOW (don't follow symlink)\n"
 " Note1: usually read/write direct IO requests must be blocksize aligned;\n"
 "        some kernels, however, allow sectorsize alignment for direct IO.\n"
 " Note2: the bmap for non-regular files can be obtained provided the file\n"
@@ -295,7 +304,7 @@ open_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "FRTacdfm:nrstx")) != EOF) {
+	while ((c = getopt(argc, argv, "FLPRTacdfm:nrstx")) != EOF) {
 		switch (c) {
 		case 'F':
 			/* Ignored / deprecated now, handled automatically */
@@ -336,6 +345,12 @@ open_f(
 		case 'T':
 			flags |= IO_TMPFILE;
 			break;
+		case 'P':
+			flags |= IO_PATH;
+			break;
+		case 'L':
+			flags |= IO_NOFOLLOW;
+			break;
 		default:
 			return command_usage(&open_cmd);
 		}
@@ -349,6 +364,12 @@ open_f(
 		return -1;
 	}
 
+	if ((flags & (IO_PATH|IO_NOFOLLOW)) &&
+	    (flags & ~(IO_PATH|IO_NOFOLLOW))) {
+		fprintf(stderr, _("-P and -L are incompatible with the other options\n"));
+		return -1;
+	}
+
 	fd = openfile(argv[optind], &geometry, flags, mode);
 	if (fd < 0)
 		return 0;
@@ -916,7 +937,7 @@ open_init(void)
 	open_cmd.argmax = -1;
 	open_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK |
 			 CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
-	open_cmd.args = _("[-acdrstxT] [-m mode] [path]");
+	open_cmd.args = _("[-acdrstxRTPL] [-m mode] [path]");
 	open_cmd.oneline = _("open the file specified by path");
 	open_cmd.help = open_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 19e1ae4..f9bd648 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -122,7 +122,7 @@ command for more details on any command.
 Display a list of all open files and (optionally) switch to an alternate
 current open file.
 .TP
-.BI "open [[ \-acdfrstRT ] " path " ]"
+.BI "open [[ \-acdfrstRTPL ] " path " ]"
 Closes the current file, and opens the file specified by
 .I path
 instead. Without any arguments, displays statistics about the current
@@ -164,6 +164,16 @@ option.
 .B \-R
 marks the file as a realtime XFS file after
 opening it, if it is not already marked as such.
+.TP
+.B \-P
+opens the path as a referent only (O_PATH).  This is incompatible with other
+flags specifying other O_xxx flags apart from
+.BR \-L .
+.TP
+.B \-L
+doesn't follow symlinks (O_NOFOLLOW).  This is incompatible with other
+flags specifying other O_xxx flags apart from
+.BR \-P .
 .PD
 .RE
 .TP
