Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FB6C433EA
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 120E422B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VYiM4Gnn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgGUAQV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:16:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40482 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbgGUAQS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:16:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L03Sqt181798
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=HP2iHYhwTpF5qDWrHBGIddPGoqXUJFo/yfd2dDtLtfM=;
 b=VYiM4GnnYsp7njP/zJvnBNs8Lbap0YikbERIW6IUFnC75KVKKgP6Rxu533YYLmb5Fp8X
 5yvorPE4hUeRpK95MTYfXhaaUghPbCJLYDCQyOAs/Vr7iV+mFx4fMFWQ1KWVZyb/noGd
 JbXJEVog+LCmPhwWf1tI9wK7GR+Vgf2nbv9LKOwEI2drem92vtoYwxtF6FM0ywz1xdbv
 99F67RilmYfIzfWYyJdl9ef0YTavmxr5hFl+0nvbbE4WSTS7krwVplgA5hrumu/aYy0+
 fjIpR+RbFGOvKRzMwE/p6iahywA6lr5uhMOz0K54WBmCSvgdsLHABpASM3j7LltC07ZY OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32bs1m9x8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L04MrV097230
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32dnfngf07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06L0GFmF001232
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:15 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:15 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 11/25] xfs: Pull up xfs_attr_rmtval_invalidate
Date:   Mon, 20 Jul 2020 17:15:52 -0700
Message-Id: <20200721001606.10781-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721001606.10781-1-allison.henderson@oracle.com>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch pulls xfs_attr_rmtval_invalidate out of
xfs_attr_rmtval_remove and into the calling functions.  Eventually
__xfs_attr_rmtval_remove will replace xfs_attr_rmtval_remove when we
introduce delayed attributes.  These functions are exepcted to return
-EAGAIN when they need a new transaction.  Because the invalidate does
not need a new transaction, we need to separate it from the rest of the
function that does.  This will enable __xfs_attr_rmtval_remove to
smoothly replace xfs_attr_rmtval_remove later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 12 ++++++++++++
 fs/xfs/libxfs/xfs_attr_remote.c |  3 ---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index df550b4..9094031 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -670,6 +670,10 @@ xfs_attr_leaf_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				return error;
+
 			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
@@ -1028,6 +1032,10 @@ xfs_attr_node_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				return error;
+
 			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
@@ -1153,6 +1161,10 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
 		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			goto out;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 9b4c173..85dca51 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -685,9 +685,6 @@ xfs_attr_rmtval_remove(
 
 	trace_xfs_attr_rmtval_remove(args);
 
-	error = xfs_attr_rmtval_invalidate(args);
-	if (error)
-		return error;
 	/*
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
-- 
2.7.4

