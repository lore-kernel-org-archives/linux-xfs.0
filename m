Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41993 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751937AbdAXArB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 19:47:01 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0O0kwP2017857
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2017 00:46:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v0O0kw24029706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2017 00:46:58 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v0O0kucu014675
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2017 00:46:57 GMT
Date: Mon, 23 Jan 2017 16:46:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: verify dirblocklog correctly
Message-ID: <20170124004655.GG31202@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

sb_dirblklog is added to sb_blocklog to compute the directory block size
in bytes.  Therefore, we must compare the sum of both those values
against XFS_MAX_BLOCKSIZE_LOG, not just dirblklog.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2580262..584ec89 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -242,7 +242,7 @@ xfs_mount_validate_sb(
 	    sbp->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG			||
 	    sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG			||
 	    sbp->sb_blocksize != (1 << sbp->sb_blocklog)		||
-	    sbp->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG			||
+	    sbp->sb_dirblklog + sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG ||
 	    sbp->sb_inodesize < XFS_DINODE_MIN_SIZE			||
 	    sbp->sb_inodesize > XFS_DINODE_MAX_SIZE			||
 	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
