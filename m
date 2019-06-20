Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55556 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfFTV3j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:39 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/11] libfrog: remove unneeded includes
Date: Thu, 20 Jun 2019 16:29:27 -0500
Message-Id: <1561066174-13144-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libfrog/avl64.c      | 1 -
 libfrog/bitmap.c     | 2 --
 libfrog/convert.c    | 2 --
 libfrog/crc32.c      | 1 -
 libfrog/fsgeom.c     | 1 -
 libfrog/linux.c      | 4 ----
 libfrog/list_sort.c  | 1 -
 libfrog/paths.c      | 4 ----
 libfrog/projects.c   | 1 -
 libfrog/ptvar.c      | 3 ---
 libfrog/radix-tree.c | 3 ---
 libfrog/topology.c   | 1 -
 libfrog/util.c       | 1 -
 libfrog/workqueue.c  | 1 -
 14 files changed, 26 deletions(-)

diff --git a/libfrog/avl64.c b/libfrog/avl64.c
index 2547bf3..2147b35 100644
--- a/libfrog/avl64.c
+++ b/libfrog/avl64.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include <stdint.h>
 #include <stdio.h>
 #include "platform_defs.h"
 #include "avl64.h"
diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 4dafc4c..5a4a1f7 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -4,11 +4,9 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include <stdint.h>
 #include <stdlib.h>
 #include <assert.h>
 #include <pthread.h>
-#include "platform_defs.h"
 #include "avl64.h"
 #include "list.h"
 #include "bitmap.h"
diff --git a/libfrog/convert.c b/libfrog/convert.c
index ed4cae7..f97c62a 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -3,10 +3,8 @@
  * Copyright (c) 2003-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "platform_defs.h"
 #include "input.h"
 #include <ctype.h>
-#include <stdbool.h>
 
 size_t
 numlen(
diff --git a/libfrog/crc32.c b/libfrog/crc32.c
index 526ce95..b4c18c7 100644
--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -36,7 +36,6 @@
 /* For endian conversion routines */
 #include "xfs_arch.h"
 #include "crc32defs.h"
-#include "crc32c.h"
 
 /* types specifc to this file */
 typedef __u8	u8;
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 8879d16..9a2aee7 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc. All Rights Reserved.
  */
 #include "libxfs.h"
-#include "fsgeom.h"
 
 void
 xfs_report_geom(
diff --git a/libfrog/linux.c b/libfrog/linux.c
index b6c2487..5fc7c6a 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -4,14 +4,10 @@
  * All Rights Reserved.
  */
 
-#include <mntent.h>
 #include <sys/stat.h>
-#include <sys/ioctl.h>
 #include <sys/sysinfo.h>
 
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "init.h"
 
 extern char *progname;
 static int max_block_alignment;
diff --git a/libfrog/list_sort.c b/libfrog/list_sort.c
index b77eece..e017b8c 100644
--- a/libfrog/list_sort.c
+++ b/libfrog/list_sort.c
@@ -1,5 +1,4 @@
 /* List sorting code from Linux::lib/list_sort.c. */
-#include <stdlib.h>
 #include <string.h>
 #include "list.h"
 
diff --git a/libfrog/paths.c b/libfrog/paths.c
index 6e26665..7cda1f8 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -4,8 +4,6 @@
  * All Rights Reserved.
  */
 
-#include <paths.h>
-#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -14,8 +12,6 @@
 #include <sys/stat.h>
 #include "path.h"
 #include "input.h"
-#include "project.h"
-#include <limits.h>
 
 extern char *progname;
 
diff --git a/libfrog/projects.c b/libfrog/projects.c
index 91bc78f..ec28c04 100644
--- a/libfrog/projects.c
+++ b/libfrog/projects.c
@@ -5,7 +5,6 @@
  */
 
 #include <stdio.h>
-#include <stdlib.h>
 #include <string.h>
 #include "project.h"
 
diff --git a/libfrog/ptvar.c b/libfrog/ptvar.c
index c929683..c8393cc 100644
--- a/libfrog/ptvar.c
+++ b/libfrog/ptvar.c
@@ -3,14 +3,11 @@
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include <stdint.h>
 #include <stdlib.h>
 #include <stdbool.h>
 #include <string.h>
 #include <assert.h>
 #include <pthread.h>
-#include <unistd.h>
-#include "platform_defs.h"
 #include "ptvar.h"
 
 /*
diff --git a/libfrog/radix-tree.c b/libfrog/radix-tree.c
index c1c7487..de7c588 100644
--- a/libfrog/radix-tree.c
+++ b/libfrog/radix-tree.c
@@ -5,9 +5,6 @@
  * Copyright (C) 2005 SGI, Christoph Lameter <clameter@sgi.com>
  */
 #include <stdlib.h>
-#include <string.h>
-#include <errno.h>
-#include <stdint.h>
 #include "platform_defs.h"
 #include "radix-tree.h"
 
diff --git a/libfrog/topology.c b/libfrog/topology.c
index cac164f..b675641 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
 #include "libxcmd.h"
 #ifdef ENABLE_BLKID
 #  include <blkid/blkid.h>
diff --git a/libfrog/util.c b/libfrog/util.c
index ff93518..a3971aa 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "platform_defs.h"
-#include "libfrog.h"
 
 /*
  * libfrog is a collection of miscellaneous userspace utilities.
diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 7311477..965ac31 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -4,7 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include <pthread.h>
-#include <signal.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdint.h>
-- 
1.8.3.1
