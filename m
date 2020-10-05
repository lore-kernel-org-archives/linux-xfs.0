Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A858FC4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 16:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A9520774
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 16:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DGLz+ytT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgJEQhk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 12:37:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47254 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgJEQhk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 12:37:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095GTLr1112481;
        Mon, 5 Oct 2020 16:37:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=qKMyyjo5CYhV7U6S6XVCLRaI24mcq1iuFZOgiSjr0Qo=;
 b=DGLz+ytT4IyKzMkIdgObmiRKp25EMJ6YhlM80ZM5Tstq3F8Lm3aDkivTxmtb82IYmnZJ
 OGf2bKGnEduBkup+VPqxFcOnww4XP+TntZjuM4BAdXltE3254J4Ubx3GTWlEx11MoHnO
 WrGqyYZB0rRNQG6rK9O90zM8Zeu4yS9zc8ZhbMElVcMTtynxK9SLrsJ1hsWgQd12nIPU
 1BbddU0t4sZ22by8Je7GER6H6g182KLkOvMeSrms+GMPTYU2bQNOo5W9dJwW2keQr3qV
 8anVGxzptKG21QWOJZGPpdHzmQL37ARNs/I8L35M/BFHLBqzg1miccav5nmb/RD3V4eM Hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxmpg91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 16:37:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095GVEcE167790;
        Mon, 5 Oct 2020 16:37:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vkr191-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 16:37:37 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095GbaL8024712;
        Mon, 5 Oct 2020 16:37:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 09:37:36 -0700
Date:   Mon, 5 Oct 2020 09:37:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] xfs_scrub: don't use statvfs to collect filesystem
 summary counts
Message-ID: <20201005163737.GE49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=5 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=5 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The function scrub_scan_estimate_blocks naïvely uses the statvfs counts
to estimate the size and free blocks on the data volume.  Unfortunately,
it fails to account for the fact that statvfs can return the size and
free counts for the realtime volume if the root directory has the
rtinherit flag set, which leads to phase 7 reporting totally absurd
quantities.

Eric pointed out a further problem with statvfs, which is that the file
counts are clamped to the current user's project quota inode limits.
Therefore, we must not use statvfs for querying the filesystem summary
counts.

The XFS_IOC_FSCOUNTS ioctl returns all the data we need, so use that
instead.

Fixes: 604dd3345f35 ("xfs_scrub: filesystem counter collection functions")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: drop statvfs entirely
---
 scrub/fscounters.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index f9d64f8c008f..e9901fcdf6df 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -130,38 +130,19 @@ scrub_scan_estimate_blocks(
 	unsigned long long		*f_free)
 {
 	struct xfs_fsop_counts		fc;
-	struct xfs_fsop_resblks		rb;
-	struct statvfs			sfs;
 	int				error;
 
-	/* Grab the fstatvfs counters, since it has to report accurately. */
-	error = fstatvfs(ctx->mnt.fd, &sfs);
-	if (error)
-		return errno;
-
 	/* Fetch the filesystem counters. */
 	error = ioctl(ctx->mnt.fd, XFS_IOC_FSCOUNTS, &fc);
 	if (error)
 		return errno;
 
-	/*
-	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
-	 * blocks back to the free data counts.
-	 */
-	error = ioctl(ctx->mnt.fd, XFS_IOC_GET_RESBLKS, &rb);
-	if (error)
-		return errno;
-
-	sfs.f_bfree += rb.resblks_avail;
-
-	*d_blocks = sfs.f_blocks;
-	if (ctx->mnt.fsgeom.logstart > 0)
-		*d_blocks += ctx->mnt.fsgeom.logblocks;
-	*d_bfree = sfs.f_bfree;
+	*d_blocks = ctx->mnt.fsgeom.datablocks;
+	*d_bfree = fc.freedata;
 	*r_blocks = ctx->mnt.fsgeom.rtblocks;
 	*r_bfree = fc.freertx;
-	*f_files = sfs.f_files;
-	*f_free = sfs.f_ffree;
+	*f_files = fc.allocino;
+	*f_free = fc.freeino;
 
 	return 0;
 }
