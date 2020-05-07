Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD504C47257
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B71C22071A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gcWlhx26"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgEGBD4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:03:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53118 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgEGBD4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:03:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04710AZH123975
        for <linux-xfs@vger.kernel.org>; Thu, 7 May 2020 01:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=v6deaJHbMWleg8a3yg4DgiwAs6KLxValpnyhY7cL5ks=;
 b=gcWlhx26oa4awv70FTuKBG1iT8/7z8uoDxIhR5mA1mon6ed8cPRGgiM3eaZXBMTgpkna
 ZixStwjC/dyXbTXfkRAr3UfPXZ5hZ9kPVbDftW3JsEd1m2rV3PJS2hve7rjhkU8viLa/
 frAF6RUtH4yjwta53AWaaTn80ZtwdVl2b9Qpsgcbh63m8mUr9wlLgtvH2BWDdJRrDcmb
 ut2g4usq0gVRSh8Ot5qfAljQ/0Pmfq5i7kenEHYbsXymDeshQ+Edf0oOTmrrI/lkYnum
 5oQxbXtqk55HISHg4IWZuuRuWDYnLQIlfpC/JF9k91+ec8i0yIsJI652X4mIHktoYUIw xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30usgq4jgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 May 2020 01:03:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470wdPX052163
        for <linux-xfs@vger.kernel.org>; Thu, 7 May 2020 01:03:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30us7p3n2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 May 2020 01:03:54 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04713rhI001278
        for <linux-xfs@vger.kernel.org>; Thu, 7 May 2020 01:03:53 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:03:53 -0700
Subject: [PATCH 20/25] xfs: refactor adding recovered intent items to the log
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:03:49 -0700
Message-ID: <158881342959.189971.5621808877331045450.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During recovery, every intent that we recover from the log has to be
added to the AIL.  Replace the open-coded addition with a helper.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |   10 +++-------
 fs/xfs/xfs_extfree_item.c  |   10 +++-------
 fs/xfs/xfs_refcount_item.c |   10 +++-------
 fs/xfs/xfs_rmap_item.c     |   10 +++-------
 fs/xfs/xfs_trans_ail.c     |   11 +++++++++++
 fs/xfs/xfs_trans_priv.h    |    3 +++
 6 files changed, 26 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index b3996f361b87..1e9bc8d15f51 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -651,15 +651,11 @@ xlog_recover_bui_commit_pass2(
 		return error;
 	}
 	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
 	/*
-	 * The RUI has two references. One for the RUD and one for RUI to ensure
-	 * it makes it into the AIL. Insert the RUI into the AIL directly and
-	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
+	 * Insert the intent into the AIL directly and drop one reference so
+	 * that finishing or canceling the work will drop the other.
 	 */
-	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
+	xfs_trans_ail_insert(log->l_ailp, &buip->bui_item, lsn);
 	xfs_bui_release(buip);
 	return 0;
 }
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3855e30109bf..99c4643d0ae8 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -710,15 +710,11 @@ xlog_recover_efi_commit_pass2(
 		return error;
 	}
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
 	/*
-	 * The EFI has two references. One for the EFD and one for EFI to ensure
-	 * it makes it into the AIL. Insert the EFI into the AIL directly and
-	 * drop the EFI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
+	 * Insert the intent into the AIL directly and drop one reference so
+	 * that finishing or canceling the work will drop the other.
 	 */
-	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
+	xfs_trans_ail_insert(log->l_ailp, &efip->efi_item, lsn);
 	xfs_efi_release(efip);
 	return 0;
 }
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index c03836e1a6d7..a9c513338ddc 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -660,15 +660,11 @@ xlog_recover_cui_commit_pass2(
 		return error;
 	}
 	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
 	/*
-	 * The CUI has two references. One for the CUD and one for CUI to ensure
-	 * it makes it into the AIL. Insert the CUI into the AIL directly and
-	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
+	 * Insert the intent into the AIL directly and drop one reference so
+	 * that finishing or canceling the work will drop the other.
 	 */
-	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
+	xfs_trans_ail_insert(log->l_ailp, &cuip->cui_item, lsn);
 	xfs_cui_release(cuip);
 	return 0;
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 31d35de518d1..ee0be4310c7c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -651,15 +651,11 @@ xlog_recover_rui_commit_pass2(
 		return error;
 	}
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
 	/*
-	 * The RUI has two references. One for the RUD and one for RUI to ensure
-	 * it makes it into the AIL. Insert the RUI into the AIL directly and
-	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
+	 * Insert the intent into the AIL directly and drop one reference so
+	 * that finishing or canceling the work will drop the other.
 	 */
-	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
+	xfs_trans_ail_insert(log->l_ailp, &ruip->rui_item, lsn);
 	xfs_rui_release(ruip);
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index bf09d4b4df58..ac5019361a13 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -815,6 +815,17 @@ xfs_trans_ail_update_bulk(
 	xfs_ail_update_finish(ailp, tail_lsn);
 }
 
+/* Insert a log item into the AIL. */
+void
+xfs_trans_ail_insert(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	spin_lock(&ailp->ail_lock);
+	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
+}
+
 /*
  * Delete one log item from the AIL.
  *
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index cc046d9557ae..3004aeac9110 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -91,6 +91,9 @@ xfs_trans_ail_update(
 	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
 }
 
+void xfs_trans_ail_insert(struct xfs_ail *ailp, struct xfs_log_item *lip,
+		xfs_lsn_t lsn);
+
 xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
 void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
 			__releases(ailp->ail_lock);

