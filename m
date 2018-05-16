Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbeEPN1k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 May 2018 09:27:40 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE94E20834
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 13:27:39 +0000 (UTC)
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 1/2] xfs_io: add the ability to do an O_PATH open
Date: Wed, 16 May 2018 09:27:37 -0400
Message-Id: <20180516132738.27776-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 io/file.c         | 3 ++-
 io/init.c         | 5 ++++-
 io/io.h           | 1 +
 io/open.c         | 7 ++++++-
 io/stat.c         | 4 +++-
 man/man8/xfs_io.8 | 3 +++
 6 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/io/file.c b/io/file.c
index 349b19cdc420..ff80652b183b 100644
--- a/io/file.c
+++ b/io/file.c
@@ -44,7 +44,8 @@ print_fileio(
 		file->flags & IO_REALTIME ? _(",real-time") : "",
 		file->flags & IO_APPEND ? _(",append-only") : "",
 		file->flags & IO_NONBLOCK ? _(",non-block") : "",
-		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
+		file->flags & IO_TMPFILE ? _(",tmpfile") : "",
+		file->flags & IO_PATH ? _(",path") : "");
 }
 
 int
diff --git a/io/init.c b/io/init.c
index 0336c9623beb..d4e84e82a77e 100644
--- a/io/init.c
+++ b/io/init.c
@@ -154,7 +154,7 @@ init(
 	gettimeofday(&stopwatch, NULL);
 
 	fs_table_initialise(0, NULL, 0, NULL);
-	while ((c = getopt(argc, argv, "ac:C:dFfim:p:nrRstTVx")) != EOF) {
+	while ((c = getopt(argc, argv, "ac:C:dFfim:Pp:nrRstTVx")) != EOF) {
 		switch (c) {
 		case 'a':
 			flags |= IO_APPEND;
@@ -200,6 +200,9 @@ init(
 		case 't':
 			flags |= IO_TRUNC;
 			break;
+		case 'P':
+			flags |= IO_PATH;
+			break;
 		case 'R':
 			flags |= IO_REALTIME;
 			break;
diff --git a/io/io.h b/io/io.h
index a26763610877..0acc332b5dbb 100644
--- a/io/io.h
+++ b/io/io.h
@@ -40,6 +40,7 @@
 #define IO_FOREIGN	(1<<7)
 #define IO_NONBLOCK	(1<<8)
 #define IO_TMPFILE	(1<<9)
+#define IO_PATH		(1<<10)
 
 /*
  * Regular file I/O control
diff --git a/io/open.c b/io/open.c
index 2cce0455263a..ba73f1d0361f 100644
--- a/io/open.c
+++ b/io/open.c
@@ -74,6 +74,8 @@ openfile(
 		oflags |= O_NONBLOCK;
 	if (flags & IO_TMPFILE)
 		oflags |= O_TMPFILE;
+	if (flags & IO_PATH)
+		oflags |= O_PATH;
 
 	fd = open(path, oflags, mode);
 	if (fd < 0) {
@@ -216,7 +218,7 @@ open_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "FRTacdfm:nrstx")) != EOF) {
+	while ((c = getopt(argc, argv, "FRTacdfm:nPrstx")) != EOF) {
 		switch (c) {
 		case 'F':
 			/* Ignored / deprecated now, handled automatically */
@@ -250,6 +252,9 @@ open_f(
 		case 't':
 			flags |= IO_TRUNC;
 			break;
+		case 'P':
+			flags |= IO_PATH;
+			break;
 		case 'R':
 		case 'x':	/* backwards compatibility */
 			flags |= IO_REALTIME;
diff --git a/io/stat.c b/io/stat.c
index 41d421525791..2db2736359e0 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -100,7 +100,9 @@ void print_file_info(void)
 		file->flags & IO_REALTIME ? _(",real-time") : "",
 		file->flags & IO_APPEND ? _(",append-only") : "",
 		file->flags & IO_NONBLOCK ? _(",non-block") : "",
-		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
+		file->flags & IO_TMPFILE ? _(",tmpfile") : "",
+		file->flags & IO_PATH ? _(",path") : "");
+
 }
 
 void print_xfs_info(int verbose)
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index c3ab532da03f..89e8e4be460e 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -153,6 +153,9 @@ truncates on open (O_TRUNC).
 .B \-n
 opens in non-blocking mode if possible (O_NONBLOCK).
 .TP
+.B \-P
+opens the file for location only (O_PATH).
+.TP
 .B \-T
 create a temporary file not linked into the filesystem namespace
 (O_TMPFILE).  The pathname passed must refer to a directory which
-- 
2.17.0

