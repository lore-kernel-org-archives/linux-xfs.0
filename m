Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0CB1C32FF;
	Thu, 12 Jun 2025 10:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749723929; cv=none; b=biC+DSOxiVG9QnSqzkZm1SNNBVg/jlXJvkdEmmJeTeqvfE5RbRgnqO6p03TWKmt+bShZyke7zW/EixRWHl98six8MsLJBO4qN4qmyDc1daGYSlpTrypHAc/vm4vs4XjJvg4BaOispsrKM55tTbHC/vWD+7P3DsBaj07Dgmi3ziw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749723929; c=relaxed/simple;
	bh=8voO2mOf/c8Uy8iuxSiWobrz/7hPMbrqmEbU1cIFsmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffoNZ+GBbf7MfiId5D/f1H1D9KNPLVzJVXvrOiWb8l1K618f0i5b4kpsPWpesp4EmCdrWrr5DJ2WbZRK88BxNziuEzNsByqRhQ1NR39D1cw7wlo64mzPwwLXWIkt7LXwQYhRWOE+tsHZMkOAzWhmSaYAgce7t8YTTDRzHO2gA08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=XFTfe5IP; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="XFTfe5IP"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id EB46F40737C3;
	Thu, 12 Jun 2025 10:25:24 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru EB46F40737C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1749723925;
	bh=f/V6lTWeM8h4Rn8orKvo94b8cHJt/QGhZ2c0fxjXVAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFTfe5IPZJtJ+z8CxFnvi0NdDbe0LHbPyw0tWlPhVdj5TLIW1NkEs4rKo+IZ9l66L
	 KE8sGocpTOA4BVBsn5ICMHrL+JooAaC7uG/Mgt5wKfm8ywysVuPc2rNVhZt+azPwXf
	 J9/FnYTjAlvNSHdDVcysDuaIM6TDcY8GMfb9iOaU=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 4/6] xfs: refactor cmp_key_with_cur routines to take advantage of cmp_int()
Date: Thu, 12 Jun 2025 13:24:48 +0300
Message-ID: <20250612102455.63024-5-pchelkin@ispras.ru>
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

The net value of these functions is to determine the result of a
three-way-comparison between operands of the same type.

Simplify the code using cmp_int() to eliminate potential errors with
opencoded casts and subtractions. This also means we can change the return
value type of cmp_key_with_cur routines from int64_t to int and make the
interface a bit clearer.

Found by Linux Verification Center (linuxtesting.org).

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 fs/xfs/libxfs/xfs_alloc_btree.c      | 15 ++++++---------
 fs/xfs/libxfs/xfs_bmap_btree.c       |  6 +++---
 fs/xfs/libxfs/xfs_btree.h            |  2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c     |  6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c   |  4 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c       | 26 +++++---------------------
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  4 ++--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     | 26 +++++---------------------
 fs/xfs/scrub/rcbag_btree.c           | 15 +++------------
 9 files changed, 30 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index f371f1b32cfb..fa1f03c1331e 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -186,7 +186,7 @@ xfs_allocbt_init_ptr_from_cur(
 		ptr->s = agf->agf_cnt_root;
 }
 
-STATIC int64_t
+STATIC int
 xfs_bnobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -194,23 +194,20 @@ xfs_bnobt_cmp_key_with_cur(
 	struct xfs_alloc_rec_incore	*rec = &cur->bc_rec.a;
 	const struct xfs_alloc_rec	*kp = &key->alloc;
 
-	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
+	return cmp_int(be32_to_cpu(kp->ar_startblock),
+		       rec->ar_startblock);
 }
 
-STATIC int64_t
+STATIC int
 xfs_cntbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
 	struct xfs_alloc_rec_incore	*rec = &cur->bc_rec.a;
 	const struct xfs_alloc_rec	*kp = &key->alloc;
-	int64_t				diff;
-
-	diff = (int64_t)be32_to_cpu(kp->ar_blockcount) - rec->ar_blockcount;
-	if (diff)
-		return diff;
 
-	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
+	return cmp_int(be32_to_cpu(kp->ar_blockcount), rec->ar_blockcount) ?:
+	       cmp_int(be32_to_cpu(kp->ar_startblock), rec->ar_startblock);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index bfe67e5d4d11..188feac04b60 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -369,13 +369,13 @@ xfs_bmbt_init_rec_from_cur(
 	xfs_bmbt_disk_set_all(&rec->bmbt, &cur->bc_rec.b);
 }
 
-STATIC int64_t
+STATIC int
 xfs_bmbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
-	return (int64_t)be64_to_cpu(key->bmbt.br_startoff) -
-				      cur->bc_rec.b.br_startoff;
+	return cmp_int(be64_to_cpu(key->bmbt.br_startoff),
+		       cur->bc_rec.b.br_startoff);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index fecd9f0b9398..1bf20d509ac9 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -175,7 +175,7 @@ struct xfs_btree_ops {
 	 * Compare key value and cursor value -- positive if key > cur,
 	 * negative if key < cur, and zero if equal.
 	 */
-	int64_t (*cmp_key_with_cur)(struct xfs_btree_cur *cur,
+	int	(*cmp_key_with_cur)(struct xfs_btree_cur *cur,
 				    const union xfs_btree_key *key);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index ab9fce20b083..100afdd66cdd 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -265,13 +265,13 @@ xfs_finobt_init_ptr_from_cur(
 	ptr->s = agi->agi_free_root;
 }
 
-STATIC int64_t
+STATIC int
 xfs_inobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
-	return (int64_t)be32_to_cpu(key->inobt.ir_startino) -
-			  cur->bc_rec.i.ir_startino;
+	return cmp_int(be32_to_cpu(key->inobt.ir_startino),
+		       cur->bc_rec.i.ir_startino);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 1c3996b11563..06da3ca14727 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -174,7 +174,7 @@ xfs_refcountbt_init_ptr_from_cur(
 	ptr->s = agf->agf_refcount_root;
 }
 
-STATIC int64_t
+STATIC int
 xfs_refcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -185,7 +185,7 @@ xfs_refcountbt_cmp_key_with_cur(
 
 	start = xfs_refcount_encode_startblock(irec->rc_startblock,
 			irec->rc_domain);
-	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
+	return cmp_int(be32_to_cpu(kp->rc_startblock), start);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 3cccdb0d0418..bf16aee50d73 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -243,34 +243,18 @@ static inline uint64_t offset_keymask(uint64_t offset)
 	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
 	struct xfs_rmap_irec		*rec = &cur->bc_rec.r;
 	const struct xfs_rmap_key	*kp = &key->rmap;
-	__u64				x, y;
-	int64_t				d;
-
-	d = (int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
-	if (d)
-		return d;
 
-	x = be64_to_cpu(kp->rm_owner);
-	y = rec->rm_owner;
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
-
-	x = offset_keymask(be64_to_cpu(kp->rm_offset));
-	y = offset_keymask(xfs_rmap_irec_offset_pack(rec));
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
-	return 0;
+	return cmp_int(be32_to_cpu(kp->rm_startblock), rec->rm_startblock) ?:
+	       cmp_int(be64_to_cpu(kp->rm_owner), rec->rm_owner) ?:
+	       cmp_int(offset_keymask(be64_to_cpu(kp->rm_offset)),
+		       offset_keymask(xfs_rmap_irec_offset_pack(rec)));
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index d9f79ae579c6..ac11e94b42ae 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -156,7 +156,7 @@ xfs_rtrefcountbt_init_ptr_from_cur(
 	ptr->l = 0;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rtrefcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -167,7 +167,7 @@ xfs_rtrefcountbt_cmp_key_with_cur(
 
 	start = xfs_refcount_encode_startblock(irec->rc_startblock,
 			irec->rc_domain);
-	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
+	return cmp_int(be32_to_cpu(kp->rc_startblock), start);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 231a189ea2fe..55f903165769 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -185,34 +185,18 @@ static inline uint64_t offset_keymask(uint64_t offset)
 	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rtrmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
 	struct xfs_rmap_irec		*rec = &cur->bc_rec.r;
 	const struct xfs_rmap_key	*kp = &key->rmap;
-	__u64				x, y;
-	int64_t				d;
-
-	d = (int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
-	if (d)
-		return d;
 
-	x = be64_to_cpu(kp->rm_owner);
-	y = rec->rm_owner;
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
-
-	x = offset_keymask(be64_to_cpu(kp->rm_offset));
-	y = offset_keymask(xfs_rmap_irec_offset_pack(rec));
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
-	return 0;
+	return cmp_int(be32_to_cpu(kp->rm_startblock), rec->rm_startblock) ?:
+	       cmp_int(be64_to_cpu(kp->rm_owner), rec->rm_owner) ?:
+	       cmp_int(offset_keymask(be64_to_cpu(kp->rm_offset)),
+		       offset_keymask(xfs_rmap_irec_offset_pack(rec)));
 }
 
 STATIC int
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 46598817b239..9a4ef823c5a7 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -47,7 +47,7 @@ rcbagbt_init_rec_from_cur(
 	bag_rec->rbg_refcount = bag_irec->rbg_refcount;
 }
 
-STATIC int64_t
+STATIC int
 rcbagbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -55,17 +55,8 @@ rcbagbt_cmp_key_with_cur(
 	struct rcbag_rec		*rec = (struct rcbag_rec *)&cur->bc_rec;
 	const struct rcbag_key		*kp = (const struct rcbag_key *)key;
 
-	if (kp->rbg_startblock > rec->rbg_startblock)
-		return 1;
-	if (kp->rbg_startblock < rec->rbg_startblock)
-		return -1;
-
-	if (kp->rbg_blockcount > rec->rbg_blockcount)
-		return 1;
-	if (kp->rbg_blockcount < rec->rbg_blockcount)
-		return -1;
-
-	return 0;
+	return cmp_int(kp->rbg_startblock, rec->rbg_startblock) ?:
+	       cmp_int(kp->rbg_blockcount, rec->rbg_blockcount);
 }
 
 STATIC int
-- 
2.49.0

