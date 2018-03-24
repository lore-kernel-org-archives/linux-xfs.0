Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:57060 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753070AbeCXVKF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 24 Mar 2018 17:10:05 -0400
From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] xfs_scrub: fix build with older kernel headers
Date: Sun, 25 Mar 2018 00:08:17 +0300
Message-Id: <7ea1df02d0f2549b6249c8bee1f6ae02bf1251a9.1521925697.git.baruch@tkos.co.il>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>, "Darrick J . Wong" <darrick.wong@oracle.com>

The OVERRIDE_SYSTEM_FSXATTR macro in include/linux.h is meant to
override the linux/fs.h kernel header provided struct fsxattr for
kernels older than v4.7. A few source files include linux/fs.h before
the local linux.h, making this override ineffective. Remove these header
includes from the source files, and rely on the linux.h include alone.

This fixes the following build failures:

In file included from ../include/xfs.h:37:0,
                 from disk.c:40:
../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
 struct fsxattr {
        ^~~~~~~

In file included from ../include/xfs.h:37:0,
                 from ../include/project.h:22,
                 from ../include/input.h:24,
                 from phase1.c:38:
../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
 struct fsxattr {
        ^~~~~~~

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 scrub/disk.c   | 1 -
 scrub/phase1.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/scrub/disk.c b/scrub/disk.c
index e12175c8656c..54d7a2a77c45 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -28,7 +28,6 @@
 #include <sys/ioctl.h>
 #include <sys/statvfs.h>
 #include <sys/vfs.h>
-#include <linux/fs.h>
 #ifdef HAVE_SG_IO
 # include <scsi/sg.h>
 #endif
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6cd544233c94..d15689e1b544 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -32,7 +32,6 @@
 #include <stdbool.h>
 #include <pthread.h>
 #include <errno.h>
-#include <linux/fs.h>
 #include "libfrog.h"
 #include "workqueue.h"
 #include "input.h"
-- 
2.16.2

