Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D77C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbjEZAx7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbjEZAx6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:53:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D6F194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7847264BF6
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9143C433EF;
        Fri, 26 May 2023 00:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062435;
        bh=rCNQPMLx4VYbA9y+rHzs5TN0y+ThFYbdc3jpCPOGfR0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=HJgpY2xIEuJ8sZFjoRzD0g5+9KjT6crQZRs6sZCBMi2XU008EhplM8WEtF1XDnza9
         0/9h9Byw+lcTjsX3rLUdFBLCBGldlZphO8HZNU8zz1cDssxPdrfAIq8bhTvYdv62Qq
         itkDn5KOnp2llquwcqSTPmd350zMb+VH7hEUsaFveq41GmCAjKGM5QnVd9sYsd6j/M
         nVzArA6NZtjpW6gR3JwoYyGx4G1SamVbyWWmoxsmfAdlL2XFk0PoMCQdza5ztM16E9
         dhZfF4lVWeJkYS2idTrv7CpExDU3ELEIGChmzmVA2Z1RFNby0E+BfFrQHkyFV5iZua
         Yf9g502eDHDHQ==
Date:   Thu, 25 May 2023 17:53:55 -0700
Subject: [PATCH 1/5] xfs: reintroduce reaping of file metadata blocks to
 xrep_reap_extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506058725.3730621.415377851180040299.stgit@frogsfrogsfrogs>
In-Reply-To: <168506058705.3730621.6175016885493289346.stgit@frogsfrogsfrogs>
References: <168506058705.3730621.6175016885493289346.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reintroduce to xrep_reap_extents the ability to reap extents from any
AG.  We dropped this before because it was buggy, but in the next patch
we will gain the ability to reap old bmap btrees, which can have blocks
in any AG.  To do this, we require that sc->sa is uninitialized, so that
we can use it to hold all the per-AG context for a given extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bitmap.h |   28 +++++++++++
 fs/xfs/scrub/reap.c   |  120 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/reap.h   |    2 +
 fs/xfs/scrub/repair.h |    1 
 4 files changed, 147 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 4fe58bad6734..2518e642f4d3 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -105,4 +105,32 @@ int xagb_bitmap_set_btblocks(struct xagb_bitmap *bitmap,
 int xagb_bitmap_set_btcur_path(struct xagb_bitmap *bitmap,
 		struct xfs_btree_cur *cur);
 
+/* Bitmaps, but for type-checked for xfs_fsblock_t */
+
+struct xfsb_bitmap {
+	struct xbitmap	fsbitmap;
+};
+
+static inline void xfsb_bitmap_init(struct xfsb_bitmap *bitmap)
+{
+	xbitmap_init(&bitmap->fsbitmap);
+}
+
+static inline void xfsb_bitmap_destroy(struct xfsb_bitmap *bitmap)
+{
+	xbitmap_destroy(&bitmap->fsbitmap);
+}
+
+static inline int xfsb_bitmap_set(struct xfsb_bitmap *bitmap,
+		xfs_fsblock_t start, xfs_filblks_t len)
+{
+	return xbitmap_set(&bitmap->fsbitmap, start, len);
+}
+
+static inline int xfsb_bitmap_walk(struct xfsb_bitmap *bitmap,
+		xbitmap_walk_fn fn, void *priv)
+{
+	return xbitmap_walk(&bitmap->fsbitmap, fn, priv);
+}
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index f0419ffca42b..f904cad5a3c4 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -73,10 +73,10 @@
  * with only the same rmap owner but the block is not owned by something with
  * the same rmap owner, the block will be freed.
  *
- * The caller is responsible for locking the AG headers for the entire rebuild
- * operation so that nothing else can sneak in and change the AG state while
- * we're not looking.  We must also invalidate any buffers associated with
- * @bitmap.
+ * The caller is responsible for locking the AG headers/inode for the entire
+ * rebuild operation so that nothing else can sneak in and change the incore
+ * state while we're not looking.  We must also invalidate any buffers
+ * associated with @bitmap.
  */
 
 /* Information about reaping extents after a repair. */
@@ -500,3 +500,115 @@ xrep_reap_agblocks(
 
 	return 0;
 }
+
+/*
+ * Break a file metadata extent into sub-extents by fate (crosslinked, not
+ * crosslinked), and dispose of each sub-extent separately.  The extent must
+ * not cross an AG boundary.
+ */
+STATIC int
+xreap_fsmeta_extent(
+	uint64_t		fsbno,
+	uint64_t		len,
+	void			*priv)
+{
+	struct xreap_state	*rs = priv;
+	struct xfs_scrub	*sc = rs->sc;
+	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
+	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+	xfs_agblock_t		agbno_next = agbno + len;
+	int			error = 0;
+
+	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
+	ASSERT(sc->ip != NULL);
+	ASSERT(!sc->sa.pag);
+
+	/*
+	 * We're reaping blocks after repairing file metadata, which means that
+	 * we have to init the xchk_ag structure ourselves.
+	 */
+	sc->sa.pag = xfs_perag_get(sc->mp, agno);
+	if (!sc->sa.pag)
+		return -EFSCORRUPTED;
+
+	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &sc->sa.agf_bp);
+	if (error)
+		goto out_pag;
+
+	while (agbno < agbno_next) {
+		xfs_extlen_t	aglen;
+		bool		crosslinked;
+
+		error = xreap_agextent_select(rs, agbno, agbno_next,
+				&crosslinked, &aglen);
+		if (error)
+			goto out_agf;
+
+		error = xreap_agextent(rs, agbno, &aglen, crosslinked);
+		if (error)
+			goto out_agf;
+
+		if (xreap_want_defer_finish(rs)) {
+			/*
+			 * Holds the AGF buffer across the deferred chain
+			 * processing.
+			 */
+			error = xrep_defer_finish(sc);
+			if (error)
+				goto out_agf;
+			xreap_defer_finish_reset(rs);
+		} else if (xreap_want_roll(rs)) {
+			/*
+			 * Hold the AGF buffer across the transaction roll so
+			 * that we don't have to reattach it to the scrub
+			 * context.
+			 */
+			xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
+			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+			xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
+			if (error)
+				goto out_agf;
+			xreap_reset(rs);
+		}
+
+		agbno += aglen;
+	}
+
+out_agf:
+	xfs_trans_brelse(sc->tp, sc->sa.agf_bp);
+	sc->sa.agf_bp = NULL;
+out_pag:
+	xfs_perag_put(sc->sa.pag);
+	sc->sa.pag = NULL;
+	return error;
+}
+
+/*
+ * Dispose of every block of every fs metadata extent in the bitmap.
+ * Do not use this to dispose of the mappings in an ondisk inode fork.
+ */
+int
+xrep_reap_fsblocks(
+	struct xfs_scrub		*sc,
+	struct xfsb_bitmap		*bitmap,
+	const struct xfs_owner_info	*oinfo)
+{
+	struct xreap_state		rs = {
+		.sc			= sc,
+		.oinfo			= oinfo,
+		.resv			= XFS_AG_RESV_NONE,
+	};
+	int				error;
+
+	ASSERT(xfs_has_rmapbt(sc->mp));
+	ASSERT(sc->ip != NULL);
+
+	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
+	if (error)
+		return error;
+
+	if (xreap_dirty(&rs))
+		return xrep_defer_finish(sc);
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index fe24626af164..5e710be44b4b 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -8,5 +8,7 @@
 
 int xrep_reap_agblocks(struct xfs_scrub *sc, struct xagb_bitmap *bitmap,
 		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
+int xrep_reap_fsblocks(struct xfs_scrub *sc, struct xfsb_bitmap *bitmap,
+		const struct xfs_owner_info *oinfo);
 
 #endif /* __XFS_SCRUB_REAP_H__ */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 9f98b70e630c..d13beb1fc4c3 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -38,6 +38,7 @@ xrep_trans_commit(
 
 struct xbitmap;
 struct xagb_bitmap;
+struct xfsb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
 

