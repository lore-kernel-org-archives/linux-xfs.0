Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA762ECE96
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759942443; cv=none; b=BPIp6qDa02ZiyK89Lp0NIBHgosbpTFB0RXh4q0khvHJE5pe12+pl6T32VKWJIQwkd3pX7Aj6DxwTY44SQnuPvGJZ5qnNyLol1PV8/4qcwCaWUCBlkZUkvkhZ2wU2uCViu0apcLU8nXGSjShZIxj/YGbtKg3Q6H7CoqVpIMIeHnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759942443; c=relaxed/simple;
	bh=q9/PpQGNDUqa6SpZplWiExN6X2OLwPIDtDeywKzNfSs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUixOaff8S+U4p3sh1TfwIQLIayoJDnblSAQdl1ERZI88bUEppXAof25M94z+5olymBUwM3k65XYpfc6Zvo7lzgqTuG/bn9KEPdNLaX2rjJNSqpqMcDmLTVpn5UHHiMHtrYKmIJDZfbFlTKO7BRzNP9akMFM+SUzamTNTKsjU3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AC1C4CEF9;
	Wed,  8 Oct 2025 16:54:00 +0000 (UTC)
Date: Wed, 8 Oct 2025 18:53:58 +0200
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH 1/11] [PATCH] xfs: rename diff_two_keys routines
Message-ID: <evlppjk6wlkmwmehqhohl2v7lz5adzkkcesinzjkcsyntf3lqx@hxyzg7qr3mys>
References: <cover.1759941416.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1759941416.patch-series@thinky>

Source kernel commit: edce172444b4f489715a3df2e5d50893e74ce3da

One may think that diff_two_keys routines are used to compute the actual
difference between the arguments but they return a result of a
three-way-comparison of the passed operands. So it looks more appropriate
to denote them as cmp_two_keys.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_alloc_btree.c      |  8 ++++----
 libxfs/xfs_bmap_btree.c       |  4 ++--
 libxfs/xfs_btree.c            |  2 +-
 libxfs/xfs_btree.h            | 26 +++++++++++++-------------
 libxfs/xfs_ialloc_btree.c     |  6 +++---
 libxfs/xfs_refcount_btree.c   |  4 ++--
 libxfs/xfs_rmap_btree.c       |  6 +++---
 libxfs/xfs_rtrefcount_btree.c |  4 ++--
 libxfs/xfs_rtrmap_btree.c     |  6 +++---
 repair/rcbag_btree.c          |  4 ++--
 10 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 63b8db4ed0..85ce9f728f 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -212,7 +212,7 @@
 }
 
 STATIC int64_t
-xfs_bnobt_diff_two_keys(
+xfs_bnobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -225,7 +225,7 @@
 }
 
 STATIC int64_t
-xfs_cntbt_diff_two_keys(
+xfs_cntbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -438,7 +438,7 @@
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_bnobt_key_diff,
 	.buf_ops		= &xfs_bnobt_buf_ops,
-	.diff_two_keys		= xfs_bnobt_diff_two_keys,
+	.cmp_two_keys		= xfs_bnobt_cmp_two_keys,
 	.keys_inorder		= xfs_bnobt_keys_inorder,
 	.recs_inorder		= xfs_bnobt_recs_inorder,
 	.keys_contiguous	= xfs_allocbt_keys_contiguous,
@@ -468,7 +468,7 @@
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_cntbt_key_diff,
 	.buf_ops		= &xfs_cntbt_buf_ops,
-	.diff_two_keys		= xfs_cntbt_diff_two_keys,
+	.cmp_two_keys		= xfs_cntbt_cmp_two_keys,
 	.keys_inorder		= xfs_cntbt_keys_inorder,
 	.recs_inorder		= xfs_cntbt_recs_inorder,
 	.keys_contiguous	= NULL, /* not needed right now */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 40e0cb3016..eb3e5d70de 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -378,7 +378,7 @@
 }
 
 STATIC int64_t
-xfs_bmbt_diff_two_keys(
+xfs_bmbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -647,7 +647,7 @@
 	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
-	.diff_two_keys		= xfs_bmbt_diff_two_keys,
+	.cmp_two_keys		= xfs_bmbt_cmp_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index fce215f924..78cc31f61e 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -5055,7 +5055,7 @@
 	int				error;
 
 	ASSERT(cur->bc_ops->init_high_key_from_rec);
-	ASSERT(cur->bc_ops->diff_two_keys);
+	ASSERT(cur->bc_ops->cmp_two_keys);
 
 	/*
 	 * Find the leftmost record.  The btree cursor must be set
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 355b304696..1046bbf383 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -176,15 +176,15 @@
 			    const union xfs_btree_key *key);
 
 	/*
-	 * Difference between key2 and key1 -- positive if key1 > key2,
-	 * negative if key1 < key2, and zero if equal.  If the @mask parameter
-	 * is non NULL, each key field to be used in the comparison must
-	 * contain a nonzero value.
+	 * Compare key1 and key2 -- positive if key1 > key2, negative if
+	 * key1 < key2, and zero if equal.  If the @mask parameter is non NULL,
+	 * each key field to be used in the comparison must contain a nonzero
+	 * value.
 	 */
-	int64_t (*diff_two_keys)(struct xfs_btree_cur *cur,
-				 const union xfs_btree_key *key1,
-				 const union xfs_btree_key *key2,
-				 const union xfs_btree_key *mask);
+	int64_t (*cmp_two_keys)(struct xfs_btree_cur *cur,
+				const union xfs_btree_key *key1,
+				const union xfs_btree_key *key2,
+				const union xfs_btree_key *mask);
 
 	const struct xfs_buf_ops	*buf_ops;
 
@@ -546,7 +546,7 @@
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) < 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, NULL) < 0;
 }
 
 static inline bool
@@ -555,7 +555,7 @@
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) > 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, NULL) > 0;
 }
 
 static inline bool
@@ -564,7 +564,7 @@
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) == 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, NULL) == 0;
 }
 
 static inline bool
@@ -602,7 +602,7 @@
 	const union xfs_btree_key	*key2,
 	const union xfs_btree_key	*mask)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, mask) < 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, mask) < 0;
 }
 
 static inline bool
@@ -612,7 +612,7 @@
 	const union xfs_btree_key	*key2,
 	const union xfs_btree_key	*mask)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, mask) > 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, mask) > 0;
 }
 
 static inline bool
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 4cccac145d..d5f55f7466 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -274,7 +274,7 @@
 }
 
 STATIC int64_t
-xfs_inobt_diff_two_keys(
+xfs_inobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -431,7 +431,7 @@
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-	.diff_two_keys		= xfs_inobt_diff_two_keys,
+	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 	.keys_contiguous	= xfs_inobt_keys_contiguous,
@@ -461,7 +461,7 @@
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_finobt_buf_ops,
-	.diff_two_keys		= xfs_inobt_diff_two_keys,
+	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 	.keys_contiguous	= xfs_inobt_keys_contiguous,
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index efb9af710f..63417b873c 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -188,7 +188,7 @@
 }
 
 STATIC int64_t
-xfs_refcountbt_diff_two_keys(
+xfs_refcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -340,7 +340,7 @@
 	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
 	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
-	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
+	.cmp_two_keys		= xfs_refcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
 	.keys_contiguous	= xfs_refcountbt_keys_contiguous,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index f4da35050d..0481850e46 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -273,7 +273,7 @@
 }
 
 STATIC int64_t
-xfs_rmapbt_diff_two_keys(
+xfs_rmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -516,7 +516,7 @@
 	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
-	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
@@ -633,7 +633,7 @@
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_mem_buf_ops,
-	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index a532476407..1f563a724c 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -169,7 +169,7 @@
 }
 
 STATIC int64_t
-xfs_rtrefcountbt_diff_two_keys(
+xfs_rtrefcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -387,7 +387,7 @@
 	.init_ptr_from_cur	= xfs_rtrefcountbt_init_ptr_from_cur,
 	.key_diff		= xfs_rtrefcountbt_key_diff,
 	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
-	.diff_two_keys		= xfs_rtrefcountbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rtrefcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
 	.recs_inorder		= xfs_rtrefcountbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrefcountbt_keys_contiguous,
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index d46fb67bb5..5b3836fccc 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -215,7 +215,7 @@
 }
 
 STATIC int64_t
-xfs_rtrmapbt_diff_two_keys(
+xfs_rtrmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -512,7 +512,7 @@
 	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
 	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
-	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
@@ -621,7 +621,7 @@
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
 	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
-	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
index bed7c7a8f6..404b509f64 100644
--- a/repair/rcbag_btree.c
+++ b/repair/rcbag_btree.c
@@ -73,7 +73,7 @@
 }
 
 STATIC int64_t
-rcbagbt_diff_two_keys(
+rcbagbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -222,7 +222,7 @@
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
 	.key_diff		= rcbagbt_key_diff,
 	.buf_ops		= &rcbagbt_mem_buf_ops,
-	.diff_two_keys		= rcbagbt_diff_two_keys,
+	.cmp_two_keys		= rcbagbt_cmp_two_keys,
 	.keys_inorder		= rcbagbt_keys_inorder,
 	.recs_inorder		= rcbagbt_recs_inorder,
 };
