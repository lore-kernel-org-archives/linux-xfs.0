Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC1AC4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30E606103E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhHLXcB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhHLXcA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:32:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B60B26103E;
        Thu, 12 Aug 2021 23:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811094;
        bh=8mV5GusErvWQcgEjW6MoSW2jXmvfLzkkXTx3sxIBo/8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=liZOHh/s8NAl1rq1CR4D/iUprih7+FUFZUXaQH4i5rKu4pWbYlefiq+2k7mGIHdUl
         s0vjQxDkRtd7WwNCVLv70MxFyv7PcPggRHL3JNP1XY7BDjE5nGiD/ZoyRQR7/fjgd/
         riJFcPoGfceBKqWEZwA4xEja5gnzJGQQzueyavAQZIQtQqSQuRwMzouK0j7cyo3BKj
         D1zmVCU56yjchzNEoWJrn6+xkSsdQhr34bsBX2F1TBPuc9fEIpSiEJuoWMZiJzAZyw
         1lut3fr0N/R1OVQGREAcR+nNs65l1Hpwa/MazPsVvxdFn6qWH9qQGpIHSoTidTU7Mr
         ei7U69VmP2+aQ==
Subject: [PATCH 02/10] xfs: make the key parameters to all btree query range
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:31:34 -0700
Message-ID: <162881109443.1695493.6458037403329160173.stgit@magnolia>
In-Reply-To: <162881108307.1695493.3416792932772498160.stgit@magnolia>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Range query functions are not supposed to modify the query keys that are
being passed in, so mark them all const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    4 ++--
 fs/xfs/libxfs/xfs_alloc.h |    4 ++--
 fs/xfs/libxfs/xfs_btree.c |   12 ++++++------
 fs/xfs/libxfs/xfs_btree.h |    3 ++-
 fs/xfs/libxfs/xfs_rmap.c  |    4 ++--
 fs/xfs/libxfs/xfs_rmap.h  |    3 ++-
 6 files changed, 16 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6929157d8d6e..d5ee19ae02eb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3407,8 +3407,8 @@ xfs_alloc_query_range_helper(
 int
 xfs_alloc_query_range(
 	struct xfs_btree_cur			*cur,
-	struct xfs_alloc_rec_incore		*low_rec,
-	struct xfs_alloc_rec_incore		*high_rec,
+	const struct xfs_alloc_rec_incore	*low_rec,
+	const struct xfs_alloc_rec_incore	*high_rec,
 	xfs_alloc_query_range_fn		fn,
 	void					*priv)
 {
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index e30900b6f8ba..3554b7d420f0 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -225,8 +225,8 @@ typedef int (*xfs_alloc_query_range_fn)(
 	void				*priv);
 
 int xfs_alloc_query_range(struct xfs_btree_cur *cur,
-		struct xfs_alloc_rec_incore *low_rec,
-		struct xfs_alloc_rec_incore *high_rec,
+		const struct xfs_alloc_rec_incore *low_rec,
+		const struct xfs_alloc_rec_incore *high_rec,
 		xfs_alloc_query_range_fn fn, void *priv);
 int xfs_alloc_query_all(struct xfs_btree_cur *cur, xfs_alloc_query_range_fn fn,
 		void *priv);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index be74a6b53689..c91f084e555e 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4536,8 +4536,8 @@ xfs_btree_compute_maxlevels(
 STATIC int
 xfs_btree_simple_query_range(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_key		*low_key,
-	union xfs_btree_key		*high_key,
+	const union xfs_btree_key	*low_key,
+	const union xfs_btree_key	*high_key,
 	xfs_btree_query_range_fn	fn,
 	void				*priv)
 {
@@ -4627,8 +4627,8 @@ xfs_btree_simple_query_range(
 STATIC int
 xfs_btree_overlapped_query_range(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_key		*low_key,
-	union xfs_btree_key		*high_key,
+	const union xfs_btree_key	*low_key,
+	const union xfs_btree_key	*high_key,
 	xfs_btree_query_range_fn	fn,
 	void				*priv)
 {
@@ -4769,8 +4769,8 @@ xfs_btree_overlapped_query_range(
 int
 xfs_btree_query_range(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_irec		*low_rec,
-	union xfs_btree_irec		*high_rec,
+	const union xfs_btree_irec	*low_rec,
+	const union xfs_btree_irec	*high_rec,
 	xfs_btree_query_range_fn	fn,
 	void				*priv)
 {
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 7154ad8647c9..462c25857a26 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -474,7 +474,8 @@ typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_rec *rec, void *priv);
 
 int xfs_btree_query_range(struct xfs_btree_cur *cur,
-		union xfs_btree_irec *low_rec, union xfs_btree_irec *high_rec,
+		const union xfs_btree_irec *low_rec,
+		const union xfs_btree_irec *high_rec,
 		xfs_btree_query_range_fn fn, void *priv);
 int xfs_btree_query_all(struct xfs_btree_cur *cur, xfs_btree_query_range_fn fn,
 		void *priv);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index d1dfad0204e3..c38342b27935 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2296,8 +2296,8 @@ xfs_rmap_query_range_helper(
 int
 xfs_rmap_query_range(
 	struct xfs_btree_cur			*cur,
-	struct xfs_rmap_irec			*low_rec,
-	struct xfs_rmap_irec			*high_rec,
+	const struct xfs_rmap_irec		*low_rec,
+	const struct xfs_rmap_irec		*high_rec,
 	xfs_rmap_query_range_fn			fn,
 	void					*priv)
 {
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index f2423cf7f1e2..1354efc4ddab 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -139,7 +139,8 @@ typedef int (*xfs_rmap_query_range_fn)(
 	void			*priv);
 
 int xfs_rmap_query_range(struct xfs_btree_cur *cur,
-		struct xfs_rmap_irec *low_rec, struct xfs_rmap_irec *high_rec,
+		const struct xfs_rmap_irec *low_rec,
+		const struct xfs_rmap_irec *high_rec,
 		xfs_rmap_query_range_fn fn, void *priv);
 int xfs_rmap_query_all(struct xfs_btree_cur *cur, xfs_rmap_query_range_fn fn,
 		void *priv);

