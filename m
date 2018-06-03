Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeFCXXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:23:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w53NL1PS190005
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:17 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jbvyp9fqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 23:23:17 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w53NNGuU030644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:16 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w53NNGnn016883
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:16 GMT
Subject: [PATCH 08/10] xfs: btree lookup shouldn't ASSERT on empty btree
 nodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 03 Jun 2018 16:23:15 -0700
Message-ID: <152806819494.18187.5772777797608092085.stgit@magnolia>
In-Reply-To: <152806814253.18187.4009340462930782844.stgit@magnolia>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a btree lookup encounters an empty btree node or an empty btree leaf
on a multi-level btree, that's evidence of a corrupt on-disk btree.
Therefore, we should return -EFSCORRUPTED to the upper levels, not an
ASSERT failure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6101ad685019..4e79baa230f9 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1939,7 +1939,8 @@ xfs_btree_lookup(
 			high = xfs_btree_get_numrecs(block);
 			if (!high) {
 				/* Block is empty, must be an empty leaf. */
-				ASSERT(level == 0 && cur->bc_nlevels == 1);
+				if (level != 0 || cur->bc_nlevels != 1)
+					return -EFSCORRUPTED;
 
 				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
 				*stat = 0;

