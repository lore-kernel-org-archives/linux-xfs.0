Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B4508016
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F9BFAC005
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:11 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4CQEzc0D4Q2CVZFu for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:37:09 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiQD-0001Bk-OB
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiQ3-0006nX-KK
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/22] libxfs: move transaction code to trans.c
Date: Wed, 12 Jun 2013 20:36:26 +1000
Message-Id: <1371033394-26006-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1371033394-26006-1-git-send-email-david@fromorbit.com>
References: <1371033394-26006-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

There is very little code left in xfs_trans.c. So little it is not
worthtrying to share this file with kernel space any more. Move the
code to libxfs/trans.c, and remove libxfs/xfs_trans.c.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_trans.h |    3 --
 libxfs/Makefile     |    2 +-
 libxfs/trans.c      |  118 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs.h        |    6 +++
 libxfs/xfs_trans.c  |  139 ---------------------------------------------------
 5 files changed, 125 insertions(+), 143 deletions(-)
 delete mode 100644 libxfs/xfs_trans.c

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 45d0ff2..21cafaa 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -459,7 +459,4 @@ extern kmem_zone_t	*xfs_log_item_desc_zone;
 
 #endif	/* __KERNEL__ */
 
-void		xfs_trans_init(struct xfs_mount *);
-int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index c4836ab..ec47b2a 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -16,7 +16,7 @@ CFILES = cache.c init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
 	xfs_ialloc_btree.c xfs_bmap_btree.c xfs_da_btree.c \
 	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
 	xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c \
-	xfs_sb.c xfs_rtalloc.c xfs_trans.c xfs_attr.c xfs_attr_remote.c \
+	xfs_sb.c xfs_rtalloc.c xfs_attr.c xfs_attr_remote.c \
 	crc32.c xfs_symlink.c xfs_trans_resv.c
 
 CFILES += $(PKG_PLATFORM).c
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 97220e7..754f827 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2001,2005-2006 Silicon Graphics, Inc.
+ * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -22,6 +23,123 @@
  * Simple transaction interface
  */
 
+kmem_zone_t	*xfs_log_item_desc_zone;
+
+/*
+ * Initialize the precomputed transaction reservation values
+ * in the mount structure.
+ */
+void
+libxfs_trans_init(
+	struct xfs_mount	*mp)
+{
+	xfs_trans_resv_calc(mp, &mp->m_reservations);
+}
+
+/*
+ * Add the given log item to the transaction's list of log items.
+ *
+ * The log item will now point to its new descriptor with its li_desc field.
+ */
+void
+libxfs_trans_add_item(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_log_item_desc *lidp;
+
+	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
+
+	lidp = calloc(sizeof(struct xfs_log_item_desc), 1);
+	if (!lidp) {
+		fprintf(stderr, _("%s: lidp calloc failed (%d bytes): %s\n"),
+			progname, (int)sizeof(struct xfs_log_item_desc),
+			strerror(errno));
+		exit(1);
+	}
+
+	lidp->lid_item = lip;
+	lidp->lid_flags = 0;
+	list_add_tail(&lidp->lid_trans, &tp->t_items);
+
+	lip->li_desc = lidp;
+}
+
+/*
+ * Unlink and free the given descriptor.
+ */
+void
+libxfs_trans_del_item(
+	struct xfs_log_item	*lip)
+{
+	list_del_init(&lip->li_desc->lid_trans);
+	free(lip->li_desc);
+	lip->li_desc = NULL;
+}
+
+/*
+ * Roll from one trans in the sequence of PERMANENT transactions to
+ * the next: permanent transactions are only flushed out when
+ * committed with XFS_TRANS_RELEASE_LOG_RES, but we still want as soon
+ * as possible to let chunks of it go to the log. So we commit the
+ * chunk we've been working on and get a new transaction to continue.
+ */
+int
+libxfs_trans_roll(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*dp)
+{
+	struct xfs_trans	*trans;
+	unsigned int		logres, count;
+	int			error;
+
+	/*
+	 * Ensure that the inode is always logged.
+	 */
+	trans = *tpp;
+	xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
+
+	/*
+	 * Copy the critical parameters from one trans to the next.
+	 */
+	logres = trans->t_log_res;
+	count = trans->t_log_count;
+	*tpp = xfs_trans_dup(trans);
+
+	/*
+	 * Commit the current transaction.
+	 * If this commit failed, then it'd just unlock those items that
+	 * are not marked ihold. That also means that a filesystem shutdown
+	 * is in progress. The caller takes the responsibility to cancel
+	 * the duplicate transaction that gets returned.
+	 */
+	error = xfs_trans_commit(trans, 0);
+	if (error)
+		return (error);
+
+	trans = *tpp;
+
+	/*
+	 * Reserve space in the log for th next transaction.
+	 * This also pushes items in the "AIL", the list of logged items,
+	 * out to disk if they are taking up space at the tail of the log
+	 * that we want to use.  This requires that either nothing be locked
+	 * across this call, or that anything that is locked be logged in
+	 * the prior and the next transactions.
+	 */
+	error = xfs_trans_reserve(trans, 0, logres, 0,
+				  XFS_TRANS_PERM_LOG_RES, count);
+	/*
+	 *  Ensure that the inode is in the new transaction and locked.
+	 */
+	if (error)
+		return error;
+
+	xfs_trans_ijoin(trans, dp, 0);
+	return 0;
+}
+
 xfs_trans_t *
 libxfs_trans_alloc(
 	xfs_mount_t	*mp,
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index efb246a..8391dc8 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -233,12 +233,14 @@ roundup_pow_of_two(uint v)
 #define xfs_mod_incore_sb		libxfs_mod_incore_sb
 
 #define xfs_trans_alloc			libxfs_trans_alloc
+#define xfs_trans_add_item		libxfs_trans_add_item
 #define xfs_trans_bhold			libxfs_trans_bhold
 #define xfs_trans_binval		libxfs_trans_binval
 #define xfs_trans_bjoin			libxfs_trans_bjoin
 #define xfs_trans_brelse		libxfs_trans_brelse
 #define xfs_trans_commit		libxfs_trans_commit
 #define xfs_trans_cancel		libxfs_trans_cancel
+#define xfs_trans_del_item		libxfs_trans_del_item
 #define xfs_trans_dup			libxfs_trans_dup
 #define xfs_trans_get_buf		libxfs_trans_get_buf
 #define xfs_trans_getsb			libxfs_trans_getsb
@@ -246,12 +248,14 @@ roundup_pow_of_two(uint v)
 #define xfs_trans_ihold			libxfs_trans_ihold
 #define xfs_trans_ijoin			libxfs_trans_ijoin
 #define xfs_trans_ijoin_ref		libxfs_trans_ijoin_ref
+#define xfs_trans_init			libxfs_trans_init
 #define xfs_trans_inode_alloc_buf	libxfs_trans_inode_alloc_buf
 #define xfs_trans_log_buf		libxfs_trans_log_buf
 #define xfs_trans_log_inode		libxfs_trans_log_inode
 #define xfs_trans_mod_sb		libxfs_trans_mod_sb
 #define xfs_trans_read_buf		libxfs_trans_read_buf
 #define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
+#define xfs_trans_roll			libxfs_trans_roll
 #define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
 #define xfs_trans_reserve		libxfs_trans_reserve
 
@@ -368,6 +372,8 @@ void xfs_mount_common(xfs_mount_t *, xfs_sb_t *);
 /*
  * logitem.c and trans.c prototypes
  */
+void xfs_trans_init(struct xfs_mount *);
+int xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 
 /* xfs_trans_item.c */
 void xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
deleted file mode 100644
index 2daf545..0000000
--- a/libxfs/xfs_trans.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * Copyright (C) 2010 Red Hat, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <xfs.h>
-
-kmem_zone_t	*xfs_trans_zone;
-kmem_zone_t	*xfs_log_item_desc_zone;
-
-/*
- * Initialize the precomputed transaction reservation values
- * in the mount structure.
- */
-void
-xfs_trans_init(
-	struct xfs_mount	*mp)
-{
-	xfs_trans_resv_calc(mp, &mp->m_reservations);
-}
-
-/*
- * Add the given log item to the transaction's list of log items.
- *
- * The log item will now point to its new descriptor with its li_desc field.
- */
-void
-xfs_trans_add_item(
-	struct xfs_trans	*tp,
-	struct xfs_log_item	*lip)
-{
-	struct xfs_log_item_desc *lidp;
-
-	ASSERT(lip->li_mountp == tp->t_mountp);
-	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
-
-	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
-
-	lidp->lid_item = lip;
-	lidp->lid_flags = 0;
-	list_add_tail(&lidp->lid_trans, &tp->t_items);
-
-	lip->li_desc = lidp;
-}
-
-STATIC void
-xfs_trans_free_item_desc(
-	struct xfs_log_item_desc *lidp)
-{
-	list_del_init(&lidp->lid_trans);
-	kmem_zone_free(xfs_log_item_desc_zone, lidp);
-}
-
-/*
- * Unlink and free the given descriptor.
- */
-void
-xfs_trans_del_item(
-	struct xfs_log_item	*lip)
-{
-	xfs_trans_free_item_desc(lip->li_desc);
-	lip->li_desc = NULL;
-}
-
-/*
- * Roll from one trans in the sequence of PERMANENT transactions to
- * the next: permanent transactions are only flushed out when
- * committed with XFS_TRANS_RELEASE_LOG_RES, but we still want as soon
- * as possible to let chunks of it go to the log. So we commit the
- * chunk we've been working on and get a new transaction to continue.
- */
-int
-xfs_trans_roll(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*dp)
-{
-	struct xfs_trans	*trans;
-	unsigned int		logres, count;
-	int			error;
-
-	/*
-	 * Ensure that the inode is always logged.
-	 */
-	trans = *tpp;
-	xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
-
-	/*
-	 * Copy the critical parameters from one trans to the next.
-	 */
-	logres = trans->t_log_res;
-	count = trans->t_log_count;
-	*tpp = xfs_trans_dup(trans);
-
-	/*
-	 * Commit the current transaction.
-	 * If this commit failed, then it'd just unlock those items that
-	 * are not marked ihold. That also means that a filesystem shutdown
-	 * is in progress. The caller takes the responsibility to cancel
-	 * the duplicate transaction that gets returned.
-	 */
-	error = xfs_trans_commit(trans, 0);
-	if (error)
-		return (error);
-
-	trans = *tpp;
-
-	/*
-	 * Reserve space in the log for th next transaction.
-	 * This also pushes items in the "AIL", the list of logged items,
-	 * out to disk if they are taking up space at the tail of the log
-	 * that we want to use.  This requires that either nothing be locked
-	 * across this call, or that anything that is locked be logged in
-	 * the prior and the next transactions.
-	 */
-	error = xfs_trans_reserve(trans, 0, logres, 0,
-				  XFS_TRANS_PERM_LOG_RES, count);
-	/*
-	 *  Ensure that the inode is in the new transaction and locked.
-	 */
-	if (error)
-		return error;
-
-	xfs_trans_ijoin(trans, dp, 0);
-	return 0;
-}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
