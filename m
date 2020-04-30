Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CABC83004
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C494620787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sLjddKWm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgD3Atr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:49:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3Atq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:49:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0nbfR160805
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zPFbb1tLC897eQyqe0k0m0kn8LUecABpqB3vI5/2M6o=;
 b=sLjddKWmZyYhPQGEYTTQ87Whnj7ZMY5psZCsrTGWmPudQ0/WRdi0CYn/udWHP1p8gFG9
 urwjO9Xn7grq7fGS/LowPn47dCMBihQOSQbAuzfF5x7hL6T68Pi/lzYpuM/7XZ7OOfLe
 8vJnVbjKnA6hTbaIQbBTwEkF0vS5/YOq9Lcfcn9Xf00DkQBDyj7vuJ5BLz1RTB2xWExv
 JYjP7dnqKqQoSyYAJkW56TN+iKnbzSzgASXqcmCAL7tylwY1X4iCrivyA3/gOZLlDhUu
 FE5bpUNkI3lYHHQtROj52ksZPG34jlLrfawCgMYYP+wicjY86v3t4ckeHRuaDavjP+jF MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30p2p0e524-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0m73f070433
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30mxrw8kqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:44 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0niKh010014
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:49:43 -0700
Subject: [PATCH 19/21] xfs: refactor intent item RECOVERED flag into the log
 item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:49:42 -0700
Message-ID: <158820778291.467894.4890121695402237848.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=3
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=3 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename XFS_{EFI,BUI,RUI,CUI}_RECOVERED to XFS_LI_RECOVERED so that we
track recovery status in the log item, then get rid of the now unused
flags fields in each of those log item types.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |   10 +++++-----
 fs/xfs/xfs_bmap_item.h     |    6 ------
 fs/xfs/xfs_extfree_item.c  |    8 ++++----
 fs/xfs/xfs_extfree_item.h  |    6 ------
 fs/xfs/xfs_refcount_item.c |    8 ++++----
 fs/xfs/xfs_refcount_item.h |    6 ------
 fs/xfs/xfs_rmap_item.c     |    8 ++++----
 fs/xfs/xfs_rmap_item.h     |    6 ------
 fs/xfs/xfs_trans.h         |    4 +++-
 9 files changed, 20 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e38efdb0ed71..5b99ffb70659 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -141,7 +141,7 @@ xfs_bui_item_recover(
 	/*
 	 * Skip BUIs that we've already processed.
 	 */
-	if (test_bit(XFS_BUI_RECOVERED, &buip->bui_flags))
+	if (test_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags))
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
@@ -479,11 +479,11 @@ xfs_bui_recover(
 	struct xfs_bmbt_irec		irec;
 	struct xfs_mount		*mp = parent_tp->t_mountp;
 
-	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
+	ASSERT(!test_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags));
 
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
-		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+		set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
 		xfs_bui_release(buip);
 		return -EFSCORRUPTED;
 	}
@@ -517,7 +517,7 @@ xfs_bui_recover(
 		 * This will pull the BUI from the AIL and
 		 * free the memory associated with it.
 		 */
-		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+		set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
 		xfs_bui_release(buip);
 		return -EFSCORRUPTED;
 	}
@@ -575,7 +575,7 @@ xfs_bui_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+	set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
 	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index 44d06e62f8f9..b9be62f8bd52 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -32,11 +32,6 @@ struct kmem_zone;
  */
 #define	XFS_BUI_MAX_FAST_EXTENTS	1
 
-/*
- * Define BUI flag bits. Manipulated by set/clear/test_bit operators.
- */
-#define	XFS_BUI_RECOVERED		1
-
 /*
  * This is the "bmap update intent" log item.  It is used to log the fact that
  * some reverse mappings need to change.  It is used in conjunction with the
@@ -49,7 +44,6 @@ struct xfs_bui_log_item {
 	struct xfs_log_item		bui_item;
 	atomic_t			bui_refcount;
 	atomic_t			bui_next_extent;
-	unsigned long			bui_flags;	/* misc flags */
 	struct xfs_bui_log_format	bui_format;
 };
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 9264ec0817cc..6b5c2b263e5b 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -157,7 +157,7 @@ xfs_efi_item_recover(
 	 * Skip EFIs that we've already processed.
 	 */
 	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
-	if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
+	if (test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags))
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
@@ -634,7 +634,7 @@ xfs_efi_recover(
 	xfs_extent_t		*extp;
 	xfs_fsblock_t		startblock_fsb;
 
-	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
+	ASSERT(!test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags));
 
 	/*
 	 * First check the validity of the extents described by the
@@ -653,7 +653,7 @@ xfs_efi_recover(
 			 * This will pull the EFI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
+			set_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags);
 			xfs_efi_release(efip);
 			return -EFSCORRUPTED;
 		}
@@ -674,7 +674,7 @@ xfs_efi_recover(
 
 	}
 
-	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
+	set_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags);
 	error = xfs_trans_commit(tp);
 	return error;
 
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 23e3758b5dbb..30a9c7069233 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -16,11 +16,6 @@ struct kmem_zone;
  */
 #define	XFS_EFI_MAX_FAST_EXTENTS	16
 
-/*
- * Define EFI flag bits. Manipulated by set/clear/test_bit operators.
- */
-#define	XFS_EFI_RECOVERED	1
-
 /*
  * This is the "extent free intention" log item.  It is used to log the fact
  * that some extents need to be free.  It is used in conjunction with the
@@ -54,7 +49,6 @@ typedef struct xfs_efi_log_item {
 	struct xfs_log_item	efi_item;
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
-	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
 } xfs_efi_log_item_t;
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 408d9312035a..493f1d16a6ce 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -140,7 +140,7 @@ xfs_cui_item_recover(
 	/*
 	 * Skip CUIs that we've already processed.
 	 */
-	if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags))
+	if (test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags))
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
@@ -493,7 +493,7 @@ xfs_cui_recover(
 	bool				requeue_only = false;
 	struct xfs_mount		*mp = parent_tp->t_mountp;
 
-	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
+	ASSERT(!test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags));
 
 	/*
 	 * First check the validity of the extents described by the
@@ -524,7 +524,7 @@ xfs_cui_recover(
 			 * This will pull the CUI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
+			set_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags);
 			xfs_cui_release(cuip);
 			return -EFSCORRUPTED;
 		}
@@ -608,7 +608,7 @@ xfs_cui_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
+	set_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags);
 	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index cfaa857673a6..f4f2e836540b 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -32,11 +32,6 @@ struct kmem_zone;
  */
 #define	XFS_CUI_MAX_FAST_EXTENTS	16
 
-/*
- * Define CUI flag bits. Manipulated by set/clear/test_bit operators.
- */
-#define	XFS_CUI_RECOVERED		1
-
 /*
  * This is the "refcount update intent" log item.  It is used to log
  * the fact that some reverse mappings need to change.  It is used in
@@ -51,7 +46,6 @@ struct xfs_cui_log_item {
 	struct xfs_log_item		cui_item;
 	atomic_t			cui_refcount;
 	atomic_t			cui_next_extent;
-	unsigned long			cui_flags;	/* misc flags */
 	struct xfs_cui_log_format	cui_format;
 };
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index ffb06960b12c..69be891e85e8 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -139,7 +139,7 @@ xfs_rui_item_recover(
 	/*
 	 * Skip RUIs that we've already processed.
 	 */
-	if (test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags))
+	if (test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags))
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
@@ -533,7 +533,7 @@ xfs_rui_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 
-	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
+	ASSERT(!test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags));
 
 	/*
 	 * First check the validity of the extents described by the
@@ -568,7 +568,7 @@ xfs_rui_recover(
 			 * This will pull the RUI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
+			set_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags);
 			xfs_rui_release(ruip);
 			return -EFSCORRUPTED;
 		}
@@ -626,7 +626,7 @@ xfs_rui_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
+	set_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags);
 	error = xfs_trans_commit(tp);
 	return error;
 
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 48a77a6f5c94..31e6cdfff71f 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -35,11 +35,6 @@ struct kmem_zone;
  */
 #define	XFS_RUI_MAX_FAST_EXTENTS	16
 
-/*
- * Define RUI flag bits. Manipulated by set/clear/test_bit operators.
- */
-#define	XFS_RUI_RECOVERED		1
-
 /*
  * This is the "rmap update intent" log item.  It is used to log the fact that
  * some reverse mappings need to change.  It is used in conjunction with the
@@ -52,7 +47,6 @@ struct xfs_rui_log_item {
 	struct xfs_log_item		rui_item;
 	atomic_t			rui_refcount;
 	atomic_t			rui_next_extent;
-	unsigned long			rui_flags;	/* misc flags */
 	struct xfs_rui_log_format	rui_format;
 };
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9ac5483d2187..5bdbae090f5d 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -59,12 +59,14 @@ struct xfs_log_item {
 #define	XFS_LI_ABORTED	1
 #define	XFS_LI_FAILED	2
 #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
+#define	XFS_LI_RECOVERED 4	/* log intent item has been recovered */
 
 #define XFS_LI_FLAGS \
 	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
 	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
 	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
-	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
+	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
+	{ (1 << XFS_LI_RECOVERED),	"RECOVERED" }
 
 struct xfs_item_ops {
 	unsigned flags;

