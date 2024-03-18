Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67973C2D
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 18:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710786763; cv=none; b=UWi9/WJtEuJVLQoa0Q/Uu7dh+FdbW6gBB4phr4t8GdxyAHoXSWubyGrXazL5N+lA/TJKnQO78InMvmUP3hdW0/F1VhN1pMsLPStOHjOtZlLm+ZNmsYuf26YKRca22jWG0loEpTzyePzWWz3p7SO5NFGcguj6nUckPPWS33SoMVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710786763; c=relaxed/simple;
	bh=z+1xnTP+ibIVv4m0c+OG9w7hyzqnsfIAFMvT4ORp33A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Io5TsW9qVwuWJd1THDY+mzu+2V8ZSn1tecPFTgBRir2BdN/f5GVI56MFDU7/2iUfAGErkI/l2rNlOVhGtBkJYddEF6tz9PMua4LK5kGEYgBHDXT9uzHyJlm8ap7Le9bDbRjxEytc+VkSPFIDLv2o7MkOirDTMvtOe5BEXyG+6cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V07EF9+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V07EF9+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733CFC433C7;
	Mon, 18 Mar 2024 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710786762;
	bh=z+1xnTP+ibIVv4m0c+OG9w7hyzqnsfIAFMvT4ORp33A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V07EF9+i1EHoBnbumFs+gNiLqvPyW7nOwiDVTUQouCKbpExmzpiJUCOrK/sI2Zi/T
	 f1l0cHw7rQHrW3jGvGbpZjaxqBgBWXHSG3ILmJWqP0AAemEWqVtGNHEsSo2iPENBs9
	 STGJRjy/jgzb10TsuDKK9ZBJpMsHCnyLvVROHyShz1FOH++DPj0Sgr6gzJfrJbFmCT
	 UqYl3IUZ+kHmpadr8SD0OeNG4rsblhHPse9UbXMb1Lakgib+EcE533yXRjKvZdmY+U
	 Z7N0LmnYhlImRD0NbNSrkV1gx5Y9i5pLHXG+d/zorC4R1fCPyFU+qLCTb//eKqYpfY
	 2KPS3bvSBaagA==
Date: Mon, 18 Mar 2024 11:32:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, linux-xfs@vger.kernel.org
Subject: [PATCH v24.5.1 4/8] xfs_repair: support more than 2^32 owners per
 physical block
Message-ID: <20240318183241.GK1927156@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434786.2065824.14230923406122272720.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434786.2065824.14230923406122272720.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@djwong.org>

Now that the incore structures handle more than 2^32 records correctly,
fix the refcountbt generation code to handle the case of that many rmap
records pointing to a piece of space in an AG.  This fixes the problem
where the refcountbt cannot be rebuilt properly because of integer
truncation if there are more than 4.3 billion owners of a piece of
space.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v24.5.1: use min() instead of open coding it
---
 repair/rmap.c |   17 ++++++++---------
 repair/rmap.h |    2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/repair/rmap.c b/repair/rmap.c
index c908429c9bf7..032bf494250a 100644
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
@@ -733,7 +732,8 @@ refcount_emit(
 		agno, agbno, len, nr_rmaps);
 	rlrec.rc_startblock = agbno;
 	rlrec.rc_blockcount = len;
-	rlrec.rc_refcount = REFCOUNT_CLAMP(nr_rmaps);
+	nr_rmaps = min(nr_rmaps, MAXREFCOUNT);
+	rlrec.rc_refcount = nr_rmaps;
 	rlrec.rc_domain = XFS_REFC_DOMAIN_SHARED;
 
 	error = slab_add(rlslab, &rlrec);
@@ -741,7 +741,6 @@ refcount_emit(
 		do_error(
 _("Insufficient memory while recreating refcount tree."));
 }
-#undef REFCOUNT_CLAMP
 
 /*
  * Transform a pile of physical block mapping observations into refcount data
@@ -758,11 +757,11 @@ compute_refcounts(
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
@@ -1312,9 +1311,9 @@ _("Unable to fix reflink flag on inode %"PRIu64".\n"),
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
