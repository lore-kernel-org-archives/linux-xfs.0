Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531B1171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390332; cv=none; b=toFC5CynDMB9C7xUwYaJpwMG8aXpsCVRShI1kSTLGTiWrLz1ofsyZ6NUP8geOKjmToir59CuAVRbwB1+7RiHQiX7k61+8JBIBP8JCRQ3XXA2t12nmenwXTPSCQ88YQln8xs8G4csqUHIz0mdAUCcxwu00jAGCk2hke+ZAaom/AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390332; c=relaxed/simple;
	bh=9dS1awVl7vN17Uy9uyjOppMj9xyLZaY11JeAWX8wmzw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fNxTmriyC0jf5zMntFa6AbhTdy7F5YO95iLKRYuatv81622p2tfRjWKiZ1oaKrs7+VF7UkdFUAGpZNPjJjyb8hSUv+EYIR43P8LCvwF7q8gBIn07UpKp2+IeF0HrMci6Y8FDmYk2kcnxHfN5vB7GmQpPAlXIanoooVMKqN6MxAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyI13K6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyI13K6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A97C072AA;
	Wed, 17 Apr 2024 21:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390332;
	bh=9dS1awVl7vN17Uy9uyjOppMj9xyLZaY11JeAWX8wmzw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fyI13K6hHfUDJcKFFwCKDgm+eMoGbPtTkF5LU3tCNMCAzkQ8m1HaavEiFuoFe1O4h
	 AXlHOoGMansGMkVtpBl3xc3I/naf1gUDzXkPezbZwAr9r7JFE3DzI3tl/1y1L4V/D2
	 JPAjcotdjm0IZUxASkxKZFkVd4K55kMrdSqsQkd78L6WdFbhSSWCMJ4YXr5mvlIC49
	 SulyludY3Ib4M/YFHIiTD4lgmdqlFbXO+BZSZzDakfnyBLRyZlgUBWce/j4+LqCxKM
	 Nd/aERBO84gQ1nK/UpjntVIl3jweojwDtVYBIkVEdS0g9scr7kg0AWBJXt903WWQkr
	 4BoYOUy3Ce7Fg==
Date: Wed, 17 Apr 2024 14:45:31 -0700
Subject: [PATCH 4/8] xfs_repair: support more than 2^32 owners per physical
 block
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171338845840.1856674.17637883617247425261.stgit@frogsfrogsfrogs>
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
index c908429c9..032bf4942 100644
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
index b074e2e87..1bc8c127d 100644
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

