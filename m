Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC3312838B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422703; cv=none; b=XQ6EdDrA+55NBGS5QC1ToqSIECX71xA3kREXqRw2p2/gqRPml7Lisjar5UDa/2ORKupMRkGAdVrnU3rIAWF3G4LVfU/z+gh/DlfUEsuG97o8WogDhtwepzkmsofg5gVC+UWCSIfmd46Bm7oocdkOkoqjEeB2QHmq/aKv7wT2KfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422703; c=relaxed/simple;
	bh=29AHGwZi8LGlKB2zBLZaIPcuGVRtATz+sYPkGikNO+Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R/Q06lc1AkhBNlnxbH6ShqqRBs62R0oDynQ0M2JiHln0/qwWibSBIMcDkXN8I5XH6kvHarK/LhZEWQysGPgzsHU6ilbl9J2QWH1ZjeL8yDBt7P1vnSmhCFAq0A4INOyL4pneRXq/t3PqPc4172w9pQQHZ2hBJC+ZBmF2nhZYMHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmIgfYnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmIgfYnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA568C433C7;
	Tue, 26 Mar 2024 03:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422702;
	bh=29AHGwZi8LGlKB2zBLZaIPcuGVRtATz+sYPkGikNO+Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NmIgfYnIcVsMaIWHwFWKATEtG04JRcbNzCAadcEQP6j1HtW251UCmucINuusfcFpF
	 s+ruDljp87gZYthHf0Ta/Jka73rwsSolwgVF8J5sE+ILVn4O9aC/l5S+gT9LkQgim6
	 Ew79TLQKYcMKgyp6vlLSd4Y9jW+mWj/iRR9WG9RC0kIyyt28DzomEUdy00Uuk/EYFU
	 aDiEBBka8Zx7JvjIAumBNWFDMgjZndOplHZJZ4t95liJatno7iY1rXoSUJeWkUWFGl
	 BsH2/DqdRMmBDQWO0Lc3HrDxaxeqZ4KB9+B3fsSe0aWXREcvEpoquTI2bDnzBLtqmQ
	 V8nDDwRQXN1SQ==
Date: Mon, 25 Mar 2024 20:11:42 -0700
Subject: [PATCH 34/67] xfs: repair free space btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127452.2212320.14285326014615515433.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4bdfd7d15747b170ce93a06fafccaf20544b6684

Rebuild the free space btrees from the gaps in the rmap btree.  Refer to
the case study in Documentation/filesystems/xfs-online-fsck-design.rst
for more details.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_ag.h          |    9 +++++++++
 libxfs/xfs_ag_resv.c     |    2 ++
 libxfs/xfs_alloc.c       |   10 ++++------
 libxfs/xfs_alloc.h       |    2 +-
 libxfs/xfs_alloc_btree.c |   13 ++++++++++++-
 libxfs/xfs_types.h       |    7 +++++++
 6 files changed, 35 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 2e0aef87d633..f16cb7a174d4 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -80,6 +80,15 @@ struct xfs_perag {
 	 */
 	uint16_t	pag_checked;
 	uint16_t	pag_sick;
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	/*
+	 * Alternate btree heights so that online repair won't trip the write
+	 * verifiers while rebuilding the AG btrees.
+	 */
+	uint8_t		pagf_repair_levels[XFS_BTNUM_AGF];
+#endif
+
 	spinlock_t	pag_state_lock;
 
 	spinlock_t	pagb_lock;	/* lock for pagb_tree */
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 29bbcb55d731..3a80b1613e18 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -410,6 +410,8 @@ xfs_ag_resv_free_extent(
 		fallthrough;
 	case XFS_AG_RESV_NONE:
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
+		fallthrough;
+	case XFS_AG_RESV_IGNORE:
 		return;
 	}
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index aaa1596157e9..352efbeca9f4 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -242,11 +242,9 @@ xfs_alloc_btrec_to_irec(
 /* Simple checks for free space records. */
 xfs_failaddr_t
 xfs_alloc_check_irec(
-	struct xfs_btree_cur		*cur,
-	const struct xfs_alloc_rec_incore *irec)
+	struct xfs_perag			*pag,
+	const struct xfs_alloc_rec_incore	*irec)
 {
-	struct xfs_perag		*pag = cur->bc_ag.pag;
-
 	if (irec->ar_blockcount == 0)
 		return __this_address;
 
@@ -295,7 +293,7 @@ xfs_alloc_get_rec(
 		return error;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	fa = xfs_alloc_check_irec(cur, &irec);
+	fa = xfs_alloc_check_irec(cur->bc_ag.pag, &irec);
 	if (fa)
 		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
@@ -3940,7 +3938,7 @@ xfs_alloc_query_range_helper(
 	xfs_failaddr_t				fa;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	fa = xfs_alloc_check_irec(cur, &irec);
+	fa = xfs_alloc_check_irec(cur->bc_ag.pag, &irec);
 	if (fa)
 		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 851cafbd6449..0b956f8b9d5a 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -185,7 +185,7 @@ xfs_alloc_get_rec(
 union xfs_btree_rec;
 void xfs_alloc_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_alloc_rec_incore *irec);
-xfs_failaddr_t xfs_alloc_check_irec(struct xfs_btree_cur *cur,
+xfs_failaddr_t xfs_alloc_check_irec(struct xfs_perag *pag,
 		const struct xfs_alloc_rec_incore *irec);
 
 int xfs_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 5ec14288d570..a472ec6d21a2 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -321,7 +321,18 @@ xfs_allocbt_verify(
 	if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC))
 		btnum = XFS_BTNUM_CNTi;
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		if (level >= pag->pagf_levels[btnum])
+		unsigned int	maxlevel = pag->pagf_levels[btnum];
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+		/*
+		 * Online repair could be rewriting the free space btrees, so
+		 * we'll validate against the larger of either tree while this
+		 * is going on.
+		 */
+		maxlevel = max_t(unsigned int, maxlevel,
+				 pag->pagf_repair_levels[btnum]);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_alloc_maxlevels)
 		return __this_address;
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 533200c4ccc2..035bf703d719 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -208,6 +208,13 @@ enum xfs_ag_resv_type {
 	XFS_AG_RESV_AGFL,
 	XFS_AG_RESV_METADATA,
 	XFS_AG_RESV_RMAPBT,
+
+	/*
+	 * Don't increase fdblocks when freeing extent.  This is a pony for
+	 * the bnobt repair functions to re-free the free space without
+	 * altering fdblocks.  If you think you need this you're wrong.
+	 */
+	XFS_AG_RESV_IGNORE,
 };
 
 /* Results of scanning a btree keyspace to check occupancy. */

