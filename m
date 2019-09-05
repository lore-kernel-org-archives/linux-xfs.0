Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0751C0030B
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2308B20825
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TfdSK76N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391135AbfIEWTK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33162 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391120AbfIEWTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ7bA078093
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=SxZoZ+Um1+fEIDu1FefnRlC0gz4cDKlPGBaqgrhh0oI=;
 b=TfdSK76NYmItLBH/52WiwroTZpcK8MY+TselLFaPcVJ/CU2KZtRHTFAhLVOGz83JKwEw
 jcyaMVreDQ3gHW2GjsTzAB7ZMvPwYqZJAhzrs5MZxnN+dHVbVvbtQd8lEB+V48v6Yj1f
 DEycuuOnATy1iYEtKPtomYpRjXrPFuTJ0S2URng11LJU67bG7c1MRXgYQE7u1k3jvHe4
 b3gS3xMUZB6eN+13yrcbRxrvkDcTbfO3q1ni0d0gSAQEK36ENxXbeEjeO4IXxLnhzVlm
 IUJdaxWQFSSnBNGtSEV7istf6mM3LVoaij6kC+YuTr31IOUR7WP+FlSjKE/gkT56wqOx cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uuaqj02mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIPrQ101777
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b946sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:04 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MInul008743
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:49 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:49 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 18/19] xfs: Enable delayed attributes
Date:   Thu,  5 Sep 2019 15:18:36 -0700
Message-Id: <20190905221837.17388-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221837.17388-1-allison.henderson@oracle.com>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Finally enable delayed attributes in xfs_attr_set and
xfs_attr_remove.  We only do this for new filesystems that have
the feature bit enabled because we cant add new log entries to
older filesystems

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f502396..1040479 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -532,6 +532,7 @@ xfs_attr_set(
 	int			valuelen)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (name->type & ATTR_ROOT) != 0;
@@ -590,7 +591,34 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args);
+	if (xfs_sb_version_hasdelattr(sbp)) {
+		error = xfs_has_attr(&args);
+
+		if (error == -EEXIST) {
+			if (name->type & ATTR_CREATE)
+				goto out_trans_cancel;
+			else
+				name->type |= ATTR_REPLACE;
+		}
+
+		if (error == -ENOATTR && (name->type & ATTR_REPLACE))
+			goto out_trans_cancel;
+
+		if (name->type & ATTR_REPLACE) {
+			name->type &= ~ATTR_REPLACE;
+			error = xfs_attr_remove_deferred(dp, args.trans, name);
+			if (error)
+				goto out_trans_cancel;
+
+			name->type |= ATTR_CREATE;
+		}
+
+		error = xfs_attr_set_deferred(dp, args.trans, name, value,
+					      valuelen);
+	} else {
+		error = xfs_attr_set_args(&args);
+	}
+
 	if (error)
 		goto out_trans_cancel;
 	if (!args.trans) {
@@ -697,6 +725,7 @@ xfs_attr_remove(
 	struct xfs_name		*name)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	int			error;
 
@@ -738,7 +767,14 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	error = xfs_attr_remove_args(&args);
+	error = xfs_has_attr(&args);
+	if (error == -ENOATTR)
+		goto out;
+
+	if (xfs_sb_version_hasdelattr(sbp))
+		error = xfs_attr_remove_deferred(dp, args.trans, name);
+	else
+		error = xfs_attr_remove_args(&args);
 	if (error)
 		goto out;
 
-- 
2.7.4

