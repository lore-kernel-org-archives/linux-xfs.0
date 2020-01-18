Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD39C33CBA
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 408B9246AC
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S67olbr6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgARWus (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:50:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37746 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgARWus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:50:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcxb3056532
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=PVBOBiG8W6QMYJFkti/pll9zT19v+ZH9cB4iPokyK8Y=;
 b=S67olbr6y88hG+2SCRJletsNhmJQ3dy1vS0FC+sbmdcFZqeicpor07fhmgKdK3lmJ7qK
 veXNm2eHHNDlToJBV9WcVCFUkh7L8DyCkD/ZALpGr5JvcEjqvL4/f5INu5HkWpKM4uuN
 gL1atlOP7a7osSj7KkRisvQFg7pVLviPqi8CgpmCEJZzJj6xZRj09RwyNciJJsF2Ebrj
 83C8Q6IQAfHN4YJ1G5umkjAae7mrcLvPuf6CzyI3qeQWcnZWIMEgysbVRU7wH9iKEX03
 +7/KGRu2zqay+TlNrSuBu1L1favQ27oij/KLQYt6OZNQAfXREqm+dYV6ycvj6GYGI3mf FA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksypt058-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcq7o125821
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xkr2datsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:46 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00IMokd0026156
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:46 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:50:45 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 08/16] xfs: Factor out trans roll from xfs_attr3_leaf_setflag
Date:   Sat, 18 Jan 2020 15:50:27 -0700
Message-Id: <20200118225035.19503-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200118225035.19503-1-allison.henderson@oracle.com>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=940
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

New delayed allocation routines cannot be handling transactions so
factor them up into the calling functions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 5 +++++
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c15361a..8ddea8d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1221,6 +1221,11 @@ xfs_attr_node_removename(
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
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d691509..67339f0 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2855,10 +2855,7 @@ xfs_attr3_leaf_setflag(
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

