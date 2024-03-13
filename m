Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA68A6FA7
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296127; cv=none; b=Ide6kuqqZKd0/Pqtr5ttplCvPgLMRMFk38xB3YQ2f9CPxut2/dxwwAGgXqiW7Qk9aoLkxH4cMq6kqHcKJOYzvM+eB+ZzX6xt0qeLEZ38JgJ7x7lAILKu/BSRZo1dzeLe6kJQHqNcsVDJnXSDyHbR/iWQ1UenO2pQKGPQP6Q6sp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296127; c=relaxed/simple;
	bh=SBE4ioQgWWo/RyXxg/7CXpSstEJ+Dub2aw8GLWoGOIc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CuNy2dzkZmtIuTyzS8tRkEcL5B33ldNLDeucNjexvGq7hu2IDQz73hY7VNhGKljIUKwKc7iyVWUvvLnuE2yYOq0cX5epN+TeDoduUph6KeCmQjhJzqVUGUgiUOaJQsInb0jvLiEO9Nf0HY9CShiJ0UJyzjDDRhQMfC3WUN81bM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWnmNtIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWnmNtIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A36C433F1;
	Wed, 13 Mar 2024 02:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296127;
	bh=SBE4ioQgWWo/RyXxg/7CXpSstEJ+Dub2aw8GLWoGOIc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jWnmNtIlTWK8FImWLODeNLINdwKSIpAGV+4hN2LvGdK+CpdSRaC+IHIQk3rJ37a/h
	 Ua2PltdqkCRE5RlbI7G1GNdGggKn+Bgs69GL0Nuo0eGVqxOQUwA+4CLbKhr8wJPXic
	 yOXE5548AkxWsyuwhbywHJCPwYm85zLCY5oj3OF556VSmtLjffUCewNTulZ5NLqXwG
	 vFZ5VvZ5ap437KshbUSHkGMTO/+cfIMJOmkmYnSeApt9fykmbZDXCrHRZt8TuyH5k8
	 zan/hgZxLAUKFlo2qzFW1A0j7QIN4m8rbPFOQmWEZlZuD1EQPYYOH3WENMA0AeYxPg
	 K2o+npD4uytrw==
Date: Tue, 12 Mar 2024 19:15:27 -0700
Subject: [PATCH 3/8] xfs_repair: support more than 2^32 rmapbt records per AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, linux-xfs@vger.kernel.org
Message-ID: <171029434772.2065824.18696490895008470.stgit@frogsfrogsfrogs>
In-Reply-To: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
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

