Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56200 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727722AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/18] xfsprogs: include headers for extern variables
Date: Wed, 10 Oct 2018 15:01:09 -0500
Message-Id: <1539201682-22198-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Include headers which export functions for their matching C files so that
they don't appear to be static to the sparse checker.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 db/crc.c        | 1 +
 db/fuzz.c       | 1 +
 db/hash.c       | 1 +
 db/logformat.c  | 1 +
 db/symlink.c    | 2 +-
 db/text.c       | 1 +
 libfrog/crc32.c | 1 +
 7 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/db/crc.c b/db/crc.c
index b6612a5..95161c6 100644
--- a/db/crc.c
+++ b/db/crc.c
@@ -17,6 +17,7 @@
 #include "output.h"
 #include "bit.h"
 #include "print.h"
+#include "crc.h"
 
 static int crc_f(int argc, char **argv);
 static void crc_help(void);
diff --git a/db/fuzz.c b/db/fuzz.c
index 5d5d54f..65157bd 100644
--- a/db/fuzz.c
+++ b/db/fuzz.c
@@ -21,6 +21,7 @@
 #include "print.h"
 #include "write.h"
 #include "malloc.h"
+#include "fuzz.h"
 
 static int	fuzz_f(int argc, char **argv);
 static void     fuzz_help(void);
diff --git a/db/hash.c b/db/hash.c
index bda3316..68c53e7 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -10,6 +10,7 @@
 #include "type.h"
 #include "io.h"
 #include "output.h"
+#include "hash.h"
 
 static int hash_f(int argc, char **argv);
 static void hash_help(void);
diff --git a/db/logformat.c b/db/logformat.c
index 42ce245..3374c29 100644
--- a/db/logformat.c
+++ b/db/logformat.c
@@ -9,6 +9,7 @@
 #include "init.h"
 #include "output.h"
 #include "libxlog.h"
+#include "logformat.h"
 
 #define MAX_LSUNIT	256 * 1024	/* max log buf. size */
 
diff --git a/db/symlink.c b/db/symlink.c
index ebf6637..752cae4 100644
--- a/db/symlink.c
+++ b/db/symlink.c
@@ -11,7 +11,7 @@
 #include "field.h"
 #include "bit.h"
 #include "init.h"
-
+#include "symlink.h"
 
 /*
  * XXX: no idea how to handle multiple contiguous block symlinks here.
diff --git a/db/text.c b/db/text.c
index 3a279d1..adf33a7 100644
--- a/db/text.c
+++ b/db/text.c
@@ -17,6 +17,7 @@
 #include "io.h"
 #include "output.h"
 #include "init.h"
+#include "text.h"
 
 static void     print_rawtext(void *data, int len);
 
diff --git a/libfrog/crc32.c b/libfrog/crc32.c
index 1d52f68..e3f3fd1 100644
--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -33,6 +33,7 @@
 #include "xfs.h"
 #include "xfs_arch.h"
 #include "crc32defs.h"
+#include "crc32c.h"
 
 /* types specifc to this file */
 typedef __u8	u8;
-- 
1.8.3.1
