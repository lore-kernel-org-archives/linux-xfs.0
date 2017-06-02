Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42791 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdFBVYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 17:24:52 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52LOpGW015491
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v52LOoCF005850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:50 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v52LOocq028426
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:50 GMT
Subject: [PATCH 08/13] xfs: reflink find shared should take a transaction
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 14:24:49 -0700
Message-ID: <149643868895.23065.15189624249509263530.stgit@birch.djwong.org>
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Adapt _reflink_find_shared to take an optional transaction pointer.  The
inode scrubber code will need to decide (within transaction context) if
a file has shared blocks.  To avoid buffer deadlocks, we must pass the
tp through to this function's utility calls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    4 ++--
 fs/xfs/xfs_reflink.c   |   15 ++++++++-------
 fs/xfs/xfs_reflink.h   |    6 +++---
 3 files changed, 13 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 308428d..fe83bbc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -455,8 +455,8 @@ xfs_getbmap_adjust_shared(
 
 	agno = XFS_FSB_TO_AGNO(mp, map->br_startblock);
 	agbno = XFS_FSB_TO_AGBNO(mp, map->br_startblock);
-	error = xfs_reflink_find_shared(mp, agno, agbno, map->br_blockcount,
-			&ebno, &elen, true);
+	error = xfs_reflink_find_shared(mp, NULL, agno, agbno,
+			map->br_blockcount, &ebno, &elen, true);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ffe6fe7..e25c995 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -155,6 +155,7 @@
 int
 xfs_reflink_find_shared(
 	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen,
@@ -166,18 +167,18 @@ xfs_reflink_find_shared(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		return error;
 
-	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 
 	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
 			find_end_of_shared);
 
 	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 
-	xfs_buf_relse(agbp);
+	xfs_trans_brelse(tp, agbp);
 	return error;
 }
 
@@ -217,7 +218,7 @@ xfs_reflink_trim_around_shared(
 	agbno = XFS_FSB_TO_AGBNO(ip->i_mount, irec->br_startblock);
 	aglen = irec->br_blockcount;
 
-	error = xfs_reflink_find_shared(ip->i_mount, agno, agbno,
+	error = xfs_reflink_find_shared(ip->i_mount, NULL, agno, agbno,
 			aglen, &fbno, &flen, true);
 	if (error)
 		return error;
@@ -1373,8 +1374,8 @@ xfs_reflink_dirty_extents(
 			agbno = XFS_FSB_TO_AGBNO(mp, map[1].br_startblock);
 			aglen = map[1].br_blockcount;
 
-			error = xfs_reflink_find_shared(mp, agno, agbno, aglen,
-					&rbno, &rlen, true);
+			error = xfs_reflink_find_shared(mp, NULL, agno, agbno,
+					aglen, &rbno, &rlen, true);
 			if (error)
 				goto out;
 			if (rbno == NULLAGBLOCK)
@@ -1445,7 +1446,7 @@ xfs_reflink_clear_inode_flag(
 		agbno = XFS_FSB_TO_AGBNO(mp, map.br_startblock);
 		aglen = map.br_blockcount;
 
-		error = xfs_reflink_find_shared(mp, agno, agbno, aglen,
+		error = xfs_reflink_find_shared(mp, *tpp, agno, agbno, aglen,
 				&rbno, &rlen, false);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index d29a796..b8cc5c3 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -20,9 +20,9 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
-extern int xfs_reflink_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
-		xfs_extlen_t *flen, bool find_maximal);
+extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_agnumber_t agno, xfs_agblock_t agbno, xfs_extlen_t aglen,
+		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
 

