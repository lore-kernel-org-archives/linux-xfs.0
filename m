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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50E1C433E4
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F9A2087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C05E0MJ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgH0A3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54098 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgH0A3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0Dw0v045222
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=FoC1IZQUFho7fKcdfZKEwfxWABpMQQd9Gd3dqzvH82s=;
 b=C05E0MJ4jCTG5z+sRwzO2GUCc/VFA/nUyUTZ2C7IbFZ9dh9jy5fOhKMCICwG4zmOxjG0
 FjHcKK+K/2kYyJab0XxG4L0IKv8/3bMyq94R14DIAupwQZ4Evt76S8F7UqKdAoaIcGWn
 mOnCjWDEeljowZhO41sn00mbb3bnWBUvZstJDFIGvqzWuX5qUWqsNmQ745uOH2I+kDdh
 jp/7aX/a579Y3SgubgVVMgDTwldYBasxOiut+7VA/fo3ndKYiW3V7PqdUr1TAAQTY2Ou
 zVna+I3PIaZc0k41ui6SzRs9uSnGkAbCy4MlL1SMracub9mcPTHxmTzA8ExjMjDXdRHK Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbs3dx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0AgVX127541
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 333ru0t3b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:12 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0TCRd024796
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:12 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:11 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 09/32] xfsprogs: Pull up trans roll in xfs_attr3_leaf_clearflag
Date:   Wed, 26 Aug 2020 17:28:33 -0700
Message-Id: <20200827002856.1131-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

New delayed allocation routines cannot be handling transactions so
pull them out into the calling functions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c      | 16 ++++++++++++++++
 libxfs/xfs_attr_leaf.c |  5 +----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5cdaac1..b472c95 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -709,6 +709,14 @@ xfs_attr_leaf_addname(
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
 		error = xfs_attr3_leaf_clearflag(args);
+		if (error)
+			return error;
+
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	}
 	return error;
 }
@@ -1073,6 +1081,14 @@ restart:
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
index d34ead2..4fd50ed 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2776,10 +2776,7 @@ xfs_attr3_leaf_clearflag(
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

