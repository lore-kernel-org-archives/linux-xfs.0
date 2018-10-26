Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbeJ0A4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 20:56:07 -0400
Date: Fri, 26 Oct 2018 09:18:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: check all defer ops types
Message-ID: <20181026161824.GG28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we have all the defer ops types loaded before proceeding.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |   12 ++++++++++++
 fs/xfs/libxfs/xfs_defer.h |    1 +
 fs/xfs/xfs_super.c        |    6 ++++++
 3 files changed, 19 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e792b167150a..997a7420026b 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -547,3 +547,15 @@ xfs_defer_move(
 
 	xfs_defer_reset(stp);
 }
+
+/* Make sure we filled out all the defer_ops types. */
+bool
+xfs_defer_check_all_present(void)
+{
+	int		x;
+
+	for(x = 0; x < XFS_DEFER_OPS_TYPE_MAX; x++)
+		if (defer_op_types[x] == NULL)
+			return false;
+	return true;
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 2584a5b95b0d..bc7ae7ff3917 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -57,5 +57,6 @@ struct xfs_defer_op_type {
 };
 
 void xfs_defer_init_op_type(const struct xfs_defer_op_type *type);
+bool xfs_defer_check_all_present(void);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 52ee659f97e2..49d1045fe71e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -38,6 +38,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
+#include "xfs_defer.h"
 
 #include <linux/namei.h>
 #include <linux/dax.h>
@@ -2220,6 +2221,11 @@ init_xfs_fs(void)
 	xfs_rmap_update_init_defer_op();
 	xfs_refcount_update_init_defer_op();
 	xfs_bmap_update_init_defer_op();
+	if (!xfs_defer_check_all_present()) {
+		printk(KERN_ERR "XFS: missing defer ops types\n");
+		error = -EINVAL;
+		goto out;
+	}
 
 	xfs_dir_startup();
 
