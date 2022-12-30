Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579D9C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiL3Wgg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiL3Wgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:36:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2A01114
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:36:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DD8061645
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB037C433D2;
        Fri, 30 Dec 2022 22:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439793;
        bh=BA45CchuKqmHTLADak6FNoUfg4ulwmrRDgswfILuXwM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZDBKlBYg69+fzg3MNs33ScM1MF6yPdl4zQmzcuAsCzrgu724qhB3IX5AXCGZBLjek
         qWBddvoB+QXJ7hAhJZyZpgT7qeeISFfoF5JpsXZtZmW20+hLH1o6kPM6HGt3c2aweM
         BLCuYF0t4Vx7Y5P1Jt8B8L8YUPRLhtKy8HRVcWOtDDvZ7ZEuD5VsRlGQYpu4jJ83h0
         AGjAm6+92WM6d5KkkEvOcpyYQLXbaEwttZx0JioSgC6OCEtKyuuTuKXpGYqR8DdMnA
         0QN50jklfRAaYYzqoTVsqgT66LqJ6uAS3eHxFV13lQyXxmCkTzYK7WtomxsXI2vQrS
         juJR8STQ5xXHQ==
Subject: [PATCH 1/1] xfs: create a function to duplicate an active perag
 reference
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:04 -0800
Message-ID: <167243826451.683615.8962179924574213683.stgit@magnolia>
In-Reply-To: <167243826436.683615.15521013040575221575.stgit@magnolia>
References: <167243826436.683615.15521013040575221575.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There a few object constructor functions throughout XFS where a caller
provides an active perag reference and the constructor wants to give the
new object its own active reference.  Replace the open-coded logic with
a common function to do this instead of open-coding atomic_inc logic.

This new function adds a few safeguards -- it checks that there's at
least one active reference to the perag structure passed in, and it
records the refcount bump in the ftrace information.  This makes it much
easier to debug refcounting problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c             |   15 +++++++++++++++
 fs/xfs/libxfs/xfs_ag.h             |    1 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |    4 +---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    4 +---
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +----
 fs/xfs/libxfs/xfs_rmap_btree.c     |    5 +----
 fs/xfs/xfs_iunlink_item.c          |    4 +---
 fs/xfs/xfs_iwalk.c                 |    3 +--
 fs/xfs/xfs_trace.h                 |    1 +
 9 files changed, 23 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 8de4143a5899..fed965831f2d 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -57,6 +57,21 @@ xfs_perag_get(
 	return pag;
 }
 
+/* Get our own reference to a perag, given an existing active reference. */
+struct xfs_perag *
+xfs_perag_bump(
+	struct xfs_perag	*pag)
+{
+	if (!atomic_inc_not_zero(&pag->pag_ref)) {
+		ASSERT(0);
+		return NULL;
+	}
+
+	trace_xfs_perag_bump(pag->pag_mount, pag->pag_agno,
+			atomic_read(&pag->pag_ref), _RET_IP_);
+	return pag;
+}
+
 /*
  * search from @first to find the next perag with the given tag set.
  */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 191b22b9a35b..d61b07e60802 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -112,6 +112,7 @@ int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
 
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
+struct xfs_perag *xfs_perag_bump(struct xfs_perag *pag);
 struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int tag);
 void xfs_perag_put(struct xfs_perag *pag);
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 549a3cba0234..0e78e00e02f9 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -492,9 +492,7 @@ xfs_allocbt_init_common(
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
 
-	/* take a reference for the cursor */
-	atomic_inc(&pag->pag_ref);
-	cur->bc_ag.pag = pag;
+	cur->bc_ag.pag = xfs_perag_bump(pag);
 
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 2dbe553d87fb..fb10760fd686 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -450,9 +450,7 @@ xfs_inobt_init_common(
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	/* take a reference for the cursor */
-	atomic_inc(&pag->pag_ref);
-	cur->bc_ag.pag = pag;
+	cur->bc_ag.pag = xfs_perag_bump(pag);
 	return cur;
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 3d8e62da2ccc..f5bdac3cf19f 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -340,10 +340,7 @@ xfs_refcountbt_init_common(
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	/* take a reference for the cursor */
-	atomic_inc(&pag->pag_ref);
-	cur->bc_ag.pag = pag;
-
+	cur->bc_ag.pag = xfs_perag_bump(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
 	cur->bc_ops = &xfs_refcountbt_ops;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 7f83f62e51e0..12c26c42c162 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -460,10 +460,7 @@ xfs_rmapbt_init_common(
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;
 
-	/* take a reference for the cursor */
-	atomic_inc(&pag->pag_ref);
-	cur->bc_ag.pag = pag;
-
+	cur->bc_ag.pag = xfs_perag_bump(pag);
 	return cur;
 }
 
diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index 43005ce8bd48..5024a59f0c75 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -168,9 +168,7 @@ xfs_iunlink_log_inode(
 	iup->ip = ip;
 	iup->next_agino = next_agino;
 	iup->old_agino = ip->i_next_unlinked;
-
-	atomic_inc(&pag->pag_ref);
-	iup->pag = pag;
+	iup->pag = xfs_perag_bump(pag);
 
 	xfs_trans_add_item(tp, &iup->item);
 	tp->t_flags |= XFS_TRANS_DIRTY;
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 7558486f4937..594ccadb729f 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -670,8 +670,7 @@ xfs_iwalk_threaded(
 		 * perag is being handed off to async work, so take another
 		 * reference for the async work to release.
 		 */
-		atomic_inc(&pag->pag_ref);
-		iwag->pag = pag;
+		iwag->pag = xfs_perag_bump(pag);
 		iwag->iwalk_fn = iwalk_fn;
 		iwag->data = data;
 		iwag->startino = startino;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6b0e9ae7c513..0448b992a561 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -187,6 +187,7 @@ DEFINE_EVENT(xfs_perag_class, name,	\
 		 unsigned long caller_ip),					\
 	TP_ARGS(mp, agno, refcount, caller_ip))
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
+DEFINE_PERAG_REF_EVENT(xfs_perag_bump);
 DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);

