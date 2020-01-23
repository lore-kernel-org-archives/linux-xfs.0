Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A7BC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BC2124125
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eb8fqMAN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgAWHnD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:43:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43900 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgAWHnD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:43:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7gsKY148121;
        Thu, 23 Jan 2020 07:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=qSyzxi6AVDyLLOY+c2+Slva7dv5Yt8+1LfJSZGQgVeg=;
 b=eb8fqMANfWsHp/cJMt3n9isVD8JzcBt3HFim5qzwYoxeMnKKSjCI+HJ5FWWAukWY80Qh
 eZlfKHD35Z7uPrczF1qPoBM+oUBqk2pSb+LkEN6qhSviAapOT/PVTrgZ3vv/0AtJIK67
 jr6Lw7dERn2NPHZBtTyea/GktUVwYRqPIY9D1xu0ALzyP9EYTr/rO7empI5xWCsenquh
 K59Gu/mkRS+e8Ms4YowVIG/5Djcd/GDkly87+vPp9wAcUsNl9KbFaPJ9I9DFFoW9TnDa
 qyIBFErqMmrbiYMKrkur4TOn7QJWyh7rMV72uZrGUtml6ANdCEepMZdzt931G95J2XzD mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnrga0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cwWV163901;
        Thu, 23 Jan 2020 07:42:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xpq7m4rgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00N7gnFt018327;
        Thu, 23 Jan 2020 07:42:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:42:49 -0800
Subject: [PATCH 09/12] xfs: remove the xfs_btree_get_buf[ls] functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 22 Jan 2020 23:42:48 -0800
Message-ID: <157976536826.2388944.18178452175492745683.stgit@magnolia>
In-Reply-To: <157976531016.2388944.3654360225810285604.stgit@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230066
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

