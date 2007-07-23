Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 02:00:44 -0700 (PDT)
Received: from mx1.suse.de (ns.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6N90dbm026320
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 02:00:40 -0700
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 7B240122DD
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 11:00:42 +0200 (CEST)
From: Andi Kleen <ak@suse.de>
Subject: Remove Makefile wrappers in XFS
Date: Mon, 23 Jul 2007 11:00:36 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231100.36852.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Makefile (and Kbuild) would include Makefile-linux-26
I doubt XFS will really still compile on 2.4; so drop that. This
moves Makefile-linux-26 into Makefile and drops Kbuild.
Also having wrappers as both Kbuild and Makefile seemed redundant
anyways.

The patch is relatively large because it renames a file, but
no functional changes.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.23-rc1-misc/fs/xfs/Kbuild
===================================================================
--- linux-2.6.23-rc1-misc.orig/fs/xfs/Kbuild
+++ /dev/null
@@ -1,6 +0,0 @@
-#
-# The xfs people like to share Makefile with 2.6 and 2.4.
-# Utilise file named Kbuild file which has precedence over Makefile.
-#
-
-include $(srctree)/$(obj)/Makefile-linux-2.6
Index: linux-2.6.23-rc1-misc/fs/xfs/Makefile
===================================================================
--- linux-2.6.23-rc1-misc.orig/fs/xfs/Makefile
+++ linux-2.6.23-rc1-misc/fs/xfs/Makefile
@@ -1 +1,121 @@
-include $(TOPDIR)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)
+#
+# Copyright (c) 2000-2005 Silicon Graphics, Inc.
+# All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+EXTRA_CFLAGS +=	 -Ifs/xfs -Ifs/xfs/linux-2.6 -funsigned-char
+
+XFS_LINUX := linux-2.6
+
+ifeq ($(CONFIG_XFS_DEBUG),y)
+	EXTRA_CFLAGS += -g
+endif
+
+obj-$(CONFIG_XFS_FS)		+= xfs.o
+
+xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix quota/, \
+				   xfs_dquot.o \
+				   xfs_dquot_item.o \
+				   xfs_trans_dquot.o \
+				   xfs_qm_syscalls.o \
+				   xfs_qm_bhv.o \
+				   xfs_qm.o)
+
+ifeq ($(CONFIG_XFS_QUOTA),y)
+xfs-$(CONFIG_PROC_FS)		+= quota/xfs_qm_stats.o
+endif
+
+xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
+xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
+xfs-$(CONFIG_PROC_FS)		+= $(XFS_LINUX)/xfs_stats.o
+xfs-$(CONFIG_SYSCTL)		+= $(XFS_LINUX)/xfs_sysctl.o
+xfs-$(CONFIG_COMPAT)		+= $(XFS_LINUX)/xfs_ioctl32.o
+
+
+xfs-y				+= xfs_alloc.o \
+				   xfs_alloc_btree.o \
+				   xfs_attr.o \
+				   xfs_attr_leaf.o \
+				   xfs_behavior.o \
+				   xfs_bit.o \
+				   xfs_bmap.o \
+				   xfs_bmap_btree.o \
+				   xfs_btree.o \
+				   xfs_buf_item.o \
+				   xfs_da_btree.o \
+				   xfs_dir2.o \
+				   xfs_dir2_block.o \
+				   xfs_dir2_data.o \
+				   xfs_dir2_leaf.o \
+				   xfs_dir2_node.o \
+				   xfs_dir2_sf.o \
+				   xfs_error.o \
+				   xfs_extfree_item.o \
+				   xfs_filestream.o \
+				   xfs_fsops.o \
+				   xfs_ialloc.o \
+				   xfs_ialloc_btree.o \
+				   xfs_iget.o \
+				   xfs_inode.o \
+				   xfs_inode_item.o \
+				   xfs_iocore.o \
+				   xfs_iomap.o \
+				   xfs_itable.o \
+				   xfs_dfrag.o \
+				   xfs_log.o \
+				   xfs_log_recover.o \
+				   xfs_mount.o \
+				   xfs_mru_cache.o \
+				   xfs_rename.o \
+				   xfs_trans.o \
+				   xfs_trans_ail.o \
+				   xfs_trans_buf.o \
+				   xfs_trans_extfree.o \
+				   xfs_trans_inode.o \
+				   xfs_trans_item.o \
+				   xfs_utils.o \
+				   xfs_vfsops.o \
+				   xfs_vnodeops.o \
+				   xfs_rw.o \
+				   xfs_dmops.o \
+				   xfs_qmops.o
+
+xfs-$(CONFIG_XFS_TRACE)		+= xfs_dir2_trace.o
+
+# Objects in linux/
+xfs-y				+= $(addprefix $(XFS_LINUX)/, \
+				   kmem.o \
+				   xfs_aops.o \
+				   xfs_buf.o \
+				   xfs_export.o \
+				   xfs_file.o \
+				   xfs_fs_subr.o \
+				   xfs_globals.o \
+				   xfs_ioctl.o \
+				   xfs_iops.o \
+				   xfs_lrw.o \
+				   xfs_super.o \
+				   xfs_vfs.o \
+				   xfs_vnode.o)
+
+# Objects in support/
+xfs-y				+= $(addprefix support/, \
+				   debug.o \
+				   move.o \
+				   uuid.o)
+
+xfs-$(CONFIG_XFS_TRACE)		+= support/ktrace.o
+
Index: linux-2.6.23-rc1-misc/fs/xfs/Makefile-linux-2.6
===================================================================
--- linux-2.6.23-rc1-misc.orig/fs/xfs/Makefile-linux-2.6
+++ /dev/null
@@ -1,121 +0,0 @@
-#
-# Copyright (c) 2000-2005 Silicon Graphics, Inc.
-# All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-
-EXTRA_CFLAGS +=	 -Ifs/xfs -Ifs/xfs/linux-2.6 -funsigned-char
-
-XFS_LINUX := linux-2.6
-
-ifeq ($(CONFIG_XFS_DEBUG),y)
-	EXTRA_CFLAGS += -g
-endif
-
-obj-$(CONFIG_XFS_FS)		+= xfs.o
-
-xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix quota/, \
-				   xfs_dquot.o \
-				   xfs_dquot_item.o \
-				   xfs_trans_dquot.o \
-				   xfs_qm_syscalls.o \
-				   xfs_qm_bhv.o \
-				   xfs_qm.o)
-
-ifeq ($(CONFIG_XFS_QUOTA),y)
-xfs-$(CONFIG_PROC_FS)		+= quota/xfs_qm_stats.o
-endif
-
-xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
-xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
-xfs-$(CONFIG_PROC_FS)		+= $(XFS_LINUX)/xfs_stats.o
-xfs-$(CONFIG_SYSCTL)		+= $(XFS_LINUX)/xfs_sysctl.o
-xfs-$(CONFIG_COMPAT)		+= $(XFS_LINUX)/xfs_ioctl32.o
-
-
-xfs-y				+= xfs_alloc.o \
-				   xfs_alloc_btree.o \
-				   xfs_attr.o \
-				   xfs_attr_leaf.o \
-				   xfs_behavior.o \
-				   xfs_bit.o \
-				   xfs_bmap.o \
-				   xfs_bmap_btree.o \
-				   xfs_btree.o \
-				   xfs_buf_item.o \
-				   xfs_da_btree.o \
-				   xfs_dir2.o \
-				   xfs_dir2_block.o \
-				   xfs_dir2_data.o \
-				   xfs_dir2_leaf.o \
-				   xfs_dir2_node.o \
-				   xfs_dir2_sf.o \
-				   xfs_error.o \
-				   xfs_extfree_item.o \
-				   xfs_filestream.o \
-				   xfs_fsops.o \
-				   xfs_ialloc.o \
-				   xfs_ialloc_btree.o \
-				   xfs_iget.o \
-				   xfs_inode.o \
-				   xfs_inode_item.o \
-				   xfs_iocore.o \
-				   xfs_iomap.o \
-				   xfs_itable.o \
-				   xfs_dfrag.o \
-				   xfs_log.o \
-				   xfs_log_recover.o \
-				   xfs_mount.o \
-				   xfs_mru_cache.o \
-				   xfs_rename.o \
-				   xfs_trans.o \
-				   xfs_trans_ail.o \
-				   xfs_trans_buf.o \
-				   xfs_trans_extfree.o \
-				   xfs_trans_inode.o \
-				   xfs_trans_item.o \
-				   xfs_utils.o \
-				   xfs_vfsops.o \
-				   xfs_vnodeops.o \
-				   xfs_rw.o \
-				   xfs_dmops.o \
-				   xfs_qmops.o
-
-xfs-$(CONFIG_XFS_TRACE)		+= xfs_dir2_trace.o
-
-# Objects in linux/
-xfs-y				+= $(addprefix $(XFS_LINUX)/, \
-				   kmem.o \
-				   xfs_aops.o \
-				   xfs_buf.o \
-				   xfs_export.o \
-				   xfs_file.o \
-				   xfs_fs_subr.o \
-				   xfs_globals.o \
-				   xfs_ioctl.o \
-				   xfs_iops.o \
-				   xfs_lrw.o \
-				   xfs_super.o \
-				   xfs_vfs.o \
-				   xfs_vnode.o)
-
-# Objects in support/
-xfs-y				+= $(addprefix support/, \
-				   debug.o \
-				   move.o \
-				   uuid.o)
-
-xfs-$(CONFIG_XFS_TRACE)		+= support/ktrace.o
-
