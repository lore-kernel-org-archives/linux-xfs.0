Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDABBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344962AbiATASZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56984 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiATASY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:18:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EDD461512
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA4BC004E1;
        Thu, 20 Jan 2022 00:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637903;
        bh=2sDmGSdjz4Y9uIiKcbq4UZWGCdeLjLxrVS/x/ftwmpI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bOD/w/50Y/+FqIVJrUellq7BOYBotrsjaU2Vzr4YHDEGWEJxUuVYdsJOPzilQkIJb
         4dgU/JgzHBgplZPtuBK3FvTscRH5T5cPumcbEApsoWQDto0LyMZbr1sR1HcMF/vCjE
         nxr+MUO1TQ4H+VFy/yvgheqdlLxgIR1mXVCGfJQU/d15Dfkx+TrVSZTQgmDhkPGdU4
         7Ioe9t6zVZ81FvhTZdnFq4EwKed3ooOhDgDciGY3fGuIR4J9Iu2XFMFNYU52e/TzJs
         Y8y69aURP8r1WkuOa19kqVvwGjCYzZFbtOozqcGvN7d19hPMRdJtdqtHkcZ+yN905q
         WADeXJkq77WAA==
Subject: [PATCH 11/45] xfs: make the key parameters to all btree query range
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:18:23 -0800
Message-ID: <164263790323.860211.18221153490120430001.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 04dcb47482a9d9e27feba48ca92613edced42ef9

Range query functions are not supposed to modify the query keys that are
being passed in, so mark them all const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c |    4 ++--
 libxfs/xfs_alloc.h |    4 ++--
 libxfs/xfs_btree.c |   12 ++++++------
 libxfs/xfs_btree.h |    3 ++-
 libxfs/xfs_rmap.c  |    4 ++--
 libxfs/xfs_rmap.h  |    3 ++-
 6 files changed, 16 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 5f455342..105c90b0 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3403,8 +3403,8 @@ xfs_alloc_query_range_helper(
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
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index e30900b6..3554b7d4 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
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
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 8455f26a..aedc62a5 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4537,8 +4537,8 @@ xfs_btree_compute_maxlevels(
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
@@ -4628,8 +4628,8 @@ xfs_btree_simple_query_range(
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
@@ -4770,8 +4770,8 @@ xfs_btree_overlapped_query_range(
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 7154ad86..462c2585 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -474,7 +474,8 @@ typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_rec *rec, void *priv);
 
 int xfs_btree_query_range(struct xfs_btree_cur *cur,
-		union xfs_btree_irec *low_rec, union xfs_btree_irec *high_rec,
+		const union xfs_btree_irec *low_rec,
+		const union xfs_btree_irec *high_rec,
 		xfs_btree_query_range_fn fn, void *priv);
 int xfs_btree_query_all(struct xfs_btree_cur *cur, xfs_btree_query_range_fn fn,
 		void *priv);
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index b95421ef..100e904d 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2295,8 +2295,8 @@ xfs_rmap_query_range_helper(
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
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index f2423cf7..1354efc4 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -139,7 +139,8 @@ typedef int (*xfs_rmap_query_range_fn)(
 	void			*priv);
 
 int xfs_rmap_query_range(struct xfs_btree_cur *cur,
-		struct xfs_rmap_irec *low_rec, struct xfs_rmap_irec *high_rec,
+		const struct xfs_rmap_irec *low_rec,
+		const struct xfs_rmap_irec *high_rec,
 		xfs_rmap_query_range_fn fn, void *priv);
 int xfs_rmap_query_all(struct xfs_btree_cur *cur, xfs_rmap_query_range_fn fn,
 		void *priv);

