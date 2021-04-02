Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAAAC43460
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A25CD6112F
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbhDBOYR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhDBOYQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 10:24:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2590C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 07:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=E7oMm14iccKwT56bcaflNR6BE4sdJ57YSwdflH/gif8=; b=qTja0sCfW6ge6veHNH9pKcQM32
        fekBydi46vvlp4vsyEF0uwT4EpneGjFTnvfS/usn3THPLmWVhUUsIF7r2AzguupXd5FbUUXP4c++F
        IrFHlPiAvPPOXOIQ7nHETRZA8ZgEUWgPsLPKifLHOvLktoZcn3g0kc0JwbWwHgY5jhaIXjKAr8OBf
        e6yt0/WdM8TudBPCTnpHF2KKmqKyCneTd4YhjxXmAOFPF9IRfosrspJ3bEnSev3d2TMIcZ5tJ1gnz
        f3aMK6Vj5HJVftgltuJUG79P4tlurjKnEyNTh+wpVHFo/cSojF7NZTXCGg+X0SgBhhBHWGIg1TzC9
        FuGtlXUg==;
Received: from [2001:4bb8:180:7517:6acc:e698:6fa4:15da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSKid-00FA5R-8q
        for linux-xfs@vger.kernel.org; Fri, 02 Apr 2021 14:24:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: move the XFS_IFEXTENTS check into xfs_iread_extents
Date:   Fri,  2 Apr 2021 16:24:03 +0200
Message-Id: <20210402142409.372050-2-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402142409.372050-1-hch@lst.de>
References: <20210402142409.372050-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the XFS_IFEXTENTS check from the callers into xfs_iread_extents to
simplify the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c  | 82 ++++++++++++++++-----------------------
 fs/xfs/scrub/bmap.c       |  9 ++---
 fs/xfs/xfs_bmap_util.c    | 16 +++-----
 fs/xfs/xfs_dir2_readdir.c |  8 ++--
 fs/xfs/xfs_dquot.c        |  8 ++--
 fs/xfs/xfs_iomap.c        | 16 +++-----
 fs/xfs/xfs_qm.c           |  8 ++--
 fs/xfs/xfs_reflink.c      |  8 ++--
 8 files changed, 62 insertions(+), 93 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5574d345d066ed..b8cab14ca8ce8d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1223,6 +1223,9 @@ xfs_iread_extents(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
+	if (ifp->if_flags & XFS_IFEXTENTS)
+		return 0;
+
 	if (XFS_IS_CORRUPT(mp, ifp->if_format != XFS_DINODE_FMT_BTREE)) {
 		error = -EFSCORRUPTED;
 		goto out;
@@ -1278,11 +1281,9 @@ xfs_bmap_first_unused(
 
 	ASSERT(xfs_ifork_has_extents(ifp));
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(tp, ip, whichfork);
-		if (error)
-			return error;
-	}
+	error = xfs_iread_extents(tp, ip, whichfork);
+	if (error)
+		return error;
 
 	lowest = max = *first_unused;
 	for_each_xfs_iext(ifp, &icur, &got) {
@@ -1330,11 +1331,9 @@ xfs_bmap_last_before(
 		return -EFSCORRUPTED;
 	}
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(tp, ip, whichfork);
-		if (error)
-			return error;
-	}
+	error = xfs_iread_extents(tp, ip, whichfork);
+	if (error)
+		return error;
 
 	if (!xfs_iext_lookup_extent_before(ip, ifp, last_block, &icur, &got))
 		*last_block = 0;
@@ -1353,11 +1352,9 @@ xfs_bmap_last_extent(
 	struct xfs_iext_cursor	icur;
 	int			error;
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(tp, ip, whichfork);
-		if (error)
-			return error;
-	}
+	error = xfs_iread_extents(tp, ip, whichfork);
+	if (error)
+		return error;
 
 	xfs_iext_last(ifp, &icur);
 	if (!xfs_iext_get_extent(ifp, &icur, rec))
@@ -3984,11 +3981,9 @@ xfs_bmapi_read(
 
 	XFS_STATS_INC(mp, xs_blk_mapr);
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, whichfork);
-		if (error)
-			return error;
-	}
+	error = xfs_iread_extents(NULL, ip, whichfork);
+	if (error)
+		return error;
 
 	if (!xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got))
 		eof = true;
@@ -4468,11 +4463,9 @@ xfs_bmapi_write(
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(tp, ip, whichfork);
-		if (error)
-			goto error0;
-	}
+	error = xfs_iread_extents(tp, ip, whichfork);
+	if (error)
+		goto error0;
 
 	if (!xfs_iext_lookup_extent(ip, ifp, bno, &bma.icur, &bma.got))
 		eof = true;
@@ -4751,11 +4744,9 @@ xfs_bmapi_remap(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(tp, ip, whichfork);
-		if (error)
-			return error;
-	}
+	error = xfs_iread_extents(tp, ip, whichfork);
+	if (error)
+		return error;
 
 	if (xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got)) {
 		/* make sure we only reflink into a hole. */
@@ -5426,9 +5417,10 @@ __xfs_bunmapi(
 	else
 		max_len = len;
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
-	    (error = xfs_iread_extents(tp, ip, whichfork)))
+	error = xfs_iread_extents(tp, ip, whichfork);
+	if (error)
 		return error;
+
 	if (xfs_iext_count(ifp) == 0) {
 		*rlen = 0;
 		return 0;
@@ -5914,11 +5906,9 @@ xfs_bmap_collapse_extents(
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(tp, ip, whichfork);
-		if (error)
-			return error;
-	}
+	error = xfs_iread_extents(tp, ip, whichfork);
+	if (error)
+		return error;
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
@@ -6031,11 +6021,9 @@ xfs_bmap_insert_extents(
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(tp, ip, whichfork);
-		if (error)
-			return error;
-	}
+	error = xfs_iread_extents(tp, ip, whichfork);
+	if (error)
+		return error;
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
@@ -6134,12 +6122,10 @@ xfs_bmap_split_extent(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		/* Read in all the extents */
-		error = xfs_iread_extents(tp, ip, whichfork);
-		if (error)
-			return error;
-	}
+	/* Read in all the extents */
+	error = xfs_iread_extents(tp, ip, whichfork);
+	if (error)
+		return error;
 
 	/*
 	 * If there are not extents, or split_fsb lies in a hole we are done.
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 33559c3a4bc3d4..fb50ec9a4303a1 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -449,11 +449,10 @@ xchk_bmap_btree(
 
 	/* Load the incore bmap cache if it's not loaded. */
 	info->was_loaded = ifp->if_flags & XFS_IFEXTENTS;
-	if (!info->was_loaded) {
-		error = xfs_iread_extents(sc->tp, ip, whichfork);
-		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
-			goto out;
-	}
+
+	error = xfs_iread_extents(sc->tp, ip, whichfork);
+	if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
+		goto out;
 
 	/* Check the btree structure. */
 	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e7d68318e6a55c..e7f9537634f3cf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -225,11 +225,9 @@ xfs_bmap_count_blocks(
 
 	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_BTREE:
-		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-			error = xfs_iread_extents(tp, ip, whichfork);
-			if (error)
-				return error;
-		}
+		error = xfs_iread_extents(tp, ip, whichfork);
+		if (error)
+			return error;
 
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		error = xfs_btree_count_blocks(cur, &btblocks);
@@ -471,11 +469,9 @@ xfs_getbmap(
 	first_bno = bno = XFS_BB_TO_FSBT(mp, bmv->bmv_offset);
 	len = XFS_BB_TO_FSB(mp, bmv->bmv_length);
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, whichfork);
-		if (error)
-			goto out_unlock_ilock;
-	}
+	error = xfs_iread_extents(NULL, ip, whichfork);
+	if (error)
+		goto out_unlock_ilock;
 
 	if (!xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got)) {
 		/*
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 66deddd5e29698..477df4869d19bd 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -258,11 +258,9 @@ xfs_dir2_leaf_readbuf(
 	int			ra_want;
 	int			error = 0;
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
-		if (error)
-			goto out;
-	}
+	error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
+	if (error)
+		goto out;
 
 	/*
 	 * Look for mapped directory blocks at or above the current offset.
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bd8379b98374f8..83c5334fe978f2 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -748,11 +748,9 @@ xfs_dq_get_next_id(
 	start = (xfs_fsblock_t)next_id / mp->m_quotainfo->qi_dqperchunk;
 
 	lock_flags = xfs_ilock_data_map_shared(quotip);
-	if (!(quotip->i_df.if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
-		if (error)
-			return error;
-	}
+	error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
+	if (error)
+		return error;
 
 	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
 		/* contiguous chunk, bump startoff for the id calculation */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e17ab7f42928a5..129a0bafb46c0d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -893,11 +893,9 @@ xfs_buffered_write_iomap_begin(
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
 
-	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
-		if (error)
-			goto out_unlock;
-	}
+	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+	if (error)
+		goto out_unlock;
 
 	/*
 	 * Search the data fork first to look up our source mapping.  We
@@ -1208,11 +1206,9 @@ xfs_seek_iomap_begin(
 		return -EIO;
 
 	lockmode = xfs_ilock_data_map_shared(ip);
-	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
-		if (error)
-			goto out_unlock;
-	}
+	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+	if (error)
+		goto out_unlock;
 
 	if (xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap)) {
 		/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6fde318b9fed27..fd835a202c51eb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1165,11 +1165,9 @@ xfs_qm_dqusage_adjust(
 	if (XFS_IS_REALTIME_INODE(ip)) {
 		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 
-		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-			error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
-			if (error)
-				goto error0;
-		}
+		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
+		if (error)
+			goto error0;
 
 		xfs_bmap_count_leaves(ifp, &rtblks);
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 725c7d8e44381b..13cd62b89c4e30 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1392,11 +1392,9 @@ xfs_reflink_inode_has_shared_extents(
 	int				error;
 
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
-		if (error)
-			return error;
-	}
+	error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
+	if (error)
+		return error;
 
 	*has_shared = false;
 	found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got);
-- 
2.30.1

