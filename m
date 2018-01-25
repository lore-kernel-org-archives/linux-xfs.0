Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39750 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbeAYF0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 00:26:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0P5QsEB007672
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2018 05:26:54 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2fq92jr05f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2018 05:26:54 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0P5QpQw026571
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2018 05:26:51 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0P5Qnn7020768
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2018 05:26:50 GMT
Date: Wed, 24 Jan 2018 21:26:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/11] xfs: refactor quota code in xfs_bmap_btalloc
Message-ID: <20180125052647.GF9068@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676027743.12349.3845769501491774512.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since we now have a dedicated function for dealing with CoW allocation
related quota updates in xfs_bmap_btalloc, we might as well refactor the
data/attr fork quota update into its own function too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4144487..2d99b7a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3402,6 +3402,25 @@ xfs_bmap_btalloc_filestreams(
 	return 0;
 }
 
+/* Deal with data/attr fork accounting when we allocate a block. */
+static void
+xfs_bmap_btalloc_quota(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	ap->ip->i_d.di_nblocks += args.len;
+	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+	if (ap->wasdel)
+		ap->ip->i_delayed_blks -= args.len;
+	/*
+	 * Adjust the disk quota also. This was reserved
+	 * earlier.
+	 */
+	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
+		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
+		(long) args.len);
+}
+
 /* Deal with CoW fork accounting when we allocate a block. */
 static void
 xfs_bmap_btalloc_quota_cow(
@@ -3679,18 +3698,7 @@ xfs_bmap_btalloc(
 			xfs_bmap_btalloc_quota_cow(ap, &args, orig_offset,
 					orig_length);
 		} else {
-			ap->ip->i_d.di_nblocks += args.len;
-			xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
-			if (ap->wasdel)
-				ap->ip->i_delayed_blks -= args.len;
-			/*
-			 * Adjust the disk quota also. This was reserved
-			 * earlier.
-			 */
-			xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-				ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
-						XFS_TRANS_DQ_BCOUNT,
-				(long) args.len);
+			xfs_bmap_btalloc_quota(ap, &args);
 		}
 	} else {
 		ap->blkno = NULLFSBLOCK;
