Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CF8C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 12:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6BC420823
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 12:54:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bkIweTKF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgESMym (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 08:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgESMym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 08:54:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003FFC08C5C0
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 05:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V9zYkvgQTdQwczYreKhhWQfjcLTB+aruaTifqHrjKc0=; b=bkIweTKFJS/HPIxc7dNaAGqxwE
        2AURQrxHIxOaicQgxFxGOkzIC+omSknUoEft8lB/82KLM/j1iCChAJWY5YGCk5hG0cnrGIGK3mxJc
        tHHi0IXtefydNGq6zL8CriI6VygpkMxq6B9CJPIy6BWk5bWkRpKOGHJtkaecafxbS/KgHynkByNhX
        PVQEeyzD+Y+weah9d4qeKKkW371SMD+8BQZewC+h6Uqz/PZaXRdmh3DLQXANOBKL4V8O+Tlu4OVe3
        clKI4n7GY7vucciMepYBc59YtnEsUNfQbaCaIY489v8H+NQy4FRDV4BLuTJmZ6YYAPAR/J2Qet6JD
        p2CpcHFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb1lV-0004G6-2F; Tue, 19 May 2020 12:54:37 +0000
Date:   Tue, 19 May 2020 05:54:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200519125437.GA15081@infradead.org>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
 <158984936387.619853.12262802837092587871.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158984936387.619853.12262802837092587871.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The actual logic looks good, but I think the new helper and another
third set of comment explaining what is going on makes this area even
more confusing.  What about something like this instead?

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index bb590a267a7f9..26f9874361cd3 100644
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
+ * filesystem is to full, the smaller the maximum preallocation.
  */
 STATIC xfs_fsblock_t
 xfs_iomap_prealloc_size(
@@ -380,52 +368,58 @@ xfs_iomap_prealloc_size(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	struct xfs_bmbt_irec	prev;
+	struct xfs_iext_cursor	ncur = *icur;
+	struct xfs_bmbt_irec	prev, got;
 	int			shift = 0;
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
 	int			qshift = 0;
-	xfs_fsblock_t		alloc_blocks = 0;
+	xfs_fsblock_t		alloc_blocks;
+	xfs_extlen_t		plen;
 
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
+	 * Otherwise use the minimum prealloca size for small files, or if we
+	 * are writing right after a hole.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
-	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
-	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
+	if (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
+	    !xfs_iext_prev_extent(ifp, &ncur, &prev) ||
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
-	 * Otherwise we take the size of the preceding data extent as the basis
-	 * for the preallocation size. If the size of the extent is greater than
-	 * half the maximum extent length, then use the current offset as the
-	 * basis. This ensures that for large files the preallocation size
-	 * always extends to MAXEXTLEN rather than falling short due to things
-	 * like stripe unit/width alignment of real extents.
+	 * Take the size of the contiguous preceding data extents as the basis
+	 * for the preallocation size.  Note that we don't care if the previous
+	 * extents are written or not.
 	 */
-	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
-		alloc_blocks = prev.br_blockcount << 1;
-	else
+	plen = prev.br_blockcount;
+	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
+		if (plen > MAXEXTLEN / 2 ||
+		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
+		    got.br_startblock + got.br_blockcount != prev.br_startblock)
+			break;
+		plen += got.br_blockcount;
+		prev = got;
+	}
+
+	/*
+	 * If the size of the extents is greater than half the maximum extent
+	 * length, then use the current offset as the basis.  This ensures that
+	 * for large files the preallocation size always extends to MAXEXTLEN
+	 * rather than falling short due to things like stripe unit/width
+	 * alignment of real extents.
+	 */
+	alloc_blocks = plen * 2;
+	if (alloc_blocks > MAXEXTLEN)
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
-	if (!alloc_blocks)
-		goto check_writeio;
 	qblocks = alloc_blocks;
 
 	/*
@@ -494,7 +488,6 @@ xfs_iomap_prealloc_size(
 	 */
 	while (alloc_blocks && alloc_blocks >= freesp)
 		alloc_blocks >>= 4;
-check_writeio:
 	if (alloc_blocks < mp->m_allocsize_blocks)
 		alloc_blocks = mp->m_allocsize_blocks;
 	trace_xfs_iomap_prealloc_size(ip, alloc_blocks, shift,
@@ -961,9 +954,16 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		goto out_unlock;
 
-	if (eof) {
-		prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork, offset,
-				count, &icur);
+	if (eof && offset + count > XFS_ISIZE(ip)) {
+		/*
+		 * Determine the initial size of the preallocation.
+ 		 * We clean up any extra preallocation when the file is closed.
+		 */
+		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
+			prealloc_blocks = mp->m_allocsize_blocks;
+		else
+			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
+						offset, count, &icur);
 		if (prealloc_blocks) {
 			xfs_extlen_t	align;
 			xfs_off_t	end_offset;
