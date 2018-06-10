Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46662 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753658AbeFJFH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:07:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A57EGh007095
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:28 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2jg4dkt247-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:27 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57RLF032474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:27 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57Rt1002761
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:27 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v7 06/23] xfs: Set up infastructure for deferred attribute operations
Date: Sat,  9 Jun 2018 22:04:51 -0700
Message-Id: <1528607108-11059-7-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds two new log item types for setting or
removing attributes as deferred operations.  The
xfs_attri_log_item logs an intent to set or remove an
attribute.  The corresponding xfs_attrd_log_item holds
a reference to the xfs_attri_log_item and is freed once
the transaction is done.  Both log items use a generic
xfs_attr_log_format structure that contains the attribute
name, value, flags, inode, and an op_flag that indicates
if the operations is a set or remove.

At the moment, this feature will only be used by the parent
pointer patch set which uses attributes to store information
about an inodes parent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile                |   2 +
 fs/xfs/libxfs/xfs_attr.c       |   5 +-
 fs/xfs/libxfs/xfs_attr.h       |  26 +-
 fs/xfs/libxfs/xfs_defer.h      |   1 +
 fs/xfs/libxfs/xfs_log_format.h |  44 +++-
 fs/xfs/libxfs/xfs_types.h      |   1 +
 fs/xfs/xfs_attr_item.c         | 560 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h         | 120 +++++++++
 fs/xfs/xfs_log_recover.c       | 173 +++++++++++++
 fs/xfs/xfs_ondisk.h            |   2 +
 fs/xfs/xfs_super.c             |   1 +
 fs/xfs/xfs_trans.h             |  14 ++
 fs/xfs/xfs_trans_attr.c        | 285 +++++++++++++++++++++
 13 files changed, 1229 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7ceb41a..d3c0004 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -107,6 +107,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_bmap_item.o \
 				   xfs_buf_item.o \
 				   xfs_extfree_item.o \
+				   xfs_attr_item.o \
 				   xfs_icreate_item.o \
 				   xfs_inode_item.o \
 				   xfs_refcount_item.o \
@@ -116,6 +117,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_trans_bmap.o \
 				   xfs_trans_buf.o \
 				   xfs_trans_extfree.o \
+				   xfs_trans_attr.o \
 				   xfs_trans_inode.o \
 				   xfs_trans_refcount.o \
 				   xfs_trans_rmap.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ab769e5..408a49d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -41,6 +41,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_attr_item.h"
 
 /*
  * xfs_attr.c
@@ -74,7 +75,7 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
 
-STATIC int
+int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
@@ -170,7 +171,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index ef6b47e..33b33d3 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_ATTR_H__
 #define	__XFS_ATTR_H__
 
+#include "libxfs/xfs_defer.h"
+
 struct xfs_inode;
 struct xfs_da_args;
 struct xfs_attr_list_context;
@@ -90,6 +92,26 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 } attrlist_ent_t;
 
 /*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_inode  *xattri_ip;
+	uint32_t	  xattri_op_flags;
+	uint32_t	  xattri_value_len;   /* length of value */
+	uint32_t	  xattri_name_len;    /* length of name */
+	uint32_t	  xattri_flags;       /* attr flags */
+	struct list_head  xattri_list;
+
+	/*
+	 * A byte array follows the header containing the file name and
+	 * attribute value.
+	 */
+};
+
+#define XFS_ATTR_ITEM_SIZEOF(namelen, valuelen)	\
+	(sizeof(struct xfs_attr_item) + (namelen) + (valuelen))
+
+/*
  * Given a pointer to the (char*) buffer containing the attr_list() result,
  * and an index, return a pointer to the indicated attribute in the buffer.
  */
@@ -158,6 +180,8 @@ int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args, int flags, bool roll_trans);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
-
+int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
+		       const unsigned char *name, int flags);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 045beac..11e1690 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -55,6 +55,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_REFCOUNT,
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 349d9f8..291e5ff 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -116,7 +116,12 @@ static inline uint xlog_get_cycle(char *ptr)
 #define XLOG_REG_TYPE_CUD_FORMAT	24
 #define XLOG_REG_TYPE_BUI_FORMAT	25
 #define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_MAX		26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_MAX		31
+
 
 /*
  * Flags to log operation header
@@ -239,6 +244,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_CUD		0x1243
 #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
 #define	XFS_LI_BUD		0x1245
+#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
+#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -254,7 +261,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
 	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
-	{ XFS_LI_BUD,		"XFS_LI_BUD" }
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
+	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -852,4 +861,35 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+/*
+ * Flags for deferred attribute operations.
+ * Upper bits are flags, lower byte is type code
+ */
+#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
+#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
+#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0x0FF	/* Flags type mask */
+
+/*
+ * This is the structure used to lay out an attr log item in the
+ * log.
+ */
+struct xfs_attri_log_format {
+	uint16_t	alfi_type;	/* attri log item type */
+	uint16_t	alfi_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfi_id;	/* attri identifier */
+	xfs_ino_t       alfi_ino;	/* the inode for this attr operation */
+	uint32_t        alfi_op_flags;	/* marks the op as a set or remove */
+	uint32_t        alfi_name_len;	/* attr name length */
+	uint32_t        alfi_value_len;	/* attr value length */
+	uint32_t        alfi_attr_flags;/* attr flags */
+};
+
+struct xfs_attrd_log_format {
+	uint16_t	alfd_type;	/* attrd log item type */
+	uint16_t	alfd_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfd_alf_id;	/* id of corresponding attrd */
+};
+
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 3c56069..2905ce3 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -23,6 +23,7 @@ typedef uint32_t	prid_t;		/* project ID */
 typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
+typedef uint32_t	xfs_attrlen_t;	/* attr length */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
 typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
 typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
new file mode 100644
index 0000000..e90d516
--- /dev/null
+++ b/fs/xfs/xfs_attr_item.c
@@ -0,0 +1,560 @@
+/*
+ * Copyright (c) 2017 Oracle, Inc.
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
+ * along with this program; if not, write the Free Software Foundation Inc.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
+#include "xfs_attr_item.h"
+#include "xfs_log.h"
+#include "xfs_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+
+static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attri_log_item, item);
+}
+
+void
+xfs_attri_item_free(
+	struct xfs_attri_log_item	*attrip)
+{
+	kmem_free(attrip->item.li_lv_shadow);
+	kmem_free(attrip);
+}
+
+/*
+ * This returns the number of iovecs needed to log the given attri item.
+ * We only need 1 iovec for an attri item.  It just logs the attr_log_format
+ * structure.
+ */
+static inline int
+xfs_attri_item_sizeof(
+	struct xfs_attri_log_item *attrip)
+{
+	return sizeof(struct xfs_attri_log_format);
+}
+
+STATIC void
+xfs_attri_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
+
+	*nvecs += 1;
+	*nbytes += xfs_attri_item_sizeof(attrip);
+
+	if (attrip->name_len > 0) {
+		*nvecs += 1;
+		nbytes += ATTR_NVEC_SIZE(attrip->name_len);
+	}
+
+	if (attrip->value_len > 0) {
+		*nvecs += 1;
+		nbytes += ATTR_NVEC_SIZE(attrip->value_len);
+	}
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given attri log item. We use only 1 iovec, and we point that
+ * at the attri_log_format structure embedded in the attri item.
+ * It is at this point that we assert that all of the attr
+ * slots in the attri item have been filled.
+ */
+STATIC void
+xfs_attri_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
+
+	attrip->format.alfi_type = XFS_LI_ATTRI;
+	attrip->format.alfi_size = 1;
+	if (attrip->name_len > 0)
+		attrip->format.alfi_size++;
+	if (attrip->value_len > 0)
+		attrip->format.alfi_size++;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
+			&attrip->format,
+			xfs_attri_item_sizeof(attrip));
+	if (attrip->name_len > 0)
+		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
+				attrip->name, ATTR_NVEC_SIZE(attrip->name_len));
+
+	if (attrip->value_len > 0)
+		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
+				attrip->value,
+				ATTR_NVEC_SIZE(attrip->value_len));
+}
+
+
+/*
+ * Pinning has no meaning for an attri item, so just return.
+ */
+STATIC void
+xfs_attri_item_pin(
+	struct xfs_log_item	*lip)
+{
+}
+
+/*
+ * The unpin operation is the last place an ATTRI is manipulated in the log. It
+ * is either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the ATTRI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the ATTRI to either
+ * construct and commit the ATTRD or drop the ATTRD's reference in the event of
+ * error. Simply drop the log's ATTRI reference now that the log is done with
+ * it.
+ */
+STATIC void
+xfs_attri_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+
+	xfs_attri_release(attrip);
+}
+
+/*
+ * attri items have no locking or pushing.  However, since ATTRIs are pulled
+ * from the AIL when their corresponding ATTRDs are committed to disk, their
+ * situation is very similar to being pinned.  Return XFS_ITEM_PINNED so that
+ * the caller will eventually flush the log.  This should help in getting the
+ * ATTRI out of the AIL.
+ */
+STATIC uint
+xfs_attri_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	return XFS_ITEM_PINNED;
+}
+
+/*
+ * The ATTRI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an ATTRD isn't going to be
+ * constructed and thus we free the ATTRI here directly.
+ */
+STATIC void
+xfs_attri_item_unlock(
+	struct xfs_log_item	*lip)
+{
+	if (lip->li_flags & XFS_LI_ABORTED)
+		xfs_attri_release(ATTRI_ITEM(lip));
+}
+
+/*
+ * The ATTRI is logged only once and cannot be moved in the log, so simply
+ * return the lsn at which it's been logged.
+ */
+STATIC xfs_lsn_t
+xfs_attri_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	return lsn;
+}
+
+STATIC void
+xfs_attri_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+}
+
+/*
+ * This is the ops vector shared by all attri log items.
+ */
+static const struct xfs_item_ops xfs_attri_item_ops = {
+	.iop_size	= xfs_attri_item_size,
+	.iop_format	= xfs_attri_item_format,
+	.iop_pin	= xfs_attri_item_pin,
+	.iop_unpin	= xfs_attri_item_unpin,
+	.iop_unlock	= xfs_attri_item_unlock,
+	.iop_committed	= xfs_attri_item_committed,
+	.iop_push	= xfs_attri_item_push,
+	.iop_committing = xfs_attri_item_committing
+};
+
+
+/*
+ * Allocate and initialize an attri item
+ */
+struct xfs_attri_log_item *
+xfs_attri_init(
+	struct xfs_mount	*mp)
+
+{
+	struct xfs_attri_log_item	*attrip;
+	uint			size;
+
+	size = (uint)(sizeof(struct xfs_attri_log_item));
+	attrip = kmem_zalloc(size, KM_SLEEP);
+
+	xfs_log_item_init(mp, &(attrip->item), XFS_LI_ATTRI,
+			  &xfs_attri_item_ops);
+	attrip->format.alfi_id = (uintptr_t)(void *)attrip;
+	atomic_set(&attrip->refcount, 2);
+
+	return attrip;
+}
+
+/*
+ * Copy an attr format buffer from the given buf, and into the destination
+ * attr format structure.
+ */
+int
+xfs_attri_copy_format(struct xfs_log_iovec *buf,
+		      struct xfs_attri_log_format *dst_attr_fmt)
+{
+	struct xfs_attri_log_format *src_attr_fmt = buf->i_addr;
+	uint len = sizeof(struct xfs_attri_log_format);
+
+	if (buf->i_len == len) {
+		memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
+		return 0;
+	}
+	return -EFSCORRUPTED;
+}
+
+/*
+ * Copy an attr format buffer from the given buf, and into the destination
+ * attr format structure.
+ */
+int
+xfs_attrd_copy_format(struct xfs_log_iovec *buf,
+		      struct xfs_attrd_log_format *dst_attr_fmt)
+{
+	struct xfs_attrd_log_format *src_attr_fmt = buf->i_addr;
+	uint len = sizeof(struct xfs_attrd_log_format);
+
+	if (buf->i_len == len) {
+		memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
+		return 0;
+	}
+	return -EFSCORRUPTED;
+}
+
+/*
+ * Freeing the attrip requires that we remove it from the AIL if it has already
+ * been placed there. However, the ATTRI may not yet have been placed in the AIL
+ * when called by xfs_attri_release() from ATTRD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the ATTRI.
+ */
+void
+xfs_attri_release(
+	struct xfs_attri_log_item	*attrip)
+{
+	ASSERT(atomic_read(&attrip->refcount) > 0);
+	if (atomic_dec_and_test(&attrip->refcount)) {
+		xfs_trans_ail_remove(&attrip->item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_attri_item_free(attrip);
+	}
+}
+ 
+static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attrd_log_item, item);
+}
+
+STATIC void
+xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
+{
+	kmem_free(attrdp->item.li_lv_shadow);
+	kmem_free(attrdp);
+}
+
+/*
+ * This returns the number of iovecs needed to log the given attrd item.
+ * We only need 1 iovec for an attrd item.  It just logs the attr_log_format
+ * structure.
+ */
+static inline int
+xfs_attrd_item_sizeof(
+	struct xfs_attrd_log_item *attrdp)
+{
+	return sizeof(struct xfs_attrd_log_format);
+}
+
+STATIC void
+xfs_attrd_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+	*nvecs += 1;
+	*nbytes += xfs_attrd_item_sizeof(attrdp);
+
+	if (attrdp->name_len > 0) {
+		*nvecs += 1;
+		nbytes += attrdp->name_len;
+	}
+
+	if (attrdp->value_len > 0) {
+		*nvecs += 1;
+		nbytes += attrdp->value_len;
+	}
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given attrd log item. We use only 1 iovec, and we point that
+ * at the attr_log_format structure embedded in the attrd item.
+ * It is at this point that we assert that all of the attr
+ * slots in the attrd item have been filled.
+ */
+STATIC void
+xfs_attrd_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
+
+	attrdp->format.alfd_type = XFS_LI_ATTRD;
+	attrdp->format.alfd_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
+			&attrdp->format,
+			xfs_attrd_item_sizeof(attrdp));
+}
+
+/*
+ * Pinning has no meaning for an attrd item, so just return.
+ */
+STATIC void
+xfs_attrd_item_pin(
+	struct xfs_log_item	*lip)
+{
+}
+
+/*
+ * Since pinning has no meaning for an attrd item, unpinning does
+ * not either.
+ */
+STATIC void
+xfs_attrd_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+}
+
+/*
+ * There isn't much you can do to push on an attrd item.  It is simply stuck
+ * waiting for the log to be flushed to disk.
+ */
+STATIC uint
+xfs_attrd_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	return XFS_ITEM_PINNED;
+}
+
+/*
+ * The ATTRD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the ATTRI and free the
+ * ATTRD.
+ */
+STATIC void
+xfs_attrd_item_unlock(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+
+	if (lip->li_flags & XFS_LI_ABORTED) {
+		xfs_attri_release(attrdp->attrip);
+		xfs_attrd_item_free(attrdp);
+	}
+}
+
+/*
+ * When the attrd item is committed to disk, all we need to do is delete our
+ * reference to our partner attri item and then free ourselves. Since we're
+ * freeing ourselves we must return -1 to keep the transaction code from
+ * further referencing this item.
+ */
+STATIC xfs_lsn_t
+xfs_attrd_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+
+	/*
+	 * Drop the ATTRI reference regardless of whether the ATTRD has been
+	 * aborted. Once the ATTRD transaction is constructed, it is the sole
+	 * responsibility of the ATTRD to release the ATTRI (even if the ATTRI
+	 * is aborted due to log I/O error).
+	 */
+	xfs_attri_release(attrdp->attrip);
+	xfs_attrd_item_free(attrdp);
+
+	return (xfs_lsn_t)-1;
+}
+
+STATIC void
+xfs_attrd_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+}
+
+/*
+ * This is the ops vector shared by all attrd log items.
+ */
+static const struct xfs_item_ops xfs_attrd_item_ops = {
+	.iop_size	= xfs_attrd_item_size,
+	.iop_format	= xfs_attrd_item_format,
+	.iop_pin	= xfs_attrd_item_pin,
+	.iop_unpin	= xfs_attrd_item_unpin,
+	.iop_unlock	= xfs_attrd_item_unlock,
+	.iop_committed	= xfs_attrd_item_committed,
+	.iop_push	= xfs_attrd_item_push,
+	.iop_committing = xfs_attrd_item_committing
+};
+
+/*
+ * Allocate and initialize an attrd item
+ */
+struct xfs_attrd_log_item *
+xfs_attrd_init(
+	struct xfs_mount	*mp,
+	struct xfs_attri_log_item	*attrip)
+
+{
+	struct xfs_attrd_log_item	*attrdp;
+	uint			size;
+
+	size = (uint)(sizeof(struct xfs_attrd_log_item));
+	attrdp = kmem_zalloc(size, KM_SLEEP);
+
+	xfs_log_item_init(mp, &attrdp->item, XFS_LI_ATTRD,
+			  &xfs_attrd_item_ops);
+	attrdp->attrip = attrip;
+	attrdp->format.alfd_alf_id = attrip->format.alfi_id;
+
+	return attrdp;
+}
+
+/*
+ * Process an attr intent item that was recovered from
+ * the log.  We need to delete the attr that it describes.
+ */
+int
+xfs_attri_recover(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_item	*attrip,
+	struct xfs_defer_ops		*dfops)
+{
+	struct xfs_inode		*ip;
+	struct xfs_attrd_log_item	*attrdp;
+	struct xfs_trans		*tp;
+	int				error = 0;
+	struct xfs_attri_log_format	*attrp;
+
+	ASSERT(!test_bit(XFS_ATTRI_RECOVERED, &attrip->flags));
+
+	/*
+	 * First check the validity of the attr described by the
+	 * ATTRI.  If any are bad, then assume that all are bad and
+	 * just toss the ATTRI.
+	 */
+	attrp = &attrip->format;
+	if (
+	    /*
+	     * Must have either XFS_ATTR_OP_FLAGS_SET or
+	     * XFS_ATTR_OP_FLAGS_REMOVE set
+	     */
+	    !(attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET ||
+		attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE) ||
+
+	    /* Check size of value and name lengths */
+	    (attrp->alfi_value_len > XATTR_SIZE_MAX ||
+		attrp->alfi_name_len > XATTR_NAME_MAX) ||
+
+	    /*
+	     * If the XFS_ATTR_OP_FLAGS_SET flag is set,
+	     * there must also be a name and value
+	     */
+	    (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET &&
+		(attrp->alfi_value_len == 0 || attrp->alfi_name_len == 0)) ||
+
+	    /*
+	     * If the XFS_ATTR_OP_FLAGS_REMOVE flag is set,
+	     * there must also be a name
+	     */
+	    (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE &&
+		(attrp->alfi_name_len == 0))
+	) {
+		/*
+		 * This will pull the ATTRI from the AIL and
+		 * free the memory associated with it.
+		 */
+		set_bit(XFS_ATTRI_RECOVERED, &attrip->flags);
+		xfs_attri_release(attrip);
+		return -EIO;
+	}
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error)
+		return error;
+	attrdp = xfs_trans_get_attrd(tp, attrip);
+	attrp = &attrip->format;
+
+	error = xfs_iget(mp, tp, attrp->alfi_ino, 0, 0, &ip);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	error = xfs_trans_attr(tp, dfops, attrdp, ip,
+				attrp->alfi_op_flags,
+				attrp->alfi_attr_flags,
+				attrp->alfi_name_len,
+				attrp->alfi_value_len,
+				attrip->name,
+				attrip->value);
+	if (error)
+		goto abort_error;
+
+
+	set_bit(XFS_ATTRI_RECOVERED, &attrip->flags);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+
+abort_error:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
new file mode 100644
index 0000000..184e6b1
--- /dev/null
+++ b/fs/xfs/xfs_attr_item.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (c) 2017 Oracle, Inc.
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
+ * along with this program; if not, write the Free Software Foundation Inc.
+ */
+#ifndef	__XFS_ATTR_ITEM_H__
+#define	__XFS_ATTR_ITEM_H__
+
+/* kernel only ATTRI/ATTRD definitions */
+
+struct xfs_mount;
+struct kmem_zone;
+
+/*
+ * Max number of attrs in fast allocation path.
+ */
+#define XFS_ATTRI_MAX_FAST_ATTRS        1
+
+
+/*
+ * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
+ */
+#define	XFS_ATTRI_RECOVERED	1
+
+
+/* nvecs must be in multiples of 4 */
+#define ATTR_NVEC_SIZE(size) (size == sizeof(int32_t) ? sizeof(int32_t) : \
+				size + sizeof(int32_t) - \
+				(size % sizeof(int32_t)))
+
+/*
+ * This is the "attr intention" log item.  It is used to log the fact
+ * that some attrs need to be processed.  It is used in conjunction with the
+ * "attr done" log item described below.
+ *
+ * The ATTRI is reference counted so that it is not freed prior to both the
+ * ATTRI and ATTRD being committed and unpinned. This ensures the ATTRI is
+ * inserted into the AIL even in the event of out of order ATTRI/ATTRD
+ * processing. In other words, an ATTRI is born with two references:
+ *
+ *      1.) an ATTRI held reference to track ATTRI AIL insertion
+ *      2.) an ATTRD held reference to track ATTRD commit
+ *
+ * On allocation, both references are the responsibility of the caller. Once
+ * the ATTRI is added to and dirtied in a transaction, ownership of reference
+ * one transfers to the transaction. The reference is dropped once the ATTRI is
+ * inserted to the AIL or in the event of failure along the way (e.g., commit
+ * failure, log I/O error, etc.). Note that the caller remains responsible for
+ * the ATTRD reference under all circumstances to this point. The caller has no
+ * means to detect failure once the transaction is committed, however.
+ * Therefore, an ATTRD is required after this point, even in the event of
+ * unrelated failure.
+ *
+ * Once an ATTRD is allocated and dirtied in a transaction, reference two
+ * transfers to the transaction. The ATTRD reference is dropped once it reaches
+ * the unpin handler. Similar to the ATTRI, the reference also drops in the
+ * event of commit failure or log I/O errors. Note that the ATTRD is not
+ * inserted in the AIL, so at this point both the ATTI and ATTRD are freed.
+ */
+struct xfs_attri_log_item {
+	xfs_log_item_t			item;
+	atomic_t			refcount;
+	unsigned long			flags;	/* misc flags */
+	int				name_len;
+	void				*name;
+	int				value_len;
+	void				*value;
+	struct xfs_attri_log_format	format;
+};
+
+/*
+ * This is the "attr done" log item.  It is used to log
+ * the fact that some attrs earlier mentioned in an attri item
+ * have been freed.
+ */
+struct xfs_attrd_log_item {
+	struct xfs_log_item		item;
+	struct xfs_attri_log_item	*attrip;
+	uint				next_attr;
+	int				name_len;
+	void				*name;
+	int				value_len;
+	void				*value;
+	struct xfs_attrd_log_format	format;
+};
+
+/*
+ * Max number of attrs in fast allocation path.
+ */
+#define	XFS_ATTRD_MAX_FAST_ATTRS	1
+
+extern struct kmem_zone	*xfs_attri_zone;
+extern struct kmem_zone	*xfs_attrd_zone;
+
+struct xfs_attri_log_item	*xfs_attri_init(struct xfs_mount *mp);
+struct xfs_attrd_log_item	*xfs_attrd_init(struct xfs_mount *mp,
+					struct xfs_attri_log_item *attrip);
+int xfs_attri_copy_format(struct xfs_log_iovec *buf,
+			   struct xfs_attri_log_format *dst_attri_fmt);
+int xfs_attrd_copy_format(struct xfs_log_iovec *buf,
+			   struct xfs_attrd_log_format *dst_attrd_fmt);
+void			xfs_attri_item_free(struct xfs_attri_log_item *attrip);
+void			xfs_attri_release(struct xfs_attri_log_item *attrip);
+
+int			xfs_attri_recover(struct xfs_mount *mp,
+					struct xfs_attri_log_item *attrip,
+					struct xfs_defer_ops *dfops);
+
+#endif	/* __XFS_ATTR_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2b2383f..b34e7f8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -34,6 +34,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"
+#include "xfs_attr_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
@@ -1967,6 +1968,8 @@ xlog_recover_reorder_trans(
 		case XFS_LI_CUD:
 		case XFS_LI_BUI:
 		case XFS_LI_BUD:
+		case XFS_LI_ATTRI:
+		case XFS_LI_ATTRD:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
 			list_move_tail(&item->ri_list, &inode_list);
@@ -3497,6 +3500,117 @@ xlog_recover_efd_pass2(
 	return 0;
 }
 
+STATIC int
+xlog_recover_attri_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item,
+	xfs_lsn_t                       lsn)
+{
+	int                             error;
+	struct xfs_mount                *mp = log->l_mp;
+	struct xfs_attri_log_item       *attrip;
+	struct xfs_attri_log_format     *attri_formatp;
+	char				*name = NULL;
+	char				*value = NULL;
+	int				region = 0;
+
+	attri_formatp = item->ri_buf[region].i_addr;
+
+	attrip = xfs_attri_init(mp);
+	error = xfs_attri_copy_format(&item->ri_buf[region], &attrip->format);
+	if (error) {
+		xfs_attri_item_free(attrip);
+		return error;
+	}
+
+	attrip->name_len = attri_formatp->alfi_name_len;
+	attrip->value_len = attri_formatp->alfi_value_len;
+	attrip = kmem_realloc(attrip, sizeof(struct xfs_attri_log_item) +
+				attrip->name_len + attrip->value_len, KM_SLEEP);
+
+	if (attrip->name_len > 0) {
+		region++;
+		name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
+		memcpy(name, item->ri_buf[region].i_addr,
+			attrip->name_len);
+		attrip->name = name;
+	}
+
+	if (attrip->value_len > 0) {
+		region++;
+		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
+			attrip->name_len;
+		memcpy(value, item->ri_buf[region].i_addr,
+			attrip->value_len);
+		attrip->value = value;
+	}
+
+	spin_lock(&log->l_ailp->ail_lock);
+	/*
+	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
+	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
+	 * directly and drop the ATTRI reference. Note that
+	 * xfs_trans_ail_update() drops the AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &attrip->item, lsn);
+	xfs_attri_release(attrip);
+	return 0;
+}
+
+
+/*
+ * This routine is called when an ATTRD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
+ * it was still in the log. To do this it searches the AIL for the ATTRI with
+ * an id equal to that in the ATTRD format structure. If we find it we drop
+ * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_attrd_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_attrd_log_format	*attrd_formatp;
+	struct xfs_attri_log_item	*attrip = NULL;
+	struct xfs_log_item		*lip;
+	uint64_t			attri_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	attrd_formatp = item->ri_buf[0].i_addr;
+	ASSERT((item->ri_buf[0].i_len ==
+				(sizeof(struct xfs_attrd_log_format))));
+	attri_id = attrd_formatp->alfd_alf_id;
+
+	/*
+	 * Search for the ATTRI with the id in the ATTRD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->ail_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_ATTRI) {
+			attrip = (struct xfs_attri_log_item *)lip;
+			if (attrip->format.alfi_id == attri_id) {
+				/*
+				 * Drop the ATTRD reference to the ATTRI. This
+				 * removes the ATTRI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->ail_lock);
+				xfs_attri_release(attrip);
+				spin_lock(&ailp->ail_lock);
+				break;
+			}
+		}
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+	}
+
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->ail_lock);
+
+	return 0;
+}
+
 /*
  * This routine is called to create an in-core extent rmap update
  * item from the rui format structure which was logged on disk.
@@ -4050,6 +4164,8 @@ xlog_recover_ra_pass2(
 		break;
 	case XFS_LI_EFI:
 	case XFS_LI_EFD:
+	case XFS_LI_ATTRI:
+	case XFS_LI_ATTRD:
 	case XFS_LI_QUOTAOFF:
 	case XFS_LI_RUI:
 	case XFS_LI_RUD:
@@ -4078,6 +4194,8 @@ xlog_recover_commit_pass1(
 	case XFS_LI_INODE:
 	case XFS_LI_EFI:
 	case XFS_LI_EFD:
+	case XFS_LI_ATTRI:
+	case XFS_LI_ATTRD:
 	case XFS_LI_DQUOT:
 	case XFS_LI_ICREATE:
 	case XFS_LI_RUI:
@@ -4116,6 +4234,10 @@ xlog_recover_commit_pass2(
 		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
 	case XFS_LI_EFD:
 		return xlog_recover_efd_pass2(log, item);
+	case XFS_LI_ATTRI:
+		return xlog_recover_attri_pass2(log, item, trans->r_lsn);
+	case XFS_LI_ATTRD:
+		return xlog_recover_attrd_pass2(log, item);
 	case XFS_LI_RUI:
 		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_RUD:
@@ -4677,6 +4799,49 @@ xlog_recover_cancel_efi(
 	spin_lock(&ailp->ail_lock);
 }
 
+/* Release the ATTRI since we're cancelling everything. */
+STATIC void
+xlog_recover_cancel_attri(
+	struct xfs_mount                *mp,
+	struct xfs_ail                  *ailp,
+	struct xfs_log_item             *lip)
+{
+	struct xfs_attri_log_item         *attrip;
+
+	attrip = container_of(lip, struct xfs_attri_log_item, item);
+
+	spin_unlock(&ailp->ail_lock);
+	xfs_attri_release(attrip);
+	spin_lock(&ailp->ail_lock);
+}
+
+
+/* Recover the ATTRI if necessary. */
+STATIC int
+xlog_recover_process_attri(
+	struct xfs_mount                *mp,
+	struct xfs_ail                  *ailp,
+	struct xfs_log_item             *lip,
+	struct xfs_defer_ops            *dfops)
+{
+	struct xfs_attri_log_item       *attrip;
+	int                             error;
+
+	/*
+	 * Skip ATTRIs that we've already processed.
+	 */
+	attrip = container_of(lip, struct xfs_attri_log_item, item);
+	if (test_bit(XFS_ATTRI_RECOVERED, &attrip->flags))
+		return 0;
+
+	spin_unlock(&ailp->ail_lock);
+	error = xfs_attri_recover(mp, attrip, dfops);
+	spin_lock(&ailp->ail_lock);
+
+	return error;
+}
+
+
 /* Recover the RUI if necessary. */
 STATIC int
 xlog_recover_process_rui(
@@ -4807,6 +4972,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	case XFS_LI_RUI:
 	case XFS_LI_CUI:
 	case XFS_LI_BUI:
+	case XFS_LI_ATTRI:
 		return true;
 	default:
 		return false;
@@ -4920,6 +5086,10 @@ xlog_recover_process_intents(
 		case XFS_LI_EFI:
 			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_ATTRI:
+			error = xlog_recover_process_attri(log->l_mp,
+							   ailp, lip, &dfops);
+			break;
 		case XFS_LI_RUI:
 			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
 			break;
@@ -4989,6 +5159,9 @@ xlog_recover_cancel_intents(
 		case XFS_LI_BUI:
 			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_ATTRI:
+			xlog_recover_cancel_attri(log->l_mp, ailp, lip);
+			break;
 		}
 
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0492436..3723d50 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -137,6 +137,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
 }
 
 #endif /* __XFS_ONDISK_H */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d714240..dce3baf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2077,6 +2077,7 @@ init_xfs_fs(void)
 	xfs_rmap_update_init_defer_op();
 	xfs_refcount_update_init_defer_op();
 	xfs_bmap_update_init_defer_op();
+	xfs_attr_init_defer_op();
 
 	xfs_dir_startup();
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9d542df..deaae6b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -40,6 +40,9 @@ struct xfs_cud_log_item;
 struct xfs_defer_ops;
 struct xfs_bui_log_item;
 struct xfs_bud_log_item;
+struct xfs_attrd_log_item;
+struct xfs_attri_log_item;
+
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
@@ -223,12 +226,23 @@ void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 
 void		xfs_extent_free_init_defer_op(void);
+void            xfs_attr_init_defer_op(void);
+
 struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
 				  struct xfs_efi_log_item *,
 				  uint);
 int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
 				      xfs_extlen_t, struct xfs_owner_info *);
+struct xfs_attrd_log_item *
+xfs_trans_get_attrd(struct xfs_trans *tp,
+		    struct xfs_attri_log_item *attrip);
+int xfs_trans_attr(struct xfs_trans *tp, struct xfs_defer_ops *dfops,
+			struct xfs_attrd_log_item *attrdp,
+			struct xfs_inode *ip, uint32_t attr_op_flags,
+			uint32_t flags, uint32_t name_len, uint32_t value_len,
+			char *name, char *value);
+
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
diff --git a/fs/xfs/xfs_trans_attr.c b/fs/xfs/xfs_trans_attr.c
new file mode 100644
index 0000000..7296414
--- /dev/null
+++ b/fs/xfs/xfs_trans_attr.c
@@ -0,0 +1,285 @@
+/*
+ * Copyright (c) 2017, Oracle Inc.
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
+ * along with this program; if not, write the Free Software Foundation Inc.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_attr_item.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_trace.h"
+#include "libxfs/xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_quota.h"
+
+/*
+ * This routine is called to allocate an "extent free done"
+ * log item that will hold nextents worth of extents.  The
+ * caller must use all nextents extents, because we are not
+ * flexible about this at all.
+ */
+struct xfs_attrd_log_item *
+xfs_trans_get_attrd(struct xfs_trans		*tp,
+		  struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_attrd_log_item			*attrdp;
+
+	ASSERT(tp != NULL);
+
+	attrdp = xfs_attrd_init(tp->t_mountp, attrip);
+	ASSERT(attrdp != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &attrdp->item);
+	return attrdp;
+}
+
+/*
+ * Delete an attr and log it to the ATTRD. Note that the transaction is marked
+ * dirty regardless of whether the attr delete succeeds or fails to support the
+ * ATTRI/ATTRD lifecycle rules.
+ */
+int
+xfs_trans_attr(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dfops,
+	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_inode		*ip,
+	uint32_t			op_flags,
+	uint32_t			flags,
+	uint32_t			name_len,
+	uint32_t			value_len,
+	char				*name,
+	char				*value)
+{
+	int				error;
+	int				local;
+	struct xfs_da_args		args;
+	xfs_fsblock_t			firstblock = NULLFSBLOCK;
+	struct xfs_buf			*leaf_bp = NULL;
+
+	error = xfs_attr_args_init(&args, ip, name, flags);
+	if (error)
+		goto out;
+
+	args.name = name;
+	args.namelen = name_len;
+	args.hashval = xfs_da_hashname(args.name, args.namelen);
+	args.value = value;
+	args.valuelen = value_len;
+	args.dfops = dfops;
+	args.firstblock = &firstblock;
+	args.op_flags = XFS_DA_OP_OKNOENT;
+	args.total = xfs_attr_calc_size(&args, &local);
+	args.trans = tp;
+	ASSERT(local);
+
+	error = xfs_qm_dqattach_locked(ip, 0);
+	if (error)
+		return error;
+
+	xfs_trans_ijoin(args.trans, ip, 0);
+	switch (op_flags) {
+		case XFS_ATTR_OP_FLAGS_SET:
+			args.op_flags |= XFS_DA_OP_ADDNAME;
+			error = xfs_attr_set_args(&args, flags,
+						  leaf_bp, false);
+			break;
+		case XFS_ATTR_OP_FLAGS_REMOVE:
+			ASSERT(XFS_IFORK_Q((ip)));
+			error = xfs_attr_remove_args(&args, flags, false);
+			break;
+		default:
+			error = -EFSCORRUPTED;
+	}
+
+out:
+	if (error) {
+		if (leaf_bp)
+			xfs_trans_brelse(args.trans, leaf_bp);
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	attrdp->item.li_desc->lid_flags |= XFS_LID_DIRTY;
+	attrdp->name = name;
+	attrdp->value = value;
+	attrdp->name_len = name_len;
+	attrdp->value_len = value_len;
+	attrdp->next_attr++;
+
+	attrdp->attrip->name = name;
+	attrdp->attrip->value = value;
+	attrdp->attrip->name_len = name_len;
+	attrdp->attrip->value_len = value_len;
+
+	return error;
+}
+
+static int
+xfs_attr_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	return 0;
+}
+
+/* Get an ATTRI. */
+STATIC void *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	struct xfs_attri_log_item		*attrip;
+
+	ASSERT(tp != NULL);
+	ASSERT(count == 1);
+
+	attrip = xfs_attri_init(tp->t_mountp);
+	ASSERT(attrip != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &attrip->item);
+	return attrip;
+}
+
+/* Log an attr to the intent item. */
+STATIC void
+xfs_attr_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+	struct xfs_attri_log_item	*attrip = intent;
+	struct xfs_attr_item		*free;
+	struct xfs_attri_log_format	*attrp;
+	char				*name_value;
+
+	free = container_of(item, struct xfs_attr_item, xattri_list);
+	name_value = ((char *)free) + sizeof(struct xfs_attr_item);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	attrip->item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	attrp = &attrip->format;
+	attrp->alfi_ino = free->xattri_ip->i_ino;
+	attrp->alfi_op_flags = free->xattri_op_flags;
+	attrp->alfi_value_len = free->xattri_value_len;
+	attrp->alfi_name_len = free->xattri_name_len;
+	attrp->alfi_attr_flags = free->xattri_flags;
+
+	attrip->name = name_value;
+	attrip->value = &name_value[free->xattri_name_len];
+	attrip->name_len = free->xattri_name_len;
+	attrip->value_len = free->xattri_value_len;
+}
+
+/* Get an ATTRD so we can process all the attrs. */
+STATIC void *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return xfs_trans_get_attrd(tp, intent);
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dop,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_attr_item		*free;
+	char				*name_value;
+	int				error;
+
+	free = container_of(item, struct xfs_attr_item, xattri_list);
+	name_value = ((char *)free) + sizeof(struct xfs_attr_item);
+	error = xfs_trans_attr(tp, dop, done_item,
+			free->xattri_ip,
+			free->xattri_op_flags,
+			free->xattri_flags,
+			free->xattri_name_len,
+			free->xattri_value_len,
+			name_value,
+			&name_value[free->xattri_name_len]);
+	kmem_free(free);
+	return error;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	void				*intent)
+{
+	xfs_attri_release(intent);
+}
+
+/* Cancel an attr */
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_item	*free;
+
+	free = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(free);
+}
+
+static const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.type		= XFS_DEFER_OPS_TYPE_ATTR,
+	.max_items	= XFS_ATTRI_MAX_FAST_ATTRS,
+	.diff_items	= xfs_attr_diff_items,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.log_item	= xfs_attr_log_item,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+};
+
+/* Register the deferred op type. */
+void
+xfs_attr_init_defer_op(void)
+{
+	xfs_defer_init_op_type(&xfs_attr_defer_type);
+}
-- 
2.7.4

