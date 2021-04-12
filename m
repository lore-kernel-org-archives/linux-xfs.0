Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF17C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F54160FDB
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241906AbhDLNin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbhDLNin (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 09:38:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB882C061574
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 06:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kv5Vxv9uRKnDplC5FNpdxjahI69hl9Gw2336AEGhdA4=; b=y5l1w4G0VSeyVllHFiQbsEw2mq
        wsP5t+itNOpEPZsoSJU9o/xOOsIVU2417jY3iHpojCOIs/ZYdXMhLUsGLmZ5icPxOk7A34MQhKOyY
        qi+tAioooervbYRyC6dOEFtQzg4aw0IVIDPnwSyqh+gEbuV3w8NX5hlc1SYPn5E+9evJM+SWHcFHd
        /7k4YvJaGedVKbCKW+OEKu5GivzicdX1SX+vOCoSForCToGb53Glb7+5z6CZ2SDc0xJfGFzBFA9Dj
        QNSZXpz0kg2Gfl+Llw2gkyB2bcZ12k5VeirqIeIkysG6cI/e/KYICRMqqD9tVdV9l9FThSK2Lr7Wk
        LQepxl/A==;
Received: from [2001:4bb8:199:e2bd:3218:1918:85d1:2852] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVwlk-006H05-IE; Mon, 12 Apr 2021 13:38:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/7] xfs: move the XFS_IFEXTENTS check into xfs_iread_extents
Date:   Mon, 12 Apr 2021 15:38:13 +0200
Message-Id: <20210412133819.2618857-2-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210412133819.2618857-1-hch@lst.de>
References: <20210412133819.2618857-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the XFS_IFEXTENTS check from the callers into xfs_iread_extents to
simplify the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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
index 402ecd6103605e..1b1b58af41fa7f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1227,6 +1227,9 @@ xfs_iread_extents(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
+	if (ifp->if_flags & XFS_IFEXTENTS)
+		return 0;
+
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_CORRUPT(mp, ifp->if_format != XFS_DINODE_FMT_BTREE)) {
@@ -1284,11 +1287,9 @@ xfs_bmap_first_unused(
 
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
@@ -1336,11 +1337,9 @@ xfs_bmap_last_before(
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
@@ -1359,11 +1358,9 @@ xfs_bmap_last_extent(
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
@@ -3991,11 +3988,9 @@ xfs_bmapi_read(
 
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
@@ -4475,11 +4470,9 @@ xfs_bmapi_write(
 
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
@@ -4758,11 +4751,9 @@ xfs_bmapi_remap(
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
@@ -5433,9 +5424,10 @@ __xfs_bunmapi(
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
@@ -5921,11 +5913,9 @@ xfs_bmap_collapse_extents(
 
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
@@ -6038,11 +6028,9 @@ xfs_bmap_insert_extents(
 
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
@@ -6141,12 +6129,10 @@ xfs_bmap_split_extent(
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
index 613e2aa7e4e7f1..924d7e343731de 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -448,11 +448,10 @@ xchk_bmap_btree(
 
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
index e79e3d1ff38dfe..1c7116abff0d69 100644
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
index 03e7c39a07807a..1d2fe48ad19fb7 100644
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
index 7fb63a04400fab..ecd5059d6928f7 100644
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
index 9c7bd2d94d8d89..d37d42e554a12b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -894,11 +894,9 @@ xfs_buffered_write_iomap_begin(
 
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
@@ -1209,11 +1207,9 @@ xfs_seek_iomap_begin(
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
index 134d5a11eb2205..4bf949a89d0d6d 100644
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
index 323506a6b33947..4dd4af6ac2ef53 100644
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

