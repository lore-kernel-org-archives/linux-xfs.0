Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165C9CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D510D2087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uR67C4qF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfJ3SFU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 14:05:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38430 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbfJ3SFU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 14:05:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nukOcChtwdixj6tbb2KlOd1/J4GmdFDLqaK3744u6AM=; b=uR67C4qFFRROAl/EhRDHKQ7Smn
        yrYElVnXoTINjPcZZ4wlYxY7JfZUvwjev6+WD4p9gL7JLL2HY9AVzdtWZl2HIdOJ6IQB7MmxcnA96
        8KmXzEbe06sCZEwGtWuTu2GMlzuq2tJCTQpO0lBai2lQWGPSAK/D+34l+tf+fsya8Kx4xyx8YPu2e
        ZV4UYViB2vo/2LlOcw3aqMrxVesFBWR20VjPnSh0Kt1C4bR0G4ys37RNLJg6hhBczwtCt52YHKu6n
        vSl1hW/KkrpC/M32FXwqDIgE/SoQq2bvx5JZ+wsRRfwC0A9GVqbwgK/jgo2PSXCuh3zXFPB6aySH0
        bRYn6aKg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPsLQ-0006tv-4y; Wed, 30 Oct 2019 18:05:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 9/9] xfs: cleanup use of the XFS_ALLOC_ flags
Date:   Wed, 30 Oct 2019 11:04:19 -0700
Message-Id: <20191030180419.13045-10-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030180419.13045-1-hch@lst.de>
References: <20191030180419.13045-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Always set XFS_ALLOC_USERDATA for data fork allocations, and check it
in xfs_alloc_is_userdata instead of the current obsfucated check.
Also remove the xfs_alloc_is_userdata and xfs_alloc_allow_busy_reuse
helpers to make the code a little easier to understand.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  8 ++++----
 fs/xfs/libxfs/xfs_alloc.h | 12 ------------
 fs/xfs/libxfs/xfs_bmap.c  | 11 +++++------
 fs/xfs/xfs_extent_busy.c  |  2 +-
 fs/xfs/xfs_filestream.c   |  2 +-
 5 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0539d61ff12c..b8d48d5fa6a5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -331,7 +331,7 @@ xfs_alloc_compute_diff(
 	xfs_extlen_t	newlen1=0;	/* length with newbno1 */
 	xfs_extlen_t	newlen2=0;	/* length with newbno2 */
 	xfs_agblock_t	wantend;	/* end of target extent */
-	bool		userdata = xfs_alloc_is_userdata(datatype);
+	bool		userdata = datatype & XFS_ALLOC_USERDATA;
 
 	ASSERT(freelen >= wantlen);
 	freeend = freebno + freelen;
@@ -1041,9 +1041,9 @@ xfs_alloc_ag_vextent_small(
 		goto out;
 
 	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
-			      xfs_alloc_allow_busy_reuse(args->datatype));
+			      (args->datatype & XFS_ALLOC_NOBUSY));
 
-	if (xfs_alloc_is_userdata(args->datatype)) {
+	if (args->datatype & XFS_ALLOC_USERDATA) {
 		struct xfs_buf	*bp;
 
 		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
@@ -2381,7 +2381,7 @@ xfs_alloc_fix_freelist(
 	 * somewhere else if we are not being asked to try harder at this
 	 * point
 	 */
-	if (pag->pagf_metadata && xfs_alloc_is_userdata(args->datatype) &&
+	if (pag->pagf_metadata && (args->datatype & XFS_ALLOC_USERDATA) &&
 	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
 		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
 		goto out_agbp_relse;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 626384d75c9c..7380fbe4a3ff 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -84,18 +84,6 @@ typedef struct xfs_alloc_arg {
 #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
 #define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
 
-static inline bool
-xfs_alloc_is_userdata(int datatype)
-{
-	return (datatype & ~XFS_ALLOC_NOBUSY) != 0;
-}
-
-static inline bool
-xfs_alloc_allow_busy_reuse(int datatype)
-{
-	return (datatype & XFS_ALLOC_NOBUSY) == 0;
-}
-
 /* freespace limit calculations */
 #define XFS_ALLOC_AGFL_RESERVE	4
 unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ec8ecfd46a48..11ec3e0f3d59 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3059,7 +3059,7 @@ xfs_bmap_adjacent(
 	mp = ap->ip->i_mount;
 	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
 	rt = XFS_IS_REALTIME_INODE(ap->ip) &&
-		xfs_alloc_is_userdata(ap->datatype);
+		(ap->datatype & XFS_ALLOC_USERDATA);
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
 							ap->tp->t_firstblock);
 	/*
@@ -3412,7 +3412,7 @@ xfs_bmap_btalloc(
 
 	if (ap->flags & XFS_BMAPI_COWFORK)
 		align = xfs_get_cowextsz_hint(ap->ip);
-	else if (xfs_alloc_is_userdata(ap->datatype))
+	else if (ap->datatype & XFS_ALLOC_USERDATA)
 		align = xfs_get_extsz_hint(ap->ip);
 	if (align) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
@@ -3427,7 +3427,7 @@ xfs_bmap_btalloc(
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
 							ap->tp->t_firstblock);
 	if (nullfb) {
-		if (xfs_alloc_is_userdata(ap->datatype) &&
+		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
 		    xfs_inode_is_filestream(ap->ip)) {
 			ag = xfs_filestream_lookup_ag(ap->ip);
 			ag = (ag != NULLAGNUMBER) ? ag : 0;
@@ -3467,7 +3467,7 @@ xfs_bmap_btalloc(
 		 * enough for the request.  If one isn't found, then adjust
 		 * the minimum allocation size to the largest space found.
 		 */
-		if (xfs_alloc_is_userdata(ap->datatype) &&
+		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
 		    xfs_inode_is_filestream(ap->ip))
 			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
 		else
@@ -4010,10 +4010,9 @@ xfs_bmap_alloc_userdata(
 	 */
 	bma->datatype = XFS_ALLOC_NOBUSY;
 	if (whichfork == XFS_DATA_FORK) {
+		bma->datatype |= XFS_ALLOC_USERDATA;
 		if (bma->offset == 0)
 			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
-		else
-			bma->datatype |= XFS_ALLOC_USERDATA;
 
 		if (mp->m_dalign && bma->length >= mp->m_dalign) {
 			error = xfs_bmap_isaeof(bma, whichfork);
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 2183d87be4cf..3991e59cfd18 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -367,7 +367,7 @@ xfs_extent_busy_trim(
 		 * If this is a metadata allocation, try to reuse the busy
 		 * extent instead of trimming the allocation.
 		 */
-		if (!xfs_alloc_is_userdata(args->datatype) &&
+		if (!(args->datatype & XFS_ALLOC_USERDATA) &&
 		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
 			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
 							  busyp, fbno, flen,
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 574a7a8b4736..2ae356775f63 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -374,7 +374,7 @@ xfs_filestream_new_ag(
 		startag = (item->ag + 1) % mp->m_sb.sb_agcount;
 	}
 
-	if (xfs_alloc_is_userdata(ap->datatype))
+	if (ap->datatype & XFS_ALLOC_USERDATA)
 		flags |= XFS_PICK_USERDATA;
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
 		flags |= XFS_PICK_LOWSPACE;
-- 
2.20.1

