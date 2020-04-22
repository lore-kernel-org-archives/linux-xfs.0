Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5A3C54FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C05C206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jjfNS1XP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDVCHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:07:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44540 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgDVCHu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:07:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M24pfC168228
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=caJgGXyhUhWIK7eUIPsGQXHUKAGsyq3i5sCYajeZ29s=;
 b=jjfNS1XPvJpgIm5ypT7F1xZ/NYZpI5VJ4AF3hTzKvditj5fYdoVeXZv0kLXFxSvpbhDA
 KdhTkpv0otZeITIJEV8Lglxw9B03QGBSnk4a9JpyJcaodVgSoXQffIG+1K8DNDoVgCoJ
 eTD1Gfi2QLEAACkbq90we/hEHDKvONnHkBx/xn46KNiOeMFNoVAa+zaCpkBT3+dGVV1H
 HkX5b4ufrkuRaFD8P4Kor6TN/qOiF2a39gd0NVcIE5NX645bQ3eJBJ4xpXy5x+JjKQVS
 LXJf4WyQb1E3jSykNmc3e34pRghdBZR20k31g+icnaER/R8ZpPkjWdTKconLfvMPS5gs Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30grpgmhnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22ETq075377
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1hbgv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M27lKM014580
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:07:47 -0700
Subject: [PATCH 16/19] xfs: refactor adding recovered intent items to the log
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:46 -0700
Message-ID: <158752126650.2140829.12864119186355641266.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220014
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

During recovery, every intent that we recover from the log has to be
added to the AIL.  Replace the open-coded addition with a helper.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 ++
 fs/xfs/xfs_bmap_item.c          |   10 +---------
 fs/xfs/xfs_extfree_item.c       |   10 +---------
 fs/xfs/xfs_log_recover.c        |   17 +++++++++++++++++
 fs/xfs/xfs_refcount_item.c      |   10 +---------
 fs/xfs/xfs_rmap_item.c          |   10 +---------
 6 files changed, 23 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index ac1adccc8451..8cb38d8327ce 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -173,5 +173,7 @@ typedef bool (*xlog_recover_release_intent_fn)(struct xlog *log,
 		struct xfs_log_item *item, uint64_t intent_id);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id, xlog_recover_release_intent_fn fn);
+void xlog_recover_insert_ail(struct xlog *log, struct xfs_log_item *lip,
+		xfs_lsn_t lsn);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index cd593b98f102..df8155dfcc87 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -621,15 +621,7 @@ xlog_recover_bui(
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
index 6a873309f3bc..3af9e37892f1 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -682,15 +682,7 @@ xlog_recover_efi(
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
index 460f836de963..913eb9101110 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1797,6 +1797,23 @@ xlog_recover_release_intent(
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
 STATIC int xlog_recover_intent_pass2(struct xlog *log,
 		struct list_head *buffer_list, struct xlog_recover_item *item,
 		xfs_lsn_t current_lsn);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 6eef1523078c..ab786739ff7c 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -644,15 +644,7 @@ xlog_recover_cui(
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
index b60fb141c22e..a83f86915c40 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -637,15 +637,7 @@ xlog_recover_rui(
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

