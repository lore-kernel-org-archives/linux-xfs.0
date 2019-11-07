Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BEBFC6196
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A471C217D7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qL8YdhY4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfKGB25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:28:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfKGB25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:28:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SsS0180102
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=C1DwzdyIGaOPcyDE840rB3lDqY9YSaetsMYt3XJo0+k=;
 b=qL8YdhY4tVfqXGyxXOETwb3JsIe5LyLMO37UPFFF1XhzDrWBPSsmZoXSnFIH+HpqBnbC
 iTlGwq4hHifGrkKuDF8nFsoF/Lze+INJM0yaJw2yuPZWgyp7WZTemcRvAZ7kvYgNmrQl
 ZJZqJsMZdn/elbdUpBANA64j9OSRJxUjzHaSWcckUMPn/MHe5wLOiA7HAE1swmXmi5/0
 wuvwFHLQdvujddaHSm71Mab3HBew5xu9Q1rAqOiuQEr2bqRqdPITyCVGMhh6zMLkZP3W
 3lv6uI+54nU6bK/ESG92VxdWJfyi+HxOMzwFlDgtLpZ5GYdvXDKQPyMgEFHseSSM/00T yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w41w12pu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SqgE174232
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w41w8euna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA71SnCM031932
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:49 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:28:48 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 15/17] xfs: Check for -ENOATTR or -EEXIST
Date:   Wed,  6 Nov 2019 18:27:59 -0700
Message-Id: <20191107012801.22863-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012801.22863-1-allison.henderson@oracle.com>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Delayed operations cannot return error codes.  So we must check for
these conditions first before starting set or remove operations

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5dcb19f..626d4a98 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -458,6 +458,27 @@ xfs_attr_set(
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
+	if (name->type & ATTR_REPLACE) {
+		name->type &= ~ATTR_REPLACE;
+		error = xfs_attr_remove_args(&args);
+		if (error)
+			goto out_trans_cancel;
+
+		name->type |= ATTR_CREATE;
+	}
+
 	error = xfs_attr_set_args(&args);
 	if (error)
 		goto out_trans_cancel;
@@ -543,6 +564,10 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
+	error = xfs_has_attr(&args);
+	if (error == -ENOATTR)
+		goto out;
+
 	error = xfs_attr_remove_args(&args);
 	if (error)
 		goto out;
-- 
2.7.4

