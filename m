Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0E7C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345047AbiATASm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45910 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiATASm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:18:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64179B81C34
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFBEC004E1;
        Thu, 20 Jan 2022 00:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637920;
        bh=flvviJq7izhwh0sWKoxrLVzR1rvB9KAUe1BDsuEAa34=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MGumtDcNwsBqw8wXAbpUiwr0qAfmyelmr4/EZuUxJ517jgwlCPOjXW6UsypqWPNIW
         FtjXN4ldhH2fNGX/fsIYBnWywByEVK3MunO25BMiOECDDMwMeZqjfeoEsr0ztT4x24
         qA3H0nYTyX+pt8W18jIZuebjJswWhzZk/T1A3fE9LKxD4LtIQ7+ieKIOGN0VKkDEP3
         JRSayTJgJTjbrxYxpOWde0v//86NYeAmrHAyhbNkaR/kE8gEP/4TYyrBMepJVy96Vi
         7rNqzIVlmmZfTj0YoScjD/ir3jJ6fA5Yf9MZei52OzP4YrXs63aJKym9LrWWvXGF85
         Ra/80Syhng+jw==
Subject: [PATCH 14/45] xfs: make the keys and records passed to btree inorder
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:18:39 -0800
Message-ID: <164263791991.860211.3190861713093208231.stgit@magnolia>
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

Source kernel commit: 8e38dc88a67b3c7475cbe8a132d03542717c1e27

The inorder functions are simple predicates, which means that they don't
modify the parameters.  Mark them all const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |   24 ++++++++++++------------
 libxfs/xfs_bmap_btree.c     |   12 ++++++------
 libxfs/xfs_btree.h          |    8 ++++----
 libxfs/xfs_ialloc_btree.c   |   12 ++++++------
 libxfs/xfs_refcount_btree.c |   12 ++++++------
 libxfs/xfs_rmap_btree.c     |   12 ++++++------
 6 files changed, 40 insertions(+), 40 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index fb2fdb4a..79130125 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -374,9 +374,9 @@ const struct xfs_buf_ops xfs_cntbt_buf_ops = {
 
 STATIC int
 xfs_bnobt_keys_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
 	return be32_to_cpu(k1->alloc.ar_startblock) <
 	       be32_to_cpu(k2->alloc.ar_startblock);
@@ -384,9 +384,9 @@ xfs_bnobt_keys_inorder(
 
 STATIC int
 xfs_bnobt_recs_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*r1,
-	union xfs_btree_rec	*r2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
 {
 	return be32_to_cpu(r1->alloc.ar_startblock) +
 		be32_to_cpu(r1->alloc.ar_blockcount) <=
@@ -395,9 +395,9 @@ xfs_bnobt_recs_inorder(
 
 STATIC int
 xfs_cntbt_keys_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
 	return be32_to_cpu(k1->alloc.ar_blockcount) <
 		be32_to_cpu(k2->alloc.ar_blockcount) ||
@@ -408,9 +408,9 @@ xfs_cntbt_keys_inorder(
 
 STATIC int
 xfs_cntbt_recs_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*r1,
-	union xfs_btree_rec	*r2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
 {
 	return be32_to_cpu(r1->alloc.ar_blockcount) <
 		be32_to_cpu(r2->alloc.ar_blockcount) ||
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 73e387f5..acaf2941 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -495,9 +495,9 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 
 STATIC int
 xfs_bmbt_keys_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
 	return be64_to_cpu(k1->bmbt.br_startoff) <
 		be64_to_cpu(k2->bmbt.br_startoff);
@@ -505,9 +505,9 @@ xfs_bmbt_keys_inorder(
 
 STATIC int
 xfs_bmbt_recs_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*r1,
-	union xfs_btree_rec	*r2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
 {
 	return xfs_bmbt_disk_get_startoff(&r1->bmbt) +
 		xfs_bmbt_disk_get_blockcount(&r1->bmbt) <=
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index c4c701fd..4b95373c 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -154,13 +154,13 @@ struct xfs_btree_ops {
 
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
-				union xfs_btree_key *k1,
-				union xfs_btree_key *k2);
+				const union xfs_btree_key *k1,
+				const union xfs_btree_key *k2);
 
 	/* check that r1 is lower than r2 */
 	int	(*recs_inorder)(struct xfs_btree_cur *cur,
-				union xfs_btree_rec *r1,
-				union xfs_btree_rec *r2);
+				const union xfs_btree_rec *r1,
+				const union xfs_btree_rec *r2);
 };
 
 /*
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index e7b19d2a..14b54f13 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -359,9 +359,9 @@ const struct xfs_buf_ops xfs_finobt_buf_ops = {
 
 STATIC int
 xfs_inobt_keys_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
 	return be32_to_cpu(k1->inobt.ir_startino) <
 		be32_to_cpu(k2->inobt.ir_startino);
@@ -369,9 +369,9 @@ xfs_inobt_keys_inorder(
 
 STATIC int
 xfs_inobt_recs_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*r1,
-	union xfs_btree_rec	*r2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
 {
 	return be32_to_cpu(r1->inobt.ir_startino) + XFS_INODES_PER_CHUNK <=
 		be32_to_cpu(r2->inobt.ir_startino);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 04bc5816..b088c4a0 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -268,9 +268,9 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 
 STATIC int
 xfs_refcountbt_keys_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
 	return be32_to_cpu(k1->refc.rc_startblock) <
 	       be32_to_cpu(k2->refc.rc_startblock);
@@ -278,9 +278,9 @@ xfs_refcountbt_keys_inorder(
 
 STATIC int
 xfs_refcountbt_recs_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*r1,
-	union xfs_btree_rec	*r2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
 {
 	return  be32_to_cpu(r1->refc.rc_startblock) +
 		be32_to_cpu(r1->refc.rc_blockcount) <=
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 294d4a41..6d28a469 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -362,9 +362,9 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 
 STATIC int
 xfs_rmapbt_keys_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*k1,
-	union xfs_btree_key	*k2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
 {
 	uint32_t		x;
 	uint32_t		y;
@@ -392,9 +392,9 @@ xfs_rmapbt_keys_inorder(
 
 STATIC int
 xfs_rmapbt_recs_inorder(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*r1,
-	union xfs_btree_rec	*r2)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
 {
 	uint32_t		x;
 	uint32_t		y;

