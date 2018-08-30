Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57018 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbeH3Wfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 18:35:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7UISel4180333
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:32:16 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2m2y2pxecn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:32:16 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIWF4k015927
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:32:15 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIWFc3020400
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:32:15 GMT
Subject: [PATCH 06/18] xfs: realtime rmap btree transaction reservations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 30 Aug 2018 11:32:14 -0700
Message-ID: <153565393394.32612.114159822497813499.stgit@magnolia>
In-Reply-To: <153565389576.32612.11057291402738397706.stgit@magnolia>
References: <153565389576.32612.11057291402738397706.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrmapbt to add the record and a second
split in the regular rmapbt to record the rtrmapbt split.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f99a7aefe418..33922646ec65 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -74,7 +74,8 @@ xfs_allocfree_log_count(
 
 	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
+		blocks += max(num_ops * (2 * mp->m_rmap_maxlevels - 1),
+			      num_ops * (2 * mp->m_rtrmap_maxlevels - 1));
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
 
