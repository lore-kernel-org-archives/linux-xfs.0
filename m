Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55572 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfFTV3k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:40 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/11] xfs_repair: remove unneeded includes
Date: Thu, 20 Jun 2019 16:29:32 -0500
Message-Id: <1561066174-13144-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/agheader.c    | 1 -
 repair/attr_repair.c | 4 ----
 repair/btree.c       | 1 -
 repair/da_util.c     | 1 -
 repair/dino_chunks.c | 5 -----
 repair/dinode.c      | 7 -------
 repair/dir2.c        | 5 -----
 repair/incore.c      | 5 -----
 repair/incore_bmc.c  | 5 -----
 repair/incore_ext.c  | 5 -----
 repair/incore_ino.c  | 5 -----
 repair/init.c        | 6 ------
 repair/phase1.c      | 2 --
 repair/phase2.c      | 3 ---
 repair/phase3.c      | 4 ----
 repair/phase4.c      | 5 -----
 repair/phase5.c      | 6 ------
 repair/phase6.c      | 5 -----
 repair/phase7.c      | 6 ------
 repair/prefetch.c    | 9 ---------
 repair/progress.c    | 1 -
 repair/rmap.c        | 2 --
 repair/rt.c          | 6 ------
 repair/sb.c          | 1 -
 repair/scan.c        | 3 ---
 repair/slab.c        | 1 -
 repair/threads.c     | 3 ---
 repair/versions.c    | 2 --
 repair/xfs_repair.c  | 5 -----
 29 files changed, 114 deletions(-)

diff --git a/repair/agheader.c b/repair/agheader.c
index 218ee25..069a024 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
 #include "globals.h"
 #include "agheader.h"
 #include "protos.h"
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 9a44f61..b7dff78 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -4,14 +4,10 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
 #include "globals.h"
 #include "err_protos.h"
 #include "attr_repair.h"
-#include "dinode.h"
 #include "bmap.h"
-#include "protos.h"
-#include "dir2.h"
 #include "da_util.h"
 
 static int xfs_acl_valid(struct xfs_mount *mp, struct xfs_acl *daclp);
diff --git a/repair/btree.c b/repair/btree.c
index 292fa51..fb288b4 100644
--- a/repair/btree.c
+++ b/repair/btree.c
@@ -5,7 +5,6 @@
  */
 
 #include "libxfs.h"
-#include "btree.h"
 
 /*
  * Maximum number of keys per node.  Must be greater than 2 for the code
diff --git a/repair/da_util.c b/repair/da_util.c
index 8c818ea..b0769d0 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -6,7 +6,6 @@
 
 /* Various utilities for repair of directory and attribute metadata */
 
-#include "libxfs.h"
 #include "globals.h"
 #include "err_protos.h"
 #include "bmap.h"
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 3b1890b..e521dc1 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -4,12 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "globals.h"
-#include "agheader.h"
-#include "incore.h"
-#include "protos.h"
 #include "err_protos.h"
 #include "dinode.h"
 #include "versions.h"
diff --git a/repair/dinode.c b/repair/dinode.c
index c0a56da..769446e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -4,20 +4,13 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "globals.h"
-#include "agheader.h"
 #include "incore.h"
-#include "protos.h"
 #include "err_protos.h"
 #include "dir2.h"
-#include "dinode.h"
 #include "scan.h"
-#include "versions.h"
 #include "attr_repair.h"
 #include "bmap.h"
-#include "threads.h"
 #include "slab.h"
 #include "rmap.h"
 
diff --git a/repair/dir2.c b/repair/dir2.c
index 4ac0084..3fe5600 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -4,17 +4,12 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "globals.h"
 #include "incore.h"
 #include "err_protos.h"
 #include "dinode.h"
-#include "dir2.h"
 #include "bmap.h"
 #include "da_util.h"
-#include "prefetch.h"
-#include "progress.h"
 
 /*
  * Known bad inode list.  These are seen when the leaf and node
diff --git a/repair/incore.c b/repair/incore.c
index 1374dde..d3599cf 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -4,15 +4,10 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "btree.h"
 #include "globals.h"
 #include "incore.h"
-#include "agheader.h"
-#include "protos.h"
 #include "err_protos.h"
-#include "threads.h"
 
 /*
  * The following manages the in-core bitmap of the entire filesystem
diff --git a/repair/incore_bmc.c b/repair/incore_bmc.c
index 97be15e..917d35c 100644
--- a/repair/incore_bmc.c
+++ b/repair/incore_bmc.c
@@ -5,12 +5,7 @@
  */
 
 #include "libxfs.h"
-#include "avl.h"
-#include "globals.h"
 #include "incore.h"
-#include "agheader.h"
-#include "protos.h"
-#include "err_protos.h"
 
 void
 init_bm_cursor(bmap_cursor_t *cursor, int num_levels)
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index e7ef9eb..918c4ba 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -4,16 +4,11 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "btree.h"
 #include "globals.h"
 #include "incore.h"
-#include "agheader.h"
-#include "protos.h"
 #include "err_protos.h"
 #include "avl64.h"
-#include "threads.h"
 
 /*
  * note:  there are 4 sets of incore things handled here:
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 82956ae..e75d001 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -4,13 +4,8 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "globals.h"
 #include "incore.h"
-#include "agheader.h"
-#include "protos.h"
-#include "threads.h"
 #include "err_protos.h"
 
 /*
diff --git a/repair/init.c b/repair/init.c
index 55f226e..60d4884 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -4,15 +4,9 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
 #include "globals.h"
-#include "agheader.h"
-#include "protos.h"
 #include "err_protos.h"
-#include "pthread.h"
-#include "avl.h"
 #include "bmap.h"
-#include "incore.h"
 #include "prefetch.h"
 #include <sys/resource.h>
 
diff --git a/repair/phase1.c b/repair/phase1.c
index 00b9858..847bdca 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -4,9 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
 #include "globals.h"
-#include "agheader.h"
 #include "protos.h"
 #include "err_protos.h"
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 4bd6c63..0f3bfb2 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -6,10 +6,7 @@
 
 #include "libxfs.h"
 #include "libxlog.h"
-#include "avl.h"
 #include "globals.h"
-#include "agheader.h"
-#include "protos.h"
 #include "err_protos.h"
 #include "incore.h"
 #include "progress.h"
diff --git a/repair/phase3.c b/repair/phase3.c
index 161852e..a4c1b78 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -7,11 +7,7 @@
 #include "libxfs.h"
 #include "threads.h"
 #include "prefetch.h"
-#include "avl.h"
 #include "globals.h"
-#include "agheader.h"
-#include "incore.h"
-#include "protos.h"
 #include "err_protos.h"
 #include "dinode.h"
 #include "progress.h"
diff --git a/repair/phase4.c b/repair/phase4.c
index 66e69db..c148950 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -7,16 +7,11 @@
 #include "libxfs.h"
 #include "threads.h"
 #include "prefetch.h"
-#include "avl.h"
 #include "globals.h"
-#include "agheader.h"
-#include "incore.h"
-#include "protos.h"
 #include "err_protos.h"
 #include "dinode.h"
 #include "bmap.h"
 #include "versions.h"
-#include "dir2.h"
 #include "progress.h"
 #include "slab.h"
 #include "rmap.h"
diff --git a/repair/phase5.c b/repair/phase5.c
index 0f6a839..8e5e3a8 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -4,17 +4,11 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "globals.h"
-#include "agheader.h"
 #include "incore.h"
-#include "protos.h"
 #include "err_protos.h"
-#include "dinode.h"
 #include "rt.h"
 #include "versions.h"
-#include "threads.h"
 #include "progress.h"
 #include "slab.h"
 #include "rmap.h"
diff --git a/repair/phase6.c b/repair/phase6.c
index 28e633d..b4b57db 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -7,15 +7,10 @@
 #include "libxfs.h"
 #include "threads.h"
 #include "prefetch.h"
-#include "avl.h"
 #include "globals.h"
-#include "agheader.h"
-#include "incore.h"
 #include "dir2.h"
-#include "protos.h"
 #include "err_protos.h"
 #include "dinode.h"
-#include "progress.h"
 #include "versions.h"
 
 static struct cred		zerocr;
diff --git a/repair/phase7.c b/repair/phase7.c
index c299647..9197555 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -4,15 +4,9 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "globals.h"
-#include "agheader.h"
 #include "incore.h"
-#include "protos.h"
 #include "err_protos.h"
-#include "dinode.h"
-#include "versions.h"
 #include "progress.h"
 #include "threads.h"
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 1de0e2f..e61f75f 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -1,21 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include "libxfs.h"
 #include <pthread.h>
-#include "avl.h"
 #include "btree.h"
 #include "globals.h"
-#include "agheader.h"
-#include "incore.h"
-#include "dir2.h"
-#include "protos.h"
 #include "err_protos.h"
 #include "dinode.h"
-#include "bmap.h"
-#include "versions.h"
 #include "threads.h"
 #include "prefetch.h"
-#include "progress.h"
 
 int do_prefetch = 1;
 
diff --git a/repair/progress.c b/repair/progress.c
index 5ee0822..b826d4c 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include "libxfs.h"
 #include "globals.h"
 #include "progress.h"
 #include "err_protos.h"
diff --git a/repair/rmap.c b/repair/rmap.c
index 47828a0..8a7757e 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -4,9 +4,7 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include <libxfs.h>
-#include "btree.h"
 #include "err_protos.h"
-#include "libxlog.h"
 #include "incore.h"
 #include "globals.h"
 #include "dinode.h"
diff --git a/repair/rt.c b/repair/rt.c
index 7108e3d..8f8982c 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -4,15 +4,9 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "globals.h"
-#include "agheader.h"
 #include "incore.h"
-#include "dinode.h"
-#include "protos.h"
 #include "err_protos.h"
-#include "rt.h"
 
 #define xfs_highbit64 libxfs_highbit64	/* for XFS_RTBLOCKLOG macro */
 
diff --git a/repair/sb.c b/repair/sb.c
index 119bf21..7d44c3b 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "libfrog.h"
-#include "libxfs.h"
 #include "libxcmd.h"
 #include "libxlog.h"
 #include "agheader.h"
diff --git a/repair/scan.c b/repair/scan.c
index 0290856..efb5a15 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -4,15 +4,12 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-#include "avl.h"
 #include "globals.h"
 #include "agheader.h"
 #include "incore.h"
 #include "protos.h"
 #include "err_protos.h"
 #include "dinode.h"
-#include "scan.h"
 #include "versions.h"
 #include "bmap.h"
 #include "progress.h"
diff --git a/repair/slab.c b/repair/slab.c
index ba5c232..78a7b93 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -4,7 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include <libxfs.h>
-#include "slab.h"
 
 #undef SLAB_DEBUG
 
diff --git a/repair/threads.c b/repair/threads.c
index d219092..3851a2b 100644
--- a/repair/threads.c
+++ b/repair/threads.c
@@ -1,12 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include "libxfs.h"
-#include <pthread.h>
 #include <signal.h>
 #include "threads.h"
 #include "err_protos.h"
-#include "protos.h"
-#include "globals.h"
 
 void
 thread_init(void)
diff --git a/repair/versions.c b/repair/versions.c
index 4c44b4e..34574e6 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -4,11 +4,9 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
 
 #include "err_protos.h"
 #include "globals.h"
-#include "versions.h"
 
 /*
  * filesystem feature global vars, set to 1 if the feature
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9657503..3b65682 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -8,16 +8,11 @@
 #include "libxlog.h"
 #include <sys/resource.h>
 #include "xfs_multidisk.h"
-#include "avl.h"
-#include "avl64.h"
 #include "globals.h"
 #include "versions.h"
-#include "agheader.h"
 #include "protos.h"
-#include "incore.h"
 #include "err_protos.h"
 #include "prefetch.h"
-#include "threads.h"
 #include "progress.h"
 #include "dinode.h"
 #include "slab.h"
-- 
1.8.3.1
