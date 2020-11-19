Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EC0C388F9
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 23:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D4C208FE
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 23:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CtDSiNrq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgKSXlt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Nov 2020 18:41:49 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40610 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgKSXlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Nov 2020 18:41:49 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJNYUZt050295;
        Thu, 19 Nov 2020 23:41:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=m0w9FCAZES7oZy/pA5fzdaB4LnhQB6EQNE9MsQNIAr4=;
 b=CtDSiNrqv/pWEEFE6h0D4Cck2LCS5ixEPxLtAWvGEaxImbAVW+ETfvn25El/yiHcFeaU
 S8z9Sduy958anplfzeMcRUMEd9L9oPRn1pkIWLNwPjpvG0YXCg13niTJqjBteynDI6fH
 C9kERn039dGTKs1r4wLSqWYOYQNyPnItoxD4tW7L7NeQatuWOzi4RYdTKJ69zoC40lUX
 oGOmHUhBTMtmwBGxdR+YCLXHvVaCYxoLRqU8I8kN4Yc1e101n1mG9uPV/SJbU0NiNXMM
 8dPmlWglTX9mLmoMl/2ADGskznMXmZl9qivxS4NksZuQsm6pCdGFCH7AA1tYlzJPeMWa +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rb8cwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 23:41:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJNZiOY162884;
        Thu, 19 Nov 2020 23:39:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34uspwtxj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 23:39:45 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AJNdjMJ024690;
        Thu, 19 Nov 2020 23:39:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 15:39:44 -0800
Date:   Thu, 19 Nov 2020 15:39:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: revert "xfs: fix rmap key and record comparison
 functions"
Message-ID: <20201119233943.GG9695@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190162
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This reverts commit 6ff646b2ceb0eec916101877f38da0b73e3a5b7f.

Your maintainer committed a major braino in the rmap code by adding the
attr fork, bmbt, and unwritten extent usage bits into rmap record key
comparisons.  While XFS uses the usage bits *in the rmap records* for
cross-referencing metadata in xfs_scrub and xfs_repair, it only needs
the owner and offset information to distinguish between reverse mappings
of the same physical extent into the data fork of a file at multiple
offsets.  The other bits are not important for key comparisons for index
lookups, and never have been.

Eric Sandeen reports that this causes regressions in generic/299, so
undo this patch before it does more damage.

Reported-by: Eric Sandeen <sandeen@sandeen.net>
Fixes: 6ff646b2ceb0 ("xfs: fix rmap key and record comparison functions")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap_btree.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 577a66381327..beb81c84a937 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -243,8 +243,8 @@ xfs_rmapbt_key_diff(
 	else if (y > x)
 		return -1;
 
-	x = be64_to_cpu(kp->rm_offset);
-	y = xfs_rmap_irec_offset_pack(rec);
+	x = XFS_RMAP_OFF(be64_to_cpu(kp->rm_offset));
+	y = rec->rm_offset;
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -275,8 +275,8 @@ xfs_rmapbt_diff_two_keys(
 	else if (y > x)
 		return -1;
 
-	x = be64_to_cpu(kp1->rm_offset);
-	y = be64_to_cpu(kp2->rm_offset);
+	x = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
+	y = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -390,8 +390,8 @@ xfs_rmapbt_keys_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = be64_to_cpu(k1->rmap.rm_offset);
-	b = be64_to_cpu(k2->rmap.rm_offset);
+	a = XFS_RMAP_OFF(be64_to_cpu(k1->rmap.rm_offset));
+	b = XFS_RMAP_OFF(be64_to_cpu(k2->rmap.rm_offset));
 	if (a <= b)
 		return 1;
 	return 0;
@@ -420,8 +420,8 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = be64_to_cpu(r1->rmap.rm_offset);
-	b = be64_to_cpu(r2->rmap.rm_offset);
+	a = XFS_RMAP_OFF(be64_to_cpu(r1->rmap.rm_offset));
+	b = XFS_RMAP_OFF(be64_to_cpu(r2->rmap.rm_offset));
 	if (a <= b)
 		return 1;
 	return 0;
