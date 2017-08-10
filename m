Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24758 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752219AbdHJBnx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 21:43:53 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7A1hqxe012266
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hp33029055
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:52 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hpRJ017099
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:51 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [RFC PATCH 08/13] xfs: parent pointer attribute creation
Date: Wed,  9 Aug 2017 18:41:28 -0700
Message-Id: <1502329293-4091-9-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

From: Dave Chinner <dchinner@redhat.com>

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
	   fixed some null pointer bugs]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
:100644 100644 a2a5d04... 90b51ae... M	fs/xfs/Makefile
:100644 100644 646d41b... ed13c67... M	fs/xfs/libxfs/xfs_attr.c
:100644 100644 a2d6466... 91c403e... M	fs/xfs/libxfs/xfs_bmap.c
:100644 100644 851982a... 533f40f... M	fs/xfs/libxfs/xfs_bmap.h
:000000 100644 0000000... 88f7edc... A	fs/xfs/libxfs/xfs_parent.c
:100644 100644 3031a09... fad2fbd... M	fs/xfs/xfs_attr.h
:100644 100644 52c331e... 3557791... M	fs/xfs/xfs_inode.c
 fs/xfs/Makefile            |  1 +
 fs/xfs/libxfs/xfs_attr.c   | 80 ++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_bmap.c   | 51 ++++++++++++++----------
 fs/xfs/libxfs/xfs_bmap.h   |  1 +
 fs/xfs/libxfs/xfs_parent.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr.h          | 13 +++++-
 fs/xfs/xfs_inode.c         | 16 +++++++-
 7 files changed, 232 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a2a5d04..90b51ae 100644
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
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 646d41b..ed13c67 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -90,12 +90,14 @@ xfs_attr_args_init(
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
 	args->flags = flags;
-	args->name = name;
-	args->namelen = strlen((const char *)name);
-	if (args->namelen >= MAXNAMELEN)
-		return -EFAULT;		/* match IRIX behaviour */
+	if (name) {
+		args->name = name;
+		args->namelen = strlen((const char *)name);
+		if (args->namelen >= MAXNAMELEN)
+			return -EFAULT;		/* match IRIX behaviour */
 
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
+		args->hashval = xfs_da_hashname(args->name, args->namelen);
+	}
 	return 0;
 }
 
@@ -203,6 +205,74 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+/*
+ * Add the initial parent pointer attribute.
+ *
+ * Inode must be locked and completely empty as we are adding the attribute
+ * fork to the inode. This open codes bits of xfs_bmap_add_attrfork() and
+ * xfs_attr_set() because we know the inode is completely empty at this point
+ * and so don't need to handle all the different combinations of fork
+ * configurations here.
+ */
+int
+xfs_attr_set_first_parent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_parent_name_rec *rec,
+	int			reclen,
+	const char		*value,
+	int			valuelen,
+	struct xfs_defer_ops	*dfops,
+	xfs_fsblock_t		*firstblock)
+{
+	struct xfs_da_args	args;
+	int			flags = ATTR_PARENT;
+	int			local;
+	int			sf_size;
+	int			error;
+
+	tp->t_flags |= XFS_TRANS_RESERVE;
+
+	error = xfs_attr_args_init(&args, ip, (char *)rec, flags);
+	if (error)
+		return error;
+
+	args.name = (char *)rec;
+	args.namelen = reclen;
+	args.hashval = xfs_da_hashname(args.name, args.namelen);
+	args.value = (char *)value;
+	args.valuelen = valuelen;
+	args.firstblock = firstblock;
+	args.dfops = dfops;
+	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	args.total = xfs_attr_calc_size(&args, &local);
+	args.trans = tp;
+	ASSERT(local);
+
+	/* set the attribute fork appropriately */
+	sf_size = sizeof(struct xfs_attr_sf_hdr) +
+			XFS_ATTR_SF_ENTSIZE_BYNAME(reclen, valuelen);
+	xfs_bmap_set_attrforkoff(ip, sf_size, NULL);
+	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
+	ip->i_afp->if_flags = XFS_IFEXTENTS;
+
+
+	/* Try to add the attr to the attribute list in the inode. */
+	xfs_attr_shortform_create(&args);
+	error = xfs_attr_shortform_addname(&args);
+	if (error != -ENOSPC)
+		return error;
+
+	/* It won't fit in the shortform, transform to a leaf block. */
+	xfs_defer_init(args.dfops, args.firstblock);
+	error = xfs_attr_shortform_to_leaf(&args);
+	if (error)
+		return error;
+
+	ASSERT(xfs_bmap_one_block(ip, XFS_ATTR_FORK));
+	return xfs_attr_leaf_addname(&args);
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a2d6466..91c403e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1076,6 +1076,35 @@ xfs_bmap_add_attrfork_local(
 	return -EFSCORRUPTED;
 }
 
+int
+xfs_bmap_set_attrforkoff(
+	struct xfs_inode	*ip,
+	int			size,
+	int			*version)
+{
+	switch (ip->i_d.di_format) {
+	case XFS_DINODE_FMT_DEV:
+		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
+		break;
+	case XFS_DINODE_FMT_UUID:
+		ip->i_d.di_forkoff = roundup(sizeof(uuid_t), 8) >> 3;
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
+		if (!ip->i_d.di_forkoff)
+			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
+		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
+			*version = 2;
+		break;
+	default:
+		ASSERT(0);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * Convert inode from non-attributed to attributed.
  * Must not be in a transaction, ip must not be locked.
@@ -1130,27 +1159,7 @@ xfs_bmap_add_attrfork(
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	switch (ip->i_d.di_format) {
-	case XFS_DINODE_FMT_DEV:
-		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
-		break;
-	case XFS_DINODE_FMT_UUID:
-		ip->i_d.di_forkoff = roundup(sizeof(uuid_t), 8) >> 3;
-		break;
-	case XFS_DINODE_FMT_LOCAL:
-	case XFS_DINODE_FMT_EXTENTS:
-	case XFS_DINODE_FMT_BTREE:
-		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
-		if (!ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
-		else if (mp->m_flags & XFS_MOUNT_ATTR2)
-			version = 2;
-		break;
-	default:
-		ASSERT(0);
-		error = -EINVAL;
-		goto trans_cancel;
-	}
+	xfs_bmap_set_attrforkoff(ip, size, &version);
 
 	ASSERT(ip->i_afp == NULL);
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 851982a..533f40f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -209,6 +209,7 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 			  xfs_fsblock_t bno, xfs_filblks_t len,
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 0000000..88f7edc
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,98 @@
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
+/*
+ * Create the initial parent attribute.
+ *
+ * The initial attribute creation also needs to be atomic w.r.t the parent
+ * directory modification. Hence it needs to run in the same transaction and the
+ * transaction committed by the caller.  Because the attribute created is
+ * guaranteed to be a local attribute and is always going to be the first
+ * attribute in the attribute fork, we can do this safely in the single
+ * transaction context as it is impossible for an overwrite to occur and hence
+ * we'll never have a rolling overwrite transaction occurring here. Hence we
+ * can short-cut a lot of the normal xfs_attr_set() code paths that are needed
+ * to handle the generic cases.
+ */
+static int
+xfs_parent_create_nrec(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*child,
+	struct xfs_parent_name_irec *nrec,
+	struct xfs_defer_ops	*dfops,
+	xfs_fsblock_t		*firstblock)
+{
+	struct xfs_parent_name_rec rec;
+
+	rec.p_ino = cpu_to_be64(nrec->p_ino);
+	rec.p_gen = cpu_to_be32(nrec->p_gen);
+	rec.p_diroffset = cpu_to_be32(nrec->p_diroffset);
+
+	return xfs_attr_set_first_parent(tp, child, &rec, sizeof(rec),
+				   nrec->p_name, nrec->p_namelen,
+				   dfops, firstblock);
+}
+
+int
+xfs_parent_create(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*parent,
+	struct xfs_inode	*child,
+	struct xfs_name		*child_name,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_defer_ops	*dfops,
+	xfs_fsblock_t		*firstblock)
+{
+	struct xfs_parent_name_irec nrec;
+
+	nrec.p_ino = parent->i_ino;
+	nrec.p_gen = VFS_I(parent)->i_generation;
+	nrec.p_diroffset = diroffset;
+	nrec.p_name = child_name->name;
+	nrec.p_namelen = child_name->len;
+
+	return xfs_parent_create_nrec(tp, child, &nrec, dfops, firstblock);
+}
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 3031a09..fad2fbd 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -155,5 +155,16 @@ int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 
-
+/*
+ * Parent pointer attribute prototypes
+ */
+int xfs_parent_create(struct xfs_trans *tp, struct xfs_inode *parent,
+		      struct xfs_inode *child, struct xfs_name *child_name,
+		      xfs_dir2_dataptr_t diroffset, struct xfs_defer_ops *dfops,
+		      xfs_fsblock_t *firstblock);
+int xfs_attr_set_first_parent(struct xfs_trans *tp, struct xfs_inode *ip,
+			      struct xfs_parent_name_rec *rec, int reclen,
+			      const char *value, int valuelen,
+			      struct xfs_defer_ops *dfops,
+			      xfs_fsblock_t *firstblock);
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 52c331e..3557791 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1162,6 +1162,7 @@ xfs_create(
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
 	uint			resblks;
+	xfs_dir2_dataptr_t	diroffset;
 
 	trace_xfs_create(dp, name);
 
@@ -1251,7 +1252,7 @@ xfs_create(
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 					&first_block, &dfops, resblks ?
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0,
-					NULL);
+					&diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1270,6 +1271,19 @@ xfs_create(
 	}
 
 	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now. This must be done within the same
+	 * transaction the directory entry is created, while the new inode
+	 * contains nothing in the inode literal area.
+	 */
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_create(tp, dp, ip, name, diroffset,
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

