Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83442C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiL3XWA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbiL3XVz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:21:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1463A1D0E9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:21:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B453DB81DA2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7DDC433D2;
        Fri, 30 Dec 2022 23:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442511;
        bh=5qRMXIpMuRNAgYIEQqyImNUeq6kYsggRyd9GeAkezrs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CmMg9aEZRC5Bz+CQcswl6M/osx1XYjVRO/URam8UZYA1rXp8CEO9yINyiPh4AOIJ1
         KoeTxtgWdXTj2OkF2O9MvId3EgqnYZah5Ld7mYX7yIhEtj0loGJBM9JxJbGs0kDM6q
         H0wdh1YZEUl/R9g/Qjzp3aY5wuYIpe3TzFdXfx1clibIiM5enorTbPi5UBpihcVxNJ
         xys5fQ1YTQDaDip9tCNSeQ2jCI6K29MfsxQDLb+0VHAhk+ea1c4d2EozBfKld9MdL0
         KhcNNHb5C/Nv2W2I6+Tq+NzfGTyMGalhxef6DAXY8h9BG8L6ToN1vw4UHUEMRp6yrM
         KGGBwr/J9Tmag==
Subject: [PATCH 7/9] xfs: ignore stale buffers when scanning the buffer cache
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834781.691918.1431626950635466750.stgit@magnolia>
In-Reply-To: <167243834673.691918.7562784486565988430.stgit@magnolia>
References: <167243834673.691918.7562784486565988430.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

After an online repair, we need to invalidate buffers representing the
blocks from the old metadata that we're replacing.  It's possible that
parts of a tree that were previously cached in memory are no longer
accessible due to media failure or other corruption on interior nodes,
so repair figures out the old blocks from the reverse mapping data and
scans the buffer cache directly.

Unfortunately, the current buffer cache code triggers asserts if the
rhashtable lookup finds a non-stale buffer of a different length than
the key we searched for.  For regular operation this is desirable, but
for this repair procedure, we don't care since we're going to forcibly
stale the buffer anyway.  Add an internal lookup flag to avoid the
assert.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |    2 +-
 fs/xfs/xfs_buf.c    |    5 ++++-
 fs/xfs/xfs_buf.h    |   10 ++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 00cdc0e9063e..a329235b039b 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -149,7 +149,7 @@ xrep_block_reap_binval(
 	 */
 	error = xfs_buf_incore(sc->mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(sc->mp, fsbno),
-			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp);
+			XFS_FSB_TO_BB(sc->mp, 1), XBF_BCACHE_SCAN, &bp);
 	if (error)
 		return;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 54c774af6e1c..a538501b652b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -482,7 +482,8 @@ _xfs_buf_obj_cmp(
 		 * reallocating a busy extent. Skip this buffer and
 		 * continue searching for an exact match.
 		 */
-		ASSERT(bp->b_flags & XBF_STALE);
+		if (!(map->bm_flags & XBM_IGNORE_LENGTH_MISMATCH))
+			ASSERT(bp->b_flags & XBF_STALE);
 		return 1;
 	}
 	return 0;
@@ -683,6 +684,8 @@ xfs_buf_get_map(
 	int			error;
 	int			i;
 
+	if (flags & XBF_BCACHE_SCAN)
+		cmap.bm_flags |= XBM_IGNORE_LENGTH_MISMATCH;
 	for (i = 0; i < nmaps; i++)
 		cmap.bm_len += map[i].bm_len;
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 549c60942208..d6e8c3bab9f6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -44,6 +44,11 @@ struct xfs_buf;
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
 
 /* flags used only as arguments to access routines */
+/*
+ * We're scanning the buffer cache; do not warn about lookup mismatches.
+ * Only online repair should use this.
+ */
+#define XBF_BCACHE_SCAN	 (1u << 28)
 #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
 #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
 #define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
@@ -67,6 +72,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
+	{ XBF_BCACHE_SCAN,	"BCACHE_SCAN" }, \
 	{ XBF_INCORE,		"INCORE" }, \
 	{ XBF_TRYLOCK,		"TRYLOCK" }, \
 	{ XBF_UNMAPPED,		"UNMAPPED" }
@@ -114,8 +120,12 @@ typedef struct xfs_buftarg {
 struct xfs_buf_map {
 	xfs_daddr_t		bm_bn;	/* block number for I/O */
 	int			bm_len;	/* size of I/O */
+	unsigned int		bm_flags;
 };
 
+/* Don't complain about live buffers with the wrong length during lookup. */
+#define XBM_IGNORE_LENGTH_MISMATCH	(1U << 0)
+
 #define DEFINE_SINGLE_BUF_MAP(map, blkno, numblk) \
 	struct xfs_buf_map (map) = { .bm_bn = (blkno), .bm_len = (numblk) };
 

