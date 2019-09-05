Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CA6C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D2B720825
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NDg40j4T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389589AbfIEWTm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33810 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391184AbfIEWTl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ7NH078078
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=/Nv2mCRdcwYrmpme4IXDnoRQVuNc0xvqfLXeEtunnLs=;
 b=NDg40j4TK9wVHCvnvV/akEpo8nU0PFrk2gIa0nVC1SPgdtTaNOtVwIXTJXeomWa5lyGf
 OkPjCttYN174puNhG7SUDnC/53eJuFYEqOF5xxErnQgs+W6/FJgpVxoy8A8jKTzOZX9H
 3Jvi7dvdKXuWCLVCsQ0qmi/OoGntxOaZb73eMzo1Nlh6pf9dVZQu9u8dpsupzPxIG9sS
 rNoaYQgsnaHNRG13CDGlEl/paKSu8m8C20sOcJIKi9XUHaGxnDL7Uheh4WREhuTryCKO
 5SN9HrICf8prmdq3qnStQGYgXkHVszgEdetl1doPf7lX6b4h7JDNSEYDXsewLEMaVRWV Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uuaqj02r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIe4g123387
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uthq27va8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:37 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MImuW008699
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:48 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:48 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 15/19] xfs: Set up infastructure for deferred attribute operations
Date:   Thu,  5 Sep 2019 15:18:33 -0700
Message-Id: <20190905221837.17388-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221837.17388-1-allison.henderson@oracle.com>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Currently attributes are modified directly across one or more
transactions.  But they are not logged or replayed in the event of
an error. The goal of delayed attributes is to enable logging and
replaying of attribute operations using the existing delayed
operations infrastructure.  This will later enable the attributes
to become part of larger multi part operations that also must first
be recorded to the log.  This is mostly of interest in the scheme of
parent pointers which would need to maintain an attribute containing
parent inode information any time an inode is moved, created, or
removed.  Parent pointers would then be of interest to any feature
that would need to quickly derive an inode path from the mount
point.  Online scrub, nfs lookups and fs grow or shrink operations
are all features that could take advantage of this.

This patch adds two new log item types for setting or removing
attributes as deferred operations.  The xfs_attri_log_item logs an
intent to set or remove an attribute.  The corresponding
xfs_attrd_log_item holds a reference to the xfs_attri_log_item and
is freed once the transaction is done.  Both log items use a generic
xfs_attr_log_format structure that contains the attribute name,
value, flags, inode, and an op_flag that indicates if the operations
is a set or remove.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/Makefile                |   2 +-
 fs/xfs/libxfs/xfs_attr.c       |   5 +-
 fs/xfs/libxfs/xfs_attr.h       |  33 ++
 fs/xfs/libxfs/xfs_defer.c      |   1 +
 fs/xfs/libxfs/xfs_defer.h      |   3 +
 fs/xfs/libxfs/xfs_log_format.h |  44 ++-
 fs/xfs/libxfs/xfs_types.h      |   1 +
 fs/xfs/xfs_attr_item.c         | 756 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h         |  88 +++++
 fs/xfs/xfs_log.c               |   4 +
 fs/xfs/xfs_log_recover.c       | 173 ++++++++++
 fs/xfs/xfs_ondisk.h            |   2 +
 fs/xfs/xfs_trans.h             |   1 -
 13 files changed, 1107 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 06b68b6..70b4716 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_bmap_item.o \
 				   xfs_buf_item.o \
 				   xfs_extfree_item.o \
+				   xfs_attr_item.o \
 				   xfs_icreate_item.o \
 				   xfs_inode_item.o \
 				   xfs_refcount_item.o \
@@ -109,7 +110,6 @@ xfs-y				+= xfs_log.o \
 				   xfs_log_recover.o \
 				   xfs_trans_ail.o \
 				   xfs_trans_buf.o
-
 # optional features
 xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 				   xfs_dquot_item.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 310f5b2..7680789 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -24,6 +24,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_attr_item.h"
 
 /*
  * xfs_attr.c
@@ -63,7 +64,7 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
-STATIC int
+int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
@@ -190,7 +191,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 6203766..1e0c25e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -80,6 +80,36 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 } attrlist_ent_t;
 
 /*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_inode	*xattri_ip;
+	void			*xattri_value;		/* attr value */
+	void			*xattri_name;		/* attr name */
+	uint32_t		xattri_op_flags;	/* attr op set or rm */
+	uint32_t		xattri_value_len;	/* length of value */
+	uint32_t		xattri_name_len;	/* length of name */
+	uint32_t		xattri_flags;		/* attr flags */
+
+	/* used to log this item to an intent */
+	struct list_head	xattri_list;
+
+	/*
+	 * xfs_da_args needs to remain instantiated across transaction rolls
+	 * during the defer finish, so store it here
+	 */
+	struct xfs_da_args	xattri_args;
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
@@ -157,5 +187,8 @@ int xfs_attr_remove_later(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
+int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
+		       struct xfs_name *name);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 2255752..6749022 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -176,6 +176,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7c28d76..b9ff7b9 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -17,6 +17,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
@@ -60,5 +61,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_attr_defer_type;
+
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5f97c6..acdb8ad 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,12 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_CUD_FORMAT	24
 #define XLOG_REG_TYPE_BUI_FORMAT	25
 #define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_MAX		26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_MAX		30
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 300b3e9..ade55d4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -11,6 +11,7 @@ typedef uint32_t	prid_t;		/* project ID */
 typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
+typedef uint32_t	xfs_attrlen_t;	/* attr length */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
 typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
 typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
new file mode 100644
index 0000000..a4abcf3
--- /dev/null
+++ b/fs/xfs/xfs_attr_item.c
@@ -0,0 +1,756 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Allison Collins <allison.henderson@oracle.com>
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
+#include "xfs_attr_item.h"
+#include "xfs_log.h"
+#include "xfs_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_shared.h"
+#include "xfs_attr_item.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_trace.h"
+#include "libxfs/xfs_da_format.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
+
+/*
+ * This routine is called to allocate an "attr free done" log item.
+ */
+struct xfs_attrd_log_item *
+xfs_trans_get_attrd(struct xfs_trans		*tp,
+		  struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_attrd_log_item		*attrdp;
+
+	ASSERT(tp != NULL);
+
+	attrdp = xfs_attrd_init(tp->t_mountp, attrip);
+	ASSERT(attrdp != NULL);
+
+	xfs_trans_add_item(tp, &attrdp->attrd_item);
+	return attrdp;
+}
+
+/*
+ * Log an ATTRI it to the ATTRD when the attr op is done.  An attr operation
+ * may be a set or a remove.  Note that the transaction is marked dirty
+ * regardless of whether the operation succeeds or fails to support the
+ * ATTRI/ATTRD lifecycle rules.
+ */
+int
+xfs_trans_attr(
+	struct xfs_da_args		*args,
+	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
+	uint32_t			op_flags)
+{
+	int				error;
+
+	error = xfs_qm_dqattach_locked(args->dp, 0);
+	if (error)
+		return error;
+
+	switch (op_flags) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+		error = xfs_attr_set_later(args, leaf_bp);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q((args->dp)));
+		error = xfs_attr_remove_later(args);
+		break;
+	default:
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
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
+	struct xfs_attri_log_item	*attrip;
+
+	ASSERT(tp != NULL);
+	ASSERT(count == 1);
+
+	attrip = xfs_attri_init(tp->t_mountp);
+	ASSERT(attrip != NULL);
+
+	xfs_trans_add_item(tp, &attrip->attri_item);
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
+	struct xfs_attr_item		*attr;
+	struct xfs_attri_log_format	*attrp;
+	char				*name_value;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
+
+	/*
+	 * At this point the xfs_attr_item has been constructed, and we've
+	 * created the log intent. Fill in the attri log item and log format
+	 * structure with fields from this xfs_attr_item
+	 */
+	attrp = &attrip->attri_format;
+	attrp->alfi_ino = attr->xattri_ip->i_ino;
+	attrp->alfi_op_flags = attr->xattri_op_flags;
+	attrp->alfi_value_len = attr->xattri_value_len;
+	attrp->alfi_name_len = attr->xattri_name_len;
+	attrp->alfi_attr_flags = attr->xattri_flags;
+
+	attrip->attri_name = name_value;
+	attrip->attri_value = &name_value[attr->xattri_name_len];
+	attrip->attri_name_len = attr->xattri_name_len;
+	attrip->attri_value_len = attr->xattri_value_len;
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
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_attr_item		*attr;
+	char				*name_value;
+	int				error;
+	int				local;
+	struct xfs_da_args		*args;
+	struct xfs_name			name;
+	struct xfs_attrd_log_item	*attrdp;
+	struct xfs_attri_log_item	*attrip;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	args = &attr->xattri_args;
+
+	name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
+	name.name = name_value;
+	name.len = attr->xattri_name_len;
+	name.type = attr->xattri_flags;
+
+	if (!(args->dc.flags & XFS_DC_INIT)) {
+		/* Only need to initialize args context once */
+		error = xfs_attr_args_init(args, attr->xattri_ip, &name);
+		if (error)
+			goto out;
+
+		args->hashval = xfs_da_hashname(args->name.name,
+						args->name.len);
+		args->value = &name_value[attr->xattri_name_len];
+		args->valuelen = attr->xattri_value_len;
+		args->op_flags = XFS_DA_OP_OKNOENT;
+
+		/* must match existing transaction block res */
+		args->total = xfs_attr_calc_size(args, &local);
+		args->dc.flags |= XFS_DC_INIT;
+	}
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	args->trans = tp;
+
+	error = xfs_trans_attr(args, done_item,	&args->dc.leaf_bp,
+			       attr->xattri_op_flags);
+out:
+	/*
+	 * The attrip refers to xfs_attr_item memory to log the name and value
+	 * with the intent item. This already occurred when the intent was
+	 * committed so these fields are no longer accessed. Clear them out of
+	 * caution since we're about to free the xfs_attr_item.
+	 */
+	attrdp = (struct xfs_attrd_log_item *)done_item;
+	attrip = attrdp->attrd_attrip;
+	attrip->attri_name = NULL;
+	attrip->attri_value = NULL;
+
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
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
+	struct xfs_attr_item	*attr;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(attr);
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= 1,
+	.diff_items	= xfs_attr_diff_items,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.log_item	= xfs_attr_log_item,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+};
+
+static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attri_log_item, attri_item);
+}
+
+void
+xfs_attri_item_free(
+	struct xfs_attri_log_item	*attrip)
+{
+	kmem_free(attrip->attri_item.li_lv_shadow);
+	kmem_free(attrip);
+}
+
+/*
+ * This returns the number of iovecs needed to log the given attri item. We
+ * only need 1 iovec for an attri item.  It just logs the attr_log_format
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
+	/* Attr set and remove operations require a name */
+	ASSERT(attrip->attri_name_len > 0);
+
+	*nvecs += 1;
+	*nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
+
+	/*
+	 * Set ops can accept a value of 0 len to clear an attr value.  Remove
+	 * ops do not need a value at all.  So only account for the value
+	 * when it is needed.
+	 */
+	if (attrip->attri_value_len > 0) {
+		*nvecs += 1;
+		*nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
+	}
+}
+
+/*
+ * This is called to fill in the log iovecs for the given attri log
+ * item. We use  1 iovec for the attri_format_item, 1 for the name, and
+ * another for the value if it is present
+ */
+STATIC void
+xfs_attri_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_log_iovec		*vecp = NULL;
+
+	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
+	attrip->attri_format.alfi_size = 1;
+
+	/*
+	 * This size accounting must be done before copying the attrip into the
+	 * iovec.  If we do it after, the wrong size will be recorded to the log
+	 * and we trip across assertion checks for bad region sizes later during
+	 * the log recovery.
+	 */
+
+	ASSERT(attrip->attri_name_len > 0);
+	attrip->attri_format.alfi_size++;
+
+	if (attrip->attri_value_len > 0)
+		attrip->attri_format.alfi_size++;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
+			&attrip->attri_format,
+			xfs_attri_item_sizeof(attrip));
+	if (attrip->attri_name_len > 0)
+		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
+				attrip->attri_name,
+				ATTR_NVEC_SIZE(attrip->attri_name_len));
+
+	if (attrip->attri_value_len > 0)
+		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
+				attrip->attri_value,
+				ATTR_NVEC_SIZE(attrip->attri_value_len));
+}
+
+/*
+ * The unpin operation is the last place an ATTRI is manipulated in the log. It
+ * is either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the ATTRI transaction has been successfully committed to make
+ * it this far. Therefore, we expect whoever committed the ATTRI to either
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
+STATIC void
+xfs_attri_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_attri_release(ATTRI_ITEM(lip));
+}
+
+static const struct xfs_item_ops xfs_attri_item_ops = {
+	.iop_size	= xfs_attri_item_size,
+	.iop_format	= xfs_attri_item_format,
+	.iop_unpin	= xfs_attri_item_unpin,
+	.iop_committed	= xfs_attri_item_committed,
+	.iop_push	= xfs_attri_item_push,
+	.iop_committing = xfs_attri_item_committing,
+	.iop_release    = xfs_attri_item_release,
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
+	uint				size;
+
+	size = (uint)(sizeof(struct xfs_attri_log_item));
+	attrip = kmem_zalloc(size, 0);
+
+	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
+			  &xfs_attri_item_ops);
+	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
+	atomic_set(&attrip->attri_refcount, 2);
+
+	return attrip;
+}
+
+/*
+ * Copy an attr format buffer from the given buf, and into the destination attr
+ * format structure.
+ */
+int
+xfs_attri_copy_format(struct xfs_log_iovec *buf,
+		      struct xfs_attri_log_format *dst_attr_fmt)
+{
+	struct xfs_attri_log_format *src_attr_fmt = buf->i_addr;
+	uint len = sizeof(struct xfs_attri_log_format);
+
+	if (buf->i_len != len)
+		return -EFSCORRUPTED;
+
+	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
+	return 0;
+}
+
+/*
+ * Freeing the attrip requires that we remove it from the AIL if it has already
+ * been placed there. However, the ATTRI may not yet have been placed in the
+ * AIL when called by xfs_attri_release() from ATTRD processing due to the
+ * ordering of committed vs unpin operations in bulk insert operations. Hence
+ * the reference count to ensure only the last caller frees the ATTRI.
+ */
+void
+xfs_attri_release(
+	struct xfs_attri_log_item	*attrip)
+{
+	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
+	if (atomic_dec_and_test(&attrip->attri_refcount)) {
+		xfs_trans_ail_remove(&attrip->attri_item,
+				     SHUTDOWN_LOG_IO_ERROR);
+		xfs_attri_item_free(attrip);
+	}
+}
+
+static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
+}
+
+STATIC void
+xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
+{
+	kmem_free(attrdp->attrd_item.li_lv_shadow);
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
+}
+
+/*
+ * This is called to fill in the log iovecs for the given attrd log item. We use
+ * only 1 iovec for the attrd_format, and we point that at the attr_log_format
+ * structure embedded in the attrd item.
+ */
+STATIC void
+xfs_attrd_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
+
+	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
+	attrdp->attrd_format.alfd_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
+			&attrdp->attrd_format, xfs_attrd_item_sizeof(attrdp));
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
+	xfs_attri_release(attrdp->attrd_attrip);
+	xfs_attrd_item_free(attrdp);
+
+	return NULLCOMMITLSN;
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
+ * The ATTRD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the ATTRI and free the
+ * ATTRD.
+ */
+STATIC void
+xfs_attrd_item_release(
+	struct xfs_log_item     *lip)
+{
+	struct xfs_attrd_log_item *attrdp = ATTRD_ITEM(lip);
+
+	xfs_attri_release(attrdp->attrd_attrip);
+	xfs_attrd_item_free(attrdp);
+}
+
+static const struct xfs_item_ops xfs_attrd_item_ops = {
+	.iop_size	= xfs_attrd_item_size,
+	.iop_format	= xfs_attrd_item_format,
+	.iop_committed	= xfs_attrd_item_committed,
+	.iop_push	= xfs_attrd_item_push,
+	.iop_committing = xfs_attrd_item_committing,
+	.iop_release    = xfs_attrd_item_release,
+};
+
+/*
+ * Allocate and initialize an attrd item
+ */
+struct xfs_attrd_log_item *
+xfs_attrd_init(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_item	*attrip)
+
+{
+	struct xfs_attrd_log_item	*attrdp;
+	uint				size;
+
+	size = (uint)(sizeof(struct xfs_attrd_log_item));
+	attrdp = kmem_zalloc(size, 0);
+
+	xfs_log_item_init(mp, &attrdp->attrd_item, XFS_LI_ATTRD,
+			  &xfs_attrd_item_ops);
+	attrdp->attrd_attrip = attrip;
+	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
+
+	return attrdp;
+}
+
+/*
+ * Process an attr intent item that was recovered from the log.  We need to
+ * delete the attr that it describes.
+ */
+int
+xfs_attri_recover(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_inode		*ip;
+	struct xfs_attrd_log_item	*attrdp;
+	struct xfs_da_args		args;
+	struct xfs_attri_log_format	*attrp;
+	struct xfs_trans_res		tres;
+	int				local;
+	int				error, err2 = 0;
+	int				rsvd = 0;
+	struct xfs_name			name;
+	struct xfs_buf			*leaf_bp = NULL;
+
+	ASSERT(!test_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags));
+
+	/*
+	 * First check the validity of the attr described by the ATTRI.  If any
+	 * are bad, then assume that all are bad and just toss the ATTRI.
+	 */
+	attrp = &attrip->attri_format;
+	if (!(attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET ||
+	      attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE) ||
+	    (attrp->alfi_value_len > XATTR_SIZE_MAX) ||
+	    (attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_name_len == 0)) {
+		/*
+		 * This will pull the ATTRI from the AIL and free the memory
+		 * associated with it.
+		 */
+		set_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags);
+		xfs_attri_release(attrip);
+		return -EFSCORRUPTED;
+	}
+
+	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
+	if (error)
+		return error;
+
+	name.name = attrip->attri_name;
+	name.len = attrp->alfi_name_len;
+	name.type = attrp->alfi_attr_flags;
+	error = xfs_attr_args_init(&args, ip, &name);
+	if (error)
+		goto out_rele;
+
+	args.hashval = xfs_da_hashname(args.name.name, args.name.len);
+	args.value = attrip->attri_value;
+	args.valuelen = attrp->alfi_value_len;
+	args.op_flags = XFS_DA_OP_OKNOENT;
+	args.total = xfs_attr_calc_size(&args, &local);
+
+	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+			M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
+	error = xfs_trans_alloc(mp, &tres, args.total,  0,
+				rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+	if (error)
+		goto out_rele;
+	attrdp = xfs_trans_get_attrd(args.trans, attrip);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(args.trans, ip, 0);
+
+	do {
+		error = xfs_trans_attr(&args, attrdp, &leaf_bp,
+				       attrp->alfi_op_flags);
+		if (error && error != -EAGAIN)
+			goto abort_error;
+
+		xfs_trans_log_inode(args.trans, ip,
+				XFS_ILOG_CORE | XFS_ILOG_ADATA);
+
+		err2 = xfs_trans_roll(&args.trans);
+		if (err2) {
+			error = err2;
+			goto abort_error;
+		}
+
+		/* Rejoin inode and leaf if needed */
+		xfs_trans_ijoin(args.trans, ip, 0);
+		if (leaf_bp) {
+			xfs_trans_bjoin(args.trans, leaf_bp);
+			xfs_trans_bhold(args.trans, leaf_bp);
+		}
+
+	} while (error == -EAGAIN);
+
+	error = xfs_trans_commit(args.trans);
+	if (error)
+		goto abort_error;
+
+	set_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+	return error;
+
+abort_error:
+	xfs_trans_cancel(args.trans);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out_rele:
+	xfs_irele(ip);
+	return error;
+}
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
new file mode 100644
index 0000000..0c4cd72
--- /dev/null
+++ b/fs/xfs/xfs_attr_item.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Allison Collins <allison.henderson@oracle.com>
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
+ * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
+ */
+#define	XFS_ATTRI_RECOVERED	1
+
+
+/* iovec length must be 32-bit aligned */
+#define ATTR_NVEC_SIZE(size) (size == sizeof(int32_t) ? sizeof(int32_t) : \
+				size + sizeof(int32_t) - \
+				(size % sizeof(int32_t)))
+
+/*
+ * This is the "attr intention" log item.  It is used to log the fact that some
+ * attribute operations need to be processed.  An operation is currently either
+ * a set or remove.  Set or remove operations are described by the xfs_attr_item
+ * which may be logged to this intent.  Intents are used in conjunction with the
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
+ * On allocation, both references are the responsibility of the caller. Once the
+ * ATTRI is added to and dirtied in a transaction, ownership of reference one
+ * transfers to the transaction. The reference is dropped once the ATTRI is
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
+ * inserted in the AIL, so at this point both the ATTRI and ATTRD are freed.
+ */
+struct xfs_attri_log_item {
+	struct xfs_log_item		attri_item;
+	atomic_t			attri_refcount;
+	unsigned long			attri_flags;	/* misc flags */
+	int				attri_name_len;
+	void				*attri_name;
+	int				attri_value_len;
+	void				*attri_value;
+	struct xfs_attri_log_format	attri_format;
+};
+
+/*
+ * This is the "attr done" log item.  It is used to log the fact that some attrs
+ * earlier mentioned in an attri item have been freed.
+ */
+struct xfs_attrd_log_item {
+	struct xfs_attri_log_item	*attrd_attrip;
+	struct xfs_log_item		attrd_item;
+	struct xfs_attrd_log_format	attrd_format;
+};
+
+struct xfs_attri_log_item	*xfs_attri_init(struct xfs_mount *mp);
+struct xfs_attrd_log_item	*xfs_attrd_init(struct xfs_mount *mp,
+					struct xfs_attri_log_item *attrip);
+int xfs_attri_copy_format(struct xfs_log_iovec *buf,
+			   struct xfs_attri_log_format *dst_attri_fmt);
+void			xfs_attri_item_free(struct xfs_attri_log_item *attrip);
+void			xfs_attri_release(struct xfs_attri_log_item *attrip);
+
+int			xfs_attri_recover(struct xfs_mount *mp,
+					struct xfs_attri_log_item *attrip);
+
+#endif	/* __XFS_ATTR_ITEM_H__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3e0a105..3de9e18 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2002,6 +2002,10 @@ xlog_print_tic_res(
 	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
 	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
 	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
+	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
+	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
+	    REG_TYPE_STR(ATTR_NAME, "attr_name"),
+	    REG_TYPE_STR(ATTR_VALUE, "attr_value"),
 	};
 	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
 #undef REG_TYPE_STR
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f05c6c9..11378f9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -20,6 +20,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"
+#include "xfs_attr_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
@@ -1887,6 +1888,8 @@ xlog_recover_reorder_trans(
 		case XFS_LI_CUD:
 		case XFS_LI_BUI:
 		case XFS_LI_BUD:
+		case XFS_LI_ATTRI:
+		case XFS_LI_ATTRD:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
 			list_move_tail(&item->ri_list, &inode_list);
@@ -3424,6 +3427,118 @@ xlog_recover_efd_pass2(
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
+	error = xfs_attri_copy_format(&item->ri_buf[region],
+				      &attrip->attri_format);
+	if (error) {
+		xfs_attri_item_free(attrip);
+		return error;
+	}
+
+	attrip->attri_name_len = attri_formatp->alfi_name_len;
+	attrip->attri_value_len = attri_formatp->alfi_value_len;
+	attrip = kmem_realloc(attrip, sizeof(struct xfs_attri_log_item) +
+			      attrip->attri_name_len + attrip->attri_value_len,
+			      0);
+
+	ASSERT(attrip->attri_name_len > 0);
+	region++;
+	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
+	memcpy(name, item->ri_buf[region].i_addr,
+	       attrip->attri_name_len);
+	attrip->attri_name = name;
+
+	if (attrip->attri_value_len > 0) {
+		region++;
+		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
+			attrip->attri_name_len;
+		memcpy(value, item->ri_buf[region].i_addr,
+			attrip->attri_value_len);
+		attrip->attri_value = value;
+	}
+
+	spin_lock(&log->l_ailp->ail_lock);
+	/*
+	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
+	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
+	 * directly and drop the ATTRI reference. Note that
+	 * xfs_trans_ail_update() drops the AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &attrip->attri_item, lsn);
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
+			if (attrip->attri_format.alfi_id == attri_id) {
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
@@ -3976,6 +4091,8 @@ xlog_recover_ra_pass2(
 		break;
 	case XFS_LI_EFI:
 	case XFS_LI_EFD:
+	case XFS_LI_ATTRI:
+	case XFS_LI_ATTRD:
 	case XFS_LI_QUOTAOFF:
 	case XFS_LI_RUI:
 	case XFS_LI_RUD:
@@ -4004,6 +4121,8 @@ xlog_recover_commit_pass1(
 	case XFS_LI_INODE:
 	case XFS_LI_EFI:
 	case XFS_LI_EFD:
+	case XFS_LI_ATTRI:
+	case XFS_LI_ATTRD:
 	case XFS_LI_DQUOT:
 	case XFS_LI_ICREATE:
 	case XFS_LI_RUI:
@@ -4042,6 +4161,10 @@ xlog_recover_commit_pass2(
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
@@ -4603,6 +4726,48 @@ xlog_recover_cancel_efi(
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
+	attrip = container_of(lip, struct xfs_attri_log_item, attri_item);
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
+	struct xfs_log_item             *lip)
+{
+	struct xfs_attri_log_item       *attrip;
+	int                             error;
+
+	/*
+	 * Skip ATTRIs that we've already processed.
+	 */
+	attrip = container_of(lip, struct xfs_attri_log_item, attri_item);
+	if (test_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags))
+		return 0;
+
+	spin_unlock(&ailp->ail_lock);
+	error = xfs_attri_recover(mp, attrip);
+	spin_lock(&ailp->ail_lock);
+
+	return error;
+}
+
+
 /* Recover the RUI if necessary. */
 STATIC int
 xlog_recover_process_rui(
@@ -4731,6 +4896,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	case XFS_LI_RUI:
 	case XFS_LI_CUI:
 	case XFS_LI_BUI:
+	case XFS_LI_ATTRI:
 		return true;
 	default:
 		return false;
@@ -4849,6 +5015,10 @@ xlog_recover_process_intents(
 		case XFS_LI_EFI:
 			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_ATTRI:
+			error = xlog_recover_process_attri(log->l_mp,
+							   ailp, lip);
+			break;
 		case XFS_LI_RUI:
 			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
 			break;
@@ -4914,6 +5084,9 @@ xlog_recover_cancel_intents(
 		case XFS_LI_BUI:
 			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_ATTRI:
+			xlog_recover_cancel_attri(log->l_mp, ailp, lip);
+			break;
 		}
 
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index b6701b4..120fb0c 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -125,6 +125,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
 
 	/*
 	 * The v5 superblock format extended several v4 header structures with
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f17..4dd5607 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -229,7 +229,6 @@ void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
 void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
 bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
-
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
-- 
2.7.4

