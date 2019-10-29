Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449CFCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18A5A20659
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HXzBTQOb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfJ2XbS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:31:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2XbS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:31:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSgUE038160;
        Tue, 29 Oct 2019 23:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DKK4IHitI0OH66pMFXDNlwIBOm9APi5eDvBCiOTJB48=;
 b=HXzBTQObzY+RsBrWSjxh8cd9WUvaXWTSF4+WzQV4efotCo4BskbBMh+npYzZ+V5P1Yqy
 tFtPR01XI1JylMgS/OGs94baDcpKtj1D/JfK2xbU8d+0XB6v/KaRUPRLL+97YVrNHULZ
 JwRLmDN+D3OICSknJNcG+G71K9LWcPKIm/jcNz//xxDtlQlmNlkXbVXpHkbgzGQ5q4Hw
 I2lJ1JujEzGCgETCEXjCBHHqyRPut2ZqtUG1OAPQZmOjwnjhOgBDaebiNDrrAluqUtDg
 zXKIc2UMz0aKIvHkSPu/XZMxxGkc7DVLBWdAwoB1dLRXQwTGe6/Lif5G1BanlIlP143x lA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vxwhfgb3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:31:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNS763178835;
        Tue, 29 Oct 2019 23:31:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vxwj54x0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:31:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9TNV6pe024114;
        Tue, 29 Oct 2019 23:31:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:31:06 -0700
Subject: [PATCH 2/5] xfs: replace open-coded bitmap weight logic
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Date:   Tue, 29 Oct 2019 16:31:05 -0700
Message-ID: <157239186518.1267044.10112295436947105301.stgit@magnolia>
In-Reply-To: <157239185264.1267044.16039786238721573306.stgit@magnolia>
References: <157239185264.1267044.16039786238721573306.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a xbitmap_hweight helper function so that we can get rid of the
open-coded loop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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
index ab26201e9110..f88694f22d05 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -297,3 +297,18 @@ xbitmap_set_btblocks(
 	return xfs_btree_visit_blocks(cur, xbitmap_collect_btblock,
 			XFS_BTREE_VISIT_ALL, bitmap);
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

