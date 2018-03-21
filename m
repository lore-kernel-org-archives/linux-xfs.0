Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbeCUDVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:21:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2L3L3q1166467
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 03:21:38 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2gufdj001k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 03:21:38 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2L3LbHs020806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 03:21:38 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2L3Lb8Q010444
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 03:21:37 GMT
Date: Tue, 20 Mar 2018 20:21:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/9] xfs: don't accept inode buffers with suspicious
 unlinked chains
Message-ID: <20180321032136.GQ1757@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152107377037.19571.8618901963505842632.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're verifying inode buffers, sanity-check the unlinked pointer.
We don't want to run the risk of trying to purge something that's
obviously broken.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 4fe17b3..f216d5b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -93,20 +93,26 @@ xfs_inode_buf_verify(
 	bool		readahead)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_agnumber_t	agno;
 	int		i;
 	int		ni;
 
 	/*
 	 * Validate the magic number and version of every inode in the buffer
 	 */
+	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
 	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
 	for (i = 0; i < ni; i++) {
 		int		di_ok;
 		xfs_dinode_t	*dip;
+		xfs_agino_t	unlinked_ino;
 
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
+		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
 		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
-			xfs_dinode_good_version(mp, dip->di_version);
+			xfs_dinode_good_version(mp, dip->di_version) &&
+			(unlinked_ino == NULLAGINO ||
+			 xfs_verify_agino(mp, agno, unlinked_ino));
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP))) {
 			if (readahead) {
@@ -122,9 +128,9 @@ xfs_inode_buf_verify(
 				(unsigned long long)bp->b_bn, i,
 				be16_to_cpu(dip->di_magic));
 #endif
+			return;
 		}
 	}
-	xfs_inobp_check(mp, bp);
 }
 
 
