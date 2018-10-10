Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56212 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/18] xfsprogs: misc static function warning fixes
Date: Wed, 10 Oct 2018 15:01:15 -0500
Message-Id: <1539201682-22198-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The last handful of static symbol warning cleanups for misc remaining
issues.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/init.h     | 1 +
 libxfs/rdwr.c     | 2 --
 repair/phase2.c   | 2 --
 repair/scan.h     | 2 ++
 scrub/xfs_scrub.h | 2 ++
 5 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/libxfs/init.h b/libxfs/init.h
index 2cda895..b23e493 100644
--- a/libxfs/init.h
+++ b/libxfs/init.h
@@ -7,6 +7,7 @@
 #define LIBXFS_INIT_H
 
 struct stat;
+extern int     use_xfs_buf_lock;
 
 extern int platform_check_ismounted (char *path, char *block,
 					struct stat *sptr, int verbose);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index e580aba..a00360e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -712,8 +712,6 @@ struct list_head	lock_buf_list = {&lock_buf_list, &lock_buf_list};
 int			lock_buf_count = 0;
 #endif
 
-extern int     use_xfs_buf_lock;
-
 static struct xfs_buf *
 __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 {
diff --git a/repair/phase2.c b/repair/phase2.c
index b92ceb8..4bd6c63 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -15,8 +15,6 @@
 #include "progress.h"
 #include "scan.h"
 
-void	set_mp(xfs_mount_t *mpp);
-
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(struct xlog *log, xlog_recover_t *t, int p)
 {
diff --git a/repair/scan.h b/repair/scan.h
index aa7c38d..bf1ee83 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -8,6 +8,8 @@
 
 struct blkmap;
 
+void set_mp(xfs_mount_t *mpp);
+
 int scan_lbtree(
 	xfs_fsblock_t	root,
 	int		nlevels,
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 8b80c79..a961d8f 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -6,6 +6,8 @@
 #ifndef XFS_SCRUB_XFS_SCRUB_H_
 #define XFS_SCRUB_XFS_SCRUB_H_
 
+extern char *progname;
+
 #define _PATH_PROC_MOUNTS	"/proc/mounts"
 
 extern unsigned int		nr_threads;
-- 
1.8.3.1
