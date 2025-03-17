Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E0C218AA3
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190541; cv=none; b=sbclQx9m33+cUvmt8kWWihoxzW43UBONrb2iDKKbqBJQYbXn5xbwhrvtXhxU28KDIacJySTXdqo6TWR4Jt+Ichy33bKI7+g2GrNWNoA0CRI9Y4Xrt8whzrYo4W8da192mLbpbcHRwjaNoqiNwD7zXdj/OFkIVR5FWRIiT0osUdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190541; c=relaxed/simple;
	bh=//LM7jjQnUAaWqyjNSeh9VDblxyGe3aj+NYJUg3IQ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gABEl88VhctHEEkO1mQ5ifRF4uoIhAzVNl3uTzgJlJn/gOTsSDWSCga6P4x7cdgm6+fbo+FRuwgodM3rhk6+dVfYco8qipiHRVt2ZHKfdEeLxW2w/e2xHzjC185RzsznEVI72LIGxaW0h6ti8nRuQE1lqEHNKuepGMzx/bYuSiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SFKMi9Tt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SFKMi9Tt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qR277G8WDBq2PbF1kAry2DjkDCOky1J5eydA3MAbvzQ=; b=SFKMi9Tt26zhiIanMNNp4G+Azd
	ccPbIRbvmRdKAJBQK4Arbj68p7Dloh1VFhe8JFk1z7ZH2CmNkEnOl5RBXqgz+3JV1SpcGCJN7cFPX
	Swgl8YekZIFg5Rn3NwhJERXUHVzvTLbjEZcQdGWM5v1gRAv0S2JheuwbuKSCYKWUqEmzfEazbvNej
	nM2LG17N2S9suKIxETgZs3zrqCP596uoYcggaX2BS5GlC1lBmnvjZunty66xwmOLeqWpM7hh83wWS
	YRPhyu8DKQCdHy/WmAB64KMeG64Avw7EtEaBLGkhdM1VkmHoi++crCbdz+GiSIZMhoU0DmNwyM7yJ
	UwtkhkVw==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3LO-00000001Ins-4C8f;
	Mon, 17 Mar 2025 05:48:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: remove xfs_buf_get_maps
Date: Mon, 17 Mar 2025 06:48:33 +0100
Message-ID: <20250317054850.1132557-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250317054850.1132557-1-hch@lst.de>
References: <20250317054850.1132557-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_get_maps has a single caller, and can just be open coded there.
When doing that, stop handling the allocation failure as we always pass
__GFP_NOFAIL to the slab allocator, and use the proper kcalloc helper for
array allocations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f42f6e47f783..878dc0f108d1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -88,26 +88,6 @@ xfs_buf_stale(
 	spin_unlock(&bp->b_lock);
 }
 
-static int
-xfs_buf_get_maps(
-	struct xfs_buf		*bp,
-	int			map_count)
-{
-	ASSERT(bp->b_maps == NULL);
-	bp->b_map_count = map_count;
-
-	if (map_count == 1) {
-		bp->b_maps = &bp->__b_map;
-		return 0;
-	}
-
-	bp->b_maps = kzalloc(map_count * sizeof(struct xfs_buf_map),
-			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-	if (!bp->b_maps)
-		return -ENOMEM;
-	return 0;
-}
-
 static void
 xfs_buf_free_maps(
 	struct xfs_buf	*bp)
@@ -317,15 +297,14 @@ xfs_buf_alloc(
 	bp->b_target = target;
 	bp->b_mount = target->bt_mount;
 	bp->b_flags = flags;
-
-	error = xfs_buf_get_maps(bp, nmaps);
-	if (error)  {
-		kmem_cache_free(xfs_buf_cache, bp);
-		return error;
-	}
-
 	bp->b_rhash_key = map[0].bm_bn;
 	bp->b_length = 0;
+	bp->b_map_count = nmaps;
+	if (nmaps == 1)
+		bp->b_maps = &bp->__b_map;
+	else
+		bp->b_maps = kcalloc(nmaps, sizeof(struct xfs_buf_map),
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	for (i = 0; i < nmaps; i++) {
 		bp->b_maps[i].bm_bn = map[i].bm_bn;
 		bp->b_maps[i].bm_len = map[i].bm_len;
-- 
2.45.2

