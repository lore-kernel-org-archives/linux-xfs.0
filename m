Return-Path: <SRS0=IYU2=A5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1935C433EB
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A298421741
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QuVHYu5t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgGREd6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:33:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59290 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgGREd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4SXTr055696
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=OPp3RBxrrzGf2jdzc30YG/U+R2IJ1/OkeUxnTjQ8ovQ=;
 b=QuVHYu5tJ2Z3BmaFcYTrusQ1DLIa5mJC1YOYXhNbu+/d3v1wiDF9bhZ/MGYSJ9M6Tcb+
 fXjD9pLxjntV1Ks1PVhNv2ItHayA/gl+hSTKQKRApoqSRVWCwQFwnThIrGlA1+sNS9jC
 QYrkkRLpm/OIDDAIMXuiSWpK/OumraSOnuPtkrJx/ueUuN//duWo/Vgk3PbqkLe/dqSS
 nfby8eAP8YQout8HkGwjJTcu1GpN62Xm3CV+Xznme0GaRZQ2FVyKy4o35tqXQfU7fV1Q
 fFyGKovWaW9m2sbca/odJjpAOddVrpgCjzq2aLdQscV+wNkt6rggnL4vE9g0xnRFggza cA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgr05dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4Wo0V177127
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32bqan5g74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06I4XsJ2003178
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:54 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 12/26] xfsprogs: Pull up xfs_attr_rmtval_invalidate
Date:   Fri, 17 Jul 2020 21:33:28 -0700
Message-Id: <20200718043342.6432-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=1
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
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
 libxfs/xfs_attr.c        | 12 ++++++++++++
 libxfs/xfs_attr_remote.c |  3 ---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 07ef88e..5580d61 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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
@@ -1028,6 +1032,10 @@ restart:
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
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 52e5574..07b7193 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -684,9 +684,6 @@ xfs_attr_rmtval_remove(
 
 	trace_xfs_attr_rmtval_remove(args);
 
-	error = xfs_attr_rmtval_invalidate(args);
-	if (error)
-		return error;
 	/*
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
-- 
2.7.4

