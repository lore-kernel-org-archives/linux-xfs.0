Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2D3C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D94D207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TVYOaTk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgEVCxY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:53:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35174 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbgEVCxY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:53:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mVMM123383;
        Fri, 22 May 2020 02:53:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FAO3H4DWyRjLYvBNdb2G9tFexwRSnmfFh30gHMiobTQ=;
 b=TVYOaTk2wJUykg4HTGUFhtPm9Bs1344SN8+5ZHIZEhvYNav+k/bau7VUzP7orMk9ZiM+
 0RssWinQKfiTXOYd+a093QaHlYGGhEhKFLSWLhtYbjjt5MIjBqM1rU+61UFc/95GN+7W
 aO7+VjjhxK2hhGAJeps8VhqanwVf2qSqIIzm4lRINqgKhcsEMs2kr1R0BLZjKXoTRT0c
 brG0bsyCM1SW2Yj7XrxTApP8CvqQghcdSGEsJ5zeYwvKBp18dO58CgTq5qPpCQSbVa1Y
 JMSbpwLGpg2S/eSUgu1haYiFv1l0fz7e1RRe2b+fdlrqDnNTyHZuZiX/+kl07g9Ye0ed 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krkk0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:53:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2nEZQ173910;
        Fri, 22 May 2020 02:53:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3d3vsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:53:19 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2rIxb029849;
        Fri, 22 May 2020 02:53:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:53:17 -0700
Subject: [PATCH 3/4] xfs: refactor xfs_iomap_prealloc_size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        hch@infradead.org, bfoster@redhat.com
Date:   Thu, 21 May 2020 19:53:16 -0700
Message-ID: <159011599650.76931.9345570053700795571.stgit@magnolia>
In-Reply-To: <159011597442.76931.7800023221007221972.stgit@magnolia>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
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

Refactor xfs_iomap_prealloc_size to be the function that dynamically
computes the per-file preallocation size by moving the allocsize= case
to the caller.  Break up the huge comment preceding the function to
annotate the relevant parts of the code, and remove the impossible
check_writeio case.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c |   83 ++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 48 deletions(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6a308af93893..d8fa5519c761 100644
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
 	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
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
@@ -434,19 +409,25 @@ xfs_iomap_prealloc_size(
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
@@ -507,7 +488,6 @@ xfs_iomap_prealloc_size(
 	 */
 	while (alloc_blocks && alloc_blocks >= freesp)
 		alloc_blocks >>= 4;
-check_writeio:
 	if (alloc_blocks < mp->m_allocsize_blocks)
 		alloc_blocks = mp->m_allocsize_blocks;
 	trace_xfs_iomap_prealloc_size(ip, alloc_blocks, shift,
@@ -974,9 +954,16 @@ xfs_buffered_write_iomap_begin(
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

