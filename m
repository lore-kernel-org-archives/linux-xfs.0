Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48428 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbeIZQ3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:29:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QADw8t079560
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:20 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2mndpphg5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:19 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHIml020183
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:18 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAHIXs027613
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:18 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v9 02/28] xfs: Add helper function xfs_attr_try_sf_addname
Date: Wed, 26 Sep 2018 03:14:41 -0700
Message-Id: <1537956907-10244-3-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a subroutine xfs_attr_try_sf_addname
used by xfs_attr_set.  This subrotine will attempt to
add the attribute name specified in args in shortform,
as well and perform error handling previously done in
xfs_attr_set.

This patch helps to pre-simplify xfs_attr_set for reviewing
purposes and reduce indentation.  New function will be added
in the next patch.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 61 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1e671d4..f0675be 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -191,6 +191,42 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+STATIC int
+xfs_attr_try_sf_addname(
+	struct xfs_inode	*dp,
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_mount	*mp = dp->i_mount;
+	int			error;
+
+	error = xfs_attr_shortform_addname(args);
+	if (error == -ENOSPC)
+		return error;
+
+	/*
+	 * Commit the shortform mods, and we're done.
+	 * NOTE: this is also the error path
+	 * (EEXIST, etc).
+	 */
+	ASSERT(args->trans != NULL);
+
+	/*
+	 * If this is a synchronous mount, make sure
+	 * that the transaction goes to disk before
+	 * returning to the user.
+	 */
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(args->trans);
+
+	if (!error && (args->flags & ATTR_KERNOTIME) == 0) {
+		xfs_trans_ichgtime(args->trans, dp,
+				XFS_ICHGTIME_CHG);
+	}
+
+	return error;
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -281,30 +317,13 @@ xfs_attr_set(
 		 * Try to add the attr to the attribute list in
 		 * the inode.
 		 */
-		error = xfs_attr_shortform_addname(&args);
+		error = xfs_attr_try_sf_addname(dp, &args);
 		if (error != -ENOSPC) {
-			/*
-			 * Commit the shortform mods, and we're done.
-			 * NOTE: this is also the error path (EEXIST, etc).
-			 */
-			ASSERT(args.trans != NULL);
-
-			/*
-			 * If this is a synchronous mount, make sure that
-			 * the transaction goes to disk before returning
-			 * to the user.
-			 */
-			if (mp->m_flags & XFS_MOUNT_WSYNC)
-				xfs_trans_set_sync(args.trans);
-
-			if (!error && (flags & ATTR_KERNOTIME) == 0) {
-				xfs_trans_ichgtime(args.trans, dp,
-							XFS_ICHGTIME_CHG);
-			}
 			err2 = xfs_trans_commit(args.trans);
-			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+			error = error ? error : err2;
 
-			return error ? error : err2;
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+			return error;
 		}
 
 		/*
-- 
2.7.4
