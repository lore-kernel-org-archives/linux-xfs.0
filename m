Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbeIZQiO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANdX5036961
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:57 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mnvtur9ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:57 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPqvf027499
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:52 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPpb3032175
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 27/30] xfsprogs: Add parent pointers to recreated inodes
Date: Wed, 26 Sep 2018 03:23:30 -0700
Message-Id: <1537957413-10630-28-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Inodes that are not recovered from the orphanage will
be recreated, so we will need to re-add the parent pointers
here too.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/libxfs_api_defs.h |  1 +
 repair/phase6.c          | 36 ++++++++++++++++++++++++------------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ad5d65d..d3a581c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -149,5 +149,6 @@
 #define xfs_dir_get_ops			libxfs_dir_get_ops
 #define xfs_default_ifork_ops		libxfs_default_ifork_ops
 #define xfs_fs_geometry			libxfs_fs_geometry
+#define xfs_parent_add    		libxfs_parent_add
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/phase6.c b/repair/phase6.c
index c4651bc..48a6cee 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -17,6 +17,7 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "xfs_parent.h"
 
 static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
@@ -919,17 +920,18 @@ mk_root_dir(xfs_mount_t *mp)
 static xfs_ino_t
 mk_orphanage(xfs_mount_t *mp)
 {
-	xfs_ino_t	ino;
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_inode_t	*pip;
-	ino_tree_node_t	*irec;
-	int		ino_offset = 0;
-	int		i;
-	int		error;
-	const int	mode = 0755;
-	int		nres;
-	struct xfs_name	xname;
+	xfs_ino_t		ino;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct xfs_inode	*pip;
+	struct ino_tree_node	*irec;
+	int			ino_offset = 0;
+	int			i;
+	int			error;
+	const int		mode = 0755;
+	int			nres;
+	struct xfs_name		xname;
+	xfs_dir2_dataptr_t	offset;
 
 	/*
 	 * check for an existing lost+found first, if it exists, return
@@ -1014,7 +1016,7 @@ mk_orphanage(xfs_mount_t *mp)
 	/*
 	 * create the actual entry
 	 */
-	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres, NULL);
+	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres, &offset);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
@@ -1034,6 +1036,16 @@ mk_orphanage(xfs_mount_t *mp)
 	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 	libxfs_dir_init(tp, ip, pip);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = -libxfs_parent_add(pip, ip, &xname, offset);
+		if (error)
+			do_error(_("Error creating parent pointer: %d\n"),
+				error);
+		libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
+		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	}
+
 	libxfs_trans_commit(tp);
 	IRELE(ip);
 	IRELE(pip);
-- 
2.7.4
