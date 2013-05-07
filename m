Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7407529E16
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 03:05:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BDEF304071
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 01:05:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Vws9MExMC8z5Q6rI for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 01:05:05 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZctH-0006ZB-G8
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZctH-0007rS-92
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] xfs: Inode create log items
Date: Tue,  7 May 2013 18:04:33 +1000
Message-Id: <1367913876-30086-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1367913876-30086-1-git-send-email-david@fromorbit.com>
References: <1367913876-30086-1-git-send-email-david@fromorbit.com>
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

Introduce the inode create log item type for logical inode create logging.
Instead of logging the changes in buffers, pass the range to be
initialised through the log by a new transaction type.  This reduces
the amount of log space required to record initialisation during
allocation from about 128 bytes per inode to a small fixed amount
per inode extent to be initialised.

This requires a new log item type to track it through the log
and the AIL. This is a relatively simple item - most callbacks are
noops as this item has the same life cycle as the transaction.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/Makefile           |    1 +
 fs/xfs/xfs_icreate_item.c |  195 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icreate_item.h |   51 ++++++++++++
 fs/xfs/xfs_log.h          |    3 +-
 fs/xfs/xfs_super.c        |    8 ++
 fs/xfs/xfs_trans.h        |    4 +-
 6 files changed, 260 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/xfs_icreate_item.c
 create mode 100644 fs/xfs/xfs_icreate_item.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6313b69..4a45080 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -71,6 +71,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_dir2_sf.o \
 				   xfs_ialloc.o \
 				   xfs_ialloc_btree.o \
+				   xfs_icreate_item.o \
 				   xfs_inode.o \
 				   xfs_log_recover.o \
 				   xfs_mount.o \
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
new file mode 100644
index 0000000..0e4d03c
--- /dev/null
+++ b/fs/xfs/xfs_icreate_item.c
@@ -0,0 +1,195 @@
+/*
+ * Copyright (c) 2008-2010, Dave Chinner
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_mount.h"
+#include "xfs_trans_priv.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_inode_item.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_error.h"
+#include "xfs_icreate_item.h"
+
+kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
+
+static inline struct xfs_icreate_item *ICR_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_icreate_item, ic_item);
+}
+
+/*
+ * This returns the number of iovecs needed to log the given inode item.
+ *
+ * We only need one iovec for the icreate log structure.
+ */
+STATIC uint
+xfs_icreate_item_size(
+	struct xfs_log_item	*lip)
+{
+	return 1;
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given inode create log item.
+ */
+STATIC void
+xfs_icreate_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_iovec	*log_vector)
+{
+	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
+
+	log_vector->i_addr = (xfs_caddr_t)&icp->ic_format;
+	log_vector->i_len  = sizeof(struct xfs_icreate_log);
+	log_vector->i_type = XLOG_REG_TYPE_ICREATE;
+}
+
+
+/* Pinning has no meaning for the create item, so just return. */
+STATIC void
+xfs_icreate_item_pin(
+	struct xfs_log_item	*lip)
+{
+}
+
+
+/* pinning has no meaning for the create item, so just return. */
+STATIC void
+xfs_icreate_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+}
+
+STATIC void
+xfs_icreate_item_unlock(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
+
+	if (icp->ic_item.li_flags & XFS_LI_ABORTED)
+		kmem_zone_free(xfs_icreate_zone, icp);
+	return;
+}
+
+/*
+ * Because we have ordered buffers being tracked in the AIL for the inode
+ * creation, we don't need the create item after this. Hence we can free
+ * the log item and return -1 to tell the caller we're done with the item.
+ * be relogged, so just return the current lsn here.
+ */
+STATIC xfs_lsn_t
+xfs_icreate_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
+
+	kmem_zone_free(xfs_icreate_zone, icp);
+	return (xfs_lsn_t)-1;
+}
+
+/* item can never get into the AIL */
+STATIC uint
+xfs_icreate_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	ASSERT(0);
+	return XFS_ITEM_SUCCESS;
+}
+
+/* Ordered buffers do the dependency tracking here, so this does nothing. */
+STATIC void
+xfs_icreate_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+}
+
+/*
+ * This is the ops vector shared by all buf log items.
+ */
+static struct xfs_item_ops xfs_icreate_item_ops = {
+	.iop_size	= xfs_icreate_item_size,
+	.iop_format	= xfs_icreate_item_format,
+	.iop_pin	= xfs_icreate_item_pin,
+	.iop_unpin	= xfs_icreate_item_unpin,
+	.iop_push	= xfs_icreate_item_push,
+	.iop_unlock	= xfs_icreate_item_unlock,
+	.iop_committed	= xfs_icreate_item_committed,
+	.iop_committing = xfs_icreate_item_committing,
+};
+
+
+/*
+ * Initialize the inode log item for a newly allocated (in-core) inode.
+ *
+ * Inode extents can only reside within an AG. Hence specify the starting
+ * block for the inode chunk by offset within an AG as well as the
+ * length of the allocated extent.
+ *
+ * This joins the item to the transaction and marks it dirty so
+ * that we don't need a separate call to do this, nor does the
+ * caller need to know anything about the icreate item.
+ */
+void
+xfs_icreate_log(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	unsigned int		count,
+	unsigned int		inode_size,
+	xfs_agblock_t		length,
+	unsigned int		generation)
+{
+	struct xfs_icreate_item	*icp;
+
+	icp = kmem_zone_zalloc(xfs_icreate_zone, KM_SLEEP);
+
+	icp->ic_item.li_type = XFS_LI_ICREATE;
+	icp->ic_item.li_ops = &xfs_icreate_item_ops;
+	icp->ic_item.li_mountp = tp->t_mountp;
+
+	icp->ic_format.icl_type = XFS_LI_ICREATE;
+	icp->ic_format.icl_size = 1;	/* single vector */
+	icp->ic_format.icl_ag = cpu_to_be32(agno);
+	icp->ic_format.icl_agbno = cpu_to_be32(agbno);
+	icp->ic_format.icl_count = cpu_to_be32(count);
+	icp->ic_format.icl_isize = cpu_to_be32(inode_size);
+	icp->ic_format.icl_length = cpu_to_be32(length);
+	icp->ic_format.icl_gen = cpu_to_be32(generation);
+
+	xfs_trans_add_item(tp, &icp->ic_item);
+}
diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/xfs_icreate_item.h
new file mode 100644
index 0000000..cf5344b
--- /dev/null
+++ b/fs/xfs/xfs_icreate_item.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright (c) 2008-2010, Dave Chinner
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef XFS_ICREATE_ITEM_H
+#define XFS_ICREATE_ITEM_H	1
+
+/*
+ * on disk log item structure
+ *
+ * Log recovery assumes the first two entries are the type and
+ * size and they fit in 32 bits. Also in host order (ugh)
+ */
+struct xfs_icreate_log {
+	__uint16_t	icl_type;	/* type of log format structure */
+	__uint16_t	icl_size;	/* size of log format structure */
+	__be32		icl_ag;		/* ag being allocated in */
+	__be32		icl_agbno;	/* start block of inode range */
+	__be32		icl_count;	/* number of inodes to initialise */
+	__be32		icl_isize;	/* size of inodes */
+	__be32		icl_length;	/* length of extent to initialise */
+	__be32		icl_gen;	/* inode generation number to use */
+};
+
+/* in memory log item structure */
+struct xfs_icreate_item {
+	struct xfs_log_item	ic_item;
+	struct xfs_icreate_log	ic_format;
+};
+
+extern kmem_zone_t *xfs_icreate_zone;	/* inode create item zone */
+
+void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
+			xfs_agblock_t agbno, unsigned int count,
+			unsigned int inode_size, xfs_agblock_t length,
+			unsigned int generation);
+
+#endif	/* XFS_ICREATE_ITEM_H */
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 5caee96..70cc014 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -88,7 +88,8 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
 #define XLOG_REG_TYPE_UNMOUNT		17
 #define XLOG_REG_TYPE_COMMIT		18
 #define XLOG_REG_TYPE_TRANSHDR		19
-#define XLOG_REG_TYPE_MAX		19
+#define XLOG_REG_TYPE_ICREATE		20
+#define XLOG_REG_TYPE_MAX		20
 
 typedef struct xfs_log_iovec {
 	void		*i_addr;	/* beginning address of region */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ea341ce..a9d5df7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -51,6 +51,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_icache.h"
 #include "xfs_trace.h"
+#include "xfs_icreate_item.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1644,9 +1645,15 @@ xfs_init_zones(void)
 					KM_ZONE_SPREAD, NULL);
 	if (!xfs_ili_zone)
 		goto out_destroy_inode_zone;
+	xfs_icreate_zone = kmem_zone_init(sizeof(struct xfs_icreate_item),
+					"xfs_icr");
+	if (!xfs_icreate_zone)
+		goto out_destroy_ili_zone;
 
 	return 0;
 
+ out_destroy_ili_zone:
+	kmem_zone_destroy(xfs_ili_zone);
  out_destroy_inode_zone:
 	kmem_zone_destroy(xfs_inode_zone);
  out_destroy_efi_zone:
@@ -1685,6 +1692,7 @@ xfs_destroy_zones(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_zone_destroy(xfs_icreate_zone);
 	kmem_zone_destroy(xfs_ili_zone);
 	kmem_zone_destroy(xfs_inode_zone);
 	kmem_zone_destroy(xfs_efi_zone);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 850fe78..079d5a0 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -48,6 +48,7 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_BUF		0x123c	/* v2 bufs, variable sized inode bufs */
 #define	XFS_LI_DQUOT		0x123d
 #define	XFS_LI_QUOTAOFF		0x123e
+#define	XFS_LI_ICREATE		0x123f
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -107,7 +108,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_SWAPEXT		40
 #define	XFS_TRANS_SB_COUNT		41
 #define	XFS_TRANS_CHECKPOINT		42
-#define	XFS_TRANS_TYPE_MAX		42
+#define	XFS_TRANS_ICREATE		43
+#define	XFS_TRANS_TYPE_MAX		43
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
