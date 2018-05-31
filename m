Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755693AbeEaQd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 12:33:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4VGVojQ039168
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2j9x4hcttm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:58 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4VGXwT9015757
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:58 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4VGXvqV007916
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:57 GMT
Subject: [PATCH 2/4] xfs: xfs_rtbuf_get should check the bmapi_read results
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 May 2018 09:33:57 -0700
Message-ID: <152778443693.6891.16527148773204429254.stgit@magnolia>
In-Reply-To: <152778442467.6891.15278589749191666547.stgit@magnolia>
References: <152778442467.6891.15278589749191666547.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The xfs_rtbuf_get function should check the block mapping it gets back
from bmapi_read.  If there are no mappings or the mapping isn't a real
extent, we should return -EFSCORRUPTED rather than trying to read a
garbage value.  We also require realtime bitmap blocks to be real,
written allocations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 106be2d0bb88..7712f282d172 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -90,6 +90,9 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
+	if (nmap == 0 || !xfs_bmap_is_real_extent(&map))
+		return -EFSCORRUPTED;
+
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),

