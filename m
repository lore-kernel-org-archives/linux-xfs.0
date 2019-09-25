Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7375C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9933520872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PFjqI3S6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfIYVgU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:36:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60574 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbfIYVgU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:36:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYWSg054898;
        Wed, 25 Sep 2019 21:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Njd0ftoNv38gIoKmW2LyCLGzULIXQsrB+GmMX/fTR1U=;
 b=PFjqI3S6U0OgxPqs7whD+YNA1mL/gr0C01+XULTWO5M/0yYUJzLm3zwl4Ba0sWVd+f1E
 oCQcNmMsHUzOdGM8GR7p2d9qtOFYVv8d7HrTmzfSULohvXjphFj7gxVCZh2jfISYgbfU
 qUo2MrKjnv2s5OwJaV50M+Bw9BNNMeK4zjrjGwl6Fcspz4zVPNd0l9Bj+NQYKKDoqyNU
 s2N8kooHfGuAEYlDbOv8xq3XOjBRRGVnOapTmOFjjeHd1D/gL9tl2BWcDeehP77eHMu/
 g0bSHfc4phvXNbT2NbMwakyoQDV+xTCLCeHJRuJegH6t63BzEoEl21todgXW3LpshKtP 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v5cgr7f2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYSWN078776;
        Wed, 25 Sep 2019 21:36:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2v82tkrj73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLaFeD016071;
        Wed, 25 Sep 2019 21:36:15 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:36:15 -0700
Subject: [PATCH 01/11] xfs_scrub: separate media error reporting for
 attribute forks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:36:14 -0700
Message-ID: <156944737397.300131.4607692740306012565.stgit@magnolia>
In-Reply-To: <156944736739.300131.5717633994765951730.stgit@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use different functions to warn about media errors that were detected
underlying xattr data because logical offsets for attribute fork extents
have no meaning to users.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |   45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 4554af9a..1edd98af 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -113,7 +113,7 @@ xfs_decode_special_owner(
 
 /* Report if this extent overlaps a bad region. */
 static bool
-xfs_report_verify_inode_bmap(
+report_data_loss(
 	struct scrub_ctx		*ctx,
 	const char			*descr,
 	int				fd,
@@ -142,6 +142,40 @@ _("offset %llu failed read verification."), bmap->bm_offset);
 	return true;
 }
 
+/* Report if the extended attribute data overlaps a bad region. */
+static bool
+report_attr_loss(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	int				whichfork,
+	struct fsxattr			*fsx,
+	struct xfs_bmap			*bmap,
+	void				*arg)
+{
+	struct media_verify_state	*vs = arg;
+	struct bitmap			*bmp = vs->d_bad;
+
+	/* Complain about attr fork extents that don't look right. */
+	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC)) {
+		str_info(ctx, descr,
+_("found unexpected unwritten/delalloc attr fork extent."));
+		return true;
+	}
+
+	if (fsx->fsx_xflags & FS_XFLAG_REALTIME) {
+		str_info(ctx, descr,
+_("found unexpected realtime attr fork extent."));
+		return true;
+	}
+
+	if (bitmap_test(bmp, bmap->bm_physical, bmap->bm_length))
+		str_error(ctx, descr,
+_("media error in extended attribute data."));
+
+	return true;
+}
+
 /* Iterate the extent mappings of a file to report errors. */
 static bool
 xfs_report_verify_fd(
@@ -155,16 +189,13 @@ xfs_report_verify_fd(
 
 	/* data fork */
 	moveon = xfs_iterate_filemaps(ctx, descr, fd, XFS_DATA_FORK, &key,
-			xfs_report_verify_inode_bmap, arg);
+			report_data_loss, arg);
 	if (!moveon)
 		return false;
 
 	/* attr fork */
-	moveon = xfs_iterate_filemaps(ctx, descr, fd, XFS_ATTR_FORK, &key,
-			xfs_report_verify_inode_bmap, arg);
-	if (!moveon)
-		return false;
-	return true;
+	return xfs_iterate_filemaps(ctx, descr, fd, XFS_ATTR_FORK, &key,
+			report_attr_loss, arg);
 }
 
 /* Report read verify errors in unlinked (but still open) files. */

