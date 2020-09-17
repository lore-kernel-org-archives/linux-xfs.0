Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C3BC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB49821D1B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k0/vvlAJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIQHCG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:02:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49104 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQHBq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:01:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H6xfV2168045;
        Thu, 17 Sep 2020 07:01:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iKpowwBGguJbRbUGteu7w5O4atjfToKvP63WOOiqPkY=;
 b=k0/vvlAJ8DilmwhLgvXLmQTwBJkfS/9A5tXLApeO2yW4Pip5bNfww/Fd87Z0qtDYh0mX
 gQS4SDcud9sSlY86mmXtTvIl3ke6xHP/OwHaBv0tyMAlxb32BeE+orcaAVuTB+1Cp4CP
 sPs2kFbhvqMp/SpKWSdx2KY6gKXSpVxte3HJi19Lypen6RyJu6Vya4vCbwfxxSh1/zVu
 BaqXAWUpcX9bDzJjMrsb/duIbGiy/xq389aCrBiRwfnTwvWLsVNSA+WkcQBtq9l13rbg
 9aFYRQmcoRDyUPwWkQYkNYdZpRhxxKSL7NN3wBrJq/jUlW7NKPRNgMt7NCS1zT2kE6YL 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrr79qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 07:01:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H6xthW024126;
        Thu, 17 Sep 2020 07:01:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33hm3493nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 07:01:37 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08H71aSa007580;
        Thu, 17 Sep 2020 07:01:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 07:01:36 +0000
Date:   Thu, 17 Sep 2020 00:01:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH 3/2] xfs: free the intent item when allocating recovery
 transaction fails
Message-ID: <20200917070135.GV7955@magnolia>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031332353.3624373.16349101558356065522.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=5
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170051
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The recovery functions of all four log intent items fail to free the
intent item if the transaction allocation fails.  Fix this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |    5 ++++-
 fs/xfs/xfs_extfree_item.c  |    5 ++++-
 fs/xfs/xfs_refcount_item.c |    5 ++++-
 fs/xfs/xfs_rmap_item.c     |    5 ++++-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 2b1cf3ed8172..85d18cd708ba 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -484,8 +484,11 @@ xfs_bui_item_recover(
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
-	if (error)
+	if (error) {
+		xfs_bui_release(buip);
 		return error;
+	}
+
 	/*
 	 * Recovery stashes all deferred ops during intent processing and
 	 * finishes them on completion. Transfer current dfops state to this
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6cb8cd11072a..9ceac1a0a39f 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -619,8 +619,11 @@ xfs_efi_item_recover(
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
-	if (error)
+	if (error) {
+		xfs_efi_release(efip);
 		return error;
+	}
+
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 492d80a0b406..aae2a6ec00d3 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -491,8 +491,11 @@ xfs_cui_item_recover(
 	 */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
-	if (error)
+	if (error) {
+		xfs_cui_release(cuip);
 		return error;
+	}
+
 	/*
 	 * Recovery stashes all deferred ops during intent processing and
 	 * finishes them on completion. Transfer current dfops state to this
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index dc5b0753cd51..9e7fabb54ff1 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -523,8 +523,11 @@ xfs_rui_item_recover(
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 			mp->m_rmap_maxlevels, 0, XFS_TRANS_RESERVE, &tp);
-	if (error)
+	if (error) {
+		xfs_rui_release(ruip);
 		return error;
+	}
+
 	rudp = xfs_trans_get_rud(tp, ruip);
 
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
