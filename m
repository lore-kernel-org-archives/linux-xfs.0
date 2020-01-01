Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A5DC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5D14206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dfvVVAY+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgAABOO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:14:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51530 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABOO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:14:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011ECbX094423
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=M4FHSiFn4Ua/aUNrmNSL3Mk1ekPfAZr77WOe4dra00Q=;
 b=dfvVVAY+vthbILBcBbwc1wDqDKJI37i5Tpsb+vzbcPLZe0S8UV4TDIC3CWnvp3fxWGJm
 egBkHxevpTD1r/AQBHAbGkrDCwZfTYbJ84MUQM/uazRPTQGrNIjvCT1c5nNZnFCvKcH8
 8r2odRRlMse4QRGt1yPNkGIrwvx7LekU8HiX46SxySbyeuXniD6jJy7u9FwZSN/9/af7
 u1mYWqJzxwx9aVWA8EBUWj7ntVlnzjbIUzr4o5a3saXcoMTF6Hi0nv5SIs3M240ONg2H
 v+GganhxxmGeigs96+mFy9/XXzrQPOwdtfGwnhhIBpxnNgE7E9hjJdYe0R9a2TV+amGX ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118wVn172138
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2x8gj9191e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:12 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011EBj2012844
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:11 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:14:11 -0800
Subject: [PATCH 15/21] xfs: create libxfs helper to link a new inode into a
 directory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:14:09 -0800
Message-ID: <157784124917.1365473.16251552432619701137.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new libxfs function to link a newly created inode into a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    4 ++++
 fs/xfs/xfs_inode.c       |   18 ++----------------
 3 files changed, 52 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index e18f248a08a9..2a41aa2b3b30 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -19,6 +19,9 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
+#include "xfs_shared.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
@@ -748,3 +751,46 @@ xfs_dir2_compname(
 		return xfs_ascii_ci_compname(args, name, len);
 	return xfs_da_compname(args, name, len);
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
+	xfs_bumplink(tp, dp);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 033777e282f2..de38d6335a72 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -250,4 +250,8 @@ unsigned int xfs_dir3_data_end_offset(struct xfs_da_geometry *geo,
 		struct xfs_dir2_data_hdr *hdr);
 bool xfs_dir2_namecheck(const void *name, size_t length);
 
+int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
+
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index af4c20a09514..b3ff374025dd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -780,23 +780,9 @@ xfs_create(
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
-		xfs_bumplink(tp, dp);
-	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the

