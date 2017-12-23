Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757099AbdLWBMN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:12:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1C7GY079455
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:12:12 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2f1cvd817n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:12:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN17BSW021015
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:11 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN17BMH005833
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:11 GMT
Subject: [PATCH 01/20] xfs: remove XFS_FSB_SANITY_CHECK
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:07:09 -0800
Message-ID: <151399122992.23543.9403402573788285274.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We already have a function to verify fsb pointers, so get rid of the
last users of the (less robust) macro.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |    4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c |    4 ++--
 fs/xfs/libxfs/xfs_btree.c      |    2 +-
 fs/xfs/libxfs/xfs_btree.h      |    4 ----
 4 files changed, 5 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1bddbba..1407447 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -400,7 +400,7 @@ xfs_bmap_check_leaf_extents(
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		XFS_WANT_CORRUPTED_GOTO(mp,
-					XFS_FSB_SANITY_CHECK(mp, bno), error0);
+					xfs_verify_fsbno(mp, bno), error0);
 		if (bp_release) {
 			bp_release = 0;
 			xfs_trans_brelse(NULL, bp);
@@ -1220,7 +1220,7 @@ xfs_iread_extents(
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		XFS_WANT_CORRUPTED_GOTO(mp,
-			XFS_FSB_SANITY_CHECK(mp, bno), out_brelse);
+			xfs_verify_fsbno(mp, bno), out_brelse);
 		xfs_trans_brelse(tp, bp);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index c10aeca..00472e1 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -470,11 +470,11 @@ xfs_bmbt_verify(
 	/* sibling pointer verification */
 	if (!block->bb_u.l.bb_leftsib ||
 	    (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_leftsib))))
+	     !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_leftsib))))
 		return false;
 	if (!block->bb_u.l.bb_rightsib ||
 	    (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_rightsib))))
+	     !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_rightsib))))
 		return false;
 
 	return true;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index e0bdff3..5a6146e 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -853,7 +853,7 @@ xfs_btree_read_bufl(
 	xfs_daddr_t		d;		/* real disk block address */
 	int			error;
 
-	if (!XFS_FSB_SANITY_CHECK(mp, fsbno))
+	if (!xfs_verify_fsbno(mp, fsbno))
 		return -EFSCORRUPTED;
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 551a2a0..8a263ea 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -473,10 +473,6 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 #define	XFS_FILBLKS_MIN(a,b)	min_t(xfs_filblks_t, (a), (b))
 #define	XFS_FILBLKS_MAX(a,b)	max_t(xfs_filblks_t, (a), (b))
 
-#define	XFS_FSB_SANITY_CHECK(mp,fsb)	\
-	(fsb && XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
-		XFS_FSB_TO_AGBNO(mp, fsb) < mp->m_sb.sb_agblocks)
-
 /*
  * Trace hooks.  Currently not implemented as they need to be ported
  * over to the generic tracing functionality, which is some effort.

