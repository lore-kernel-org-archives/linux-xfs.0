Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78088C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536936103E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhHLXcM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237883AbhHLXcL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1E9F6103E;
        Thu, 12 Aug 2021 23:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811105;
        bh=XHsjON4S84CstW5brXfjd6ZTLr6QOeF1eNy4bq5Tp0s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WtXF+CbBwpSK6n+Oo6eI62a8s9SmMSzWIwNa4sHBp8mgMk8ien7ujAgflZFIA5l9r
         AGykq+Vw66ajaTelqymLL97/FB8GaSB7C9WBPvV7eexOOgoP0GYdQPTjGft5tG9Ilp
         1dbTkVsmXnJ/3x18DhZyu/7pSX2rWQAeldkk0YVI/eaVUlrjL0vvuAy5aOcY6vaQfE
         j9M1Ro4Kj7J2np3T8X9bMStu0Kqgj4GMF9z/yFh7V+rpNNsb8Eo77Bk6+OcNwj1LdA
         2E6aLG1SvsKZ9A40Fywk0ZFlzxSgJT7Hmj1bdxTupzhSqgdxZI/tXYcIHMCJIj571V
         WcQSmGjdyMh/Q==
Subject: [PATCH 04/10] xfs: mark the record passed into btree init_key
 functions as const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:31:45 -0700
Message-ID: <162881110548.1695493.18089688856522736997.stgit@magnolia>
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

These functions initialize a key from a record, but they aren't supposed
to modify the record.  Mark it const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   14 +++++++-------
 fs/xfs/libxfs/xfs_bmap_btree.c     |   12 ++++++------
 fs/xfs/libxfs/xfs_bmap_btree.h     |    4 ++--
 fs/xfs/libxfs/xfs_btree.h          |    4 ++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   10 +++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c |   10 +++++-----
 fs/xfs/libxfs/xfs_rmap_btree.c     |   12 ++++++------
 7 files changed, 33 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index f2ee982ca4f7..576b3ba3f27b 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -177,8 +177,8 @@ xfs_allocbt_get_maxrecs(
 
 STATIC void
 xfs_allocbt_init_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->alloc.ar_startblock = rec->alloc.ar_startblock;
 	key->alloc.ar_blockcount = rec->alloc.ar_blockcount;
@@ -186,10 +186,10 @@ xfs_allocbt_init_key_from_rec(
 
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
@@ -199,8 +199,8 @@ xfs_bnobt_init_high_key_from_rec(
 
 STATIC void
 xfs_cntbt_init_high_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->alloc.ar_blockcount = rec->alloc.ar_blockcount;
 	key->alloc.ar_startblock = 0;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index e6c8865eee5f..00a1104d9823 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -78,7 +78,7 @@ xfs_bmbt_disk_get_all(
  */
 xfs_filblks_t
 xfs_bmbt_disk_get_blockcount(
-	xfs_bmbt_rec_t	*r)
+	const struct xfs_bmbt_rec	*r)
 {
 	return (xfs_filblks_t)(be64_to_cpu(r->l1) & xfs_mask64lo(21));
 }
@@ -88,7 +88,7 @@ xfs_bmbt_disk_get_blockcount(
  */
 xfs_fileoff_t
 xfs_bmbt_disk_get_startoff(
-	xfs_bmbt_rec_t	*r)
+	const struct xfs_bmbt_rec	*r)
 {
 	return ((xfs_fileoff_t)be64_to_cpu(r->l0) &
 		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
@@ -352,8 +352,8 @@ xfs_bmbt_get_dmaxrecs(
 
 STATIC void
 xfs_bmbt_init_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->bmbt.br_startoff =
 		cpu_to_be64(xfs_bmbt_disk_get_startoff(&rec->bmbt));
@@ -361,8 +361,8 @@ xfs_bmbt_init_key_from_rec(
 
 STATIC void
 xfs_bmbt_init_high_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->bmbt.br_startoff = cpu_to_be64(
 			xfs_bmbt_disk_get_startoff(&rec->bmbt) +
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 72bf74c79fb9..209ded1eefd1 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -88,8 +88,8 @@ extern void xfs_bmdr_to_bmbt(struct xfs_inode *, xfs_bmdr_block_t *, int,
 			struct xfs_btree_block *, int);
 
 void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
-extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
-extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
+extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(const struct xfs_bmbt_rec *r);
+extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(const struct xfs_bmbt_rec *r);
 extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 
 extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index e83836a984e4..c4c701fd1077 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index ecae2067c986..a583928cc810 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -188,18 +188,18 @@ xfs_inobt_get_maxrecs(
 
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
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index beb40f279abb..094afa264aa7 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -135,18 +135,18 @@ xfs_refcountbt_get_maxrecs(
 
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
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f6571c06ce04..df57b40d001f 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -156,8 +156,8 @@ xfs_rmapbt_get_maxrecs(
 
 STATIC void
 xfs_rmapbt_init_key_from_rec(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
 {
 	key->rmap.rm_startblock = rec->rmap.rm_startblock;
 	key->rmap.rm_owner = rec->rmap.rm_owner;
@@ -173,11 +173,11 @@ xfs_rmapbt_init_key_from_rec(
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
 

