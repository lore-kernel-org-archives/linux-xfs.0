Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB35DFA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AF8F2077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EA0c8ZTn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733007AbfKGDEO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:04:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58514 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732917AbfKGDEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:04:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7346Nq042776
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=c4hxUl/nX1wEES0FOqEwv1zG9kYSqa0t5SXa4Dkd4ZA=;
 b=EA0c8ZTnVGNsOoquO9O8k5ovkTmNT88rpf1zPBb0aLYc69rt/sSaCH79FNyXuqnJ+UgA
 MCoZpXx8O03wmGHM7e3XwgvyfRCY2IbO4gB7LII9c5kaG80rjiiB/ME+dfIsUhoH+EY1
 zteVUEI7IeFsFg2N+jpngNFsxqiKMKP2rdDHnMU6gAzN34EAIgAx+CM4Bh4BkKnGmZwF
 SDkg4d4mHTRTSZQE14lRApEeVrWEKVz5WwTgVSqW/ymWMlgGAGIDf/RTxJFCCgrt9hSF
 Zo2DOb1yVfkiExZGKzJn04sDcHvM/Rj0dUkw0WX8FLZjEehTnRp0YqQ1KCqDNnQLU/Kn iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w41w0u0pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:04:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA734777064507
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:04:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w41wfsq5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:04:10 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA73426t018325
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:04:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:04:01 -0800
Subject: [PATCH 09/10] xfs: report realtime metadata corruption errors to
 the health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:04:00 -0800
Message-ID: <157309584089.46704.12768463241066568037.stgit@magnolia>
In-Reply-To: <157309578380.46704.8292405543138526332.stgit@magnolia>
References: <157309578380.46704.8292405543138526332.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter corrupt realtime metadat blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    6 ++++++
 fs/xfs/xfs_rtalloc.c         |    6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 20113c5f11a5..88a87526280e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -71,6 +72,8 @@ xfs_rtbuf_get(
 		return error;
 
 	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_real_extent(&map))) {
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 		return -EFSCORRUPTED;
 	}
 
@@ -78,6 +81,9 @@ xfs_rtbuf_get(
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

