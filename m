Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A474C4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3283F23120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgLFXLk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:11:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56588 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgLFXLk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:11:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5tbg182066
        for <linux-xfs@vger.kernel.org>; Sun, 6 Dec 2020 23:10:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4gA34opggK7Ndss0t/uDyXTmxax/009tbcO1ItjmRO0=;
 b=P17KG8v9+DX6cFC0N2uv5v72iBL/QrwhXKHIWx3obBkrKJHCiHfMX42AAU63W5+8XV0F
 asjH36HiY5Ez9ELaxugvoYVzANElkIeoSjiRD+sZv+cpmQdgMOA9xWWcUyd9Kd5XTdhB
 8XcGCgBH3ZoCRn3xJTGdcyzWM5taRJ7VtqtTigxM6hxRpIfjKPzlUL5U0IYCcd4nmkM1
 b3csyucNsSr8FY7rKjxKXAk1317JGlrupGkJM0egvsNzuHymMxQ/t2s7jgsJMW6wsrcJ
 d3VozlrhtxldRKpGav4pwwkdWmjAxOB69EjKtQXHnyOe5zWLAxoMbdME/B0K2ucBtxfa eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825ktuhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 23:10:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NAMM4005637
        for <linux-xfs@vger.kernel.org>; Sun, 6 Dec 2020 23:10:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m3vpdwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 23:10:58 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NAw5o012031
        for <linux-xfs@vger.kernel.org>; Sun, 6 Dec 2020 23:10:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:10:57 -0800
Subject: [PATCH 1/4] xfs: refactor data device extent validation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 06 Dec 2020 15:10:57 -0800
Message-ID: <160729625702.1608297.4480089333393399990.stgit@magnolia>
In-Reply-To: <160729625074.1608297.13414859761208067117.stgit@magnolia>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the open-coded validation of non-static data device extents
into a single helper.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c   |    8 ++------
 fs/xfs/libxfs/xfs_types.c  |   23 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h  |    2 ++
 fs/xfs/scrub/bmap.c        |    5 +----
 fs/xfs/xfs_bmap_item.c     |   11 +----------
 fs/xfs/xfs_extfree_item.c  |   11 +----------
 fs/xfs/xfs_refcount_item.c |   11 +----------
 fs/xfs/xfs_rmap_item.c     |   11 +----------
 8 files changed, 32 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de9c27ef68d8..7f1b6ad570a9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6242,12 +6242,8 @@ xfs_bmap_validate_extent(
 		if (!xfs_verify_rtbno(mp, endfsb))
 			return __this_address;
 	} else {
-		if (!xfs_verify_fsbno(mp, irec->br_startblock))
-			return __this_address;
-		if (!xfs_verify_fsbno(mp, endfsb))
-			return __this_address;
-		if (XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
-		    XFS_FSB_TO_AGNO(mp, endfsb))
+		if (!xfs_verify_fsbext(mp, irec->br_startblock,
+					   irec->br_blockcount))
 			return __this_address;
 	}
 	if (irec->br_state != XFS_EXT_NORM && whichfork != XFS_DATA_FORK)
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 4f595546a639..b74866dbea94 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -61,6 +61,29 @@ xfs_verify_fsbno(
 	return xfs_verify_agbno(mp, agno, XFS_FSB_TO_AGBNO(mp, fsbno));
 }
 
+/*
+ * Verify that a data device extent is fully contained inside the filesystem,
+ * does not cross an AG boundary, and does not point at static metadata.
+ */
+bool
+xfs_verify_fsbext(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno,
+	xfs_fsblock_t		len)
+{
+	if (fsbno + len <= fsbno)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, fsbno))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, fsbno + len - 1))
+		return false;
+
+	return  XFS_FSB_TO_AGNO(mp, fsbno) ==
+		XFS_FSB_TO_AGNO(mp, fsbno + len - 1);
+}
+
 /* Calculate the first and last possible inode number in an AG. */
 void
 xfs_agino_range(
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 397d94775440..7feaaac25b3d 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -184,6 +184,8 @@ xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno);
 bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
+bool xfs_verify_fsbext(struct xfs_mount *mp, xfs_fsblock_t fsbno,
+		xfs_fsblock_t len);
 
 void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agino_t *first, xfs_agino_t *last);
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index fed56d213a3f..3e2ba7875059 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -359,10 +359,7 @@ xchk_bmap_iextent(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (!info->is_rt &&
-	    (!xfs_verify_fsbno(mp, irec->br_startblock) ||
-	     !xfs_verify_fsbno(mp, end) ||
-	     XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
-				XFS_FSB_TO_AGNO(mp, end)))
+	    !xfs_verify_fsbext(mp, irec->br_startblock, irec->br_blockcount))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 8d3ed07800f6..5c9706760e68 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -452,16 +452,7 @@ xfs_bui_validate(
 	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
 		return false;
 
-	if (bmap->me_startblock + bmap->me_len <= bmap->me_startblock)
-		return false;
-
-	if (!xfs_verify_fsbno(mp, bmap->me_startblock))
-		return false;
-
-	if (!xfs_verify_fsbno(mp, bmap->me_startblock + bmap->me_len - 1))
-		return false;
-
-	return true;
+	return xfs_verify_fsbext(mp, bmap->me_startblock, bmap->me_len);
 }
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index bfdfbd192a38..93223ebb3372 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -584,16 +584,7 @@ xfs_efi_validate_ext(
 	struct xfs_mount		*mp,
 	struct xfs_extent		*extp)
 {
-	if (extp->ext_start + extp->ext_len <= extp->ext_start)
-		return false;
-
-	if (!xfs_verify_fsbno(mp, extp->ext_start))
-		return false;
-
-	if (!xfs_verify_fsbno(mp, extp->ext_start + extp->ext_len - 1))
-		return false;
-
-	return true;
+	return xfs_verify_fsbext(mp, extp->ext_start, extp->ext_len);
 }
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 937d482c9be4..07ebccbbf4df 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -439,16 +439,7 @@ xfs_cui_validate_phys(
 		return false;
 	}
 
-	if (refc->pe_startblock + refc->pe_len <= refc->pe_startblock)
-		return false;
-
-	if (!xfs_verify_fsbno(mp, refc->pe_startblock))
-		return false;
-
-	if (!xfs_verify_fsbno(mp, refc->pe_startblock + refc->pe_len - 1))
-		return false;
-
-	return true;
+	return xfs_verify_fsbext(mp, refc->pe_startblock, refc->pe_len);
 }
 
 /*
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 9b84017184d9..4fa875237422 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -493,16 +493,7 @@ xfs_rui_validate_map(
 	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
 		return false;
 
-	if (rmap->me_startblock + rmap->me_len <= rmap->me_startblock)
-		return false;
-
-	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
-		return false;
-
-	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
-		return false;
-
-	return true;
+	return xfs_verify_fsbext(mp, rmap->me_startblock, rmap->me_len);
 }
 
 /*

