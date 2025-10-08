Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8D72EC555
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759942529; cv=none; b=eDziX7Fs49mUIMtBBPdhoujhQom6nGUNO81LCtC2dRPrUsfXNVUsZoNpX7Kj0ptkcOFlxM4s6qvYPcSZlIu4mdAZNY/B7LOKrH0Fa4St+VZP5WdyQq36cDpiyQK/GtE419Ybj/yBrak5RW1wJ11+pM0QLA/LqNl6eeQdiK/7Jws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759942529; c=relaxed/simple;
	bh=xtYkubePYCbC9CaqzYSKSsQkO187W8GUPtvxh8JBSVc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P0fCXPl/A41hH4DjufZZzfvDfmmovv8WS6ySMfaT2A5hcgvavRIHXzKjsjXWXeExFa7fjmrkxuK4Qml4Xp4tFPG4ei8RQuKQkVKGI0b08TKG0Ih7UZV1/lFM1WhhSWlSi1CQNvDuLLpDTcSa87I68ugwqJjjeYhwjX4GnlZHx4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92037C4CEE7;
	Wed,  8 Oct 2025 16:55:26 +0000 (UTC)
Date: Wed, 8 Oct 2025 18:55:24 +0200
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH 4/11] [PATCH] xfs: refactor cmp_key_with_cur routines to take
 advantage of cmp_int()
Message-ID: <vzli4wtrpsrkzklbm6c4afm3h6s4izso6yscruif46covebhn4@l6v5uftifs4l>
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

Source kernel commit: 734b871d6cf7d4f815bb1eff8c808289079701c2

The net value of these functions is to determine the result of a
three-way-comparison between operands of the same type.

Simplify the code using cmp_int() to eliminate potential errors with
opencoded casts and subtractions. This also means we can change the return
value type of cmp_key_with_cur routines from int64_t to int and make the
interface a bit clearer.

Found by Linux Verification Center (linuxtesting.org).

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_alloc_btree.c      | 17 +++++++----------
 libxfs/xfs_bmap_btree.c       |  6 +++---
 libxfs/xfs_btree.h            |  2 +-
 libxfs/xfs_ialloc_btree.c     |  6 +++---
 libxfs/xfs_refcount_btree.c   |  4 ++--
 libxfs/xfs_rmap_btree.c       | 28 ++++++----------------------
 libxfs/xfs_rtrefcount_btree.c |  4 ++--
 libxfs/xfs_rtrmap_btree.c     | 28 ++++++----------------------
 repair/rcbag_btree.c          |  2 +-
 9 files changed, 31 insertions(+), 66 deletions(-)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index c3c69a9de3..1604e1bb62 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -184,7 +184,7 @@
 		ptr->s = agf->agf_cnt_root;
 }
 
-STATIC int64_t
+STATIC int
 xfs_bnobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -192,23 +192,20 @@
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
-
-	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
+
+	return cmp_int(be32_to_cpu(kp->ar_blockcount), rec->ar_blockcount) ?:
+	       cmp_int(be32_to_cpu(kp->ar_startblock), rec->ar_startblock);
 }
 
 STATIC int
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 19eab66fad..252da347b0 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -368,13 +368,13 @@
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index fecd9f0b93..1bf20d509a 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -175,7 +175,7 @@
 	 * Compare key value and cursor value -- positive if key > cur,
 	 * negative if key < cur, and zero if equal.
 	 */
-	int64_t (*cmp_key_with_cur)(struct xfs_btree_cur *cur,
+	int	(*cmp_key_with_cur)(struct xfs_btree_cur *cur,
 				    const union xfs_btree_key *key);
 
 	/*
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 973ae62d39..dab9b61bd2 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -264,13 +264,13 @@
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
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 668c788dca..44d942e9d0 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -173,7 +173,7 @@
 	ptr->s = agf->agf_refcount_root;
 }
 
-STATIC int64_t
+STATIC int
 xfs_refcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -184,7 +184,7 @@
 
 	start = xfs_refcount_encode_startblock(irec->rc_startblock,
 			irec->rc_domain);
-	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
+	return cmp_int(be32_to_cpu(kp->rc_startblock), start);
 }
 
 STATIC int
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ab207b9cc2..d7b9fccc3a 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -242,34 +242,18 @@
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
-
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
+
+	return cmp_int(be32_to_cpu(kp->rm_startblock), rec->rm_startblock) ?:
+	       cmp_int(be64_to_cpu(kp->rm_owner), rec->rm_owner) ?:
+	       cmp_int(offset_keymask(be64_to_cpu(kp->rm_offset)),
+		       offset_keymask(xfs_rmap_irec_offset_pack(rec)));
 }
 
 STATIC int
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 7fbbc6387c..77191f073a 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -154,7 +154,7 @@
 	ptr->l = 0;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rtrefcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -165,7 +165,7 @@
 
 	start = xfs_refcount_encode_startblock(irec->rc_startblock,
 			irec->rc_domain);
-	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
+	return cmp_int(be32_to_cpu(kp->rc_startblock), start);
 }
 
 STATIC int
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 0492cd55d5..633dca0333 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -184,34 +184,18 @@
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
-
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
+
+	return cmp_int(be32_to_cpu(kp->rm_startblock), rec->rm_startblock) ?:
+	       cmp_int(be64_to_cpu(kp->rm_owner), rec->rm_owner) ?:
+	       cmp_int(offset_keymask(be64_to_cpu(kp->rm_offset)),
+		       offset_keymask(xfs_rmap_irec_offset_pack(rec)));
 }
 
 STATIC int
diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
index c42a2ca0d1..fc5f69c4d2 100644
--- a/repair/rcbag_btree.c
+++ b/repair/rcbag_btree.c
@@ -46,7 +46,7 @@
 	bag_rec->rbg_refcount = bag_irec->rbg_refcount;
 }
 
-STATIC int64_t
+STATIC int
 rcbagbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
