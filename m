Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E34C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33FEF2464B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rlnXLplS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfLLEPd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:15:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43062 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727571AbfLLEPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:15:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4ENpt128888
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=Mqf9CjYcPDxGjyXsh13PFrCaVQnD3sJzuX8WTGOiAz8=;
 b=rlnXLplSgz/e+MpSfHNcaGt98tza9S6rEzB/ScZ+RbqQ2kRPDdbvGke8TI8TjnoHbC/Z
 l7kXCUuigTxZdTetopSsIulDlSGBZWMwCzvn3D27U172lEVzMv2ncN60P9QQTcKjbaou
 o18/nMXGpNWjgK2P+HYAqt1iB1B8KkArzJPShFfWORsOL3XfNESURz5w7mjtBjQKzLg7
 xbInXGEH9qnXtstHt9s0cYxBLKbPMHor+oBICO90RoJZe9T9ry/HHTiv6tYDYRmWcV/9
 s9manysSqBVANY57fw8hkONK9fc2AAKk32O6Dx1u3CCz6gXxkBdCwnZoaIMOCZo9lN6I lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wr4qrre0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4E6JR128085
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wu5cs3dcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:30 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBC4FT7T024948
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:30 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:15:29 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 12/14] xfs: Check for -ENOATTR or -EEXIST
Date:   Wed, 11 Dec 2019 21:15:11 -0700
Message-Id: <20191212041513.13855-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212041513.13855-1-allison.henderson@oracle.com>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Delayed operations cannot return error codes.  So we must check for
these conditions first before starting set or remove operations

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a3dd620..b5a5c84 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -446,6 +446,18 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
+
+	error = xfs_has_attr(&args);
+	if (error == -EEXIST) {
+		if (name->type & ATTR_CREATE)
+			goto out_trans_cancel;
+		else
+			name->type |= ATTR_REPLACE;
+	}
+
+	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
+		goto out_trans_cancel;
+
 	error = xfs_attr_set_args(&args);
 	if (error)
 		goto out_trans_cancel;
@@ -534,6 +546,10 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
+	error = xfs_has_attr(&args);
+	if (error != -EEXIST)
+		goto out;
+
 	error = xfs_attr_remove_args(&args);
 	if (error)
 		goto out;
-- 
2.7.4

