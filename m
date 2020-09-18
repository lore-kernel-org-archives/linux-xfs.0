Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78002C43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 06:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DAAA20866
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 06:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kfYWJwZn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIRGHR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 02:07:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIRGHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 02:07:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I2JGiO177002;
        Fri, 18 Sep 2020 02:19:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GbUjw8iisMVVhPbI5mQubP9xK3xH3zTSGc8ELCI668E=;
 b=kfYWJwZnR2Wy9ls58/YjdaDirmCVE8Lsrtsu1XM+Lbtbkm+CcW0DeLQ/4J7gisRNUvW6
 8bBTBmt1M3yaPISVE5RoipuNWlmYY5BpPUsUxkxPQZwGoIhOHphDWhKIIq1q/kh0Ld8N
 oWe9XoYdsV6uT1wMukUQLEJAmf2X2kP90zsIF7gChmat47X7bxhpyeXWNRecCGp0d2GQ
 s808/R81p8U20ni8zZ9kWnVXlG5GOF//sy2zSPrXwXvRA4AI4wIF4ct2dvB4PNsKdg7T
 sGAaWNZlKL4ID6nqBUmg/G27R2NA5oTbIdqbMKm0W2lAjUnNtuemNFAIBwpgwfmYWabu 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9mmhn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 02:19:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I2Fvir171735;
        Fri, 18 Sep 2020 02:19:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm35xqgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 02:19:41 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08I2Jf2p016177;
        Fri, 18 Sep 2020 02:19:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 02:19:40 +0000
Date:   Thu, 17 Sep 2020 19:19:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 3/2] xfs: don't release log intent items when recovery
 fails
Message-ID: <20200918021940.GW7955@magnolia>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <20200918021702.GV7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918021702.GV7955@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=5 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180021
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Nowadays, log recovery will call ->release on the recovered intent items
if recovery fails.  Therefore, it's redundant to release them from
inside the ->recover functions when they're about to return an error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix subject line
v2: log recovery frees unfinished intent items on failure, so remove
release calls
---
 fs/xfs/xfs_bmap_item.c     |   12 ++----------
 fs/xfs/xfs_extfree_item.c  |    8 +-------
 fs/xfs/xfs_refcount_item.c |    8 +-------
 fs/xfs/xfs_rmap_item.c     |    8 +-------
 4 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 2b1cf3ed8172..b04ebcd78316 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -444,10 +444,8 @@ xfs_bui_item_recover(
 	int				error = 0;
 
 	/* Only one mapping operation per BUI... */
-	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
-		xfs_bui_release(buip);
+	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return -EFSCORRUPTED;
-	}
 
 	/*
 	 * First check the validity of the extent described by the
@@ -473,14 +471,8 @@ xfs_bui_item_recover(
 	    startblock_fsb >= mp->m_sb.sb_dblocks ||
 	    bmap->me_len >= mp->m_sb.sb_agblocks ||
 	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)) {
-		/*
-		 * This will pull the BUI from the AIL and
-		 * free the memory associated with it.
-		 */
-		xfs_bui_release(buip);
+	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
 		return -EFSCORRUPTED;
-	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6cb8cd11072a..9093d2e7afdf 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -608,14 +608,8 @@ xfs_efi_item_recover(
 		if (startblock_fsb == 0 ||
 		    extp->ext_len == 0 ||
 		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    extp->ext_len >= mp->m_sb.sb_agblocks) {
-			/*
-			 * This will pull the EFI from the AIL and
-			 * free the memory associated with it.
-			 */
-			xfs_efi_release(efip);
+		    extp->ext_len >= mp->m_sb.sb_agblocks)
 			return -EFSCORRUPTED;
-		}
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 492d80a0b406..3e34b7662361 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -467,14 +467,8 @@ xfs_cui_item_recover(
 		    refc->pe_len == 0 ||
 		    startblock_fsb >= mp->m_sb.sb_dblocks ||
 		    refc->pe_len >= mp->m_sb.sb_agblocks ||
-		    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)) {
-			/*
-			 * This will pull the CUI from the AIL and
-			 * free the memory associated with it.
-			 */
-			xfs_cui_release(cuip);
+		    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
 			return -EFSCORRUPTED;
-		}
 	}
 
 	/*
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index dc5b0753cd51..e38ec5d736be 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -511,14 +511,8 @@ xfs_rui_item_recover(
 		    rmap->me_len == 0 ||
 		    startblock_fsb >= mp->m_sb.sb_dblocks ||
 		    rmap->me_len >= mp->m_sb.sb_agblocks ||
-		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)) {
-			/*
-			 * This will pull the RUI from the AIL and
-			 * free the memory associated with it.
-			 */
-			xfs_rui_release(ruip);
+		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
 			return -EFSCORRUPTED;
-		}
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
