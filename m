Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0694128816
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423595; cv=none; b=qXXYQYMGCXdISdziASS3t+WJqpLtqxhsKYLHhxHGAHEJHDUe3OzhaRT12elD2gHblcqNbRljXDtuBGKGe+KChmubwVZHGE4UM5edNrP236EcEfOvvS3TOpGUc/gUIlf41CUUukbRJyAd//EjmKjo8CmuNR4a6DLoy8clLDEXmCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423595; c=relaxed/simple;
	bh=Ig9lxtYvAXHBVcrWYwYYGKQAVYt5XqqYFa+68TS6gek=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ktCXXQgkwpb65xchd49V5c2+dUIPxdlVFDQq51ir5k0gnVxJqXO+D9QDz/Na9Pis7ZrnlPGUge2oemfJvetLg9LNNVTT71NAHp4X1pIAvTMBaXKLxaIei0WBkMPtyYHw2sxKEuHknW4mgo7ObTKYtK/B1TH2siZAy/iMwgYwBqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OA9TAZdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OA9TAZdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AFCC433F1;
	Tue, 26 Mar 2024 03:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423595;
	bh=Ig9lxtYvAXHBVcrWYwYYGKQAVYt5XqqYFa+68TS6gek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OA9TAZdK7XwizRpFZnWsGDf2eePbRBCIXz7CDF+/Spy93WeBirTptve9nDtkntRAX
	 j70T2fOdxrg7VGWulLHyCxcCukpaYoCNmSQNKJQMNrOIP+WUJEU+/wo4S0JeIAA+da
	 Cuj9hfmrVgpxQ2WmqOVoQAHwqoigL4xKJuzbP0WG4v1vHfx1X1DgRDHlOKE8HibAX/
	 PFpFtH/0IS+AtULrcAXGnN8A6Zw6eax23gm44iVB+XSGU+gvgfi9hjLHkXJ7Q4ZwLD
	 G3e4EKAWv6Ta77cHGg/KqGghHUkRB0fiO8ZHUPzOzyfRaRMHAlfE4PCHfNMtDzlDDT
	 KDUJpWbAKQIvg==
Date: Mon, 25 Mar 2024 20:26:34 -0700
Subject: [PATCH 4/8] xfs_repair: support more than 2^32 owners per physical
 block
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171142130413.2214793.16528270782720817470.stgit@frogsfrogsfrogs>
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
fix the refcountbt generation code to handle the case of that many rmap
records pointing to a piece of space in an AG.  This fixes the problem
where the refcountbt cannot be rebuilt properly because of integer
truncation if there are more than 4.3 billion owners of a piece of
space.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

