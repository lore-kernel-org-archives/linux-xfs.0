Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44505C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EF2120838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0Ro6N4kD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgBYAMm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:12:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAMm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:12:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08JO4050371;
        Tue, 25 Feb 2020 00:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Vm6jqfgUEyQH/+BU5sB8J8MgrCdifMvaLBmYHhOvSts=;
 b=0Ro6N4kD4MxOf/nOsR/lgZ9nYexMfigI80wfpsdjoaHb14q2mWMy9dYmhOsaBA7hczpx
 0vyK49KDDcZPPn4WNjQkJkXBkVBWMXhWA34miWkesrPq5dV+cvRJj8yC4w8LlMKGjogL
 n2drOCwESBycPZTdpikyI2JQhZb0AuzBadiyJI7et2b/HW4yg66hkEKmZmXaF/6A/iAt
 +94r1EiGPRJi+DpTRWXQU5da1yZqULHyyPirz7DHFhvSXQuFfvBGSxqazweiyNsdK5UU
 YGMdHm2fNulMy2Lle1cPAIm8Toe9ZUFd0K373Uey2MQHvx9ITGPB+/vdMI89AowNo7sJ ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08FVq015080;
        Tue, 25 Feb 2020 00:12:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ybdshxya4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:39 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0CdL0032625;
        Tue, 25 Feb 2020 00:12:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:12:38 -0800
Subject: [PATCH 11/25] xfs_db: use uncached buffer reads to get the
 superblock
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:12:37 -0800
Message-ID: <158258955793.451378.12834800309076146911.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=931 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=979 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Upon startup, xfs_db needs to check if it is even looking at an XFS
filesystem, and it needs the AG 0 superblock contents to initialize the
incore mount.  We cannot know the filesystem sector size until we read
the superblock, but we also do not want to introduce aliasing in the
buffer cache.  Convert this code to the new uncached buffer read API so
that we can stop open-coding it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/init.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/db/init.c b/db/init.c
index 8bad7e53..61eea111 100644
--- a/db/init.c
+++ b/db/init.c
@@ -47,6 +47,7 @@ init(
 	struct xfs_buf	*bp;
 	unsigned int	agcount;
 	int		c;
+	int		error;
 
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
@@ -112,10 +113,9 @@ init(
 	 */
 	memset(&xmount, 0, sizeof(struct xfs_mount));
 	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
-	bp = libxfs_buf_read(xmount.m_ddev_targp, XFS_SB_DADDR,
-			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
-
-	if (!bp || bp->b_error) {
+	error = -libxfs_buf_read_uncached(xmount.m_ddev_targp, XFS_SB_DADDR,
+			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &bp, NULL);
+	if (error) {
 		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
 			"bytes)\n"), progname, fsdevice);
 		exit(1);
@@ -124,7 +124,6 @@ init(
 	/* copy SB from buffer to in-core, converting architecture as we go */
 	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
 	libxfs_buf_relse(bp);
-	libxfs_purgebuf(bp);
 
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {

