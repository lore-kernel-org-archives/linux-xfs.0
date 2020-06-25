Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D29DC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AC282084D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xtnmQKed"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgFYXaw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:30:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgFYXat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:30:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNUmXt014777
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=yOLP8iBWcY6oTlIqzIvdQhtcaK+i5B/EQKIqMxf0ejo=;
 b=xtnmQKedUgmgUjTjpwp+qhVmuQZLV4ON8JdNx2Ww24alcbHtKK673UJOeCsXFquiZY7h
 RXtGqpurrrCrSReWwFgLBbqBsP6CrY5aNKKDg1J8clAt7Eq/rn6r71l9vdX9laAb/fTK
 7mtsT+sxxOfMAeguNP88iDDi8CGJXHREG1t3VJrVYJGWoLwKPbWYicJUV8G/jMCmwyw+
 7L3cK/JHHZQUYOUvWt3CBnPCDWgbxDYbctWtG7DLk8KaolANjb6XsvpyJmdx49QODw24
 ccFSpJIarBHPvjVRNyKZVoGMuQx4CViEjMVHGVp8f83AZangGhiZKURmDAIG4OHqztSs sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31uustu9ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIw7117238
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31uuram5pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:47 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNUkfS008479
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:46 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:30:46 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 13/25] xfs: Remove unneeded xfs_trans_roll_inode calls
Date:   Thu, 25 Jun 2020 16:30:06 -0700
Message-Id: <20200625233018.14585-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625233018.14585-1-allison.henderson@oracle.com>
References: <20200625233018.14585-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=1 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some calls to xfs_trans_roll_inode and xfs_defer_finish routines are not
needed. If they are the last operations executed in these functions, and
no further changes are made, then higher level routines will roll or
commit the tranactions.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 61 ++++++------------------------------------------
 1 file changed, 7 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4eff875..1a78023 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -693,34 +693,15 @@ xfs_attr_leaf_addname(
 		/*
 		 * If the result is small enough, shrink it all into the inode.
 		 */
-		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
-			if (error)
-				return error;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
-		}
-
-		/*
-		 * Commit the remove and start the next trans in series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
 		error = xfs_attr3_leaf_clearflag(args);
-		if (error)
-			return error;
-
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	}
 	return error;
 }
@@ -780,15 +761,11 @@ xfs_attr_leaf_removename(
 	/*
 	 * If the result is small enough, shrink it all into the inode.
 	 */
-	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+	forkoff = xfs_attr_shortform_allfit(bp, dp);
+	if (forkoff)
+		return xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-	}
+
 	return 0;
 }
 
@@ -1070,18 +1047,8 @@ xfs_attr_node_addname(
 			error = xfs_da3_join(state);
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 		}
 
-		/*
-		 * Commit and start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
@@ -1089,14 +1056,6 @@ xfs_attr_node_addname(
 		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
-
-		 /*
-		  * Commit the flag value change and start the next trans in
-		  * series.
-		  */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
 	}
 	retval = error = 0;
 
@@ -1135,16 +1094,10 @@ xfs_attr_node_shrink(
 	if (forkoff) {
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
-		if (error)
-			return error;
-
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 	} else
 		xfs_trans_brelse(args->trans, bp);
 
-	return 0;
+	return error;
 }
 
 /*
-- 
2.7.4

