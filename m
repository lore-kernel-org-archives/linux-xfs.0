Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5585522423F;
	Thu, 12 Jun 2025 10:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749723930; cv=none; b=A8PJQRQxqF4qFTG4Lf+z+sg8a3J55nTVrIMsY5ULgyWaWqY3Skd221DWSljl5wzj5qU0schhh5sdsxKjDT8HpXds8Ud/6LnNRjMrrdW/5aujylP+cv+UCUZD3cnfME95qsUltke7zci9hFPMXNUbFHENnP7BWLvw+drNSA3WAjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749723930; c=relaxed/simple;
	bh=9CnsJhrfbndRsgnhtB971HFRWQanRxUlBRHvmhrZ3DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Auc6aKtWY3EvlelNi/EP5Zq5Iwfu09qUXPexf9V9SeGrFE8UA52NBLc93ykLBXqd9qA/dvXTLD99Bf0njRU/9DSg2+r/znhYsPFHwNgwmIJSqSa+NqPhrGhK5UXk/gwUA750d0EYc9sDOOqqmphP2H10UwT6nT+t1D0paklQKIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=PE2VutnK; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="PE2VutnK"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id AEACB40158F5;
	Thu, 12 Jun 2025 10:25:23 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru AEACB40158F5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1749723923;
	bh=1GvrzvmxUXP7LyGCjeE5jq8DK4hB08/BY64fUOGZt9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PE2VutnKc5NKiV86urW9+Wy92X4RaWK1G7sg45fNF1xmOFv09SyukRK48uMZFyfRH
	 TGTg6vzO6bT85AThpKiiuUxmwkYX5x367gy031iV8Z6mO1sqhF4A1cdrak8mofuj0c
	 LLcKDAR/BQOnem7n374GZfNPrS1dp/MnJ1IHLzSE=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 2/6] xfs: rename key_diff routines
Date: Thu, 12 Jun 2025 13:24:46 +0300
Message-ID: <20250612102455.63024-3-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612102455.63024-1-pchelkin@ispras.ru>
References: <20250612102455.63024-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

key_diff routines compare a key value with a cursor value. Make the naming
to be a bit more self-descriptive.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 fs/xfs/libxfs/xfs_alloc_btree.c      | 8 ++++----
 fs/xfs/libxfs/xfs_bmap_btree.c       | 4 ++--
 fs/xfs/libxfs/xfs_btree.c            | 2 +-
 fs/xfs/libxfs/xfs_btree.h            | 9 ++++++---
 fs/xfs/libxfs/xfs_ialloc_btree.c     | 6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c   | 4 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c       | 6 +++---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 4 ++--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     | 6 +++---
 fs/xfs/scrub/rcbag_btree.c           | 4 ++--
 10 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 42e4b8105e47..d01807e0c4d4 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -187,7 +187,7 @@ xfs_allocbt_init_ptr_from_cur(
 }
 
 STATIC int64_t
-xfs_bnobt_key_diff(
+xfs_bnobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -198,7 +198,7 @@ xfs_bnobt_key_diff(
 }
 
 STATIC int64_t
-xfs_cntbt_key_diff(
+xfs_cntbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -438,7 +438,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.init_high_key_from_rec	= xfs_bnobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
-	.key_diff		= xfs_bnobt_key_diff,
+	.cmp_key_with_cur	= xfs_bnobt_cmp_key_with_cur,
 	.buf_ops		= &xfs_bnobt_buf_ops,
 	.cmp_two_keys		= xfs_bnobt_cmp_two_keys,
 	.keys_inorder		= xfs_bnobt_keys_inorder,
@@ -468,7 +468,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.init_high_key_from_rec	= xfs_cntbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
-	.key_diff		= xfs_cntbt_key_diff,
+	.cmp_key_with_cur	= xfs_cntbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_cntbt_buf_ops,
 	.cmp_two_keys		= xfs_cntbt_cmp_two_keys,
 	.keys_inorder		= xfs_cntbt_keys_inorder,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 1cee9c2a3dc8..0c5dba21d94a 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -370,7 +370,7 @@ xfs_bmbt_init_rec_from_cur(
 }
 
 STATIC int64_t
-xfs_bmbt_key_diff(
+xfs_bmbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -647,7 +647,7 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
-	.key_diff		= xfs_bmbt_key_diff,
+	.cmp_key_with_cur	= xfs_bmbt_cmp_key_with_cur,
 	.cmp_two_keys		= xfs_bmbt_cmp_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c8164c194841..99a63a178f25 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2070,7 +2070,7 @@ xfs_btree_lookup(
 				 *  - greater than, move left
 				 *  - equal, we're done
 				 */
-				diff = cur->bc_ops->key_diff(cur, kp);
+				diff = cur->bc_ops->cmp_key_with_cur(cur, kp);
 				if (diff < 0)
 					low = keyno + 1;
 				else if (diff > 0)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 1046bbf3839a..e72a10ba7ee6 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -171,9 +171,12 @@ struct xfs_btree_ops {
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
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 307734dbb5c7..0d0c6534259a 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -266,7 +266,7 @@ xfs_finobt_init_ptr_from_cur(
 }
 
 STATIC int64_t
-xfs_inobt_key_diff(
+xfs_inobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -430,7 +430,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
-	.key_diff		= xfs_inobt_key_diff,
+	.cmp_key_with_cur	= xfs_inobt_cmp_key_with_cur,
 	.buf_ops		= &xfs_inobt_buf_ops,
 	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
@@ -460,7 +460,7 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
-	.key_diff		= xfs_inobt_key_diff,
+	.cmp_key_with_cur	= xfs_inobt_cmp_key_with_cur,
 	.buf_ops		= &xfs_finobt_buf_ops,
 	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 83f7758dc6dc..885fc3a0a304 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -175,7 +175,7 @@ xfs_refcountbt_init_ptr_from_cur(
 }
 
 STATIC int64_t
-xfs_refcountbt_key_diff(
+xfs_refcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -339,7 +339,7 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.init_high_key_from_rec	= xfs_refcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
-	.key_diff		= xfs_refcountbt_key_diff,
+	.cmp_key_with_cur	= xfs_refcountbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
 	.cmp_two_keys		= xfs_refcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 77f586844730..74288d311b68 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -244,7 +244,7 @@ static inline uint64_t offset_keymask(uint64_t offset)
 }
 
 STATIC int64_t
-xfs_rmapbt_key_diff(
+xfs_rmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -515,7 +515,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
-	.key_diff		= xfs_rmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
 	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
@@ -632,7 +632,7 @@ const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
 	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.key_diff		= xfs_rmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rmapbt_mem_buf_ops,
 	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 3ef29477877e..864c3aa664d7 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -157,7 +157,7 @@ xfs_rtrefcountbt_init_ptr_from_cur(
 }
 
 STATIC int64_t
-xfs_rtrefcountbt_key_diff(
+xfs_rtrefcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -387,7 +387,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.init_high_key_from_rec	= xfs_rtrefcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrefcountbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrefcountbt_init_ptr_from_cur,
-	.key_diff		= xfs_rtrefcountbt_key_diff,
+	.cmp_key_with_cur	= xfs_rtrefcountbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
 	.cmp_two_keys		= xfs_rtrefcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 6325502005c4..b48336086ca7 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -186,7 +186,7 @@ static inline uint64_t offset_keymask(uint64_t offset)
 }
 
 STATIC int64_t
-xfs_rtrmapbt_key_diff(
+xfs_rtrmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -511,7 +511,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
-	.key_diff		= xfs_rtrmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rtrmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
 	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
@@ -620,7 +620,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_mem_ops = {
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.key_diff		= xfs_rtrmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rtrmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
 	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index c3c7025ca336..523ffd0da77a 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -48,7 +48,7 @@ rcbagbt_init_rec_from_cur(
 }
 
 STATIC int64_t
-rcbagbt_key_diff(
+rcbagbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -201,7 +201,7 @@ static const struct xfs_btree_ops rcbagbt_mem_ops = {
 	.init_key_from_rec	= rcbagbt_init_key_from_rec,
 	.init_rec_from_cur	= rcbagbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.key_diff		= rcbagbt_key_diff,
+	.cmp_key_with_cur	= rcbagbt_cmp_key_with_cur,
 	.buf_ops		= &rcbagbt_mem_buf_ops,
 	.cmp_two_keys		= rcbagbt_cmp_two_keys,
 	.keys_inorder		= rcbagbt_keys_inorder,
-- 
2.49.0

