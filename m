Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38175 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdLKCQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 21:16:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBB2Cefc010572
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:40 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2esh08r0n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2GduR020707
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:39 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2GdR4010157
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:39 GMT
Subject: [PATCH 4/6] xfs: relax is_reflink_inode assert in
 xfs_reflink_find_cow_mapping
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 10 Dec 2017 18:16:41 -0800
Message-ID: <151295860143.30614.17097584029425726245.stgit@magnolia>
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

We don't hold the ilock through the entire sequence of xfs_writepage_map
-> xfs_map_cow -> xfs_reflink_find_cow_mapping.  This means that we can
race with another thread that is trying to clear the inode reflink flag,
with the result that the flag is set for the xfs_map_cow check but
cleared before we get to the assert in find_cow_mapping.  When this
happens, we blow the assert even though everything is fine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e13f5ad..99c5852 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -490,8 +490,9 @@ xfs_reflink_find_cow_mapping(
 	struct xfs_iext_cursor		icur;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
-	ASSERT(xfs_is_reflink_inode(ip));
 
+	if (!xfs_is_reflink_inode(ip))
+		return false;
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got))
 		return false;

