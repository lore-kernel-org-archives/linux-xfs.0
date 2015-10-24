Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E4617F6F
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 16:16:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 561CB8F8040
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yLBNbLTJfIsLCw8v (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:22 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 300AF8F2FE
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 21:16:22 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4/4] xfs: SGI ACLs: Prepare for richacls
Date: Sat, 24 Oct 2015 23:16:09 +0200
Message-Id: <1445721369-25679-5-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

In case an inode has trusted.SGI_ACL_* attributes but POSIX ACLs are not
enabled, treat those attributes as normal trusted attributes and bypass the
get_acl and set_acl inode operations to prevent corrupting inode->i_mode,
inode->i_acl, or inode->i_default_acl.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_acl.c   |  5 +++++
 fs/xfs/xfs_xattr.c |  5 +++--
 fs/xfs/xfs_xattr.h | 28 ++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/xfs_xattr.h

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 64ffb85..bee1493 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -21,6 +21,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_xattr.h"
 #include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
@@ -319,6 +320,8 @@ xfs_xattr_acl_get(struct dentry *dentry, const char *name,
 	struct posix_acl *acl;
 	int error;
 
+	if (!IS_POSIXACL(inode))
+		return xfs_xattr_get(dentry, name, value, size, type);
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 
@@ -350,6 +353,8 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
 	struct posix_acl *acl = NULL;
 	int error;
 
+	if (!IS_POSIXACL(inode))
+		return xfs_xattr_set(dentry, name, value, size, flags, type);
 	if (!inode->i_op->set_acl)
 		return -EOPNOTSUPP;
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 7534cb5..78540c3 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -25,13 +25,14 @@
 #include "xfs_inode.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_xattr.h"
 #include "xfs_acl.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
 
 
-static int
+int
 xfs_xattr_get(struct dentry *dentry, const char *name,
 		void *value, size_t size, int xflags)
 {
@@ -53,7 +54,7 @@ xfs_xattr_get(struct dentry *dentry, const char *name,
 	return asize;
 }
 
-static int
+int
 xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags, int xflags)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
new file mode 100644
index 0000000..69560052
--- /dev/null
+++ b/fs/xfs/xfs_xattr.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c) 2001-2005 Silicon Graphics, Inc.
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
+#ifndef __XFS_XATTR_H__
+#define __XFS_XATTR_H__
+
+struct dentry;
+
+extern int xfs_xattr_get(struct dentry *dentry, const char *name, void *value,
+			 size_t size, int xflags);
+extern int xfs_xattr_set(struct dentry *dentry, const char *name,
+			 const void *value, size_t size, int flags, int xflags);
+
+#endif	/* __XFS_XATTR_H__ */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
