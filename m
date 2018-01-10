Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34710 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbeAJVuH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 16:50:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0ALlHei109783
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 21:50:06 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2fdtjur527-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 21:50:06 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0ALo5Dt012929
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 21:50:05 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0ALo4Oc030225
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 21:50:04 GMT
Date: Wed, 10 Jan 2018 13:50:03 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: record whichfork in iext tracepoints
Message-ID: <20180110215003.GT5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Record the whichfork number of the fork being operated on in iext
tracepoints.  This makes it easier to trace our way through complex
remapping operations like copy on write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cd87985..1c38b79 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -233,6 +233,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__field(xfs_exntst_t, state)
 		__field(int, bmap_state)
 		__field(unsigned long, caller_ip)
+		__field(int, whichfork)
 	),
 	TP_fast_assign(
 		struct xfs_ifork	*ifp;
@@ -250,11 +251,19 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->state = r.br_state;
 		__entry->bmap_state = state;
 		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d ino 0x%llx state %s cur 0x%p/%d "
+		if (ifp == XFS_IFORK_PTR(ip, XFS_DATA_FORK))
+			__entry->whichfork = XFS_DATA_FORK;
+		else if (ifp == XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
+			__entry->whichfork = XFS_ATTR_FORK;
+		else if (ifp == XFS_IFORK_PTR(ip, XFS_COW_FORK))
+			__entry->whichfork = XFS_COW_FORK;
+		else
+			__entry->whichfork = -1;
+	),
+	TP_printk("dev %d:%d ino 0x%llx fork %d state %s cur 0x%p/%d "
 		  "offset %lld block %lld count %lld flag %d caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
+		  __entry->ino, __entry->whichfork,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
 		  __entry->leaf,
 		  __entry->pos,
