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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46A3C2BBD4
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FB4E23A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732884AbgLRHaG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:30:06 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36408 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732863AbgLRHaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:30:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7K6Ph001489
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=u3HPgTZCINJoUBOl1z/cQ2pl12VddPb+Hn8GqicUynA=;
 b=Yy1JVk4QD+bY0zZ0ltYJWQ5VGBOrbyuRFZKq/17IOJlsA/w8Jtz+hfLcUWKEs0+orheo
 DYgXvA5p0T8MjDNppr1Ye9v0pN0W+40ZMVpdwP3Ti4i3WrU/sc/7DBbCLOcIXozINzXr
 7XgTuo8n5QTbaebfyAfTUc8HdM6exYP60VFOtanu8dUQg4hgTqPY5l7zqw449bQ4Sxwt
 XStcUqxZ6JmIE0n2pvv0rg72l+w7mM/3IxIoXJo4qKWUptFqh508pyAUpagm08Vatdj1
 1VkPr5CgYf6gtbPL23py+rmCw/Qdht89+8dqFLzv0yxUuXIEFeYtQIsa6G6t/wxbwSn7 MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcbs6q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LJ37119464
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35g3rft5xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BI7TMaq004219
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:22 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:29:22 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 02/15] xfs: Add xfs_attr_node_remove_cleanup
Date:   Fri, 18 Dec 2020 00:29:04 -0700
Message-Id: <20201218072917.16805-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072917.16805-1-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
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

This patch pulls a new helper function xfs_attr_node_remove_cleanup out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8b55a8d..e93d76a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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

