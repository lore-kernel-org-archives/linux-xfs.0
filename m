Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3502DBE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ut8AXOfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02430C433C8;
	Sun, 31 Dec 2023 22:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060545;
	bh=7GPNEISEGTVuE61KnUi/BdHUkJnz7nKtoTkWU6dQ4GU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ut8AXOfiNq+XZKHaAVqO/qd802IX0cC6gF22z7oRtdLm5ZmnsnpbZ6cREy4vRkwzG
	 z3lxi6VjDc91TtcCSnlqesbPtPty73/T8Ir5PXRgVmxLf0M8KR/2cZ3oRby46AJIpu
	 B2T9a4t+81h3DLkDUkB2q+7IV/aWsLQmJbF2EtVZTkJLgdr8gmAthgYmOnrhWio1zE
	 allAKZE4h2V9FeI/6jr3hzrs1A6dm2XCEwcZUOS24VKI6bRnTnERFdJNiObNFCWCuw
	 jeJw2HSmZg6WaluY9Vv2Odz3ypn1s9oB3l5r0NjrtrvINYE63MKjOVXcjtxHIghDIb
	 ILYJl5rxGPU1Q==
Date: Sun, 31 Dec 2023 14:09:04 -0800
Subject: [PATCH 3/8] xfs_repair: support more than 2^32 rmapbt records per AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, linux-xfs@vger.kernel.org
Message-ID: <170404991178.1793698.3340045648839811450.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
References: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
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
index a2291c7b3b0..c908429c9bf 100644
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
index 1dad2f5890a..b074e2e8786 100644
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

