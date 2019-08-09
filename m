Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfHIViS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYjOg072235
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:17 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNUOs056397
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u8pj9m4gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:17 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcGlB002183
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:16 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v1 04/19] xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date: Fri,  9 Aug 2019 14:37:49 -0700
Message-Id: <20190809213804.32628-5-allison.henderson@oracle.com>
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

These routines set up set and start a new deferred attribute
operation.  These functions are meant to be called by other
code needing to initiate a deferred attribute operation.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_attr.h |  5 ++++
 2 files changed, 79 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 99a3a31..4690538 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -26,6 +26,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
 
 /*
  * xfs_attr.c
@@ -400,6 +401,48 @@ out_trans_cancel:
 	goto out_unlock;
 }
 
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_inode	*dp,
+	struct xfs_trans	*tp,
+	struct xfs_name		*name,
+	const unsigned char	*value,
+	unsigned int		valuelen)
+{
+
+	struct xfs_attr_item	*new;
+	char			*name_value;
+
+	/*
+	 * All set operations must have a name but not necessarily a value.
+	 */
+	if (!name->len) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(name->len, valuelen),
+			 KM_SLEEP|KM_NOFS);
+	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
+	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(name->len, valuelen));
+	new->xattri_ip = dp;
+	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_SET;
+	new->xattri_name_len = name->len;
+	new->xattri_value_len = valuelen;
+	new->xattri_flags = name->type;
+	memcpy(&name_value[0], name->name, name->len);
+	new->xattri_name = name_value;
+	new->xattri_value = name_value + name->len;
+
+	if (valuelen > 0)
+		memcpy(&name_value[name->len], value, valuelen);
+
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
@@ -481,6 +524,37 @@ out:
 	return error;
 }
 
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_inode        *dp,
+	struct xfs_trans	*tp,
+	struct xfs_name		*name)
+{
+
+	struct xfs_attr_item	*new;
+	char			*name_value;
+
+	if (!name->len) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(name->len, 0), KM_SLEEP|KM_NOFS);
+	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
+	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(name->len, 0));
+	new->xattri_ip = dp;
+	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
+	new->xattri_name_len = name->len;
+	new->xattri_value_len = 0;
+	new->xattri_flags = name->type;
+	memcpy(name_value, name->name, name->len);
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
index 7089a80..f4efa7c 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -171,5 +171,10 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
 		       struct xfs_name *name);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
+			  struct xfs_name *name, const unsigned char *value,
+			  unsigned int valuelen);
+int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
+			    struct xfs_name *name);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4
