Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47627 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760346AbdKQSYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 13:24:11 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 12/17] xfs: parent pointer attribute creation
Date: Fri, 17 Nov 2017 11:21:40 -0700
Message-Id: <1510942905-12897-13-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Allison Henderson <allison.henderson@oracle.com>

From: Dave Chinner <dchinner@redhat.com>

Add parent pointer attribute during xfs_create, and
subroutines to initialize attributes

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
	   fixed some null pointer bugs,
	   merged error handling patch,
	   added subroutines to handle attribute initialization]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
v2: remove unnecessary ENOSPC handling in xfs_attr_set_first_parent

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |  1 +
 fs/xfs/libxfs/xfs_parent.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr.h          | 15 +++++++-
 fs/xfs/xfs_inode.c         | 16 +++++++-
 4 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ec6486b..3015bca 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -52,6 +52,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_parent.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 0000000..5eec0ab
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,93 @@
+/*
+ * Copyright (c) 2015 Red Hat, Inc.
+ * All rights reserved.
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
+ * along with this program; if not, write the Free Software Foundation
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_attr.h"
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behaviour is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+			struct xfs_parent_name_rec	*rec,
+			unsigned long long int		p_ino,
+			unsigned int			p_gen,
+			unsigned int			p_diroffset)
+{
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
+/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec */
+void
+xfs_init_parent_name_irec(
+			struct xfs_parent_name_irec	*irec,
+			struct xfs_parent_name_rec	*rec)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
+/*
+ * Add a parent record to an inode with existing parent records.
+ */
+int
+xfs_parent_add(
+	struct xfs_trans        *tp,
+	struct xfs_inode        *parent,
+	struct xfs_inode        *child,
+	struct xfs_name         *child_name,
+	uint32_t                diroffset,
+	struct xfs_defer_ops    *dfops,
+	xfs_fsblock_t           *firstblock)
+{
+	struct xfs_parent_name_rec rec;
+
+	xfs_init_parent_name_rec(&rec, parent->i_ino,
+		VFS_I(parent)->i_generation, diroffset);
+
+	return xfs_attr_set_deferred(child, dfops, &rec, sizeof(rec),
+		(void *)child_name->name, child_name->len, ATTR_PARENT);
+}
+
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 1f5c711..09ef747 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -19,6 +19,8 @@
 #define	__XFS_ATTR_H__
 
 #include "libxfs/xfs_defer.h"
+#include "libxfs/xfs_da_format.h"
+#include "libxfs/xfs_format.h"
 
 struct xfs_inode;
 struct xfs_da_args;
@@ -184,5 +186,16 @@ int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
 			  unsigned int valuelen, int flags);
 int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
 			    void *name, unsigned int namelen, int flags);
-
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+		unsigned long long int p_ino, unsigned int p_gen,
+		unsigned int  p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			struct xfs_parent_name_rec *rec);
+int xfs_parent_add(struct xfs_trans *tp, struct xfs_inode *parent,
+		struct xfs_inode *child, struct xfs_name *child_name,
+		xfs_dir2_dataptr_t diroffset, struct xfs_defer_ops *dfops,
+		xfs_fsblock_t *firstblock);
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f7986d8..1c45c73 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1164,6 +1164,7 @@ xfs_create(
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
 	uint			resblks;
+	xfs_dir2_dataptr_t	diroffset;
 
 	trace_xfs_create(dp, name);
 
@@ -1253,7 +1254,7 @@ xfs_create(
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 					&first_block, &dfops, resblks ?
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0,
-					NULL);
+					&diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1272,6 +1273,19 @@ xfs_create(
 	}
 
 	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now. This must be done within the same
+	 * transaction the directory entry is created, while the new inode
+	 * contains nothing in the inode literal area.
+	 */
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_add(tp, dp, ip, name, diroffset,
+					  &dfops, &first_block);
+		if (error)
+			goto out_bmap_cancel;
+	}
+
+	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
 	 * the user.
-- 
2.7.4

