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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BADBC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ED772087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S842yLTf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgH0A3Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgH0A3Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0T1MC022065
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=OLteAmIH0pa7vtnc7iU/vhqCxyprbIox1L6/aLKxvX8=;
 b=S842yLTfkIu5ELJPXBKJ3WYbZBRP6rK/PtoGzJAq4RzhTCkv9btjPvE+RTZcQr/c4S4u
 4eT9j0dKU5v1mY7HGeVCFTXGEM6SnVk2mSjS/qhzjpZI6IVU9ytfjGrlVY1DjlmpBWc0
 RgbNG5YcAD5BUPiNyWhC1+BkDhrrwZ60PAP6QQTNIYNUvjE6Sn7NSC9LiLAwu3YPFK/s
 L6HbUzHmvUilFnr3e3ST31gniJQ0SUow0ObQO930QbYZFyv4Y2nXOD8+Z3ijiSPqLfGA
 7nJfJ8X5Mz8yDdpF4q7PIt6TORkYPIUx2O4bCpsQkaI+O6H/KbPS9KNm7T0K7D2ZW1Bv Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 335gw859dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0AqWA025878
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 333r9mswts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:14 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07R0TCp7019244
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:13 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:12 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 11/32] xfsprogs: Pull up xfs_attr_rmtval_invalidate
Date:   Wed, 26 Aug 2020 17:28:35 -0700
Message-Id: <20200827002856.1131-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270000
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
index b472c95..310b925 100644
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

