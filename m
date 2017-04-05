Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932212AbdDEMtX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 08:49:23 -0400
Subject: [PATCH 1/4] xfstests: Add an auxiliary program to create an AF_UNIX
 socket [ver #6]
From: David Howells <dhowells@redhat.com>
Date: Wed, 05 Apr 2017 13:49:19 +0100
Message-ID: <149139655968.12368.18434671350530288572.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org

Add an auxiliary program to create an AF_UNIX socket at the specified
location so that tests can do things with it.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---

 .gitignore    |    1 +
 src/Makefile  |    2 +-
 src/af_unix.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 1 deletion(-)
 create mode 100644 src/af_unix.c

diff --git a/.gitignore b/.gitignore
index 1ed2a92..8a7c052 100644
--- a/.gitignore
+++ b/.gitignore
@@ -35,6 +35,7 @@
 /ltp/iogen
 
 # src/ binaries
+/src/af_unix
 /src/alloc
 /src/append_reader
 /src/append_writer
diff --git a/src/Makefile b/src/Makefile
index a7f27f0..716c178 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -12,7 +12,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
-	holetest t_truncate_self t_mmap_dio
+	holetest t_truncate_self t_mmap_dio af_unix
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/af_unix.c b/src/af_unix.c
new file mode 100644
index 0000000..dc2368e
--- /dev/null
+++ b/src/af_unix.c
@@ -0,0 +1,66 @@
+/* Create an AF_UNIX socket.
+ *
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+
+#define offsetof(TYPE, MEMBER)	((size_t)&((TYPE *)0)->MEMBER)
+
+int main(int argc, char *argv[])
+{
+	struct sockaddr_un sun;
+	struct stat st;
+	size_t len, max;
+	int fd;
+
+	if (argc != 2) {
+		fprintf(stderr, "Format: %s <socketpath>\n", argv[0]);
+		exit(2);
+	}
+
+	max = sizeof(sun.sun_path);
+	len = strlen(argv[1]);
+	if (len >= max) {
+		fprintf(stderr, "Filename too long (max %zu)\n", max);
+		exit(2);
+	}
+
+	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		perror("socket");
+		exit(1);
+	}
+
+	memset(&sun, 0, sizeof(sun));
+	sun.sun_family = AF_UNIX;
+	strcpy(sun.sun_path, argv[1]);
+	if (bind(fd, (struct sockaddr *)&sun, sizeof(sun)) == -1) {
+		perror("bind");
+		exit(1);
+	}
+
+	if (stat(argv[1], &st)) {
+		fprintf(stderr, "Couldn't stat socket after creation: %m\n");
+		exit(1);
+	}
+
+	exit(0);
+}

