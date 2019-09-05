Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB76C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E3982070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hYsxBjVb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391156AbfIEWTP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39124 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391120AbfIEWTL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8oF084610
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=yCFY63zqgsR96OHSAmr9R/9E+m/FSVJ/cXY9xkienKs=;
 b=hYsxBjVbPEaH5AsJhawQhO/SuGQi107SbZlDhr7/afdyUOVZYPmKNpWS3/vqntEjt9oF
 G2r4NSH0b6+uxmaBns+tUFfqiEgnyVxk+QygA59Ak/mkndkXCVsbNMJ0zAiIzB8Kbl+H
 qQTx8+rIvXf27vVxuTUqeKIlr7utdX1QipnHEGRAmyMAyRo474rxWxAf2aYHuJIMEb/m
 6i0Zzt6+ckn5Lf+MXVZF7+27OPlxm4cSttct752vJbzr2muP1zNRfA4gO0FgKU+hOuhX
 k2XmQPNp1XQOZn0d5S8+rL8qv2DTNmLoTW+ZpkAOoOWzQKnmRS2ysGKA25jWpnWe5gMi lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uuaqxr2ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ4KW076515
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2utvr4a10b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:09 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85MJ3CF032561
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:03 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:03 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 12/21] xfsprogs: Factor up trans roll in xfs_attr3_leaf_clearflag
Date:   Thu,  5 Sep 2019 15:18:46 -0700
Message-Id: <20190905221855.17555-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
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

New delayed allocation routines cannot be handling
transactions so factor them up into the calling functions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 14 ++++++++++++++
 libxfs/xfs_attr_leaf.c |  5 +----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a5b630c..3f354c8 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -749,6 +749,12 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
 		error = xfs_attr3_leaf_clearflag(args);
+
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	}
 	return error;
 }
@@ -1108,6 +1114,14 @@ restart:
 		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
+
+		 /*
+		  * Commit the flag value change and start the next trans in
+		  * series.
+		  */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			goto out;
 	}
 	retval = error = 0;
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index b540ba9..338b0bd 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2724,10 +2724,7 @@ xfs_attr3_leaf_clearflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	return error;
 }
 
 /*
-- 
2.7.4

