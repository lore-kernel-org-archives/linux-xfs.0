Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34278 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbeAZCO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 21:14:56 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0Q2Eukp111720
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:14:56 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2fqucqg002-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:14:56 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q24tWD027553
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:04:55 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0Q24tGJ027269
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:04:55 GMT
Subject: [PATCH 1/6] xfs: refactor accounting updates out of xfs_bmap_btalloc
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jan 2018 18:04:54 -0800
Message-ID: <151693229417.7395.1737479240326881862.stgit@magnolia>
In-Reply-To: <151693228803.7395.12526880865470882359.stgit@magnolia>
References: <151693228803.7395.12526880865470882359.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move all the inode and quota accounting updates out of xfs_bmap_btalloc
in preparation for fixing some quota accounting problems with copy on
write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0c9c9cd..6ad79ea 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3337,6 +3337,26 @@ xfs_bmap_btalloc_filestreams(
 	return 0;
 }
 
+/* Update all inode and quota accounting for the allocation we just did. */
+static void
+xfs_bmap_btalloc_accounting(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	if (!(ap->flags & XFS_BMAPI_COWFORK))
+		ap->ip->i_d.di_nblocks += args->len;
+	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+	if (ap->wasdel)
+		ap->ip->i_delayed_blks -= args->len;
+	/*
+	 * Adjust the disk quota also. This was reserved
+	 * earlier.
+	 */
+	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
+		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
+		(long) args->len);
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -3571,19 +3591,7 @@ xfs_bmap_btalloc(
 			*ap->firstblock = args.fsbno;
 		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
-		if (!(ap->flags & XFS_BMAPI_COWFORK))
-			ap->ip->i_d.di_nblocks += args.len;
-		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
-		if (ap->wasdel)
-			ap->ip->i_delayed_blks -= args.len;
-		/*
-		 * Adjust the disk quota also. This was reserved
-		 * earlier.
-		 */
-		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-			ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
-					XFS_TRANS_DQ_BCOUNT,
-			(long) args.len);
+		xfs_bmap_btalloc_accounting(ap, &args);
 	} else {
 		ap->blkno = NULLFSBLOCK;
 		ap->length = 0;

