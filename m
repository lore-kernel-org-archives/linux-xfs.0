Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196B4652
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817491; cv=none; b=lY6kfa1BgIyo57lOlmcUOvYgZfYH40G5LqxbfK22yd4rSTSdVLuHrS17aB15d8I46vtupnTMCP0OcF2Oq84KH5BYX+DzL+ZWOPdNHF3JguxN7Szhub8BKmMHZooqCdWpd0Sd2nzhoVxVXSRPRt2Cwca6G019e8w8QTt+xcpVxrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817491; c=relaxed/simple;
	bh=fwHZdvOPEOwoMQJwb80gXT9M0IDFg17/pGh3c60LBlc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CxvqjWRS+oCdB0LrFcwjJu8LEhfPOJdS8ulQ/veMNPkpEbuZQHwNsfJg6KpimDTavJSc86ZaHStsYU1CZrgpJGH7d3XwmcfXzEB7t/CKosQtfb8fTuW6M94/YuSmuBW0yODp1dGDrF4haV3ZZpfDWbsoMvMb7QunMYwDVtQ2pRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dod+6rCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dod+6rCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AB6C433F1;
	Thu,  1 Feb 2024 19:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817490;
	bh=fwHZdvOPEOwoMQJwb80gXT9M0IDFg17/pGh3c60LBlc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dod+6rCgf0IaXUwh7+nFO5cvXdwOUMH8v2mxDrBBsrO++X74pd5cz5xLEW/Xu/5Y0
	 wvSUF+FhMSGK7w6dY5B2bra01N/OgM1WovweaEPUbS7W/XCM4Vx4trVvhvQBp7gg7b
	 TGs4+GK2BlwdzKuah7T6mmNEYf2tXB4D6rppb0WiayarpFm1qA/PoNHLTBhXuOmsWe
	 mBskauOhDdhYPkJmchsD3Uts1NroyFfzC6nYFFwyOixJxbzrsH527GJQax9VzbQUgk
	 /uxINmoc+PIwK+LLiFs8XFrtlmLJsH7nQPtzA/y7eZC9kY7onrc336Lt0D57ZQBnSE
	 85gqFm8sg/1hw==
Date: Thu, 01 Feb 2024 11:58:10 -0800
Subject: [PATCH 3/5] xfs: add a xfs_btree_ptrs_equal helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org,
 willy@infradead.org
Message-ID: <170681337008.1608400.5344176407453392727.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
References: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

This only has a single caller and thus might be a bit questionable,
but I think it really improves the readability of
xfs_btree_visit_block.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index ecdd5ea27a038..aa60a46b8eecc 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1043,6 +1043,17 @@ xfs_btree_set_ptr_null(
 		ptr->s = cpu_to_be32(NULLAGBLOCK);
 }
 
+static inline bool
+xfs_btree_ptrs_equal(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_ptr		*ptr1,
+	union xfs_btree_ptr		*ptr2)
+{
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
+		return ptr1->l == ptr2->l;
+	return ptr1->s == ptr2->s;
+}
+
 /*
  * Get/set/init sibling pointers
  */
@@ -4365,7 +4376,7 @@ xfs_btree_visit_block(
 {
 	struct xfs_btree_block		*block;
 	struct xfs_buf			*bp;
-	union xfs_btree_ptr		rptr;
+	union xfs_btree_ptr		rptr, bufptr;
 	int				error;
 
 	/* do right sibling readahead */
@@ -4388,19 +4399,12 @@ xfs_btree_visit_block(
 	 * return the same block without checking if the right sibling points
 	 * back to us and creates a cyclic reference in the btree.
 	 */
-	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
-		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
-							xfs_buf_daddr(bp))) {
-			xfs_btree_mark_sick(cur);
-			return -EFSCORRUPTED;
-		}
-	} else {
-		if (be32_to_cpu(rptr.s) == xfs_daddr_to_agbno(cur->bc_mp,
-							xfs_buf_daddr(bp))) {
-			xfs_btree_mark_sick(cur);
-			return -EFSCORRUPTED;
-		}
+	xfs_btree_buf_to_ptr(cur, bp, &bufptr);
+	if (xfs_btree_ptrs_equal(cur, &rptr, &bufptr)) {
+		xfs_btree_mark_sick(cur);
+		return -EFSCORRUPTED;
 	}
+
 	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
 }
 

