Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6850A171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390316; cv=none; b=IAC7KGjX8Oh9e+9eYnYSyISVXAtk+MhT/upcwKq6lYvFp3eJjDKEDNPFDRuo1DNNZ22Lm556MxWp9z9ri4RlksKT7UBLESY7FpYz+naG4FQOdFCkHn0o5zyIwUcHTV8YXjQzyu+jpEetubGw3mmRWYi9TGzQ6B25Dlt4HWu/7/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390316; c=relaxed/simple;
	bh=QMVv42qiJ2NwlcB6qgzJsrbI9AEkZpsNxdh4riLSfKg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DlnFEcWi5Hkx/W/yDegl0IG5He6IvvC/kwGqM1Iytfl6yuLLcg+Xug/comZ1WFHwDvOV9ATBKAq86vHLE+ndduToKr/13em+eXPe9nyScB9ud1pYRq6LG1HrNIjPHsCUgPm131UVh/rz4RMXDYSpdRHY4NuMtA4ZDF5YgxX5QpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DduXJud0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DduXJud0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42688C072AA;
	Wed, 17 Apr 2024 21:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390316;
	bh=QMVv42qiJ2NwlcB6qgzJsrbI9AEkZpsNxdh4riLSfKg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DduXJud0cZz0kXvS6CKT5RiDpt9B6Or1cHvFtOQVJall5nEaSwEJtE3Qd6CtYTooU
	 dO4pMheIG6RMhbISAbyHFit4ebRPufSbBVY/1Ax9z7X1C4Yb5ZCnpexB/AbkQZ4IoV
	 kwl+0R51YDRma/L5XchomJ5UWwpm+Q0qBuDQSbx/C6V20DSdy/U46Ta1gj9OHQsNpY
	 VaES3XN7RXNv9XGWo5cZVghBTkSxxhQQlD+I9IX6hG0Z7WYm/YIMNKeXxoOfHdusam
	 jX3McKi0qyGX+rscnMDUg79CcM5ghKCboNTq/6XXnpKk8LL9yOpD45cWWrqcgw0qZE
	 bpG7pRXr5Ryqg==
Date: Wed, 17 Apr 2024 14:45:15 -0700
Subject: [PATCH 3/8] xfs_repair: support more than 2^32 rmapbt records per AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171338845826.1856674.2136380681034727010.stgit@frogsfrogsfrogs>
In-Reply-To: <171338845773.1856674.2763970395218819820.stgit@frogsfrogsfrogs>
References: <171338845773.1856674.2763970395218819820.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@djwong.org>

Now that the incore structures handle more than 2^32 records correctly,
fix the rmapbt generation code to handle that many records.  This fixes
the problem where an extremely large rmapbt cannot be rebuilt properly
because of integer truncation.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/rmap.c |    8 ++++----
 repair/rmap.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index a2291c7b3..c908429c9 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -283,7 +283,7 @@ rmap_fold_raw_recs(
 {
 	struct xfs_slab_cursor	*cur = NULL;
 	struct xfs_rmap_irec	*prev, *rec;
-	size_t			old_sz;
+	uint64_t		old_sz;
 	int			error = 0;
 
 	old_sz = slab_count(ag_rmaps[agno].ar_rmaps);
@@ -690,7 +690,7 @@ mark_inode_rl(
 	struct xfs_rmap_irec	*rmap;
 	struct ino_tree_node	*irec;
 	int			off;
-	size_t			idx;
+	uint64_t		idx;
 	xfs_agino_t		ino;
 
 	if (bag_count(rmaps) < 2)
@@ -873,9 +873,9 @@ compute_refcounts(
 /*
  * Return the number of rmap objects for an AG.
  */
-size_t
+uint64_t
 rmap_record_count(
-	struct xfs_mount		*mp,
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
 	return slab_count(ag_rmaps[agno].ar_rmaps);
diff --git a/repair/rmap.h b/repair/rmap.h
index 1dad2f589..b074e2e87 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -26,7 +26,7 @@ extern bool rmaps_are_mergeable(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *
 extern int rmap_add_fixed_ag_rec(struct xfs_mount *, xfs_agnumber_t);
 extern int rmap_store_ag_btree_rec(struct xfs_mount *, xfs_agnumber_t);
 
-extern size_t rmap_record_count(struct xfs_mount *, xfs_agnumber_t);
+uint64_t rmap_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern int rmap_init_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
 extern void rmap_avoid_check(void);
 void rmaps_verify_btree(struct xfs_mount *mp, xfs_agnumber_t agno);

