Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EA9C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjEZBKW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZBKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3FC9B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABFBC60B88
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E14C433EF;
        Fri, 26 May 2023 01:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063419;
        bh=lx57eXRaEmWFfFHfqIUgLxEqXRAmx6dqpXAJXiZuFjY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=LN6oe808+37VPG5fE9IWq5t99IkcmrAIGPqobmCe9V2GEGZ/LJ71okd1V+02weAdr
         ys3On7FIJkyu4cNPAJcio7KkivAhhIWiWRr7Py/ln+re00qhXKJbRzxll2ncsz/YKE
         yIgbziMmOI+tXclXjXH8pAXySqpIDnWYAJj62/HAGTRhS1lEFfaug99/SZ9C1QhRFd
         QqzxzNpXlTVcyQDGFZuDDYKTNk+wsdmG0UBfVyUzy4cMUNm20jEhsNj2qngir4+jCZ
         bxizP5BBRsNbd/IofRziMoc/IJjzc9vIj9jv2+HMwUR6g+oVKPQBQcL9GAzAF89P2A
         /HDeDvJGoHDyQ==
Date:   Thu, 25 May 2023 18:10:18 -0700
Subject: [PATCH 9/9] xfs: remove unnecessary fields in xfbtree_config
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062811.3733506.3833741911122802454.stgit@frogsfrogsfrogs>
In-Reply-To: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
References: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
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
index c82d3e6d220a..3951ef56e534 100644
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
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 4e944eb83480..ce4f05a476e9 100644
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
index e1e6dca0f7f6..ecb01592a39b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2065,8 +2065,7 @@ TRACE_EVENT(xfbtree_create,
 		 struct xfbtree *xfbt),
 	TP_ARGS(mp, cfg, xfbt),
 	TP_STRUCT__entry(
-		__field(xfs_btnum_t, btnum)
-		__field(unsigned int, xfbtree_flags)
+		__field(const void *, btree_ops)
 		__field(unsigned long, xfino)
 		__field(unsigned int, leaf_mxr)
 		__field(unsigned int, leaf_mnr)
@@ -2075,8 +2074,7 @@ TRACE_EVENT(xfbtree_create,
 		__field(unsigned long long, owner)
 	),
 	TP_fast_assign(
-		__entry->btnum = cfg->btnum;
-		__entry->xfbtree_flags = cfg->flags;
+		__entry->btree_ops = cfg->btree_ops;
 		__entry->xfino = xfbtree_ino(xfbt);
 		__entry->leaf_mxr = xfbt->maxrecs[0];
 		__entry->node_mxr = xfbt->maxrecs[1];
@@ -2084,9 +2082,9 @@ TRACE_EVENT(xfbtree_create,
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
index b5874e3f39da..b9a9ee88dc53 100644
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

