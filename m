Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9137328A0
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803996; cv=none; b=oVt5cvB8awRykyAiQ86PL3APPpsF/fRWT0HvdbwQeYEIVDwIsdqgx+c+x5GM5oGD59Kz5ur0DobC4g/CheMJlwoSbLUgChxLfQZ4zZCP0EsGRPAVYeD9dJVUlUB/N0taJjTP7qqaIgc2yYhnhVF7eS1U0aRMfBHxKMrWvK9rj/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803996; c=relaxed/simple;
	bh=axADbrm1DdtL0QWmuCyYnKjOPgKPBQJx7q4+VK1lzPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdATXJvZC1YU7r8OAeG54Hhp0ATqyGJ2OpHaYqSAl/aYpPtRGVrsb/nGVF3xJVh/xVbGiO6ehbSHFoDHrN5XX3AmzNqZ4dsPqC6TViVPge+EvC7Qblk+oqhARi2HblR7dy6Wc9quJSNyZf+p+BI3l20vHKY4SNK5dsWMvNuzLlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWhfe0aC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWhfe0aC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B06C113CC;
	Mon, 22 Apr 2024 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803995;
	bh=axADbrm1DdtL0QWmuCyYnKjOPgKPBQJx7q4+VK1lzPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWhfe0aCGbRQiIW/v2t7bVrOd72XBFeq8WfCKP6uNS/EVOBmY20z8Oxe6Act3Wcwo
	 PJqXUk08XhXE+XLwqFqZAocQvBOZGo0uphtHflUkHoVQsszzxFPUUUbqAdXHSj9IjG
	 +ESz/muXbWIpQjGbAaeu7BqgeG+N5RJWSMSbS2lRW5BnC+tx2+87A/7nb5w1kT6lgC
	 5EysCFN6qGDnnCmb+4qBHElbOT31dR8UB+Hqk5JW8Paj/au65ywVupZ9KGg5qbbEjm
	 HyFA4tOs4sCUcgbh+XzOyJ/CIHFj+9ArY6CIA2MLeMmcEa8CmAkiokJ0QcWZT0j8p3
	 FGnNfbLDpzYfw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 31/67] xfs: read leaf blocks when computing keys for bulkloading into node blocks
Date: Mon, 22 Apr 2024 18:25:53 +0200
Message-ID: <20240422163832.858420-33-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 26de64629d8b439a03bce243f14a46f7440729f3

When constructing a new btree, xfs_btree_bload_node needs to read the
btree blocks for level N to compute the keyptrs for the blocks that will
be loaded into level N+1.  The level N blocks must be formatted at that
point.

A subsequent patch will change the btree bulkloader to write new btree
blocks in 256K chunks to moderate memory consumption if the new btree is
very large.  As a consequence of that, it's possible that the buffers
for lower level blocks might have been reclaimed by the time the node
builder comes back to the block.

Therefore, change xfs_btree_bload_node to read the lower level blocks
to handle the reclaimed buffer case.  As a side effect, the read will
increase the LRU refs, which will bias towards keeping new btree buffers
in memory after the new btree commits.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_btree.c         | 2 +-
 libxfs/xfs_btree.h         | 3 +++
 libxfs/xfs_btree_staging.c | 7 ++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 85f8bef06..97962fc16 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1327,7 +1327,7 @@ xfs_btree_get_buf_block(
  * Read in the buffer at the given ptr and return the buffer and
  * the block pointer within the buffer.
  */
-STATIC int
+int
 xfs_btree_read_buf_block(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*ptr,
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 4d68a58be..e0875cec4 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -700,6 +700,9 @@ void xfs_btree_set_ptr_null(struct xfs_btree_cur *cur,
 int xfs_btree_get_buf_block(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr, struct xfs_btree_block **block,
 		struct xfs_buf **bpp);
+int xfs_btree_read_buf_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr, int flags,
+		struct xfs_btree_block **block, struct xfs_buf **bpp);
 void xfs_btree_set_sibling(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, const union xfs_btree_ptr *ptr,
 		int lr);
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index ae2d9c63f..be0b43e45 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -489,7 +489,12 @@ xfs_btree_bload_node(
 
 		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
 
-		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
+		/*
+		 * Read the lower-level block in case the buffer for it has
+		 * been reclaimed.  LRU refs will be set on the block, which is
+		 * desirable if the new btree commits.
+		 */
+		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
 				&child_bp);
 		if (ret)
 			return ret;
-- 
2.44.0

