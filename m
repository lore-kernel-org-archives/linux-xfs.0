Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbfEJUSn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:43 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/11] libxfs: create new file trans_inode.c
Date: Fri, 10 May 2019 15:18:28 -0500
Message-Id: <1557519510-10602-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Pull functions out of libxfs/trans.c into trans_inode.c, if they roughly
match the kernel's xfs_trans_inode.c file.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/Makefile      |   1 +
 libxfs/trans.c       |  86 -----------------------------------------
 libxfs/trans_inode.c | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+), 86 deletions(-)
 create mode 100644 libxfs/trans_inode.c

diff --git a/libxfs/Makefile b/libxfs/Makefile
index fe58ce9..82544d2 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -60,6 +60,7 @@ CFILES = cache.c \
 	rdwr.c \
 	trans.c \
 	trans_buf.c \
+	trans_inode.c \
 	util.c \
 	xfs_ag.c \
 	xfs_ag_resv.c \
diff --git a/libxfs/trans.c b/libxfs/trans.c
index b062e07..f199d15 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -336,92 +336,6 @@ out:
 	return;
 }
 
-void
-xfs_trans_ijoin(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip,
-	uint			lock_flags)
-{
-	xfs_inode_log_item_t	*iip;
-
-	if (ip->i_itemp == NULL)
-		xfs_inode_item_init(ip, ip->i_mount);
-	iip = ip->i_itemp;
-	ASSERT(iip->ili_inode != NULL);
-
-	ASSERT(iip->ili_lock_flags == 0);
-	iip->ili_lock_flags = lock_flags;
-
-	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
-
-#ifdef XACT_DEBUG
-	fprintf(stderr, "ijoin'd inode %llu, transaction %p\n", ip->i_ino, tp);
-#endif
-}
-
-void
-xfs_trans_ijoin_ref(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip,
-	int			lock_flags)
-{
-	ASSERT(ip->i_itemp != NULL);
-
-	xfs_trans_ijoin(tp, ip, lock_flags);
-
-#ifdef XACT_DEBUG
-	fprintf(stderr, "ijoin_ref'd inode %llu, transaction %p\n", ip->i_ino, tp);
-#endif
-}
-
-/*
- * This is called to mark the fields indicated in fieldmask as needing
- * to be logged when the transaction is committed.  The inode must
- * already be associated with the given transaction.
- *
- * The values for fieldmask are defined in xfs_log_format.h.  We always
- * log all of the core inode if any of it has changed, and we always log
- * all of the inline data/extents/b-tree root if any of them has changed.
- */
-void
-xfs_trans_log_inode(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip,
-	uint			flags)
-{
-	ASSERT(ip->i_itemp != NULL);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "dirtied inode %llu, transaction %p\n", ip->i_ino, tp);
-#endif
-
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags);
-
-	/*
-	 * Always OR in the bits from the ili_last_fields field.
-	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
-	 * routines in the eventual clearing of the ilf_fields bits.
-	 * See the big comment in xfs_iflush() for an explanation of
-	 * this coordination mechanism.
-	 */
-	flags |= ip->i_itemp->ili_last_fields;
-	ip->i_itemp->ili_fields |= flags;
-}
-
-int
-xfs_trans_roll_inode(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip)
-{
-	int			error;
-
-	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_roll(tpp);
-	if (!error)
-		xfs_trans_ijoin(*tpp, ip, 0);
-	return error;
-}
-
 /*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
diff --git a/libxfs/trans_inode.c b/libxfs/trans_inode.c
new file mode 100644
index 0000000..cfca147
--- /dev/null
+++ b/libxfs/trans_inode.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005-2006 Silicon Graphics, Inc.
+ * Copyright (C) 2010 Red Hat, Inc.
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
+#include "xfs_sb.h"
+#include "xfs_defer.h"
+
+void
+xfs_trans_ijoin(
+	xfs_trans_t		*tp,
+	xfs_inode_t		*ip,
+	uint			lock_flags)
+{
+	xfs_inode_log_item_t	*iip;
+
+	if (ip->i_itemp == NULL)
+		xfs_inode_item_init(ip, ip->i_mount);
+	iip = ip->i_itemp;
+	ASSERT(iip->ili_inode != NULL);
+
+	ASSERT(iip->ili_lock_flags == 0);
+	iip->ili_lock_flags = lock_flags;
+
+	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
+
+#ifdef XACT_DEBUG
+	fprintf(stderr, "ijoin'd inode %llu, transaction %p\n", ip->i_ino, tp);
+#endif
+}
+
+void
+xfs_trans_ijoin_ref(
+	xfs_trans_t		*tp,
+	xfs_inode_t		*ip,
+	int			lock_flags)
+{
+	ASSERT(ip->i_itemp != NULL);
+
+	xfs_trans_ijoin(tp, ip, lock_flags);
+
+#ifdef XACT_DEBUG
+	fprintf(stderr, "ijoin_ref'd inode %llu, transaction %p\n", ip->i_ino, tp);
+#endif
+}
+
+/*
+ * This is called to mark the fields indicated in fieldmask as needing
+ * to be logged when the transaction is committed.  The inode must
+ * already be associated with the given transaction.
+ *
+ * The values for fieldmask are defined in xfs_log_format.h.  We always
+ * log all of the core inode if any of it has changed, and we always log
+ * all of the inline data/extents/b-tree root if any of them has changed.
+ */
+void
+xfs_trans_log_inode(
+	xfs_trans_t		*tp,
+	xfs_inode_t		*ip,
+	uint			flags)
+{
+	ASSERT(ip->i_itemp != NULL);
+#ifdef XACT_DEBUG
+	fprintf(stderr, "dirtied inode %llu, transaction %p\n", ip->i_ino, tp);
+#endif
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags);
+
+	/*
+	 * Always OR in the bits from the ili_last_fields field.
+	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
+	 * routines in the eventual clearing of the ilf_fields bits.
+	 * See the big comment in xfs_iflush() for an explanation of
+	 * this coordination mechanism.
+	 */
+	flags |= ip->i_itemp->ili_last_fields;
+	ip->i_itemp->ili_fields |= flags;
+}
+
+int
+xfs_trans_roll_inode(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_roll(tpp);
+	if (!error)
+		xfs_trans_ijoin(*tpp, ip, 0);
+	return error;
+}
-- 
1.8.3.1
