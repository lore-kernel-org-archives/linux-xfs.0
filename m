Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbeJ0A4x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 20:56:53 -0400
Date: Fri, 26 Oct 2018 09:19:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: check all defer ops types
Message-ID: <20181026161905.GH28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we have all the defer ops types loaded before proceeding.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c      |    5 +++++
 libxfs/xfs_defer.c |   12 ++++++++++++
 libxfs/xfs_defer.h |    1 +
 3 files changed, 18 insertions(+)

diff --git a/libxfs/init.c b/libxfs/init.c
index 750b8f20..d1fdc3a8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -253,6 +253,11 @@ libxfs_init(libxfs_init_t *a)
 	xfs_rmap_update_init_defer_op();
 	xfs_refcount_update_init_defer_op();
 	xfs_bmap_update_init_defer_op();
+	if (!xfs_defer_check_all_present()) {
+		fprintf(stderr, _("%s: defer ops not all there\n"),
+			progname);
+		goto done;
+	}
 
 	radix_tree_init();
 
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 5a6da0f3..cd3a8ef3 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -545,3 +545,15 @@ xfs_defer_move(
 
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
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 2584a5b9..bc7ae7ff 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -57,5 +57,6 @@ struct xfs_defer_op_type {
 };
 
 void xfs_defer_init_op_type(const struct xfs_defer_op_type *type);
+bool xfs_defer_check_all_present(void);
 
 #endif /* __XFS_DEFER_H__ */
