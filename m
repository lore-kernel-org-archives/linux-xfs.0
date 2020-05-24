Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07732C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 17:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE4D2206D5
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 17:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mOxzKDNV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387773AbgEXRR1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 13:17:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36974 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387707AbgEXRR1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 13:17:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04OHCJkY136883;
        Sun, 24 May 2020 17:17:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=h7J+uUHFeWS7K9vLF9Qz7Wh37SWHHiFhZyA/aXuZV4c=;
 b=mOxzKDNVn7elzujhbHeYvl76Re9NrjO1PSOrpr08c8/BS/6qR5WEnFH+X+OoAxxkGQQW
 Fk42IQBFWiS4FNLFCxs6kRotw2y1yp1ZhqDYkVxn9+mjce+cD6kYeMB+HaB1tuE1SqKF
 LNExc0PSUexoDF9IqGaaT271rFe/ljst1he4Ecbnk2xqoJinHAsP+puQNxVv2pq6hIbb
 KZhh0cF8gcbvGxBF89ggwTZZO4/JvEOBN3zN3CkjoYylbbFR2hme5nYTSdZUofwVIF6/
 N/Df6ohiW2Kck+gjP0QO7PxmweN+tEF5cKybsjIVrX2T7wQohxdXPAChrW8iC/19NODX DQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 316uskk5d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 24 May 2020 17:17:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04OHCpMg142022;
        Sun, 24 May 2020 17:17:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 317ddjxkw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 24 May 2020 17:17:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04OHHBaV008158;
        Sun, 24 May 2020 17:17:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 24 May 2020 10:17:10 -0700
Date:   Sun, 24 May 2020 10:17:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Subject: [PATCH v2 3/4] xfs: refactor xfs_iomap_prealloc_size
Message-ID: <20200524171709.GI8230@magnolia>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
 <159025259150.493629.14462334296980108072.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159025259150.493629.14462334296980108072.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=1 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005240143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 lowpriorityscore=0
 suspectscore=1 spamscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 cotscore=-2147483648 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005240143
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
v2: minor rebase due to changes in previous patch
---
 fs/xfs/xfs_iomap.c |   83 ++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e74a8c2c94ce..b9a8c3798e08 100644
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
 	alloc_blocks = plen * 2;
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
