Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34667 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756546AbcJQHV6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 03:21:58 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] xfs_io: add command line option -i to start an idle thread
Date: Mon, 17 Oct 2016 10:20:51 +0300
Message-Id: <1476688851-32647-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

xfs_io -i will start by spawning an idle thread.

The purpose of this idle thread is to test io from a multi threaded
process. With single threaded process, the file table is not shared
and file structs are not reference counted. Spawning an idle thread
can help detecting file struct reference leaks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/Makefile       |  2 +-
 io/init.c         | 35 +++++++++++++++++++++++++++++++++--
 man/man8/xfs_io.8 |  8 +++++++-
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/io/Makefile b/io/Makefile
index 1997ca9..032a8c7 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -13,7 +13,7 @@ CFILES = init.c \
 	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
 	sync.c truncate.c reflink.c
 
-LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
+LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/io/init.c b/io/init.c
index 6b88cc6..2db48a2 100644
--- a/io/init.c
+++ b/io/init.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <pthread.h>
 #include "platform_defs.h"
 #include "command.h"
 #include "input.h"
@@ -25,6 +26,7 @@
 char	*progname;
 int	exitcode;
 int	expert;
+int	idlethread;
 size_t	pagesize;
 struct timeval stopwatch;
 
@@ -32,7 +34,7 @@ void
 usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-adfmnrRstVx] [-p prog] [-c cmd]... file\n"),
+		_("Usage: %s [-adfimnrRstTVx] [-p prog] [-c cmd]... file\n"),
 		progname);
 	exit(1);
 }
@@ -141,7 +143,7 @@ init(
 	pagesize = getpagesize();
 	gettimeofday(&stopwatch, NULL);
 
-	while ((c = getopt(argc, argv, "ac:dFfmp:nrRstTVx")) != EOF) {
+	while ((c = getopt(argc, argv, "ac:dFfimp:nrRstTVx")) != EOF) {
 		switch (c) {
 		case 'a':
 			flags |= IO_APPEND;
@@ -158,6 +160,9 @@ init(
 		case 'f':
 			flags |= IO_CREAT;
 			break;
+		case 'i':
+			idlethread = 1;
+			break;
 		case 'm':
 			mode = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
@@ -213,12 +218,38 @@ init(
 	add_check_command(init_check_command);
 }
 
+/*
+ * The purpose of this idle thread is to test io from a multi threaded process.
+ * With single threaded process, the file table is not shared and file structs
+ * are not reference counted. Spawning an idle thread can help detecting file
+ * struct reference leaks.
+ */
+void *
+idle_loop(void *arg)
+{
+	for (;;)
+		pause();
+}
+
+void
+start_idle_thread()
+{
+	pthread_t t;
+
+	if (pthread_create(&t, NULL, idle_loop, NULL)) {
+		fprintf(stderr, "Error creating idle thread\n");
+		exit(1);
+	}
+}
+
 int
 main(
 	int	argc,
 	char	**argv)
 {
 	init(argc, argv);
+	if (idlethread)
+		start_idle_thread();
 	command_loop();
 	return exitcode;
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index eb7b878..885df7f 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -4,7 +4,7 @@ xfs_io \- debug the I/O path of an XFS filesystem
 .SH SYNOPSIS
 .B xfs_io
 [
-.B \-adfmrRstxT
+.B \-adfimrRstxT
 ] [
 .B \-c
 .I cmd
@@ -51,6 +51,12 @@ read-only, initially. This is required if
 .I file
 is immutable or append-only.
 .TP
+.B \-i
+Start an idle thread. The purpose of this idle thread is to test io
+from a multi threaded process. With single threaded process,
+the file table is not shared and file structs are not reference counted.
+Spawning an idle thread can help detecting file struct reference leaks.
+.TP
 .B \-x
 Expert mode. Dangerous commands are only available in this mode.
 These commands also tend to require additional privileges.
-- 
2.7.4

