Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A663271449
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582358; cv=none; b=ngutHU0IVA/JPJy5TMK0VtOuJM8/sz9YW6nRcMuxjm37MKDWH/DGCZWjvUG9qumUUf0geAOU7ex993icOW/X3wjgy0Zz/nFpdTca7uXMqfCdpdAyU8mOILgM0BwV6GY1fFGBeJsp/n4g39xMWRTZOGf0Iz7aMiK3vGsLoZlN+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582358; c=relaxed/simple;
	bh=1xDa1kRtWnteo6GeniyOWv3x5rQL10XbwIn/JCC0myQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TilPCgOacd3RJ4AmEiAJZkMFaQ1jAxJ8U016/QOMZ0IYlewdunpJ4AcbeUjRF81rMQ/slM2C9nU0EBaHaVPZc6EIfyLkx6hSgUJw8WQAPB7/rf/tDSuDThl1uNXUZEC/l+DSRqT6CZ9MRCmLVY70UUVX5MVCD8iLmI35XuF5wT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TR7dufJD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TR7dufJD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MgDp4GNKvEYs03oqZoigd3HlgWneeGUHl7H9flw2lMw=; b=TR7dufJDogD+EJcT01xiKKqhUu
	dxMUIxCLLtHUJFIGme9aLH6hwR1OMho95To1uKhdwCJ5tfDHbDSMbMftMIpY19zIlacFRc4qYuEpQ
	uDDAutjELihcMCCQ106iD+lVuL6t1B+9lkwzVpJVAwYJVQZNgP5BLxRBu00msgZJjBD9G+/mRfrwV
	LQRb0MvF4PXnkRiKy9WjltmoK+NPMIaoINRtb7DwqFahJOJyb94rPhqPX5iFTFcaoEEDfTvxziI1F
	j3F/UN8BzQ0+gWUOHO5ZJItoDkPOpGylOUwVmhTrOQJMadKVSrKaDQKI9iFsyMlCCACN7MflUrzo5
	+i7ovuBQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubejM-000000053yU-1KKp;
	Tue, 15 Jul 2025 12:25:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc
Date: Tue, 15 Jul 2025 14:25:36 +0200
Message-ID: <20250715122544.1943403-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715122544.1943403-1-hch@lst.de>
References: <20250715122544.1943403-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_trans_alloc_empty only shares the very basic transaction structure
allocation and initialization with xfs_trans_alloc.

Split out a new __xfs_trans_alloc helper for that and otherwise decouple
xfs_trans_alloc_empty from xfs_trans_alloc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 52 +++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 1fddea8d761a..e43f44f62c5f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -241,6 +241,28 @@ xfs_trans_reserve(
 	return error;
 }
 
+static struct xfs_trans *
+__xfs_trans_alloc(
+	struct xfs_mount	*mp,
+	uint			flags)
+{
+	struct xfs_trans	*tp;
+
+	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp));
+
+	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
+	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
+		sb_start_intwrite(mp->m_super);
+	xfs_trans_set_context(tp);
+	tp->t_flags = flags;
+	tp->t_mountp = mp;
+	INIT_LIST_HEAD(&tp->t_items);
+	INIT_LIST_HEAD(&tp->t_busy);
+	INIT_LIST_HEAD(&tp->t_dfops);
+	tp->t_highest_agno = NULLAGNUMBER;
+	return tp;
+}
+
 int
 xfs_trans_alloc(
 	struct xfs_mount	*mp,
@@ -254,33 +276,16 @@ xfs_trans_alloc(
 	bool			want_retry = true;
 	int			error;
 
+	ASSERT(resp->tr_logres > 0);
+
 	/*
 	 * Allocate the handle before we do our freeze accounting and setting up
 	 * GFP_NOFS allocation context so that we avoid lockdep false positives
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 	 */
 retry:
-	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
-	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
-		sb_start_intwrite(mp->m_super);
-	xfs_trans_set_context(tp);
-
-	/*
-	 * Zero-reservation ("empty") transactions can't modify anything, so
-	 * they're allowed to run while we're frozen.
-	 */
-	WARN_ON(resp->tr_logres > 0 &&
-		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
-	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
-	       xfs_has_lazysbcount(mp));
-
-	tp->t_flags = flags;
-	tp->t_mountp = mp;
-	INIT_LIST_HEAD(&tp->t_items);
-	INIT_LIST_HEAD(&tp->t_busy);
-	INIT_LIST_HEAD(&tp->t_dfops);
-	tp->t_highest_agno = NULLAGNUMBER;
-
+	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
+	tp = __xfs_trans_alloc(mp, flags);
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error == -ENOSPC && want_retry) {
 		xfs_trans_cancel(tp);
@@ -329,9 +334,8 @@ xfs_trans_alloc_empty(
 	struct xfs_mount		*mp,
 	struct xfs_trans		**tpp)
 {
-	struct xfs_trans_res		resv = {0};
-
-	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
+	*tpp = __xfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
+	return 0;
 }
 
 /*
-- 
2.47.2

