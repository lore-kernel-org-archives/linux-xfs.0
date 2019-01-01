Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43698 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfAACUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:20:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012Dn7v018643
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:45 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2pp0btp7a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:20:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012KiK3009202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:44 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012Kisi026339
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:44 GMT
Subject: [PATCH 15/22] xfs: create libxfs helper to link a new inode into a
 directory
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:20:35 -0800
Message-ID: <154630923581.18437.16793782051661833470.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new libxfs function to link a newly created inode into a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    4 ++++
 fs/xfs/xfs_inode.c       |   20 ++------------------
 3 files changed, 51 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 229152cd1a24..aaac55668e9d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -22,6 +22,9 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_shared.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
@@ -703,3 +706,45 @@ xfs_dir2_shrink_inode(
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	return 0;
 }
+
+/*
+ * Given a directory @dp, a newly allocated inode @ip, and a @name, link @ip
+ * into @dp under the given @name.  If @ip is a directory, it will be
+ * initialized.  Both inodes must have the ILOCK held and the transaction must
+ * have sufficient blocks reserved.
+ */
+int
+xfs_dir_create_new_child(
+	struct xfs_trans		*tp,
+	uint				resblks,
+	struct xfs_inode		*dp,
+	struct xfs_name			*name,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	int				error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
+	ASSERT(resblks == 0 || resblks > XFS_IALLOC_SPACE_RES(mp));
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
+				   resblks ?
+					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
+	if (error) {
+		ASSERT(error != -ENOSPC);
+		return error;
+	}
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	if (!S_ISDIR(VFS_I(ip)->i_mode))
+		return 0;
+
+	error = xfs_dir_init(tp, ip, dp);
+	if (error)
+		return error;
+
+	return xfs_bumplink(tp, dp);
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c3e3f6b813d8..5219ca503012 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -327,4 +327,8 @@ unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp, uint8_t filetype);
 void *xfs_dir3_data_endp(struct xfs_da_geometry *geo,
 		struct xfs_dir2_data_hdr *hdr);
 
+int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
+
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 110ce01f183e..1469f905be36 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -778,25 +778,9 @@ xfs_create(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks ?
-					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
-	if (error) {
-		ASSERT(error != -ENOSPC);
+	error = xfs_dir_create_new_child(tp, resblks, dp, name, ip);
+	if (error)
 		goto out_trans_cancel;
-	}
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
-
-	if (is_dir) {
-		error = xfs_dir_init(tp, ip, dp);
-		if (error)
-			goto out_trans_cancel;
-
-		error = xfs_bumplink(tp, dp);
-		if (error)
-			goto out_trans_cancel;
-	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
