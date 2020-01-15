Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5CFC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8E90214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c1MQ87Yy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgAOREs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:04:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46658 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAOREs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:04:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhOAw012327;
        Wed, 15 Jan 2020 17:04:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=16ucMzSCkirqk334GdhKB86M4CnqPEYUJL0SbF9A520=;
 b=c1MQ87Yy0SUsGYuoDwcQaSreHD+UwrMzZ1CckPISkLV7J70RShCvZyVwsqitY/RV69s2
 2fRoTsu7bYPpVme+PFmYL5pOiN55nqnbJ6zJz/H4Lh9l2F6UvKJnsGAnTXsrlPNl8maD
 kcHoA7k+v/O/qxvT7L7liU68+OL5y62cnLon0WwR13Zpm9nKU6yHKxeSJegHcLI+S9xB
 nEXVJIA/VzkdGYaYBCkd/ePjM4SfifOsMg7p4iKlPZyudx8ausyoxveOHINv2K494RUr
 XU6MKCaSfhxa7cGpZthzK1xk748T29l+kXBA0nm+aNbAEgfJgWQVaUOUafyPCds9GXkU yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yne5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGiXws183122;
        Wed, 15 Jan 2020 17:04:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xj1apwss6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FH4dRf024282;
        Wed, 15 Jan 2020 17:04:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:04:39 -0800
Subject: [PATCH 9/9] xfs: make xfs_btree_get_buf functions return an error
 code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:04:38 -0800
Message-ID: <157910787821.2028217.9307411154179566922.stgit@magnolia>
In-Reply-To: <157910781961.2028217.1250106765923436515.stgit@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert both xfs_btree_get_buf() functions to return numeric error codes
like most everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   13 ++++++-------
 fs/xfs/libxfs/xfs_bmap.c  |   10 +++++-----
 fs/xfs/libxfs/xfs_btree.c |   36 ++++++++++++++----------------------
 fs/xfs/libxfs/xfs_btree.h |   16 +++++-----------
 4 files changed, 30 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 53410819691b..542f6ad7e5b4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1070,11 +1070,10 @@ xfs_alloc_ag_vextent_small(
 	if (args->datatype & XFS_ALLOC_USERDATA) {
 		struct xfs_buf	*bp;
 
-		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
-		if (XFS_IS_CORRUPT(args->mp, !bp)) {
-			error = -EFSCORRUPTED;
+		error = xfs_btree_get_bufs(args->mp, args->tp, args->agno,
+				fbno, &bp);
+		if (error)
 			goto error;
-		}
 		xfs_trans_binval(args->tp, bp);
 	}
 	*fbnop = args->agbno = fbno;
@@ -2347,9 +2346,9 @@ xfs_free_agfl_block(
 	if (error)
 		return error;
 
-	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
-	if (XFS_IS_CORRUPT(tp->t_mountp, !bp))
-		return -EFSCORRUPTED;
+	error = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno, &bp);
+	if (error)
+		return error;
 	xfs_trans_binval(tp, bp);
 
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4c2e046fbfad..4544732d09a5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -730,11 +730,9 @@ xfs_bmap_extents_to_btree(
 	cur->bc_private.b.allocated++;
 	ip->i_d.di_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
-	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
-	if (XFS_IS_CORRUPT(mp, !abp)) {
-		error = -EFSCORRUPTED;
+	error = xfs_btree_get_bufl(mp, tp, args.fsbno, &abp);
+	if (error)
 		goto out_unreserve_dquot;
-	}
 
 	/*
 	 * Fill in the child block.
@@ -878,7 +876,9 @@ xfs_bmap_local_to_extents(
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(args.len == 1);
 	tp->t_firstblock = args.fsbno;
-	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno);
+	error = xfs_btree_get_bufl(args.mp, tp, args.fsbno, &bp);
+	if (error)
+		goto done;
 
 	/*
 	 * Initialize the block, copy the data and log the remote buffer.
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2d53e5fdff70..0a7e2265dec1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -682,46 +682,38 @@ xfs_btree_get_block(
  * Get a buffer for the block, return it with no data read.
  * Long-form addressing.
  */
-xfs_buf_t *				/* buffer for fsbno */
+int
 xfs_btree_get_bufl(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_fsblock_t	fsbno)		/* file system block number */
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		fsbno,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
 	xfs_daddr_t		d;		/* real disk block address */
-	int			error;
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
-	if (error)
-		return NULL;
-	return bp;
+	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, bpp);
 }
 
 /*
  * Get a buffer for the block, return it with no data read.
  * Short-form addressing.
  */
-xfs_buf_t *				/* buffer for agno/agbno */
+int
 xfs_btree_get_bufs(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_agblock_t	agbno)		/* allocation group block number */
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
-	xfs_daddr_t		d;		/* real disk block address */
-	int			error;
+	xfs_daddr_t		d;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agbno != NULLAGBLOCK);
 	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
-	if (error)
-		return NULL;
-	return bp;
+	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, bpp);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index fb9b2121c628..97c2b5e75210 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -300,22 +300,16 @@ xfs_btree_dup_cursor(
  * Get a buffer for the block, return it with no data read.
  * Long-form addressing.
  */
-struct xfs_buf *				/* buffer for fsbno */
-xfs_btree_get_bufl(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_fsblock_t		fsbno);	/* file system block number */
+int xfs_btree_get_bufl(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_fsblock_t fsbno, struct xfs_buf **bpp);
 
 /*
  * Get a buffer for the block, return it with no data read.
  * Short-form addressing.
  */
-struct xfs_buf *				/* buffer for agno/agbno */
-xfs_btree_get_bufs(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	xfs_agblock_t		agbno);	/* allocation group block number */
+int xfs_btree_get_bufs(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_agnumber_t agno, xfs_agblock_t agbno,
+		struct xfs_buf **bpp);
 
 /*
  * Compute first and last byte offsets for the fields given.

