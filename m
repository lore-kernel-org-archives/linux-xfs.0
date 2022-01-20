Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16868C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344975AbiATASV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344962AbiATASU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:18:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C02CC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:18:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4564AB81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D416C004E1;
        Thu, 20 Jan 2022 00:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637898;
        bh=SizmMugLVY2cj3HTuglXYhmsZY/qvJ28YpJIFNNO4AE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kHjqDGcokQ6vLlGA7mwYYSvg5ScSQ5Rm0HgMW7+1DgFoX9+y4cXmOMBzpP04+HaBT
         g+jlwyl99iN0lTRMXJhGcQec24V/d3/ZwZjwka8/PIgKoB13OGdpUT2rx2cZ4nnd7T
         2wvrZK/6EaD11ppLZWrXrfeWCShmeDGZnsXo2skggTpqAah8T8hAij1zvKFGaNJa9L
         14z2Xxtvv/0WHL9nxXb8jFGxwr8KMZHNyZSqqx4V2qakiXTV0iIFb7hwf3v7Wewmxk
         IKvbEO0TL1FskdpwOtHBwjf7672kpJeSvNCJFi+ytwNab8u6Dh/PZkLDhwJwcvUlwa
         XddOMmTYd2pHw==
Subject: [PATCH 10/45] xfs: make the key parameters to all btree key
 comparison functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:18:17 -0800
Message-ID: <164263789773.860211.4259313999179547752.stgit@magnolia>
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

Source kernel commit: d29d5577774d7d032da1343dba80be7423e307f9

The btree key comparison functions are not allowed to change the keys
that are passed in, so mark them const.  We'll need this for the next
patch, which adds const to the btree range query functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |   32 ++++++++++++++++----------------
 libxfs/xfs_bmap_btree.c     |   14 +++++++-------
 libxfs/xfs_btree.h          |    6 +++---
 libxfs/xfs_ialloc_btree.c   |   10 +++++-----
 libxfs/xfs_refcount_btree.c |   12 ++++++------
 libxfs/xfs_rmap_btree.c     |   26 +++++++++++++-------------
 6 files changed, 50 insertions(+), 50 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 3847f7cb..67553183 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -227,23 +227,23 @@ xfs_allocbt_init_ptr_from_cur(
 
 STATIC int64_t
 xfs_bnobt_key_diff(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
 {
-	xfs_alloc_rec_incore_t	*rec = &cur->bc_rec.a;
-	xfs_alloc_key_t		*kp = &key->alloc;
+	struct xfs_alloc_rec_incore	*rec = &cur->bc_rec.a;
+	const struct xfs_alloc_rec	*kp = &key->alloc;
 
 	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
 STATIC int64_t
 xfs_cntbt_key_diff(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
 {
-	xfs_alloc_rec_incore_t	*rec = &cur->bc_rec.a;
-	xfs_alloc_key_t		*kp = &key->alloc;
-	int64_t			diff;
+	struct xfs_alloc_rec_incore	*rec = &cur->bc_rec.a;
+	const struct xfs_alloc_rec	*kp = &key->alloc;
+	int64_t				diff;
 
 	diff = (int64_t)be32_to_cpu(kp->ar_blockcount) - rec->ar_blockcount;
 	if (diff)
@@ -254,9 +254,9 @@ xfs_cntbt_key_diff(
 
 STATIC int64_t
 xfs_bnobt_diff_two_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
 	return (int64_t)be32_to_cpu(k1->alloc.ar_startblock) -
 			  be32_to_cpu(k2->alloc.ar_startblock);
@@ -264,11 +264,11 @@ xfs_bnobt_diff_two_keys(
 
 STATIC int64_t
 xfs_cntbt_diff_two_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
-	int64_t			diff;
+	int64_t				diff;
 
 	diff =  be32_to_cpu(k1->alloc.ar_blockcount) -
 		be32_to_cpu(k2->alloc.ar_blockcount);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 4c456df9..d72e1e7b 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -385,8 +385,8 @@ xfs_bmbt_init_ptr_from_cur(
 
 STATIC int64_t
 xfs_bmbt_key_diff(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
 {
 	return (int64_t)be64_to_cpu(key->bmbt.br_startoff) -
 				      cur->bc_rec.b.br_startoff;
@@ -394,12 +394,12 @@ xfs_bmbt_key_diff(
 
 STATIC int64_t
 xfs_bmbt_diff_two_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
-	uint64_t		a = be64_to_cpu(k1->bmbt.br_startoff);
-	uint64_t		b = be64_to_cpu(k2->bmbt.br_startoff);
+	uint64_t			a = be64_to_cpu(k1->bmbt.br_startoff);
+	uint64_t			b = be64_to_cpu(k2->bmbt.br_startoff);
 
 	/*
 	 * Note: This routine previously casted a and b to int64 and subtracted
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 4dbdc659..7154ad86 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -140,15 +140,15 @@ struct xfs_btree_ops {
 
 	/* difference between key value and cursor value */
 	int64_t (*key_diff)(struct xfs_btree_cur *cur,
-			      union xfs_btree_key *key);
+			    const union xfs_btree_key *key);
 
 	/*
 	 * Difference between key2 and key1 -- positive if key1 > key2,
 	 * negative if key1 < key2, and zero if equal.
 	 */
 	int64_t (*diff_two_keys)(struct xfs_btree_cur *cur,
-				   union xfs_btree_key *key1,
-				   union xfs_btree_key *key2);
+				 const union xfs_btree_key *key1,
+				 const union xfs_btree_key *key2);
 
 	const struct xfs_buf_ops	*buf_ops;
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 3e8afe76..fd13ec53 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -252,8 +252,8 @@ xfs_finobt_init_ptr_from_cur(
 
 STATIC int64_t
 xfs_inobt_key_diff(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
 {
 	return (int64_t)be32_to_cpu(key->inobt.ir_startino) -
 			  cur->bc_rec.i.ir_startino;
@@ -261,9 +261,9 @@ xfs_inobt_key_diff(
 
 STATIC int64_t
 xfs_inobt_diff_two_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
 	return (int64_t)be32_to_cpu(k1->inobt.ir_startino) -
 			  be32_to_cpu(k2->inobt.ir_startino);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 26fef861..277c7669 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -176,20 +176,20 @@ xfs_refcountbt_init_ptr_from_cur(
 
 STATIC int64_t
 xfs_refcountbt_key_diff(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
 {
 	struct xfs_refcount_irec	*rec = &cur->bc_rec.rc;
-	struct xfs_refcount_key		*kp = &key->refc;
+	const struct xfs_refcount_key	*kp = &key->refc;
 
 	return (int64_t)be32_to_cpu(kp->rc_startblock) - rec->rc_startblock;
 }
 
 STATIC int64_t
 xfs_refcountbt_diff_two_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
 	return (int64_t)be32_to_cpu(k1->refc.rc_startblock) -
 			  be32_to_cpu(k2->refc.rc_startblock);
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 47e32d20..d27e83b9 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -217,13 +217,13 @@ xfs_rmapbt_init_ptr_from_cur(
 
 STATIC int64_t
 xfs_rmapbt_key_diff(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
 {
-	struct xfs_rmap_irec	*rec = &cur->bc_rec.r;
-	struct xfs_rmap_key	*kp = &key->rmap;
-	__u64			x, y;
-	int64_t			d;
+	struct xfs_rmap_irec		*rec = &cur->bc_rec.r;
+	const struct xfs_rmap_key	*kp = &key->rmap;
+	__u64				x, y;
+	int64_t				d;
 
 	d = (int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
 	if (d)
@@ -247,14 +247,14 @@ xfs_rmapbt_key_diff(
 
 STATIC int64_t
 xfs_rmapbt_diff_two_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
-	struct xfs_rmap_key	*kp1 = &k1->rmap;
-	struct xfs_rmap_key	*kp2 = &k2->rmap;
-	int64_t			d;
-	__u64			x, y;
+	const struct xfs_rmap_key	*kp1 = &k1->rmap;
+	const struct xfs_rmap_key	*kp2 = &k2->rmap;
+	int64_t				d;
+	__u64				x, y;
 
 	d = (int64_t)be32_to_cpu(kp1->rm_startblock) -
 		       be32_to_cpu(kp2->rm_startblock);

