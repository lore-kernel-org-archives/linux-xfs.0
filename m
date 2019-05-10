Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36098 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfEJUSn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:43 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 08/11] libxfs: create new file inode_item.c
Date: Fri, 10 May 2019 15:18:27 -0500
Message-Id: <1557519510-10602-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Pull functions out of libxfs/* into inode_item.c, if they roughly match
the kernel's xfs_inode_item.c file.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/Makefile      |   2 +-
 libxfs/inode_item.c  | 117 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h |   3 ++
 libxfs/logitem.c     |  43 -------------------
 libxfs/trans.c       |  75 ---------------------------------
 5 files changed, 121 insertions(+), 119 deletions(-)
 create mode 100644 libxfs/inode_item.c
 delete mode 100644 libxfs/logitem.c

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 820ffb0..fe58ce9 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -55,8 +55,8 @@ CFILES = cache.c \
 	buf_item.c \
 	defer_item.c \
 	init.c \
+	inode_item.c \
 	kmem.c \
-	logitem.c \
 	rdwr.c \
 	trans.c \
 	trans_buf.c \
diff --git a/libxfs/inode_item.c b/libxfs/inode_item.c
new file mode 100644
index 0000000..4e9b1af
--- /dev/null
+++ b/libxfs/inode_item.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode_fork.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+
+kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
+
+/*
+ * Initialize the inode log item for a newly allocated (in-core) inode.
+ */
+void
+xfs_inode_item_init(
+	xfs_inode_t		*ip,
+	xfs_mount_t		*mp)
+{
+	xfs_inode_log_item_t	*iip;
+
+	ASSERT(ip->i_itemp == NULL);
+	iip = ip->i_itemp = (xfs_inode_log_item_t *)
+			kmem_zone_zalloc(xfs_ili_zone, KM_SLEEP);
+#ifdef LI_DEBUG
+	fprintf(stderr, "inode_item_init for inode %llu, iip=%p\n",
+		ip->i_ino, iip);
+#endif
+
+	iip->ili_item.li_type = XFS_LI_INODE;
+	iip->ili_item.li_mountp = mp;
+	INIT_LIST_HEAD(&iip->ili_item.li_trans);
+	iip->ili_inode = ip;
+}
+
+static void
+xfs_inode_item_put(
+	struct xfs_inode_log_item	*iip)
+{
+	struct xfs_inode		*ip = iip->ili_inode;
+
+	ip->i_itemp = NULL;
+	kmem_zone_free(xfs_ili_zone, iip);
+}
+
+/*
+ * Transaction commital code follows (i.e. write to disk in libxfs)
+ *
+ * XXX (dgc): should failure to flush the inode (e.g. due to uncorrected
+ * corruption) result in transaction commit failure w/ EFSCORRUPTED?
+ */
+void
+inode_item_done(
+	xfs_inode_log_item_t	*iip)
+{
+	xfs_dinode_t		*dip;
+	xfs_inode_t		*ip;
+	xfs_mount_t		*mp;
+	xfs_buf_t		*bp;
+	int			error;
+
+	ip = iip->ili_inode;
+	mp = iip->ili_item.li_mountp;
+	ASSERT(ip != NULL);
+
+	if (!(iip->ili_fields & XFS_ILOG_ALL))
+		goto free;
+
+	/*
+	 * Get the buffer containing the on-disk inode.
+	 */
+	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, 0, 0);
+	if (error) {
+		fprintf(stderr, _("%s: warning - imap_to_bp failed (%d)\n"),
+			progname, error);
+		goto free;
+	}
+
+	/*
+	 * Flush the inode and disassociate it from the transaction regardless
+	 * of whether the flush succeed or not. If we fail the flush, make sure
+	 * we still release the buffer reference we currently hold.
+	 */
+	error = libxfs_iflush_int(ip, bp);
+	bp->b_transp = NULL;	/* remove xact ptr */
+
+	if (error) {
+		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
+			progname, error);
+		libxfs_putbuf(bp);
+		goto free;
+	}
+
+	libxfs_writebuf(bp, 0);
+#ifdef XACT_DEBUG
+	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
+			ip->i_ino, bp);
+#endif
+free:
+	xfs_inode_item_put(iip);
+}
+
+void
+inode_item_unlock(
+	xfs_inode_log_item_t    *iip)
+{
+	xfs_inode_item_put(iip);
+}
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 155b782..cf808d3 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -491,6 +491,7 @@ struct xfs_log_item;
 struct xfs_buf;
 struct xfs_buf_map;
 struct xfs_buf_log_item;
+struct xfs_inode_log_item;
 struct xfs_buftarg;
 
 /* xfs_attr.c */
@@ -515,6 +516,8 @@ void xfs_trans_del_item(struct xfs_log_item *);
 
 /* xfs_inode_item.c */
 void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
+void inode_item_done(struct xfs_inode_log_item *iip);
+void inode_item_unlock(struct xfs_inode_log_item *iip);
 
 /* xfs_buf_item.c */
 void xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
deleted file mode 100644
index c80e2ed..0000000
--- a/libxfs/logitem.c
+++ /dev/null
@@ -1,43 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-#include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_inode_buf.h"
-#include "xfs_inode_fork.h"
-#include "xfs_inode.h"
-#include "xfs_trans.h"
-
-kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
-
-/*
- * Initialize the inode log item for a newly allocated (in-core) inode.
- */
-void
-xfs_inode_item_init(
-	xfs_inode_t		*ip,
-	xfs_mount_t		*mp)
-{
-	xfs_inode_log_item_t	*iip;
-
-	ASSERT(ip->i_itemp == NULL);
-	iip = ip->i_itemp = (xfs_inode_log_item_t *)
-			kmem_zone_zalloc(xfs_ili_zone, KM_SLEEP);
-#ifdef LI_DEBUG
-	fprintf(stderr, "inode_item_init for inode %llu, iip=%p\n",
-		ip->i_ino, iip);
-#endif
-
-	iip->ili_item.li_type = XFS_LI_INODE;
-	iip->ili_item.li_mountp = mp;
-	INIT_LIST_HEAD(&iip->ili_item.li_trans);
-	iip->ili_inode = ip;
-}
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 7d3899c..b062e07 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -470,74 +470,6 @@ _("Transaction block reservation exceeded! %u > %u\n"),
 }
 
 static void
-xfs_inode_item_put(
-	struct xfs_inode_log_item	*iip)
-{
-	struct xfs_inode		*ip = iip->ili_inode;
-
-	ip->i_itemp = NULL;
-	kmem_zone_free(xfs_ili_zone, iip);
-}
-
-
-/*
- * Transaction commital code follows (i.e. write to disk in libxfs)
- *
- * XXX (dgc): should failure to flush the inode (e.g. due to uncorrected
- * corruption) result in transaction commit failure w/ EFSCORRUPTED?
- */
-static void
-inode_item_done(
-	xfs_inode_log_item_t	*iip)
-{
-	xfs_dinode_t		*dip;
-	xfs_inode_t		*ip;
-	xfs_mount_t		*mp;
-	xfs_buf_t		*bp;
-	int			error;
-
-	ip = iip->ili_inode;
-	mp = iip->ili_item.li_mountp;
-	ASSERT(ip != NULL);
-
-	if (!(iip->ili_fields & XFS_ILOG_ALL))
-		goto free;
-
-	/*
-	 * Get the buffer containing the on-disk inode.
-	 */
-	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, 0, 0);
-	if (error) {
-		fprintf(stderr, _("%s: warning - imap_to_bp failed (%d)\n"),
-			progname, error);
-		goto free;
-	}
-
-	/*
-	 * Flush the inode and disassociate it from the transaction regardless
-	 * of whether the flush succeed or not. If we fail the flush, make sure
-	 * we still release the buffer reference we currently hold.
-	 */
-	error = libxfs_iflush_int(ip, bp);
-	bp->b_transp = NULL;	/* remove xact ptr */
-
-	if (error) {
-		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
-			progname, error);
-		libxfs_putbuf(bp);
-		goto free;
-	}
-
-	libxfs_writebuf(bp, 0);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
-			ip->i_ino, bp);
-#endif
-free:
-	xfs_inode_item_put(iip);
-}
-
-static void
 trans_committed(
 	xfs_trans_t		*tp)
 {
@@ -558,13 +490,6 @@ trans_committed(
 	}
 }
 
-static void
-inode_item_unlock(
-	xfs_inode_log_item_t	*iip)
-{
-	xfs_inode_item_put(iip);
-}
-
 /* Detach and unlock all of the items in a transaction */
 static void
 xfs_trans_free_items(
-- 
1.8.3.1
