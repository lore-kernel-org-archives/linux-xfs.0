Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E36C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45E786103E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbhHLXcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhHLXbz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 436796103E;
        Thu, 12 Aug 2021 23:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811089;
        bh=Np/82lf3SR6LVZmJk4/kODjPrdMgyenkrW2sEJuOqmI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PblqrNEIjqpIe4RpZ/gu0Rf0vI3jsdU52PobiJZBPRiDBvcqYR+fMxOTcKaaC5Odu
         Oa9KEdP5H9GiymlEPQVhsYHN2o8cWj579sA9HcImDj8sSpKzuKp6Wb4LfsOboeE0aC
         zxh66hHoibPpvY5YiupmQPINFVMqLgt8Z/s4m/SZ54LQJU2QUrEdXjSeuRbvlANVeF
         0VpSVWKAhKp98I6NJFENCHcgUckTz8I5H1KqagIZBq5S3jDu8H215veSNIUAfcQLhT
         9/GHKb4kPCrWAVWppanCVObdWL6ZrGJ8fX6gAKXLLQ6atW2ItaNjEe/E4TA7TE8M0T
         EJO89+/pwUc5g==
Subject: [PATCH 01/10] xfs: make the key parameters to all btree key
 comparison functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:31:28 -0700
Message-ID: <162881108892.1695493.3056744650016025435.stgit@magnolia>
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

The btree key comparison functions are not allowed to change the keys
that are passed in, so mark them const.  We'll need this for the next
patch, which adds const to the btree range query functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   32 ++++++++++++++++----------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |   14 +++++++-------
 fs/xfs/libxfs/xfs_btree.h          |    6 +++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   10 +++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c |   12 ++++++------
 fs/xfs/libxfs/xfs_rmap_btree.c     |   26 +++++++++++++-------------
 6 files changed, 50 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 6b363f78cfa2..f2ee982ca4f7 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -229,23 +229,23 @@ xfs_allocbt_init_ptr_from_cur(
 
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
@@ -256,9 +256,9 @@ xfs_cntbt_key_diff(
 
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
@@ -266,11 +266,11 @@ xfs_bnobt_diff_two_keys(
 
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
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 1ceba020940e..e6c8865eee5f 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -387,8 +387,8 @@ xfs_bmbt_init_ptr_from_cur(
 
 STATIC int64_t
 xfs_bmbt_key_diff(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
 {
 	return (int64_t)be64_to_cpu(key->bmbt.br_startoff) -
 				      cur->bc_rec.b.br_startoff;
@@ -396,12 +396,12 @@ xfs_bmbt_key_diff(
 
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4dbdc659c396..7154ad8647c9 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 823a038939f8..ecae2067c986 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -253,8 +253,8 @@ xfs_finobt_init_ptr_from_cur(
 
 STATIC int64_t
 xfs_inobt_key_diff(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
 {
 	return (int64_t)be32_to_cpu(key->inobt.ir_startino) -
 			  cur->bc_rec.i.ir_startino;
@@ -262,9 +262,9 @@ xfs_inobt_key_diff(
 
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
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 92d336c17e83..beb40f279abb 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -177,20 +177,20 @@ xfs_refcountbt_init_ptr_from_cur(
 
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
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f29bc71b9950..f6571c06ce04 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -219,13 +219,13 @@ xfs_rmapbt_init_ptr_from_cur(
 
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
@@ -249,14 +249,14 @@ xfs_rmapbt_key_diff(
 
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

