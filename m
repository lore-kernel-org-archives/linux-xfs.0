Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046EFC3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B26206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XfW9aLD5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEEBNB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:13:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37650 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgEEBNB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:13:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513679054626;
        Tue, 5 May 2020 01:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=71JUqqeJLh6oixligJLt7Maf/wIaNIMwspo8lHf3WbQ=;
 b=XfW9aLD53lCppd5i5cAbONO7L+qWoWiwv4+PdFYJ1/rb76r1QWSmgjF6ecLsK2cv8K13
 hwtdr1RqaVL625VBM87EsTJmKX8H+PySuyd6UyaJAOABvZ53/BaWNZtjevm169QCs1R6
 NbP/uQD2qVzY6WeBDEhymUGcc0KybE8VziXRbh0LXZQ4TdibOdtV6zaOzu+cuXFTIW6N
 qez+lA8wZxfkGD+sqlvdTCqkat3fKWAdpmyFHUMU/9Nk158xsGMVAATwdeUVtwWM9G+J
 JHngrh23yrBRMM17tuuof+wxS5zB6b9HXpeNRC6abJaQ5PnHpvkWpsoffPGIWr8WbIWj uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30s0tma19u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:12:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516sKA004797;
        Tue, 5 May 2020 01:12:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdrtydn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:12:55 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451CsD3015187;
        Tue, 5 May 2020 01:12:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:12:54 -0700
Subject: [PATCH 22/28] xfs: refactor adding recovered intent items to the log
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:12:53 -0700
Message-ID: <158864117369.182683.15552207685086345850.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=1
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
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
index b875819a1c04..d8c0eae87179 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -128,5 +128,7 @@ int xlog_recover_process_unlinked(struct xlog *log);
 
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
+void xlog_recover_insert_ail(struct xlog *log, struct xfs_log_item *lip,
+		xfs_lsn_t lsn);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 96627ea800c8..090dc1c53c92 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -651,15 +651,7 @@ xlog_recover_bmap_intent_commit_pass2(
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
index 4e1b10ab17a5..dc6ebb5fb8d3 100644
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
index 55477b9b9311..a2c03d87c374 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1811,6 +1811,23 @@ xlog_recover_release_intent(
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
index 27126b136b5a..fdc18576a023 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -660,15 +660,7 @@ xlog_recover_refcount_intent_commit_pass2(
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
index 3987f217415c..f9cd3ff18736 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -651,15 +651,7 @@ xlog_recover_rmap_intent_commit_pass2(
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

