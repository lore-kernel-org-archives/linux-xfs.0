Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdLKCQT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 21:16:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBB2CCWR126004
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:19 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2esh0700jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:18 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2GIOP018377
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:18 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2GIpp007914
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:18 GMT
Subject: [PATCH 1/6] xfs: account for null transactions in bunmapi
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 10 Dec 2017 18:16:20 -0800
Message-ID: <151295858045.30614.4101979123861411900.stgit@magnolia>
In-Reply-To: <151295857424.30614.8269461794142248028.stgit@magnolia>
References: <151295857424.30614.8269461794142248028.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

In e1a4e37cc7b665 ("xfs: try to avoid blowing out the transaction
reservation when bunmaping a shared extent"), we try to constrain the
amount of real extents we unmap from the data fork in a given call so
that we don't blow out transaction reservations.

However, not all bunmapi operations require a transaction -- if we're
only removing a delalloc extent, no transaction is needed, so we have to
code against that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1210f68..1bddbba 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5136,7 +5136,7 @@ __xfs_bunmapi(
 	 * blowing out the transaction with a mix of EFIs and reflink
 	 * adjustments.
 	 */
-	if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK)
+	if (tp && xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK)
 		max_len = min(len, xfs_refcount_max_unmap(tp->t_log_res));
 	else
 		max_len = len;

