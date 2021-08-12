Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCDDC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B06EA6103E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbhHLXcR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237883AbhHLXcR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56FC260C3E;
        Thu, 12 Aug 2021 23:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811111;
        bh=y+mS3TAQN0YnIHx22Wp5LMLw0fbDqeGVI4k1eEP8wTs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nZ/SYQHGti1/BNbTC63xWxUrpwrMHQ6Wta3LuRg8lNyS9MehKlNQkQ3DUR0PSQukj
         nyQh/Khr2yKPB3vuL9yqlnEJFy07peeJQPc+7OxUwNxkR2P9XyfoWmtoDpFDIvn4aO
         RTjpqLEgOs4iMn5ij/xQ0FvvSmGnNpQsMdY9iHpfUAFc8rqvlebW9ci3W1qCWajdcX
         V6lbAkinfPRN5BugY/5NJxvVIn42itwl9BdhKGBBfOD68B95B75n9leVExV89WcGTC
         MwiFdBBUIKUuGVOtYQk9QB/1hMq5I8y27B/6YzDg3LvxG0U0jiOk9V94Nue8qle/4+
         pt19qolBtvhag==
Subject: [PATCH 05/10] xfs: make the keys and records passed to btree inorder
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:31:51 -0700
Message-ID: <162881111103.1695493.15030145852356555847.stgit@magnolia>
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

The inorder functions are simple predicates, which means that they don't
modify the parameters.  Mark them all const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   24 ++++++++++++------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |   12 ++++++------
 fs/xfs/libxfs/xfs_btree.h          |    8 ++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   12 ++++++------
 fs/xfs/libxfs/xfs_refcount_btree.c |   12 ++++++------
 fs/xfs/libxfs/xfs_rmap_btree.c     |   12 ++++++------
 6 files changed, 40 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 576b3ba3f27b..c2d2a0be56d8 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -376,9 +376,9 @@ const struct xfs_buf_ops xfs_cntbt_buf_ops = {
 
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
@@ -386,9 +386,9 @@ xfs_bnobt_keys_inorder(
 
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
@@ -397,9 +397,9 @@ xfs_bnobt_recs_inorder(
 
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
@@ -410,9 +410,9 @@ xfs_cntbt_keys_inorder(
 
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
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 00a1104d9823..cd8fefc9019f 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -497,9 +497,9 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 
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
@@ -507,9 +507,9 @@ xfs_bmbt_keys_inorder(
 
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index c4c701fd1077..4b95373c6d23 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index a583928cc810..a6ba08bb9bfe 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -360,9 +360,9 @@ const struct xfs_buf_ops xfs_finobt_buf_ops = {
 
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
@@ -370,9 +370,9 @@ xfs_inobt_keys_inorder(
 
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
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 094afa264aa7..907869014a99 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -269,9 +269,9 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 
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
@@ -279,9 +279,9 @@ xfs_refcountbt_keys_inorder(
 
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
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index df57b40d001f..3c3cf4971bd7 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -364,9 +364,9 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 
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
@@ -394,9 +394,9 @@ xfs_rmapbt_keys_inorder(
 
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

