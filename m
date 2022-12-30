Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C6FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiLaAMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiLaAMb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:12:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3D9102E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DC9B81E07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCF9C433D2;
        Sat, 31 Dec 2022 00:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445547;
        bh=xetoTG19L9IIBcjn1e0GZ9FHC/r7WxpFxy2COu9FuL0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hyadrQeg3lvtvghts8SMP8nuKflPao9Af8aSKdyfOPdA9mvzxsViNy3WKUeU0KZzn
         HOlSWR+k8uHmp0l/IR5rqR/AeC3b8yRxKjsYI5HjPYar5GatAW82RoYnD3G9zXzn9b
         k95o9eiVKk9aENftqhGwQhajch0RAhsC/PW5JuXlAa1ZcvNIaVg1SUE6txEIrZLgUk
         1NR6pYeNDniWIlDwiI/ElFnZQtpa7BnHugkuGH/uvOZjCjxf4mmUoGA7Vt2LjIDxqz
         xiXsIul++K9gdz3WLw/tph4sBOo1p52QSvJ89O7pREL5o+/vpTWW0vgohNNknEMuBt
         QFXIl6YJ0YwAA==
Subject: [PATCH 5/9] xfs: consolidate btree block freeing tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:42 -0800
Message-ID: <167243866224.711834.5671254620893854013.stgit@magnolia>
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

Don't waste tracepoint segment memory on per-btree block freeing
tracepoints when we can do it from the generic btree code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h         |    3 +--
 libxfs/xfs_btree.c          |    2 ++
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 --
 4 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 19b05f6e25e..0a7581b5794 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -61,6 +61,7 @@
 #define trace_xfs_btree_commit_ifakeroot(a)	((void) 0)
 #define trace_xfs_btree_bload_level_geometry(a,b,c,d,e,f,g) ((void) 0)
 #define trace_xfs_btree_bload_block(a,b,c,d,e,f) ((void) 0)
+#define trace_xfs_btree_free_block(...)		((void) 0)
 
 #define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
@@ -243,7 +244,6 @@
 #define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
 #define trace_xfs_rmap_lookup_le_range_result(...)	((void) 0)
 
-#define trace_xfs_rmapbt_free_block(...)	((void) 0)
 #define trace_xfs_rmapbt_alloc_block(...)	((void) 0)
 
 #define trace_xfs_ag_resv_critical(...)		((void) 0)
@@ -263,7 +263,6 @@
 #define trace_xfs_refcount_insert_error(...)	((void) 0)
 #define trace_xfs_refcount_delete(...)		((void) 0)
 #define trace_xfs_refcount_delete_error(...)	((void) 0)
-#define trace_xfs_refcountbt_free_block(...)	((void) 0)
 #define trace_xfs_refcountbt_alloc_block(...)	((void) 0)
 #define trace_xfs_refcount_rec_order_error(...)	((void) 0)
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index e0b9f075015..d7501da87ce 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -411,6 +411,8 @@ xfs_btree_free_block(
 {
 	int			error;
 
+	trace_xfs_btree_free_block(cur, bp);
+
 	error = cur->bc_ops->free_block(cur, bp);
 	if (!error) {
 		xfs_trans_binval(cur->bc_tp, bp);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 0a8e80e705f..c1dd2fe8d37 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -107,8 +107,6 @@ xfs_refcountbt_free_block(
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	int			error;
 
-	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	error = xfs_free_extent(cur->bc_tp, cur->bc_ag.pag,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index e8ffb23be42..36f6714ed3f 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -123,8 +123,6 @@ xfs_rmapbt_free_block(
 	int			error;
 
 	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
-	trace_xfs_rmapbt_free_block(cur->bc_mp, pag->pag_agno,
-			bno, 1);
 	be32_add_cpu(&agf->agf_rmap_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
 	error = xfs_alloc_put_freelist(pag, cur->bc_tp, agbp, NULL, bno, 1);

