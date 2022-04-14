Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F2BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346896AbiDNW4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbiDNW4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:56:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FFC65162
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAF84620B7
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37476C385A5;
        Thu, 14 Apr 2022 22:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976851;
        bh=jJ2grDlVKv3W/amCyxA1/bBWHzFLG+8m8Hv/IVcMqSo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hYfpO2fHXQcJCtrR8V7vxCuu1UGaNy0HPeLAj4zASUeptRaFQj3BiE8H18Rs4m/yj
         0HdjZUNuEhudO1SyOFysE0z1hT9rXiFO9IQnbw25M/YvuQDCPqmHhvHdHk2gv4kYZt
         O7BbFVkGDIEtfw7Qt7CYyciZ63Dc6/nrVQS2k+tbLRxGegnkh7SAVf4k063tcRf7YN
         r+ziTrRcWDdQYGAdxFDKv+/3ptMy0BrUNESbNa+DLb+C6pHoqKPsdIh6VXzcNI78XV
         9C5B7SbzVWIh2xHOH4nJfeKvSKsG2Oocg/FnJZhi8rMCtVJ9813eYg521C8JA0ZC4Z
         GTYikpDoFhcAQ==
Subject: [PATCH 2/4] xfs: simplify xfs_rmap_lookup_le call sites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:10 -0700
Message-ID: <164997685075.383709.9161047695879739444.stgit@magnolia>
In-Reply-To: <164997683918.383709.10179435130868945685.stgit@magnolia>
References: <164997683918.383709.10179435130868945685.stgit@magnolia>
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
index a4cbbc346f60..1bd5c1089bf8 100644
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

