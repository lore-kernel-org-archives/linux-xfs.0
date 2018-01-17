Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33190 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754145AbeAQQlF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 11:41:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0HGbMmf045910
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2018 16:41:04 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2fj8ahrsuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2018 16:41:04 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0HGf4P9007316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2018 16:41:04 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0HGf4PU017863
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2018 16:41:04 GMT
Date: Wed, 17 Jan 2018 08:41:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix non-debug build compiler warnings
Message-ID: <20180117164102.GE25805@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <djwong@djwong.org>

Fix compiler warning on non-debug build

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot_item.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index e564f11..51ee848 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -150,10 +150,7 @@ xfs_dquot_item_error(
 	struct xfs_log_item	*lip,
 	struct xfs_buf		*bp)
 {
-	struct xfs_dquot	*dqp;
-
-	dqp = DQUOT_ITEM(lip)->qli_dquot;
-	ASSERT(!completion_done(&dqp->q_flush));
+	ASSERT(!completion_done(&DQUOT_ITEM(lip)->qli_dquot->q_flush));
 	xfs_set_li_failed(lip, bp);
 }
 
