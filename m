Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895A6C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50EDF23120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgLFXKx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:10:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56030 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLFXKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:10:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N60ss182080;
        Sun, 6 Dec 2020 23:10:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Z45SLX6s1U5dyF7ioMPgN6bnLxRLLDB3i2IIBGvEM+8=;
 b=Dp6K+mCVHpuu3hiNGdAbN3PegFwPMP/fgkDDFnHcyYJBn1J2eHqRKaNkGu7C/bEIBP49
 ul8WgB/ZCvFtJR1jA96m72fxlb7byW/chDcdFhMKROXJvtv+3caTsj3ImcSks8Erj5cA
 KkBIQajIXqkPk5Dic3N37hc5g84syilNzMEb3YHFoctvs3Wgw2Hu9M373ToR1x8Ol1iR
 Bqj8IAps3bFdoWSVK8sMhAPnjEUSEPT+l41LJpysoPQVilM6CBO62iHHKslu1a50ZWJt
 Yb81W3gzcBcy3XgRUfwez1oGsRK1edmJWjRbFXmyOZS5ZwtX6wPFewTRYVba3Xf4caB9 Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35825ktugx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:10:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N6XFE130189;
        Sun, 6 Dec 2020 23:10:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kyq6rss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:10:06 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NA52i021183;
        Sun, 6 Dec 2020 23:10:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 23:10:04 +0000
Subject: [PATCH 03/10] xfs: hoist recovered rmap intent checks out of
 xfs_rui_item_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sun, 06 Dec 2020 15:10:03 -0800
Message-ID: <160729620357.1607103.17006699559437771482.stgit@magnolia>
In-Reply-To: <160729618252.1607103.863261260798043728.stgit@magnolia>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=3 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we recover a rmap intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_rmap_item.c |   67 ++++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 7adc996ca6e3..19d2dc285ed6 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -460,6 +460,42 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.cancel_item	= xfs_rmap_update_cancel_item,
 };
 
+/* Is this recovered RUI ok? */
+static inline bool
+xfs_rui_validate_map(
+	struct xfs_mount		*mp,
+	struct xfs_map_extent		*rmap)
+{
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
+	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
+	case XFS_RMAP_EXTENT_MAP:
+	case XFS_RMAP_EXTENT_MAP_SHARED:
+	case XFS_RMAP_EXTENT_UNMAP:
+	case XFS_RMAP_EXTENT_UNMAP_SHARED:
+	case XFS_RMAP_EXTENT_CONVERT:
+	case XFS_RMAP_EXTENT_CONVERT_SHARED:
+	case XFS_RMAP_EXTENT_ALLOC:
+	case XFS_RMAP_EXTENT_FREE:
+		op_ok = true;
+		break;
+	default:
+		op_ok = false;
+		break;
+	}
+	if (!op_ok || startblock_fsb == 0 ||
+	    rmap->me_len == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    rmap->me_len >= mp->m_sb.sb_agblocks ||
+	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process an rmap update intent item that was recovered from the log.
  * We need to update the rmapbt.
@@ -475,10 +511,8 @@ xfs_rui_item_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_mountp;
-	xfs_fsblock_t			startblock_fsb;
 	enum xfs_rmap_intent_type	type;
 	xfs_exntst_t			state;
-	bool				op_ok;
 	int				i;
 	int				whichfork;
 	int				error = 0;
@@ -489,30 +523,13 @@ xfs_rui_item_recover(
 	 * just toss the RUI.
 	 */
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		rmap = &ruip->rui_format.rui_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
-		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
-		case XFS_RMAP_EXTENT_MAP:
-		case XFS_RMAP_EXTENT_MAP_SHARED:
-		case XFS_RMAP_EXTENT_UNMAP:
-		case XFS_RMAP_EXTENT_UNMAP_SHARED:
-		case XFS_RMAP_EXTENT_CONVERT:
-		case XFS_RMAP_EXTENT_CONVERT_SHARED:
-		case XFS_RMAP_EXTENT_ALLOC:
-		case XFS_RMAP_EXTENT_FREE:
-			op_ok = true;
-			break;
-		default:
-			op_ok = false;
-			break;
-		}
-		if (!op_ok || startblock_fsb == 0 ||
-		    rmap->me_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    rmap->me_len >= mp->m_sb.sb_agblocks ||
-		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+		if (!xfs_rui_validate_map(mp,
+					&ruip->rui_format.rui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&ruip->rui_format,
+					sizeof(ruip->rui_format));
 			return -EFSCORRUPTED;
+		}
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,

