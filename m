Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8853EC4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD8223120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgLFXLD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:11:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56162 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgLFXLC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:11:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N6QMB182470;
        Sun, 6 Dec 2020 23:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qh0cnY4iOMuuuWbus4RGG+wXilwOQA12O1pfeS+zUks=;
 b=XXvZAFM6tCcdkmaLebQWTKzoA0eIV7oKO4r+RIkGdL/4pcQUTHf+m2QGKbEONH7WBkbL
 DSoltBMBWoVITdD4WJ5keK9COlziRpz0FToz72jJ7YuW8afZINb0JLPX2YRlP5wb45VR
 YffaejX6EaGkCU0yOZWnmRngo9/iO3WDkGBIwfaeTO3yt/s/1QUEOg78MGXH3RO0xvz1
 F9tr4E2FZvk08c952sFtJcUImt/URNrv41ko1rVHCMOxbUC7/0DKUJpZvUbaoWY8cF4U
 iEVDzQK6uRPiI2NsEhYDFGXSzDQlraq6eC/kHfJmDjjLnsCGfMa0PyX5n00oJG2mQjDN +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35825ktuh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:10:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N4gRW165540;
        Sun, 6 Dec 2020 23:10:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 358kskgayw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:10:18 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NAHP6011524;
        Sun, 6 Dec 2020 23:10:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:10:17 -0800
Subject: [PATCH 05/10] xfs: hoist recovered refcount intent checks out of
 xfs_cui_item_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sun, 06 Dec 2020 15:10:16 -0800
Message-ID: <160729621636.1607103.4134252517684885288.stgit@magnolia>
In-Reply-To: <160729618252.1607103.863261260798043728.stgit@magnolia>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
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

When we recover a refcount intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_refcount_item.c |   59 ++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7529eb63ce94..e19f96c9b93a 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -417,6 +417,38 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
 
+/* Is this recovered CUI ok? */
+static inline bool
+xfs_cui_validate_phys(
+	struct xfs_mount		*mp,
+	struct xfs_phys_extent		*refc)
+{
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
+	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		op_ok = true;
+		break;
+	default:
+		op_ok = false;
+		break;
+	}
+	if (!op_ok || startblock_fsb == 0 ||
+	    refc->pe_len == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    refc->pe_len >= mp->m_sb.sb_agblocks ||
+	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process a refcount update intent item that was recovered from the log.
  * We need to update the refcountbt.
@@ -433,11 +465,9 @@ xfs_cui_item_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_mountp;
-	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
 	unsigned int			refc_type;
-	bool				op_ok;
 	bool				requeue_only = false;
 	enum xfs_refcount_intent_type	type;
 	int				i;
@@ -449,26 +479,13 @@ xfs_cui_item_recover(
 	 * just toss the CUI.
 	 */
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
-		refc = &cuip->cui_format.cui_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
-		switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
-		case XFS_REFCOUNT_INCREASE:
-		case XFS_REFCOUNT_DECREASE:
-		case XFS_REFCOUNT_ALLOC_COW:
-		case XFS_REFCOUNT_FREE_COW:
-			op_ok = true;
-			break;
-		default:
-			op_ok = false;
-			break;
-		}
-		if (!op_ok || startblock_fsb == 0 ||
-		    refc->pe_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    refc->pe_len >= mp->m_sb.sb_agblocks ||
-		    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+		if (!xfs_cui_validate_phys(mp,
+					&cuip->cui_format.cui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&cuip->cui_format,
+					sizeof(cuip->cui_format));
 			return -EFSCORRUPTED;
+		}
 	}
 
 	/*

