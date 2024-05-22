Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C03C28FD
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347582; cv=none; b=bjadCcOGxjazqDlHd6sMVo426PNuw9JgVrkSWqG1zw71w5jEY9InQPKFwmBYC6IMfPBKTr2EYzwVbwmRMYmbFK98jtUQdAnJnOG1VYgi82Aoy3iZTevyBh5fC5yMaoi6lcrJE02mJau9tVr71rYTRgvrTRA5IHXJBSy0n6BHQuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347582; c=relaxed/simple;
	bh=xr20z03IEzaU0KRTUnnOg0p6PLI/0qpM26l51ZppzyQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EhprdWAMX3ve0QN0PwK36XNBHP4iPo7bVKsZXC2uCHoz04eqmcoF/5v/F2xCGh6CmTrxh+lq1RCB7z98s1Uotxu8k3f+H3oILZBLIUPCo+/QI86pyCMhAXHRuG8SyWn7wzxHPeKxeJ9T16y8AeTOz7VjANsas+jIugrBcApNOCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RN6/6lyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RN6/6lyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EF8C2BD11;
	Wed, 22 May 2024 03:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347582;
	bh=xr20z03IEzaU0KRTUnnOg0p6PLI/0qpM26l51ZppzyQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RN6/6lyvrMEkmwBiDoAIhDBnvNkkW8Qj4EE+ZBsIpSzwq69CjmTZTSauebQMNHCN7
	 iaX1bMUDzoeXEztuv4gTsHQ9zUsgV77X+C2CrZ+BTsTLd991v1kkYZ1/9k/N7QF3uU
	 OrBk0rPGvj1iY28lUgcG+VZFQ0VPeQDFq5ss3bLbMvBVUOhVsIy6j+CWPNiJWJ9tvs
	 EQR9cI6Ny1EqJAEHew9ZnJcLcwJW1pqdecFjqrc291wzvVqdiyGkOLFX+Wr3u5Iod1
	 CXc5RdIt7ovZSjChCn/kP08Vnru93S+i+AmOOKNxvUP/2gkj2p/XL5j6tw5iaNWi36
	 EqA2jsijUPqvg==
Date: Tue, 21 May 2024 20:13:01 -0700
Subject: [PATCH 093/111] xfs: add a xfs_btree_ptrs_equal helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533095.2478931.1588956656813952942.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
 

