Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52080 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752671AbeEHEnc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484fR65035091
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:32 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2hs24sey0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:31 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w484hUxf018586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:31 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w484hUCw025141
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:30 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 16/21] xfsprogs: Add parent pointer ioctl
Date: Mon,  7 May 2018 21:41:14 -0700
Message-Id: <1525754479-12177-17-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a new file ioctl to retrieve the parent
pointer of a given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_fs.h     | 38 ++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.c | 10 ++++++++++
 libxfs/xfs_parent.h |  2 ++
 3 files changed, 50 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 0c6f9fa..e3ce233 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -573,6 +573,43 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_WARNING)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				255
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u32		xpp_namelen;			/* File name length */
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
@@ -616,6 +653,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
+#define XFS_IOC_GETPPOINTER	_IOR ('X', 61, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index b8ec1f6..368830b 100644
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
index 298562b..1a321db 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -33,4 +33,6 @@ int xfs_parent_add(struct xfs_trans *tp, struct xfs_inode *parent,
 		   struct xfs_inode *child, struct xfs_name *child_name,
 		   uint32_t diroffset, xfs_fsblock_t *firstblock,
 		   struct xfs_defer_ops *dfops);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 struct xfs_parent_name_rec *rec);
 #endif	/* __XFS_PARENT_H__ */
-- 
2.7.4

