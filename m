Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6BA3876DE;
	Thu,  3 Sep 2026 05:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414714; cv=none; b=C/Mi2ruvY3i4vLvjZF3E2yLROTQ1rdPdBYBLQ8NA21NBBBuoKPDpCxrXYMr7QhIxJ+DI8FMYNNlOrsI54iCioMq3zHoUt7R1lqQ4LWWYS3ymOQNpQNuoowVpffRiJ4RbHXGwbeo+NLugAL+ipHD7ShauyElqy9aS6Oqhzz0FPaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414714; c=relaxed/simple;
	bh=h3QQzBnAvjiC5rWLQF8s6pjsXdyFakqbCn43twiCuck=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ol+qbuHYDzQcsbxDI/1YgsCXI3UyrUZC19IqDVz3qeerL5p0mz8J8x5QauRWdFNB+4Zd53mLlRBeRNbBzc387zjuPFjShEaxIJKeSaXd2IomoKSfWPLWAEIrvJQLjEwNWZqZYbuG74lpyrDRIuD1sRDR/EBrmmzzhpeQTmXLyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aE/5+HN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aE/5+HN2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9A63B1F000E9;
	Thu,  3 Sep 2026 05:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414712;
	bh=pgZd1JMC2eR7DdO4uNjKORr6QgW0t/ZBUUC0pYtBbfw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=aE/5+HN2FOUOkvjpdKQScLKfL/0YqFl1YYr1g9JaVIjyKLtf0vEQtTZ4/+pkAmAQt
	 ovsPPbHSMYHffjbyqHzPqP2hGMplAm87koAlUmBvL2Z1xc2PeuhYzVQlI2nlYim5Bs
	 QGKXTQW2WD6Re/OoyXcpmjjdFcD/y7N5AHYIgAuiJUGhvpVvONZuivKDrtpfFPgmvA
	 jpadTP2RPPDNKSVoeMQv8gj/yjuxaG+Mc88F77pspkGEweGu0qCqFxJUSJ4ZT9Vuvv
	 +8/PoQ60qdJPf+onEGO9jTZR3SMA6E4UTSJgeile9x4YxPQEpX5rXVlpUsk78fVd/0
	 5BGqPFj74ip+w==
Date: Wed, 02 Sep 2026 22:51:52 -0700
Subject: [PATCH 4/6] xfs: fix rtrefcount btree block counting in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178840969914.484660.12780329653421744867.stgit@frogsfrogsfrogs>
In-Reply-To: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM started on a long tangent about how xchk_refcount_xref_rmap
shouldn't nope out if sc->sa.rmap_cur isn't set, because nothing ever
sets that field.  It's right about the condition, but misses the bigger
problem, which is that to count the rtrefcount btree blocks, we have to
walk all rmap records in each AG in the data section.  That was papered
over by the incorrect !sc->sa.rmap_cur test.

In other words, we need a perag iteration loop here.  Restructure the
code to do that, and now it'll all work properly.  Fix the confusing
function name prefix.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: c27929670de144 ("xfs: scrub the realtime refcount btree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rtrefcount.c |   64 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 652d6b78b7a05b..3d916d71a135dc 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -20,6 +20,7 @@
 #include "xfs_metafile.h"
 #include "xfs_rtrefcount_btree.h"
 #include "xfs_rtalloc.h"
+#include "xfs_ag.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -504,30 +505,75 @@ xchk_rtrefcountbt_rec(
 	return 0;
 }
 
+/* Count the number of blocks used by the rtrefcount btree file in this AG. */
+static int
+xchk_rtrefcount_count_agblocks(
+	struct xfs_scrub	*sc,
+	xfs_agnumber_t		agno,
+	const struct xfs_owner_info *btree_oinfo,
+	xfs_filblks_t		*blocks)
+{
+	xfs_filblks_t		agblocks = 0;
+	int			error;
+
+	error = xchk_ag_init_existing(sc, agno, &sc->sa);
+	if (error)
+		goto out_free;
+
+	/*
+	 * If we don't have an rmap cursor, we can't complete the cross
+	 * referencing, so return EFSCORRUPTED to end the loop and trigger the
+	 * XFAIL flag.
+	 */
+	if (!sc->sa.rmap_cur) {
+		error = -EFSCORRUPTED;
+		goto out_free;
+	}
+
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, btree_oinfo,
+			&agblocks);
+	if (error)
+		goto out_free;
+
+	*blocks += agblocks;
+out_free:
+	xchk_ag_free(sc, &sc->sa);
+	return error;
+}
+
 /* Make sure we have as many refc blocks as the rmap says. */
 STATIC void
-xchk_refcount_xref_rmap(
+xchk_rtrefcount_xref_rmap(
 	struct xfs_scrub	*sc,
 	const struct xfs_owner_info *btree_oinfo,
 	xfs_extlen_t		cow_blocks)
 {
 	xfs_filblks_t		refcbt_blocks = 0;
-	xfs_filblks_t		blocks;
-	int			error;
+	xfs_filblks_t		blocks = 1; /* one for the iroot */
+	xfs_agnumber_t		agno;
+	int			error = 0;
 
-	if (!sc->sr.rmap_cur || !sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
+	if (!xfs_has_rmapbt(sc->mp) || xchk_skip_xref(sc->sm))
 		return;
 
 	/* Check that we saw as many refcbt blocks as the rmap knows about. */
 	error = xfs_btree_count_blocks(sc->sr.refc_cur, &refcbt_blocks);
 	if (!xchk_btree_process_error(sc, sc->sr.refc_cur, 0, &error))
 		return;
-	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, btree_oinfo,
-			&blocks);
-	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+
+	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
+		error = xchk_rtrefcount_count_agblocks(sc, agno, btree_oinfo,
+				&blocks);
+		if (error)
+			break;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return;
 	if (blocks != refcbt_blocks)
-		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	if (!sc->sr.rmap_cur || xchk_skip_xref(sc->sm))
+		return;
 
 	/* Check that we saw as many cow blocks as the rmap knows about. */
 	error = xchk_count_rmap_ownedby_ag(sc, sc->sr.rmap_cur,
@@ -568,7 +614,7 @@ xchk_rtrefcountbt(
 	 */
 	xchk_rtrefcountbt_xref_gaps(sc, &rrc,
 			xfs_rtx_to_rgbno(sc->sr.rtg, sc->mp->m_sb.sb_rgextents));
-	xchk_refcount_xref_rmap(sc, &btree_oinfo, rrc.cow_blocks);
+	xchk_rtrefcount_xref_rmap(sc, &btree_oinfo, rrc.cow_blocks);
 
 	return 0;
 }

