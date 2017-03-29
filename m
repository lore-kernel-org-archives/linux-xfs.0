Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932470AbdC2Vwi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 17:52:38 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <29183.1490711359@warthog.procyon.org.uk>
References: <29183.1490711359@warthog.procyon.org.uk>
Subject: [PATCH] xfs_io: Allow -P and -L to be given to open for O_PATH and O_NOFOLLOW
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <858.1490824354.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 29 Mar 2017 22:52:34 +0100
Message-ID: <859.1490824354@warthog.procyon.org.uk>
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

Signed-off-by: David Howells <dhowells@redhat.com>
---
 io/io.h           |    2 ++
 io/open.c         |   22 ++++++++++++++++++++--
 man/man8/xfs_io.8 |   12 +++++++++++-
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/io/io.h b/io/io.h
index 952bdb8..4399419 100644
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
index 2ed55cf..f7f508a 100644
--- a/io/open.c
+++ b/io/open.c
@@ -72,6 +72,10 @@ openfile(
 		oflags |= O_NONBLOCK;
 	if (flags & IO_TMPFILE)
 		oflags |= O_TMPFILE;
+	if (flags & IO_PATH)
+		oflags |= O_PATH;
+	if (flags & IO_NOFOLLOW)
+		oflags |= O_NOFOLLOW;
 
 	fd = open(path, oflags, mode);
 	if (fd < 0) {
@@ -179,6 +183,8 @@ open_help(void)
 " -t -- open with O_TRUNC (truncate the file to zero length if it exists)\n"
 " -R -- mark the file as a realtime XFS file immediately after opening it\n"
 " -T -- open with O_TMPFILE (create a file not visible in the namespace)\n"
+" -P -- open with O_PATH (create an fd that is merely a location reference)\n"
+" -L -- open with O_NOFOLLOW (don't follow symlink)\n"
 " Note1: usually read/write direct IO requests must be blocksize aligned;\n"
 "        some kernels, however, allow sectorsize alignment for direct IO.\n"
 " Note2: the bmap for non-regular files can be obtained provided the file\n"
@@ -203,7 +209,7 @@ open_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "FRTacdfm:nrstx")) != EOF) {
+	while ((c = getopt(argc, argv, "FLPRTacdfm:nrstx")) != EOF) {
 		switch (c) {
 		case 'F':
 			/* Ignored / deprecated now, handled automatically */
@@ -244,6 +250,12 @@ open_f(
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
@@ -257,6 +269,12 @@ open_f(
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
@@ -772,7 +790,7 @@ open_init(void)
 	open_cmd.argmax = -1;
 	open_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK |
 			 CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
-	open_cmd.args = _("[-acdrstxT] [-m mode] [path]");
+	open_cmd.args = _("[-acdrstxRTPL] [-m mode] [path]");
 	open_cmd.oneline = _("open the file specified by path");
 	open_cmd.help = open_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 022f0ea..e77be40 100644
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
