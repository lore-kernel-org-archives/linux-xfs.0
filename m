Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B1F6C29DF5
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 17:27:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9322A8F804C
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 15:27:01 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FjE7fNKqmngT5xEj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 15:26:59 -0800 (PST)
Date: Mon, 11 Jan 2016 15:26:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: check sizes of XFS on-disk structures at compile time
Message-ID: <20160111232657.GA7831@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Check the sizes of XFS on-disk structures when compiling the kernel.
Use this to catch inadvertent changes in structure size due to padding
and alignment issues, etc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    4 ++++
 fs/xfs/xfs_super.c         |   45 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e2536bb..a589b47 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1509,4 +1509,8 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
+#define XFS_CHECK_STRUCT_SIZE(structname, size) \
+	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(struct " \
+		#structname ") is wrong, expected " #size)
+
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36bd882..31b69d1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1812,11 +1812,56 @@ xfs_destroy_workqueues(void)
 	destroy_workqueue(xfs_alloc_wq);
 }
 
+static void __init
+xfs_check_ondisk_structs(void)
+{
+	/* on-disk structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
+
+	/* log structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_64,	56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_ictimestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_icdinode,		176);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
+}
+
 STATIC int __init
 init_xfs_fs(void)
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
