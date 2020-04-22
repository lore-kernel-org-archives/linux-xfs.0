Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE87C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8B26206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QvG2Nlnz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDVCIJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:08:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgDVCII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:08:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M23I4v074563
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bPQs51kj5rY2fVtmOYDd6rdhcC7RW5Vxrog7SCoTwaA=;
 b=QvG2Nlnz3/YBKfsNLmKPi1kkyrcmScePCwabJxRVEdk4f3FZCmuScP4I7LTWxVP5ywd2
 hiBApOK3E9AZsiHDYfudEV7Oi8eJ9SbUGiCorE7V7foMfejgL6Bm7QVPpi2rHWiEvcc9
 rR1QczuU6ct4mUwp5RWqbEwK7cecRf/h4CScfsI/qxZ4Qz/N8rO6DrAMw4EwOUftIo40
 Cg/ZQOAAgfUoG220F5l1TG5MpGYdNAbiNjG0TcwP4pAFP5GumAz9yqCAticgMMU0+igK
 WV+qGALX5GZr/hWw0Fe/3TRdMy9LOGVG5Dz4PF1TFUm7urNbr8IFiz8iEBnFS6L83dYS og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30ft6n81md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22FWS075402
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30gb1hbh9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:07 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03M286UN031731
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:08:06 -0700
Subject: [PATCH 19/19] xfs: move xlog_recover_intent_pass2 up in the file
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:08:05 -0700
Message-ID: <158752128537.2140829.17923623833043582709.stgit@magnolia>
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

Move xlog_recover_intent_pass2 up in the file so that we don't have to
have a forward declaration of a static function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |  110 ++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 250f04419035..5a20a95c5dad 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1814,9 +1814,59 @@ xlog_recover_insert_ail(
 	xfs_trans_ail_update(log->l_ailp, lip, lsn);
 }
 
-STATIC int xlog_recover_intent_pass2(struct xlog *log,
-		struct list_head *buffer_list, struct xlog_recover_item *item,
-		xfs_lsn_t current_lsn);
+static inline const struct xlog_recover_intent_type *
+xlog_intent_for_type(
+	unsigned short			type)
+{
+	switch (type) {
+	case XFS_LI_EFD:
+	case XFS_LI_EFI:
+		return &xlog_recover_extfree_type;
+	case XFS_LI_RUD:
+	case XFS_LI_RUI:
+		return &xlog_recover_rmap_type;
+	case XFS_LI_CUI:
+	case XFS_LI_CUD:
+		return &xlog_recover_refcount_type;
+	case XFS_LI_BUI:
+	case XFS_LI_BUD:
+		return &xlog_recover_bmap_type;
+	default:
+		return NULL;
+	}
+}
+
+static inline bool
+xlog_is_intent_done_item(
+	struct xlog_recover_item	*item)
+{
+	switch (ITEM_TYPE(item)) {
+	case XFS_LI_EFD:
+	case XFS_LI_RUD:
+	case XFS_LI_CUD:
+	case XFS_LI_BUD:
+		return true;
+	default:
+		return false;
+	}
+}
+
+STATIC int
+xlog_recover_intent_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
+{
+	const struct xlog_recover_intent_type *type;
+
+	type = xlog_intent_for_type(ITEM_TYPE(item));
+	if (!type)
+		return -EFSCORRUPTED;
+	if (xlog_is_intent_done_item(item))
+		return type->recover_done(log, item);
+	return type->recover_intent(log, item, current_lsn);
+}
 
 const struct xlog_recover_item_type xlog_intent_item_type = {
 	.reorder		= XLOG_REORDER_INODE_LIST,
@@ -2075,60 +2125,6 @@ xlog_recover_commit_pass1(
 	return item->ri_type->commit_pass1_fn(log, item);
 }
 
-static inline const struct xlog_recover_intent_type *
-xlog_intent_for_type(
-	unsigned short			type)
-{
-	switch (type) {
-	case XFS_LI_EFD:
-	case XFS_LI_EFI:
-		return &xlog_recover_extfree_type;
-	case XFS_LI_RUD:
-	case XFS_LI_RUI:
-		return &xlog_recover_rmap_type;
-	case XFS_LI_CUI:
-	case XFS_LI_CUD:
-		return &xlog_recover_refcount_type;
-	case XFS_LI_BUI:
-	case XFS_LI_BUD:
-		return &xlog_recover_bmap_type;
-	default:
-		return NULL;
-	}
-}
-
-static inline bool
-xlog_is_intent_done_item(
-	struct xlog_recover_item	*item)
-{
-	switch (ITEM_TYPE(item)) {
-	case XFS_LI_EFD:
-	case XFS_LI_RUD:
-	case XFS_LI_CUD:
-	case XFS_LI_BUD:
-		return true;
-	default:
-		return false;
-	}
-}
-
-STATIC int
-xlog_recover_intent_pass2(
-	struct xlog			*log,
-	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			current_lsn)
-{
-	const struct xlog_recover_intent_type *type;
-
-	type = xlog_intent_for_type(ITEM_TYPE(item));
-	if (!type)
-		return -EFSCORRUPTED;
-	if (xlog_is_intent_done_item(item))
-		return type->recover_done(log, item);
-	return type->recover_intent(log, item, current_lsn);
-}
-
 STATIC int
 xlog_recover_commit_pass2(
 	struct xlog			*log,

