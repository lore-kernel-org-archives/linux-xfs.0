Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24ECC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiL3XqU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235749AbiL3XqT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:46:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B63564FA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:46:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDB6DB81DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFB5C433D2;
        Fri, 30 Dec 2022 23:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443975;
        bh=AU0HhtmNhthWnxu0B/J6r4DtmTbXfzxLghBxLrz451Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ohXlNXMaPqdmdjp3QfDDsiEpfPjg2ztKNlNQ/Er1SwKygC3IyoZc1Low626Yd/0Ue
         h3HbicLKNY15Llb3fuTbSsLErBRp3/yOsfskV4KuFLip8lMuejn/PYZBFtvoixGuJO
         5V8znyv0p1uyaH0D0pkoxba+Rl/P/A9gUCqvY2Br/jLU8v0a3gGUAY2mkTa5rIzjxz
         0CBGOUuwH0jGq5tWBQKmm/p0LZHDTKZoWKe2c5NOaO5ewN9OvunNR+2SoOslTx7RDl
         lirzr0z8EYwtsB0s+l3b/41dxv22ZEW/JLAGTsSMYMlS/1iJ0M9Xazigy5zSSVLLVd
         4phA9o1CikhYw==
Subject: [PATCH 9/9] xfs: remove unnecessary fields in xfbtree_config
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:35 -0800
Message-ID: <167243841499.696890.9438947017938864280.stgit@magnolia>
In-Reply-To: <167243841359.696890.6518296492918665756.stgit@magnolia>
References: <167243841359.696890.6518296492918665756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove these fields now that we get all the info we need from the btree
ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_mem.h  |    9 ---------
 fs/xfs/libxfs/xfs_rmap_btree.c |    1 -
 fs/xfs/scrub/trace.h           |   10 ++++------
 fs/xfs/scrub/xfbtree.c         |    4 ++--
 4 files changed, 6 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
index 5e7b1f20fb5b..ee142b972839 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.h
+++ b/fs/xfs/libxfs/xfs_btree_mem.h
@@ -17,17 +17,8 @@ struct xfbtree_config {
 
 	/* Owner of this btree. */
 	unsigned long long		owner;
-
-	/* Btree type number */
-	xfs_btnum_t			btnum;
-
-	/* XFBTREE_CREATE_* flags */
-	unsigned int			flags;
 };
 
-/* btree has long pointers */
-#define XFBTREE_CREATE_LONG_PTRS	(1U << 0)
-
 #ifdef CONFIG_XFS_IN_MEMORY_BTREE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 31dc40358bf9..ebd86c559837 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -669,7 +669,6 @@ xfs_rmapbt_mem_create(
 	struct xfbtree_config	cfg = {
 		.btree_ops	= &xfs_rmapbt_mem_ops,
 		.target		= target,
-		.btnum		= XFS_BTNUM_RMAP,
 		.owner		= agno,
 	};
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index dc0547691fe4..213134d812e8 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2013,8 +2013,7 @@ TRACE_EVENT(xfbtree_create,
 		 struct xfbtree *xfbt),
 	TP_ARGS(mp, cfg, xfbt),
 	TP_STRUCT__entry(
-		__field(xfs_btnum_t, btnum)
-		__field(unsigned int, xfbtree_flags)
+		__field(const void *, btree_ops)
 		__field(unsigned long, xfino)
 		__field(unsigned int, leaf_mxr)
 		__field(unsigned int, leaf_mnr)
@@ -2023,8 +2022,7 @@ TRACE_EVENT(xfbtree_create,
 		__field(unsigned long long, owner)
 	),
 	TP_fast_assign(
-		__entry->btnum = cfg->btnum;
-		__entry->xfbtree_flags = cfg->flags;
+		__entry->btree_ops = cfg->btree_ops;
 		__entry->xfino = xfbtree_ino(xfbt);
 		__entry->leaf_mxr = xfbt->maxrecs[0];
 		__entry->node_mxr = xfbt->maxrecs[1];
@@ -2032,9 +2030,9 @@ TRACE_EVENT(xfbtree_create,
 		__entry->node_mnr = xfbt->minrecs[1];
 		__entry->owner = cfg->owner;
 	),
-	TP_printk("xfino 0x%lx btnum %s owner 0x%llx leaf_mxr %u leaf_mnr %u node_mxr %u node_mnr %u",
+	TP_printk("xfino 0x%lx btree_ops %pS owner 0x%llx leaf_mxr %u leaf_mnr %u node_mxr %u node_mnr %u",
 		  __entry->xfino,
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->btree_ops,
 		  __entry->owner,
 		  __entry->leaf_mxr,
 		  __entry->leaf_mnr,
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index ac7b9f679b56..072e1d8b813e 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -384,7 +384,7 @@ xfbtree_rec_bytes(
 {
 	unsigned int			blocklen = xfo_to_b(1);
 
-	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS) {
+	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS) {
 		if (xfs_has_crc(mp))
 			return blocklen - XFS_BTREE_LBLOCK_CRC_LEN;
 
@@ -481,7 +481,7 @@ xfbtree_create(
 	xbitmap_init(xfbt->freespace);
 
 	/* Set up min/maxrecs for this btree. */
-	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS)
+	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS)
 		keyptr_len += sizeof(__be64);
 	else
 		keyptr_len += sizeof(__be32);

