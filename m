Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448D8C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58C02076B
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FsnnoQiK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgI2RoC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:44:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55050 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728897AbgI2RoC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:44:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THeMOd061464;
        Tue, 29 Sep 2020 17:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mAZikhXhPaOuZwHxX1b0xxaKKiPkttpGNFfMm3piz8A=;
 b=FsnnoQiKigV0I4zIJMwiio4Ouo7VSavJI8xcrX7OrIYqfEhrcyV5ZlNFkZyQba+EoxAR
 dZju9LBMT7/TGk9gmzFn3tq8wOCUD65xuXMgQ3dd7A1zTM2yqFWB/zCE8gYAkA+sFhOw
 lomPK71BbDo1hhYvy6nrN7Rhu14+yD8KaOrEUlCfkIztkTVV5Eef23l5+y1KCkGsrPhJ
 p4FZvkax9YPMFoKX7x5q9G8gWPym0BTnedSeXtB5daLhq3vD7luvuq/cGOgdReBJMzbm
 E/STHzZitEm/mbnL9Q1sdZIvkFmCMhRbExXsNHAOcGWb+zCLA/89yJanKuTDz1Cthld0 vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33su5avcb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:43:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THer97146942;
        Tue, 29 Sep 2020 17:43:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33uv2e7vy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:43:55 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08THht5o028120;
        Tue, 29 Sep 2020 17:43:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:43:54 -0700
Subject: [PATCH 1/3] xfs: clean up bmap intent item recovery checking
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Date:   Tue, 29 Sep 2020 10:43:53 -0700
Message-ID: <160140143350.830434.10160569591329741062.stgit@magnolia>
In-Reply-To: <160140142711.830434.5161910313856677767.stgit@magnolia>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The bmap intent item checking code in xfs_bui_item_recover is spread all
over the function.  We should check the recovered log item at the top
before we allocate any resources or do anything else, so do that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c |   38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 126df48dae5f..c1f2cc3c42cb 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -437,8 +437,6 @@ xfs_bui_item_recover(
 	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
 	xfs_exntst_t			state;
-	enum xfs_bmap_intent_type	type;
-	bool				op_ok;
 	unsigned int			bui_type;
 	int				whichfork;
 	int				error = 0;
@@ -456,16 +454,19 @@ xfs_bui_item_recover(
 			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
 	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
 			XFS_INO_TO_FSB(mp, bmap->me_owner)));
-	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
+			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
+			XFS_ATTR_FORK : XFS_DATA_FORK;
+	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
+	switch (bui_type) {
 	case XFS_BMAP_MAP:
 	case XFS_BMAP_UNMAP:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return -EFSCORRUPTED;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
+	if (startblock_fsb == 0 ||
 	    bmap->me_len == 0 ||
 	    inode_fsb == 0 ||
 	    startblock_fsb >= mp->m_sb.sb_dblocks ||
@@ -493,32 +494,17 @@ xfs_bui_item_recover(
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 
-	/* Process deferred bmap item. */
-	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
-			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
-			XFS_ATTR_FORK : XFS_DATA_FORK;
-	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
-	switch (bui_type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		type = bui_type;
-		break;
-	default:
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		error = -EFSCORRUPTED;
-		goto err_inode;
-	}
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
-	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
-			bmap->me_startoff, bmap->me_startblock, &count, state);
+	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
+			whichfork, bmap->me_startoff, bmap->me_startblock,
+			&count, state);
 	if (error)
 		goto err_inode;
 
 	if (count > 0) {
-		ASSERT(type == XFS_BMAP_UNMAP);
+		ASSERT(bui_type == XFS_BMAP_UNMAP);
 		irec.br_startblock = bmap->me_startblock;
 		irec.br_blockcount = count;
 		irec.br_startoff = bmap->me_startoff;

