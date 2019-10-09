Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F2BECE58C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0003221848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EgSBFreI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfJIQtV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:49:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59374 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731375AbfJIQtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:49:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99Gjlga039899
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oHlWIjXOMnXakldBTyr+O72pPmnrucHD1WwQ3URLw2M=;
 b=EgSBFreIqBJ9iRBL8QulVHlt8XE7OSPztS/m5qL6gSRY3sqCSyhRoXK6hMrWHF1meFbO
 G/vz4vV/XmiD2U6+QQ7rxv9X33LKv9Nf4pz9X+kfJW6HYV7/ZcN2yMJeA+qZ0fMxruWU
 dDgBVchxZm/u4zkCMxd8BH2d6N/PR8EO1ik1ck48fXxRwYsGSW48tBf/vx2QMJhx6Bxu
 Us4QlkIrBSsfnd4BNuG0GhNPqXhFIF9MTEERLI9Re7bdzcWEdAPN2Zhd9M9160+ovjMi
 h/yEpa2zPv4y36dRAuMp46diBeQgzPjsdd+OCd+k7WFl5XoPyBs246ahY+QkmJ6o0W2Z ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vejkup10t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GiZen144612
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vh8k1466r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99GnHr9023847
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:49:17 -0700
Subject: [PATCH 2/4] xfs: replace open-coded bitmap weight logic
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:49:12 -0700
Message-ID: <157063975219.2913318.17554625502389919068.stgit@magnolia>
In-Reply-To: <157063973592.2913318.8246472567175058111.stgit@magnolia>
References: <157063973592.2913318.8246472567175058111.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a xbitmap_hweight helper function so that we can get rid of the
open-coded loop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader_repair.c |   12 ++----------
 fs/xfs/scrub/bitmap.c          |   15 +++++++++++++++
 fs/xfs/scrub/bitmap.h          |    1 +
 3 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 9fbb6035f4e2..f35596cc26fb 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -482,8 +482,6 @@ xrep_agfl_collect_blocks(
 	struct xrep_agfl	ra;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_btree_cur	*cur;
-	struct xbitmap_range	*br;
-	struct xbitmap_range	*n;
 	int			error;
 
 	ra.sc = sc;
@@ -527,14 +525,8 @@ xrep_agfl_collect_blocks(
 	 * Calculate the new AGFL size.  If we found more blocks than fit in
 	 * the AGFL we'll free them later.
 	 */
-	*flcount = 0;
-	for_each_xbitmap_extent(br, n, agfl_extents) {
-		*flcount += br->len;
-		if (*flcount > xfs_agfl_size(mp))
-			break;
-	}
-	if (*flcount > xfs_agfl_size(mp))
-		*flcount = xfs_agfl_size(mp);
+	*flcount = min_t(uint64_t, xbitmap_hweight(agfl_extents),
+			 xfs_agfl_size(mp));
 	return 0;
 
 err:
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 5b07b46c89c9..8b704d7b5855 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -296,3 +296,18 @@ xbitmap_set_btblocks(
 {
 	return xfs_btree_visit_blocks(cur, xbitmap_collect_btblock, bitmap);
 }
+
+/* How many bits are set in this bitmap? */
+uint64_t
+xbitmap_hweight(
+	struct xbitmap		*bitmap)
+{
+	struct xbitmap_range	*bmr;
+	struct xbitmap_range	*n;
+	uint64_t		ret = 0;
+
+	for_each_xbitmap_extent(bmr, n, bitmap)
+		ret += bmr->len;
+
+	return ret;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 8db4017ac78e..900646b72de1 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -32,5 +32,6 @@ int xbitmap_set_btcur_path(struct xbitmap *bitmap,
 		struct xfs_btree_cur *cur);
 int xbitmap_set_btblocks(struct xbitmap *bitmap,
 		struct xfs_btree_cur *cur);
+uint64_t xbitmap_hweight(struct xbitmap *bitmap);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */

