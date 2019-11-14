Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E99C33C9C
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B19D5207DD
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lYebvHhb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfKNSUP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:20:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33768 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbfKNSUP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 13:20:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEIK09M092809
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=y+vkyj6pruFWvmhwGVAxuxmvRm1Z5v8pWrgN/9gnBGw=;
 b=lYebvHhbdSNchxQp2F9K3SNHIs1RGxMJbZs4wt9RFBb1AS0IM/3gyQ1kOO3qYOjGdYhm
 wtAYOMnjX7kwZaCk3xDDbJ5E/SKOo2M0FDwRkemmsaU0jbr2SfgvdObtsalGQ6IP2il9
 MrfoBDD1pI7vAw4naWxvbxNQ72zAqvU+Xy+HNG4GJpA/lLHoSjLtF7VKDAcyOC9Wx6wc
 uTGAWtrQ5wj41dak5Q8GzmKI0M4t4EmzxneCLWR9DOUihyz/hmbKbldd1HktVzQ9hPLc
 gDgYq3ipOrQ6BjiE+SSVHxan3slpIRkfl5Jbn9Ff1S9cOkm7KcnyLSl0vIFnRaieyERL XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w5ndqn0xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEI41v9106882
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w8g19tnx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAEIKCO1023455
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 10:20:11 -0800
Subject: [PATCH 9/9] xfs: report realtime metadata corruption errors to the
 health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Nov 2019 10:20:11 -0800
Message-ID: <157375561114.3692735.2022049508424797963.stgit@magnolia>
In-Reply-To: <157375555426.3692735.1357467392517392169.stgit@magnolia>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter corrupt realtime metadat blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 ++++++++-
 fs/xfs/xfs_rtalloc.c         |    6 +++++-
 2 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f42c74cb8be5..88a87526280e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -70,13 +71,19 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_real_extent(&map)))
+	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_real_extent(&map))) {
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 		return -EFSCORRUPTED;
+	}
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d42b5a2047e0..4ec0fead3177 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -18,7 +18,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
-
+#include "xfs_health.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1235,11 +1235,15 @@ xfs_rtmount_inodes(
 
 	sbp = &mp->m_sb;
 	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
 
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
 	if (error) {
 		xfs_irele(mp->m_rbmip);
 		return error;

