Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59594 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCpI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:45:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fRKf010293
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:08 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2hdrxnrk03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:08 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2j6EX022912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:07 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I2j6th028407
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:06 GMT
Subject: [PATCH 7/9] xfs: btree lookup shouldn't ASSERT on empty btree nodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:45:05 -0700
Message-ID: <152401950551.12719.2425224069506482998.stgit@magnolia>
In-Reply-To: <152401946245.12719.18338955003321437040.stgit@magnolia>
References: <152401946245.12719.18338955003321437040.stgit@magnolia>
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
index 6101ad6..4e79baa 100644
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

