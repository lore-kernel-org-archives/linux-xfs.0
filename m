Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA44CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD24E610D1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhINCmM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236953AbhINCmL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5BC8610CC;
        Tue, 14 Sep 2021 02:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587255;
        bh=3+BNyhJDzKOUq/BS3Bb2GnIg9R8LKoLdbI5L6tcX1YE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nFKzDOByftBoCsJ/TrkQZcTGkTYWCeev5tU1gLHGfYwYStKkk/tyjW9OfbMFjKGpR
         E8pnMbmmW0td83eJe00zMcDvn5PNyICiQoi+2v8YzG755ZBFYXWV5VpuW9sbPsj2Ua
         /q6uTbFh/UUjre2311G/EUaLWVg350WuKGB8oENadCUAEFXJL/2sOlVSFk2RJ7Gwjf
         nHjqmVBbvMa1JEg2+9/e2jfmDix2zVijOXqMO1Mu7QQYE7zzjTvp8TvSs3wYDB1U1F
         z9qk/w2ll7rVEn9c1c8VWl8gxS9OQGzEuDqTGzBpcrLRib8p6ncpP5DHqf02fNfeHx
         0jBZn8TlvyhqQ==
Subject: [PATCH 10/43] xfs: make the key parameters to all btree query range
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:40:54 -0700
Message-ID: <163158725466.1604118.7676809163968280784.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
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
index 9caff949..16347ff5 100644
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

