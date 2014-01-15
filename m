Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0176B29DF9
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5500304032
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:52 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UsX0003640
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:54 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000852.129897758@sgi.com>
Date: Wed, 15 Jan 2014 16:00:23 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 11/17] xfs: (parent ptr) add parent pointer support to xfs_rename
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=11-pptr-add-incore-to-rename.patch
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

Add the parent inode / offset support for xfs_rename. This
could add the new extry to inode core, if the entry is empty
or the old entry was stored there, else store the new entry
in an extended attribute. Removal of the old entry from
an inode core or extended attribute is also done.

---
 fs/xfs/Makefile     |    1 
 fs/xfs/xfs_inode.c  |   69 +++++++++++++++++++++-
 fs/xfs/xfs_parent.c |  158 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent.h |    5 +
 4 files changed, 228 insertions(+), 5 deletions(-)

Index: b/fs/xfs/Makefile
===================================================================
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -49,6 +49,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
+				   xfs_parent.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
 				   xfs_trans.o \
Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2728,6 +2728,9 @@ xfs_rename(
 	xfs_inode_t	*inodes[4];
 	int		spaceres;
 	int		num_inodes;
+	int		need_action = 0;
+	uint		src_offset = 0;
+	uint		tar_offset = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2808,8 +2811,8 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-						src_ip->i_ino, &first_block,
-						&free_list, spaceres, NULL);
+					   src_ip->i_ino, &first_block,
+					   &free_list, spaceres, &tar_offset);
 		if (error == ENOSPC)
 			goto error_return;
 		if (error)
@@ -2851,7 +2854,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, &first_block,
-					&free_list, spaceres, NULL);
+					&free_list, spaceres, &tar_offset);
 		if (error)
 			goto abort_return;
 
@@ -2919,10 +2922,16 @@ xfs_rename(
 	}
 
 	error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-				     &first_block, &free_list, spaceres, NULL);
+				   &first_block, &free_list, spaceres,
+				   &src_offset);
 	if (error)
 		goto abort_return;
 
+	if (xfs_sb_version_hasparent(&mp->m_sb))
+		need_action = xfs_pptr_rename(mp, tp, src_dp, target_dp,
+					      src_ip, target_ip, src_offset,
+					      tar_offset);
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -2949,7 +2958,57 @@ xfs_rename(
 	 * trans_commit will unlock src_ip, target_ip & decrement
 	 * the vnode references.
 	 */
-	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	if (error)
+		return error;
+
+	if (xfs_sb_version_hasparent(&mp->m_sb) && need_action) {
+		struct xfs_pattr	p_entry;
+		struct xfs_name		p_name;
+
+		if ((need_action & XFSREMOVESRC) /* &&
+		    atomic_read(&VFS_I(src_ip)->i_count) > 1 &&
+		    src_ip->i_d.di_nlink != 0*/) {
+			xfs_parent_pname(src_dp->i_ino, src_offset, &p_entry,
+					 &p_name);
+			error = xfs_attr_remove(src_ip, (char *) &p_name,
+						    ATTR_PARENT);
+			if (error)
+				xfs_notice(mp,
+			 "%s: rm src attr %llx/%x failed inode %llx %d\n",
+				  	__func__, src_dp->i_ino, src_offset,
+					src_ip->i_ino, error);
+		}
+
+		if (target_ip && (need_action & XFSREMOVETAR) &&
+		    atomic_read(&VFS_I(target_ip)->i_count) > 1 &&
+		    target_ip->i_d.di_nlink != 0) {
+			xfs_parent_pname(target_dp->i_ino, tar_offset, &p_entry,
+					 &p_name);
+			error = xfs_attr_remove(target_ip, (char *) &p_name,
+							  ATTR_PARENT);
+			if (error)
+				xfs_notice(mp,
+			 "%s: rm tar attr %llx/%x failed inode %llx %d\n",
+			  		__func__, target_dp->i_ino,
+					tar_offset, target_ip->i_ino, error);
+		}
+
+		if (need_action & XFSADD) {
+			xfs_parent_pname(target_dp->i_ino, tar_offset, &p_entry,
+					 &p_name);
+			error = xfs_attr_set(src_ip, (char *) &p_name, NULL, 0,
+						 ATTR_PARENT|ATTR_CREATE);
+			if (error) {
+				xfs_notice(mp,
+			 "%s: rm add attr %llx/%x failed inode %llx %d\n",
+			  __func__, target_dp->i_ino, tar_offset, src_ip->i_ino,
+				   error);
+//				goto unlock_return;
+			}
+		}
+	}
+	return error;
 
  abort_return:
 	cancel_flags |= XFS_TRANS_ABORT;
Index: b/fs/xfs/xfs_parent.c
===================================================================
--- /dev/null
+++ b/fs/xfs/xfs_parent.c
@@ -0,0 +1,158 @@
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
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_inum.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_attr_sf.h"
+#include "xfs_attr.h"
+#include "xfs_trans_space.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
+#include "xfs_inode_item.h"
+#include "xfs_ialloc.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_error.h"
+#include "xfs_quota.h"
+#include "xfs_dinode.h"
+#include "xfs_filestream.h"
+#include "xfs_cksum.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_ioctl.h"
+#include "xfs_trace.h"
+#include "xfs_icache.h"
+#include "xfs_symlink.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_parent.h"
+
+int
+xfs_pptr_rename(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*src_dp,
+	struct xfs_inode	*target_dp,
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*target_ip,
+	uint			src_offset,
+	uint			tar_offset)
+{
+	int64_t be_src_ino = cpu_to_be64(src_dp->i_ino);
+	__uint64_t be_tar_ino = cpu_to_be64(target_dp->i_ino);
+	__uint32_t be_src_offset = cpu_to_be32(src_offset);
+	__uint32_t be_tar_offset = cpu_to_be32(tar_offset);
+
+	ASSERT(xfs_sb_version_hasparent(&mp->m_sb));
+
+	if (target_ip &&
+	    src_ip->i_d.di_parent == be_tar_ino &&
+	    src_ip->i_d.di_poffset == be_tar_offset) {
+		/*
+		 * If the target exists and is already in the source
+		 * inode entry, then just remove the source entry.
+		 */
+		return XFSREMOVESRC;
+
+	}
+
+	if (src_ip->i_d.di_parent == be_src_ino &&
+	    src_ip->i_d.di_poffset == be_src_offset) {
+		/*
+		 * The destination contains the old entry, then replace
+		 * it with the new entry. Remove the target name if it
+		 * existed.
+		 */
+		src_ip->i_d.di_parent = be_tar_ino;
+		src_ip->i_d.di_poffset = be_tar_offset;
+		xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
+
+		if (target_ip)  {
+			if (target_ip != src_ip &&
+			    target_ip->i_d.di_parent == be_tar_ino &&
+			    target_ip->i_d.di_poffset == be_tar_offset) {
+				target_ip->i_d.di_parent = NULLFSINO;
+				target_ip->i_d.di_poffset = 0;
+				xfs_trans_log_inode(tp, target_ip,
+						XFS_ILOG_CORE);
+				return 0;
+			} else
+				return XFSREMOVETAR;
+		}
+		return 0;
+	}
+
+	if (src_ip->i_d.di_parent == NULLFSINO) {
+		/* place entry in empty inode area */
+		src_ip->i_d.di_parent = be_tar_ino;
+		src_ip->i_d.di_poffset = be_tar_offset;
+		xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
+
+		/*
+		 * we know the old src is in the extend attribute so
+		 * remove it. if the target exist, remove it also.
+		 */
+		if (target_ip) {
+			if (target_ip != src_ip &&
+			    target_ip->i_d.di_parent == be_tar_ino &&
+			    target_ip->i_d.di_poffset == be_tar_offset) {
+				target_ip->i_d.di_parent = NULLFSINO;
+				target_ip->i_d.di_poffset = 0;
+				xfs_trans_log_inode(tp, target_ip,
+					    XFS_ILOG_CORE);
+				return XFSREMOVESRC;
+			} else
+				return XFSREMOVETAR | XFSREMOVESRC;
+		} else
+			return XFSREMOVESRC;
+	}
+
+	if (src_ip != target_ip) {
+		if (target_ip) {
+			if (target_ip->i_d.di_parent == be_tar_ino &&
+			    target_ip->i_d.di_poffset == be_tar_offset) {
+				target_ip->i_d.di_parent = NULLFSINO;
+				target_ip->i_d.di_poffset = 0;
+				xfs_trans_log_inode(tp, target_ip,
+						 XFS_ILOG_CORE);
+				return XFSREMOVESRC | XFSADD;
+			} else
+				return XFSREMOVETAR | XFSREMOVESRC | XFSADD;
+		} else
+			return XFSREMOVESRC | XFSADD;
+	}
+
+	/*
+	 * The extended attribute already exists in the src_ip.
+	 * Remove the src name from the extend attribute
+	 */
+	return XFSREMOVESRC;
+}
Index: b/fs/xfs/xfs_parent.h
===================================================================
--- a/fs/xfs/xfs_parent.h
+++ b/fs/xfs/xfs_parent.h
@@ -35,5 +35,10 @@ static inline void xfs_parent_pname(xfs_
 	pn->name = (char *)pe;
 	pn->len = sizeof(struct xfs_pattr);
 }
+
+int xfs_pptr_rename(struct xfs_mount *mp, struct xfs_trans *tp,
+	struct xfs_inode *src_dp, struct xfs_inode *target_dp,
+	struct xfs_inode *src_ip, struct xfs_inode *target_ip,
+	uint src_offset, uint tar_offset);
 #endif /* __XFS_PARENT_H__ */
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
