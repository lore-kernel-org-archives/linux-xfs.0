Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716FAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240356AbiATASi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345030AbiATASh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:18:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46841C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:18:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03E58B81B2B
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB892C004E1;
        Thu, 20 Jan 2022 00:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637914;
        bh=gAHVfB2veFS1p8GprhXVSL+rrV/CqpMjU3fARRzswlw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=j3r8n7eZQ/wnT7UefoCrg84B1quCoG9sV8i+AmB1f/3DWfHHcEg2cdFhluOVvpbmp
         fERFNjgeV1PShDHcvw6z1brW77aIfotD0looGwlNiPI5ci+B16KtrpDn/bXWEbPYMv
         lkkuekrus2a0a2hXlOZX54wiIArM4FAbO4cMLxN2sH/8wTAJJ91wVuFQHX3JQtNsP7
         O7jj8tF/Hzz+mc1b3ai2PUUEYWFACwBmHOlFFqiIvpMepID6YCFCywj33SJiiDsLVi
         G9ihnMlycnHeA9Dpm3v/47bR7POlKtalJbhbMqMcn6JXwEzmLd/A3daHI2/xpRbUss
         KjrUxLHsKhNaA==
Subject: [PATCH 13/45] xfs: mark the record passed into btree init_key
 functions as const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:18:34 -0800
Message-ID: <164263791438.860211.8696445320829104527.stgit@magnolia>
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

Source kernel commit: 23825cd148764ce133ee92375da395140d6ccb15

These functions initialize a key from a record, but they aren't supposed
to modify the record.  Mark it const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |   14 +++++++-------
 libxfs/xfs_bmap_btree.c     |   12 ++++++------
 libxfs/xfs_bmap_btree.h     |    4 ++--
 libxfs/xfs_btree.h          |    4 ++--
 libxfs/xfs_ialloc_btree.c   |   10 +++++-----
 libxfs/xfs_refcount_btree.c |   10 +++++-----
 libxfs/xfs_rmap_btree.c     |   12 ++++++------
 7 files changed, 33 insertions(+), 33 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 67553183..fb2fdb4a 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -175,8 +175,8 @@ xfs_allocbt_get_maxrecs(
 
 STATIC void
 xfs_allocbt_init_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->alloc.ar_startblock = rec->alloc.ar_startblock;
 	key->alloc.ar_blockcount = rec->alloc.ar_blockcount;
@@ -184,10 +184,10 @@ xfs_allocbt_init_key_from_rec(
 
 STATIC void
 xfs_bnobt_init_high_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
-	__u32			x;
+	__u32				x;
 
 	x = be32_to_cpu(rec->alloc.ar_startblock);
 	x += be32_to_cpu(rec->alloc.ar_blockcount) - 1;
@@ -197,8 +197,8 @@ xfs_bnobt_init_high_key_from_rec(
 
 STATIC void
 xfs_cntbt_init_high_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->alloc.ar_blockcount = rec->alloc.ar_blockcount;
 	key->alloc.ar_startblock = 0;
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index d72e1e7b..73e387f5 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -76,7 +76,7 @@ xfs_bmbt_disk_get_all(
  */
 xfs_filblks_t
 xfs_bmbt_disk_get_blockcount(
-	xfs_bmbt_rec_t	*r)
+	const struct xfs_bmbt_rec	*r)
 {
 	return (xfs_filblks_t)(be64_to_cpu(r->l1) & xfs_mask64lo(21));
 }
@@ -86,7 +86,7 @@ xfs_bmbt_disk_get_blockcount(
  */
 xfs_fileoff_t
 xfs_bmbt_disk_get_startoff(
-	xfs_bmbt_rec_t	*r)
+	const struct xfs_bmbt_rec	*r)
 {
 	return ((xfs_fileoff_t)be64_to_cpu(r->l0) &
 		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
@@ -350,8 +350,8 @@ xfs_bmbt_get_dmaxrecs(
 
 STATIC void
 xfs_bmbt_init_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->bmbt.br_startoff =
 		cpu_to_be64(xfs_bmbt_disk_get_startoff(&rec->bmbt));
@@ -359,8 +359,8 @@ xfs_bmbt_init_key_from_rec(
 
 STATIC void
 xfs_bmbt_init_high_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->bmbt.br_startoff = cpu_to_be64(
 			xfs_bmbt_disk_get_startoff(&rec->bmbt) +
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 72bf74c7..209ded1e 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -88,8 +88,8 @@ extern void xfs_bmdr_to_bmbt(struct xfs_inode *, xfs_bmdr_block_t *, int,
 			struct xfs_btree_block *, int);
 
 void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
-extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
-extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
+extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(const struct xfs_bmbt_rec *r);
+extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(const struct xfs_bmbt_rec *r);
 extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 
 extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index e83836a9..c4c701fd 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -130,13 +130,13 @@ struct xfs_btree_ops {
 
 	/* init values of btree structures */
 	void	(*init_key_from_rec)(union xfs_btree_key *key,
-				     union xfs_btree_rec *rec);
+				     const union xfs_btree_rec *rec);
 	void	(*init_rec_from_cur)(struct xfs_btree_cur *cur,
 				     union xfs_btree_rec *rec);
 	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
 				     union xfs_btree_ptr *ptr);
 	void	(*init_high_key_from_rec)(union xfs_btree_key *key,
-					  union xfs_btree_rec *rec);
+					  const union xfs_btree_rec *rec);
 
 	/* difference between key value and cursor value */
 	int64_t (*key_diff)(struct xfs_btree_cur *cur,
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index fd13ec53..e7b19d2a 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -187,18 +187,18 @@ xfs_inobt_get_maxrecs(
 
 STATIC void
 xfs_inobt_init_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->inobt.ir_startino = rec->inobt.ir_startino;
 }
 
 STATIC void
 xfs_inobt_init_high_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
-	__u32			x;
+	__u32				x;
 
 	x = be32_to_cpu(rec->inobt.ir_startino);
 	x += XFS_INODES_PER_CHUNK - 1;
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 277c7669..04bc5816 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -134,18 +134,18 @@ xfs_refcountbt_get_maxrecs(
 
 STATIC void
 xfs_refcountbt_init_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->refc.rc_startblock = rec->refc.rc_startblock;
 }
 
 STATIC void
 xfs_refcountbt_init_high_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
-	__u32			x;
+	__u32				x;
 
 	x = be32_to_cpu(rec->refc.rc_startblock);
 	x += be32_to_cpu(rec->refc.rc_blockcount) - 1;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index d27e83b9..294d4a41 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -154,8 +154,8 @@ xfs_rmapbt_get_maxrecs(
 
 STATIC void
 xfs_rmapbt_init_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->rmap.rm_startblock = rec->rmap.rm_startblock;
 	key->rmap.rm_owner = rec->rmap.rm_owner;
@@ -171,11 +171,11 @@ xfs_rmapbt_init_key_from_rec(
  */
 STATIC void
 xfs_rmapbt_init_high_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
-	uint64_t		off;
-	int			adj;
+	uint64_t			off;
+	int				adj;
 
 	adj = be32_to_cpu(rec->rmap.rm_blockcount) - 1;
 

