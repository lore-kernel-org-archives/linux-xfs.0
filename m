Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29884 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbdJRXAL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:00:11 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9IN0ArK002981
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 23:00:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9IN08In029121
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 23:00:08 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9IN07D2027323
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 23:00:07 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 03/17] Add xfs_attr_set_defered and xfs_attr_remove_defered
Date: Wed, 18 Oct 2017 15:55:19 -0700
Message-Id: <1508367333-3237-4-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

These routines set up set and start a new deferred attribute
operation.  These functions are meant to be called by other
code needing to initiate a deferred attribute operation.  We
will use these routines later in the parent pointer patches.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr.h        |  7 ++++++
 2 files changed, 65 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5325ec2..59f3502 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -458,6 +458,37 @@ xfs_attr_set(
 	return error;
 }
 
+int
+xfs_attr_set_deferred(
+	struct xfs_inode	*dp,
+	struct xfs_defer_ops    *dfops,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	unsigned char		*value,
+	unsigned int		valuelen,
+	int			flags)
+{
+
+	struct xfs_attr_item     *new;
+
+	ASSERT(namelen != 0);
+	ASSERT(valuelen != 0);
+
+	new = kmem_alloc(sizeof(struct xfs_attr_item), KM_SLEEP|KM_NOFS);
+	memset(new, 0, sizeof(struct xfs_attr_item));
+	new->xattri_ino = dp->i_ino;
+	new->xattri_op_flags = ATTR_OP_FLAGS_SET;
+	new->xattri_name_len = namelen;
+	new->xattri_value_len = valuelen;
+	new->xattri_flags = flags;
+	memcpy(new->xattri_name, name, namelen);
+	memcpy(&new->xattri_value, value, valuelen);
+
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
@@ -531,6 +562,33 @@ xfs_attr_remove(
 	return error;
 }
 
+int
+xfs_attr_remove_deferred(
+	struct xfs_inode        *dp,
+	struct xfs_defer_ops    *dfops,
+	const unsigned char     *name,
+	unsigned int		namelen,
+	int                     flags)
+{
+
+	struct xfs_attr_item     *new;
+
+	ASSERT(namelen != 0);
+
+	new = kmem_alloc(sizeof(struct xfs_attr_item), KM_SLEEP|KM_NOFS);
+	memset(new, 0, sizeof(struct xfs_attr_item));
+	new->xattri_ino = dp->i_ino;
+	new->xattri_op_flags = ATTR_OP_FLAGS_REMOVE;
+	new->xattri_name_len = namelen;
+	new->xattri_value_len = 0;
+	new->xattri_flags = flags;
+	memcpy(new->xattri_name, name, namelen);
+
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 34bb4cb..f4a53fd 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -173,5 +173,12 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
 		       const unsigned char *name, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
+			  const unsigned char *name, unsigned int name_len,
+			  unsigned char *value, unsigned int valuelen,
+			  int flags);
+int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
+			    const unsigned char *name, unsigned int namelen,
+			    int flags);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4

