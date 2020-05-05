Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2509CC47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0AEF206D7
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i7eG4Tpy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgEEBNQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:13:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37818 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgEEBNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:13:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045136YV054629
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZYP95k9NXiuvbxlJPuEYQUXm8ndKxoRZoaQLD8/L7LE=;
 b=i7eG4TpyiPp3y2xsVrpwRkMpTHvO4B0w8V7M0wTUZp+0gYbwk2xSGWoqiWIIYFNDg5lk
 pqmP6G5oVMreLU3gTo+MLP28UOyt83VCIAZL1erftR4E5xcrXr6qOutr1fRF2qVDFYdZ
 ELndIx97lGye8z/pRnhCKwth4IGu0V16qmlvKxYU5NKcZms0Huu/kK5+Tcn63hBK2xWw
 mv7C7zVj8A4iM1xeoMa2BA+m4FTUVpEbMUkQlxbH+SL991AD49g8PNndM1eqGRUwpU+0
 Cm1uKvog51i+tpXIh5ibYrotyRXwjSV/N6wINtCcvzUlkVq/a+uRdQuYFTzHHcCsoORH 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tma1aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515knh057358
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r3qqb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451DD30016756
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:13:13 -0700
Subject: [PATCH 25/28] xfs: hoist setting of XFS_LI_RECOVERED to caller
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:13:12 -0700
Message-ID: <158864119233.182683.339682087935092440.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=3
 spamscore=0 mlxlogscore=636 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=3
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=680 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The only purpose of XFS_LI_RECOVERED is to prevent log recovery from
trying to replay recovered intents more than once.  Therefore, we can
move the bit setting up to the ->iop_recover caller.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |    5 -----
 fs/xfs/xfs_extfree_item.c  |    4 ----
 fs/xfs/xfs_log_recover.c   |    2 +-
 fs/xfs/xfs_refcount_item.c |    4 ----
 fs/xfs/xfs_rmap_item.c     |    4 ----
 5 files changed, 1 insertion(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 8f0dc6d550d1..0793c317defb 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -442,11 +442,8 @@ xfs_bui_item_recover(
 	int				whichfork;
 	int				error = 0;
 
-	ASSERT(!test_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags));
-
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
-		set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
 		xfs_bui_release(buip);
 		return -EFSCORRUPTED;
 	}
@@ -480,7 +477,6 @@ xfs_bui_item_recover(
 		 * This will pull the BUI from the AIL and
 		 * free the memory associated with it.
 		 */
-		set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
 		xfs_bui_release(buip);
 		return -EFSCORRUPTED;
 	}
@@ -538,7 +534,6 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
 	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index ec8a79fe6cab..b92678bede24 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -594,8 +594,6 @@ xfs_efi_item_recover(
 	int				i;
 	int				error = 0;
 
-	ASSERT(!test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags));
-
 	/*
 	 * First check the validity of the extents described by the
 	 * EFI.  If any are bad, then assume that all are bad and
@@ -613,7 +611,6 @@ xfs_efi_item_recover(
 			 * This will pull the EFI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags);
 			xfs_efi_release(efip);
 			return -EFSCORRUPTED;
 		}
@@ -634,7 +631,6 @@ xfs_efi_item_recover(
 
 	}
 
-	set_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags);
 	error = xfs_trans_commit(tp);
 	return error;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8ff957da2845..a49435db3be0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2717,7 +2717,7 @@ xlog_recover_process_intents(
 		 * this routine or else those subsequent intents will get
 		 * replayed in the wrong order!
 		 */
-		if (!test_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
+		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
 			spin_unlock(&ailp->ail_lock);
 			error = lip->li_ops->iop_recover(lip, parent_tp);
 			spin_lock(&ailp->ail_lock);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index fab821fce76b..e6d355a09bb3 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -442,8 +442,6 @@ xfs_cui_item_recover(
 	int				i;
 	int				error = 0;
 
-	ASSERT(!test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags));
-
 	/*
 	 * First check the validity of the extents described by the
 	 * CUI.  If any are bad, then assume that all are bad and
@@ -473,7 +471,6 @@ xfs_cui_item_recover(
 			 * This will pull the CUI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags);
 			xfs_cui_release(cuip);
 			return -EFSCORRUPTED;
 		}
@@ -557,7 +554,6 @@ xfs_cui_item_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	set_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags);
 	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index c9233a220551..4a5e2b1cf75a 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -482,8 +482,6 @@ xfs_rui_item_recover(
 	int				whichfork;
 	int				error = 0;
 
-	ASSERT(!test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags));
-
 	/*
 	 * First check the validity of the extents described by the
 	 * RUI.  If any are bad, then assume that all are bad and
@@ -517,7 +515,6 @@ xfs_rui_item_recover(
 			 * This will pull the RUI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags);
 			xfs_rui_release(ruip);
 			return -EFSCORRUPTED;
 		}
@@ -575,7 +572,6 @@ xfs_rui_item_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-	set_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags);
 	error = xfs_trans_commit(tp);
 	return error;
 

