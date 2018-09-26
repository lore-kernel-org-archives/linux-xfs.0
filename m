Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbeIZQiD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANw3B073271
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:47 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mnd5thjrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:46 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPjSu004721
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:46 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPjPY018418
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:45 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 07/30] xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date: Wed, 26 Sep 2018 03:23:10 -0700
Message-Id: <1537957413-10630-8-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

These routines set up set and start a new deferred attribute
operation.  These functions are meant to be called by other
code needing to initiate a deferred attribute operation.  We
will use these routines later in the parent pointer patches.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_attr.h |  7 +++++
 2 files changed, 87 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 566a617..d50b5a1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -25,6 +25,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
 
 /*
  * xfs_attr.c
@@ -442,6 +443,52 @@ out:
 	return error;
 }
 
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_inode	*dp,
+	struct xfs_trans	*tp,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const unsigned char	*value,
+	unsigned int		valuelen,
+	int			flags)
+{
+
+	struct xfs_attr_item	*new;
+	char			*name_value;
+
+	/*
+	 * All set operations must have a name
+	 * but not necessarily a value.
+	 * Generic 062
+	 */
+	if (!namelen) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, valuelen),
+			 KM_SLEEP|KM_NOFS);
+	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
+	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, valuelen));
+	new->xattri_ip = dp;
+	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_SET;
+	new->xattri_name_len = namelen;
+	new->xattri_value_len = valuelen;
+	new->xattri_flags = flags;
+	memcpy(&name_value[0], name, namelen);
+	new->xattri_name = name_value;
+	new->xattri_value = name_value + namelen;
+
+	if (valuelen > 0)
+		memcpy(&name_value[namelen], value, valuelen);
+
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
@@ -525,6 +572,39 @@ out:
 	return error;
 }
 
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_inode        *dp,
+	struct xfs_trans	*tp,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	int                     flags)
+{
+
+	struct xfs_attr_item	*new;
+	char			*name_value;
+
+	if (!namelen) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, 0), KM_SLEEP|KM_NOFS);
+	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
+	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, 0));
+	new->xattri_ip = dp;
+	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
+	new->xattri_name_len = namelen;
+	new->xattri_value_len = 0;
+	new->xattri_flags = flags;
+	memcpy(name_value, name, namelen);
+
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 39a7a26..6e546a1 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -168,5 +168,12 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
 		       const unsigned char *name, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
+			  const unsigned char *name, unsigned int name_len,
+			  const unsigned char *value, unsigned int valuelen,
+			  int flags);
+int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
+			    const unsigned char *name, unsigned int namelen,
+			    int flags);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4
