Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F9BC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1B85207E8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gm7sKZaE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgEVCxe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:53:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgEVCxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:53:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2m0ou111156;
        Fri, 22 May 2020 02:53:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nhNEfbDA7hygXgzHiaabroNOr78xf+7YmgWUhReNu9A=;
 b=Gm7sKZaE5bqB8F2duUdVN3yNnuyB6qG0+DgTXf+BKYjO3ctQXQX7xmRJl/WPWTYFUu0k
 gLDrJjfzHYlTbgxwinkOdV1XUFT9WIfgJSfI14ccBmbfQByvF25LeCB1Mq4pxCEczjSL
 SYlPdRMj6kFqDwIbwq8+TwvJeXWbYnn8o7PbUnmyfG/g9AP/K9GoDbnV4oP94QuydP9g
 umzrpZ+FQwcoZQMfCO0ZACf+P5yGfa72yITyF1Lom9ebjoNXpykBsIr3btIdSugK7szo
 0ImUV14YjUpqC0C0vrA8VhKNDqFCekqz2F2IGHjkB/7vTFmgg/6bNgeYqL88rOt330/r yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127krkk0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:53:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mX8d186009;
        Fri, 22 May 2020 02:53:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gmaav3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:53:26 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M2rOuw029821;
        Fri, 22 May 2020 02:53:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:53:24 -0700
Subject: [PATCH 4/4] xfs: force writes to delalloc regions to unwritten
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Date:   Thu, 21 May 2020 19:53:23 -0700
Message-ID: <159011600308.76931.7853207930055232164.stgit@magnolia>
In-Reply-To: <159011597442.76931.7800023221007221972.stgit@magnolia>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

