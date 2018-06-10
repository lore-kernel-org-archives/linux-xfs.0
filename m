Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49312 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753599AbeFJFKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A58i55142324
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:17 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2jgecx94pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5AGXs024599
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:16 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A5AGsP030424
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:16 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 18/27] xfsprogs: Add parent pointer ioctl
Date: Sat,  9 Jun 2018 22:07:43 -0700
Message-Id: <1528607272-11122-19-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a new file ioctl to retrieve the parent
pointer of a given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_fs.h     | 42 ++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.c | 10 ++++++++++
 libxfs/xfs_parent.h |  2 ++
 3 files changed, 54 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 0c6f9fa..3ebfe75 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -573,6 +573,47 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_WARNING)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u32		xpp_namelen;			/* File name length */
+	__u32		xpp_pad;
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate though an inodes parent pointers */
+struct xfs_pptr_info {
+	struct xfs_handle		pi_handle;
+	struct xfs_attrlist_cursor	pi_cursor;
+	__u32				pi_flags;
+	__u32				pi_reserved;
+	__u32				pi_ptrs_size;
+	__u32				pi_ptrs_used;
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_pptr follows the header
+	 * information. Use XFS_PPINFO_TO_PP() to access the
+	 * parent pointer array entries.
+	 */
+};
+
+#define XFS_PPTR_INFO_SIZEOF(nr_ptrs) sizeof (struct xfs_pptr_info) + \
+				      nr_ptrs * sizeof(struct xfs_parent_ptr)
+
+#define XFS_PPINFO_TO_PP(info, idx)    \
+	(&(((struct xfs_parent_ptr *)((char *)(info) + sizeof(*(info))))[(idx)]))
+
 /*
  * ioctl limits
  */
@@ -616,6 +657,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
+#define XFS_IOC_GETPPOINTER	_IOR ('X', 61, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 3510828..70c12ba 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -39,6 +39,16 @@
 #include "xfs_attr_sf.h"
 #include "libxfs_api_defs.h"
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
+		     struct xfs_parent_name_rec	*rec)
+{
+	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
+	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
+	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
 /*
  * Parent pointer attribute handling.
  *
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 6197817..7771719 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -33,4 +33,6 @@ int xfs_parent_add(struct xfs_inode *parent,
 		   struct xfs_inode *child, struct xfs_name *child_name,
 		   uint32_t diroffset, xfs_fsblock_t *firstblock,
 		   struct xfs_defer_ops *dfops);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 struct xfs_parent_name_rec *rec);
 #endif	/* __XFS_PARENT_H__ */
-- 
2.7.4

