Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F4484D12
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425162; cv=none; b=MgUrE/5POLYDBPPpjoGfDmWYvAmhLl0S/Ei7cLN/Byk5YwyhtOzF0jROEUjGyo7NmAt2Gr+dRwmGbJ2esbC3WSo+KadhTgyZqjaRdgVr2DuF/npbS57j8ae+mLx3QTO+iKUr7SNzihkc6RoS6N9nc2615zy5tEF+9SLQY5W5Ado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425162; c=relaxed/simple;
	bh=2IeCg6rpEjTkLd/0/2oq/wJWXoYH/WSXbNueUlvI7Co=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MqNjBLde1FOHxXOOJaF4v1xx0q4BPxVSGkVhGD/ZgDU/VM98qKbhP8N44L3GY95qDO7dHGG9JaiyPV4fNgGLdI3AaRGgokcKqwnOtoy1zO3OOdDSDZkQTTuOq3+RRk5eYrAfe+W19rVC4mAUc6ur83QA3ULGQbhV4erDELkiMLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZO5gi9TA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZO5gi9TA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E3DC433C7;
	Tue, 26 Mar 2024 03:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425162;
	bh=2IeCg6rpEjTkLd/0/2oq/wJWXoYH/WSXbNueUlvI7Co=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZO5gi9TAh/uNJTlT66pwYWdjx8ssgYTUN+GCuO8sXZ9uzHbz2dLROikXMu4ojGC4M
	 xgybrsM2NUcXAgf9e/si076U5M8AzRoAy/u8iVRjNpguA8C3uUcJ/uVGKDdNNq7jXE
	 IvkLlwyMeiv1oF41yJSfXHszCHFcbVPOzpwyOswiOMUffbIN8azw1vPyVTN/1MtBC3
	 ETk7tAksmX+hlVdCxaEUcqjue+hG8gDdqsO7giO35/TYqE9pSxXWeZgUYPO5yje7+V
	 uqYH9eVZ/QCkPbCPRfaFG4g7e6Dt+9q8ZcJgxLdMMXecewTF84jyy2L5B9+X+IYkTo
	 8sNN3DUWGkmGQ==
Date: Mon, 25 Mar 2024 20:52:41 -0700
Subject: [PATCH 093/110] xfs: add a xfs_btree_ptrs_equal helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132719.2215168.10847260518840612695.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8c1771c45dfa9dddd4569727c48204b66073d2c2

This only has a single caller and thus might be a bit questionable,
but I think it really improves the readability of
xfs_btree_visit_block.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a989b2da2dd5..5fd966a63371 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1040,6 +1040,17 @@ xfs_btree_set_ptr_null(
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
@@ -4362,7 +4373,7 @@ xfs_btree_visit_block(
 {
 	struct xfs_btree_block		*block;
 	struct xfs_buf			*bp;
-	union xfs_btree_ptr		rptr;
+	union xfs_btree_ptr		rptr, bufptr;
 	int				error;
 
 	/* do right sibling readahead */
@@ -4385,19 +4396,12 @@ xfs_btree_visit_block(
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
 

