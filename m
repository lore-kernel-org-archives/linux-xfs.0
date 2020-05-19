Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC795C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3A9520756
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:49:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PsMngJIB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgESAtc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 20:49:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgESAtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 20:49:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0l42N144879;
        Tue, 19 May 2020 00:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XHBM36PM/PUr5LbXkYkqtu+rYZzXGOxJIgOPA8X0CZ4=;
 b=PsMngJIB7SvpEXz36tY52SvBHHvDMPALsNpXigQXaGUvML0UVWC6WFlCirawlsohpZwa
 McrkLYTFwtyFu6OJswE0wrGDTjhwE3wKkp4fcmjMb136bbOv275QWP4lYBqQnWTkYW1x
 vi7BXqmRpGrH2dwK/ZU3526V7Ak1aV61VuqAESad53GYbPYKsu/Td6LGISjhdNlEHmZE
 ZXThVv95zw16rEKv9aiKIIvYDy2YUqYruF1Mi1ARCpd/9jAhHs89rR8IGYLEL6UH2Pga
 VTEEWy/qaK+jY4L47XAV5hq0VnAVZ3t/Qbw962uTmQ+yMixk9sWTruUjwqXP5DlWYMRz eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127kr26ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 00:49:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0gvYD045875;
        Tue, 19 May 2020 00:49:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t32jwt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 00:49:26 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04J0nQX0014484;
        Tue, 19 May 2020 00:49:26 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 17:49:25 -0700
Subject: [PATCH 3/3] xfs: measure all contiguous previous extents for prealloc
 size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Date:   Mon, 18 May 2020 17:49:23 -0700
Message-ID: <158984936387.619853.12262802837092587871.stgit@magnolia>
In-Reply-To: <158984934500.619853.3585969653869086436.stgit@magnolia>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190005
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
 fs/xfs/xfs_iomap.c |   63 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ac970b13b1f8..2dffd56a433c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -351,6 +351,46 @@ xfs_quota_calc_throttle(
 	}
 }
 
+/*
+ * Determine if the previous extent's range of offsets is contiguous with
+ * @offset_fsb.  If so, set @prev_contig to the number of blocks that are
+ * physically contiguous with that previous extent and return true.  If there
+ * is no previous extent or there's a hole right before @offset_fsb, return
+ * false.
+ *
+ * Note that we don't care if the previous extents are written or not.
+ */
+static inline bool
+xfs_iomap_prev_contiguous(
+	struct xfs_ifork	*ifp,
+	struct xfs_iext_cursor	*cur,
+	xfs_fileoff_t		offset_fsb,
+	xfs_extlen_t		*prev_contig)
+{
+	struct xfs_iext_cursor	ncur = *cur;
+	struct xfs_bmbt_irec	got, old;
+
+	xfs_iext_prev(ifp, &ncur);
+	if (!xfs_iext_get_extent(ifp, &ncur, &old))
+		return false;
+	if (old.br_startoff + old.br_blockcount < offset_fsb)
+		return false;
+
+	*prev_contig = old.br_blockcount;
+
+	xfs_iext_prev(ifp, &ncur);
+	while (xfs_iext_get_extent(ifp, &ncur, &got) &&
+	       got.br_blockcount + got.br_startoff == old.br_startoff &&
+	       got.br_blockcount + got.br_startblock == old.br_startblock &&
+	       *prev_contig <= MAXEXTLEN) {
+		*prev_contig += got.br_blockcount;
+		old = got; /* struct copy */
+		xfs_iext_prev(ifp, &ncur);
+	}
+
+	return true;
+}
+
 /*
  * If we are doing a write at the end of the file and there are no allocations
  * past this one, then extend the allocation out to the file system's write
@@ -380,12 +420,12 @@ xfs_iomap_prealloc_size(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	struct xfs_bmbt_irec	prev;
 	int			shift = 0;
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
 	int			qshift = 0;
 	xfs_fsblock_t		alloc_blocks = 0;
+	xfs_extlen_t		plen = 0;
 
 	if (offset + count <= XFS_ISIZE(ip))
 		return 0;
@@ -400,9 +440,9 @@ xfs_iomap_prealloc_size(
 	 */
 	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
 	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
-	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
-	    prev.br_startoff + prev.br_blockcount < offset_fsb)
+	    !xfs_iomap_prev_contiguous(ifp, icur, offset_fsb, &plen)) {
 		return mp->m_allocsize_blocks;
+	}
 
 	/*
 	 * Determine the initial size of the preallocation. We are beyond the
@@ -413,15 +453,16 @@ xfs_iomap_prealloc_size(
 	 * preallocation size.
 	 *
 	 * If the extent is a hole, then preallocation is essentially disabled.
-	 * Otherwise we take the size of the preceding data extent as the basis
-	 * for the preallocation size. If the size of the extent is greater than
-	 * half the maximum extent length, then use the current offset as the
-	 * basis. This ensures that for large files the preallocation size
-	 * always extends to MAXEXTLEN rather than falling short due to things
-	 * like stripe unit/width alignment of real extents.
+	 * Otherwise we take the size of the contiguous preceding data extents
+	 * as the basis for the preallocation size. If the size of the extent
+	 * is greater than half the maximum extent length, then use the current
+	 * offset as the basis. This ensures that for large files the
+	 * preallocation size always extends to MAXEXTLEN rather than falling
+	 * short due to things like stripe unit/width alignment of real
+	 * extents.
 	 */
-	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
-		alloc_blocks = prev.br_blockcount << 1;
+	if (plen <= (MAXEXTLEN >> 1))
+		alloc_blocks = plen << 1;
 	else
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	if (!alloc_blocks)

