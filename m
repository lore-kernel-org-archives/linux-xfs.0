Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6BDF9C3
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBoBt5AG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA80EC433C8;
	Sun, 31 Dec 2023 20:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054708;
	bh=190i35DJJ7ye++3bbyvc1qNGH6Zbal26cAc0iUlykHI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IBoBt5AGI5bt/2LFwjQcMO6o6QolBoJNhQ8TIaRZ187hh+j9bL29pwb5XrMm6ecZH
	 wcqEpyee6gqSL1dQgueK2zjfVNaUUpfbLw+ldouXHEjDN/insFQUqh59qN3f1mKlX0
	 RgAa096Uud+RpayDnFTi/UYa1mmojUJh4YVYnFmLb1MQXOo0XqzQApLNbrksQlxcUl
	 WCu1lg/dP6IXiJ8u+jm48goMAFZ/B421BLNLGTdu4OB/JluAu9Tf/obdvT8wFv1W2t
	 DJVvvp8vY3HYco+v99WPZfQtcgN4ks4eIrb8ybAn0A4Cv8OTrKNPvS4pUMYtAiUbI+
	 EYzABUA/c2cww==
Date: Sun, 31 Dec 2023 12:31:48 -0800
Subject: [PATCH 4/4] xfs: add the ability to reap entire inode forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833931.1752674.3586860708664682941.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833858.1752674.247392515267008994.stgit@frogsfrogsfrogs>
References: <170404833858.1752674.247392515267008994.stgit@frogsfrogsfrogs>
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

In preparation for supporting repair of indexed file-based metadata
(such as realtime bitmaps, directories, and extended attribute data),
add a function to reap the old blocks after a metadata repair finishes.
IOWs, this is an elaborate bunmapi call that deals with crosslinked
blocks by unmapping them without freeing them, and also scans for incore
buffers to invalidate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c  |  372 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.h  |    1 
 fs/xfs/scrub/trace.h |   63 ++++++++
 3 files changed, 436 insertions(+)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 7ae6253395e72..01ceaa4efa16b 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -675,3 +675,375 @@ xrep_reap_fsblocks(
 
 	return 0;
 }
+
+/*
+ * Metadata files are not supposed to share blocks with anything else.
+ * If blocks are shared, we remove the reverse mapping (thus reducing the
+ * crosslink factor); if blocks are not shared, we also need to free them.
+ *
+ * This first step determines the longest subset of the passed-in imap
+ * (starting at its beginning) that is either crosslinked or not crosslinked.
+ * The blockcount will be adjust down as needed.
+ */
+STATIC int
+xreap_bmapi_select(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*imap,
+	bool			*crosslinked)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_btree_cur	*cur;
+	xfs_filblks_t		len = 1;
+	xfs_agblock_t		bno;
+	xfs_agblock_t		agbno;
+	xfs_agblock_t		agbno_next;
+	int			error;
+
+	agbno = XFS_FSB_TO_AGBNO(sc->mp, imap->br_startblock);
+	agbno_next = agbno + imap->br_blockcount;
+
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.pag);
+
+	xfs_rmap_ino_owner(&oinfo, ip->i_ino, whichfork, imap->br_startoff);
+	error = xfs_rmap_has_other_keys(cur, agbno, 1, &oinfo, crosslinked);
+	if (error)
+		goto out_cur;
+
+	bno = agbno + 1;
+	while (bno < agbno_next) {
+		bool		also_crosslinked;
+
+		oinfo.oi_offset++;
+		error = xfs_rmap_has_other_keys(cur, bno, 1, &oinfo,
+				&also_crosslinked);
+		if (error)
+			goto out_cur;
+
+		if (also_crosslinked != *crosslinked)
+			break;
+
+		len++;
+		bno++;
+	}
+
+	imap->br_blockcount = len;
+	trace_xreap_bmapi_select(sc->sa.pag, agbno, len, *crosslinked);
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+/*
+ * Decide if this buffer can be joined to a transaction.  This is true for most
+ * buffers, but there are two cases that we want to catch: large remote xattr
+ * value buffers are not logged and can overflow the buffer log item dirty
+ * bitmap size; and oversized cached buffers if things have really gone
+ * haywire.
+ */
+static inline bool
+xreap_buf_loggable(
+	const struct xfs_buf	*bp)
+{
+	int			i;
+
+	for (i = 0; i < bp->b_map_count; i++) {
+		int		chunks;
+		int		map_size;
+
+		chunks = DIV_ROUND_UP(BBTOB(bp->b_maps[i].bm_len),
+				XFS_BLF_CHUNK);
+		map_size = DIV_ROUND_UP(chunks, NBWORD);
+		if (map_size > XFS_BLF_DATAMAP_SIZE)
+			return false;
+	}
+
+	return true;
+}
+
+/*
+ * Invalidate any buffers for this file mapping.  The @imap blockcount may be
+ * adjusted downward if we need to roll the transaction.
+ */
+STATIC int
+xreap_bmapi_binval(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*imap)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag = sc->sa.pag;
+	int			bmap_flags = xfs_bmapi_aflag(whichfork);
+	xfs_fileoff_t		off;
+	xfs_fileoff_t		max_off;
+	xfs_extlen_t		scan_blocks;
+	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
+	xfs_agblock_t		bno;
+	xfs_agblock_t		agbno;
+	xfs_agblock_t		agbno_next;
+	unsigned int		invalidated = 0;
+	int			error;
+
+	/*
+	 * Avoid invalidating AG headers and post-EOFS blocks because we never
+	 * own those.
+	 */
+	agbno = bno = XFS_FSB_TO_AGBNO(sc->mp, imap->br_startblock);
+	agbno_next = agbno + imap->br_blockcount;
+	if (!xfs_verify_agbno(pag, agbno) ||
+	    !xfs_verify_agbno(pag, agbno_next - 1))
+		return 0;
+
+	/*
+	 * Buffers for file blocks can span multiple contiguous mappings.  This
+	 * means that for each block in the mapping, there could exist an
+	 * xfs_buf indexed by that block with any length up to the maximum
+	 * buffer size (remote xattr values) or to the next hole in the fork.
+	 * To set up our binval scan, first we need to figure out the location
+	 * of the next hole.
+	 */
+	off = imap->br_startoff + imap->br_blockcount;
+	max_off = off + xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+	while (off < max_off) {
+		struct xfs_bmbt_irec	hmap;
+		int			nhmaps = 1;
+
+		error = xfs_bmapi_read(ip, off, max_off - off, &hmap,
+				&nhmaps, bmap_flags);
+		if (error)
+			return error;
+		if (nhmaps != 1 || hmap.br_startblock == DELAYSTARTBLOCK) {
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		if (!xfs_bmap_is_real_extent(&hmap))
+			break;
+
+		off = hmap.br_startoff + hmap.br_blockcount;
+	}
+	scan_blocks = off - imap->br_startoff;
+
+	trace_xreap_bmapi_binval_scan(sc, imap, scan_blocks);
+
+	/*
+	 * If there are incore buffers for these blocks, invalidate them.  If
+	 * we can't (try)lock the buffer we assume it's owned by someone else
+	 * and leave it alone.  The buffer cache cannot detect aliasing, so
+	 * employ nested loops to detect incore buffers of any plausible size.
+	 */
+	while (bno < agbno_next) {
+		struct xrep_bufscan	scan = {
+			.daddr		= XFS_AGB_TO_DADDR(mp, agno, bno),
+			.max_sectors	= xrep_bufscan_max_sectors(mp,
+								scan_blocks),
+			.daddr_step	= XFS_FSB_TO_BB(mp, 1),
+		};
+		struct xfs_buf		*bp;
+
+		while ((bp = xrep_bufscan_advance(mp, &scan)) != NULL) {
+			if (xreap_buf_loggable(bp)) {
+				xfs_trans_bjoin(sc->tp, bp);
+				xfs_trans_binval(sc->tp, bp);
+			} else {
+				xfs_buf_stale(bp);
+				xfs_buf_relse(bp);
+			}
+			invalidated++;
+
+			/*
+			 * Stop invalidating if we've hit the limit; we should
+			 * still have enough reservation left to free however
+			 * much of the mapping we've seen so far.
+			 */
+			if (invalidated > XREAP_MAX_BINVAL) {
+				imap->br_blockcount = agbno_next - bno;
+				goto out;
+			}
+		}
+
+		bno++;
+		scan_blocks--;
+	}
+
+out:
+	trace_xreap_bmapi_binval(sc->sa.pag, agbno, imap->br_blockcount);
+	return 0;
+}
+
+/*
+ * Dispose of as much of the beginning of this file fork mapping as possible.
+ * The number of blocks disposed of is returned in @imap->br_blockcount.
+ */
+STATIC int
+xrep_reap_bmapi_iter(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	int				whichfork,
+	struct xfs_bmbt_irec		*imap,
+	bool				crosslinked)
+{
+	int				error;
+
+	if (crosslinked) {
+		/*
+		 * If there are other rmappings, this block is cross linked and
+		 * must not be freed.  Remove the reverse mapping, leave the
+		 * buffer cache in its possibly confused state, and move on.
+		 * We don't want to risk discarding valid data buffers from
+		 * anybody else who thinks they own the block, even though that
+		 * runs the risk of stale buffer warnings in the future.
+		 */
+		trace_xreap_dispose_unmap_extent(sc->sa.pag,
+				XFS_FSB_TO_AGBNO(sc->mp, imap->br_startblock),
+				imap->br_blockcount);
+
+		/*
+		 * Schedule removal of the mapping from the fork.  We use
+		 * deferred log intents in this function to control the exact
+		 * sequence of metadata updates.
+		 */
+		xfs_bmap_unmap_extent(sc->tp, ip, whichfork, imap);
+		xfs_trans_mod_dquot_byino(sc->tp, ip, XFS_TRANS_DQ_BCOUNT,
+				-(int64_t)imap->br_blockcount);
+		xfs_rmap_unmap_extent(sc->tp, ip, whichfork, imap);
+		return 0;
+	}
+
+	/*
+	 * If the block is not crosslinked, we can invalidate all the incore
+	 * buffers for the extent, and then free the extent.  This is a bit of
+	 * a mess since we don't detect discontiguous buffers that are indexed
+	 * by a block starting before the first block of the extent but overlap
+	 * anyway.
+	 */
+	trace_xreap_dispose_free_extent(sc->sa.pag,
+			XFS_FSB_TO_AGBNO(sc->mp, imap->br_startblock),
+			imap->br_blockcount);
+
+	/*
+	 * Invalidate as many buffers as we can, starting at the beginning of
+	 * this mapping.  If this function sets blockcount to zero, the
+	 * transaction is full of logged buffer invalidations, so we need to
+	 * return early so that we can roll and retry.
+	 */
+	error = xreap_bmapi_binval(sc, ip, whichfork, imap);
+	if (error || imap->br_blockcount == 0)
+		return error;
+
+	/*
+	 * Schedule removal of the mapping from the fork.  We use deferred log
+	 * intents in this function to control the exact sequence of metadata
+	 * updates.
+	 */
+	xfs_bmap_unmap_extent(sc->tp, ip, whichfork, imap);
+	xfs_trans_mod_dquot_byino(sc->tp, ip, XFS_TRANS_DQ_BCOUNT,
+			-(int64_t)imap->br_blockcount);
+	return xfs_free_extent_later(sc->tp, imap->br_startblock,
+			imap->br_blockcount, NULL, XFS_AG_RESV_NONE, true);
+}
+
+/*
+ * Dispose of as much of this file extent as we can.  Upon successful return,
+ * the imap will reflect the mapping that was removed from the fork.
+ */
+STATIC int
+xreap_ifork_extent(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	int				whichfork,
+	struct xfs_bmbt_irec		*imap)
+{
+	xfs_agnumber_t			agno;
+	bool				crosslinked;
+	int				error;
+
+	ASSERT(sc->sa.pag == NULL);
+
+	trace_xreap_ifork_extent(sc, ip, whichfork, imap);
+
+	agno = XFS_FSB_TO_AGNO(sc->mp, imap->br_startblock);
+	sc->sa.pag = xfs_perag_get(sc->mp, agno);
+	if (!sc->sa.pag)
+		return -EFSCORRUPTED;
+
+	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &sc->sa.agf_bp);
+	if (error)
+		goto out_pag;
+
+	/*
+	 * Decide the fate of the blocks at the beginning of the mapping, then
+	 * update the mapping to use it with the unmap calls.
+	 */
+	error = xreap_bmapi_select(sc, ip, whichfork, imap, &crosslinked);
+	if (error)
+		goto out_agf;
+
+	error = xrep_reap_bmapi_iter(sc, ip, whichfork, imap, crosslinked);
+	if (error)
+		goto out_agf;
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
+ * Dispose of each block mapped to the given fork of the given file.  Callers
+ * must hold ILOCK_EXCL, and ip can only be sc->ip or sc->tempip.  The fork
+ * must not have any delalloc reservations.
+ */
+int
+xrep_reap_ifork(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	xfs_fileoff_t		off = 0;
+	int			bmap_flags = xfs_bmapi_aflag(whichfork);
+	int			error;
+
+	ASSERT(xfs_has_rmapbt(sc->mp));
+	ASSERT(ip == sc->ip || ip == sc->tempip);
+	ASSERT(whichfork == XFS_ATTR_FORK || !XFS_IS_REALTIME_INODE(ip));
+
+	while (off < XFS_MAX_FILEOFF) {
+		struct xfs_bmbt_irec	imap;
+		int			nimaps = 1;
+
+		/* Read the next extent, skip past holes and delalloc. */
+		error = xfs_bmapi_read(ip, off, XFS_MAX_FILEOFF - off, &imap,
+				&nimaps, bmap_flags);
+		if (error)
+			return error;
+		if (nimaps != 1 || imap.br_startblock == DELAYSTARTBLOCK) {
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		/*
+		 * If this is a real space mapping, reap as much of it as we
+		 * can in a single transaction.
+		 */
+		if (xfs_bmap_is_real_extent(&imap)) {
+			error = xreap_ifork_extent(sc, ip, whichfork, &imap);
+			if (error)
+				return error;
+
+			error = xfs_defer_finish(&sc->tp);
+			if (error)
+				return error;
+		}
+
+		off = imap.br_startoff + imap.br_blockcount;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index bb09e21fcb172..3f2f1775e29db 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -13,6 +13,7 @@ int xrep_reap_agblocks(struct xfs_scrub *sc, struct xagb_bitmap *bitmap,
 		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 int xrep_reap_fsblocks(struct xfs_scrub *sc, struct xfsb_bitmap *bitmap,
 		const struct xfs_owner_info *oinfo);
+int xrep_reap_ifork(struct xfs_scrub *sc, struct xfs_inode *ip, int whichfork);
 
 /* Buffer cache scan context. */
 struct xrep_bufscan {
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 00f906e50c341..691c91c9a5853 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1510,6 +1510,7 @@ DEFINE_EVENT(xrep_extent_class, name, \
 DEFINE_REPAIR_EXTENT_EVENT(xreap_dispose_unmap_extent);
 DEFINE_REPAIR_EXTENT_EVENT(xreap_dispose_free_extent);
 DEFINE_REPAIR_EXTENT_EVENT(xreap_agextent_binval);
+DEFINE_REPAIR_EXTENT_EVENT(xreap_bmapi_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
 DECLARE_EVENT_CLASS(xrep_reap_find_class,
@@ -1543,6 +1544,7 @@ DEFINE_EVENT(xrep_reap_find_class, name, \
 		 bool crosslinked), \
 	TP_ARGS(pag, agbno, len, crosslinked))
 DEFINE_REPAIR_REAP_FIND_EVENT(xreap_agextent_select);
+DEFINE_REPAIR_REAP_FIND_EVENT(xreap_bmapi_select);
 
 DECLARE_EVENT_CLASS(xrep_rmap_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -2394,6 +2396,67 @@ TRACE_EVENT(xrep_tempfile_create,
 		  __entry->temp_inum)
 );
 
+TRACE_EVENT(xreap_ifork_extent,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *ip, int whichfork,
+		 const struct xfs_bmbt_irec *irec),
+	TP_ARGS(sc, ip, whichfork, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, fileoff)
+		__field(xfs_filblks_t, len)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(int, state)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->whichfork = whichfork;
+		__entry->fileoff = irec->br_startoff;
+		__entry->len = irec->br_blockcount;
+		__entry->agno = XFS_FSB_TO_AGNO(sc->mp, irec->br_startblock);
+		__entry->agbno = XFS_FSB_TO_AGBNO(sc->mp, irec->br_startblock);
+		__entry->state = irec->br_state;
+	),
+	TP_printk("dev %d:%d ip 0x%llx whichfork %s agno 0x%x agbno 0x%x fileoff 0x%llx fsbcount 0x%llx state 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->fileoff,
+		  __entry->len,
+		  __entry->state)
+);
+
+TRACE_EVENT(xreap_bmapi_binval_scan,
+	TP_PROTO(struct xfs_scrub *sc, const struct xfs_bmbt_irec *irec,
+		 xfs_extlen_t scan_blocks),
+	TP_ARGS(sc, irec, scan_blocks),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_filblks_t, len)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, scan_blocks)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->len = irec->br_blockcount;
+		__entry->agno = XFS_FSB_TO_AGNO(sc->mp, irec->br_startblock);
+		__entry->agbno = XFS_FSB_TO_AGBNO(sc->mp, irec->br_startblock);
+		__entry->scan_blocks = scan_blocks;
+	),
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%llx scan_blocks 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->scan_blocks)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 

