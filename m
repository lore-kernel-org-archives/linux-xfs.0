Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B511BC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBPUoK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBPUoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:44:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B29F505D0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:44:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1796460A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8FDC433EF;
        Thu, 16 Feb 2023 20:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580247;
        bh=Adze65CflRsdJVAyGnJNs9/A1obIuV4khXalxpAablE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=s36Rlsua6sLi2cqQwjQDmmAe5ENzTeCHxhBqPYXEQCdTtkRdkqSIiejccPOGqWBcC
         IfeH6LCHF8vllO1IE+A9gyXuoKun3iM834a9xQ/KdVdfEAbCZYFazxTKyh02zHgGgl
         SWZc7StGFyrVPUMijFVGcJmG2T+8P5xocvJpshiUFfLT2v7q6jquJBbrDr6vc65ym5
         DjaiCSv5ZdQ2NZ3Hm+XWS1tc97fiOnJtq9dIvjWpaZ9E4YCgXXcQPLplzEENnOwABr
         0JNSmXHKz7n22a/Ahe1Ex4PanGJYF5TQGgfY32iA6Tob1wJ6CzV7O6GxrxmFB6JbuO
         MJg3cLtNxSsbA==
Date:   Thu, 16 Feb 2023 12:44:07 -0800
Subject: [PATCH 09/23] xfs: ignore stale buffers when scanning the buffer
 cache
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873964.3474338.12221305414915817753.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
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
 fs/xfs/xfs_buf.c |    5 ++++-
 fs/xfs/xfs_buf.h |   10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)


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
 

