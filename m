Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9807C4361B
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7696D224B1
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387531AbgLDBND (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:13:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46754 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbgLDBND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:13:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B419A8n014366;
        Fri, 4 Dec 2020 01:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cVydzMHd42flGnsOKX96tyGFr/4PretGY5vbgs833iY=;
 b=ZRtOptspqOO4GrcMmLqgk0dnGt1sfdZZr2kvUbqYiDD5SSAUmn6tRRxX4pRWs2yejUKk
 z3NrYvyaOMrWURHgxonbMZe5gVinBQqkPcBT8KyA9Dl6XNZjFGFRiFnHEvDunF45KX1W
 CoWrmq5mGlZx8eqdU+jLA7rNtZd12hpUZanNmyWb7e08xv5GwcLkNA9ctKEXYa1GwPTh
 ofp20IAsppY4lewldMB70dNDh7ogYRjmOAxPN3okbkiBk2BbjACkopI43y6u8RXJZzIU
 St7+wErqJFOWYIjMVOV5U2lsXU/QlPSX/33eJeDsRrQIzNpeZc7Cn4xObOjZhqPLCcDr Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egm0ykm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 01:12:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41AFTw116024;
        Fri, 4 Dec 2020 01:12:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540f2n3xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 01:12:19 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B41CJT8002514;
        Fri, 4 Dec 2020 01:12:19 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:12:19 -0800
Subject: [PATCH 07/10] xfs: hoist recovered extent-free intent checks out of
 xfs_efi_item_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 03 Dec 2020 17:12:18 -0800
Message-ID: <160704433854.734470.16229052921938871989.stgit@magnolia>
In-Reply-To: <160704429410.734470.15640089119078502938.stgit@magnolia>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=3 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we recover a extent-free intent from the log, we need to validate
its contents before we try to replay them.  Hoist the checking code into
a separate function in preparation to refactor this code to use
validation helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6c11bfc3d452..5e0f0b0a6c83 100644
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
 
@@ -602,14 +620,11 @@ xfs_efi_item_recover(
 	 * just toss the EFI.
 	 */
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
-		extp = &efip->efi_format.efi_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, extp->ext_start));
-		if (startblock_fsb == 0 ||
-		    extp->ext_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    extp->ext_len >= mp->m_sb.sb_agblocks)
+		if (!xfs_efi_validate_ext(mp,
+					&efip->efi_format.efi_extents[i])) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);

