Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50430 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbeHBIDE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Aug 2018 04:03:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w726DXco124400
        for <linux-xfs@vger.kernel.org>; Thu, 2 Aug 2018 06:13:33 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2kge0d9vme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Aug 2018 06:13:33 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w726DXFr032045
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 2 Aug 2018 06:13:33 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w726DWeD032023
        for <linux-xfs@vger.kernel.org>; Thu, 2 Aug 2018 06:13:33 GMT
Date: Wed, 1 Aug 2018 23:13:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: only validate summary counts on primary superblock
Message-ID: <20180802061331.GP30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Skip the summary counter checks for secondary superblocks and inprogress
primary superblocks because mkfs has always written those out with
zeroed summary counters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: add the inprogress check
---
 fs/xfs/libxfs/xfs_sb.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ca1b3a7a9171..081f46e30556 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -148,6 +148,7 @@ xfs_validate_sb_read(
 STATIC int
 xfs_validate_sb_write(
 	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
 	struct xfs_sb		*sbp)
 {
 	/*
@@ -155,10 +156,15 @@ xfs_validate_sb_write(
 	 * the superblock.  We skip this in the read validator because there
 	 * could be newer superblocks in the log and if the values are garbage
 	 * even after replay we'll recalculate them at the end of log mount.
+	 *
+	 * mkfs has traditionally written zeroed counters to inprogress and
+	 * secondary superblocks, so allow this usage to continue because
+	 * we never read counters from such superblocks.
 	 */
-	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
-	    !xfs_verify_icount(mp, sbp->sb_icount) ||
-	    sbp->sb_ifree > sbp->sb_icount) {
+	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
+	    (sbp->sb_fdblocks > sbp->sb_dblocks ||
+	     !xfs_verify_icount(mp, sbp->sb_icount) ||
+	     sbp->sb_ifree > sbp->sb_icount)) {
 		xfs_warn(mp, "SB summary counter sanity check failed");
 		return -EFSCORRUPTED;
 	}
@@ -756,7 +762,7 @@ xfs_sb_write_verify(
 	error = xfs_validate_sb_common(mp, bp, &sb);
 	if (error)
 		goto out_error;
-	error = xfs_validate_sb_write(mp, &sb);
+	error = xfs_validate_sb_write(mp, bp, &sb);
 	if (error)
 		goto out_error;
 
