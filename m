Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34601 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932605AbdKGBDg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 20:03:36 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA713ZD2030251
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA713ZU6009165
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:35 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA713ZF6031903
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:35 GMT
Subject: [PATCH 2/5] xfs: refactor the directory data block bestfree checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 06 Nov 2017 17:03:33 -0800
Message-ID: <151001661390.26786.10161063535996587375.stgit@magnolia>
In-Reply-To: <151001660179.26786.15701876786383794673.stgit@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

In a directory data block, the zeroth bestfree item must point to the
longest free space.  Therefore, when we check the bestfree block's
records against the data blocks, we only need to compare with bf[0] and
don't need the loop.

The weird loop was most probably the result of an earlier refactoring
gone bad.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index d4cd766..c8ca3fd 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -435,25 +435,15 @@ xfs_scrub_directory_check_freesp(
 	struct xfs_buf			*dbp,
 	unsigned int			len)
 {
-	struct xfs_dir2_data_free	*bf;
 	struct xfs_dir2_data_free	*dfp;
-	int				offset;
 
-	if (len == 0)
-		return;
+	dfp = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
 
-	bf = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
-	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
-		offset = be16_to_cpu(dfp->offset);
-		if (offset == 0)
-			break;
-		if (len == be16_to_cpu(dfp->length))
-			return;
-		/* Didn't find the best length in the bestfree data */
-		break;
-	}
+	if (len != be16_to_cpu(dfp->length))
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 
-	xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+	if (len > 0 && be16_to_cpu(dfp->offset) == 0)
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 }
 
 /* Check free space info in a directory leaf1 block. */

