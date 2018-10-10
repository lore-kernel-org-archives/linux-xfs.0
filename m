Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56204 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/18] libxfs: silence static warnings about platform_* functions
Date: Wed, 10 Oct 2018 15:01:11 -0500
Message-Id: <1539201682-22198-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add all platform_* prototypes to init.h and include it in linux.c
to silence sparse warnings about static functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libfrog/linux.c | 1 +
 libxfs/init.h   | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index fc9f3ac..b6c2487 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -11,6 +11,7 @@
 
 #include "libxfs_priv.h"
 #include "xfs_fs.h"
+#include "init.h"
 
 extern char *progname;
 static int max_block_alignment;
diff --git a/libxfs/init.h b/libxfs/init.h
index e0b5091..2cda895 100644
--- a/libxfs/init.h
+++ b/libxfs/init.h
@@ -19,5 +19,7 @@ extern char *platform_findblockpath (char *path);
 extern int platform_direct_blockdev (void);
 extern int platform_align_blockdev (void);
 extern unsigned long platform_physmem(void);	/* in kilobytes */
+extern void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
+extern int platform_nproc(void);
 
 #endif	/* LIBXFS_INIT_H */
-- 
1.8.3.1
