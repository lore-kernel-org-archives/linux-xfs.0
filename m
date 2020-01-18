Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E68C32771
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F554246A5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UtLyE0I8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgARWws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:52:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41780 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgARWwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:52:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMc9qm093182
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:52:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ujOB1lK0CXEft99oJd7l1/qssUWfIzzncSZF0cGoIYA=;
 b=UtLyE0I8JpBO7EXltY0knEd9ElKEFbA2lymVaJB0PBU1aS8zu3faff+hx2j+8hcA2jHs
 hsEQVGH666Fs3zG77OSA3QBD+rODZD/CMpzImskH8Ya20pFv3SxUD6aep1XVMS9ZIRdT
 e3j0HUc+ilkdCVbPJhkSIj+51dSPYCm3YgT7czX7IaWffLA9pBy/8ZJDIlf1io4i95yQ
 og7DRwIuhGP0vVD7qdjKgaF5uYH8wT2Mg3ZSBIg4esvj0rGwpyBy3VYu63fUezxPP7/g
 KyRQdy0Dr/WrkeKfsgv5NEag7iM/LpE6i0wE/vYqa9yktstxtqO6teNqhL4b3cWDBb5v Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xkseu24mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:52:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcuuO070494
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xkq5p96dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:46 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00IMojTj028561
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:45 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:50:45 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 05/16] xfs: Factor out trans handling in xfs_attr3_leaf_flipflags
Date:   Sat, 18 Jan 2020 15:50:24 -0700
Message-Id: <20200118225035.19503-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200118225035.19503-1-allison.henderson@oracle.com>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
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
 fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c |  7 +------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a2507b9..b0ec25b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -727,6 +727,13 @@ xfs_attr_leaf_addname(
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
@@ -1069,6 +1076,13 @@ xfs_attr_node_addname(
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
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 9d6b68c..d691509 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2973,10 +2973,5 @@ xfs_attr3_leaf_flipflags(
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

