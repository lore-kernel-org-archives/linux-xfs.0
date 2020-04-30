Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B80C83000
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF07220787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jV5EsXs1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3Atv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:49:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgD3Atv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:49:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0nf9G165809;
        Thu, 30 Apr 2020 00:49:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Nzj0yml/L7FaGPR+xXFf5TmK50e2MR/KqEycyg8mFLM=;
 b=jV5EsXs1hjpFxrT/kSiq0mkuDAEq1GwuvCID8vUCVgFstWqXIafSc8OQCZYd8hj627kY
 1iYXBNs7rvW65rYmOPG9BZruP6T+eccInPrA1s1qDuns4WqRB5e9b6k+lPBPsVRd7FQe
 6+5DMEyWhWVbfHwmfnuF2xQ9T/e0OIM/7f98Wd+Vv28Zz4UtEsBXdKXf4sV26/AIHzb7
 n93RBSgeEHSnvSjhXySe0+j5YMwslSB7lrZWK7Xp3m1McIjxlW23ew2yuA2z67aKDMbN
 U0SBKeloP8k4upi+Z3IsDFPzmdtjlUtTJfToYJ9+jz7txkTibFt1Sb7X08t55aWWM86z /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30p01ny8mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 00:49:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0klhi087569;
        Thu, 30 Apr 2020 00:49:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30mxpma5w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 00:49:43 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03U0nbXL004430;
        Thu, 30 Apr 2020 00:49:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:49:37 -0700
Subject: [PATCH 18/21] xfs: refactor adding recovered intent items to the log
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Wed, 29 Apr 2020 17:49:35 -0700
Message-ID: <158820777528.467894.13864229426499171945.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During recovery, every intent that we recover from the log has to be
added to the AIL.  Replace the open-coded addition with a helper.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 ++
 fs/xfs/xfs_bmap_item.c          |   10 +---------
 fs/xfs/xfs_extfree_item.c       |   10 +---------
 fs/xfs/xfs_log_recover.c        |   17 +++++++++++++++++
 fs/xfs/xfs_refcount_item.c      |   10 +---------
 fs/xfs/xfs_rmap_item.c          |   10 +---------
 6 files changed, 23 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index bb21d512a824..ba172eb454c8 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -127,5 +127,7 @@ void xlog_recover_iodone(struct xfs_buf *bp);
 typedef bool (*xlog_item_match_fn)(struct xfs_log_item *item, uint64_t id);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id, xlog_item_match_fn fn);
+void xlog_recover_insert_ail(struct xlog *log, struct xfs_log_item *lip,
+		xfs_lsn_t lsn);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index bf5997f616a4..e38efdb0ed71 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -649,15 +649,7 @@ xlog_recover_bmap_intent_commit_pass2(
 		return error;
 	}
 	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The RUI has two references. One for the RUD and one for RUI to ensure
-	 * it makes it into the AIL. Insert the RUI into the AIL directly and
-	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
+	xlog_recover_insert_ail(log, &buip->bui_item, lsn);
 	xfs_bui_release(buip);
 	return 0;
 }
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 57d33a5a42c5..9264ec0817cc 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -711,15 +711,7 @@ xlog_recover_extfree_intent_commit_pass2(
 		return error;
 	}
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The EFI has two references. One for the EFD and one for EFI to ensure
-	 * it makes it into the AIL. Insert the EFI into the AIL directly and
-	 * drop the EFI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
+	xlog_recover_insert_ail(log, &efip->efi_item, lsn);
 	xfs_efi_release(efip);
 	return 0;
 }
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 853500a51762..527c74fa5cc3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1812,6 +1812,23 @@ xlog_recover_release_intent(
 	spin_unlock(&ailp->ail_lock);
 }
 
+/* Insert a recovered intent item into the AIL. */
+void
+xlog_recover_insert_ail(
+	struct xlog		*log,
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	/*
+	 * The intent has two references. One for the done item and one for the
+	 * intent to ensure it makes it into the AIL. Insert the intent into
+	 * the AIL directly and drop the intent reference. Note that
+	 * xfs_trans_ail_update() drops the AIL lock.
+	 */
+	spin_lock(&log->l_ailp->ail_lock);
+	xfs_trans_ail_update(log->l_ailp, lip, lsn);
+}
+
 /******************************************************************************
  *
  *		Log recover routines
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 3c469a49e620..408d9312035a 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -672,15 +672,7 @@ xlog_recover_refcount_intent_commit_pass2(
 		return error;
 	}
 	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The CUI has two references. One for the CUD and one for CUI to ensure
-	 * it makes it into the AIL. Insert the CUI into the AIL directly and
-	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
+	xlog_recover_insert_ail(log, &cuip->cui_item, lsn);
 	xfs_cui_release(cuip);
 	return 0;
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 1de5c20cb624..ffb06960b12c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -664,15 +664,7 @@ xlog_recover_rmap_intent_commit_pass2(
 		return error;
 	}
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The RUI has two references. One for the RUD and one for RUI to ensure
-	 * it makes it into the AIL. Insert the RUI into the AIL directly and
-	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
+	xlog_recover_insert_ail(log, &ruip->rui_item, lsn);
 	xfs_rui_release(ruip);
 	return 0;
 }

