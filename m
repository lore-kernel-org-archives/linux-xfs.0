Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD8AC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C2920768
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WF2kEr4V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgFYXcw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:32:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51932 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgFYXcv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:32:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNS9RH151884
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=qjUIVUlY2mlCt0Y9p78bgesjqAlAhADUnZla+cTGT5k=;
 b=WF2kEr4VH1ZshTCA1i1hTy7ayqKdD79/YlZBCaYrRvQQvfysX0douUsuqKEZNIkzegGB
 Z6ZxOr0NKqCVMJVX1yPjBhGStm3OgFM/mytb27JD+5NVcym8livt+9Hn8aSkz5uzhw3n
 3XYlgg6hB0/enmedJ/2nmU7WdSPLro3f1flW/+t2NybiVG/IWpH7cEp3VyZTrJ+ORD2V
 Ep7cZB+so5Bky6VtsawpZrzQTahUA1O9c4+iR+lv9Ua+e7DlHPZnfnMDHAWQDoOz2gsH
 jcJrLC4jg7Z547ntH9A20pKbPsAll1o5jRsMpBPkiYU8Ln1GCFScG1qAf9x9K/LkGlQt UA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31uusu3ajr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:32:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNS25h141158
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31uur1wcvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:49 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNUmAJ017550
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:48 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:30:48 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 22/25] xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
Date:   Thu, 25 Jun 2020 16:30:15 -0700
Message-Id: <20200625233018.14585-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625233018.14585-1-allison.henderson@oracle.com>
References: <20200625233018.14585-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=1 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
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
 fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e618b09..4b78c86 100644
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

