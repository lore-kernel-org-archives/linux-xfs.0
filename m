Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A98C54FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9D502072D
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZqeG7zUs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgDVCH5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:07:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44584 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgDVCH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:07:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M24NpW167630
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5WBXbnucUT5DDOQOWUiprrW1FcVlbKCFZ0w6J+5h5FI=;
 b=ZqeG7zUs9R05xXzvswvILQqcSwE7IZuFKFIxQmDBYDWlV/b9fKnoBLe2li0NTR6ZnGC/
 GJNsqla2Dbcgf+7tnqI8K7GHTQ+Pq86HwOveAtJXdqnUm7TgWErxy43aL1N8PmpqBWY6
 izrGOdeti+Q34RSCpIfMZ7aVL3fqKfVC07gV5MYpOtju3d4mbg8qeVa1efZts8gINEDT
 jho2HYShfB9U4ffpHjg1TeMl57WpzHfTXFS9UwUpJty6Bx5r2rfJWBRG2y770D3QD/7I
 gQtXG/kCG+5f3vpAKVbR7pOHIj+bTIUF02W/2YRXVcmkPHZk8ulHg+2leDTcnP74oreg KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30grpgmhnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M27fn8075612
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30gb3t4nmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:55 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M27rxx014590
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:07:53 -0700
Subject: [PATCH 17/19] xfs: hoist the ail unlock/lock cycle when cancelling
 intents during recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:52 -0700
Message-ID: <158752127272.2140829.17836221324265747282.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=1 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the spin_unlock/spin_lock of the ail lock up to
xlog_recover_cancel_intents so that the individual ->cancel_intent
functions don't have to do that anymore.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    3 +--
 fs/xfs/xfs_bmap_item.c          |    8 +-------
 fs/xfs/xfs_extfree_item.c       |    8 +-------
 fs/xfs/xfs_log_recover.c        |    4 +++-
 fs/xfs/xfs_refcount_item.c      |    8 +-------
 fs/xfs/xfs_rmap_item.c          |    8 +-------
 6 files changed, 8 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 8cb38d8327ce..5c37940386d6 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -132,8 +132,7 @@ typedef int (*xlog_recover_done_fn)(struct xlog *xlog,
 		struct xlog_recover_item *item);
 typedef int (*xlog_recover_process_intent_fn)(struct xlog *log,
 		struct xfs_trans *tp, struct xfs_log_item *lip);
-typedef void (*xlog_recover_cancel_intent_fn)(struct xlog *log,
-		struct xfs_log_item *lip);
+typedef void (*xlog_recover_cancel_intent_fn)(struct xfs_log_item *lip);
 
 struct xlog_recover_intent_type {
 	/*
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index df8155dfcc87..53160172c36b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -701,15 +701,9 @@ xlog_recover_process_bui(
 /* Release the BUI since we're cancelling everything. */
 STATIC void
 xlog_recover_cancel_bui(
-	struct xlog			*log,
 	struct xfs_log_item		*lip)
 {
-	struct xfs_ail			*ailp = log->l_ailp;
-	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
-
-	spin_unlock(&ailp->ail_lock);
-	xfs_bui_release(buip);
-	spin_lock(&ailp->ail_lock);
+	xfs_bui_release(BUI_ITEM(lip));
 }
 
 const struct xlog_recover_intent_type xlog_recover_bmap_type = {
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3af9e37892f1..a15ede29244a 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -762,15 +762,9 @@ xlog_recover_process_efi(
 /* Release the EFI since we're cancelling everything. */
 STATIC void
 xlog_recover_cancel_efi(
-	struct xlog			*log,
 	struct xfs_log_item		*lip)
 {
-	struct xfs_ail			*ailp = log->l_ailp;
-	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
-
-	spin_unlock(&ailp->ail_lock);
-	xfs_efi_release(efip);
-	spin_lock(&ailp->ail_lock);
+	xfs_efi_release(EFI_ITEM(lip));
 }
 
 const struct xlog_recover_intent_type xlog_recover_extfree_type = {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 913eb9101110..51a7d4b963cd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2824,7 +2824,9 @@ xlog_recover_cancel_intents(
 			break;
 		}
 
-		type->cancel_intent(log, lip);
+		spin_unlock(&ailp->ail_lock);
+		type->cancel_intent(lip);
+		spin_lock(&ailp->ail_lock);
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index ab786739ff7c..01a393727a1e 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -724,15 +724,9 @@ xlog_recover_process_cui(
 /* Release the CUI since we're cancelling everything. */
 STATIC void
 xlog_recover_cancel_cui(
-	struct xlog			*log,
 	struct xfs_log_item		*lip)
 {
-	struct xfs_ail			*ailp = log->l_ailp;
-	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
-
-	spin_unlock(&ailp->ail_lock);
-	xfs_cui_release(cuip);
-	spin_lock(&ailp->ail_lock);
+	xfs_cui_release(CUI_ITEM(lip));
 }
 
 const struct xlog_recover_intent_type xlog_recover_refcount_type = {
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index a83f86915c40..69a2d23eedda 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -714,15 +714,9 @@ xlog_recover_process_rui(
 /* Release the RUI since we're cancelling everything. */
 STATIC void
 xlog_recover_cancel_rui(
-	struct xlog			*log,
 	struct xfs_log_item		*lip)
 {
-	struct xfs_ail			*ailp = log->l_ailp;
-	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
-
-	spin_unlock(&ailp->ail_lock);
-	xfs_rui_release(ruip);
-	spin_lock(&ailp->ail_lock);
+	xfs_rui_release(RUI_ITEM(lip));
 }
 
 const struct xlog_recover_intent_type xlog_recover_rmap_type = {

