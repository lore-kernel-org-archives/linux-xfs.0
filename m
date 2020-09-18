Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674B1C43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24CF2239EB
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tOR0/s35"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgIRCRZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:17:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbgIRCRV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 22:17:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I2FZfI121035;
        Fri, 18 Sep 2020 02:17:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=083P8GXQPb8Xq8R2FnNe82zO19d3arm3fGeehBo7sEs=;
 b=tOR0/s35fCPd0U+emgZdXmwiX1Y3V53MAoJGVY+DFrrT5y9JqClgNHqSr52jBl/DfzdG
 GAuH9ff1uswtTvqmsrmQNhZd/bYeBwRPK/S1Zty4X/ydOBzMh1zf4q+8zDgtboP5A+jk
 CPDpkpOusFjlEosSicY24CFUy9ur3Zh2Id+GsNCBvfGA13screfgl9KRCANitlIoaazu
 rzCn+6BzI6rPlwavJdbcl8oLz5Q403qk/5px8VWPUUJ9raFFPpAmk/5VPkMM1T5foXpS
 SqUeXkUXuwRdQBp9Ytts+SL8Eam8b+q1GDZiArs6n83f2HM7dSU0iqoHG/XlLnE5mK/u fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dx7t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 02:17:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I2Epj6012736;
        Fri, 18 Sep 2020 02:17:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33megagcy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 02:17:05 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08I2H4vA006960;
        Fri, 18 Sep 2020 02:17:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 02:17:03 +0000
Date:   Thu, 17 Sep 2020 19:17:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 3/2] xfs: fix simple problems with log intent recovery
Message-ID: <20200918021702.GV7955@magnolia>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031332353.3624373.16349101558356065522.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=5 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180020
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Nowadays, log recovery will call ->release on the recovered intent items
if recovery fails.  Therefore, it's redundant to release them from
inside the ->recover functions when they're about to return an error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: log recovery already cancels the intents for us, so don't free them
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
