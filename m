Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378AABE4D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SO3pL+DP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA54C433C7;
	Sun, 31 Dec 2023 22:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060560;
	bh=4jBIkW2ocVGxJdGttysApEa/IcDJpwTmQEs+hYYt7cY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SO3pL+DPgGQwW0DSGzy2lTlJIyEatG8v1MIynlmxao9SaOjRPoX03mtD8o8PGsMyV
	 3WSEZENE2lRIzz3/Hd9ponFxYHay/Z/lOVl05TtPS3Kv62aufqDaOlIbRgsSGSeUFN
	 BAFPO1OIwhROiIhOOGZkAa0x0gy2ULbRioJl6mDFKBYlgCe2u0WVgVPe11zxrQgPPz
	 /wOtbmEknaINaFroOVLp0VAqEdjN3hZAj7kjgy9ZNwJeLJeebTaWXWGr9ReBfptAt1
	 RPU6OIbeMb3nQOmSqUilURn55KYYJLU6hDiz3SukkJkUtqMnKBhMqwUXsP4Hv9+qM/
	 xd+Jncabfw41Q==
Date: Sun, 31 Dec 2023 14:09:20 -0800
Subject: [PATCH 4/8] xfs_repair: support more than 2^32 owners per physical
 block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, linux-xfs@vger.kernel.org
Message-ID: <170404991192.1793698.2797509871951673384.stgit@frogsfrogsfrogs>
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
index c908429c9bf..564e1cbf294 100644
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
index b074e2e8786..1bc8c127d0e 100644
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

