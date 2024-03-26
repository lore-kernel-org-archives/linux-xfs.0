Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870061292FD
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424723; cv=none; b=R6yBcGsVXXjtR/DzfJh1mbDCOfj3himtj9VHnhyd9VcxcTEgo6eWJ4MzHCop7iDry382FzJ60edAKAW35VjQS10sLtoloyZ+gkWOqcmd0X3lqdblgV+qQnCwDdz7wFL9EVxsZy8LzpJj0DQ6rzCnByZLjyQWtu0K4cTuWI+2Vc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424723; c=relaxed/simple;
	bh=NyObIvG2EcmilzX6cxtL3Z1jQuEpF5VwUkqLAxK3Bvo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FKsFUDdnpUU8mJAEOmILKKumEA6hMfDq1nSv2gHQuCD9lJL8xcQK6znUovwAVCSBeXOtBDPnxR7bybqBtYQuI4PDuLIBsC9JT/isjNlIDSZfRBJ6ESeqJNyTJZeHGNM5NSUwuUVtPkXn3azCS1XknIxTqEwt91qjOmtVfhyGGv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZIk27F2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZIk27F2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E30EC433C7;
	Tue, 26 Mar 2024 03:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424723;
	bh=NyObIvG2EcmilzX6cxtL3Z1jQuEpF5VwUkqLAxK3Bvo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QZIk27F2krgDU6lcdxbLaNNFN26k7atiPp3OBHfJ/iZrk2qpF8XhSHWieUP7aS+64
	 AzCjjKv6Hd552US0EEd4cWTU4t5hsIQLUY6Os3lhER5BAQ55r6Z07uuJcqSze/Bpkn
	 M7fYLLXTyYikdKxI5g7t5iZ9cVqNJgLkOD1bY7/nHaeanS+t6K2/o9RBgYP7e3iDtB
	 88IciLkeMvJRNt6HBbuB84OnA/VhBn873Qvkg2Nw0vcHez2OEeL70mDWp/sSeoUkDS
	 A4tCCpbCehzkB5bcHROfiXfwVlB9e2qY5jRbfNP/sibvkzbZsGgXXEchVdqHAKrA9b
	 jYZfUyOsdKn9g==
Date: Mon, 25 Mar 2024 20:45:22 -0700
Subject: [PATCH 065/110] xfs: split the agf_roots and agf_levels arrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132315.2215168.17914980607375222997.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: e45ea3645178c6db91aef4314945b05e4c6ee1fc

Using arrays of largely unrelated fields that use the btree number
as index is not very robust.  Split the arrays into three separate
fields instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/xfs_copy.c          |    4 ++--
 db/agf.c                 |   28 +++++--------------------
 db/check.c               |   14 ++++++------
 db/freesp.c              |    8 ++++---
 db/metadump.c            |   12 +++++------
 libxfs/xfs_ag.c          |   13 +++++-------
 libxfs/xfs_ag.h          |    8 ++++---
 libxfs/xfs_alloc.c       |   49 +++++++++++++++++--------------------------
 libxfs/xfs_alloc_btree.c |   52 +++++++++++++++++++++++++++++++---------------
 libxfs/xfs_format.h      |   21 +++++++++----------
 libxfs/xfs_rmap_btree.c  |   17 +++++++--------
 logprint/log_misc.c      |    8 ++++---
 logprint/log_print_all.c |    8 ++++---
 repair/phase5.c          |   24 +++++++++++----------
 repair/scan.c            |   16 +++++++-------
 15 files changed, 136 insertions(+), 146 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 98a578a017c6..07957e007812 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1016,10 +1016,10 @@ main(int argc, char **argv)
 
 		/* traverse btree until we get to the leftmost leaf node */
 
-		bno = be32_to_cpu(ag_hdr.xfs_agf->agf_roots[XFS_BTNUM_BNOi]);
+		bno = be32_to_cpu(ag_hdr.xfs_agf->agf_bno_root);
 		current_level = 0;
 		btree_levels = be32_to_cpu(ag_hdr.xfs_agf->
-						agf_levels[XFS_BTNUM_BNOi]);
+						agf_bno_level);
 
 		ag_end = XFS_AGB_TO_DADDR(mp, agno,
 				be32_to_cpu(ag_hdr.xfs_agf->agf_length) - 1)
diff --git a/db/agf.c b/db/agf.c
index 8a6e2824d95b..5d465f5d2a8d 100644
--- a/db/agf.c
+++ b/db/agf.c
@@ -35,31 +35,15 @@ const field_t	agf_flds[] = {
 	{ "versionnum", FLDT_UINT32D, OI(OFF(versionnum)), C1, 0, TYP_NONE },
 	{ "seqno", FLDT_AGNUMBER, OI(OFF(seqno)), C1, 0, TYP_NONE },
 	{ "length", FLDT_AGBLOCK, OI(OFF(length)), C1, 0, TYP_NONE },
-	{ "roots", FLDT_AGBLOCK, OI(OFF(roots)), CI(XFS_BTNUM_AGF),
-	  FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
-	{ "bnoroot", FLDT_AGBLOCK,
-	  OI(OFF(roots) + XFS_BTNUM_BNO * SZ(roots[XFS_BTNUM_BNO])), C1, 0,
-	  TYP_BNOBT },
-	{ "cntroot", FLDT_AGBLOCK,
-	  OI(OFF(roots) + XFS_BTNUM_CNT * SZ(roots[XFS_BTNUM_CNT])), C1, 0,
-	  TYP_CNTBT },
-	{ "rmaproot", FLDT_AGBLOCKNZ,
-	  OI(OFF(roots) + XFS_BTNUM_RMAP * SZ(roots[XFS_BTNUM_RMAP])), C1, 0,
-	  TYP_RMAPBT },
+	{ "bnoroot", FLDT_AGBLOCK, OI(OFF(bno_root)), C1, 0, TYP_BNOBT },
+	{ "cntroot", FLDT_AGBLOCK, OI(OFF(cnt_root)), C1, 0, TYP_CNTBT },
+	{ "rmaproot", FLDT_AGBLOCKNZ, OI(OFF(rmap_root)), C1, 0, TYP_RMAPBT },
 	{ "refcntroot", FLDT_AGBLOCKNZ,
 	  OI(OFF(refcount_root)), C1, 0,
 	  TYP_REFCBT },
-	{ "levels", FLDT_UINT32D, OI(OFF(levels)), CI(XFS_BTNUM_AGF),
-	  FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
-	{ "bnolevel", FLDT_UINT32D,
-	  OI(OFF(levels) + XFS_BTNUM_BNO * SZ(levels[XFS_BTNUM_BNO])), C1, 0,
-	  TYP_NONE },
-	{ "cntlevel", FLDT_UINT32D,
-	  OI(OFF(levels) + XFS_BTNUM_CNT * SZ(levels[XFS_BTNUM_CNT])), C1, 0,
-	  TYP_NONE },
-	{ "rmaplevel", FLDT_UINT32D,
-	  OI(OFF(levels) + XFS_BTNUM_RMAP * SZ(levels[XFS_BTNUM_RMAP])), C1, 0,
-	  TYP_NONE },
+	{ "bnolevel", FLDT_UINT32D, OI(OFF(bno_level)), C1, 0, TYP_NONE },
+	{ "cntlevel", FLDT_UINT32D, OI(OFF(cnt_level)), C1, 0, TYP_NONE },
+	{ "rmaplevel", FLDT_UINT32D, OI(OFF(rmap_level)), C1, 0, TYP_NONE },
 	{ "refcntlevel", FLDT_UINT32D,
 	  OI(OFF(refcount_level)), C1, 0,
 	  TYP_NONE },
diff --git a/db/check.c b/db/check.c
index 0a53ab7dfde6..bceaf318d75e 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4095,18 +4095,18 @@ scan_ag(
 	scan_freelist(agf);
 	fdblocks--;
 	scan_sbtree(agf,
-		be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
-		be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
+		be32_to_cpu(agf->agf_bno_root),
+		be32_to_cpu(agf->agf_bno_level),
 		1, scanfunc_bno, TYP_BNOBT);
 	fdblocks--;
 	scan_sbtree(agf,
-		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
-		be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
+		be32_to_cpu(agf->agf_cnt_root),
+		be32_to_cpu(agf->agf_cnt_level),
 		1, scanfunc_cnt, TYP_CNTBT);
-	if (agf->agf_roots[XFS_BTNUM_RMAP]) {
+	if (agf->agf_rmap_root) {
 		scan_sbtree(agf,
-			be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]),
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]),
+			be32_to_cpu(agf->agf_rmap_root),
+			be32_to_cpu(agf->agf_rmap_level),
 			1, scanfunc_rmap, TYP_RMAPBT);
 	}
 	if (agf->agf_refcount_root) {
diff --git a/db/freesp.c b/db/freesp.c
index 6f2346665847..883741e66fee 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -209,12 +209,12 @@ scan_ag(
 	agf = iocur_top->data;
 	scan_freelist(agf);
 	if (countflag)
-		scan_sbtree(agf, be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
-			TYP_CNTBT, be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
+		scan_sbtree(agf, be32_to_cpu(agf->agf_cnt_root),
+			TYP_CNTBT, be32_to_cpu(agf->agf_cnt_level),
 			scanfunc_cnt);
 	else
-		scan_sbtree(agf, be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
-			TYP_BNOBT, be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
+		scan_sbtree(agf, be32_to_cpu(agf->agf_bno_root),
+			TYP_BNOBT, be32_to_cpu(agf->agf_bno_level),
 			scanfunc_bno);
 	pop_cur();
 }
diff --git a/db/metadump.c b/db/metadump.c
index 536d089fbac6..a656ef574a7e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -460,8 +460,8 @@ copy_free_bno_btree(
 	xfs_agblock_t	root;
 	int		levels;
 
-	root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
-	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+	root = be32_to_cpu(agf->agf_bno_root);
+	levels = be32_to_cpu(agf->agf_bno_level);
 
 	/* validate root and levels before processing the tree */
 	if (root == 0 || root > mp->m_sb.sb_agblocks) {
@@ -488,8 +488,8 @@ copy_free_cnt_btree(
 	xfs_agblock_t	root;
 	int		levels;
 
-	root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
-	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	root = be32_to_cpu(agf->agf_cnt_root);
+	levels = be32_to_cpu(agf->agf_cnt_level);
 
 	/* validate root and levels before processing the tree */
 	if (root == 0 || root > mp->m_sb.sb_agblocks) {
@@ -560,8 +560,8 @@ copy_rmap_btree(
 	if (!xfs_has_rmapbt(mp))
 		return 1;
 
-	root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
-	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+	root = be32_to_cpu(agf->agf_rmap_root);
+	levels = be32_to_cpu(agf->agf_rmap_level);
 
 	/* validate root and levels before processing the tree */
 	if (root == 0 || root > mp->m_sb.sb_agblocks) {
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index cdca7f2470f2..389a8288e989 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -667,14 +667,13 @@ xfs_agfblock_init(
 	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
 	agf->agf_seqno = cpu_to_be32(id->agno);
 	agf->agf_length = cpu_to_be32(id->agsize);
-	agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(XFS_BNO_BLOCK(mp));
-	agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
-	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
-	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
+	agf->agf_bno_root = cpu_to_be32(XFS_BNO_BLOCK(mp));
+	agf->agf_cnt_root = cpu_to_be32(XFS_CNT_BLOCK(mp));
+	agf->agf_bno_level = cpu_to_be32(1);
+	agf->agf_cnt_level = cpu_to_be32(1);
 	if (xfs_has_rmapbt(mp)) {
-		agf->agf_roots[XFS_BTNUM_RMAPi] =
-					cpu_to_be32(XFS_RMAP_BLOCK(mp));
-		agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
+		agf->agf_rmap_root = cpu_to_be32(XFS_RMAP_BLOCK(mp));
+		agf->agf_rmap_level = cpu_to_be32(1);
 		agf->agf_rmap_blocks = cpu_to_be32(1);
 	}
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 77c0fa2bb510..19eddba09894 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -36,8 +36,9 @@ struct xfs_perag {
 	atomic_t	pag_active_ref;	/* active reference count */
 	wait_queue_head_t pag_active_wq;/* woken active_ref falls to zero */
 	unsigned long	pag_opstate;
-	uint8_t		pagf_levels[XFS_BTNUM_AGF];
-					/* # of levels in bno & cnt btree */
+	uint8_t		pagf_bno_level;	/* # of levels in bno btree */
+	uint8_t		pagf_cnt_level;	/* # of levels in cnt btree */
+	uint8_t		pagf_rmap_level;/* # of levels in rmap btree */
 	uint32_t	pagf_flcount;	/* count of blocks in freelist */
 	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
 	xfs_extlen_t	pagf_longest;	/* longest free space */
@@ -86,7 +87,8 @@ struct xfs_perag {
 	 * Alternate btree heights so that online repair won't trip the write
 	 * verifiers while rebuilding the AG btrees.
 	 */
-	uint8_t		pagf_repair_levels[XFS_BTNUM_AGF];
+	uint8_t		pagf_repair_bno_level;
+	uint8_t		pagf_repair_cnt_level;
 	uint8_t		pagf_repair_refcount_level;
 #endif
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index e5ae5394893a..1fdd7d44cb1a 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2331,8 +2331,9 @@ xfs_alloc_min_freelist(
 	struct xfs_perag	*pag)
 {
 	/* AG btrees have at least 1 level. */
-	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
-	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
+	const unsigned int	bno_level = pag ? pag->pagf_bno_level : 1;
+	const unsigned int	cnt_level = pag ? pag->pagf_cnt_level : 1;
+	const unsigned int	rmap_level = pag ? pag->pagf_rmap_level : 1;
 	unsigned int		min_free;
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
@@ -2359,16 +2360,12 @@ xfs_alloc_min_freelist(
 	 */
 
 	/* space needed by-bno freespace btree */
-	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
-				       mp->m_alloc_maxlevels) * 2 - 2;
+	min_free = min(bno_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed by-size freespace btree */
-	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
-				       mp->m_alloc_maxlevels) * 2 - 2;
+	min_free += min(cnt_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed reverse mapping used space btree */
 	if (xfs_has_rmapbt(mp))
-		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
-						mp->m_rmap_maxlevels) * 2 - 2;
-
+		min_free += min(rmap_level + 1, mp->m_rmap_maxlevels) * 2 - 2;
 	return min_free;
 }
 
@@ -3052,8 +3049,8 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_versionnum),
 		offsetof(xfs_agf_t, agf_seqno),
 		offsetof(xfs_agf_t, agf_length),
-		offsetof(xfs_agf_t, agf_roots[0]),
-		offsetof(xfs_agf_t, agf_levels[0]),
+		offsetof(xfs_agf_t, agf_bno_root),   /* also cnt/rmap root */
+		offsetof(xfs_agf_t, agf_bno_level),  /* also cnt/rmap levels */
 		offsetof(xfs_agf_t, agf_flfirst),
 		offsetof(xfs_agf_t, agf_fllast),
 		offsetof(xfs_agf_t, agf_flcount),
@@ -3232,12 +3229,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_freeblks) > agf_length)
 		return __this_address;
 
-	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) >
-						mp->m_alloc_maxlevels ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) >
-						mp->m_alloc_maxlevels)
+	if (be32_to_cpu(agf->agf_bno_level) < 1 ||
+	    be32_to_cpu(agf->agf_cnt_level) < 1 ||
+	    be32_to_cpu(agf->agf_bno_level) > mp->m_alloc_maxlevels ||
+	    be32_to_cpu(agf->agf_cnt_level) > mp->m_alloc_maxlevels)
 		return __this_address;
 
 	if (xfs_has_lazysbcount(mp) &&
@@ -3248,9 +3243,8 @@ xfs_agf_verify(
 		if (be32_to_cpu(agf->agf_rmap_blocks) > agf_length)
 			return __this_address;
 
-		if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
-		    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) >
-							mp->m_rmap_maxlevels)
+		if (be32_to_cpu(agf->agf_rmap_level) < 1 ||
+		    be32_to_cpu(agf->agf_rmap_level) > mp->m_rmap_maxlevels)
 			return __this_address;
 	}
 
@@ -3376,12 +3370,9 @@ xfs_alloc_read_agf(
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
 		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
-		pag->pagf_levels[XFS_BTNUM_BNOi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
-		pag->pagf_levels[XFS_BTNUM_CNTi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
-		pag->pagf_levels[XFS_BTNUM_RMAPi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+		pag->pagf_bno_level = be32_to_cpu(agf->agf_bno_level);
+		pag->pagf_cnt_level = be32_to_cpu(agf->agf_cnt_level);
+		pag->pagf_rmap_level = be32_to_cpu(agf->agf_rmap_level);
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		if (xfs_agfl_needs_reset(pag->pag_mount, agf))
 			set_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
@@ -3410,10 +3401,8 @@ xfs_alloc_read_agf(
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
 		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+		ASSERT(pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level));
+		ASSERT(pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level));
 	}
 #endif
 	if (agfbpp)
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index bd7878b68931..dd9584269fc0 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -36,13 +36,18 @@ xfs_allocbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	int			btnum = cur->bc_btnum;
 
 	ASSERT(ptr->s != 0);
 
-	agf->agf_roots[btnum] = ptr->s;
-	be32_add_cpu(&agf->agf_levels[btnum], inc);
-	cur->bc_ag.pag->pagf_levels[btnum] += inc;
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		agf->agf_bno_root = ptr->s;
+		be32_add_cpu(&agf->agf_bno_level, inc);
+		cur->bc_ag.pag->pagf_bno_level += inc;
+	} else {
+		agf->agf_cnt_root = ptr->s;
+		be32_add_cpu(&agf->agf_cnt_level, inc);
+		cur->bc_ag.pag->pagf_cnt_level += inc;
+	}
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -224,7 +229,10 @@ xfs_allocbt_init_ptr_from_cur(
 
 	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
-	ptr->s = agf->agf_roots[cur->bc_btnum];
+	if (cur->bc_btnum == XFS_BTNUM_BNO)
+		ptr->s = agf->agf_bno_root;
+	else
+		ptr->s = agf->agf_cnt_root;
 }
 
 STATIC int64_t
@@ -297,7 +305,6 @@ xfs_allocbt_verify(
 	struct xfs_perag	*pag = bp->b_pag;
 	xfs_failaddr_t		fa;
 	unsigned int		level;
-	xfs_btnum_t		btnum = XFS_BTNUM_BNOi;
 
 	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
@@ -318,21 +325,27 @@ xfs_allocbt_verify(
 	 * against.
 	 */
 	level = be16_to_cpu(block->bb_level);
-	if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC))
-		btnum = XFS_BTNUM_CNTi;
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		unsigned int	maxlevel = pag->pagf_levels[btnum];
+		unsigned int	maxlevel, repair_maxlevel = 0;
 
-#ifdef CONFIG_XFS_ONLINE_REPAIR
 		/*
 		 * Online repair could be rewriting the free space btrees, so
 		 * we'll validate against the larger of either tree while this
 		 * is going on.
 		 */
-		maxlevel = max_t(unsigned int, maxlevel,
-				 pag->pagf_repair_levels[btnum]);
+		if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC)) {
+			maxlevel = pag->pagf_cnt_level;
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+			repair_maxlevel = pag->pagf_repair_cnt_level;
 #endif
-		if (level >= maxlevel)
+		} else {
+			maxlevel = pag->pagf_bno_level;
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+			repair_maxlevel = pag->pagf_repair_bno_level;
+#endif
+		}
+
+		if (level >= max(maxlevel, repair_maxlevel))
 			return __this_address;
 	} else if (level >= mp->m_alloc_maxlevels)
 		return __this_address;
@@ -540,8 +553,8 @@ xfs_allocbt_init_cursor(
 		struct xfs_agf		*agf = agbp->b_addr;
 
 		cur->bc_nlevels = (btnum == XFS_BTNUM_BNO) ?
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) :
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+			be32_to_cpu(agf->agf_bno_level) :
+			be32_to_cpu(agf->agf_cnt_level);
 	}
 	return cur;
 }
@@ -561,8 +574,13 @@ xfs_allocbt_commit_staged_btree(
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
-	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
-	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		agf->agf_bno_root = cpu_to_be32(afake->af_root);
+		agf->agf_bno_level = cpu_to_be32(afake->af_levels);
+	} else {
+		agf->agf_cnt_root = cpu_to_be32(afake->af_root);
+		agf->agf_cnt_level = cpu_to_be32(afake->af_levels);
+	}
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 
 	xfs_btree_commit_afakeroot(cur, tp, agbp);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 382ab1e71c0b..2b2f9050fbfb 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -477,15 +477,9 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 #define	XFS_AGI_GOOD_VERSION(v)	((v) == XFS_AGI_VERSION)
 
 /*
- * Btree number 0 is bno, 1 is cnt, 2 is rmap. This value gives the size of the
- * arrays below.
- */
-#define	XFS_BTNUM_AGF	((int)XFS_BTNUM_RMAPi + 1)
-
-/*
- * The second word of agf_levels in the first a.g. overlaps the EFS
- * superblock's magic number.  Since the magic numbers valid for EFS
- * are > 64k, our value cannot be confused for an EFS superblock's.
+ * agf_cnt_level in the first AGF overlaps the EFS superblock's magic number.
+ * Since the magic numbers valid for EFS are > 64k, our value cannot be confused
+ * for an EFS superblock.
  */
 
 typedef struct xfs_agf {
@@ -499,8 +493,13 @@ typedef struct xfs_agf {
 	/*
 	 * Freespace and rmap information
 	 */
-	__be32		agf_roots[XFS_BTNUM_AGF];	/* root blocks */
-	__be32		agf_levels[XFS_BTNUM_AGF];	/* btree levels */
+	__be32		agf_bno_root;	/* bnobt root block */
+	__be32		agf_cnt_root;	/* cntbt root block */
+	__be32		agf_rmap_root;	/* rmapbt root block */
+
+	__be32		agf_bno_level;	/* bnobt btree levels */
+	__be32		agf_cnt_level;	/* cntbt btree levels */
+	__be32		agf_rmap_level;	/* rmapbt btree levels */
 
 	__be32		agf_flfirst;	/* first freelist block's index */
 	__be32		agf_fllast;	/* last freelist block's index */
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 5fad7f20b9d6..82052ce78554 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -63,13 +63,12 @@ xfs_rmapbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	int			btnum = cur->bc_btnum;
 
 	ASSERT(ptr->s != 0);
 
-	agf->agf_roots[btnum] = ptr->s;
-	be32_add_cpu(&agf->agf_levels[btnum], inc);
-	cur->bc_ag.pag->pagf_levels[btnum] += inc;
+	agf->agf_rmap_root = ptr->s;
+	be32_add_cpu(&agf->agf_rmap_level, inc);
+	cur->bc_ag.pag->pagf_rmap_level += inc;
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -220,7 +219,7 @@ xfs_rmapbt_init_ptr_from_cur(
 
 	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
-	ptr->s = agf->agf_roots[cur->bc_btnum];
+	ptr->s = agf->agf_rmap_root;
 }
 
 /*
@@ -340,7 +339,7 @@ xfs_rmapbt_verify(
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
+		if (level >= pag->pagf_rmap_level)
 			return __this_address;
 	} else if (level >= mp->m_rmap_maxlevels)
 		return __this_address;
@@ -521,7 +520,7 @@ xfs_rmapbt_init_cursor(
 	if (agbp) {
 		struct xfs_agf		*agf = agbp->b_addr;
 
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+		cur->bc_nlevels = be32_to_cpu(agf->agf_rmap_level);
 	}
 	return cur;
 }
@@ -541,8 +540,8 @@ xfs_rmapbt_commit_staged_btree(
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
-	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
-	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
+	agf->agf_rmap_root = cpu_to_be32(afake->af_root);
+	agf->agf_rmap_level = cpu_to_be32(afake->af_levels);
 	agf->agf_rmap_blocks = cpu_to_be32(afake->af_blocks);
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS |
 				    XFS_AGF_RMAP_BLOCKS);
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 836156e0d586..9d38113402f4 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -378,11 +378,11 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 				be32_to_cpu(agf->agf_seqno),
 				be32_to_cpu(agf->agf_length));
 			printf(_("root BNO: %d  CNT: %d\n"),
-				be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]),
-				be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
+				be32_to_cpu(agf->agf_bno_root),
+				be32_to_cpu(agf->agf_cnt_root));
 			printf(_("level BNO: %d  CNT: %d\n"),
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]),
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+				be32_to_cpu(agf->agf_bno_level),
+				be32_to_cpu(agf->agf_cnt_level));
 			printf(_("1st: %d  last: %d  cnt: %d  "
 			       "freeblks: %d  longest: %d\n"),
 				be32_to_cpu(agf->agf_flfirst),
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 8d3ede190e5f..f436e10917d8 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -152,11 +152,11 @@ xlog_recover_print_buffer(
 				be32_to_cpu(agf->agf_seqno),
 				be32_to_cpu(agf->agf_length));
 			printf(_("		root BNO:%d  CNT:%d\n"),
-				be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]),
-				be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
+				be32_to_cpu(agf->agf_bno_root),
+				be32_to_cpu(agf->agf_cnt_root));
 			printf(_("		level BNO:%d  CNT:%d\n"),
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]),
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+				be32_to_cpu(agf->agf_bno_level),
+				be32_to_cpu(agf->agf_cnt_level));
 			printf(_("		1st:%d  last:%d  cnt:%d  "
 				"freeblks:%d  longest:%d\n"),
 				be32_to_cpu(agf->agf_flfirst),
diff --git a/repair/phase5.c b/repair/phase5.c
index b0e208f95af5..6ae2ea575582 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -255,20 +255,20 @@ build_agf_agfl(
 		agf->agf_length = cpu_to_be32(mp->m_sb.sb_dblocks -
 			(xfs_rfsblock_t) mp->m_sb.sb_agblocks * agno);
 
-	agf->agf_roots[XFS_BTNUM_BNO] =
+	agf->agf_bno_root =
 			cpu_to_be32(btr_bno->newbt.afake.af_root);
-	agf->agf_levels[XFS_BTNUM_BNO] =
+	agf->agf_bno_level =
 			cpu_to_be32(btr_bno->newbt.afake.af_levels);
-	agf->agf_roots[XFS_BTNUM_CNT] =
+	agf->agf_cnt_root =
 			cpu_to_be32(btr_cnt->newbt.afake.af_root);
-	agf->agf_levels[XFS_BTNUM_CNT] =
+	agf->agf_cnt_level =
 			cpu_to_be32(btr_cnt->newbt.afake.af_levels);
 	agf->agf_freeblks = cpu_to_be32(btr_bno->freeblks);
 
 	if (xfs_has_rmapbt(mp)) {
-		agf->agf_roots[XFS_BTNUM_RMAP] =
+		agf->agf_rmap_root =
 				cpu_to_be32(btr_rmap->newbt.afake.af_root);
-		agf->agf_levels[XFS_BTNUM_RMAP] =
+		agf->agf_rmap_level =
 				cpu_to_be32(btr_rmap->newbt.afake.af_levels);
 		agf->agf_rmap_blocks =
 				cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
@@ -305,8 +305,8 @@ build_agf_agfl(
 
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "bno root = %u, bcnt root = %u, indices = %u %u\n",
-			be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
-			be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
+			be32_to_cpu(agf->agf_bno_root),
+			be32_to_cpu(agf->agf_cnt_root),
 			XFS_BTNUM_BNO,
 			XFS_BTNUM_CNT);
 #endif
@@ -367,12 +367,12 @@ build_agf_agfl(
 	agf->agf_longest = cpu_to_be32((ext_ptr != NULL) ?
 						ext_ptr->ex_blockcount : 0);
 
-	ASSERT(be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]) !=
-		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
+	ASSERT(be32_to_cpu(agf->agf_bno_root) !=
+		be32_to_cpu(agf->agf_cnt_root));
 	ASSERT(be32_to_cpu(agf->agf_refcount_root) !=
-		be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]));
+		be32_to_cpu(agf->agf_bno_root));
 	ASSERT(be32_to_cpu(agf->agf_refcount_root) !=
-		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
+		be32_to_cpu(agf->agf_cnt_root));
 
 	libxfs_buf_mark_dirty(agf_buf);
 	libxfs_buf_relse(agf_buf);
diff --git a/repair/scan.c b/repair/scan.c
index 0a77dd67913b..7e6d94cfa670 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2364,17 +2364,17 @@ validate_agf(
 	unsigned int		levels;
 	struct xfs_perag	*pag = libxfs_perag_get(mp, agno);
 
-	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+	levels = be32_to_cpu(agf->agf_bno_level);
 	if (levels == 0 || levels > mp->m_alloc_maxlevels) {
 		do_warn(_("bad levels %u for btbno root, agno %d\n"),
 			levels, agno);
 	}
 
-	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
+	bno = be32_to_cpu(agf->agf_bno_root);
 	if (libxfs_verify_agbno(pag, bno)) {
 		magic = xfs_has_crc(mp) ? XFS_ABTB_CRC_MAGIC
 							 : XFS_ABTB_MAGIC;
-		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
+		scan_sbtree(bno, be32_to_cpu(agf->agf_bno_level),
 			    agno, 0, scan_allocbt, 1, magic, agcnts,
 			    &xfs_bnobt_buf_ops);
 	} else {
@@ -2382,17 +2382,17 @@ validate_agf(
 			bno, agno);
 	}
 
-	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	levels = be32_to_cpu(agf->agf_cnt_level);
 	if (levels == 0 || levels > mp->m_alloc_maxlevels) {
 		do_warn(_("bad levels %u for btbcnt root, agno %d\n"),
 			levels, agno);
 	}
 
-	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
+	bno = be32_to_cpu(agf->agf_cnt_root);
 	if (libxfs_verify_agbno(pag, bno)) {
 		magic = xfs_has_crc(mp) ? XFS_ABTC_CRC_MAGIC
 							 : XFS_ABTC_MAGIC;
-		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
+		scan_sbtree(bno, be32_to_cpu(agf->agf_cnt_level),
 			    agno, 0, scan_allocbt, 1, magic, agcnts,
 			    &xfs_cntbt_buf_ops);
 	} else  {
@@ -2409,14 +2409,14 @@ validate_agf(
 		priv.last_rec.rm_owner = XFS_RMAP_OWN_UNKNOWN;
 		priv.nr_blocks = 0;
 
-		levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+		levels = be32_to_cpu(agf->agf_rmap_level);
 		if (levels == 0 || levels > mp->m_rmap_maxlevels) {
 			do_warn(_("bad levels %u for rmapbt root, agno %d\n"),
 				levels, agno);
 			rmap_avoid_check();
 		}
 
-		bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
+		bno = be32_to_cpu(agf->agf_rmap_root);
 		if (libxfs_verify_agbno(pag, bno)) {
 			scan_sbtree(bno, levels, agno, 0, scan_rmapbt, 1,
 					XFS_RMAP_CRC_MAGIC, &priv,

