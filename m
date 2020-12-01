Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE13C64E90
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87B6D20796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QDt37Lnm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgLADjM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:39:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39680 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbgLADjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:39:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13ThWH147106
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7Y/26q8YG2W4v+mr1e063NkErd8DkNqaNhvSFQaKSqU=;
 b=QDt37LnmoXfGTAEQjk/JTf/A90eUfNJRNCiSE3s5X+hVxMypNKLmtbn4hHEgczKJUr4r
 Fx4N3sOzwZBWrhiXvVfSWZglhYwpWLvGGEOix88+LvGnUgcTOBGN1H/to/ki1xfmem+B
 26UaGdRe8iWFs8/K9wLHqeIT6UDTfQmBn2oeS7kSFDIV7sBTDKeEaXE+r9HGnqHnzEor
 9fM/Yf9mFUVRr7RPtVmbCGe0P2QpmPNIylpN59kOQXjhp9GvbjMr44pscsmQatVLbB1L
 dXnrbS1KEdzLv5UVOybnnpZslbLCeFAnlgbbPOnfLRw6odgl8t2Hv7yspU9HXBbBHgxe SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egkgcs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13U3dg134177
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540exd345-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:30 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B13cTS6005363
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:29 GMT
Received: from localhost (/67.169.218.210) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Mon, 30 Nov 2020 19:38:05 -0800
USER-AGENT: StGit/0.19
MIME-Version: 1.0
Message-ID: <160679388445.447963.9471776418395898485.stgit@magnolia>
Date:   Mon, 30 Nov 2020 19:38:04 -0800 (PST)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/10] xfs: improve the code that checks recovered rmap intent
 items
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
In-Reply-To: <160679385987.447963.9630288535682256882.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=3 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The code that validates recovered rmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_rmap_item.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 871ed7fc43ee..2779cbee8fa8 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -466,11 +466,11 @@ xfs_rui_validate_map(
 	struct xfs_mount		*mp,
 	struct xfs_map_extent		*rmap)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	xfs_fsblock_t			end;
+
+	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
 	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 	case XFS_RMAP_EXTENT_MAP:
 	case XFS_RMAP_EXTENT_MAP_SHARED:
@@ -480,17 +480,24 @@ xfs_rui_validate_map(
 	case XFS_RMAP_EXTENT_CONVERT_SHARED:
 	case XFS_RMAP_EXTENT_ALLOC:
 	case XFS_RMAP_EXTENT_FREE:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return false;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
-	    rmap->me_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    rmap->me_len >= mp->m_sb.sb_agblocks ||
-	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+
+	if (!xfs_verify_ino(mp, rmap->me_owner) &&
+	    !XFS_RMAP_NON_INODE_OWNER(rmap->me_owner))
+		return false;
+
+	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
+		return false;
+
+	if (rmap->me_startblock + rmap->me_len <= rmap->me_startblock)
+		return false;
+
+	end = rmap->me_startblock + rmap->me_len - 1;
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock) ||
+	    !xfs_verify_fsbno(mp, end))
 		return false;
 
 	return true;

