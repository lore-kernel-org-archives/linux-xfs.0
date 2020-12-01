Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF65C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B612E206ED
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nMFqCmt0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgLADlG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:41:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40974 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbgLADlG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:41:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13d4CL168697
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TtrmEHUzGYQcEwbGkfMYDFixoq/k4ASQcf6RBJhQgyQ=;
 b=nMFqCmt0mO8d0yrBfjuJMMxGzr8UUvjqiyY3iDf6PS0vTLCPBrHwtcma/f/zRJJH7tv6
 Km6pRwOurP+q6XkObiP8brJFg9PGbB8Q/Pe4kpnT+ZczmVEl2Mys6M3RdBpITs4F5a2l
 jUEMTyTID/mjRg9N7Xm3etOUdZ+Wr3f0jovdAWQsK+PF/4N5W71F7fPON0Kj38mro4vc
 uNqFIlJZHe8Qkp9GFMN+q5DRVnie7HamHiZjjcevu/0HlY/thFpPW+6gPlCohUqVRZjn
 XuVTwz+v+dQjp1XGPd974Wl3SdOnhQbTte+kztZbyaulggB855xGwRA2nEudhvteVY6c cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egkgcw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:40:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13VIvR071428
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540fw826f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B13cNLB012286
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:38:23 -0800
Subject: [PATCH 07/10] xfs: hoist recovered extent-free intent checks out of
 xfs_efi_item_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:38:22 -0800
Message-ID: <160679390266.447963.18406641317021209964.stgit@magnolia>
In-Reply-To: <160679385987.447963.9630288535682256882.stgit@magnolia>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010024
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we recover a extent-free intent from the log, we need to validate
its contents before we try to replay them.  Hoist the checking code into
a separate function in preparation to refactor this code to use
validation helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_extfree_item.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6c11bfc3d452..b5710b7fc263 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -578,6 +578,25 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
+/* Is this recovered EFI ok? */
+static inline bool
+xfs_efi_validate_ext(
+	struct xfs_mount		*mp,
+	struct xfs_extent		*extp)
+{
+	xfs_fsblock_t			startblock_fsb;
+
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, extp->ext_start));
+	if (startblock_fsb == 0 ||
+	    extp->ext_len == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    extp->ext_len >= mp->m_sb.sb_agblocks)
+		return false;
+
+	return true;
+}
+
 /*
  * Process an extent free intent item that was recovered from
  * the log.  We need to free the extents that it describes.
@@ -592,7 +611,6 @@ xfs_efi_item_recover(
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
 	struct xfs_extent		*extp;
-	xfs_fsblock_t			startblock_fsb;
 	int				i;
 	int				error = 0;
 
@@ -601,16 +619,9 @@ xfs_efi_item_recover(
 	 * EFI.  If any are bad, then assume that all are bad and
 	 * just toss the EFI.
 	 */
-	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
-		extp = &efip->efi_format.efi_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, extp->ext_start));
-		if (startblock_fsb == 0 ||
-		    extp->ext_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    extp->ext_len >= mp->m_sb.sb_agblocks)
+	for (i = 0; i < efip->efi_format.efi_nextents; i++)
+		if (!xfs_efi_validate_ext(mp, &efip->efi_format.efi_extents[i]))
 			return -EFSCORRUPTED;
-	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error)

