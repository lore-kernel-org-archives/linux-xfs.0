Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555EF1F92E;
	Thu, 12 Jun 2025 10:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749723928; cv=none; b=p1xikMjNtZKmt8Mp2hZuDHsXbON7UHkNtb8fOwp4cN+QMFbyhXheF74NUa1GUERY1Y/uSBCHSVzV+edjl3oRjB7fmx1DqUpxv1rmCdGwoGdk/KcLAzDIwbQejw2X8pVpL7HKCRUKEHe+9v8anmT5S57hHosutm2PvivX/AV5FGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749723928; c=relaxed/simple;
	bh=VONAksVjcSO2s2yj8Zp764n0sujrMwWVxwCoqAbUey0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIZR675w2pJrnYhThsqAn7xSd4vEkZyOCPCIX0qi4EigMpk8PyXCdg6BNPDvrpplk2zAzBe9Mur5iBqFcXhLSUiv/SFtoIvjE4gkeiGfuP+P/QqMNvnJm3RIb82XQuL2dWwM0Tb98ChQZ6X9dDJd3fZ1Wx/02iBmZZcznk9Z3EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=hrrorbEs; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="hrrorbEs"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id E5778552F556;
	Thu, 12 Jun 2025 10:25:22 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru E5778552F556
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1749723923;
	bh=uB8s/TKRC+X6h2ermWN9k7gOsdkkqDl0MQCvqPkW/g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrrorbEszFJAGmwDVR27MqFagABSGbWrEfroH2kRtPw7PEvPsXeGCHCkLwxG1CkIG
	 sMe4qtz84y6MlIowMehSz6xZhKX1Z8H3zlg2wFUaf+IbKmbWMTWNmF7iw59QiHs2Pg
	 wnNnYKIAO5AFpth83JvjT5o79FoHGsANp5LK9LhE=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 1/6] xfs: rename diff_two_keys routines
Date: Thu, 12 Jun 2025 13:24:45 +0300
Message-ID: <20250612102455.63024-2-pchelkin@ispras.ru>
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

One may think that diff_two_keys routines are used to compute the actual
difference between the arguments but they return a result of a
three-way-comparison of the passed operands. So it looks more appropriate
to denote them as cmp_two_keys.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 fs/xfs/libxfs/xfs_alloc_btree.c      |  8 ++++----
 fs/xfs/libxfs/xfs_bmap_btree.c       |  4 ++--
 fs/xfs/libxfs/xfs_btree.c            |  2 +-
 fs/xfs/libxfs/xfs_btree.h            | 26 +++++++++++++-------------
 fs/xfs/libxfs/xfs_ialloc_btree.c     |  6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c   |  4 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c       |  6 +++---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  4 ++--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |  6 +++---
 fs/xfs/scrub/rcbag_btree.c           |  4 ++--
 10 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a4ac37ba5d51..42e4b8105e47 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -214,7 +214,7 @@ xfs_cntbt_key_diff(
 }
 
 STATIC int64_t
-xfs_bnobt_diff_two_keys(
+xfs_bnobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -227,7 +227,7 @@ xfs_bnobt_diff_two_keys(
 }
 
 STATIC int64_t
-xfs_cntbt_diff_two_keys(
+xfs_cntbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -440,7 +440,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_bnobt_key_diff,
 	.buf_ops		= &xfs_bnobt_buf_ops,
-	.diff_two_keys		= xfs_bnobt_diff_two_keys,
+	.cmp_two_keys		= xfs_bnobt_cmp_two_keys,
 	.keys_inorder		= xfs_bnobt_keys_inorder,
 	.recs_inorder		= xfs_bnobt_recs_inorder,
 	.keys_contiguous	= xfs_allocbt_keys_contiguous,
@@ -470,7 +470,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_cntbt_key_diff,
 	.buf_ops		= &xfs_cntbt_buf_ops,
-	.diff_two_keys		= xfs_cntbt_diff_two_keys,
+	.cmp_two_keys		= xfs_cntbt_cmp_two_keys,
 	.keys_inorder		= xfs_cntbt_keys_inorder,
 	.recs_inorder		= xfs_cntbt_recs_inorder,
 	.keys_contiguous	= NULL, /* not needed right now */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 908d7b050e9c..1cee9c2a3dc8 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -379,7 +379,7 @@ xfs_bmbt_key_diff(
 }
 
 STATIC int64_t
-xfs_bmbt_diff_two_keys(
+xfs_bmbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -648,7 +648,7 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
-	.diff_two_keys		= xfs_bmbt_diff_two_keys,
+	.cmp_two_keys		= xfs_bmbt_cmp_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 299ce7fd11b0..c8164c194841 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5058,7 +5058,7 @@ xfs_btree_simple_query_range(
 	int				error;
 
 	ASSERT(cur->bc_ops->init_high_key_from_rec);
-	ASSERT(cur->bc_ops->diff_two_keys);
+	ASSERT(cur->bc_ops->cmp_two_keys);
 
 	/*
 	 * Find the leftmost record.  The btree cursor must be set
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 355b304696e6..1046bbf3839a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -176,15 +176,15 @@ struct xfs_btree_ops {
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
 
@@ -546,7 +546,7 @@ xfs_btree_keycmp_lt(
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) < 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, NULL) < 0;
 }
 
 static inline bool
@@ -555,7 +555,7 @@ xfs_btree_keycmp_gt(
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) > 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, NULL) > 0;
 }
 
 static inline bool
@@ -564,7 +564,7 @@ xfs_btree_keycmp_eq(
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) == 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, NULL) == 0;
 }
 
 static inline bool
@@ -602,7 +602,7 @@ xfs_btree_masked_keycmp_lt(
 	const union xfs_btree_key	*key2,
 	const union xfs_btree_key	*mask)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, mask) < 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, mask) < 0;
 }
 
 static inline bool
@@ -612,7 +612,7 @@ xfs_btree_masked_keycmp_gt(
 	const union xfs_btree_key	*key2,
 	const union xfs_btree_key	*mask)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, mask) > 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, mask) > 0;
 }
 
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 6f270d8f4270..307734dbb5c7 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -275,7 +275,7 @@ xfs_inobt_key_diff(
 }
 
 STATIC int64_t
-xfs_inobt_diff_two_keys(
+xfs_inobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -432,7 +432,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-	.diff_two_keys		= xfs_inobt_diff_two_keys,
+	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 	.keys_contiguous	= xfs_inobt_keys_contiguous,
@@ -462,7 +462,7 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_finobt_buf_ops,
-	.diff_two_keys		= xfs_inobt_diff_two_keys,
+	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 	.keys_contiguous	= xfs_inobt_keys_contiguous,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 54505fee1852..83f7758dc6dc 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -189,7 +189,7 @@ xfs_refcountbt_key_diff(
 }
 
 STATIC int64_t
-xfs_refcountbt_diff_two_keys(
+xfs_refcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -341,7 +341,7 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
 	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
-	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
+	.cmp_two_keys		= xfs_refcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
 	.keys_contiguous	= xfs_refcountbt_keys_contiguous,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 2cab694ac58a..77f586844730 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -274,7 +274,7 @@ xfs_rmapbt_key_diff(
 }
 
 STATIC int64_t
-xfs_rmapbt_diff_two_keys(
+xfs_rmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -517,7 +517,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
-	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
@@ -634,7 +634,7 @@ const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_mem_buf_ops,
-	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 3db5e7a4a945..3ef29477877e 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -171,7 +171,7 @@ xfs_rtrefcountbt_key_diff(
 }
 
 STATIC int64_t
-xfs_rtrefcountbt_diff_two_keys(
+xfs_rtrefcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -389,7 +389,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.init_ptr_from_cur	= xfs_rtrefcountbt_init_ptr_from_cur,
 	.key_diff		= xfs_rtrefcountbt_key_diff,
 	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
-	.diff_two_keys		= xfs_rtrefcountbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rtrefcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
 	.recs_inorder		= xfs_rtrefcountbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrefcountbt_keys_contiguous,
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 9bdc2cbfc113..6325502005c4 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -216,7 +216,7 @@ xfs_rtrmapbt_key_diff(
 }
 
 STATIC int64_t
-xfs_rtrmapbt_diff_two_keys(
+xfs_rtrmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -513,7 +513,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
 	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
-	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
@@ -622,7 +622,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_mem_ops = {
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
 	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
-	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 709356dc6256..c3c7025ca336 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -69,7 +69,7 @@ rcbagbt_key_diff(
 }
 
 STATIC int64_t
-rcbagbt_diff_two_keys(
+rcbagbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -203,7 +203,7 @@ static const struct xfs_btree_ops rcbagbt_mem_ops = {
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
 	.key_diff		= rcbagbt_key_diff,
 	.buf_ops		= &rcbagbt_mem_buf_ops,
-	.diff_two_keys		= rcbagbt_diff_two_keys,
+	.cmp_two_keys		= rcbagbt_cmp_two_keys,
 	.keys_inorder		= rcbagbt_keys_inorder,
 	.recs_inorder		= rcbagbt_recs_inorder,
 };
-- 
2.49.0

