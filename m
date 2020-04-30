Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525C3C4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30A6020774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:50:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lbj7cfmt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgD3Wui (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:50:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbgD3Wuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:50:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMmvLI132896
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=rNl3yEu5UKJvYoMLQwE2PweEQE/WH7Y9aCC5aK7j+e4=;
 b=lbj7cfmtGvCHS2OzRI65TILTEmeDV8qiFKnGrYr3YZYMtDCaHtkeWmXRBAs7ab9orhM3
 k/9EyK4VvTnvJ42qXVD4DBMmngsjcGlf97Z9SRI5Mjs2YlRY4+mj7xjaOUh+mUbrSF8r
 07bc7GGcIMHUirB9VHVDIS/k6xloYq2hI2dTP9JODei/sVsdqukGxQ0A2gUZPOGqMKuk
 AXHcGR+lbnbuCX/ZG0iJXVf+HFflS8n1xFlglyy8v0E+8qQ9C4DIoiqAOb6O6ndIct3L
 RbJc4/Clil0fXxVkSLDc3iRraoD9LRMiDZXRhZKoYE6qN8RcxpfVXYvMf9iPSu4kGZzc Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30r7f3g2fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhR5v181393
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30r7fesasc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:35 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMoZxC014740
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:35 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:50:34 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 11/24] xfs: Pull up xfs_attr_rmtval_invalidate
Date:   Thu, 30 Apr 2020 15:50:03 -0700
Message-Id: <20200430225016.4287-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430225016.4287-1-allison.henderson@oracle.com>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=871 phishscore=0 suspectscore=1 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=913 impostorscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
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
---
 fs/xfs/libxfs/xfs_attr.c        | 12 ++++++++++++
 fs/xfs/libxfs/xfs_attr_remote.c |  3 ---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0fc6436..4fdfab9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -669,6 +669,10 @@ xfs_attr_leaf_addname(
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
@@ -1027,6 +1031,10 @@ xfs_attr_node_addname(
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
@@ -1152,6 +1160,10 @@ xfs_attr_node_removename(
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
index 02d1a44..f770159 100644
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

