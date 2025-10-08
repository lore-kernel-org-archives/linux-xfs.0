Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728782BEC23
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759942502; cv=none; b=A1HbN4GuC3Wu2ynn49AwfzLTtuVRcHmOiK6gKOd6GvEzd6vZre7c5yk+8tK8tghvW64st8Ix8Xmvmbi1Pezrf5iRe0O9mJGKzPcpYURyuLyCsMQmKidVcF3/D0TTLCBWNbbgNKarJ7zCrMI45hyu1DQFPOMoVZAhAx/QMxDasc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759942502; c=relaxed/simple;
	bh=DdVpKEGRx5nabBlpBa3PSgleZQBo3U8MuG2eAq0TxV0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cJcElK2bxkhXXKMYt7ujGCjNF5xwK8IDoOPYpTl4G3Z+5GmTRIAujenESwHl9I+Twd7U0AWclURPPD8jf3Qi66ihR9dCi2K8/xzze2WjIt1Apmpoai1RvLhOPKfPg5UZSRplF2knL8Sox0h1uwqeC8XIIQGzpRFt594R/V8VBmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D31C4CEF4;
	Wed,  8 Oct 2025 16:54:59 +0000 (UTC)
Date: Wed, 8 Oct 2025 18:54:58 +0200
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH 2/11] [PATCH] xfs: rename key_diff routines
Message-ID: <tnjouief5jx5xvzhtmseezok6tnh6dbjs5tbqi6kqh4qydsvek@ye3o2woryog3>
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

Source kernel commit: 82b63ee160016096436aa026a27c8d85d40f3fb1

key_diff routines compare a key value with a cursor value. Make the naming
to be a bit more self-descriptive.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_alloc_btree.c      | 8 ++++----
 libxfs/xfs_bmap_btree.c       | 4 ++--
 libxfs/xfs_btree.c            | 2 +-
 libxfs/xfs_btree.h            | 9 ++++++---
 libxfs/xfs_ialloc_btree.c     | 6 +++---
 libxfs/xfs_refcount_btree.c   | 4 ++--
 libxfs/xfs_rmap_btree.c       | 6 +++---
 libxfs/xfs_rtrefcount_btree.c | 4 ++--
 libxfs/xfs_rtrmap_btree.c     | 6 +++---
 repair/rcbag_btree.c          | 4 ++--
 10 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 85ce9f728f..6e7af0020b 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -185,7 +185,7 @@
 }
 
 STATIC int64_t
-xfs_bnobt_key_diff(
+xfs_bnobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -196,7 +196,7 @@
 }
 
 STATIC int64_t
-xfs_cntbt_key_diff(
+xfs_cntbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -436,7 +436,7 @@
 	.init_high_key_from_rec	= xfs_bnobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
-	.key_diff		= xfs_bnobt_key_diff,
+	.cmp_key_with_cur	= xfs_bnobt_cmp_key_with_cur,
 	.buf_ops		= &xfs_bnobt_buf_ops,
 	.cmp_two_keys		= xfs_bnobt_cmp_two_keys,
 	.keys_inorder		= xfs_bnobt_keys_inorder,
@@ -466,7 +466,7 @@
 	.init_high_key_from_rec	= xfs_cntbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
-	.key_diff		= xfs_cntbt_key_diff,
+	.cmp_key_with_cur	= xfs_cntbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_cntbt_buf_ops,
 	.cmp_two_keys		= xfs_cntbt_cmp_two_keys,
 	.keys_inorder		= xfs_cntbt_keys_inorder,
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index eb3e5d70de..3fc23444f3 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -369,7 +369,7 @@
 }
 
 STATIC int64_t
-xfs_bmbt_key_diff(
+xfs_bmbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -646,7 +646,7 @@
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
-	.key_diff		= xfs_bmbt_key_diff,
+	.cmp_key_with_cur	= xfs_bmbt_cmp_key_with_cur,
 	.cmp_two_keys		= xfs_bmbt_cmp_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 78cc31f61e..15846f0ff6 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -2067,7 +2067,7 @@
 				 *  - greater than, move left
 				 *  - equal, we're done
 				 */
-				diff = cur->bc_ops->key_diff(cur, kp);
+				diff = cur->bc_ops->cmp_key_with_cur(cur, kp);
 				if (diff < 0)
 					low = keyno + 1;
 				else if (diff > 0)
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 1046bbf383..e72a10ba7e 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -171,9 +171,12 @@
 	void	(*init_high_key_from_rec)(union xfs_btree_key *key,
 					  const union xfs_btree_rec *rec);
 
-	/* difference between key value and cursor value */
-	int64_t (*key_diff)(struct xfs_btree_cur *cur,
-			    const union xfs_btree_key *key);
+	/*
+	 * Compare key value and cursor value -- positive if key > cur,
+	 * negative if key < cur, and zero if equal.
+	 */
+	int64_t (*cmp_key_with_cur)(struct xfs_btree_cur *cur,
+				    const union xfs_btree_key *key);
 
 	/*
 	 * Compare key1 and key2 -- positive if key1 > key2, negative if
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index d5f55f7466..d56876c5be 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -265,7 +265,7 @@
 }
 
 STATIC int64_t
-xfs_inobt_key_diff(
+xfs_inobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -429,7 +429,7 @@
 	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
-	.key_diff		= xfs_inobt_key_diff,
+	.cmp_key_with_cur	= xfs_inobt_cmp_key_with_cur,
 	.buf_ops		= &xfs_inobt_buf_ops,
 	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
@@ -459,7 +459,7 @@
 	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
-	.key_diff		= xfs_inobt_key_diff,
+	.cmp_key_with_cur	= xfs_inobt_cmp_key_with_cur,
 	.buf_ops		= &xfs_finobt_buf_ops,
 	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 63417b873c..0924ab7eb7 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -174,7 +174,7 @@
 }
 
 STATIC int64_t
-xfs_refcountbt_key_diff(
+xfs_refcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -338,7 +338,7 @@
 	.init_high_key_from_rec	= xfs_refcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
-	.key_diff		= xfs_refcountbt_key_diff,
+	.cmp_key_with_cur	= xfs_refcountbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
 	.cmp_two_keys		= xfs_refcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 0481850e46..ea946616bf 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -243,7 +243,7 @@
 }
 
 STATIC int64_t
-xfs_rmapbt_key_diff(
+xfs_rmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -514,7 +514,7 @@
 	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
-	.key_diff		= xfs_rmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
 	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
@@ -631,7 +631,7 @@
 	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.key_diff		= xfs_rmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rmapbt_mem_buf_ops,
 	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 1f563a724c..7a4eec49ca 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -155,7 +155,7 @@
 }
 
 STATIC int64_t
-xfs_rtrefcountbt_key_diff(
+xfs_rtrefcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -385,7 +385,7 @@
 	.init_high_key_from_rec	= xfs_rtrefcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrefcountbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrefcountbt_init_ptr_from_cur,
-	.key_diff		= xfs_rtrefcountbt_key_diff,
+	.cmp_key_with_cur	= xfs_rtrefcountbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
 	.cmp_two_keys		= xfs_rtrefcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 5b3836fccc..59a99bb42c 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -185,7 +185,7 @@
 }
 
 STATIC int64_t
-xfs_rtrmapbt_key_diff(
+xfs_rtrmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -510,7 +510,7 @@
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
-	.key_diff		= xfs_rtrmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rtrmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
 	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
@@ -619,7 +619,7 @@
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.key_diff		= xfs_rtrmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rtrmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
 	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
index 404b509f64..704e66e9fb 100644
--- a/repair/rcbag_btree.c
+++ b/repair/rcbag_btree.c
@@ -47,7 +47,7 @@
 }
 
 STATIC int64_t
-rcbagbt_key_diff(
+rcbagbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -220,7 +220,7 @@
 	.init_key_from_rec	= rcbagbt_init_key_from_rec,
 	.init_rec_from_cur	= rcbagbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.key_diff		= rcbagbt_key_diff,
+	.cmp_key_with_cur	= rcbagbt_cmp_key_with_cur,
 	.buf_ops		= &rcbagbt_mem_buf_ops,
 	.cmp_two_keys		= rcbagbt_cmp_two_keys,
 	.keys_inorder		= rcbagbt_keys_inorder,
