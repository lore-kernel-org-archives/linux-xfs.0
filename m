Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753208AbeARAHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 19:07:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0I07Ttf036975
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:46 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2fjetj0dvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:46 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0I07jow013889
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:45 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0I07jXu003506
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:45 GMT
Subject: [PATCH 5/5] xfs: scrub should flag (and repair) unfixed agfls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 16:07:43 -0800
Message-ID: <151623406358.4727.1655021837392456302.stgit@magnolia>
In-Reply-To: <151623403113.4727.2418454911805718650.stgit@magnolia>
References: <151623403113.4727.2418454911805718650.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If somehow we let a fs with an unfixed agfl slip by, we should flag it
and try to repair it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index fbd1744..d548656 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -160,8 +160,13 @@ xfs_scrub_superblock(
 	__be16				vernum_mask;
 
 	agno = sc->sm->sm_agno;
-	if (agno == 0)
+	if (agno == 0) {
+		/* If we somehow don't have a fixed agfl, preen... */
+		if (xfs_sb_version_hascrc(&mp->m_sb) &&
+		    !xfs_sb_version_hasfixedagfl(&mp->m_sb))
+			xfs_scrub_block_set_preen(sc, mp->m_sb_bp);
 		return 0;
+	}
 
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
 		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
@@ -444,8 +449,13 @@ xfs_repair_superblock(
 
 	/* Don't try to repair AG 0's sb; let xfs_repair deal with it. */
 	agno = sc->sm->sm_agno;
-	if (agno == 0)
+	if (agno == 0) {
+		/* Try to fix the AGFLs if we don't have the feature set */
+		if ((sc->sm->sm_flags & XFS_SCRUB_OFLAG_PREEN) &&
+		    !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+			return xfs_agf_fixup_freelist_counts(mp);
 		return -EOPNOTSUPP;
+	}
 
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
 		  XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),

