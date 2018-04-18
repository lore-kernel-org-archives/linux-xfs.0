Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:40:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2aFmj007077
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:22 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2hdrxnrjr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:21 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2eLSh014018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:21 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2eLrK025377
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:21 GMT
Subject: [PATCH 07/11] xfs: superblock scrub should use uncached buffers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:40:20 -0700
Message-ID: <152401922015.11465.14941366292853283272.stgit@magnolia>
In-Reply-To: <152401916729.11465.4212188839231900136.stgit@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We've never cached buffers when reading or writing superblocks, so we
need to change scrub to do likewise or risk screwing up the uncached sb
buffer usage everywhere else.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 018aabbd..aacbc3f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -157,7 +157,7 @@ xfs_scrub_superblock(
 	if (agno == 0)
 		return 0;
 
-	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+	error = xfs_buf_read_uncached(mp->m_ddev_targp,
 		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 		  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
 	/*
@@ -421,6 +421,7 @@ xfs_scrub_superblock(
 		xfs_scrub_block_set_corrupt(sc, bp);
 
 	xfs_scrub_superblock_xref(sc, bp);
+	xfs_buf_relse(bp);
 
 	return error;
 }

