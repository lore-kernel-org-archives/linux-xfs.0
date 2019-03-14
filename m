Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48552 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfCNV3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:29:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2ELT70i156136
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:29:07 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2r430f41fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:29:07 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2ELT6Tr019006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:29:06 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2ELT6Jp023081
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:29:06 GMT
Subject: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:29:06 -0700
Message-ID: <155259894630.30230.10064390935593758177.stgit@magnolia>
In-Reply-To: <155259893433.30230.6566995969675098053.stgit@magnolia>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When writing to a delalloc region in the data fork, commit the new
allocations (of the da reservation) as unwritten so that the mappings
are only marked written once writeback completes successfully.  This
fixes the problem of stale data exposure if the system goes down during
targeted writeback of a specific region of a file, as tested by
generic/042.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 931edfdca22e..dae5f1734297 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4077,16 +4077,18 @@ xfs_bmapi_allocate(
 	bma->got.br_state = XFS_EXT_NORM;
 
 	/*
-	 * In the data fork, a wasdelay extent has been initialized, so
-	 * shouldn't be flagged as unwritten.
+	 * In the data fork, the pages backed by a delalloc extent have been
+	 * dirtied but not yet written to disk, so the allocation should be
+	 * marked unwritten.  Only after writeback completes successfully
+	 * should we convert those mappings to real, so that a crash during
+	 * writeback won't expose stale disk contents.
 	 *
 	 * For the cow fork, however, we convert delalloc reservations
 	 * (extents allocated for speculative preallocation) to
 	 * allocated unwritten extents, and only convert the unwritten
 	 * extents to real extents when we're about to write the data.
 	 */
-	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
-	    (bma->flags & XFS_BMAPI_PREALLOC))
+	if (bma->flags & XFS_BMAPI_PREALLOC)
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel)
@@ -4496,8 +4498,9 @@ xfs_bmapi_convert_delalloc(
 	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
 	bma.total = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
+	bma.flags = XFS_BMAPI_PREALLOC;
 	if (whichfork == XFS_COW_FORK)
-		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
+		bma.flags |= XFS_BMAPI_COWFORK;
 
 	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
 		bma.prev.br_startoff = NULLFILEOFF;
