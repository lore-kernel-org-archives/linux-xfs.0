Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7749D8248D
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 05:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726637503; cv=none; b=NPNSZD/8QPLQpE+lQFSFmdCp3tuUYfoWrU7N24Tns7ODOrnPGdMCxoQVX3F4UK0lo6o0SGagVDYUwXB6NE7L6z2yfxEbtTWMtjt38kqNjiDa3+ZqqvRqlsK1nsoRXDDOgZsGpX9QZFwA7cvz02771mo9ws7b1NmoPEWn6Lfqvcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726637503; c=relaxed/simple;
	bh=iH3D/GU1Ng3AgOdSEFHs6W/k2p6abUCuArMZCvJj3Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H20onPuJcHytUMnLEAQl49DI6DXY8Uy5p35fHWDjlkwxAgWFtx8gAM6JoO1oJOlz5c3a4YfXzqiZjl09fSsz70wc6JvZyd0MALrghyOwy+bWz3nWI0fcSjyuBER5cTF7SXcuzlYmXPDP6fghKy66CjjgIFdux/01ZC9nn+SXkvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RvWn0kvn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RvWn0kvn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yxQDZliEp4BklWlRYgHCy8Y1V3WP43FN7UVC4n8KU30=; b=RvWn0kvnKpi5svQk9LkNEIIiAM
	TfFaMrBTQDjue2vjyIzKxlRiHz85+mRqp1FDUPgRFFqKuVs4A78n0+JVQG5rZ1/EKq5DvtVi905RD
	00O96ehhY/SFJm4abhpUzrgGDIW2PsYg4K8k2gFeDQT4TpUgArTsqUoanbfDowwecpdJeJylhnQrV
	DAsZqBml5JCsxUvTTs8/X1sXoa10FGU4h262nkN7VX4MD66kbOwtUCNV/5sZ1xNRMN1gsVg5/aKuW
	3O17UEQwSR9No/vyse2TxsFbjpsPpK4T8na28dMpcd/UMc84izj4O9z9+NgmhB1v4B9UEiWluSkwQ
	UUlzq0Kg==;
Received: from [62.218.44.93] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sqnHw-00000007Tmn-30p8;
	Wed, 18 Sep 2024 05:31:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: don't ifdef around the exact minlen allocations
Date: Wed, 18 Sep 2024 07:30:08 +0200
Message-ID: <20240918053117.774001-7-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240918053117.774001-1-hch@lst.de>
References: <20240918053117.774001-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Exact minlen allocations only exist as an error injection tool for debug
builds.  Currently this is implemented using ifdefs, which means the code
isn't even compiled for non-XFS_DEBUG builds.  Enhance the compile test
coverage by always building the code and use the compilers' dead code
elimination to remove it from the generated binary instead.

The only downside is that the alloc_minlen_only field is unconditionally
added to struct xfs_alloc_args now, but by moving it around and packing
it tightly this doesn't actually increase the size of the structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c | 7 ++-----
 fs/xfs/libxfs/xfs_alloc.h | 4 +---
 fs/xfs/libxfs/xfs_bmap.c  | 6 ------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 59326f84f6a571..04f64cf9777e21 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2766,7 +2766,6 @@ xfs_alloc_commit_autoreap(
 		xfs_defer_item_unpause(tp, aarp->dfp);
 }
 
-#ifdef DEBUG
 /*
  * Check if an AGF has a free extent record whose length is equal to
  * args->minlen.
@@ -2806,7 +2805,6 @@ xfs_exact_minlen_extent_available(
 
 	return error;
 }
-#endif
 
 /*
  * Decide whether to use this allocation group for this allocation.
@@ -2880,15 +2878,14 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, alloc_flags))
 		goto out_agbp_relse;
 
-#ifdef DEBUG
-	if (args->alloc_minlen_only) {
+	if (IS_ENABLED(CONFIG_XFS_DEBUG) && args->alloc_minlen_only) {
 		int stat;
 
 		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
 		if (error || !stat)
 			goto out_agbp_relse;
 	}
-#endif
+
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index fae170825be064..0165452e7cd055 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -53,11 +53,9 @@ typedef struct xfs_alloc_arg {
 	int		datatype;	/* mask defining data type treatment */
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
+	bool		alloc_minlen_only; /* allocate exact minlen extent */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
-#ifdef DEBUG
-	bool		alloc_minlen_only; /* allocate exact minlen extent */
-#endif
 } xfs_alloc_arg_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d5a8403b469b9d..5263b66bbd3c60 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3477,7 +3477,6 @@ xfs_bmap_process_allocated_extent(
 	xfs_bmap_alloc_account(ap);
 }
 
-#ifdef DEBUG
 static int
 xfs_bmap_exact_minlen_extent_alloc(
 	struct xfs_bmalloca	*ap)
@@ -3539,11 +3538,6 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 	return 0;
 }
-#else
-
-#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
-
-#endif
 
 /*
  * If we are not low on available data blocks and we are allocating at
-- 
2.45.2

