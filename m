Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459A2BA27
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295268; cv=none; b=Psin3SebrH5aB62QEvjWcf5GUNzVrtJIMP5dMcuB+dbIoeumeV7NhR8vijCeI5xtmvWRabG4Cv55bvCblufDi1PE8PvwXp1VN5ALUEl4WkJWOk4m7SXKfMu4epaOKPN3e/O9RG7ViIltz4wLCgp1g3yA0gQrvJ/NKrfUMHERCf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295268; c=relaxed/simple;
	bh=wn1I9/kzpl3StY/YmEcFy2uojakuv0fyM8IEeX704YU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bBiYCsopu+BgxleicO9+JVJEZiQEgq94J2RsuQFHRZz++b9zd+JDKNjZMP3cILZ2GVimCl36d7HsW1/HJRBZ2WnqSHmxVTF4LfqUUvLm2arFkH/BwdNXZe6lzAhUsZxvKHjsyQvhJuj5Wk4+9rqFgjlH7uZCjEOan18OsHb862g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uKZiTltV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uKZiTltV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9961CC43399;
	Wed, 13 Mar 2024 02:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295267;
	bh=wn1I9/kzpl3StY/YmEcFy2uojakuv0fyM8IEeX704YU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uKZiTltV0yB9jPlaYPR5cvMaszD4T5btX2GylMEFgE4cNBTcJBm6lgUJPqAuRQ14w
	 5gngFEC7LuXF2/cko/kuMFch44n4/GeZ/erP271blOnouCQh5E9UAfEeKxecBE1l3d
	 2Q0/jE6B0O7q9BnDhQ/pnOxkl1c7Tqn6knOm2SrZ8cpwRFBTU7f8U/dMDZqq6cBcYE
	 +egqWYi9p5ZxL5sZ8CWQBw7jCVjeQwf4fjoYoVBt1elKCjvnsQMA7cLdtPYuqG/vXo
	 Yf8A/W1Y/iTYalbyLJTErvOUHITFSiHsM/L2qAvp+td+WTRaV7OL+LAVyvDFHDATKi
	 btbfEk3AZYvHg==
Date: Tue, 12 Mar 2024 19:01:07 -0700
Subject: [PATCH 31/67] xfs: read leaf blocks when computing keys for
 bulkloading into node blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431641.2061787.11426108394278141993.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_btree.c         |    2 +-
 libxfs/xfs_btree.h         |    3 +++
 libxfs/xfs_btree_staging.c |    7 ++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 85f8bef0610a..97962fc16ec4 100644
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
index 4d68a58be160..e0875cec4939 100644
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
index ae2d9c63f484..be0b43e45f52 100644
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

