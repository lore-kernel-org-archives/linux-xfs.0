Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47874 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753669AbeFJFKG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A56dbT006805
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:06 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2jg4dkt26p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:06 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5A56U004084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:05 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5A5Yp003684
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:05 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 02/27] xfsprogs: Add helper function xfs_attr_try_sf_addname
Date: Sat,  9 Jun 2018 22:07:27 -0700
Message-Id: <1528607272-11122-3-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
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
 libxfs/xfs_attr.c | 64 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a4bde02..51b567d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -198,6 +198,44 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+STATIC int
+xfs_attr_try_sf_addname(
+	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
+	int			flags)
+{
+
+	struct xfs_mount	*mp = dp->i_mount;
+	int			error;
+	int			err2;
+
+	error = xfs_attr_shortform_addname(args);
+	if (error != -ENOSPC) {
+		/*
+		 * Commit the shortform mods, and we're done.
+		 * NOTE: this is also the error path
+		 * (EEXIST, etc).
+		 */
+		ASSERT(args->trans != NULL);
+
+		/*
+		 * If this is a synchronous mount, make sure
+		 * that the transaction goes to disk before
+		 * returning to the user.
+		 */
+		if (mp->m_flags & XFS_MOUNT_WSYNC)
+			xfs_trans_set_sync(args->trans);
+
+		if (!error && (flags & ATTR_KERNOTIME) == 0) {
+			xfs_trans_ichgtime(args->trans, dp,
+					XFS_ICHGTIME_CHG);
+		}
+		err2 = xfs_trans_commit(args->trans);
+		error = error ? error : err2;
+	}
+	return error;
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -213,7 +251,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
-	int			error, err2, local;
+	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
 
@@ -292,30 +330,10 @@ xfs_attr_set(
 		 * Try to add the attr to the attribute list in
 		 * the inode.
 		 */
-		error = xfs_attr_shortform_addname(&args);
+		error = xfs_attr_try_sf_addname(dp, &args, flags);
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
-			err2 = xfs_trans_commit(args.trans);
 			xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
-			return error ? error : err2;
+			return error;
 		}
 
 		/*
-- 
2.7.4

