Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 434597F37
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:34:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D42A4AC001
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:34:49 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Faf8Sp1q3Yr9ddge (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:34:47 -0800 (PST)
Subject: [PATCH 3/3] xfs: check sizes of XFS on-disk structures at compile time
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:34:44 -0800
Message-ID: <20160123003444.2338.37236.stgit@birch.djwong.org>
In-Reply-To: <20160123003425.2338.18133.stgit@birch.djwong.org>
References: <20160123003425.2338.18133.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Check the sizes of XFS on-disk structures when compiling the kernel.
Use this to catch inadvertent changes in structure size due to padding
and alignment issues, etc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ondisk.h |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c  |    3 +
 2 files changed, 111 insertions(+)
 create mode 100644 fs/xfs/xfs_ondisk.h


diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
new file mode 100644
index 0000000..56fab46
--- /dev/null
+++ b/fs/xfs/xfs_ondisk.h
@@ -0,0 +1,108 @@
+/*
+ * Copyright (c) 2016 Oracle.
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
+#ifndef __XFS_ONDISK_H
+#define __XFS_ONDISK_H
+
+#define XFS_CHECK_STRUCT_SIZE(structname, size) \
+	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(struct " \
+		#structname ") is wrong, expected " #size)
+
+static inline void __init
+xfs_check_ondisk_structs(void)
+{
+	/* ag/file structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
+
+	/* dir/attr trees */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leafblock,	88);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_rmt_hdr,		56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_blkinfo,		56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_intnode,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_node_hdr,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_blk_hdr,		48);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_data_hdr,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_entry_t,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_hdr_t,		32);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_map_t,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_local_t,	4);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		40);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_shortform_t,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
+	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
+	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_da_node_hdr_t,		16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_free_t,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_hdr_t,		16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_unused_t,		6);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_hdr_t,		16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_t,			16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_ino4_t,			4);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_ino8_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_inou_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_entry_t,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_hdr_t,		16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_off_t,		2);
+
+	/* log structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_icdinode,		176);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_ictimestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_64,	56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
+}
+
+#endif /* __XFS_ONDISK_H */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36bd882..f63d212 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -45,6 +45,7 @@
 #include "xfs_filestream.h"
 #include "xfs_quota.h"
 #include "xfs_sysfs.h"
+#include "xfs_ondisk.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1817,6 +1818,8 @@ init_xfs_fs(void)
 {
 	int			error;
 
+	xfs_check_ondisk_structs();
+
 	printk(KERN_INFO XFS_VERSION_STRING " with "
 			 XFS_BUILD_OPTIONS " enabled\n");
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
