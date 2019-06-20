Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55554 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbfFTV3j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:39 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/11] xfs_io: remove unneeded includes
Date: Thu, 20 Jun 2019 16:29:26 -0500
Message-Id: <1561066174-13144-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/bmap.c            | 1 -
 io/copy_file_range.c | 2 --
 io/cowextsize.c      | 1 -
 io/encrypt.c         | 1 -
 io/fiemap.c          | 1 -
 io/file.c            | 1 -
 io/fsmap.c           | 1 -
 io/getrusage.c       | 1 -
 io/init.c            | 2 --
 io/label.c           | 3 ---
 io/log_writes.c      | 1 -
 io/mmap.c            | 1 -
 io/parent.c          | 1 -
 io/reflink.c         | 2 --
 io/scrub.c           | 3 ---
 io/stat.c            | 2 --
 16 files changed, 24 deletions(-)

diff --git a/io/bmap.c b/io/bmap.c
index d408826..a0dd77f 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index d069e5b..576a58d 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -4,8 +4,6 @@
  */
 
 #include <sys/syscall.h>
-#include <sys/uio.h>
-#include <xfs/xfs.h>
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/cowextsize.c b/io/cowextsize.c
index 029605a..bbec335 100644
--- a/io/cowextsize.c
+++ b/io/cowextsize.c
@@ -14,7 +14,6 @@
 #include "init.h"
 #include "io.h"
 #include "input.h"
-#include "path.h"
 
 static cmdinfo_t cowextsize_cmd;
 static long cowextsize;
diff --git a/io/encrypt.c b/io/encrypt.c
index 8db3525..4c2ba87 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -7,7 +7,6 @@
 #include "platform_defs.h"
 #include "command.h"
 #include "init.h"
-#include "path.h"
 #include "io.h"
 
 #ifndef ARRAY_SIZE
diff --git a/io/fiemap.c b/io/fiemap.c
index 485bae1..3bda112 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
 #include "command.h"
 #include "input.h"
 #include <linux/fiemap.h>
diff --git a/io/file.c b/io/file.c
index c45486e..0ccf803 100644
--- a/io/file.c
+++ b/io/file.c
@@ -6,7 +6,6 @@
 
 #include "command.h"
 #include "input.h"
-#include <sys/mman.h>
 #include "init.h"
 #include "io.h"
 
diff --git a/io/fsmap.c b/io/fsmap.c
index 477c36f..906d60f 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -6,7 +6,6 @@
 #include "platform_defs.h"
 #include "command.h"
 #include "init.h"
-#include "path.h"
 #include "io.h"
 #include "input.h"
 
diff --git a/io/getrusage.c b/io/getrusage.c
index 6962913..ba704b7 100644
--- a/io/getrusage.c
+++ b/io/getrusage.c
@@ -9,7 +9,6 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include "init.h"
-#include "io.h"
 
 static cmdinfo_t getrusage_cmd;
 
diff --git a/io/init.c b/io/init.c
index 7025aea..4354c64 100644
--- a/io/init.c
+++ b/io/init.c
@@ -5,9 +5,7 @@
  */
 
 #include <pthread.h>
-#include "platform_defs.h"
 #include "command.h"
-#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/label.c b/io/label.c
index 72e0796..5180743 100644
--- a/io/label.c
+++ b/io/label.c
@@ -3,10 +3,7 @@
  * Copyright (c) 2018 Red Hat, Inc. All Rights Reserved.
  */
 
-#include <sys/ioctl.h>
 #include "platform_defs.h"
-#include "libxfs.h"
-#include "path.h"
 #include "command.h"
 #include "init.h"
 #include "io.h"
diff --git a/io/log_writes.c b/io/log_writes.c
index 9c2285f..114f818 100644
--- a/io/log_writes.c
+++ b/io/log_writes.c
@@ -8,7 +8,6 @@
 #include <libdevmapper.h>
 #include "command.h"
 #include "init.h"
-#include "io.h"
 
 static cmdinfo_t log_writes_cmd;
 
diff --git a/io/mmap.c b/io/mmap.c
index f9383e5..55b253f 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -7,7 +7,6 @@
 #include "command.h"
 #include "input.h"
 #include <sys/mman.h>
-#include <signal.h>
 #include "init.h"
 #include "io.h"
 
diff --git a/io/parent.c b/io/parent.c
index ffa55f6..3db75d6 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -6,7 +6,6 @@
 
 #include "command.h"
 #include "input.h"
-#include "path.h"
 #include "parent.h"
 #include "handle.h"
 #include "jdm.h"
diff --git a/io/reflink.c b/io/reflink.c
index 26eb2e3..815597b 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -4,8 +4,6 @@
  * All Rights Reserved.
  */
 
-#include <sys/uio.h>
-#include <xfs/xfs.h>
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/scrub.c b/io/scrub.c
index 2ff1a6a..449e39f 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -5,11 +5,8 @@
  */
 
 #include <sys/uio.h>
-#include <xfs/xfs.h>
 #include "command.h"
-#include "input.h"
 #include "init.h"
-#include "path.h"
 #include "io.h"
 
 static struct cmdinfo scrub_cmd;
diff --git a/io/stat.c b/io/stat.c
index 37c0b2e..fe51aed 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -11,9 +11,7 @@
 #include "init.h"
 #include "io.h"
 #include "statx.h"
-#include "libxfs.h"
 
-#include <fcntl.h>
 
 static cmdinfo_t stat_cmd;
 static cmdinfo_t statfs_cmd;
-- 
1.8.3.1
