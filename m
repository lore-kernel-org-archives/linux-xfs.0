Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfAACVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:21:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012GwC9174951
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:29 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jqx44k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:21:29 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012LSZT013140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:28 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012LSgI026766
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:28 GMT
Subject: [PATCH 21/22] xfs: get rid of cross_rename
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:21:27 -0800
Message-ID: <154630928741.18437.12538028217269533890.stgit@magnolia>
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

Get rid of the largely pointless xfs_cross_rename now that we've
refactored its parent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   42 ++++++------------------------------------
 1 file changed, 6 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 52e29a27f514..f177e0ded21c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2018,36 +2018,6 @@ xfs_finish_rename(
 	return xfs_trans_commit(tp);
 }
 
-/*
- * xfs_cross_rename()
- *
- * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
- */
-STATIC int
-xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
-{
-	int			error;
-
-	error = xfs_dir_exchange(tp, dp1, name1, ip1, dp2, name2, ip2,
-			spaceres);
-	if (error)
-		goto out_trans_abort;
-
-	return xfs_finish_rename(tp);
-
-out_trans_abort:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 /*
  * xfs_rename_alloc_whiteout()
  *
@@ -2190,12 +2160,12 @@ xfs_rename(
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
-					target_dp, target_name, target_ip,
-					spaceres);
-
-	error = xfs_dir_rename(tp, src_dp, src_name, src_ip, target_dp,
-			target_name, target_ip, spaceres, wip);
+		error = xfs_dir_exchange(tp, src_dp, src_name, src_ip,
+					 target_dp, target_name, target_ip,
+					 spaceres);
+	else
+		error = xfs_dir_rename(tp, src_dp, src_name, src_ip, target_dp,
+				       target_name, target_ip, spaceres, wip);
 	if (error)
 		goto out_trans_cancel;
 
