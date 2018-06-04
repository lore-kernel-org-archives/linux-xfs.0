Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40400 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbeFDTR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 15:17:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w54JFnRH057777
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 19:17:55 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2jbvynvwep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jun 2018 19:17:55 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w54JHttI016075
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 19:17:55 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w54JHsAo016602
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 19:17:55 GMT
Date: Mon, 4 Jun 2018 12:17:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/4] xfs: don't assert on corrupted unlinked inode list
Message-ID: <20180604191754.GP7825@magnolia>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152812862079.2736.15381483104759513267.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the per-ag inode number verifiers to detect corrupt lists and error
out, instead of using ASSERTs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 05207a64dd53..c85ae83e007f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2090,10 +2090,15 @@ xfs_iunlink_remove(
 	 * list this inode will go on.
 	 */
 	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	ASSERT(agino != 0);
+	if (!xfs_verify_agino(mp, agno, agino))
+		return -EFSCORRUPTED;
 	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	ASSERT(agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO));
-	ASSERT(agi->agi_unlinked[bucket_index]);
+	if (!xfs_verify_agino(mp, agno,
+			be32_to_cpu(agi->agi_unlinked[bucket_index]))) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				agi, sizeof(*agi));
+		return -EFSCORRUPTED;
+	}
 
 	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
 		/*
@@ -2171,8 +2176,12 @@ xfs_iunlink_remove(
 
 			last_offset = imap.im_boffset;
 			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
-			ASSERT(next_agino != NULLAGINO);
-			ASSERT(next_agino != 0);
+			if (!xfs_verify_agino(mp, agno, next_agino)) {
+				XFS_CORRUPTION_ERROR(__func__,
+						XFS_ERRLEVEL_LOW, mp,
+						last_dip, sizeof(*last_dip));
+				return -EFSCORRUPTED;
+			}
 		}
 
 		/*
