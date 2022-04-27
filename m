Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE848C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349217AbiD0Ayw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356548AbiD0Ayv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:54:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7736D879
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CE5D61AF5
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B6FC385A0;
        Wed, 27 Apr 2022 00:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020697;
        bh=Y/GZNaukdSNr4XlXrQk0htwDcwDJt1o9yNnKwRClRBw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CDINsJfAuMGtYg4VRB4sMQ13JCsL+Vek7MXi8aL+Zx6BfOWGLVXUkMk7deTkl8gJm
         ez2+Y6u2N+SvhJUtJhdY/kZ9NYMPLUiiWjXRu07JgX7VX8gvZVNtbu7MZl2m1bga/N
         Vhh8wL/upxe+60mCfSOB85MTkcIHZ5A+9r4xaA9DnuqqnOJYNrM96NtqFZjIKdsvxv
         RrAshk9wkHZmeKxrTO39d8fplPX1ZqE/mWIGCEJ1eRfy1UVYTnsW1Wvm8cqsS1hd9A
         tP8JYoIM/6c/jvN6fc6fXPJzLaKlBySLpMZdJp3d/sPf2r/Fn/dTiF11SotXV+YxAo
         R+kIVprEL/vcg==
Subject: [PATCH 2/4] xfs: simplify xfs_rmap_lookup_le call sites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:51:36 -0700
Message-ID: <165102069690.3922526.4998507556334099851.stgit@magnolia>
In-Reply-To: <165102068549.3922526.15959517253241370597.stgit@magnolia>
References: <165102068549.3922526.15959517253241370597.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Most callers of xfs_rmap_lookup_le will retrieve the btree record
immediately if the lookup succeeds.  The overlapped version of this
function (xfs_rmap_lookup_le_range) will return the record if the lookup
succeeds, so make the regular version do it too.  Get rid of the useless
len argument, since it's not part of the lookup key.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rmap.c |   59 +++++++++++++++++-----------------------------
 fs/xfs/libxfs/xfs_rmap.h |    4 ++-
 fs/xfs/scrub/bmap.c      |   24 +++----------------
 3 files changed, 28 insertions(+), 59 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index cd322174dbff..3eea8056e7bc 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -34,18 +34,32 @@ int
 xfs_rmap_lookup_le(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
+	struct xfs_rmap_irec	*irec,
 	int			*stat)
 {
+	int			get_stat = 0;
+	int			error;
+
 	cur->bc_rec.r.rm_startblock = bno;
-	cur->bc_rec.r.rm_blockcount = len;
+	cur->bc_rec.r.rm_blockcount = 0;
 	cur->bc_rec.r.rm_owner = owner;
 	cur->bc_rec.r.rm_offset = offset;
 	cur->bc_rec.r.rm_flags = flags;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+	if (error || !(*stat) || !irec)
+		return error;
+
+	error = xfs_rmap_get_rec(cur, irec, &get_stat);
+	if (error)
+		return error;
+	if (!get_stat)
+		return -EFSCORRUPTED;
+
+	return 0;
 }
 
 /*
@@ -510,7 +524,7 @@ xfs_rmap_unmap(
 	 * for the AG headers at rm_startblock == 0 created by mkfs/growfs that
 	 * will not ever be removed from the tree.
 	 */
-	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags, &i);
+	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, &ltrec, &i);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -518,13 +532,6 @@ xfs_rmap_unmap(
 		goto out_error;
 	}
 
-	error = xfs_rmap_get_rec(cur, &ltrec, &i);
-	if (error)
-		goto out_error;
-	if (XFS_IS_CORRUPT(mp, i != 1)) {
-		error = -EFSCORRUPTED;
-		goto out_error;
-	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
 			ltrec.rm_blockcount, ltrec.rm_owner,
@@ -786,18 +793,11 @@ xfs_rmap_map(
 	 * record for our insertion point. This will also give us the record for
 	 * start block contiguity tests.
 	 */
-	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags,
+	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, &ltrec,
 			&have_lt);
 	if (error)
 		goto out_error;
 	if (have_lt) {
-		error = xfs_rmap_get_rec(cur, &ltrec, &have_lt);
-		if (error)
-			goto out_error;
-		if (XFS_IS_CORRUPT(mp, have_lt != 1)) {
-			error = -EFSCORRUPTED;
-			goto out_error;
-		}
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
@@ -1022,7 +1022,7 @@ xfs_rmap_convert(
 	 * record for our insertion point. This will also give us the record for
 	 * start block contiguity tests.
 	 */
-	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, oldext, &i);
+	error = xfs_rmap_lookup_le(cur, bno, owner, offset, oldext, &PREV, &i);
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -1030,13 +1030,6 @@ xfs_rmap_convert(
 		goto done;
 	}
 
-	error = xfs_rmap_get_rec(cur, &PREV, &i);
-	if (error)
-		goto done;
-	if (XFS_IS_CORRUPT(mp, i != 1)) {
-		error = -EFSCORRUPTED;
-		goto done;
-	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, PREV.rm_startblock,
 			PREV.rm_blockcount, PREV.rm_owner,
@@ -1140,7 +1133,7 @@ xfs_rmap_convert(
 			_RET_IP_);
 
 	/* reset the cursor back to PREV */
-	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, oldext, &i);
+	error = xfs_rmap_lookup_le(cur, bno, owner, offset, oldext, NULL, &i);
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -2677,7 +2670,7 @@ xfs_rmap_record_exists(
 	ASSERT(XFS_RMAP_NON_INODE_OWNER(owner) ||
 	       (flags & XFS_RMAP_BMBT_BLOCK));
 
-	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags,
+	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, &irec,
 			&has_record);
 	if (error)
 		return error;
@@ -2686,14 +2679,6 @@ xfs_rmap_record_exists(
 		return 0;
 	}
 
-	error = xfs_rmap_get_rec(cur, &irec, &has_record);
-	if (error)
-		return error;
-	if (!has_record) {
-		*has_rmap = false;
-		return 0;
-	}
-
 	*has_rmap = (irec.rm_owner == owner && irec.rm_startblock <= bno &&
 		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index b718ebeda372..11ec9406a0ea 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -122,8 +122,8 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  const struct xfs_owner_info *oinfo);
 
 int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, uint64_t owner, uint64_t offset,
-		unsigned int flags, int *stat);
+		uint64_t owner, uint64_t offset, unsigned int flags,
+		struct xfs_rmap_irec *irec, int *stat);
 int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, uint64_t owner, uint64_t offset,
 		unsigned int flags, int *stat);
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index c357593e0a02..285995ba3947 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -133,29 +133,13 @@ xchk_bmap_get_rmap(
 	if (info->is_shared) {
 		error = xfs_rmap_lookup_le_range(info->sc->sa.rmap_cur, agbno,
 				owner, offset, rflags, rmap, &has_rmap);
-		if (!xchk_should_check_xref(info->sc, &error,
-				&info->sc->sa.rmap_cur))
-			return false;
-		goto out;
+	} else {
+		error = xfs_rmap_lookup_le(info->sc->sa.rmap_cur, agbno,
+				owner, offset, rflags, rmap, &has_rmap);
 	}
-
-	/*
-	 * Otherwise, use the (faster) regular lookup.
-	 */
-	error = xfs_rmap_lookup_le(info->sc->sa.rmap_cur, agbno, 0, owner,
-			offset, rflags, &has_rmap);
-	if (!xchk_should_check_xref(info->sc, &error,
-			&info->sc->sa.rmap_cur))
-		return false;
-	if (!has_rmap)
-		goto out;
-
-	error = xfs_rmap_get_rec(info->sc->sa.rmap_cur, rmap, &has_rmap);
-	if (!xchk_should_check_xref(info->sc, &error,
-			&info->sc->sa.rmap_cur))
+	if (!xchk_should_check_xref(info->sc, &error, &info->sc->sa.rmap_cur))
 		return false;
 
-out:
 	if (!has_rmap)
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 			irec->br_startoff);

