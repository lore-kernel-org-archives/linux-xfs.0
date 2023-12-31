Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1525BC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YkOPBon7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CBBC433C7;
	Sun, 31 Dec 2023 22:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062687;
	bh=rFuqfxtBVXT8fD+0crH+wh1tU8vBiD7H3Nxm9Z4CEK4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YkOPBon7eHSepclEuPvafsKc6QWEedJGPQNwo5yU0idjdqv9YcSmHDeGHjd6is9tS
	 2/fv+EROxuxFGz8dzxIsrUnXI6Yw7iDtV/tNyhBP2RkfJGPlH46UsqSAx6iSsczWLs
	 PsKW9vKlcuNSamY9X9oqnQFiR9VM7tTd/UDxqjvaWXqdccYIkKgWwR4EObKPpCs9cB
	 hHVztXheQSD/vFTRuZGEm5qfv0Q5krRmTHkKLMLw8ft2ZOkK+vWLX2E03kpTRcOHVc
	 WYly/lweh2PK1Zmo1H3ShgKIfaj/gtr/zqq8egEhUqrlzsxLJnMPBTs0MgzPtGlE2m
	 8+AcrUseAFYDw==
Date: Sun, 31 Dec 2023 14:44:46 -0800
Subject: [PATCH 3/4] xfs_scrub: recheck entire metadata objects after
 corruption repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000265.1798235.16664295272813316069.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
References: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we've finished making repairs to some domain of filesystem metadata
(file, AG, etc.) to correct an inconsistency, we should recheck all the
other metadata types within that domain to make sure that we neither
made things worse nor introduced more cross-referencing problems.  If we
did, requeue the item to make the repairs.  If the only changes we made
were optimizations, don't bother.

The XFS_SCRUB_TYPE_ values are getting close to the max for a u32, so
I chose u64 for sri_selected.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c        |   37 +++++++++++++++++++++++++++++++++++++
 scrub/scrub.c         |    5 +++--
 scrub/scrub.h         |   10 ++++++++++
 scrub/scrub_private.h |    2 ++
 4 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index eba936e1fd1..19f5c9052af 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -485,8 +485,10 @@ action_item_try_repair(
 {
 	struct scrub_item	*sri = &aitem->sri;
 	unsigned int		before, after;
+	unsigned int		scrub_type;
 	int			ret;
 
+	BUILD_BUG_ON(sizeof(sri->sri_selected) * NBBY < XFS_SCRUB_TYPE_NR);
 	before = repair_item_count_needsrepair(sri);
 
 	ret = repair_item(ctx, sri, 0);
@@ -507,6 +509,41 @@ action_item_try_repair(
 		return 0;
 	}
 
+	/*
+	 * Nothing in this fs object was marked inconsistent.  This means we
+	 * were merely optimizing metadata and there is no revalidation work to
+	 * be done.
+	 */
+	if (!sri->sri_inconsistent) {
+		*outcome = TR_REPAIRED;
+		return 0;
+	}
+
+	/*
+	 * We fixed inconsistent metadata, so reschedule the entire object for
+	 * immediate revalidation to see if anything else went wrong.
+	 */
+	foreach_scrub_type(scrub_type)
+		if (sri->sri_selected & (1ULL << scrub_type))
+			sri->sri_state[scrub_type] = SCRUB_ITEM_NEEDSCHECK;
+	sri->sri_inconsistent = false;
+	sri->sri_revalidate = true;
+
+	ret = scrub_item_check(ctx, sri);
+	if (ret)
+		return ret;
+
+	after = repair_item_count_needsrepair(sri);
+	if (after > 0) {
+		/*
+		 * Uhoh, we found something else broken.  Tell the caller that
+		 * this item needs to be queued for more repairs.
+		 */
+		sri->sri_revalidate = false;
+		*outcome = TR_REQUEUE;
+		return 0;
+	}
+
 	/* Repairs complete. */
 	*outcome = TR_REPAIRED;
 	return 0;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 69dfb1eb84d..2b6b6274e38 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -117,11 +117,12 @@ xfs_check_metadata(
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
 
 	error = -xfrog_scrub_metadata(xfdp, &meta);
-	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
-		meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
+		if (!sri->sri_revalidate &&
+		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+			meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 246c923f490..90578108a1c 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -59,11 +59,20 @@ struct scrub_item {
 	__u32			sri_gen;
 	__u32			sri_agno;
 
+	/* Bitmask of scrub types that were scheduled here. */
+	__u64			sri_selected;
+
 	/* Scrub item state flags, one for each XFS_SCRUB_TYPE. */
 	__u8			sri_state[XFS_SCRUB_TYPE_NR];
 
 	/* Track scrub and repair call retries for each scrub type. */
 	__u8			sri_tries[XFS_SCRUB_TYPE_NR];
+
+	/* Were there any corruption repairs needed? */
+	bool			sri_inconsistent:1;
+
+	/* Are we revalidating after repairs? */
+	bool			sri_revalidate:1;
 };
 
 #define foreach_scrub_type(loopvar) \
@@ -103,6 +112,7 @@ static inline void
 scrub_item_schedule(struct scrub_item *sri, unsigned int scrub_type)
 {
 	sri->sri_state[scrub_type] = SCRUB_ITEM_NEEDSCHECK;
+	sri->sri_selected |= (1ULL << scrub_type);
 }
 
 void scrub_item_schedule_group(struct scrub_item *sri,
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index 234b30ef2b8..bcfabda16be 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -71,6 +71,8 @@ scrub_item_save_state(
 	unsigned  int			scrub_flags)
 {
 	sri->sri_state[scrub_type] = scrub_flags & SCRUB_ITEM_REPAIR_ANY;
+	if (scrub_flags & SCRUB_ITEM_NEEDSREPAIR)
+		sri->sri_inconsistent = true;
 }
 
 static inline void

