Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29707CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E985D21872
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j5ah+o6u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392732AbfJYFPZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:15:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56968 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfJYFPZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:15:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5EHQ6107868
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cklCALz8FhMEhZBd5RH+n+3Vy+sH2uibrH0uBn9+ahg=;
 b=j5ah+o6uvpTh2j/4p5O/gVf/UsZwxfoNXjQ1G1TT9pZTcOlvhOhTdV0jITT2YgHDpJSl
 liHpYQm3BQNiTKZi6KGXZPqngqY9ACVzVL2g/xqIYFXYoqxnlnhZT7W3p0QF8DQaFKyb
 +Txc+hzI93qhTiN1ySMr6wqdqfsBA6Y85PuONnIHgzSB0xjjh9IYciqKrFvpngNlvWNr
 w9Atb11g/DuiTJVHMIPwsuWrTAl4rqlbjG2czDPfghy0PXFH7QQwZLn8HclOyJXM2xbf
 8J+Hl/6VDGSzMAPv6Yt4Za7oaYjkgeK4mbItthM06eW09FBwgErNmwWLv35bi4pQr/W5 ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqteq8512-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5DagA125957
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vunbkgux6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:23 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P5FM5e002433
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 22:15:22 -0700
Subject: [PATCH 1/2] xfs: refactor xfs_bmap_count_blocks using newer btree
 helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Oct 2019 22:15:21 -0700
Message-ID: <157198052157.2873576.11427854428031607748.stgit@magnolia>
In-Reply-To: <157198051549.2873576.10430329078588571923.stgit@magnolia>
References: <157198051549.2873576.10430329078588571923.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Currently, this function open-codes walking a bmbt to count the extents
and blocks in use by a particular inode fork.  Since we now have a
function to tally extent records from the incore extent tree and a btree
helper to count every block in a btree, replace all that with calls to
the helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |  146 +++++-------------------------------------------
 1 file changed, 15 insertions(+), 131 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4f443703065e..b70d5513b7e9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -228,106 +228,6 @@ xfs_bmap_count_leaves(
 	return numrecs;
 }
 
-/*
- * Count leaf blocks given a range of extent records originally
- * in btree format.
- */
-STATIC void
-xfs_bmap_disk_count_leaves(
-	struct xfs_mount	*mp,
-	struct xfs_btree_block	*block,
-	int			numrecs,
-	xfs_filblks_t		*count)
-{
-	int		b;
-	xfs_bmbt_rec_t	*frp;
-
-	for (b = 1; b <= numrecs; b++) {
-		frp = XFS_BMBT_REC_ADDR(mp, block, b);
-		*count += xfs_bmbt_disk_get_blockcount(frp);
-	}
-}
-
-/*
- * Recursively walks each level of a btree
- * to count total fsblocks in use.
- */
-STATIC int
-xfs_bmap_count_tree(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_ifork	*ifp,
-	xfs_fsblock_t		blockno,
-	int			levelin,
-	xfs_extnum_t		*nextents,
-	xfs_filblks_t		*count)
-{
-	int			error;
-	struct xfs_buf		*bp, *nbp;
-	int			level = levelin;
-	__be64			*pp;
-	xfs_fsblock_t           bno = blockno;
-	xfs_fsblock_t		nextbno;
-	struct xfs_btree_block	*block, *nextblock;
-	int			numrecs;
-
-	error = xfs_btree_read_bufl(mp, tp, bno, &bp, XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
-	if (error)
-		return error;
-	*count += 1;
-	block = XFS_BUF_TO_BLOCK(bp);
-
-	if (--level) {
-		/* Not at node above leaves, count this level of nodes */
-		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
-		while (nextbno != NULLFSBLOCK) {
-			error = xfs_btree_read_bufl(mp, tp, nextbno, &nbp,
-						XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
-			if (error)
-				return error;
-			*count += 1;
-			nextblock = XFS_BUF_TO_BLOCK(nbp);
-			nextbno = be64_to_cpu(nextblock->bb_u.l.bb_rightsib);
-			xfs_trans_brelse(tp, nbp);
-		}
-
-		/* Dive to the next level */
-		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
-		bno = be64_to_cpu(*pp);
-		error = xfs_bmap_count_tree(mp, tp, ifp, bno, level, nextents,
-				count);
-		if (error) {
-			xfs_trans_brelse(tp, bp);
-			XFS_ERROR_REPORT("xfs_bmap_count_tree(1)",
-					 XFS_ERRLEVEL_LOW, mp);
-			return -EFSCORRUPTED;
-		}
-		xfs_trans_brelse(tp, bp);
-	} else {
-		/* count all level 1 nodes and their leaves */
-		for (;;) {
-			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
-			numrecs = be16_to_cpu(block->bb_numrecs);
-			(*nextents) += numrecs;
-			xfs_bmap_disk_count_leaves(mp, block, numrecs, count);
-			xfs_trans_brelse(tp, bp);
-			if (nextbno == NULLFSBLOCK)
-				break;
-			bno = nextbno;
-			error = xfs_btree_read_bufl(mp, tp, bno, &bp,
-						XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
-			if (error)
-				return error;
-			*count += 1;
-			block = XFS_BUF_TO_BLOCK(bp);
-		}
-	}
-	return 0;
-}
-
 /*
  * Count fsblocks of the given fork.  Delayed allocation extents are
  * not counted towards the totals.
@@ -340,26 +240,19 @@ xfs_bmap_count_blocks(
 	xfs_extnum_t		*nextents,
 	xfs_filblks_t		*count)
 {
-	struct xfs_mount	*mp;	/* file system mount structure */
-	__be64			*pp;	/* pointer to block address */
-	struct xfs_btree_block	*block;	/* current btree block */
-	struct xfs_ifork	*ifp;	/* fork structure */
-	xfs_fsblock_t		bno;	/* block # of "block" */
-	int			level;	/* btree level, for checking */
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_btree_cur	*cur;
+	xfs_extlen_t		btblocks = 0;
 	int			error;
 
-	bno = NULLFSBLOCK;
-	mp = ip->i_mount;
 	*nextents = 0;
 	*count = 0;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+
 	if (!ifp)
 		return 0;
 
 	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
-	case XFS_DINODE_FMT_EXTENTS:
-		*nextents = xfs_bmap_count_leaves(ifp, count);
-		return 0;
 	case XFS_DINODE_FMT_BTREE:
 		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 			error = xfs_iread_extents(tp, ip, whichfork);
@@ -367,25 +260,16 @@ xfs_bmap_count_blocks(
 				return error;
 		}
 
-		/*
-		 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
-		 */
-		block = ifp->if_broot;
-		level = be16_to_cpu(block->bb_level);
-		ASSERT(level > 0);
-		pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
-		bno = be64_to_cpu(*pp);
-		ASSERT(bno != NULLFSBLOCK);
-		ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
-		ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
-
-		error = xfs_bmap_count_tree(mp, tp, ifp, bno, level,
-				nextents, count);
-		if (error) {
-			XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)",
-					XFS_ERRLEVEL_LOW, mp);
-			return -EFSCORRUPTED;
-		}
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
+		error = xfs_btree_count_blocks(cur, &btblocks);
+		xfs_btree_del_cursor(cur, error);
+		if (error)
+			return error;
+
+		*count += btblocks - 1;
+		/* fall through */
+	case XFS_DINODE_FMT_EXTENTS:
+		*nextents = xfs_bmap_count_leaves(ifp, count);
 		return 0;
 	}
 

