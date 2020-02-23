Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305EDC35669
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F378E20707
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lF/I1CJZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgBWCGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgBWCGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N22Ti4179973
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=BHXbWCEMHX8ukKpTmQAbJTj52lAvNCpXhJL2tA5euM0=;
 b=lF/I1CJZlbfKbxYWUQF4U7b24iSprJhqen+ElO3k9+Bsj/lP5VQX6lqgABlOzuAqi0K2
 QoglDBHslk9J7ZRCpdQz5jTcmJTdJpEru0jEaUVyfp32wxzd6RmH4u14k6wZNeAsyRRx
 zwIYZy8m444m0adeJHFlS4fKKDaT1a5CVnLnWlRUQoju9y7JuBPRRzJ8OTGcuREplV0U
 vvlfFjN73QXRBmkDgFkcEszRPtjG/LLoi+E6LgpzSHM2FOVP/IRtzr95rJQrucB3X+wE
 1KfO1YnKfb1KCxwZrNhlf9SLluuq1jKIsVFubXbIYrbMYcIV/yFeFVkTvx6xHPVfQcwj SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yavxr9yyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1wP2H054410
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ybe38md8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01N2650R028919
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:05 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 20/20] xfsprogs: Remove xfs_attr_rmtval_remove
Date:   Sat, 22 Feb 2020 19:05:54 -0700
Message-Id: <20200223020554.1731-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=1 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_attr_rmtval_remove is no longer used.  Clear it out now

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr_remote.c | 42 ------------------------------------------
 1 file changed, 42 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 3ed27e0..b5cb21c 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -704,48 +704,6 @@ xfs_attr_rmtval_invalidate(
 }
 
 /*
- * Remove the value associated with an attribute by deleting the
- * out-of-line buffer that it is stored on.
- */
-int
-xfs_attr_rmtval_remove(
-	struct xfs_da_args      *args)
-{
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
-	int			error = 0;
-	int			done = 0;
-
-	trace_xfs_attr_rmtval_remove(args);
-
-	error = xfs_attr_rmtval_invalidate(args);
-	if (error)
-		return error;
-	/*
-	 * Keep de-allocating extents until the remote-value region is gone.
-	 */
-	lblkno = args->rmtblkno;
-	blkcnt = args->rmtblkcnt;
-	while (!done) {
-		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
-				    XFS_BMAPI_ATTRFORK, 1, &done);
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			return error;
-	}
-	return 0;
-}
-
-/*
  * Remove the value associated with an attribute by deleting the out-of-line
  * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
  * transaction and recall the function
-- 
2.7.4

