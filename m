Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609B3C28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3548E20747
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rLTbvnNP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgEGBIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:08:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56262 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgEGBIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:08:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470xO0t123196;
        Thu, 7 May 2020 01:06:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2bEaVRrWoF6QckdPRIzw9N2j8JQGKHB2UNtLteMK+ZI=;
 b=rLTbvnNPUuAZUPskH87aOECfncBJp7oO5++3G+LEWWXyOG7RlU4OxtgKHpCDQWWLjxjk
 GNQrk9Edy5HjJutCZFeYovyz5nyI2eEKB9EvBbYG4tWiWZS2QDfqjszUmQq99QyTm60U
 B3UYgxh1bTTAL+np8HmQUNk1BC0NJyzQOHeab1SAzc9Zy1Jp1aH2rq3B/ouQoE+j9fup
 hIVZxNIlSC+PZuTK1KI1VUMGhgDtPXJ0WrVAkBLulChmkohIlQxePwiSAowiii9jZgUn
 /f8v3SDPKED5+wEEDnVcr31izH69XByUyneVYBrnXRG+6orIZdASC8PFIZQKWDaBmjy9 qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30usgq4jnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:06:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vmvE009935;
        Thu, 7 May 2020 01:04:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30t1r96gc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:00 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04713xiV028800;
        Thu, 7 May 2020 01:03:59 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:03:59 -0700
Subject: [PATCH 21/25] xfs: refactor intent item RECOVERED flag into the log
 item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:03:55 -0700
Message-ID: <158881343573.189971.16574218227921676795.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=3
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename XFS_{EFI,BUI,RUI,CUI}_RECOVERED to XFS_LI_RECOVERED so that we
track recovery status in the log item, then get rid of the now unused
flags fields in each of those log item types.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 1e9bc8d15f51..8a5ac8cfd5f2 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -441,11 +441,11 @@ xfs_bui_recover(
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
@@ -479,7 +479,7 @@ xfs_bui_recover(
 		 * This will pull the BUI from the AIL and
 		 * free the memory associated with it.
 		 */
-		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+		set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
 		xfs_bui_release(buip);
 		return -EFSCORRUPTED;
 	}
@@ -537,7 +537,7 @@ xfs_bui_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+	set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
 	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -568,7 +568,7 @@ xfs_bui_item_recover(
 	/*
 	 * Skip BUIs that we've already processed.
 	 */
-	if (test_bit(XFS_BUI_RECOVERED, &buip->bui_flags))
+	if (test_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags))
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
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
index 99c4643d0ae8..ffa15bcaea33 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -592,7 +592,7 @@ xfs_efi_recover(
 	xfs_extent_t		*extp;
 	xfs_fsblock_t		startblock_fsb;
 
-	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
+	ASSERT(!test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags));
 
 	/*
 	 * First check the validity of the extents described by the
@@ -611,7 +611,7 @@ xfs_efi_recover(
 			 * This will pull the EFI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
+			set_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags);
 			xfs_efi_release(efip);
 			return -EFSCORRUPTED;
 		}
@@ -632,7 +632,7 @@ xfs_efi_recover(
 
 	}
 
-	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
+	set_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags);
 	error = xfs_trans_commit(tp);
 	return error;
 
@@ -655,7 +655,7 @@ xfs_efi_item_recover(
 	 * Skip EFIs that we've already processed.
 	 */
 	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
-	if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
+	if (test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags))
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 4b2c2c5c5985..cd2860c875bf 100644
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
@@ -54,7 +49,6 @@ struct xfs_efi_log_item {
 	struct xfs_log_item	efi_item;
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
-	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
 };
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a9c513338ddc..c7d584b99508 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -441,7 +441,7 @@ xfs_cui_recover(
 	bool				requeue_only = false;
 	struct xfs_mount		*mp = parent_tp->t_mountp;
 
-	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
+	ASSERT(!test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags));
 
 	/*
 	 * First check the validity of the extents described by the
@@ -472,7 +472,7 @@ xfs_cui_recover(
 			 * This will pull the CUI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
+			set_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags);
 			xfs_cui_release(cuip);
 			return -EFSCORRUPTED;
 		}
@@ -556,7 +556,7 @@ xfs_cui_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
+	set_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags);
 	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
@@ -581,7 +581,7 @@ xfs_cui_item_recover(
 	/*
 	 * Skip CUIs that we've already processed.
 	 */
-	if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags))
+	if (test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags))
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
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
index ee0be4310c7c..45cc7bfe82b4 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -480,7 +480,7 @@ xfs_rui_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 
-	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
+	ASSERT(!test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags));
 
 	/*
 	 * First check the validity of the extents described by the
@@ -515,7 +515,7 @@ xfs_rui_recover(
 			 * This will pull the RUI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
+			set_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags);
 			xfs_rui_release(ruip);
 			return -EFSCORRUPTED;
 		}
@@ -573,7 +573,7 @@ xfs_rui_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
+	set_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags);
 	error = xfs_trans_commit(tp);
 	return error;
 
@@ -596,7 +596,7 @@ xfs_rui_item_recover(
 	/*
 	 * Skip RUIs that we've already processed.
 	 */
-	if (test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags))
+	if (test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags))
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
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
index 3e8808bb07c5..8308bf6d7e40 100644
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

