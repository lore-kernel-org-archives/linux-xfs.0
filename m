Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596A0BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUzIw4uJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248D8C433C7;
	Sun, 31 Dec 2023 20:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055225;
	bh=o++nJb3VA5Fqb5PqXPCQy2pn9EcDfOV1L0YtJ73cEoc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gUzIw4uJG0kDzJ6ZZ4Oo7oTK4GKDgC+egFSvoqNgJeDqVvgJV3X7ZZysVHjNLE/L9
	 oBH5VCpHeakxbjyntLXz/Gqioa8hNkdMC6lOFIfoNr3jQTTg/GQDRd2ah41pxPrjoB
	 PqJj/5GsDlE4o6Ut+HpyOTypARVCoRp74bIL2Z79H4Hr0BZ1C0WzdMquATy6/9sxCe
	 Swj2OLObTN3W52y1I1+vZMNDAtkPSEPpow2RTrvpz4TWNOgv/9zFx0byN0xvmfU6gV
	 2PZBfBDPfJDWRY+4vLph73Bd+47XYW6Zqj9UW2ZbNMrji5cgrfhXNTrEUptvREDRXF
	 RsY3OKvOHCY5g==
Date: Sun, 31 Dec 2023 12:40:24 -0800
Subject: [PATCH 2/3] xfs: use b_offset to support direct-mapping pages when
 blocksize < pagesize
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404837630.1754104.9143395380611692112.stgit@frogsfrogsfrogs>
In-Reply-To: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support using directly-mapped pages in the buffer cache when the fs
blocksize is less than the page size.  This is not strictly necessary
since the only user of direct-map buffers always uses page-sized
buffers, but I included it here for completeness.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c       |    8 ++++++--
 fs/xfs/xfs_buf_xfile.c |   20 +++++++++++++++++---
 2 files changed, 23 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ca7657d0ea592..d86227e852b7f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -321,7 +321,7 @@ xfs_buf_free(
 	ASSERT(list_empty(&bp->b_lru));
 
 	if (xfs_buf_is_vmapped(bp))
-		vm_unmap_ram(bp->b_addr, bp->b_page_count);
+		vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
 
 	if (bp->b_flags & _XBF_DIRECT_MAP)
 		xfile_buf_unmap_pages(bp);
@@ -434,6 +434,8 @@ xfs_buf_alloc_pages(
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		memalloc_retry_wait(gfp_mask);
 	}
+
+	bp->b_offset = 0;
 	return 0;
 }
 
@@ -449,7 +451,7 @@ _xfs_buf_map_pages(
 
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]);
+		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 	} else if (flags & XBF_UNMAPPED) {
 		bp->b_addr = NULL;
 	} else {
@@ -476,6 +478,8 @@ _xfs_buf_map_pages(
 
 		if (!bp->b_addr)
 			return -ENOMEM;
+
+		bp->b_addr += bp->b_offset;
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_buf_xfile.c b/fs/xfs/xfs_buf_xfile.c
index be1e54be070ce..58469a91e72bc 100644
--- a/fs/xfs/xfs_buf_xfile.c
+++ b/fs/xfs/xfs_buf_xfile.c
@@ -163,15 +163,27 @@ xfile_buf_map_pages(
 	gfp_t			gfp_mask = __GFP_NOWARN;
 	const unsigned int	page_align_mask = PAGE_SIZE - 1;
 	unsigned int		m, p, n;
+	unsigned int		first_page_offset;
 	int			error;
 
 	ASSERT(xfile_buftarg_can_direct_map(bp->b_target));
 
-	/* For direct-map buffers, each map has to be page aligned. */
-	for (m = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++)
-		if (BBTOB(map->bm_bn | map->bm_len) & page_align_mask)
+	/*
+	 * For direct-map buffer targets with multiple mappings, the first map
+	 * must end on a page boundary and the rest of the mappings must start
+	 * and end on a page boundary.  For single-mapping buffers, we don't
+	 * care.
+	 */
+	if (bp->b_map_count > 1) {
+		map = &bp->b_maps[0];
+		if (BBTOB(map->bm_bn + map->bm_len) & page_align_mask)
 			return -ENOTBLK;
 
+		for (m = 1, map++; m < bp->b_map_count - 1; m++, map++)
+			if (BBTOB(map->bm_bn | map->bm_len) & page_align_mask)
+				return -ENOTBLK;
+	}
+
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
 	else
@@ -182,6 +194,7 @@ xfile_buf_map_pages(
 		return error;
 
 	/* Map in the xfile pages. */
+	first_page_offset = offset_in_page(BBTOB(xfs_buf_daddr(bp)));
 	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
 		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
 			unsigned int	len;
@@ -198,6 +211,7 @@ xfile_buf_map_pages(
 	}
 
 	bp->b_flags |= _XBF_DIRECT_MAP;
+	bp->b_offset = first_page_offset;
 	return 0;
 
 fail:

