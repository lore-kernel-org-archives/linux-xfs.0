Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756468AbeAHTkT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 14:40:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.21) with SMTP id w08Jaem8175051
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jan 2018 19:40:18 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fcesmg295-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jan 2018 19:40:18 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w08JeHh8032492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jan 2018 19:40:17 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w08JeG9I019350
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jan 2018 19:40:16 GMT
Date: Mon, 8 Jan 2018 11:40:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: clarify units in the failed metadata io message
Message-ID: <20180108194015.GT5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If a metadata IO error happens, we report the location of the failed IO
request in units of daddrs.  However, the printk message misleads people
into thinking that the units are fs blocks, so fix the reported units.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1981ef7..582c64a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1196,7 +1196,7 @@ xfs_buf_ioerror_alert(
 	const char		*func)
 {
 	xfs_alert(bp->b_target->bt_mount,
-"metadata I/O error: block 0x%llx (\"%s\") error %d numblks %d",
+"metadata I/O error: daddr 0x%llx (\"%s\") error %d numblks %d",
 		(uint64_t)XFS_BUF_ADDR(bp), func, -bp->b_error, bp->b_length);
 }
 
