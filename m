Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813D6C433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BB6320870
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xiddDvwQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgEWQuV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 12:50:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54090 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgEWQuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 12:50:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGgmdx166029;
        Sat, 23 May 2020 16:49:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Hot8KZSSw4YfVcYxKFbdndsjw5WsBJbctc4ukq1uqI8=;
 b=xiddDvwQVhgew2Oku9cRQBc7SUPhMGwAD4Ee1dnfSE2r1D8NzGVemJ4Dj+jElS2tDRwZ
 QUyeOHcjpqDtRebq05QTb5RycTq2x9DbRNJmbW4z4EntM3e6Ip0wb7H6ScvoLOAKlI7A
 bBGZaZ4+LA2jb5rwjZPEbE8CJte6ghYViEJ3hSbBsmOaYTh9/o9b2haWlvZ6fPiQDg8t
 H9d5KqSQ2g0bKrFc0RjSHL0Bpa1Scs65tDKetpEmGm+GJ81U/RWjcLIqbr2lxMP8xdzW
 3J1sgaBdWp7nTy+ZghKjssBewF4gubeLut0rnDsoX2ei6FxlPr/9CCscYyXj9EM6FEE2 Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 316vfn14d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 16:49:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGnLPt169015;
        Sat, 23 May 2020 16:49:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 316u5huss0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 16:49:53 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04NGnr6e029996;
        Sat, 23 May 2020 16:49:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 23 May 2020 09:49:52 -0700
Subject: [PATCH 3/4] xfs: refactor xfs_iomap_prealloc_size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, bfoster@redhat.com
Date:   Sat, 23 May 2020 09:49:51 -0700
Message-ID: <159025259150.493629.14462334296980108072.stgit@magnolia>
In-Reply-To: <159025257178.493629.12621189512718182426.stgit@magnolia>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=1 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=1
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_iomap_prealloc_size to be the function that dynamically
computes the per-file preallocation size by moving the allocsize= case
to the caller.  Break up the huge comment preceding the function to
annotate the relevant parts of the code, and remove the impossible
check_writeio case.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c |   83 ++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 48 deletions(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index de990365397e..ad695c77a472 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -352,22 +352,10 @@ xfs_quota_calc_throttle(
 }
 
 /*
- * If we are doing a write at the end of the file and there are no allocations
- * past this one, then extend the allocation out to the file system's write
- * iosize.
- *
  * If we don't have a user specified preallocation size, dynamically increase
  * the preallocation size as the size of the file grows.  Cap the maximum size
  * at a single extent or less if the filesystem is near full. The closer the
- * filesystem is to full, the smaller the maximum prealocation.
- *
- * As an exception we don't do any preallocation at all if the file is smaller
- * than the minimum preallocation and we are using the default dynamic
- * preallocation scheme, as it is likely this is the only write to the file that
- * is going to be done.
- *
- * We clean up any extra space left over when the file is closed in
- * xfs_inactive().
+ * filesystem is to being full, the smaller the maximum preallocation.
  */
 STATIC xfs_fsblock_t
 xfs_iomap_prealloc_size(
@@ -389,41 +377,28 @@ xfs_iomap_prealloc_size(
 	int			shift = 0;
 	int			qshift = 0;
 
-	if (offset + count <= XFS_ISIZE(ip))
-		return 0;
-
-	if (!(mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
-	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_allocsize_blocks)))
+	/*
+	 * As an exception we don't do any preallocation at all if the file is
+	 * smaller than the minimum preallocation and we are using the default
+	 * dynamic preallocation scheme, as it is likely this is the only write
+	 * to the file that is going to be done.
+	 */
+	if (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_allocsize_blocks))
 		return 0;
 
 	/*
-	 * If an explicit allocsize is set, the file is small, or we
-	 * are writing behind a hole, then use the minimum prealloc:
+	 * Use the minimum preallocation size for small files or if we are
+	 * writing right after a hole.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
-	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
+	if (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
 	    !xfs_iext_prev_extent(ifp, &ncur, &prev) ||
 	    prev.br_startoff + prev.br_blockcount < offset_fsb)
 		return mp->m_allocsize_blocks;
 
 	/*
-	 * Determine the initial size of the preallocation. We are beyond the
-	 * current EOF here, but we need to take into account whether this is
-	 * a sparse write or an extending write when determining the
-	 * preallocation size.  Hence we need to look up the extent that ends
-	 * at the current write offset and use the result to determine the
-	 * preallocation size.
-	 *
-	 * If the extent is a hole, then preallocation is essentially disabled.
-	 * Otherwise we take the size of the preceding data extents as the basis
-	 * for the preallocation size. Note that we don't care if the previous
-	 * extents are written or not.
-	 *
-	 * If the size of the extents is greater than half the maximum extent
-	 * length, then use the current offset as the basis. This ensures that
-	 * for large files the preallocation size always extends to MAXEXTLEN
-	 * rather than falling short due to things like stripe unit/width
-	 * alignment of real extents.
+	 * Take the size of the preceding data extents as the basis for the
+	 * preallocation size. Note that we don't care if the previous extents
+	 * are written or not.
 	 */
 	plen = prev.br_blockcount;
 	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
@@ -435,19 +410,25 @@ xfs_iomap_prealloc_size(
 		plen += got.br_blockcount;
 		prev = got;
 	}
+
+	/*
+	 * If the size of the extents is greater than half the maximum extent
+	 * length, then use the current offset as the basis.  This ensures that
+	 * for large files the preallocation size always extends to MAXEXTLEN
+	 * rather than falling short due to things like stripe unit/width
+	 * alignment of real extents.
+	 */
 	alloc_blocks = plen << 1;
 	if (alloc_blocks > MAXEXTLEN)
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
-	if (!alloc_blocks)
-		goto check_writeio;
 	qblocks = alloc_blocks;
 
 	/*
 	 * MAXEXTLEN is not a power of two value but we round the prealloc down
 	 * to the nearest power of two value after throttling. To prevent the
-	 * round down from unconditionally reducing the maximum supported prealloc
-	 * size, we round up first, apply appropriate throttling, round down and
-	 * cap the value to MAXEXTLEN.
+	 * round down from unconditionally reducing the maximum supported
+	 * prealloc size, we round up first, apply appropriate throttling,
+	 * round down and cap the value to MAXEXTLEN.
 	 */
 	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(MAXEXTLEN),
 				       alloc_blocks);
@@ -508,7 +489,6 @@ xfs_iomap_prealloc_size(
 	 */
 	while (alloc_blocks && alloc_blocks >= freesp)
 		alloc_blocks >>= 4;
-check_writeio:
 	if (alloc_blocks < mp->m_allocsize_blocks)
 		alloc_blocks = mp->m_allocsize_blocks;
 	trace_xfs_iomap_prealloc_size(ip, alloc_blocks, shift,
@@ -975,9 +955,16 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		goto out_unlock;
 
-	if (eof) {
-		prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork, offset,
-				count, &icur);
+	if (eof && offset + count > XFS_ISIZE(ip)) {
+		/*
+		 * Determine the initial size of the preallocation.
+		 * We clean up any extra preallocation when the file is closed.
+		 */
+		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
+			prealloc_blocks = mp->m_allocsize_blocks;
+		else
+			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
+						offset, count, &icur);
 		if (prealloc_blocks) {
 			xfs_extlen_t	align;
 			xfs_off_t	end_offset;

