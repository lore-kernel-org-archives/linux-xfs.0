Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E852EC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B87C621881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eKerFFj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfHZVbR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:31:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbfHZVbR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:31:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDl9P000864;
        Mon, 26 Aug 2019 21:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=X7LtZomcC3o24aWMUujYM4G8HTGAMm7mFUHqfyB9meE=;
 b=eKerFFj4Q78j6fLZofwiQeieGTcY+htdw6xmYuc0MSnmn+tZr6n4Zm1/ObsUDoaV05qH
 vmyYxInqG1ek39OBsUSBAgvp5/qQ+jE39vFi0Cgf1Kpa/JLGGHb2wOSl6yY2yAPnUEvj
 jZ07lYl2ZngPw4R6UrTdbAJTsrhDeH+H3MUM/prox1cEtbtqbofTpSUOqN9qJZIGu+sO
 gn0Bh0bclRKY14P2fr5bOCsehokDXNPmObH6ZtUX6UeFbvJYuK1K1g57xx6O65/dShYR
 kmEF++0L5JLMXH20B/CioBUKwnUpVgJhz+ETOl0V2qRNgRdgkc9YOAC4gw1/y6kj1uRN vQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2umpxx05jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIR9w024995;
        Mon, 26 Aug 2019 21:31:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2umj1tk8xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:14 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLVDIY029979;
        Mon, 26 Aug 2019 21:31:13 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:31:13 -0700
Subject: [PATCH 01/11] xfs_scrub: separate media error reporting for
 attribute forks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:31:12 -0700
Message-ID: <156685507246.2843133.6278494675997623986.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
index fec25c31..60355bb8 100644
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

