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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A593FC433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B3521744
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V5xU6Inv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgGREd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:33:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59532 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgGREdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4WbPQ051800
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=T6v0WoW4pb/NrEGJMvsiV0JzIbtyoXt/LQA1lEGkvfY=;
 b=V5xU6InvBLVFl4iq15gBzUYOd406xMtfj+8MhxfuTRmsT8hKdpewlzvBnHy1fg6Mdl5q
 kNh/3tmmOEOc+LeSd+IVhgsYf4h1SdrnOT1NNQwj8Is5bfTpnJLqyiR5sjfaWk/NqcU3
 gMsuPEwMM7Q6F2snmDDxo3mAcvXR8xElCOM3GBKZipyHtRYPnh2wu/LFblm2usK+mPRb
 OelWIYLN4l9Oii+Sswk4fQmkiq1NFKgSZdfEqobMI0Y+ugUJsUogtsyJkQmizI9t0XVM
 IqzM8HAo/pKLmWGaBuu/NQs2Q6jtyerWQE0qT7hEoArLFw5Gh4JPad1T9FEKnjyZ5Xn2 fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 32bpkarbj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XlxC169299
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32brw1w79f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06I4XrtE008266
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:53 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:53 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 08/26] xfsprogs: Pull up trans roll from xfs_attr3_leaf_setflag
Date:   Fri, 17 Jul 2020 21:33:24 -0700
Message-Id: <20200718043342.6432-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007180030
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

New delayed allocation routines cannot be handling transactions so
pull them up into the calling functions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c      | 5 +++++
 libxfs/xfs_attr_leaf.c | 5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c1d1bfa..d9f7ceb 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1132,6 +1132,11 @@ xfs_attr_node_removename(
 		error = xfs_attr3_leaf_setflag(args);
 		if (error)
 			goto out;
+
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			goto out;
+
 		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			goto out;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 9ea85d1..0197d02 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2832,10 +2832,7 @@ xfs_attr3_leaf_setflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	return 0;
 }
 
 /*
-- 
2.7.4

