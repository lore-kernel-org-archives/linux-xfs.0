Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713D0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiLaAMq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiLaAMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:12:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666F760EF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:12:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 021BC61CE3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D8EC433D2;
        Sat, 31 Dec 2022 00:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445563;
        bh=cgz9gijUdM5wAlvrjoqIXTZS9ZyLOGqAJiH75qW4eps=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lz+xyrG3HPaD70UqueqVKg91e4zUklE20+N3zJ0vAgJu/7Sq7YC6b42QpQPgf0b8z
         vko6eBqcWX2Dttx/7eOmpce11sZGQaFNV01Xoin/gFpgylAOLl45mpQiRMJMw4nJw1
         JkBIDyouhS1F2PM/q7NrwIfgreNgnnCzE1dMYf3WiOnBZ2aji6/C/0op3jlDpwTZ19
         CfZ1ejPB3bn2ZsFn47W+XDMQX25xVdA3ALvW3gAx4oVg/bjI2FPZgc298PIhYsIx04
         t+JpvmNqMG0CFgcwhFQI4twzqkiItG4r8gMOwWdIDAo+uQCq82FHtzQcuQ8G2jXw//
         m6HOTdhl6o2Xg==
Subject: [PATCH 6/9] xfs: consolidate btree block allocation tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:42 -0800
Message-ID: <167243866237.711834.18080247135876736641.stgit@magnolia>
In-Reply-To: <167243866153.711834.17585439086893346840.stgit@magnolia>
References: <167243866153.711834.17585439086893346840.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't waste tracepoint segment memory on per-btree block allocation
tracepoints when we can do it from the generic btree code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h         |    4 +---
 libxfs/xfs_btree.c          |   20 +++++++++++++++++---
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 --
 4 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 0a7581b5794..3ca6cda253c 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -62,6 +62,7 @@
 #define trace_xfs_btree_bload_level_geometry(a,b,c,d,e,f,g) ((void) 0)
 #define trace_xfs_btree_bload_block(a,b,c,d,e,f) ((void) 0)
 #define trace_xfs_btree_free_block(...)		((void) 0)
+#define trace_xfs_btree_alloc_block(...)	((void) 0)
 
 #define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
@@ -244,8 +245,6 @@
 #define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
 #define trace_xfs_rmap_lookup_le_range_result(...)	((void) 0)
 
-#define trace_xfs_rmapbt_alloc_block(...)	((void) 0)
-
 #define trace_xfs_ag_resv_critical(...)		((void) 0)
 #define trace_xfs_ag_resv_needed(...)		((void) 0)
 #define trace_xfs_ag_resv_free(...)		((void) 0)
@@ -263,7 +262,6 @@
 #define trace_xfs_refcount_insert_error(...)	((void) 0)
 #define trace_xfs_refcount_delete(...)		((void) 0)
 #define trace_xfs_refcount_delete_error(...)	((void) 0)
-#define trace_xfs_refcountbt_alloc_block(...)	((void) 0)
 #define trace_xfs_refcount_rec_order_error(...)	((void) 0)
 
 #define trace_xfs_refcount_lookup(...)		((void) 0)
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index d7501da87ce..cd722d1c830 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -2690,6 +2690,20 @@ xfs_btree_rshift(
 	return error;
 }
 
+static inline int
+xfs_btree_alloc_block(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*hint_block,
+	union xfs_btree_ptr		*new_block,
+	int				*stat)
+{
+	int				error;
+
+	error = cur->bc_ops->alloc_block(cur, hint_block, new_block, stat);
+	trace_xfs_btree_alloc_block(cur, new_block, *stat, error);
+	return error;
+}
+
 /*
  * Split cur/level block in half.
  * Return new block number and the key to its first
@@ -2733,7 +2747,7 @@ __xfs_btree_split(
 	xfs_btree_buf_to_ptr(cur, lbp, &lptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &lptr, &rptr, stat);
+	error = xfs_btree_alloc_block(cur, &lptr, &rptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -2999,7 +3013,7 @@ xfs_btree_new_iroot(
 	pp = xfs_btree_ptr_addr(cur, 1, block);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, pp, &nptr, stat);
+	error = xfs_btree_alloc_block(cur, pp, &nptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -3099,7 +3113,7 @@ xfs_btree_new_root(
 	cur->bc_ops->init_ptr_from_cur(cur, &rptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, stat);
+	error = xfs_btree_alloc_block(cur, &rptr, &lptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index c1dd2fe8d37..ec30077bd49 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -76,8 +76,6 @@ xfs_refcountbt_alloc_block(
 	error = xfs_alloc_vextent(&args);
 	if (error)
 		goto out_error;
-	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			args.agbno, 1);
 	if (args.fsbno == NULLFSBLOCK) {
 		*stat = 0;
 		return 0;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 36f6714ed3f..928f61053b0 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -92,8 +92,6 @@ xfs_rmapbt_alloc_block(
 				       &bno, 1);
 	if (error)
 		return error;
-
-	trace_xfs_rmapbt_alloc_block(cur->bc_mp, pag->pag_agno, bno, 1);
 	if (bno == NULLAGBLOCK) {
 		*stat = 0;
 		return 0;

