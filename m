Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31646 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdJFWIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 18:08:32 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v96M8UQm009077
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Oct 2017 22:08:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v96M8UsD014797
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Oct 2017 22:08:30 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v96M8UU0014775
        for <linux-xfs@vger.kernel.org>; Fri, 6 Oct 2017 22:08:30 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 03/17] Add xfs_attr_set_defered and xfs_attr_remove_defered
Date: Fri,  6 Oct 2017 15:05:34 -0700
Message-Id: <1507327548-3221-4-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1507327548-3221-1-git-send-email-allison.henderson@oracle.com>
References: <1507327548-3221-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
:100644 100644 5325ec2... 5c9b604... M	fs/xfs/libxfs/xfs_attr.c
:100644 100644 06c4081... 67b0fbf... M	fs/xfs/xfs_attr.h
 fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr.h        |  5 +++++
 2 files changed, 63 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5325ec2..5c9b604 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -458,6 +458,37 @@ xfs_attr_set(
 	return error;
 }
 
+int
+xfs_attr_set_defered(
+	struct xfs_inode	*dp,
+	struct xfs_defer_ops    *dfops,
+	const unsigned char	*name,
+	int			namelen,
+	unsigned char		*value,
+	int			valuelen,
+	int			flags)
+{
+
+	struct xfs_attr_item     *new;
+
+	ASSERT(name != NULL);
+	ASSERT(value != NULL);
+
+	new = kmem_alloc(sizeof(struct xfs_attr_item), KM_SLEEP);
+	memset(new, 0, sizeof(struct xfs_attr_item));
+	new->xattri_ino = dp->i_ino;
+	new->xattri_op_flags = ATTR_OP_FLAGS_SET;
+	new->xattri_name_len = namelen;
+	new->xattri_nameval_len = namelen + valuelen;
+	new->xattri_flags = flags;
+	memcpy(new->xattri_nameval, name, namelen);
+	memcpy(&new->xattri_nameval[namelen], value, valuelen);
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
+xfs_attr_remove_defered(
+	struct xfs_inode        *dp,
+	struct xfs_defer_ops    *dfops,
+	const unsigned char     *name,
+	int			namelen,
+	int                     flags)
+{
+
+	struct xfs_attr_item     *new;
+
+	ASSERT(name != NULL);
+
+	new = kmem_alloc(sizeof(struct xfs_attr_item), KM_SLEEP);
+	memset(new, 0, sizeof(struct xfs_attr_item));
+	new->xattri_ino = dp->i_ino;
+	new->xattri_op_flags = ATTR_OP_FLAGS_REMOVE;
+	new->xattri_name_len = namelen;
+	new->xattri_nameval_len = namelen;
+	new->xattri_flags = flags;
+	memcpy(new->xattri_nameval, name, namelen);
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
index 06c4081..67b0fbf 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -176,5 +176,10 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
 		       const unsigned char *name, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_defered(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
+			 const unsigned char *name, int name_len,
+			 unsigned char *value, int valuelen, int flags);
+int xfs_attr_remove_defered(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
+			    const unsigned char *name, int namelen, int flags);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4

