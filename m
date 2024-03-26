Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2315B86AC1
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423799; cv=none; b=f1ded6sSSOmmPzYqbSx45nrRLMovjkKHsJYTBCXj/jtxo6FAHkEXpVy/cZgQ9/Zy/ztKSYStH6rAAuDE903mQpnXMHdKGhxvVc6H1HaJXWGeEsP38xKn2tj9Kx227N39txzTRtepyt6F1oCh6zbQTowS8XgxvTEZ3fEr34Ejap8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423799; c=relaxed/simple;
	bh=0rwSLvaqghX2TZFjfyfTSX5a6lnQ8hrYmGKQLGYqE88=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G9WcccgCw8nt9BBTnVb5rXv8PjdJ9cP/NDYswffOwMj4QBL2Zh4SxyMwmIK0KBNLZGVFj9zTdjzQiz36pVxRZo8whrz8Ua/3MNL+R1k8xzqtxv5g7VftWgAmR5KBr+tytHsvlSZb+gzTYAKpH88e647HU7H24Nlgcq8PCLoyPqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAlxEda9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAlxEda9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5228C433F1;
	Tue, 26 Mar 2024 03:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423799;
	bh=0rwSLvaqghX2TZFjfyfTSX5a6lnQ8hrYmGKQLGYqE88=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DAlxEda9WhCHlW4OHwi2mt+/VCaQDQpGnACfhc6gkDFH0D+RjEV1oNpppwZIcw9j7
	 QuLTnXe+8JT4h+zOZVvYDGHc9+KTXxD+oZsbyP2JfoNjwWJ7H7U3X6nrBMT7Essoul
	 wyyWRO1DUnzIJvhT5hfYk3fAFn55U5cvLj43+yzl4Z8Ih+m4DhZcUDp5NESjLd6Cqv
	 FTKjAfqZmzKhkjsrTXrG1lCWTXuVMMJKzoMn17mFnJwOBo+xOZRHUktM3j8avuE3Wg
	 xpRbVNCT4oZsQSSqKJn3IRpBuGAB1m4ojDtAcc8q0etTuwnFWytj/n1VaswQtI5inY
	 CG0d/RNnAXcOg==
Date: Mon, 25 Mar 2024 20:29:58 -0700
Subject: [PATCH 006/110] xfs: clean up remaining GFP_NOFS users
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171142131472.2215168.12128079829062523014.stgit@frogsfrogsfrogs>
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

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 204fae32d5f7b9ac673d3d4f636dcef8697db2f0

These few remaining GFP_NOFS callers do not need to use GFP_NOFS at
all. They are only called from a non-transactional context or cannot
be accessed from memory reclaim due to other constraints. Hence they
can just use GFP_KERNEL.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_btree_staging.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 0828cc7e38a7..45ef6aba8514 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -139,7 +139,7 @@ xfs_btree_stage_afakeroot(
 	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
@@ -220,7 +220,7 @@ xfs_btree_stage_ifakeroot(
 	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;

