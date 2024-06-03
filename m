Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA91C23A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442178; cv=none; b=HWlSlh9J5TCQj/TnK+yoFmtJGOah9k2DtGRzda6vXRNf1di1p/h6auEgEOfuwFg4IGvS2l3keL77klZV8gA7co7X/vxrvOrtPycgR/Z4ijsQg901P0Pd6/C3kErYmEGZOJ5pa4rX+rS6k3GAGll92PF1mMu6+VUzC1+62K1cVyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442178; c=relaxed/simple;
	bh=cg4s39b1B3cn/a9zZd9f2M+Rw729TZ+AWcXmCzk+Eb0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/YUKWRqRnxyTskt7RwaEbWbpUyvgj3h3S+S5R8XZ7LisjUTkLyjFZ5WRboArTgxNP+0IISGFNA1jt690o7odStZqNwstnoAzPTnjyMeDaGYZKOCJ3AS5T3FXRwwa87v6OuKx8pz5aNSLnP/OmieJ2vhKaMH0eSN8MQj/DK7Qhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAJpjYob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAJpjYob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503CAC2BD10;
	Mon,  3 Jun 2024 19:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442178;
	bh=cg4s39b1B3cn/a9zZd9f2M+Rw729TZ+AWcXmCzk+Eb0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OAJpjYob9E95shhfF9tfZatoU0hog2VALmpD/Yfzi0/fVH6rE+y9LRVOlH0lszBy8
	 aOzDmLKxtU9bXaiOn23WfGC6Rel0rMT8SKFVaJSGLP9FeHOy6lY+2GtEndsQMiVLob
	 bkBphf9hC89uyZy7nkFnsq3oTDUnh2a0Vz2urndfoO210WM6L87J8FeJ70cugQpZGB
	 EwzKexH8RiDXCxVjWRimJEFZA+T7kUScXTu/AAMjqqnvxfMP07aS68+NhWXzFOY5qt
	 iNygjsk7aBrNVLfBX6CuIUZciIDu/AgCUh7J8wEr16vhpTzb17jInnlmC0HrbcNZ/v
	 bkMiBFXmw0Efg==
Date: Mon, 03 Jun 2024 12:16:17 -0700
Subject: [PATCH 093/111] xfs: add a xfs_btree_ptrs_equal helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040763.1443973.11592247170716659672.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a989b2da2..5fd966a63 100644
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
 

