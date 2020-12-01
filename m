Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D980C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6A9C20796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dXS5M/qs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgLADia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:38:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbgLADia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:38:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13TDHP169826
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/i1Pj1G2e15dKxkWQ1q18ySTrrafKM6nOeNBKyeOSYs=;
 b=dXS5M/qs8h0H8arf4Ppt2yLXogCVPtDSUjGxWqxl1ac6lBuYHNity+nhMNbs9kawvF7I
 H9WX+2u4OY4l/gQrxd7os81PIc65O5PgK1iRKttuSCQbRk2RPylcuRC6tmtwfolKCP5M
 oc7bn+M7K+yz2rpWcK6vYVKcg8OGnxEdi/Y5ddSda+LaVqMyMtwcxXp89j0IcqQlu+88
 nGVK5gdlzusJfGlt6iHbqKsshKdjLCHx5hmOohKGUrf7hOTj8/Q2SFh+MZ/vzDcu/lxd
 x56+68gaa4hB4enxeYZUs3TewUAI4fUIyBpO9XMJAxE62jss+gMSMwtS9/mf8K6PehqS xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyqge00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:37:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13UNSl160770
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404mbvuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:37:47 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B13blhI013740
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:37:47 -0800
Subject: [PATCH 01/10] xfs: hoist recovered bmap intent checks out of
 xfs_bui_item_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:37:46 -0800
Message-ID: <160679386612.447963.1918698861734333230.stgit@magnolia>
In-Reply-To: <160679385987.447963.9630288535682256882.stgit@magnolia>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we recover a bmap intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c |   71 ++++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 9e16a4d0f97c..c90d018fbc2e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -417,6 +417,49 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.cancel_item	= xfs_bmap_update_cancel_item,
 };
 
+/* Is this recovered BUI ok? */
+static inline bool
+xfs_bui_validate(
+	struct xfs_mount		*mp,
+	struct xfs_bui_log_item		*buip)
+{
+	struct xfs_map_extent		*bmap;
+	xfs_fsblock_t			startblock_fsb;
+	xfs_fsblock_t			inode_fsb;
+
+	/* Only one mapping operation per BUI... */
+	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+		return false;
+
+	bmap = &buip->bui_format.bui_extents[0];
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
+	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
+			XFS_INO_TO_FSB(mp, bmap->me_owner)));
+
+	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
+		return false;
+
+	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	case XFS_BMAP_MAP:
+	case XFS_BMAP_UNMAP:
+		break;
+	default:
+		return false;
+	}
+
+	if (startblock_fsb == 0 ||
+	    bmap->me_len == 0 ||
+	    inode_fsb == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    bmap->me_len >= mp->m_sb.sb_agblocks ||
+	    inode_fsb >= mp->m_sb.sb_dblocks ||
+	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process a bmap update intent item that was recovered from the log.
  * We need to update some inode's bmbt.
@@ -433,47 +476,21 @@ xfs_bui_item_recover(
 	struct xfs_mount		*mp = lip->li_mountp;
 	struct xfs_map_extent		*bmap;
 	struct xfs_bud_log_item		*budp;
-	xfs_fsblock_t			startblock_fsb;
-	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
 	xfs_exntst_t			state;
 	unsigned int			bui_type;
 	int				whichfork;
 	int				error = 0;
 
-	/* Only one mapping operation per BUI... */
-	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+	if (!xfs_bui_validate(mp, buip))
 		return -EFSCORRUPTED;
 
-	/*
-	 * First check the validity of the extent described by the
-	 * BUI.  If anything is bad, then toss the BUI.
-	 */
 	bmap = &buip->bui_format.bui_extents[0];
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
-	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
-			XFS_INO_TO_FSB(mp, bmap->me_owner)));
 	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
 			XFS_ATTR_FORK : XFS_DATA_FORK;
 	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
-	switch (bui_type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		break;
-	default:
-		return -EFSCORRUPTED;
-	}
-	if (startblock_fsb == 0 ||
-	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
-		return -EFSCORRUPTED;
 
 	/* Grab the inode. */
 	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);

