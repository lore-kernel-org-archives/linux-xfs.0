Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AB8C64E90
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF72E20796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iC0jj8EA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgLADig (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:38:36 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60320 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbgLADig (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:38:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13Sup4065770
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YQOBlIgnBH/1iazRWxXuA2fsJrppzTv3fiDRPeTZhaA=;
 b=iC0jj8EArPQuxIQlxJwGAOu9sbkWBOu7HpU/g0xIKevR9c54FZtBN158/OK3REVFZtSs
 IaySZ/5zX6/HpYeBtF13xIv74O7LmezlbJ9y8wGS1mFAXDmHyim05sMkF14fMGMXtTn3
 EbPAr+Bx1jbPCwNt3ClqYdCPB8aQYPtT1OzKfY0gBazFFLOMJa3TBvRW94EBjkH9x5DG
 TQ019MCBMtXoyN2naPVhAnUDTA4AU17Z8N2D1HAz9sL4oFor45O3TV2vBT6/mXLTk60O
 r+1dITWpkC+XHGTF7F7PD0Cb3OrrD3tQA2yQCuOV5A4akqTT/TXQ1vYrzLsFeC6uZgqD 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2arhkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:37:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13U4pa134416
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3540exd2up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:37:54 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B13brAI012118
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:37:53 -0800
Subject: [PATCH 02/10] xfs: improve the code that checks recovered bmap intent
 items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:37:52 -0800
Message-ID: <160679387231.447963.15156459924591469631.stgit@magnolia>
In-Reply-To: <160679385987.447963.9630288535682256882.stgit@magnolia>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The code that validates recovered bmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index c90d018fbc2e..19f89a6b65a1 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -424,18 +424,13 @@ xfs_bui_validate(
 	struct xfs_bui_log_item		*buip)
 {
 	struct xfs_map_extent		*bmap;
-	xfs_fsblock_t			startblock_fsb;
-	xfs_fsblock_t			inode_fsb;
+	xfs_fsblock_t			end;
 
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return false;
 
 	bmap = &buip->bui_format.bui_extents[0];
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
-	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
-			XFS_INO_TO_FSB(mp, bmap->me_owner)));
 
 	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
 		return false;
@@ -448,13 +443,18 @@ xfs_bui_validate(
 		return false;
 	}
 
-	if (startblock_fsb == 0 ||
-	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
+	if (!xfs_verify_ino(mp, bmap->me_owner))
+		return false;
+
+	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
+		return false;
+
+	if (bmap->me_startblock + bmap->me_len <= bmap->me_startblock)
+		return false;
+
+	end = bmap->me_startblock + bmap->me_len - 1;
+	if (!xfs_verify_fsbno(mp, bmap->me_startblock) ||
+	    !xfs_verify_fsbno(mp, end))
 		return false;
 
 	return true;

