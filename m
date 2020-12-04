Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66820C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B9EB224B1
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgLDBMw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:12:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47828 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbgLDBMw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:12:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B419b2o068007;
        Fri, 4 Dec 2020 01:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ciMn21u8cFjDz6d4wUUFKO0DWOeNDSKuELwiaCjKdjI=;
 b=NWrxXfcz5ilDTlHkB7TPQsKzqntLsQb8UXHWHdeKxNuupTcykETDGPa36ZLdL+Afw4hx
 rG1cmzCSTUhoaQxd6ekWSGwJTHRq6YEeHtrEGruNX/eZJFEs3idil+nU7M4BMakjCD+t
 r2H6dghvr891rci93aCKJVBWkuVh66h/pAvlmqrafoDUROO5HfPrKiiKQwbSMsE/tZbl
 8EK6Ho7Bz2ZY3a0sWzuJwqalnzfdvdAuf/7jlgjflbV/Ye168y0IZJEEvpgnrjjNorVZ
 +KbPvlobOY0CeGIo9xIrrZuLp70bFIPVfBtBW24/KmL92O1LtPJon8WowNQlfUeTRDT9 gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyr1215-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 01:12:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41AX46093375;
        Fri, 4 Dec 2020 01:12:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404rn6g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 01:12:08 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B41C7hr011508;
        Fri, 4 Dec 2020 01:12:07 GMT
Received: from localhost (/10.159.242.140) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Thu, 03 Dec 2020 17:12:06 -0800
USER-AGENT: StGit/0.19
MIME-Version: 1.0
Message-ID: <160704432626.734470.12800460361201622389.stgit@magnolia>
Date:   Fri, 4 Dec 2020 01:12:06 +0000 (UTC)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: [PATCH 05/10] xfs: hoist recovered refcount intent checks out of
 xfs_cui_item_recover
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
In-Reply-To: <160704429410.734470.15640089119078502938.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=3 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
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
---
 fs/xfs/xfs_refcount_item.c |   57 ++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7529eb63ce94..a456a2fb794c 100644
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
@@ -449,26 +479,11 @@ xfs_cui_item_recover(
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
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	/*

