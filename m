Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:42163 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936219AbeEYPQV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 11:16:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] xfs, proc: hide unused xfs procfs helpers
Date: Fri, 25 May 2018 17:16:04 +0200
Message-Id: <20180525151612.2408651-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

These two functions now trigger a warning when CONFIG_PROC_FS is disabled:

fs/xfs/xfs_stats.c:128:12: error: 'xqmstat_proc_show' defined but not used [-Werror=unused-function]
 static int xqmstat_proc_show(struct seq_file *m, void *v)
            ^~~~~~~~~~~~~~~~~
fs/xfs/xfs_stats.c:118:12: error: 'xqm_proc_show' defined but not used [-Werror=unused-function]
 static int xqm_proc_show(struct seq_file *m, void *v)
            ^~~~~~~~~~~~~

Previously, they were referenced from an unused 'static const' structure,
which is silently dropped by gcc.

We can address the warning by adding the same #ifdef around them that
hides the reference.

Fixes: 3f3942aca6da ("proc: introduce proc_create_single{,_data}")
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
The warning was caused by a patch in Al's VFS tree, so the fix
needs to go through the same one.
---
 fs/xfs/xfs_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 04762a72e344..1cc79907b377 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -113,6 +113,7 @@ void xfs_stats_clearall(struct xfsstats __percpu *stats)
 	}
 }
 
+#ifdef CONFIG_PROC_FS
 /* legacy quota interfaces */
 #ifdef CONFIG_XFS_QUOTA
 static int xqm_proc_show(struct seq_file *m, void *v)
@@ -137,7 +138,6 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
 }
 #endif /* CONFIG_XFS_QUOTA */
 
-#ifdef CONFIG_PROC_FS
 int
 xfs_init_procfs(void)
 {
-- 
2.9.0

