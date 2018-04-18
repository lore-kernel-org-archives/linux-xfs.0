Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752308AbeDRWNt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 18:13:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3IMC9O9154838
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 22:13:49 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2hdrxncudw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 22:13:48 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3IMDmfm031494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 22:13:48 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3IMDm0o005625
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 22:13:48 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 04/18] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date: Wed, 18 Apr 2018 15:11:12 -0700
Message-Id: <1524089486-22922-5-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1524089486-22922-1-git-send-email-allison.henderson@oracle.com>
References: <1524089486-22922-1-git-send-email-allison.henderson@oracle.com>
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
 fs/xfs/libxfs/xfs_attr.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr.h |  5 ++++
 2 files changed, 75 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 338abd6..5acf6e7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -504,6 +504,43 @@ xfs_attr_set(
 	return error;
 }
 
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_inode	*dp,
+	struct xfs_defer_ops    *dfops,
+	void			*name,
+	unsigned int		namelen,
+	void			*value,
+	unsigned int		valuelen,
+	int			flags)
+{
+
+	struct xfs_attr_item	*new;
+	char			*name_value;
+
+	if (!namelen || !valuelen) {
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
+	memcpy(&name_value[namelen], value, valuelen);
+
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
@@ -581,6 +618,39 @@ xfs_attr_remove(
 	return error;
 }
 
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_inode        *dp,
+	struct xfs_defer_ops    *dfops,
+	void			*name,
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
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index e3f6cc8..924bf7c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -183,5 +183,10 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
 		       const unsigned char *name, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
+			  void *name, unsigned int name_len, void *value,
+			  unsigned int valuelen, int flags);
+int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
+			    void *name, unsigned int namelen, int flags);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4

