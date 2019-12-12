Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC67C2D0CB
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC84021655
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FNlbSYfz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfLLESP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:18:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47944 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfLLESN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:18:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EKH3130916
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=e2r8wamUZxVGdr5Tugx3F95mwGs8FNzf1L2a5EYnJMs=;
 b=FNlbSYfz6u9hKQECd6FANPaDEFUoLPzjcXeKmWk3WnYwhAwv8b/ZHuFwBanG4ncvGWhE
 Mxx7xJc3CpRzFNQ7ajOgw3sU7COuCuoLs+5jHIuMHn6HVqqDI410VcSwYO09DG+gSDM0
 +063ts6toe88RfRD6510FOuVGQYZwAxwTUTI8F9P0MLRX7EUqRXwTotMhsTrb1F+STTe
 yv+TfvCWBRgrbWie8nDwV/DDyCvjdpp+SefSWOXkTE7H5tSE8DbNmJoEJEaNtlMp63d7
 g5CyEHiouvWOcuNQxxrcBaOp/DxTcBlm/svVUg56nvEvOG+sIEVMCVbwU73q0biJ4dHN gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wr41qggxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EKEm073512
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wu3k0b8gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBC4IA2r016301
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:10 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:18:10 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 12/14] xfsprogs: Check for -ENOATTR or -EEXIST
Date:   Wed, 11 Dec 2019 21:18:01 -0700
Message-Id: <20191212041803.14018-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212041803.14018-1-allison.henderson@oracle.com>
References: <20191212041803.14018-1-allison.henderson@oracle.com>
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
 libxfs/xfs_attr.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 289fee2..357824c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -445,6 +445,18 @@ xfs_attr_set(
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
@@ -533,6 +545,10 @@ xfs_attr_remove(
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

