Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC67D2512FF;
	Wed,  2 Jul 2025 09:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751449223; cv=none; b=n+lw9LlUoDVFbbV9+jSI4VTGgOGyVCG07VhZUHHe4NCmzbdOY4fDxndhqHSU+AVF3iik8PMgaoXeBfd11ZuFU6isn4jw/MhqUlXu1XhAiD6iYeHbhck3LYKF1czGYtyY8TmIvTKM/HwC7xa3yJWJ2mBpWbH3QQlVc+Gpi7Z3qTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751449223; c=relaxed/simple;
	bh=PKtduxNHLaG/iyvNy/09gNTUMS1xS68Wdkb3lsnsgM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgNwadRfvzaNAFN6ZFU2nKWyt6O1pCTc2AT1u71NWEuvMlsOMblOfut7nBGcBdl/9cognvLCPn+ZuObueajgYvNDdGcaBXzX3WlmcgbBob4IvaoXJiFe9Il/u2OA6+9bUtzYEYxdCraeIjMoIvGsqkaklXiBcA84IgFYS50tsEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=p5cIqzGX; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="p5cIqzGX"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.14])
	by mail.ispras.ru (Postfix) with ESMTPSA id 4901F40737DC;
	Wed,  2 Jul 2025 09:40:13 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4901F40737DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1751449213;
	bh=RE+PudlIQdKtoBJ6OWbQXVmGrwcTEPVrgu1koayZCik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5cIqzGXxr0MrJbz73aQ3zaT+L346NCzdqj9u/qrghpWT0bhxwS1AmeV4xOHGpbG5
	 bAEqqPhSqwEy/7DZxYneFTj5w7GwRCi6ziRGIGK7Fvt3+jkszb/W6DKn3eJNwabBvp
	 5g/7bv40I86QJstBCRjER227KX+qv4kCdWnh01lk=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v2 3/6] xfs: refactor cmp_two_keys routines to take advantage of cmp_int()
Date: Wed,  2 Jul 2025 12:39:30 +0300
Message-ID: <20250702093935.123798-4-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250702093935.123798-1-pchelkin@ispras.ru>
References: <20250702093935.123798-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The net value of these functions is to determine the result of a
three-way-comparison between operands of the same type.

Simplify the code using cmp_int() to eliminate potential errors with
opencoded casts and subtractions. This also means we can change the return
value type of cmp_two_keys routines from int64_t to int and make the
interface a bit clearer.

Found by Linux Verification Center (linuxtesting.org).

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

v2: add R-b

 fs/xfs/libxfs/xfs_alloc_btree.c      | 21 ++++++++------------
 fs/xfs/libxfs/xfs_bmap_btree.c       | 18 +++--------------
 fs/xfs/libxfs/xfs_btree.h            |  2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c     |  6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c   |  6 +++---
 fs/xfs/libxfs/xfs_rmap_btree.c       | 29 ++++++++++++----------------
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  6 +++---
 fs/xfs/libxfs/xfs_rtrmap_btree.c     | 29 ++++++++++++----------------
 fs/xfs/scrub/rcbag_btree.c           | 15 +++-----------
 9 files changed, 48 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index d01807e0c4d4..f371f1b32cfb 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -213,7 +213,7 @@ xfs_cntbt_cmp_key_with_cur(
 	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
-STATIC int64_t
+STATIC int
 xfs_bnobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -222,29 +222,24 @@ xfs_bnobt_cmp_two_keys(
 {
 	ASSERT(!mask || mask->alloc.ar_startblock);
 
-	return (int64_t)be32_to_cpu(k1->alloc.ar_startblock) -
-			be32_to_cpu(k2->alloc.ar_startblock);
+	return cmp_int(be32_to_cpu(k1->alloc.ar_startblock),
+		       be32_to_cpu(k2->alloc.ar_startblock));
 }
 
-STATIC int64_t
+STATIC int
 xfs_cntbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
 	const union xfs_btree_key	*mask)
 {
-	int64_t				diff;
-
 	ASSERT(!mask || (mask->alloc.ar_blockcount &&
 			 mask->alloc.ar_startblock));
 
-	diff =  be32_to_cpu(k1->alloc.ar_blockcount) -
-		be32_to_cpu(k2->alloc.ar_blockcount);
-	if (diff)
-		return diff;
-
-	return  be32_to_cpu(k1->alloc.ar_startblock) -
-		be32_to_cpu(k2->alloc.ar_startblock);
+	return cmp_int(be32_to_cpu(k1->alloc.ar_blockcount),
+		       be32_to_cpu(k2->alloc.ar_blockcount)) ?:
+	       cmp_int(be32_to_cpu(k1->alloc.ar_startblock),
+		       be32_to_cpu(k2->alloc.ar_startblock));
 }
 
 static xfs_failaddr_t
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 0c5dba21d94a..bfe67e5d4d11 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -378,29 +378,17 @@ xfs_bmbt_cmp_key_with_cur(
 				      cur->bc_rec.b.br_startoff;
 }
 
-STATIC int64_t
+STATIC int
 xfs_bmbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
 	const union xfs_btree_key	*mask)
 {
-	uint64_t			a = be64_to_cpu(k1->bmbt.br_startoff);
-	uint64_t			b = be64_to_cpu(k2->bmbt.br_startoff);
-
 	ASSERT(!mask || mask->bmbt.br_startoff);
 
-	/*
-	 * Note: This routine previously casted a and b to int64 and subtracted
-	 * them to generate a result.  This lead to problems if b was the
-	 * "maximum" key value (all ones) being signed incorrectly, hence this
-	 * somewhat less efficient version.
-	 */
-	if (a > b)
-		return 1;
-	if (b > a)
-		return -1;
-	return 0;
+	return cmp_int(be64_to_cpu(k1->bmbt.br_startoff),
+		       be64_to_cpu(k2->bmbt.br_startoff));
 }
 
 static xfs_failaddr_t
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index e72a10ba7ee6..fecd9f0b9398 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -184,7 +184,7 @@ struct xfs_btree_ops {
 	 * each key field to be used in the comparison must contain a nonzero
 	 * value.
 	 */
-	int64_t (*cmp_two_keys)(struct xfs_btree_cur *cur,
+	int	(*cmp_two_keys)(struct xfs_btree_cur *cur,
 				const union xfs_btree_key *key1,
 				const union xfs_btree_key *key2,
 				const union xfs_btree_key *mask);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 0d0c6534259a..ab9fce20b083 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -274,7 +274,7 @@ xfs_inobt_cmp_key_with_cur(
 			  cur->bc_rec.i.ir_startino;
 }
 
-STATIC int64_t
+STATIC int
 xfs_inobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -283,8 +283,8 @@ xfs_inobt_cmp_two_keys(
 {
 	ASSERT(!mask || mask->inobt.ir_startino);
 
-	return (int64_t)be32_to_cpu(k1->inobt.ir_startino) -
-			be32_to_cpu(k2->inobt.ir_startino);
+	return cmp_int(be32_to_cpu(k1->inobt.ir_startino),
+		       be32_to_cpu(k2->inobt.ir_startino));
 }
 
 static xfs_failaddr_t
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 885fc3a0a304..1c3996b11563 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -188,7 +188,7 @@ xfs_refcountbt_cmp_key_with_cur(
 	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
 }
 
-STATIC int64_t
+STATIC int
 xfs_refcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -197,8 +197,8 @@ xfs_refcountbt_cmp_two_keys(
 {
 	ASSERT(!mask || mask->refc.rc_startblock);
 
-	return (int64_t)be32_to_cpu(k1->refc.rc_startblock) -
-			be32_to_cpu(k2->refc.rc_startblock);
+	return cmp_int(be32_to_cpu(k1->refc.rc_startblock),
+		       be32_to_cpu(k2->refc.rc_startblock));
 }
 
 STATIC xfs_failaddr_t
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 74288d311b68..3cccdb0d0418 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -273,7 +273,7 @@ xfs_rmapbt_cmp_key_with_cur(
 	return 0;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -282,36 +282,31 @@ xfs_rmapbt_cmp_two_keys(
 {
 	const struct xfs_rmap_key	*kp1 = &k1->rmap;
 	const struct xfs_rmap_key	*kp2 = &k2->rmap;
-	int64_t				d;
-	__u64				x, y;
+	int				d;
 
 	/* Doesn't make sense to mask off the physical space part */
 	ASSERT(!mask || mask->rmap.rm_startblock);
 
-	d = (int64_t)be32_to_cpu(kp1->rm_startblock) -
-		     be32_to_cpu(kp2->rm_startblock);
+	d = cmp_int(be32_to_cpu(kp1->rm_startblock),
+		    be32_to_cpu(kp2->rm_startblock));
 	if (d)
 		return d;
 
 	if (!mask || mask->rmap.rm_owner) {
-		x = be64_to_cpu(kp1->rm_owner);
-		y = be64_to_cpu(kp2->rm_owner);
-		if (x > y)
-			return 1;
-		else if (y > x)
-			return -1;
+		d = cmp_int(be64_to_cpu(kp1->rm_owner),
+			    be64_to_cpu(kp2->rm_owner));
+		if (d)
+			return d;
 	}
 
 	if (!mask || mask->rmap.rm_offset) {
 		/* Doesn't make sense to allow offset but not owner */
 		ASSERT(!mask || mask->rmap.rm_owner);
 
-		x = offset_keymask(be64_to_cpu(kp1->rm_offset));
-		y = offset_keymask(be64_to_cpu(kp2->rm_offset));
-		if (x > y)
-			return 1;
-		else if (y > x)
-			return -1;
+		d = cmp_int(offset_keymask(be64_to_cpu(kp1->rm_offset)),
+			    offset_keymask(be64_to_cpu(kp2->rm_offset)));
+		if (d)
+			return d;
 	}
 
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 864c3aa664d7..d9f79ae579c6 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -170,7 +170,7 @@ xfs_rtrefcountbt_cmp_key_with_cur(
 	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rtrefcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -179,8 +179,8 @@ xfs_rtrefcountbt_cmp_two_keys(
 {
 	ASSERT(!mask || mask->refc.rc_startblock);
 
-	return (int64_t)be32_to_cpu(k1->refc.rc_startblock) -
-			be32_to_cpu(k2->refc.rc_startblock);
+	return cmp_int(be32_to_cpu(k1->refc.rc_startblock),
+		       be32_to_cpu(k2->refc.rc_startblock));
 }
 
 static xfs_failaddr_t
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index b48336086ca7..231a189ea2fe 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -215,7 +215,7 @@ xfs_rtrmapbt_cmp_key_with_cur(
 	return 0;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rtrmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -224,36 +224,31 @@ xfs_rtrmapbt_cmp_two_keys(
 {
 	const struct xfs_rmap_key	*kp1 = &k1->rmap;
 	const struct xfs_rmap_key	*kp2 = &k2->rmap;
-	int64_t				d;
-	__u64				x, y;
+	int				d;
 
 	/* Doesn't make sense to mask off the physical space part */
 	ASSERT(!mask || mask->rmap.rm_startblock);
 
-	d = (int64_t)be32_to_cpu(kp1->rm_startblock) -
-		     be32_to_cpu(kp2->rm_startblock);
+	d = cmp_int(be32_to_cpu(kp1->rm_startblock),
+		    be32_to_cpu(kp2->rm_startblock));
 	if (d)
 		return d;
 
 	if (!mask || mask->rmap.rm_owner) {
-		x = be64_to_cpu(kp1->rm_owner);
-		y = be64_to_cpu(kp2->rm_owner);
-		if (x > y)
-			return 1;
-		else if (y > x)
-			return -1;
+		d = cmp_int(be64_to_cpu(kp1->rm_owner),
+			    be64_to_cpu(kp2->rm_owner));
+		if (d)
+			return d;
 	}
 
 	if (!mask || mask->rmap.rm_offset) {
 		/* Doesn't make sense to allow offset but not owner */
 		ASSERT(!mask || mask->rmap.rm_owner);
 
-		x = offset_keymask(be64_to_cpu(kp1->rm_offset));
-		y = offset_keymask(be64_to_cpu(kp2->rm_offset));
-		if (x > y)
-			return 1;
-		else if (y > x)
-			return -1;
+		d = cmp_int(offset_keymask(be64_to_cpu(kp1->rm_offset)),
+			    offset_keymask(be64_to_cpu(kp2->rm_offset)));
+		if (d)
+			return d;
 	}
 
 	return 0;
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 523ffd0da77a..46598817b239 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -68,7 +68,7 @@ rcbagbt_cmp_key_with_cur(
 	return 0;
 }
 
-STATIC int64_t
+STATIC int
 rcbagbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -80,17 +80,8 @@ rcbagbt_cmp_two_keys(
 
 	ASSERT(mask == NULL);
 
-	if (kp1->rbg_startblock > kp2->rbg_startblock)
-		return 1;
-	if (kp1->rbg_startblock < kp2->rbg_startblock)
-		return -1;
-
-	if (kp1->rbg_blockcount > kp2->rbg_blockcount)
-		return 1;
-	if (kp1->rbg_blockcount < kp2->rbg_blockcount)
-		return -1;
-
-	return 0;
+	return cmp_int(kp1->rbg_startblock, kp2->rbg_startblock) ?:
+	       cmp_int(kp1->rbg_blockcount, kp2->rbg_blockcount);
 }
 
 STATIC int
-- 
2.50.0

