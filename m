Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E48C32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60CB824650
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fk6Rie0W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgATW7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:59:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38162 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATW7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:59:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMvTGI078572;
        Mon, 20 Jan 2020 22:57:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=qSyzxi6AVDyLLOY+c2+Slva7dv5Yt8+1LfJSZGQgVeg=;
 b=Fk6Rie0Wk7VNjBn91T7QRjnDEX0UwpzBT12caSHte6j3muY67Zada4oHuCtMs4dWPKls
 ABM9mZDJjanVr7DQSd64jmmxAgSPvnQglMo0Zrq+rUFTmQKuo9Vg16C1ZGgDrpGuIdma
 +TuDhDXeKWZO6Ust8oWPgDsFcc9UUO154vdN5UqRe1kjJnpsVnGHZ0//PuKXpW3zh3Sx
 BNaXXae9hGmOBONR4Bbc+b+Sam/aZfALD5a6tqVdEbO1iJQKepmDAivxsHirLWyQPeoT
 01PaGg3+6WFqJ/bpeMRd2c6BXNpg21IhrxJN3zrrGfQCCqB1j/hpbrOfCZdPDwesOLVT +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseu9u5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMnBJQ169330;
        Mon, 20 Jan 2020 22:57:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xmbj4m6kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:29 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00KMvShF011868;
        Mon, 20 Jan 2020 22:57:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:57:28 -0800
Subject: [PATCH 09/13] xfs: remove the xfs_btree_get_buf[ls] functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 20 Jan 2020 14:57:27 -0800
Message-ID: <157956104723.1166689.18009447992234814306.stgit@magnolia>
In-Reply-To: <157956098906.1166689.13651975861399490259.stgit@magnolia>
References: <157956098906.1166689.13651975861399490259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the xfs_btree_get_bufs and xfs_btree_get_bufl functions, since
they're pretty trivial oneliners.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c |   16 +++++++++-------
 fs/xfs/libxfs/xfs_bmap.c  |   14 +++++++++-----
 fs/xfs/libxfs/xfs_btree.c |   46 ---------------------------------------------
 fs/xfs/libxfs/xfs_btree.h |   21 ---------------------
 4 files changed, 18 insertions(+), 79 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index df25024275a1..7be6c8fbfcf9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1070,11 +1070,11 @@ xfs_alloc_ag_vextent_small(
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
@@ -2347,9 +2347,11 @@ xfs_free_agfl_block(
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
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4c2e046fbfad..cfcef076c72f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -730,11 +730,11 @@ xfs_bmap_extents_to_btree(
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
@@ -878,7 +878,11 @@ xfs_bmap_local_to_extents(
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
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2d53e5fdff70..fd300dc93ca4 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -678,52 +678,6 @@ xfs_btree_get_block(
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index fb9b2121c628..3eff7c321d43 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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

