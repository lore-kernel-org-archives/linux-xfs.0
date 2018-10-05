Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48104 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbeJELAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 09/15] xfsprogs: remove write-only variables
Date: Thu,  4 Oct 2018 23:03:10 -0500
Message-Id: <1538712196-13625-10-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 copy/xfs_copy.c | 3 ---
 libfrog/linux.c | 1 -
 libxfs/init.h   | 1 -
 3 files changed, 5 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 1d04780..5fbc0f3 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -39,7 +39,6 @@ target_control	*target;
 wbuf		w_buf;
 wbuf		btree_buf;
 
-pid_t		parent_pid;
 unsigned int	kids;
 
 thread_control	glob_masks;
@@ -631,8 +630,6 @@ main(int argc, char **argv)
 		target[i].err_type = 0;
 	}
 
-	parent_pid = getpid();
-
 	/* open up source -- is it a file? */
 
 	open_flags = O_RDONLY;
diff --git a/libfrog/linux.c b/libfrog/linux.c
index 46f15d6..fc9f3ac 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -12,7 +12,6 @@
 #include "libxfs_priv.h"
 #include "xfs_fs.h"
 
-int platform_has_uuid = 1;
 extern char *progname;
 static int max_block_alignment;
 
diff --git a/libxfs/init.h b/libxfs/init.h
index 2c3cd91..e0b5091 100644
--- a/libxfs/init.h
+++ b/libxfs/init.h
@@ -19,6 +19,5 @@ extern char *platform_findblockpath (char *path);
 extern int platform_direct_blockdev (void);
 extern int platform_align_blockdev (void);
 extern unsigned long platform_physmem(void);	/* in kilobytes */
-extern int platform_has_uuid;
 
 #endif	/* LIBXFS_INIT_H */
-- 
1.8.3.1
