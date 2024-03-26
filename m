Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1B9128816
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423580; cv=none; b=YU1wl7wcEHtlnXBQjcUxoFtZvMt9FkmyNbF40udDweKvUhAQ+lnlTVM/1IsB/S1oYQFrejPuENmetGc+U7jO1xlUrvibbIRK88rCRH0MCTzs3lAeFaw+3DR2mfgXe0+IfWKsgez6zDAiVU693MLFuD+S701jvfHxzNGuiTV5C1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423580; c=relaxed/simple;
	bh=BCvAWrvfY6mT7IYU9/aKbA8Y7czVxpTDs3pJyIkbpwE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdu5jaUOfdDq/fmmzEJRLvtdiIeAX2FocklkpLc9gRK/yot/DC+U54cnX1ZH9+nPRLo5S4Lc4DecAwWbTQInmtgbiRXWjVD/n5ilLSIIiBe1Np6wHZJwue6Ti9hDQgEJYvMcKy7lP4MQ1ive+9mvzeXZDcThMMhifSf/UCbo6eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRItzEsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRItzEsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6279C433C7;
	Tue, 26 Mar 2024 03:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423579;
	bh=BCvAWrvfY6mT7IYU9/aKbA8Y7czVxpTDs3pJyIkbpwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BRItzEsDTOdBRhuMn3e8Pl58txd9e/TKUYYGjbneQQGhaZ6F64JMS4eFjVug8e8cl
	 k3iR9vHAZgNeYD4g2JUa3soTnFTQZNeyFRJ9xGOLV0OP4GNFluI/coBQ3sVvuKSieQ
	 NgznIE+1BSEPo3kcrA2ymK3zImEm3zr1PXwBg4icDwRQirRTklABbIMIi7G1RROoI3
	 MiChFTHtZbkQX3Vp4bEJq67QV8s7WuUZf2aXI1mYdur7iNaKsrr53bbjBwcxQFJJuF
	 GV20V6kZvaSuvPeLkzVbWp5FXfvME5E1cF5ug9p/6Mdi3aJxjPh5qwe/jeP0eHxqC5
	 +T1OFuR0m4NOQ==
Date: Mon, 25 Mar 2024 20:26:19 -0700
Subject: [PATCH 3/8] xfs_repair: support more than 2^32 rmapbt records per AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171142130398.2214793.5088042745927641463.stgit@frogsfrogsfrogs>
In-Reply-To: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
References: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
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
index a2291c7b3b01..c908429c9bf7 100644
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
index 1dad2f5890a4..b074e2e87860 100644
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

