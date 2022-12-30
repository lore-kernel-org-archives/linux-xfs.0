Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FD7C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbiL3WnH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbiL3WnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:43:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1902E12D26
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:43:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C45D3B81C06
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF90C433D2;
        Fri, 30 Dec 2022 22:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440182;
        bh=OEFPZDX9CyCI98ZLu99+7oICwPUfqwkBF6YQfBYV0Ow=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i7dWD+6w2I7DDFSbDG0bcdaWvaCfaOyhwwuQKdpamuzyakAZ935miAlwRGUxVNz3n
         uty791RyYix+hLF+x0PR/jHrT7vKrOTdhiGbXL9AxVzc1IvzsYbjJTlNGqtXGuNdP9
         PPsQwkpnVdlQFE+dBXSbhNY+LGKlAL02I+g3bqM82j2VZjOsTnddRqp8bczaoH2Pks
         wbOEj5Zh0g9qB3weKTpO7e5u7odm4bn+rDPjzfC5+lUn6qo1bPqbJHQSGQgNI9gFQx
         Ujtfux/hT/5SHydTAOiN41+xoB0+Nk1rYpP4zwnJ2FH0cTwMPMih9Ha/tE3hB3shke
         UGf7NJo5xmDeg==
Subject: [PATCH 5/6] xfs: check the reference counts of gaps in the refcount
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:25 -0800
Message-ID: <167243828584.684405.7881225190931317148.stgit@magnolia>
In-Reply-To: <167243828503.684405.18151259725784634316.stgit@magnolia>
References: <167243828503.684405.18151259725784634316.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Gaps in the reference count btree are also significant -- for these
regions, there must not be any overlapping reverse mappings.  We don't
currently check this, so make the refcount scrubber more complete.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/refcount.c |   95 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 220b2850659e..10ef377873f6 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -332,6 +332,64 @@ xchk_refcountbt_xref(
 	xchk_refcountbt_xref_rmap(sc, irec);
 }
 
+struct xchk_refcbt_records {
+	/* The next AG block where we aren't expecting shared extents. */
+	xfs_agblock_t		next_unshared_agbno;
+
+	/* Number of CoW blocks we expect. */
+	xfs_agblock_t		cow_blocks;
+
+	/* Was the last record a shared or CoW staging extent? */
+	enum xfs_refc_domain	prev_domain;
+};
+
+STATIC int
+xchk_refcountbt_rmap_check_gap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	xfs_agblock_t			*next_bno = priv;
+
+	if (*next_bno != NULLAGBLOCK && rec->rm_startblock < *next_bno)
+		return -ECANCELED;
+
+	*next_bno = rec->rm_startblock + rec->rm_blockcount;
+	return 0;
+}
+
+/*
+ * Make sure that a gap in the reference count records does not correspond to
+ * overlapping records (i.e. shared extents) in the reverse mappings.
+ */
+static inline void
+xchk_refcountbt_xref_gaps(
+	struct xfs_scrub	*sc,
+	struct xchk_refcbt_records *rrc,
+	xfs_agblock_t		bno)
+{
+	struct xfs_rmap_irec	low;
+	struct xfs_rmap_irec	high;
+	xfs_agblock_t		next_bno = NULLAGBLOCK;
+	int			error;
+
+	if (bno <= rrc->next_unshared_agbno || !sc->sa.rmap_cur ||
+            xchk_skip_xref(sc->sm))
+		return;
+
+	memset(&low, 0, sizeof(low));
+	low.rm_startblock = rrc->next_unshared_agbno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = bno - 1;
+
+	error = xfs_rmap_query_range(sc->sa.rmap_cur, &low, &high,
+			xchk_refcountbt_rmap_check_gap, &next_bno);
+	if (error == -ECANCELED)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+	else
+		xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur);
+}
+
 /* Scrub a refcountbt record. */
 STATIC int
 xchk_refcountbt_rec(
@@ -339,7 +397,7 @@ xchk_refcountbt_rec(
 	const union xfs_btree_rec *rec)
 {
 	struct xfs_refcount_irec irec;
-	xfs_agblock_t		*cow_blocks = bs->private;
+	struct xchk_refcbt_records *rrc = bs->private;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
 	if (xfs_refcount_check_irec(bs->cur, &irec) != NULL) {
@@ -348,10 +406,27 @@ xchk_refcountbt_rec(
 	}
 
 	if (irec.rc_domain == XFS_REFC_DOMAIN_COW)
-		(*cow_blocks) += irec.rc_blockcount;
+		rrc->cow_blocks += irec.rc_blockcount;
+
+	/* Shared records always come before CoW records. */
+	if (irec.rc_domain == XFS_REFC_DOMAIN_SHARED &&
+	    rrc->prev_domain == XFS_REFC_DOMAIN_COW)
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+	rrc->prev_domain = irec.rc_domain;
 
 	xchk_refcountbt_xref(bs->sc, &irec);
 
+	/*
+	 * If this is a record for a shared extent, check that all blocks
+	 * between the previous record and this one have at most one reverse
+	 * mapping.
+	 */
+	if (irec.rc_domain == XFS_REFC_DOMAIN_SHARED) {
+		xchk_refcountbt_xref_gaps(bs->sc, rrc, irec.rc_startblock);
+		rrc->next_unshared_agbno = irec.rc_startblock +
+					   irec.rc_blockcount;
+	}
+
 	return 0;
 }
 
@@ -393,15 +468,25 @@ int
 xchk_refcountbt(
 	struct xfs_scrub	*sc)
 {
-	xfs_agblock_t		cow_blocks = 0;
+	struct xchk_refcbt_records rrc = {
+		.cow_blocks		= 0,
+		.next_unshared_agbno	= 0,
+		.prev_domain		= XFS_REFC_DOMAIN_SHARED,
+	};
 	int			error;
 
 	error = xchk_btree(sc, sc->sa.refc_cur, xchk_refcountbt_rec,
-			&XFS_RMAP_OINFO_REFC, &cow_blocks);
+			&XFS_RMAP_OINFO_REFC, &rrc);
 	if (error)
 		return error;
 
-	xchk_refcount_xref_rmap(sc, cow_blocks);
+	/*
+	 * Check that all blocks between the last refcount > 1 record and the
+	 * end of the AG have at most one reverse mapping.
+	 */
+	xchk_refcountbt_xref_gaps(sc, &rrc, sc->mp->m_sb.sb_agblocks);
+
+	xchk_refcount_xref_rmap(sc, rrc.cow_blocks);
 
 	return 0;
 }

