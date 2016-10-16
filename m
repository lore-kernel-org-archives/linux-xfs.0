Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33952 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752018AbcJPIzn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Oct 2016 04:55:43 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] xfs_io: add command line option -M to run as multi threaded process
Date: Sun, 16 Oct 2016 11:55:11 +0300
Message-Id: <1476608111-28948-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

xfs_io -M will start by spawning an idle thread.
The purpose of this idle thread is to test io from a multi threaded
process. With single threaded process, the file table is not shared
and file structs are not reference counted.

So in order to detect file struct reference leaks, spawning an idle
thread will do the trick.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/Makefile |  2 +-
 io/init.c   | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

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
index 6b88cc6..8a34ceb 100644
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
+int	multithreaded;
 size_t	pagesize;
 struct timeval stopwatch;
 
@@ -141,7 +143,7 @@ init(
 	pagesize = getpagesize();
 	gettimeofday(&stopwatch, NULL);
 
-	while ((c = getopt(argc, argv, "ac:dFfmp:nrRstTVx")) != EOF) {
+	while ((c = getopt(argc, argv, "ac:dFfmMp:nrRstTVx")) != EOF) {
 		switch (c) {
 		case 'a':
 			flags |= IO_APPEND;
@@ -166,6 +168,9 @@ init(
 				exit(1);
 			}
 			break;
+		case 'M':
+			multithreaded = 1;
+			break;
 		case 'n':
 			flags |= IO_NONBLOCK;
 			break;
@@ -213,12 +218,38 @@ init(
 	add_check_command(init_check_command);
 }
 
+/*
+ * The purpose of this idle thread is to test io from a multi threaded process.
+ * With single threaded process, the file table is not shared and file structs
+ * are not reference counted. So in order to detect file struct reference
+ * leaks, spawning an idle thread will do the trick.
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
+	if (multithreaded)
+		start_idle_thread();
 	command_loop();
 	return exitcode;
 }
-- 
2.7.4

