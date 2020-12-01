Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68989C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0981720796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X3iJ8hf7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgLADiy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:38:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60452 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbgLADiy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:38:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13TZrR065987
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2T4SLMEEbEI+3lmfYSVfs3KbG9LWCHN9ZKNPuneSdGc=;
 b=X3iJ8hf7mv7kj9tpIUilYILwXTTchi+kGNtQvfbdMCqJJ/O7QKOhRfIMBvhqn24Y7N2c
 RW4wiHYJNO1ExUoWVN2vPPoLB/DrSh9SZBoxyjLegPTnoI4Bjlr9DlTe4O4NyGW9m1ot
 O2W5Onmk70N35nMZPfu4sfZ91QQhnfg1tUM/88760DE5TbbzKO+XSQWCsKmR6ZjEZ4jn
 Zb4gdS4wVSrpiVCH3VSef5H937N3XUafvLkk7T5DrkELlyQOCXrdO7qKIQp7dcf8RzAD
 75oCf7sPTzSj9cLcwpuup4BYRbo+CcVq5LNhjsCIS4uhtN9KD4aaFydqWiOyZ/TWlNFK 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2arhm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13VHb9071335
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540fw81qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B13cBFf005171
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:38:11 -0800
Subject: [PATCH 05/10] xfs: hoist recovered refcount intent checks out of
 xfs_cui_item_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:38:10 -0800
Message-ID: <160679389048.447963.5353838196502010594.stgit@magnolia>
In-Reply-To: <160679385987.447963.9630288535682256882.stgit@magnolia>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we recover a refcount intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_refcount_item.c |   58 +++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7529eb63ce94..de344bd7e73c 100644
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
@@ -448,28 +478,10 @@ xfs_cui_item_recover(
 	 * CUI.  If any are bad, then assume that all are bad and
 	 * just toss the CUI.
 	 */
-	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
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
+	for (i = 0; i < cuip->cui_format.cui_nextents; i++)
+		if (!xfs_cui_validate_phys(mp,
+					   &cuip->cui_format.cui_extents[i]))
 			return -EFSCORRUPTED;
-	}
 
 	/*
 	 * Under normal operation, refcount updates are deferred, so we

