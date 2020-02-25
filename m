Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC37C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39B3321D7E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bydg6iib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgBYAPh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:15:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32900 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbgBYAPh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:15:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09OAr033765;
        Tue, 25 Feb 2020 00:15:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qLWsSsU31dLAtPmwEVMtMQ+ucCRkBT8ZxZa4isZpN9E=;
 b=Bydg6iibWR4L82gaAMeuRb+eg2+iqtKhswf4c+DQnw+PqGtETUvrb3HWEySwzcApL8uF
 fTwCY1VoOgcv7AVN6RajNQs0/4El1Z//5XyjVP6ST4mGGEqCX6K7GxZXUjL5WCgl6Nzg
 Y8g4fJEzbi3cdP7pGCMRU09hBcgV6al+2cuWcZt2k49bHV5GyTmO97KP/fe1gNrrmHNG
 GAZhxReDHe7T6XQbG/ikYc/+80S0HuQJptoEYAdQlz8es8zsnq8ObdUe3Qkm10OFYyMk
 xV7R4BJekFeqiCTeARwHD0R6Dw31AyKgV95Tslk/nN9iKp4ZO8kEIFJu9Hs3/i8nJeMz 7w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ycppr8h1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P06hHt099197;
        Tue, 25 Feb 2020 00:15:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ybduvg3bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:30 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0FT3R000657;
        Tue, 25 Feb 2020 00:15:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:15:29 -0800
Subject: [PATCH 12/14] xfs: remove the xfs_btree_get_buf[ls] functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Mon, 24 Feb 2020 16:15:28 -0800
Message-ID: <158258972846.453666.15908646021943390229.stgit@magnolia>
In-Reply-To: <158258964941.453666.10913737544282124969.stgit@magnolia>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=2 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: ee647f85cb81b09bbfa2886954828ed03fa3ec38

Remove the xfs_btree_get_bufs and xfs_btree_get_bufl functions, since
they're pretty trivial oneliners.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |   16 +++++++++-------
 libxfs/xfs_bmap.c  |   14 +++++++++-----
 libxfs/xfs_btree.c |   46 ----------------------------------------------
 libxfs/xfs_btree.h |   21 ---------------------
 4 files changed, 18 insertions(+), 79 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1bf813e3..be1bf736 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1066,11 +1066,11 @@ xfs_alloc_ag_vextent_small(
 	if (args->datatype & XFS_ALLOC_USERDATA) {
 		struct xfs_buf	*bp;
 
-		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
-		if (XFS_IS_CORRUPT(args->mp, !bp)) {
-			error = -EFSCORRUPTED;
+		error = xfs_trans_get_buf(args->tp, args->mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(args->mp, args->agno, fbno),
+				args->mp->m_bsize, 0, &bp);
+		if (error)
 			goto error;
-		}
 		xfs_trans_binval(args->tp, bp);
 	}
 	*fbnop = args->agbno = fbno;
@@ -2343,9 +2343,11 @@ xfs_free_agfl_block(
 	if (error)
 		return error;
 
-	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
-	if (XFS_IS_CORRUPT(tp->t_mountp, !bp))
-		return -EFSCORRUPTED;
+	error = xfs_trans_get_buf(tp, tp->t_mountp->m_ddev_targp,
+			XFS_AGB_TO_DADDR(tp->t_mountp, agno, agbno),
+			tp->t_mountp->m_bsize, 0, &bp);
+	if (error)
+		return error;
 	xfs_trans_binval(tp, bp);
 
 	return 0;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5efa2f0c..f917a6eb 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -723,11 +723,11 @@ xfs_bmap_extents_to_btree(
 	cur->bc_private.b.allocated++;
 	ip->i_d.di_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
-	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
-	if (XFS_IS_CORRUPT(mp, !abp)) {
-		error = -EFSCORRUPTED;
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, args.fsbno),
+			mp->m_bsize, 0, &abp);
+	if (error)
 		goto out_unreserve_dquot;
-	}
 
 	/*
 	 * Fill in the child block.
@@ -871,7 +871,11 @@ xfs_bmap_local_to_extents(
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(args.len == 1);
 	tp->t_firstblock = args.fsbno;
-	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno);
+	error = xfs_trans_get_buf(tp, args.mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(args.mp, args.fsbno),
+			args.mp->m_bsize, 0, &bp);
+	if (error)
+		goto done;
 
 	/*
 	 * Initialize the block, copy the data and log the remote buffer.
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index aeaa9623..57862dfa 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -675,52 +675,6 @@ xfs_btree_get_block(
 	return XFS_BUF_TO_BLOCK(*bpp);
 }
 
-/*
- * Get a buffer for the block, return it with no data read.
- * Long-form addressing.
- */
-xfs_buf_t *				/* buffer for fsbno */
-xfs_btree_get_bufl(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_fsblock_t	fsbno)		/* file system block number */
-{
-	struct xfs_buf		*bp;
-	xfs_daddr_t		d;		/* real disk block address */
-	int			error;
-
-	ASSERT(fsbno != NULLFSBLOCK);
-	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
-	if (error)
-		return NULL;
-	return bp;
-}
-
-/*
- * Get a buffer for the block, return it with no data read.
- * Short-form addressing.
- */
-xfs_buf_t *				/* buffer for agno/agbno */
-xfs_btree_get_bufs(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_agblock_t	agbno)		/* allocation group block number */
-{
-	struct xfs_buf		*bp;
-	xfs_daddr_t		d;		/* real disk block address */
-	int			error;
-
-	ASSERT(agno != NULLAGNUMBER);
-	ASSERT(agbno != NULLAGBLOCK);
-	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
-	if (error)
-		return NULL;
-	return bp;
-}
-
 /*
  * Change the cursor to point to the first record at the given level.
  * Other levels are unaffected.
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 2e727f23..8bead747 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -296,27 +296,6 @@ xfs_btree_dup_cursor(
 	xfs_btree_cur_t		*cur,	/* input cursor */
 	xfs_btree_cur_t		**ncur);/* output cursor */
 
-/*
- * Get a buffer for the block, return it with no data read.
- * Long-form addressing.
- */
-struct xfs_buf *				/* buffer for fsbno */
-xfs_btree_get_bufl(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_fsblock_t		fsbno);	/* file system block number */
-
-/*
- * Get a buffer for the block, return it with no data read.
- * Short-form addressing.
- */
-struct xfs_buf *				/* buffer for agno/agbno */
-xfs_btree_get_bufs(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	xfs_agblock_t		agbno);	/* allocation group block number */
-
 /*
  * Compute first and last byte offsets for the fields given.
  * Interprets the offsets table, which contains struct field offsets.

