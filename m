Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF930C433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 17:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6120206D5
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 17:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X8d9SiQh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgEXRQy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 13:16:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43006 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387707AbgEXRQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 13:16:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04OHBd54052260;
        Sun, 24 May 2020 17:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0yyepkUp9YUqDNzDBRGO6el+sS1x/j+y8+cZI1G2508=;
 b=X8d9SiQhFM34p8jtiDGmKL4oUYWUFJDfNf1l0Cb3xmRqCZLP1gKk2BOGIfF/tqDt4tF5
 tPdAhJa8MvSrO5PWvmZ0nxZHhn8Y/EGBZvGBm8f/Ado9SXwwpPnibp7WQfzYjs3KcZNG
 ++bYXv8GZ27vI4SAbZSBI8o8/3l5d36VfoanSfZvUPkOv3OaIDiW12arwAq+CfN24FAE
 3J8WLdSBZ7p1EQ559GAU93802T7YLTxJC0+IIriJbayHm2vx5G6M60nlUvJv410cMbD9
 16KS2UUioxGyIrkxJz6bCALBkELB6E6BZa7F9R/rp+8Nyvj1lsTyAHhkxNsbCmx67KAK jQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 316vfn3359-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 24 May 2020 17:16:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04OHDnmQ083490;
        Sun, 24 May 2020 17:16:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 317dkp61y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 24 May 2020 17:16:15 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04OHGEQw023263;
        Sun, 24 May 2020 17:16:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 24 May 2020 10:16:13 -0700
Date:   Sun, 24 May 2020 10:16:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Subject: [PATCH v2 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200524171612.GG8230@magnolia>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
 <159025258515.493629.3176219395358340970.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159025258515.493629.3176219395358340970.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=1 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005240143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=1
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005240143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're estimating a new speculative preallocation length for an
extending write, we should walk backwards through the extent list to
determine the number of number of blocks that are physically and
logically contiguous with the write offset, and use that as an input to
the preallocation size computation.

This way, preallocation length is truly measured by the effectiveness of
the allocator in giving us contiguous allocations without being
influenced by the state of a given extent.  This fixes both the problem
where ZERO_RANGE within an EOF can reduce preallocation, and prevents
the unnecessary shrinkage of preallocation when delalloc extents are
turned into unwritten extents.

This was found as a regression in xfs/014 after changing delalloc writes
to create unwritten extents during writeback.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: multiplication instead of lshift
---
 fs/xfs/xfs_iomap.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7d8966ce630a..e74a8c2c94ce 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -377,15 +377,17 @@ xfs_iomap_prealloc_size(
 	loff_t			count,
 	struct xfs_iext_cursor	*icur)
 {
+	struct xfs_iext_cursor	ncur = *icur;
+	struct xfs_bmbt_irec	prev, got;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	struct xfs_bmbt_irec	prev;
-	int			shift = 0;
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
-	int			qshift = 0;
 	xfs_fsblock_t		alloc_blocks = 0;
+	xfs_extlen_t		plen;
+	int			shift = 0;
+	int			qshift = 0;
 
 	if (offset + count <= XFS_ISIZE(ip))
 		return 0;
@@ -400,7 +402,7 @@ xfs_iomap_prealloc_size(
 	 */
 	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
 	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
-	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
+	    !xfs_iext_prev_extent(ifp, &ncur, &prev) ||
 	    prev.br_startoff + prev.br_blockcount < offset_fsb)
 		return mp->m_allocsize_blocks;
 
@@ -413,16 +415,28 @@ xfs_iomap_prealloc_size(
 	 * preallocation size.
 	 *
 	 * If the extent is a hole, then preallocation is essentially disabled.
-	 * Otherwise we take the size of the preceding data extent as the basis
-	 * for the preallocation size. If the size of the extent is greater than
-	 * half the maximum extent length, then use the current offset as the
-	 * basis. This ensures that for large files the preallocation size
-	 * always extends to MAXEXTLEN rather than falling short due to things
-	 * like stripe unit/width alignment of real extents.
+	 * Otherwise we take the size of the preceding data extents as the basis
+	 * for the preallocation size. Note that we don't care if the previous
+	 * extents are written or not.
+	 *
+	 * If the size of the extents is greater than half the maximum extent
+	 * length, then use the current offset as the basis. This ensures that
+	 * for large files the preallocation size always extends to MAXEXTLEN
+	 * rather than falling short due to things like stripe unit/width
+	 * alignment of real extents.
 	 */
-	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
-		alloc_blocks = prev.br_blockcount << 1;
-	else
+	plen = prev.br_blockcount;
+	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
+		if (plen > MAXEXTLEN / 2 ||
+		    isnullstartblock(got.br_startblock) ||
+		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
+		    got.br_startblock + got.br_blockcount != prev.br_startblock)
+			break;
+		plen += got.br_blockcount;
+		prev = got;
+	}
+	alloc_blocks = plen * 2;
+	if (alloc_blocks > MAXEXTLEN)
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	if (!alloc_blocks)
 		goto check_writeio;
