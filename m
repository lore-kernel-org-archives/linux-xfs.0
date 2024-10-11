Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EDB7E1
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607233; cv=none; b=mpE/02tzq4tUtyw2UCD0Q6oY6IO4vUAcapfXri3LsWVDQYzwTejhAR36U2/KTTlB6EccBYp+M5X49RSHS3rHENbNo12k13skg2yCqq2h7t8czcbB7KFbm5lNPzgdwBvgnVj5tjmxvEmxaABMKCSVrIunXshcvbY/f/LALI3fNkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607233; c=relaxed/simple;
	bh=Njb4tR1HzrHFrhQB+MpmWm7Lm9rp5dY5/bP3sLIXoqs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i3prum9mvuu6S2mpIVpN1etpI+6hJ/jv97u2rrzdxmTfjNDyfnd9nnbATiESg6L2ciD56b9+rzylLf1dh+I9McspiL+itucm7Wlht6+sfX2ScrbuNYyyzIG9sTDZRVu3m5djgOGz+7qLZAQTUirTtKGgMXA8Hk2kc2Ghqvvw2yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7FZR3kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7FZR3kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D67C4CEC5;
	Fri, 11 Oct 2024 00:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607233;
	bh=Njb4tR1HzrHFrhQB+MpmWm7Lm9rp5dY5/bP3sLIXoqs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V7FZR3kb9nc6AMqKa81QaZL88xLTerKJcv6bsDMovV5HEXL18OL2FQo7MzBt/DDdL
	 vl9GdsBeu6CixuUUivpxWpmj00uJVBr74rrCTiUhyeSKx24DLkgnpoL3qDlNMO1inx
	 9eIGZhik+X5EHqma89RXC/lv9I3qhlMhZmZj+QjJ0O6RG3qkGhD1IXRex/DpqxTRaT
	 KTPWfo79DAUb99obNjCH/u+hi6MDhR/JtJGYfMRktlT3SBOJGTg7fEyEnQCOG8nL6l
	 Lx6J2MUznk/bAaU4dXyHoWf6LB4LJU//DxnPqqTFxX4J5zvKvpaGlr/GS1nkqxgAWk
	 0ZvwgumePbQgg==
Date: Thu, 10 Oct 2024 17:40:32 -0700
Subject: [PATCH 11/25] xfs: pass a pag to xfs_extent_busy_{search,reuse}
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640600.4175438.10362083773245467427.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
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

Replace the [mp,agno] tuple with the perag structure, which will become
more useful later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c       |    4 ++--
 fs/xfs/libxfs/xfs_alloc_btree.c |    2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c  |    2 +-
 fs/xfs/xfs_discard.c            |    2 +-
 fs/xfs/xfs_extent_busy.c        |   12 ++++--------
 fs/xfs/xfs_extent_busy.h        |    8 ++++----
 6 files changed, 13 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9071e1cb97f72a..3627d730d01e2d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1252,7 +1252,7 @@ xfs_alloc_ag_vextent_small(
 	if (fbno == NULLAGBLOCK)
 		goto out;
 
-	xfs_extent_busy_reuse(args->mp, args->pag, fbno, 1,
+	xfs_extent_busy_reuse(args->pag, fbno, 1,
 			      (args->datatype & XFS_ALLOC_NOBUSY));
 
 	if (args->datatype & XFS_ALLOC_USERDATA) {
@@ -3619,7 +3619,7 @@ xfs_alloc_vextent_finish(
 		if (error)
 			goto out_drop_perag;
 
-		ASSERT(!xfs_extent_busy_search(mp, args->pag, args->agbno,
+		ASSERT(!xfs_extent_busy_search(args->pag, args->agbno,
 				args->len));
 	}
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index aada676eee519c..5175d0b4d32e48 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -86,7 +86,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.pag, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_ag.pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index ac2f1f499b76f6..b49006c1ca7eee 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -102,7 +102,7 @@ xfs_rmapbt_alloc_block(
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(cur->bc_mp, pag, bno, 1, false);
+	xfs_extent_busy_reuse(pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d8c4a5dcca7aea..1a91e97d25ffba 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -272,7 +272,7 @@ xfs_trim_gather_extents(
 		 * If any blocks in the range are still busy, skip the
 		 * discard and try again the next time.
 		 */
-		if (xfs_extent_busy_search(mp, pag, fbno, flen)) {
+		if (xfs_extent_busy_search(pag, fbno, flen)) {
 			trace_xfs_discard_busy(mp, pag->pag_agno, fbno, flen);
 			goto next_extent;
 		}
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index a73e7c73b664c6..22c16fa56bcc44 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -101,7 +101,6 @@ xfs_extent_busy_insert_discard(
  */
 int
 xfs_extent_busy_search(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len)
@@ -148,7 +147,6 @@ xfs_extent_busy_search(
  */
 STATIC bool
 xfs_extent_busy_update_extent(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	struct xfs_extent_busy	*busyp,
 	xfs_agblock_t		fbno,
@@ -280,24 +278,22 @@ xfs_extent_busy_update_extent(
 		ASSERT(0);
 	}
 
-	trace_xfs_extent_busy_reuse(mp, pag->pag_agno, fbno, flen);
+	trace_xfs_extent_busy_reuse(pag->pag_mount, pag->pag_agno, fbno, flen);
 	return true;
 
 out_force_log:
 	spin_unlock(&pag->pagb_lock);
-	xfs_log_force(mp, XFS_LOG_SYNC);
-	trace_xfs_extent_busy_force(mp, pag->pag_agno, fbno, flen);
+	xfs_log_force(pag->pag_mount, XFS_LOG_SYNC);
+	trace_xfs_extent_busy_force(pag->pag_mount, pag->pag_agno, fbno, flen);
 	spin_lock(&pag->pagb_lock);
 	return false;
 }
 
-
 /*
  * For a given extent [fbno, flen], make sure we can reuse it safely.
  */
 void
 xfs_extent_busy_reuse(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	xfs_agblock_t		fbno,
 	xfs_extlen_t		flen,
@@ -323,7 +319,7 @@ xfs_extent_busy_reuse(
 			continue;
 		}
 
-		if (!xfs_extent_busy_update_extent(mp, pag, busyp, fbno, flen,
+		if (!xfs_extent_busy_update_extent(pag, busyp, fbno, flen,
 						  userdata))
 			goto restart;
 	}
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 470032de31391b..847c904a19386c 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -58,12 +58,12 @@ xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
 	bool do_discard);
 
 int
-xfs_extent_busy_search(struct xfs_mount *mp, struct xfs_perag *pag,
-	xfs_agblock_t bno, xfs_extlen_t len);
+xfs_extent_busy_search(struct xfs_perag *pag, xfs_agblock_t bno,
+		xfs_extlen_t len);
 
 void
-xfs_extent_busy_reuse(struct xfs_mount *mp, struct xfs_perag *pag,
-	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
+xfs_extent_busy_reuse(struct xfs_perag *pag, xfs_agblock_t fbno,
+		xfs_extlen_t flen, bool userdata);
 
 bool
 xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,

