Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C47FC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA1C2087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ykJI9a7t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgH0A3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54674 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgH0A3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0TBg6022162
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=RNmmb6gqrXCYQyr/3829f9Hf8G7fCZTqs454omFtZwo=;
 b=ykJI9a7tL0l21Vg3tM3ZQkNKLz5TvTcrWUX0XD/bhqHBwC9b87bvkn6JEGzXMLZPMO0W
 pVGjScaA7/h2tIdoLBEIoZV6CEDTTqy0gj7iWvyjM4O2umJf6NdwamG6NQU8im8IsfXm
 vpCU+2Y2OqrmSdsHDrsyQODko38y031UZJgpYriWXJzkCXOUndkL/ZUUlJkLFcNJ+734
 HyC8s1qHHe5pUjxCtO42QEONuVuhaFblgWBk/zkJJmcZ7lM1CGr1TQMwuIqE1NS+ozE1
 SQVZNNR1O5xC+uirsLNS1ysimgaL4d4JrBMGXahuk9kgcqhvpU796aWlIbmKmi6wwvfS iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 335gw859e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0BME4038057
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 333r9mk544-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07R0THaw019045
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:17 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:17 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 22/32] xfsprogs: Lift -ENOSPC handler from xfs_attr_leaf_addname
Date:   Wed, 26 Aug 2020 17:28:46 -0700
Message-Id: <20200827002856.1131-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift -ENOSPC handler from xfs_attr_leaf_addname.  This will help to
reorganize transitions between the attr forms later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 592ba30..fc7de6b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -299,6 +299,13 @@ xfs_attr_set_args(
 			return error;
 
 		/*
+		 * Promote the attribute list to the Btree format.
+		 */
+		error = xfs_attr3_leaf_to_node(args);
+		if (error)
+			return error;
+
+		/*
 		 * Finish any deferred work items and roll the transaction once
 		 * more.  The goal here is to call node_addname with the inode
 		 * and transaction in the same state (inode locked and joined,
@@ -603,7 +610,7 @@ xfs_attr_leaf_try_add(
 	struct xfs_da_args	*args,
 	struct xfs_buf		*bp)
 {
-	int			retval, error;
+	int			retval;
 
 	/*
 	 * Look up the given attribute in the leaf block.  Figure out if
@@ -635,20 +642,10 @@ xfs_attr_leaf_try_add(
 	}
 
 	/*
-	 * Add the attribute to the leaf block, transitioning to a Btree
-	 * if required.
+	 * Add the attribute to the leaf block
 	 */
-	retval = xfs_attr3_leaf_add(bp, args);
-	if (retval == -ENOSPC) {
-		/*
-		 * Promote the attribute list to the Btree format. Unless an
-		 * error occurs, retain the -ENOSPC retval
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
-	}
-	return retval;
+	return xfs_attr3_leaf_add(bp, args);
+
 out_brelse:
 	xfs_trans_brelse(args->trans, bp);
 	return retval;
-- 
2.7.4

