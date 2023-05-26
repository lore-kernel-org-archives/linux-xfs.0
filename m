Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8FDC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbjEZApA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239896AbjEZAov (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:44:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CD1195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DF58616EF
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC32BC433D2;
        Fri, 26 May 2023 00:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061888;
        bh=qX63S54CCFrmm1d+RbL713OSMzj8rEsvf4I5QDUwFhw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=DLkiCl0ZBnTW1rupDsFLj/XH/wR7zY83vjLu2bKOGt8sPfrLlgaAtHRSlXdYuU+LT
         rRpUj+wqhctC+B94WJfg+9J9MraJU9MfHeY6yfni9wJzKpMIvB40v8ILTiNuikb75G
         c/ONWKg0nEEkBJQriVKe6de/HA2YfCf4RKFRvj0g5cDB6zVEnGMROH5KV1ygObFg1Q
         Gb9FIzsxWrZ6V3imascdQGRygL3bPGyAnnC/wdivcSh+rsUz0myrUsb//9Bwdp74Vw
         jDKWSG6WQKPTxyLOOapnp/00wfkCmgjzGnauhhexsG2IF9d9QMzRke6kjh5GOPbU0O
         8DfFt/ZWkCRDg==
Date:   Thu, 25 May 2023 17:44:48 -0700
Subject: [PATCH 7/9] xfs: ignore stale buffers when scanning the buffer cache
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055718.3728180.15781485173918712234.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
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
index 30e61315feb0..ca75c22481d2 100644
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
index 15d1e5a7c2d3..b31e6d09a056 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -481,7 +481,8 @@ _xfs_buf_obj_cmp(
 		 * reallocating a busy extent. Skip this buffer and
 		 * continue searching for an exact match.
 		 */
-		ASSERT(bp->b_flags & XBF_STALE);
+		if (!(map->bm_flags & XBM_IGNORE_LENGTH_MISMATCH))
+			ASSERT(bp->b_flags & XBF_STALE);
 		return 1;
 	}
 	return 0;
@@ -682,6 +683,8 @@ xfs_buf_get_map(
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
 

