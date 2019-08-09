Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50376 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfHIViV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYeLv071951
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:20 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNU6c056459
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u8pj9m4jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:20 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcJcj019329
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:19 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v1 09/19] xfsprogs: Factor up commit from xfs_attr_try_sf_addname
Date: Fri,  9 Aug 2019 14:37:54 -0700
Message-Id: <20190809213804.32628-10-allison.henderson@oracle.com>
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

New delayed attribute routines cannot handle transactions,
so factor this up to the calling function.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 3b7baba..6245afb 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -197,7 +197,7 @@ xfs_attr_try_sf_addname(
 {
 
 	struct xfs_mount	*mp = dp->i_mount;
-	int			error, error2;
+	int			error;
 
 	error = xfs_attr_shortform_addname(args);
 	if (error == -ENOSPC)
@@ -213,9 +213,7 @@ xfs_attr_try_sf_addname(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args->trans);
 
-	error2 = xfs_trans_commit(args->trans);
-	args->trans = NULL;
-	return error ? error : error2;
+	return error;
 }
 
 /*
@@ -227,7 +225,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error;
+	int			error, error2 = 0;;
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -247,8 +245,11 @@ xfs_attr_set_args(
 		 * Try to add the attr to the attribute list in the inode.
 		 */
 		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC)
-			return error;
+		if (error != -ENOSPC) {
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
 
 		/*
 		 * It won't fit in the shortform, transform to a leaf block.
-- 
2.7.4
