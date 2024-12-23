Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99BD1AB53A;
	Mon, 23 Dec 2024 22:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991844; cv=none; b=IJYct1sZamZk0PYU/hGcD1O6s39CZgY6UWaFv5hIwWxpry34g5jaoYlb+rA+FhBCY2P4E1sssGCiWTptVqTY5V5UniHKvTW49rqaXMMsmY0obhYAuQGy+bxv5RKjT+5UonKYyE8D5db7Yuv5bAlx7fYvOJEEVQ6kOzlbzrvmiJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991844; c=relaxed/simple;
	bh=KttecI5jKLPJ/fTaZsaphDKwQ4RKhSAYqGE/zwMNCFc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WqpSYsNtRsnGpii+YNPd59+FjxuQ+9Zi+RhL7cC8C60WDxE2LRPl0zzB0sZjzaglDu0VYOb4fMBsySklXzyHv5Co7FWEpJ3shzSacpjLI86W/bH0lxg1LUUgjGO3gXVkx/w1g/9w94dX2SK7O0ouE0+l13r5wAT8gxfRRAeRVDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNUAn1Kh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNUAn1Kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4547EC4CED3;
	Mon, 23 Dec 2024 22:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991844;
	bh=KttecI5jKLPJ/fTaZsaphDKwQ4RKhSAYqGE/zwMNCFc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YNUAn1KhYNF+K9NO6UkJKul3+IAacpmVsrAlRaj21b+4Q2G+RMWcoyS8m1XUetKI/
	 RkoPTUA/SrPzGLwnAhU5mA/3yeDi3JIWc4wPQlQlJsnefh8yDR3mBujsqRmsxvBq6I
	 EZg+oe/fJPQDWrVCvV8yQ+LyxAEfgp5aBNWuu4SLbE7T6DO20I/PaeYH57WDqVKigm
	 F9Whlwm3Zi7FGigDXHE3+PjzoRjFiTonla6lzaJeGacD/qb4ibeVK3WP5y3PpA+AqV
	 CoP19Ic5Z3Ys3oyqyrh4ELfsJP9vFjgqe3rURYdhIqwBZs8fPAaaE5vJBkbjcsYatp
	 lZEkEk/Hbig+g==
Date: Mon, 23 Dec 2024 14:10:43 -0800
Subject: [PATCH 48/52] xfs: return a 64-bit block count from
 xfs_btree_count_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943225.2295836.6586781956533561026.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: bd27c7bcdca25ce8067ebb94ded6ac1bd7b47317

With the nrext64 feature enabled, it's possible for a data fork to have
2^48 extent mappings.  Even with a 64k fsblock size, that maps out to
a bmbt containing more than 2^32 blocks.  Therefore, this predicate must
return a u64 count to avoid an integer wraparound that will cause scrub
to do the wrong thing.

It's unlikely that any such filesystem currently exists, because the
incore bmbt would consume more than 64GB of kernel memory on its own,
and so far nobody except me has driven a filesystem that far, judging
from the lack of complaints.

Cc: <stable@vger.kernel.org> # v5.19
Fixes: df9ad5cc7a5240 ("xfs: Introduce macros to represent new maximum extent counts for data/attr forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.c        |    4 ++--
 libxfs/xfs_btree.h        |    2 +-
 libxfs/xfs_ialloc_btree.c |    4 +++-
 3 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3d870f3f4a5165..5c293ccf623336 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -5142,7 +5142,7 @@ xfs_btree_count_blocks_helper(
 	int			level,
 	void			*data)
 {
-	xfs_extlen_t		*blocks = data;
+	xfs_filblks_t		*blocks = data;
 	(*blocks)++;
 
 	return 0;
@@ -5152,7 +5152,7 @@ xfs_btree_count_blocks_helper(
 int
 xfs_btree_count_blocks(
 	struct xfs_btree_cur	*cur,
-	xfs_extlen_t		*blocks)
+	xfs_filblks_t		*blocks)
 {
 	*blocks = 0;
 	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 3b739459ebb0f4..c5bff273cae255 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -484,7 +484,7 @@ typedef int (*xfs_btree_visit_blocks_fn)(struct xfs_btree_cur *cur, int level,
 int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
 		xfs_btree_visit_blocks_fn fn, unsigned int flags, void *data);
 
-int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_extlen_t *blocks);
+int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_filblks_t *blocks);
 
 union xfs_btree_rec *xfs_btree_rec_addr(struct xfs_btree_cur *cur, int n,
 		struct xfs_btree_block *block);
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 19fca9fad62b1d..4cccac145dc775 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -743,6 +743,7 @@ xfs_finobt_count_blocks(
 {
 	struct xfs_buf		*agbp = NULL;
 	struct xfs_btree_cur	*cur;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
@@ -750,9 +751,10 @@ xfs_finobt_count_blocks(
 		return error;
 
 	cur = xfs_finobt_init_cursor(pag, tp, agbp);
-	error = xfs_btree_count_blocks(cur, tree_blocks);
+	error = xfs_btree_count_blocks(cur, &blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
+	*tree_blocks = blocks;
 
 	return error;
 }

