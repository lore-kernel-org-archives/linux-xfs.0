Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32840 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbdIWHMK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Sep 2017 03:12:10 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8N7C9XX021115
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Sep 2017 07:12:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8N7C9ES009782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Sep 2017 07:12:09 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8N7C9Jw009406
        for <linux-xfs@vger.kernel.org>; Sat, 23 Sep 2017 07:12:09 GMT
Date: Sat, 23 Sep 2017 00:12:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: always swap the cow forks when swapping extents
Message-ID: <20170923071208.GN5728@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Since the CoW fork exists as a secondary data structure to the data
fork, we must always swap cow forks during swapext.  We also need to
swap the extent counts and reset the cowblocks tags.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index bc6c6e1..e9db7fc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -2122,11 +2122,31 @@ xfs_swap_extents(
 		ip->i_d.di_flags2 |= tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
 		tip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
 		tip->i_d.di_flags2 |= f & XFS_DIFLAG2_REFLINK;
+	}
+
+	/* Swap the cow forks. */
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		xfs_extnum_t	extnum;
+
+		ASSERT(ip->i_cformat == XFS_DINODE_FMT_EXTENTS);
+		ASSERT(tip->i_cformat == XFS_DINODE_FMT_EXTENTS);
+
+		extnum = ip->i_cnextents;
+		ip->i_cnextents = tip->i_cnextents;
+		tip->i_cnextents = extnum;
+
 		cowfp = ip->i_cowfp;
 		ip->i_cowfp = tip->i_cowfp;
 		tip->i_cowfp = cowfp;
-		xfs_inode_set_cowblocks_tag(ip);
-		xfs_inode_set_cowblocks_tag(tip);
+
+		if (ip->i_cowfp && ip->i_cnextents)
+			xfs_inode_set_cowblocks_tag(ip);
+		else
+			xfs_inode_clear_cowblocks_tag(ip);
+		if (tip->i_cowfp && tip->i_cnextents)
+			xfs_inode_set_cowblocks_tag(tip);
+		else
+			xfs_inode_clear_cowblocks_tag(tip);
 	}
 
 	xfs_trans_log_inode(tp, ip,  src_log_flags);
