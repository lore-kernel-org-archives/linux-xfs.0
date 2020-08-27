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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC19C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E2132087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qq/ZTIAr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgH0A30 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37824 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgH0A3X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0TIxJ165383
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=hoghDP00s+RHLEHpLT6vn/TeCPRRPA/K/+orz34PGVo=;
 b=qq/ZTIArYUqs95B4N2FPVS45RbfEs+c8oFCiQ4e+Sp6cLVrr14+FJJfMo39cWjOe/3PQ
 TN+Qy8wAJbpj/aEQXzyAvIXaKoZYNh3J2BO0Mz9V3RUeiCz6xu5Qwnq5U53l4cqJiMMM
 7iQiDIe2bCLhbGec/iTYspoBBbrzaK/aGwnmC0gXuijDXwFwPqH/Z0iz/x/Sz3wVZVkt
 E1VxTOqDv7kwV9VM+XAJ7wbgIZdocA8lGhugTG05hY73FH7ChJuAwclDR7nZdPtMNo3F
 D/kaLNf+msYFH+uy4cpWZZl6nO0KlFZAxitkxaM170JboIbcdXPW388YGxrKsuBuz7tB Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 333w6u1ywk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0ArGF025945
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 333r9mswwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0TLcP016982
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:21 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:21 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 29/32] xfsprogs: Enable delayed attributes
Date:   Wed, 26 Aug 2020 17:28:53 -0700
Message-Id: <20200827002856.1131-30-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
We only do this for new filesystems that have the feature bit enabled
because we cant add new log entries to older filesystems

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ed25894..6afcfe3 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -517,6 +517,7 @@ xfs_attr_set(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
@@ -602,9 +603,17 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		if (xfs_sb_version_hasdelattr(sbp))
+			error = xfs_attr_set_deferred(dp, args->trans,
+					      args->name, args->namelen,
+					      args->attr_filter, args->value,
+					      args->valuelen);
+		else
+			error = xfs_attr_set_args(args);
+
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -613,7 +622,13 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		if (xfs_sb_version_hasdelattr(sbp))
+			error = xfs_attr_remove_deferred(dp, args->trans,
+							 args->name,
+							 args->namelen,
+							 args->attr_filter);
+		else
+			error = xfs_attr_remove_args(args);
 		if (error)
 			goto out_trans_cancel;
 	}
-- 
2.7.4

