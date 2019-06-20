Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55574 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfFTV3k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:40 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/11] xfs_scrub: remove unneeded includes
Date: Thu, 20 Jun 2019 16:29:33 -0500
Message-Id: <1561066174-13144-11-git-send-email-sandeen@redhat.com>
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 scrub/common.c      | 1 -
 scrub/counter.c     | 5 -----
 scrub/disk.c        | 2 --
 scrub/filemap.c     | 4 ----
 scrub/fscounters.c  | 2 --
 scrub/inodes.c      | 3 ---
 scrub/phase1.c      | 8 --------
 scrub/phase2.c      | 2 --
 scrub/phase3.c      | 3 ---
 scrub/phase4.c      | 2 --
 scrub/phase5.c      | 3 ---
 scrub/phase6.c      | 3 ---
 scrub/phase7.c      | 2 --
 scrub/progress.c    | 4 ----
 scrub/read_verify.c | 1 -
 scrub/repair.c      | 2 --
 scrub/scrub.c       | 3 ---
 scrub/spacemap.c    | 2 --
 scrub/unicrash.c    | 4 ----
 scrub/vfs.c         | 2 --
 scrub/xfs_scrub.c   | 4 ----
 21 files changed, 62 deletions(-)

diff --git a/scrub/common.c b/scrub/common.c
index 1cd2b7b..6f6137e 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -7,7 +7,6 @@
 #include <pthread.h>
 #include <sys/statvfs.h>
 #include <syslog.h>
-#include "platform_defs.h"
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/counter.c b/scrub/counter.c
index 4800e75..60094ec 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -4,13 +4,8 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <stdlib.h>
-#include <string.h>
-#include <assert.h>
-#include <pthread.h>
 #include "ptvar.h"
-#include "counter.h"
 
 /*
  * Per-Thread Counters
diff --git a/scrub/disk.c b/scrub/disk.c
index dd10953..cf1dd21 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -4,7 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <fcntl.h>
@@ -16,7 +15,6 @@
 #ifdef HAVE_HDIO_GETGEO
 # include <linux/hdreg.h>
 #endif
-#include "platform_defs.h"
 #include "libfrog.h"
 #include "path.h"
 #include "xfs_scrub.h"
diff --git a/scrub/filemap.c b/scrub/filemap.c
index dc8f488..601ccbb 100644
--- a/scrub/filemap.c
+++ b/scrub/filemap.c
@@ -4,11 +4,7 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <string.h>
-#include <sys/types.h>
 #include <sys/statvfs.h>
 #include "path.h"
 #include "xfs_scrub.h"
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 9e93e2a..d3b8fc1 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -4,7 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
 #include "platform_defs.h"
@@ -14,7 +13,6 @@
 #include "workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
-#include "fscounters.h"
 
 /*
  * Filesystem counter collection routines.  We can count the number of
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 442a597..bfa2c84 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -4,9 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
-#include <stdlib.h>
-#include <pthread.h>
 #include <sys/statvfs.h>
 #include "platform_defs.h"
 #include "xfs_arch.h"
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 04a5f4a..94d02c9 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -6,20 +6,12 @@
 #include "xfs.h"
 #include <unistd.h>
 #include <sys/types.h>
-#include <sys/time.h>
-#include <sys/resource.h>
 #include <sys/statvfs.h>
 #include <fcntl.h>
-#include <dirent.h>
-#include <stdint.h>
-#include <pthread.h>
 #include "libfrog.h"
-#include "workqueue.h"
-#include "input.h"
 #include "path.h"
 #include "handle.h"
 #include "bitops.h"
-#include "avl64.h"
 #include "list.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 653f666..a647f03 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -4,8 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
-#include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
 #include "path.h"
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 4963d67..250e848 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -4,12 +4,9 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
-#include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
 #include "path.h"
-#include "workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "counter.h"
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 7924832..b70d170 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -4,9 +4,7 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <dirent.h>
-#include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
 #include "path.h"
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 1743119..e9a5c8e 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -4,18 +4,15 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <dirent.h>
 #include <sys/types.h>
 #include <sys/statvfs.h>
 #ifdef HAVE_LIBATTR
 # include <attr/attributes.h>
 #endif
-#include <linux/fs.h>
 #include "handle.h"
 #include "list.h"
 #include "path.h"
-#include "workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 66e6451..fe35971 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -4,12 +4,9 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <dirent.h>
 #include <sys/statvfs.h>
-#include "handle.h"
 #include "path.h"
-#include "workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "bitmap.h"
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 0c3202e..ec891e6 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -4,8 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
-#include <stdlib.h>
 #include <sys/statvfs.h>
 #include "path.h"
 #include "ptvar.h"
diff --git a/scrub/progress.c b/scrub/progress.c
index d0afe90..06e0d8e 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -4,15 +4,11 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <dirent.h>
 #include <pthread.h>
 #include <sys/statvfs.h>
 #include <time.h>
 #include "path.h"
-#include "disk.h"
-#include "read_verify.h"
 #include "xfs_scrub.h"
-#include "common.h"
 #include "counter.h"
 #include "progress.h"
 
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 4a9b91f..c3c9f98 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -4,7 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
 #include "ptvar.h"
diff --git a/scrub/repair.c b/scrub/repair.c
index 4ed3c09..56c2f42 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -4,9 +4,7 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <stdlib.h>
-#include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
 #include "path.h"
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 0f0c963..1a16631 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -4,11 +4,8 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <stdlib.h>
-#include <unistd.h>
 #include <string.h>
-#include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
 #include "path.h"
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index d547a04..730f380 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -4,9 +4,7 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <string.h>
-#include <pthread.h>
 #include <sys/statvfs.h>
 #include "workqueue.h"
 #include "path.h"
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 824b10f..f3cc9f9 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -4,19 +4,15 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <stdlib.h>
 #include <dirent.h>
-#include <sys/types.h>
 #include <sys/statvfs.h>
-#include <strings.h>
 #include <unicode/ustring.h>
 #include <unicode/unorm2.h>
 #include <unicode/uspoof.h>
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
-#include "unicrash.h"
 
 /*
  * Detect Unicode confusable names in directories and attributes.
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 8bcc4e7..ef3cece 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -4,11 +4,9 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <dirent.h>
 #include <sys/types.h>
 #include <sys/statvfs.h>
-#include "handle.h"
 #include "path.h"
 #include "workqueue.h"
 #include "xfs_scrub.h"
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 71fc274..a35cf1f 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -3,19 +3,15 @@
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
 #include <pthread.h>
 #include <stdlib.h>
-#include <paths.h>
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <sys/statvfs.h>
-#include "platform_defs.h"
 #include "input.h"
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
-#include "unicrash.h"
 #include "progress.h"
 
 /*
-- 
1.8.3.1
