Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B959EC54FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93940206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:06:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eVBBVV08"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgDVCGx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:06:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37910 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVCGw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:06:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22x3V074509
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6BsQ44lEsBPu6JM/D5m+xbGfLcd0C5sr+Og8vN3auQk=;
 b=eVBBVV08pegx/TXMFUsRCC/RoZ2wYX5WGwDtIOZJ61gMurx0rf5zX2n7UGwFY3ThOlvH
 z4YV2iPjyHfDKxFOHM9/NDEUg2qp5FXUP1QFql0OUknDlp7SS8L3lRWfUF2awQbfddo0
 jimaJR8ZpWfLmGxL5yLOP5uvFrlApCc2SMsJ/tfkfAXEV29RGKJqn4N8I9eB+OL76RC3
 fqFyoDs3gIc/IUqdZkY9JME1h8UAY1xUspYSxpOMb0IXT50cCZTXJqkIrQA/FTGGPHft
 fIuMiehZooObrfuhDAzXUOPO4kZbTiUzLfxeWrfcsEmfsXueilEBYcktcwyGwA67wZjD RA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30ft6n81he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M21bOZ064956
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30gb3t4mpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:50 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M26n3X014148
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:06:49 -0700
Subject: [PATCH 07/19] xfs: refactor log recovery intent item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:06:48 -0700
Message-ID: <158752120800.2140829.455621202654717367.stgit@magnolia>
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
 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the log intent item pass2 commit code into the per-item source code
files and use the dispatch function to call it.  We do these one at a
time because there's a lot of code to move.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |   44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2e4f400d3f6e..2abcca26e4c7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1770,8 +1770,13 @@ xlog_clear_stale_blocks(
 
 /* Log intent item dispatching. */
 
+STATIC int xlog_recover_intent_pass2(struct xlog *log,
+		struct list_head *buffer_list, struct xlog_recover_item *item,
+		xfs_lsn_t current_lsn);
+
 const struct xlog_recover_item_type xlog_intent_item_type = {
 	.reorder		= XLOG_REORDER_INODE_LIST,
+	.commit_pass2_fn	= xlog_recover_intent_pass2,
 };
 
 /******************************************************************************
@@ -2693,35 +2698,48 @@ xlog_recover_commit_pass1(
 }
 
 STATIC int
-xlog_recover_commit_pass2(
+xlog_recover_intent_pass2(
 	struct xlog			*log,
-	struct xlog_recover		*trans,
 	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item)
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
 {
-	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
-
-	if (item->ri_type && item->ri_type->commit_pass2_fn)
-		return item->ri_type->commit_pass2_fn(log, buffer_list, item,
-				trans->r_lsn);
-
 	switch (ITEM_TYPE(item)) {
 	case XFS_LI_EFI:
-		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
+		return xlog_recover_efi_pass2(log, item, current_lsn);
 	case XFS_LI_EFD:
 		return xlog_recover_efd_pass2(log, item);
 	case XFS_LI_RUI:
-		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
+		return xlog_recover_rui_pass2(log, item, current_lsn);
 	case XFS_LI_RUD:
 		return xlog_recover_rud_pass2(log, item);
 	case XFS_LI_CUI:
-		return xlog_recover_cui_pass2(log, item, trans->r_lsn);
+		return xlog_recover_cui_pass2(log, item, current_lsn);
 	case XFS_LI_CUD:
 		return xlog_recover_cud_pass2(log, item);
 	case XFS_LI_BUI:
-		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
+		return xlog_recover_bui_pass2(log, item, current_lsn);
 	case XFS_LI_BUD:
 		return xlog_recover_bud_pass2(log, item);
+	}
+
+	return -EFSCORRUPTED;
+}
+
+STATIC int
+xlog_recover_commit_pass2(
+	struct xlog			*log,
+	struct xlog_recover		*trans,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item)
+{
+	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
+
+	if (item->ri_type && item->ri_type->commit_pass2_fn)
+		return item->ri_type->commit_pass2_fn(log, buffer_list, item,
+				trans->r_lsn);
+
+	switch (ITEM_TYPE(item)) {
 	case XFS_LI_DQUOT:
 		return xlog_recover_dquot_pass2(log, buffer_list, item,
 						trans->r_lsn);

