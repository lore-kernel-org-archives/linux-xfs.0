Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46378 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755594AbeEaQeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 12:34:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4VGVJZ7121189
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:34:05 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2j9ev8fs9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:34:05 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4VGY4QF026240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:34:04 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4VGY4oo001919
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:34:04 GMT
Subject: [PATCH 3/4] xfs: strengthen rtalloc query range checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 May 2018 09:34:03 -0700
Message-ID: <152778444301.6891.15337114742525069233.stgit@magnolia>
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

Strengthen the rtalloc range query checks to make sure that the keys do
not run off the end of the realtime device inappropriately.  Note that
the query range functions require units of rt extents, not blocks,
despite the type name.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 7712f282d172..1855182c11ec 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1038,8 +1038,11 @@ xfs_rtalloc_query_range(
 
 	if (low_rec->ar_startblock > high_rec->ar_startblock)
 		return -EINVAL;
-	else if (low_rec->ar_startblock == high_rec->ar_startblock)
+	if (low_rec->ar_startblock >= mp->m_sb.sb_rextents ||
+	    low_rec->ar_startblock == high_rec->ar_startblock)
 		return 0;
+	if (high_rec->ar_startblock >= mp->m_sb.sb_rextents)
+		high_rec->ar_startblock = mp->m_sb.sb_rextents - 1;
 
 	/* Iterate the bitmap, looking for discrepancies. */
 	rtstart = low_rec->ar_startblock;
@@ -1083,7 +1086,7 @@ xfs_rtalloc_query_all(
 	struct xfs_rtalloc_rec		keys[2];
 
 	keys[0].ar_startblock = 0;
-	keys[1].ar_startblock = tp->t_mountp->m_sb.sb_rblocks;
+	keys[1].ar_startblock = tp->t_mountp->m_sb.sb_rextents - 1;
 	keys[0].ar_blockcount = keys[1].ar_blockcount = 0;
 
 	return xfs_rtalloc_query_range(tp, &keys[0], &keys[1], fn, priv);

