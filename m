Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367B2C64E90
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA0F920796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:40:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vbqbHTAn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgLADkm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:40:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgLADkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:40:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13e0nG193362
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zzrW+9vNV3jfnia2w+Klp6GHwH3y3O+TnatASYMB+dk=;
 b=vbqbHTAnYV3b0evRTLiKyVtAPgB7BC/ftVxUY5vlWVURGaV0tdUmDmeLmbU9Ffmpq6FO
 HxHxzEEVSFrj/CJ2hZVI1jpOsDNRvIcYFA7er31Bb4C33Sp3gFtLCr7H2DeP75tiDGBV
 XBW8p/BuDhHXQZD18J+ohK120lG6LKuKxxyHX4T5lYaS8l00bNyILINKUAfl8lOuLmG+
 DCGrMuGtShqEz61UzCphg7ECs52E/IuXCCwzbwf0hxD3baTTfeFVk+R862GK4PkdmXvg
 vKa+FF7o3DPQFK40f+nOV6dd3SxoNoEr9Ow9XkWcouM6mxYNPsUjsAZmvsF6lCMtuM9h lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqge39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:40:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13UJjI181479
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540arh7x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:00 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B13bxcV005143
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:37:59 -0800
Subject: [PATCH 03/10] xfs: hoist recovered rmap intent checks out of
 xfs_rui_item_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:37:58 -0800
Message-ID: <160679387832.447963.10771235215002135416.stgit@magnolia>
In-Reply-To: <160679385987.447963.9630288535682256882.stgit@magnolia>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=3
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=3 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010024
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we recover a rmap intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_rmap_item.c |   65 ++++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 7adc996ca6e3..871ed7fc43ee 100644
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
@@ -488,32 +522,9 @@ xfs_rui_item_recover(
 	 * RUI.  If any are bad, then assume that all are bad and
 	 * just toss the RUI.
 	 */
-	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
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
+	for (i = 0; i < ruip->rui_format.rui_nextents; i++)
+		if (!xfs_rui_validate_map(mp, &ruip->rui_format.rui_extents[i]))
 			return -EFSCORRUPTED;
-	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 			mp->m_rmap_maxlevels, 0, XFS_TRANS_RESERVE, &tp);

