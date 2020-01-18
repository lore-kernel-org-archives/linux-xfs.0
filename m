Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F46C32771
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20BE82469D
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g1E0z091"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgARWqQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:46:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36750 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgARWqQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:46:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcv0d093509
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=+BqodORqckjtFnmjQmpIwiyOwE7281PdWQmzyQ37vaA=;
 b=g1E0z0915SioCcu1cCpDR7nBRYcZ31eogP/dvRaSgkSgsY6t4n/inQABjtNvJ4lhDqsY
 6MYwaTrGg1sKxoWPjQRqysjOEdSGA6wPsihyYRvHnMsc18qiNX6BZW/I3Hmpiib3mFCN
 3sEl3DhD71hFfMUjBt1dDu8DZ9kimWDpADBprdxz/4GOlfsH7SPG3FjmJc0dgk4acBx9
 2HLpgBrwwGKNmAtkpFkIZTwsQj+vlqfu3804yn8QSm5z7eAnNoY3nSEoW5bZiVJpf/gK
 vUfQsfeC1DvnMNF438OYqUpJgolz9k0uRA+T2/31FvI6FSt5JxrRn2D2nN2aEm8FVVc1 ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseu244j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcqgg125789
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xkr2dannf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:14 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00IMkD6T025475
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:13 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:46:12 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 06/17] xfsprogs: Factor out trans handling in xfs_attr3_leaf_flipflags
Date:   Sat, 18 Jan 2020 15:45:47 -0700
Message-Id: <20200118224558.19382-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200118224558.19382-1-allison.henderson@oracle.com>
References: <20200118224558.19382-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since delayed operations cannot roll transactions, factor up the
transaction handling into the calling function

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c      | 14 ++++++++++++++
 libxfs/xfs_attr_leaf.c |  7 +------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a96761c..6b15d12 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -726,6 +726,13 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			return error;
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
@@ -1068,6 +1075,13 @@ restart:
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			goto out;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			goto out;
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 542315e..b4be417 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2899,10 +2899,5 @@ xfs_attr3_leaf_flipflags(
 			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-
-	return error;
+	return 0;
 }
-- 
2.7.4

