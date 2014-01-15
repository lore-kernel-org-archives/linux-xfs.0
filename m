Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B103529DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:52 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95E30304032
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:52 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0Usri003632
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:54 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000851.941188004@sgi.com>
Date: Wed, 15 Jan 2014 16:00:21 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 09/17] xfs: (parent ptr) add parent pointer support to xfs_link
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=09-pptr-add-to_xfs_link.patch
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
To: xfs@oss.sgi.com

Add the parent inode / offset entry for a new link. If the
parent inode pointer entries are not free, then add the
entry as an extended attribute of ATTR_PARENT type. The
entry uses an unique name composed of the 64 bit inode
and the 32 bit offsets. No extend attribute value is used.

---
 fs/xfs/xfs_inode.c  |   43 ++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_parent.h |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 3 deletions(-)

Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -51,6 +51,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_parent.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -1358,6 +1359,7 @@ xfs_link(
 	int			cancel_flags;
 	int			committed;
 	int			resblks;
+	uint			offset;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1407,12 +1409,26 @@ xfs_link(
 	if (error)
 		goto error_return;
 
-	xfs_bmap_init(&free_list, &first_block);
+ 	xfs_bmap_init(&free_list, &first_block);
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   &first_block, &free_list, resblks, NULL);
+				   &first_block, &free_list, resblks, &offset);
 	if (error)
 		goto abort_return;
+
+	if (xfs_sb_version_hasparent(&mp->m_sb) &&
+	    sip->i_d.di_parent == NULLFSINO) {
+		/*
+		 * store the parent information in the inode if the fields
+		 * are empty. zero the offset as a flag to not add the
+		 * information in an extended attribute.
+		 */
+		sip->i_d.di_parent = cpu_to_be64(tdp->i_ino);
+		sip->i_d.di_poffset = cpu_to_be32(offset);
+		xfs_trans_log_inode(tp, sip, XFS_ILOG_CORE);
+		offset = 0;
+	}
+
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
@@ -1435,7 +1451,28 @@ xfs_link(
 		goto abort_return;
 	}
 
-	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	if (error)
+		return error;
+
+	if (xfs_sb_version_hasparent(&mp->m_sb) && offset) {
+		struct xfs_pattr	p_entry;
+		struct xfs_name		p_name;
+
+		/*
+		 * The parent pointer information could not be stored
+		 * inode core, and must be stored in an extended attribute.
+		 */
+		xfs_parent_pname(tdp->i_ino, offset, &p_entry, &p_name);
+		error = xfs_attr_set(sip, (char *) &p_name, NULL, 0,
+				     ATTR_PARENT|ATTR_CREATE);
+		if (error)
+			xfs_notice(mp,
+			   "%s: attr %llx/%x failed inode %llx %d\n",
+			   __func__, tdp->i_ino, offset, sip->i_ino,
+			   error);
+	}
+	return error;
 
  abort_return:
 	cancel_flags |= XFS_TRANS_ABORT;
Index: b/fs/xfs/xfs_parent.h
===================================================================
--- /dev/null
+++ b/fs/xfs/xfs_parent.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (c) 2014 SGI
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
+
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+#define XFSREMOVESRC	(1 << 0)
+#define XFSREMOVETAR	(1 << 1)
+#define XFSADD		(1 << 2)
+
+struct xfs_pattr {
+	__be64  p_ino;
+	__be32  p_offset;
+} __attribute__((packed));
+
+static inline void xfs_parent_pname(xfs_ino_t ino, __uint32_t off, struct xfs_pattr *pe, struct xfs_name *pn)
+{
+	pe->p_ino = cpu_to_be64(ino);
+	pe->p_offset = cpu_to_be32(off);
+	pn->name = (char *)pe;
+	pn->len = sizeof(struct xfs_pattr);
+}
+#endif /* __XFS_PARENT_H__ */
+


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
