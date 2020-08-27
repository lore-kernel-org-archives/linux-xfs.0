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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC4CC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 926A820738
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L4xlZ2jO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgH0Afb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:35:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58014 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbgH0Af3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:35:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0U5wC022962
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=N4+jFqKMn5wLLattSrbEHYJUFcJ6plmix+xU0GS05Cc=;
 b=L4xlZ2jO7094DWcsbfhqYdtaN0Jtn3vE0MeP0tbEsvg4hMvP2gNlfF5uBDdMNHqfEFyb
 lV7UJPC1NS2kjmac6YeAPi4UVMscsJ1h0PD9chAxmnvBJk+tlZfYyxFV5+MKbk4w95mn
 YI7hXsM51hK4aqp9EcTus8XzLGjH4MuctHoPljjldzJ2IZRhFNx5GWo8VjH+5x5npN0a
 a/Y4QGPeVWfrc9dclINI9VScvpgNFGQx6AoaoeCLUdVHmkZiV1YMLIwARZDIUYkAkLZ2
 4wYWHIwix8DX7ql75xIMiUGD2QzsP+itF3purWQ5XllGbnbZpqzq3EggA74lea9bHuRK Ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 335gw859ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0UhiM169722
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 333ru0t855-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:28 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07R0ZRZt021160
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:27 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:35:26 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 7/8] xfs: Enable delayed attributes
Date:   Wed, 26 Aug 2020 17:35:17 -0700
Message-Id: <20200827003518.1231-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827003518.1231-1-allison.henderson@oracle.com>
References: <20200827003518.1231-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
We only do this for new filesystems that have the feature bit enabled
because we cant add new log entries to older filesystems

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7b79868..e5fbcbc 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -518,6 +518,7 @@ xfs_attr_set(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
@@ -603,9 +604,17 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		if (xfs_sb_version_hasdelattr(sbp))
+			error = xfs_attr_set_deferred(dp, args->trans,
+					      args->name, args->namelen,
+					      args->attr_filter, args->value,
+					      args->valuelen);
+		else
+			error = xfs_attr_set_args(args);
+
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -614,7 +623,13 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		if (xfs_sb_version_hasdelattr(sbp))
+			error = xfs_attr_remove_deferred(dp, args->trans,
+							 args->name,
+							 args->namelen,
+							 args->attr_filter);
+		else
+			error = xfs_attr_remove_args(args);
 		if (error)
 			goto out_trans_cancel;
 	}
-- 
2.7.4

