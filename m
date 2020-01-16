Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AD7C33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B422207E0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VEciK9kd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgAPGSA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 01:18:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgAPGSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 01:18:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G6ECLS045466;
        Thu, 16 Jan 2020 06:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=CexxUmk/ygFg7KobuiCBaaLHhL8+gUzQSqSzVOjq6ps=;
 b=VEciK9kdtz7o8S4e6lwwAxfd7MrSwtJ9sME3BuHXFxcvaid6ZZ3IQTLA+awsqM7a5yWH
 dgK8YUgmzVs+Hu0HXQGPGzQ0uYSXdeKpCQluRRbTlIz1zm96HERyKkOf5pNrlQm0TJjE
 NOwP/b8UjnGqhEH7Pv6a4A50GkCGHXfYWXgBN47yG1tU9Fe4dXWuVoax+4fRW6an//B9
 jJOQJgQ+nMv8Xc8tOueYSVuD7vGdvJ3znrE8D4rQ7t8Z0mtRM6a+LDV+X1IcO/HKSL6s
 /cNOCpG4z9AHAOyNPC77MeEGqsRXxao2Y0qpTDMMy23EguK5wI1vbu85coSymf4rFCSq IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74sgf1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 06:17:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G6EUIw029373;
        Thu, 16 Jan 2020 06:15:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xj1psfnw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 06:15:54 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G6FrU1024618;
        Thu, 16 Jan 2020 06:15:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 22:15:52 -0800
Subject: [PATCH 1/2] xfs: force writes to delalloc regions to unwritten
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 22:15:50 -0800
Message-ID: <157915535059.2406747.264640456606868955.stgit@magnolia>
In-Reply-To: <157915534429.2406747.2688273938645013888.stgit@magnolia>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=866
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=932 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160052
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When writing to a delalloc region in the data fork, commit the new
allocations (of the da reservation) as unwritten so that the mappings
are only marked written once writeback completes successfully.  This
fixes the problem of stale data exposure if the system goes down during
targeted writeback of a specific region of a file, as tested by
generic/042.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4544732d09a5..220ea1dc67ab 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4190,17 +4190,7 @@ xfs_bmapi_allocate(
 	bma->got.br_blockcount = bma->length;
 	bma->got.br_state = XFS_EXT_NORM;
 
-	/*
-	 * In the data fork, a wasdelay extent has been initialized, so
-	 * shouldn't be flagged as unwritten.
-	 *
-	 * For the cow fork, however, we convert delalloc reservations
-	 * (extents allocated for speculative preallocation) to
-	 * allocated unwritten extents, and only convert the unwritten
-	 * extents to real extents when we're about to write the data.
-	 */
-	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
-	    (bma->flags & XFS_BMAPI_PREALLOC))
+	if (bma->flags & XFS_BMAPI_PREALLOC)
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel)
@@ -4608,8 +4598,24 @@ xfs_bmapi_convert_delalloc(
 	bma.offset = bma.got.br_startoff;
 	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
+
+	/*
+	 * When we're converting the delalloc reservations backing dirty pages
+	 * in the page cache, we must be careful about how we create the new
+	 * extents:
+	 *
+	 * New CoW fork extents are created unwritten, turned into real extents
+	 * when we're about to write the data to disk, and mapped into the data
+	 * fork after the write finishes.  End of story.
+	 *
+	 * New data fork extents must be mapped in as unwritten and converted
+	 * to real extents after the write succeeds to avoid exposing stale
+	 * disk contents if we crash.
+	 */
 	if (whichfork == XFS_COW_FORK)
 		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
+	else
+		bma.flags = XFS_BMAPI_PREALLOC;
 
 	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
 		bma.prev.br_startoff = NULLFILEOFF;

