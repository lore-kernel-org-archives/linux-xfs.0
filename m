Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980C5C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E7C72087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CxznIYx3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfKHHG3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:06:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfKHHG2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:06:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873hKu070013
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:06:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=y+vkyj6pruFWvmhwGVAxuxmvRm1Z5v8pWrgN/9gnBGw=;
 b=CxznIYx3dsDgyTjYoovUIIOEVpZBILF1tvMAQiaCU5HprGexl+J+z99goHvGntL74YJs
 mOIE6DfuWLCQKT+SL+Hq/p509cis89THOwor2rCshjgC0kW+aKa7bbtsS+IK2cN3khMd
 QpGkXq5Hjv1ob5rwtkrUkcJ98/64ysNPrR7us/xdyWAkdXL0y/0V27kaeH5ZWNI+9gHd
 xGsRWCHa6WSnnhpIW8knbdhCBfsLJSrNpmospO9Z02PFjzqxIrQ6MjDyhJd0uoYBx4hw
 DqxKilG/NKmZIPvZg0d9vqTYVtV5Lrxqy3d5c6jO0YpFvvMC1zN2otEmONzCYZPyp5ef cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w1bdas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:06:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873oR6081537
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:06:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w50m4c83f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:06:26 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA876PrN014588
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:06:25 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:06:25 -0800
Subject: [PATCH 09/10] xfs: report realtime metadata corruption errors to
 the health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 07 Nov 2019 23:06:23 -0800
Message-ID: <157319678364.834783.4652955939341150769.stgit@magnolia>
In-Reply-To: <157319672612.834783.1318671695966912922.stgit@magnolia>
References: <157319672612.834783.1318671695966912922.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080069
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

