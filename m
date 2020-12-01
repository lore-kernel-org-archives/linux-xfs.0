Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D163C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D002076C
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:54:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TD2dgQjI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387876AbgLAQyi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:54:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51366 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387563AbgLAQyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 11:54:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1Gj1gB079342;
        Tue, 1 Dec 2020 16:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VfluVSrYAVeMOVeQnpD4Jb0z8UxJPPEIQoCNBWsMWXE=;
 b=TD2dgQjIUy21NDCOxaTFgcluR7dp6L5vog0rVedypoDjOZt2ZXaqiDbZPc5du2OUjR9A
 FGMikMDuZtP1QMoptJrXALAd2A07HgLDOcp801LH8JYlrsUe+nS4uSYIavSywiLXEqzr
 CA62E7myrfDNpA+/6Tc9XgkgNzpDY3NHXI1d8Ob9JVxSkTaBpceBfCeVzERRZxOxEH7E
 TMdIuiyQbvzi1/InXllIgJX8SJlUNfinYhCNEdX9NIgDfUJBVrOKyWPKC6HoMsvWDQNR
 q20xDQP9WweUDwcaUwK2XQHoXW42qxheRbNqtdYw6M/CIIP9J2fWqaEmwoqCe7XRvGtr ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkkm1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:53:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GkGZ7015325;
        Tue, 1 Dec 2020 16:53:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3540asn99r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:53:45 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1GrjdO021760;
        Tue, 1 Dec 2020 16:53:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:53:44 -0800
Date:   Tue, 1 Dec 2020 08:53:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: [PATCH v2 04/10] xfs: improve the code that checks recovered rmap
 intent items
Message-ID: <20201201165343.GD143045@magnolia>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679388445.447963.9471776418395898485.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679388445.447963.9471776418395898485.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=5
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=5
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010103
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
v2: reverse the owner tests, simplify the startblock checks
---
 fs/xfs/xfs_rmap_item.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 871ed7fc43ee..36fe368531d2 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -466,11 +466,9 @@ xfs_rui_validate_map(
 	struct xfs_mount		*mp,
 	struct xfs_map_extent		*rmap)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
 	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 	case XFS_RMAP_EXTENT_MAP:
 	case XFS_RMAP_EXTENT_MAP_SHARED:
@@ -480,17 +478,25 @@ xfs_rui_validate_map(
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
+	if (!XFS_RMAP_NON_INODE_OWNER(rmap->me_owner) &&
+	    !xfs_verify_ino(mp, rmap->me_owner))
+		return false;
+
+	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
+		return false;
+
+	if (rmap->me_startblock + rmap->me_len <= rmap->me_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
 		return false;
 
 	return true;
