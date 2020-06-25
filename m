Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC94C433E8
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39DE820C09
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qNGawFS5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgFYX3n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:29:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51210 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731950AbgFYX3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:29:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNRwUU012301
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=PX65Tbj5N3JmccBSDMXZTuceWLGgTyemO+tERH/1aA8=;
 b=qNGawFS5i6qgDuGfrVYPPhUFfH1llX05e0qDCc+tD1d6wpZ1ELKDVsPofyL3FzW84Tq3
 1Os6P4+kyH12hO1Qs21JYbgoXd2iLSn3dTymKXiWZze45FaUjE27onfU/0vn+Imssil5
 7Pf/a6zMikqgDNY7LqnzTqQXjcgF4wzjqXU96E8Kc4B0LYBufwbjXyDE3jVz7FLH8vYp
 KqCjnGLCPCcATxo1ugqiIufEJRYsbZSZm45rfOTFZ0sXTl9Pl9CyraCrn4O79P60dkxP
 1klZlYi7IbFhGIX8xUGR2Nt9MDOVFniFlvvFI2JcZfmFIHpm9stg3gW6lXFK0tZt9VCv Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31uustu960-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNS2Xd141169
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31uur1way3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNT3gC016784
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:03 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:03 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 14/26] xfsprogs: Remove unneeded xfs_trans_roll_inode calls
Date:   Thu, 25 Jun 2020 16:28:36 -0700
Message-Id: <20200625232848.14465-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=1 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250136
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
 libxfs/xfs_attr.c | 61 +++++++------------------------------------------------
 1 file changed, 7 insertions(+), 54 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4463c22..0b81bf5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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
 
@@ -1070,18 +1047,8 @@ restart:
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
@@ -1089,14 +1056,6 @@ restart:
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

