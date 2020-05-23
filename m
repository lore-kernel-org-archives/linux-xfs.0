Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6341C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A39B320738
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:54:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MyV0hOpG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387968AbgEWQyX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 12:54:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387598AbgEWQyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 12:54:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGphDt186125;
        Sat, 23 May 2020 16:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=G7VeQAoH3f3ZiroFAPiCj3OwVvceReyVqyqs9j1imIQ=;
 b=MyV0hOpGVpCaPqomhbq06EolttoZXE/X43A2HrgSPlgnMDvXb9q7BPeonbzrSULR7nv5
 bMuKkoBK8CnRA0xGbqohIuClPGypa3SYZUKIKcQb0K2+fUwF6ZA7HPx8NQHoK2OISL4G
 BnnzWd1Tqv28ei4YXqUJE85hufcMsseTnXepTW51uu7ReKlBZN0kmJ/I72KT43q0JU2P
 IDilZVkFu2LRfI4SMWL2gzNUe1Zxs9VzkRsy8wGfmhh3yN7to265+3mAXA+g6glbtCjD
 kZ5uFTpVGUuHnM7beq0IJIQHjQgcN4uOQNB+uD2d4wprwcq4BwJ9VO28BLQZy5slExAD NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 316vfn14gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 16:52:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGhLxX131613;
        Sat, 23 May 2020 16:50:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 316un1a3au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 16:50:00 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04NGnxKQ006716;
        Sat, 23 May 2020 16:49:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 23 May 2020 09:49:59 -0700
Subject: [PATCH 4/4] xfs: force writes to delalloc regions to unwritten
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Date:   Sat, 23 May 2020 09:49:58 -0700
Message-ID: <159025259804.493629.14105390886258058200.stgit@magnolia>
In-Reply-To: <159025257178.493629.12621189512718182426.stgit@magnolia>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 spamscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=1
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230139
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
 fs/xfs/libxfs/xfs_bmap.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fda13cd7add0..f8fe83c9348d 100644
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
@@ -4611,8 +4601,23 @@ xfs_bmapi_convert_delalloc(
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
+	bma.flags = XFS_BMAPI_PREALLOC;
 	if (whichfork == XFS_COW_FORK)
-		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
+		bma.flags |= XFS_BMAPI_COWFORK;
 
 	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
 		bma.prev.br_startoff = NULLFILEOFF;

