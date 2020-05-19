Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC107C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 907E820578
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gfd4A/ZX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgESAvW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 20:51:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgESAvW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 20:51:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0lYSk188260;
        Tue, 19 May 2020 00:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4Wtum3YfHf7+50WpRzJMVVEnXKsE1tNN8Tz4blVOqkc=;
 b=Gfd4A/ZXgn/dGfCm89KqAJnPE/oWSmJF53Mr7KS6FEhG6/IjNbxDWKdtKw+nGu7Q4en4
 FYhcbpGEIxkriqywLPzQGH4KtEdzv4XN9qwjf2aI1xNk/A8piSSwWbxO0EII+Lkx7wHb
 SwuSeVJaQLyiuxLmoYSajZ+09+my94e0qor6FoJpFhS68z6S9zFuJlkyQQUvEg053a68
 rysXi9mmh2qe1n81N+0a8wHjSNhHPUBbHvNq0gahQcyByYo1Q4BwkoGCv/6QV+Qr8CvU
 DSg5WVyhYutA1THFXTgt6Z4mFWHq2cvlUH4MlMo2Ql8shDTlPborpdkGk6hqPsc1kxeM Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tna2w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 00:51:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0iMS9121457;
        Tue, 19 May 2020 00:49:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 312t3wrb2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 00:49:14 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04J0nDTX001313;
        Tue, 19 May 2020 00:49:13 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 17:49:13 -0700
Subject: [PATCH 1/3] xfs: force writes to delalloc regions to unwritten
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, bfoster@redhat.com
Date:   Mon, 18 May 2020 17:49:11 -0700
Message-ID: <158984935136.619853.1558687512700172480.stgit@magnolia>
In-Reply-To: <158984934500.619853.3585969653869086436.stgit@magnolia>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=1 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190005
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fda13cd7add0..825d170e1503 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4193,17 +4193,7 @@ xfs_bmapi_allocate(
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
@@ -4611,8 +4601,24 @@ xfs_bmapi_convert_delalloc(
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

