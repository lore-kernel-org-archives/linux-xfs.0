Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C8BBD7F63
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 15:50:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9CAD2304043
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 13:50:15 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EprId6LS98l3sSTv for <xfs@oss.sgi.com>;
	Sun, 06 Mar 2016 13:50:13 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1acgYt-0000Y9-MY
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:50:03 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1acgYh-0004oJ-Uw
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:49:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: check sizes of XFS on-disk structures at compile time
Date: Mon,  7 Mar 2016 08:49:49 +1100
Message-Id: <1457300990-18300-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1457300990-18300-1-git-send-email-david@fromorbit.com>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Check the sizes of XFS on-disk structures when compiling the kernel.
Use this to catch inadvertent changes in structure size due to padding
and alignment issues, etc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_ondisk.h | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c  |   3 ++
 2 files changed, 111 insertions(+)
 create mode 100644 fs/xfs/xfs_ondisk.h

diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
new file mode 100644
index 0000000..9a78408
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
+	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
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
+	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
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
index 59c9b7b..3bd2027 100644
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
 
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
