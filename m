Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E9B6FA7
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296143; cv=none; b=nfushjllK64MNkHCN3EfXotE9I0GqRJYJaREi9+Wj7nAUYJrnOGNKgMAqj/e/ULsulk76osDXbWJnZf2hjuE2mEDMK44o24GLqJUZh0ImRQdoLCWNlt1Ntd+RGk84V4N+dGWWJIgPcAnnM1d2xRvmysh28RiVcHheGAED7Iz+eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296143; c=relaxed/simple;
	bh=/axwi8OBLlDd8ynO4iSoDBHNGLVDxdzpK9cKMwvx6K8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eh/2FPjK6z3f3W7XMrE+wl1mKeAikjJiKbw/uMOOTcFqVHjVRFATuTXZ0WNqt9f+6d66kPwqmLdSjtOzjVQSzZCgelTRhPpK79H7NKxHYRfgYdL1ojHjRYtZpwvLSKskVdk/kK8rLWgRfG8LwZIycPL0bgjuzYId6t+LNbYi1mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDHCEvDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDHCEvDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A289C433C7;
	Wed, 13 Mar 2024 02:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296143;
	bh=/axwi8OBLlDd8ynO4iSoDBHNGLVDxdzpK9cKMwvx6K8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lDHCEvDUl5itJEaIlXtkbUKIYLYEEH3yHIjrVYXeksyxyNqCrMmjlqS6peTmgm/I4
	 v/T/c2Z6WwarydeuXhOwSYb+490kU62OX96+8+Z8AC3gBgvadWX26Rn4C7Hnj7vT5V
	 gFy/rBfRFWZph924Bpc/w9WOx8mLa8Xggu78WfgqdSAAT6eF6+19W8v4qiIt9WlsL2
	 z28YXW1zMaLpMcXXUhvrwi0CAoLK5Dm67dqwRo8myPMsvtO7Nb2IPFQwArpR86J9im
	 KZ0vqQc2GXX7eiAyhUqANsptFNEP0OoiQ32nzMwbOfCjy+kAmTRTPxlHRtGnSCl6vm
	 J85oscJEuHDEA==
Date: Tue, 12 Mar 2024 19:15:42 -0700
Subject: [PATCH 4/8] xfs_repair: support more than 2^32 owners per physical
 block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, linux-xfs@vger.kernel.org
Message-ID: <171029434786.2065824.14230923406122272720.stgit@frogsfrogsfrogs>
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
fix the refcountbt generation code to handle the case of that many rmap
records pointing to a piece of space in an AG.  This fixes the problem
where the refcountbt cannot be rebuilt properly because of integer
truncation if there are more than 4.3 billion owners of a piece of
space.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
---
 repair/rmap.c |   18 +++++++++---------
 repair/rmap.h |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index c908429c9bf7..564e1cbf294e 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -713,14 +713,13 @@ mark_inode_rl(
 /*
  * Emit a refcount object for refcntbt reconstruction during phase 5.
  */
-#define REFCOUNT_CLAMP(nr)	((nr) > MAXREFCOUNT ? MAXREFCOUNT : (nr))
 static void
 refcount_emit(
-	struct xfs_mount		*mp,
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,
-	size_t			nr_rmaps)
+	uint64_t		nr_rmaps)
 {
 	struct xfs_refcount_irec	rlrec;
 	int			error;
@@ -733,7 +732,9 @@ refcount_emit(
 		agno, agbno, len, nr_rmaps);
 	rlrec.rc_startblock = agbno;
 	rlrec.rc_blockcount = len;
-	rlrec.rc_refcount = REFCOUNT_CLAMP(nr_rmaps);
+	if (nr_rmaps > MAXREFCOUNT)
+		nr_rmaps = MAXREFCOUNT;
+	rlrec.rc_refcount = nr_rmaps;
 	rlrec.rc_domain = XFS_REFC_DOMAIN_SHARED;
 
 	error = slab_add(rlslab, &rlrec);
@@ -741,7 +742,6 @@ refcount_emit(
 		do_error(
 _("Insufficient memory while recreating refcount tree."));
 }
-#undef REFCOUNT_CLAMP
 
 /*
  * Transform a pile of physical block mapping observations into refcount data
@@ -758,11 +758,11 @@ compute_refcounts(
 	struct xfs_slab_cursor	*rmaps_cur;
 	struct xfs_rmap_irec	*array_cur;
 	struct xfs_rmap_irec	*rmap;
+	uint64_t		n, idx;
+	uint64_t		old_stack_nr;
 	xfs_agblock_t		sbno;	/* first bno of this rmap set */
 	xfs_agblock_t		cbno;	/* first bno of this refcount set */
 	xfs_agblock_t		nbno;	/* next bno where rmap set changes */
-	size_t			n, idx;
-	size_t			old_stack_nr;
 	int			error;
 
 	if (!xfs_has_reflink(mp))
@@ -1312,9 +1312,9 @@ _("Unable to fix reflink flag on inode %"PRIu64".\n"),
 /*
  * Return the number of refcount objects for an AG.
  */
-size_t
+uint64_t
 refcount_record_count(
-	struct xfs_mount		*mp,
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
 	return slab_count(ag_rmaps[agno].ar_refcount_items);
diff --git a/repair/rmap.h b/repair/rmap.h
index b074e2e87860..1bc8c127d0e5 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -37,7 +37,7 @@ extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 		struct xfs_rmap_irec *key);
 
 extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
-extern size_t refcount_record_count(struct xfs_mount *, xfs_agnumber_t);
+uint64_t refcount_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern int init_refcount_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
 extern void refcount_avoid_check(void);
 void check_refcounts(struct xfs_mount *mp, xfs_agnumber_t agno);

