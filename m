Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39002 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752609AbeEHEnc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484fXJF104944
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:31 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2hs5936smb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:31 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w484hUg8015964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:30 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w484hTjD025430
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:30 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 14/21] xfsprogs: parent pointer attribute creation
Date: Mon,  7 May 2018 21:41:12 -0700
Message-Id: <1525754479-12177-15-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add parent pointer attribute during xfs_create, and
subroutines to initialize attributes

Kernel create routines take advantage of deferred attributes,
where as libxfs routines will add parent pointers directly.

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
       fixed some null pointer bugs,
       merged error handling patch,
       added subroutines to handle attribute initialization,
       remove unnecessary ENOSPC handling in xfs_attr_set_first_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/Makefile     |   2 +
 libxfs/xfs_parent.c | 168 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |  36 +++++++++++
 3 files changed, 206 insertions(+)

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 75ce980..6fdcdf7 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -37,6 +37,7 @@ HFILES = \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
+	xfs_parent.h \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
 	xfs_refcount_btree.h \
@@ -89,6 +90,7 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_parent.c \
 	xfs_refcount.c \
 	xfs_refcount_btree.c \
 	xfs_rmap.c \
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
new file mode 100644
index 0000000..b8ec1f6
--- /dev/null
+++ b/libxfs/xfs_parent.c
@@ -0,0 +1,168 @@
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
+#include "platform_defs.h"
+#include "xfs_arch.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "list.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "radix-tree.h"
+#include "atomic.h"
+#include "xfs_mount.h"
+#include "xfs_da_format.h"
+#include "xfs_bmap_btree.h"
+#include "cache.h"
+#include "xfs_cksum.h"
+#include "libxfs_io.h"
+#include "xfs_inode.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "libxfs_api_defs.h"
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
+			xfs_ino_t			p_ino,
+			uint32_t			p_gen,
+			uint32_t			p_diroffset)
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
+ * Directly add a parent pointer instead of as a deferred operation
+ * Currently only used during protofile creation
+ */
+int
+xfs_parent_add(
+	struct xfs_inode	*parent,
+	struct xfs_inode	*child,
+	struct xfs_name		*child_name,
+	uint32_t		diroffset,
+	xfs_fsblock_t		*firstblock,
+	struct xfs_defer_ops	*dfops)
+{
+	struct xfs_parent_name_rec	rec;
+	int				error;
+	struct xfs_da_args		args;
+	int				flags = ATTR_PARENT;
+	int				local = 0;
+	int				rsvd = 0;
+	struct xfs_buf			*leaf_bp = NULL;
+	struct xfs_trans_res		tres;
+	struct xfs_mount		*mp = child->i_mount;
+
+	xfs_init_parent_name_rec(&rec, parent->i_ino,
+				 VFS_I(parent)->i_generation, diroffset);
+
+	error = xfs_attr_args_init(&args, child, (const unsigned char *)&rec,
+				   sizeof(rec), flags);
+	if (error)
+		return error;
+
+	args.hashval = xfs_da_hashname(args.name, args.namelen);
+	args.value = (char *)child_name->name;
+	args.valuelen = child_name->len;
+	args.dfops = dfops;
+	args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_ADDNAME;
+	args.firstblock = firstblock;
+	args.total = xfs_attr_calc_size(&args, &local);
+	args.trans = &tres;
+	ASSERT(local);
+
+       tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+                        M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+       tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+       tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
+       /*
+        * Root fork attributes can use reserved data blocks for this
+        * operation if necessary
+        */
+       error = xfs_trans_alloc(mp, &tres, args.total, 0,
+                               rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+       if (error)
+               goto out;
+
+
+	/*
+	 * If the inode doesn't have an attribute fork, add one.
+	 * (inode must not be locked when we call this routine)
+	 */
+	if (XFS_IFORK_Q(child) == 0) {
+		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
+			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, args.valuelen);
+
+		error = xfs_bmap_add_attrfork(child, sf_size, rsvd);
+		if (error)
+			return error;
+	}
+
+	error = xfs_attr_set_args(&args, flags, leaf_bp, false);
+
+
+       if (error)
+               goto out;
+
+       xfs_trans_log_inode(args.trans, child, XFS_ILOG_CORE);
+
+       return error;
+
+out:
+       if (args.trans)
+               xfs_trans_cancel(args.trans);
+
+	return error;
+}
+
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
new file mode 100644
index 0000000..298562b
--- /dev/null
+++ b/libxfs/xfs_parent.h
@@ -0,0 +1,36 @@
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
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+#include "xfs_da_format.h"
+#include "xfs_format.h"
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      xfs_ino_t p_ino, uint32_t p_gen,
+			      uint32_t p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			       struct xfs_parent_name_rec *rec);
+
+int xfs_parent_add(struct xfs_trans *tp, struct xfs_inode *parent,
+		   struct xfs_inode *child, struct xfs_name *child_name,
+		   uint32_t diroffset, xfs_fsblock_t *firstblock,
+		   struct xfs_defer_ops *dfops);
+#endif	/* __XFS_PARENT_H__ */
-- 
2.7.4

