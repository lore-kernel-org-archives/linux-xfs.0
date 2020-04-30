Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0FEC47257
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E7220873
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:52:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RjVPgaMw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgD3Wwl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:52:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47220 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgD3Wwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:52:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMmvLO132896
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=9b7walYvUCAG1BmhFzBCioZC+z6ae9wOjsnAFoZVyI8=;
 b=RjVPgaMwyxuARTDT8mQkzk+MNRCqlC3Tk6V5RmkcHfVIuVSN8X5cb0wXxrSg8LYLutwI
 tL3rwrKXdyjAHOaB68m07RhwawH7RX433xy7xtRN7upGam2b5LbzpEghYb2BOEPrQ3sz
 Q3nfGcFW9EG1VvqQl17HwCRXjEPQ/B5dSzAYXZ4AM6yUz7HV6W22P/G9d6xXji0yQ99T
 sIIPt66jkTYUpb7o9UIk0ipoUe9hiUnVHsVi1ZBP7VmyH3K+YckAql9X0WrkkE8bEymw
 2ohcNGFTUhjapkhkU415IVHymCTsaZ1Ua8UuOnDy5gAShxAWOuHFrh5vQOSyYjXN8WfD Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30r7f3g2nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:52:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgDCR141451
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30qtg23n78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:39 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMoc1H011231
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:38 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:50:38 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 21/24] xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
Date:   Thu, 30 Apr 2020 15:50:13 -0700
Message-Id: <20200430225016.4287-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430225016.4287-1-allison.henderson@oracle.com>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift -ENOSPC handler from xfs_attr_leaf_addname.  This will help to
reorganize transitions between the attr forms later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9171895..c8cae68 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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
 		 * Commit that transaction so that the node_addname()
 		 * call can manage its own transactions.
 		 */
@@ -602,7 +609,7 @@ xfs_attr_leaf_try_add(
 	struct xfs_da_args	*args,
 	struct xfs_buf		*bp)
 {
-	int			retval, error;
+	int			retval;
 
 	/*
 	 * Look up the given attribute in the leaf block.  Figure out if
@@ -634,20 +641,10 @@ xfs_attr_leaf_try_add(
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

