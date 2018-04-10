Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52036 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbeDJFN7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Apr 2018 01:13:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3A5BU9q126402
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 05:13:58 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2h6ny38cr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 05:13:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3A5Dw8Z017658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 05:13:58 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3A5Dwiv027692
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 05:13:58 GMT
Date: Mon, 9 Apr 2018 22:13:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: only cancel cow blocks when truncating the data fork
Message-ID: <20180410051357.GR7500@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_itruncate_extents, only cancel cow blocks and clear the reflink
flag if we were asked to truncate the data fork.  Attr fork blocks
cannot be shared, so this makes no sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e7907d2..383258e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1611,13 +1611,15 @@ xfs_itruncate_extents(
 			goto out;
 	}
 
-	/* Remove all pending CoW reservations. */
-	error = xfs_reflink_cancel_cow_blocks(ip, &tp, first_unmap_block,
-			last_block, true);
-	if (error)
-		goto out;
+	if (whichfork == XFS_DATA_FORK) {
+		/* Remove all pending CoW reservations. */
+		error = xfs_reflink_cancel_cow_blocks(ip, &tp,
+				first_unmap_block, last_block, true);
+		if (error)
+			goto out;
 
-	xfs_itruncate_clear_reflink_flags(ip);
+		xfs_itruncate_clear_reflink_flags(ip);
+	}
 
 	/*
 	 * Always re-log the inode so that our permanent transaction can keep
