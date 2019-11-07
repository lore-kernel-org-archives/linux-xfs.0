Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AE0FC6196
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EA0C21D82
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F5oHQJB1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfKGBb5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:31:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40240 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732910AbfKGBb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:31:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71TqSL180843
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=aya/9O10agciAoobj1pvOJk0f/2OASS4Rb7JduTjqOc=;
 b=F5oHQJB1scD4IsxHHvLmIaso2Ls0ONUxJyv3fTLPu6tY8KEKQMxG/4Q9aXSrxXNgTugz
 5loppyrFgy+YD80LtAJs+Wm1278OcZSnznCBwrJLnkDlPuFKtym4asyFmi0TDFC4iQN4
 VUCC5myvnS2+0ebZ6jgQZyHHn5FaCHLxbzD3B0AWTZFYRW012WFl18EkxIVEPoFRerBS
 8futsXrItZPD+v1ynFkrtB4+OIVtnHo+4IyNi4HlnxRU+McnRAa+WpbCnamLb0SylBQW
 LJSprdsh/XOwLgkuXnkSR9BGQF5iVPLv/RLd0j9mpqvOHhuTLyjMOwZtuEXLrdmg/JGX EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w12q48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:31:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SmT3127075
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w41wfvbwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:54 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71TrWX011837
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:54 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:29:53 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 09/17] xfsprogs: Factor up commit from xfs_attr_try_sf_addname
Date:   Wed,  6 Nov 2019 18:29:37 -0700
Message-Id: <20191107012945.22941-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012945.22941-1-allison.henderson@oracle.com>
References: <20191107012945.22941-1-allison.henderson@oracle.com>
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

New delayed attribute routines cannot handle transactions,
so factor this up to the calling function.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2d71e9c..ce75023 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -193,8 +193,7 @@ xfs_attr_try_sf_addname(
 	struct xfs_da_args	*args)
 {
 
-	struct xfs_mount	*mp = dp->i_mount;
-	int			error, error2;
+	int			error;
 
 	error = xfs_attr_shortform_addname(args);
 	if (error == -ENOSPC)
@@ -207,12 +206,7 @@ xfs_attr_try_sf_addname(
 	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(args->trans);
-
-	error2 = xfs_trans_commit(args->trans);
-	args->trans = NULL;
-	return error ? error : error2;
+	return error;
 }
 
 /*
@@ -224,7 +218,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error;
+	int			error, error2 = 0;;
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -244,8 +238,15 @@ xfs_attr_set_args(
 		 * Try to add the attr to the attribute list in the inode.
 		 */
 		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC)
-			return error;
+		if (error != -ENOSPC) {
+			if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
+				xfs_trans_set_sync(args->trans);
+
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
+
 
 		/*
 		 * It won't fit in the shortform, transform to a leaf block.
-- 
2.7.4

