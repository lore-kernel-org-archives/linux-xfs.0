Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B8FC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A7DD2311B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLFXPR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:15:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59138 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgLFXPR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:15:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5ix7182044;
        Sun, 6 Dec 2020 23:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OzmnVKdRHi6WTgQFdPalPzUI3wEAvoeOIT05cy1Ifkc=;
 b=Q/TDXSuPOR2hWlcPBcE2Z4s0DzfhTonMeLspILEEs6XCu8ROTLluUS2XquRk05L2Ulek
 eA9/zNtF6Q46LP2NyOlD6ErS0KBKr7jyqnspXuLoJG8RTYB7WKIIVxrlnHaJO3H8gb0+
 R6fppAQomphzEJjtZkAD04O8/QG/sPC5jy4+lI/OIH8cvCTof0dMbFl5C4aclXbd8P3O
 xM4BhLav+OisQ/j27SftWmUf84IAmb+eHEYQ4tWCbajOaXSdSUxXTCpkOhu0jYQ6hnwF
 hTX0bx7RTgIHdfst1OtyigeavaCcGgG4JAQXlUwdH1NHHmJkBOxhTtqvUAqu4Ucn0CnZ Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35825ktujt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:12:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5bHS120667;
        Sun, 6 Dec 2020 23:10:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m4v6508-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:10:31 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NAUw4011589;
        Sun, 6 Dec 2020 23:10:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:10:30 -0800
Subject: [PATCH 07/10] xfs: hoist recovered extent-free intent checks out of
 xfs_efi_item_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sun, 06 Dec 2020 15:10:29 -0800
Message-ID: <160729622893.1607103.16920765742195834092.stgit@magnolia>
In-Reply-To: <160729618252.1607103.863261260798043728.stgit@magnolia>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=3
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_extfree_item.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6c11bfc3d452..f86c8a7c9c4e 100644
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
 
@@ -602,14 +620,13 @@ xfs_efi_item_recover(
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
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&efip->efi_format,
+					sizeof(efip->efi_format));
 			return -EFSCORRUPTED;
+		}
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);

