Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31228 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbdGRSYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 14:24:18 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6IIOI3x029169
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 18:24:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6IIOHMV028048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 18:24:18 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6IIOHoS012968
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 18:24:17 GMT
Subject: [PATCH 1/3] xfs: check _btree_check_block value
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Jul 2017 11:24:16 -0700
Message-ID: <150040225662.1216.16823172616535217786.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the _btree_check_block return value for the firstrec and lastrec
functions, since we have the ability to signal that the repositioning
did not succeed.

Fixes-coverity-id: 114067
Fixes-coverity-id: 114068
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4da85ff..e0bcc4a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -728,7 +728,8 @@ xfs_btree_firstrec(
 	 * Get the block pointer for this level.
 	 */
 	block = xfs_btree_get_block(cur, level, &bp);
-	xfs_btree_check_block(cur, block, level, bp);
+	if (xfs_btree_check_block(cur, block, level, bp))
+		return 0;
 	/*
 	 * It's empty, there is no such record.
 	 */
@@ -757,7 +758,8 @@ xfs_btree_lastrec(
 	 * Get the block pointer for this level.
 	 */
 	block = xfs_btree_get_block(cur, level, &bp);
-	xfs_btree_check_block(cur, block, level, bp);
+	if (xfs_btree_check_block(cur, block, level, bp))
+		return 0;
 	/*
 	 * It's empty, there is no such record.
 	 */

