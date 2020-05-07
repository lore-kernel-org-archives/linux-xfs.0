Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACB2C28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E54220747
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:06:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ar4cQ4tI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgEGBGW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:06:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55748 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgEGBGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:06:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vjth130466;
        Thu, 7 May 2020 01:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hLpGgSpPaTamAp2giRQxGmniWAqO5sc9pdLfzCb48AA=;
 b=ar4cQ4tIYAoRdRyxIjmyna1CAZXvJrhP/irp3qQOvf+sytN3QD44ELegsX5BpwklQAQ3
 iDu+WcF2FXpKGFhBv2ZeqKVtRiIRWaHs3YEPHeTMpfsFjfHOusNDSPID/Tu+rcaqmWlE
 gHt939CYOtolNKD57W7tFOYnJg6PgdbvKgPzgIOsxqE1evpX1uW+6OrPorKYoKd+/Dto
 ZwcOomPt9h2iAy7nAmkUdqCIz9OXFkydCvPt05gVHgV4txZIseIrZTvlw9/EcEKmODbF
 qJxkguQWdHxW1zh26kuuUo0eCPvCo7L819e+RPMay2WJzCyXsx7jW6blu+SCWq0d6I4z eQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gnda7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vWwt150870;
        Thu, 7 May 2020 01:04:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnmbpbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:16 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04714FXw032224;
        Thu, 7 May 2020 01:04:15 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:04:14 -0700
Subject: [PATCH 23/25] xfs: hoist setting of XFS_LI_RECOVERED to caller
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:04:10 -0700
Message-ID: <158881345055.189971.1644525085198836818.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=626 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=671
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The only purpose of XFS_LI_RECOVERED is to prevent log recovery from
trying to replay recovered intents more than once.  Therefore, we can
move the bit setting up to the ->iop_recover caller.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c     |    5 -----
 fs/xfs/xfs_extfree_item.c  |    4 ----
 fs/xfs/xfs_log_recover.c   |    4 ++--
 fs/xfs/xfs_refcount_item.c |    4 ----
 fs/xfs/xfs_rmap_item.c     |    4 ----
 5 files changed, 2 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3b8ca4409aa5..6736c5ab188f 100644
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
index a8ee9aaef50d..b9c333bae0a1 100644
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
index 60e98e48d04b..fa1b63bd9031 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2643,7 +2643,7 @@ xlog_recover_process_intents(
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
-	int			error = 0;
+	int			error;
 #if defined(DEBUG) || defined(XFS_WARN)
 	xfs_lsn_t		last_lsn;
 #endif
@@ -2693,7 +2693,7 @@ xlog_recover_process_intents(
 		 * this routine or else those subsequent intents will get
 		 * replayed in the wrong order!
 		 */
-		if (!test_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
+		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
 			spin_unlock(&ailp->ail_lock);
 			error = lip->li_ops->iop_recover(lip, parent_tp);
 			spin_lock(&ailp->ail_lock);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index b256eafd30d3..c81639891e29 100644
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
index d190060729a3..a86599db20a6 100644
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
 

