Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F601EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjG0WXS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjG0WXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:23:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE19C2D71
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BB9161F3E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99034C433C7;
        Thu, 27 Jul 2023 22:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496594;
        bh=fkA+szUV8WYI0DHJozqKUtn2WJqEdjPGs068xUDJv5c=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=r03/2QDaDm/sGtMnrBkd+3m9t93sdKzxp02V0aa8zicwZDa5UcDujS57viNKSVVAo
         ylLSPKQkzM8F4HgYKI2HWSWXDAGKuHP5OBJxa5p3y39pQGq4kpwe04LlLZaTDZ3eXZ
         BOfGosjakRhsWuOU3dCWYdGP1oLo/vvuNxRJR+6ss+qKlVKiZvyQ8quSeINBDkeoDR
         wdu9mLMEYL2MO2LNv7KgQDRzlHozXdczc+wDVcgdONNR4d26/Y0EWaF7cX+/YUGuJO
         XMdQGC2gVdnDiBFDk+PlrfH5CD6VPrLQ5ca7AFwRaARhAGpiJSX3aFaS7lpZCdD34/
         z3+iaG6wD1ukQ==
Date:   Thu, 27 Jul 2023 15:23:14 -0700
Subject: [PATCH 7/9] xfs: allow scanning ranges of the buffer cache for live
 buffers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049622831.921010.410578297835897388.stgit@frogsfrogsfrogs>
In-Reply-To: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
References: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
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

In other words, online fsck needs to find all the live (i.e. non-stale)
buffers for a range of fsblocks so that it can invalidate them.

Unfortunately, the current buffer cache code triggers asserts if the
rhashtable lookup finds a non-stale buffer of a different length than
the key we searched for.  For regular operation this is desirable, but
for this repair procedure, we don't care since we're going to forcibly
stale the buffer anyway.  Add an internal lookup flag to avoid the
assert.  Skip buffers that are already XBF_STALE.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |    2 +-
 fs/xfs/xfs_buf.c    |    9 ++++++++-
 fs/xfs/xfs_buf.h    |   13 +++++++++++++
 3 files changed, 22 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 847c6f8361021..df13a9e0fe86a 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -149,7 +149,7 @@ xrep_block_reap_binval(
 	 */
 	error = xfs_buf_incore(sc->mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(sc->mp, fsbno),
-			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp);
+			XFS_FSB_TO_BB(sc->mp, 1), XBF_LIVESCAN, &bp);
 	if (error)
 		return;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15d1e5a7c2d34..fa392c43ba166 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -481,7 +481,8 @@ _xfs_buf_obj_cmp(
 		 * reallocating a busy extent. Skip this buffer and
 		 * continue searching for an exact match.
 		 */
-		ASSERT(bp->b_flags & XBF_STALE);
+		if (!(map->bm_flags & XBM_LIVESCAN))
+			ASSERT(bp->b_flags & XBF_STALE);
 		return 1;
 	}
 	return 0;
@@ -559,6 +560,10 @@ xfs_buf_find_lock(
 	 * intact here.
 	 */
 	if (bp->b_flags & XBF_STALE) {
+		if (flags & XBF_LIVESCAN) {
+			xfs_buf_unlock(bp);
+			return -ENOENT;
+		}
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
 		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
 		bp->b_ops = NULL;
@@ -682,6 +687,8 @@ xfs_buf_get_map(
 	int			error;
 	int			i;
 
+	if (flags & XBF_LIVESCAN)
+		cmap.bm_flags |= XBM_LIVESCAN;
 	for (i = 0; i < nmaps; i++)
 		cmap.bm_len += map[i].bm_len;
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 549c60942208b..df8f47953bb4e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -44,6 +44,11 @@ struct xfs_buf;
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
 
 /* flags used only as arguments to access routines */
+/*
+ * Online fsck is scanning the buffer cache for live buffers.  Do not warn
+ * about length mismatches during lookups and do not return stale buffers.
+ */
+#define XBF_LIVESCAN	 (1u << 28)
 #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
 #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
 #define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
@@ -67,6 +72,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
+	{ XBF_LIVESCAN,		"LIVESCAN" }, \
 	{ XBF_INCORE,		"INCORE" }, \
 	{ XBF_TRYLOCK,		"TRYLOCK" }, \
 	{ XBF_UNMAPPED,		"UNMAPPED" }
@@ -114,8 +120,15 @@ typedef struct xfs_buftarg {
 struct xfs_buf_map {
 	xfs_daddr_t		bm_bn;	/* block number for I/O */
 	int			bm_len;	/* size of I/O */
+	unsigned int		bm_flags;
 };
 
+/*
+ * Online fsck is scanning the buffer cache for live buffers.  Do not warn
+ * about length mismatches during lookups and do not return stale buffers.
+ */
+#define XBM_LIVESCAN		(1U << 0)
+
 #define DEFINE_SINGLE_BUF_MAP(map, blkno, numblk) \
 	struct xfs_buf_map (map) = { .bm_bn = (blkno), .bm_len = (numblk) };
 

