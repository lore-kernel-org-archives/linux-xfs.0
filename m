Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BB3C4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A084D23A23
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732814AbgLRH2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:28:49 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35392 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732686AbgLRH2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:28:49 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KRsD001615
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:28:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=kMmVtC8du7y2ASNPS0mWTwpS0U6uUMfHgwGhns37Ofc=;
 b=r5be4KPTC8gEptDrKlqf5amTAKorNiB9mMk5n/IxiHpIgWXwla5WKB/i/GU45CB8c4N4
 GmacWd1l5OmbdD24YkdFHlePDbUycfmDDhMB+kvauLbbEsJw67awJzMEq8y7bv5K4cWR
 +xz/8czURx+CFl1R9MSf/VdtbfJ5166Uq2U6SD9jcL8ym1SFeghgnhHh/vrCr1tgwofx
 9+4cFKRecsFw0Ms0/DuJGlG3TN/BAQEYmwAguPsDIoDkaJZYxAe49vJrwe0ncZhRBulg
 quQAbeXxmBt5HeMH+Jxz1h4T4cHJ8GKUNVH46IlXTu88TpY88I8g1FzNmE+C6GlFLgam Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcbs6ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:28:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LLon044543
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7erys61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BI7Q6qN020797
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:06 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:26:06 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 02/14] xfsprogs: Add xfs_attr_node_remove_cleanup
Date:   Fri, 18 Dec 2020 00:25:43 -0700
Message-Id: <20201218072555.16694-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072555.16694-1-allison.henderson@oracle.com>
References: <20201218072555.16694-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 4078af18570ef0f89fce18e9ed9c1fa0c827f37b

This patch pulls a new helper function xfs_attr_node_remove_cleanup out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 3645398..5bed2e1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1220,6 +1220,25 @@ xfs_attr_node_remove_rmt(
 	return xfs_attr_refillstate(state);
 }
 
+STATIC int
+xfs_attr_node_remove_cleanup(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1232,7 +1251,6 @@ xfs_attr_node_remove_step(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1247,14 +1265,7 @@ xfs_attr_node_remove_step(
 		if (error)
 			return error;
 	}
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	retval = xfs_attr_node_remove_cleanup(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

