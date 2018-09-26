Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48556 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbeIZQiC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANpE1037052
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:45 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2mnvtur9bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:45 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPigg004665
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:45 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPieF032123
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:44 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 06/30] xfsprogs: Set up infastructure for deferred attribute operations
Date: Wed, 26 Sep 2018 03:23:09 -0700
Message-Id: <1537957413-10630-7-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
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

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c       |  5 +++--
 libxfs/xfs_attr.h       | 26 +++++++++++++++++++++++++-
 libxfs/xfs_defer.h      |  1 +
 libxfs/xfs_log_format.h | 44 ++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_types.h      |  1 +
 5 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d31560d..566a617 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -24,6 +24,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_attr_item.h"
 
 /*
  * xfs_attr.c
@@ -57,7 +58,7 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
 
-STATIC int
+int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
@@ -153,7 +154,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index c7a194c..39a7a26 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -75,6 +75,28 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 } attrlist_ent_t;
 
 /*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_inode  *xattri_ip;
+	uint32_t	  xattri_op_flags;
+	void*		  xattri_value;	      /* attr value */
+	uint32_t	  xattri_value_len;   /* length of value */
+	void*		  xattri_name;	      /* attr name */
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
@@ -143,6 +165,8 @@ int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
-
+int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
+		       const unsigned char *name, int flags);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 2584a5b..326fa2b 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -31,6 +31,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index e5f97c6..76d42e6 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -117,7 +117,12 @@ struct xfs_unmount_log_format {
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
@@ -240,6 +245,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_CUD		0x1243
 #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
 #define	XFS_LI_BUD		0x1245
+#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
+#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -255,7 +262,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
 	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
-	{ XFS_LI_BUD,		"XFS_LI_BUD" }
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
+	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -853,4 +862,35 @@ struct xfs_icreate_log {
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
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index b9e6c89..6f33dd6 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -11,6 +11,7 @@ typedef uint32_t	prid_t;		/* project ID */
 typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
+typedef uint32_t	xfs_attrlen_t;	/* attr length */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
 typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
 typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
-- 
2.7.4
