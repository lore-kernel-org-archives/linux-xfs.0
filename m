Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A45913FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688222; cv=none; b=to5cS93vHn+gQo/S0tEkQQbxmWc/KzBlsKHc2KgsK1MetWxLopKFUeV9t6rUE4ktTxaunWlNcE3etyLhAXrm6eKw0tnauLU+reasWCJT9Lsgg+AMP3d+luKUoI/BEE6kRsgi0xIdRQPBIevbwLnt9infhSpE5m38/qgW/Oz+nRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688222; c=relaxed/simple;
	bh=o7PgozDMRfY/4b6Kej8xtZlyJtoloTsaUj03lEDoUpA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YEsvFH22MpO/y8hFmoxSdkCc2w/fIB/S3QKofqYUCvvPKgCd4kj9rLiF/U05PoV403H+IgVH2tLitQCpODDRSdzW3hMmiSAFnwMV/0xVADUSTcnJA3/h/ngrm0AEL/+Q3tRry26zEqMNbBYvvr/lNKIHaL769LyD7hnKpSekV74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spAakOFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spAakOFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03471C4CED2;
	Tue, 31 Dec 2024 23:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688222;
	bh=o7PgozDMRfY/4b6Kej8xtZlyJtoloTsaUj03lEDoUpA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=spAakOFusA5TOUlEZyBftnxTS1beJ9g0I8aca5T3s+BTP8tYHT8RFFDGhOgK9kW5p
	 cNLdGKbaZVVic6fNj3DIR+l2IBzGAR+qAHmdvRmUvBXAJ0RwDXZRi+ISUHmbhYKahq
	 1NFZ+SYq8WAPSrhgsSAo1oOVwuYAL2gSv8OAGKj8KiVVP7xs74wr8WGqtp6CWeuSXl
	 X23csDKK7ocozA2f3QMp/MTxfZuQbBRUPUK4c21a9OfF5ultzOTokSFs/3PI75z1iR
	 0WeowipHr9YtmhBj6b9ve8GS5wM5vnxcv12e2MtlObR8KBS4mnXk1QjenwIFI6G6Ql
	 2wALlxkmfKXUg==
Date: Tue, 31 Dec 2024 15:37:01 -0800
Subject: [PATCH 3/5] xfs: create a noalloc mode for allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568753374.2704399.9022049113109750800.stgit@frogsfrogsfrogs>
In-Reply-To: <173568753306.2704399.16022227525226280055.stgit@frogsfrogsfrogs>
References: <173568753306.2704399.16022227525226280055.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new noalloc state for the per-AG structure that will disable
block allocation in this AG.  We accomplish this by subtracting from
fdblocks all the free blocks in this AG, hiding those blocks from the
allocator, and preventing freed blocks from updating fdblocks until
we're ready to lift noalloc mode.

Note that we reduce the free block count of the filesystem so that we
can prevent transactions from entering the allocator looking for "free"
space that we've turned off incore.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c      |   60 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h      |    8 ++++++
 fs/xfs/libxfs/xfs_ag_resv.c |   27 +++++++++++++++++--
 fs/xfs/scrub/fscounters.c   |    3 +-
 fs/xfs/xfs_fsops.c          |   10 ++++++-
 fs/xfs/xfs_super.c          |    1 +
 fs/xfs/xfs_trace.h          |   46 +++++++++++++++++++++++++++++++++
 7 files changed, 150 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index b59cb461e096ea..1e65cd981afd49 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -976,3 +976,63 @@ xfs_ag_get_geometry(
 	xfs_buf_relse(agi_bp);
 	return error;
 }
+
+/* How many blocks does this AG contribute to fdblocks? */
+xfs_extlen_t
+xfs_ag_fdblocks(
+	struct xfs_perag		*pag)
+{
+	xfs_extlen_t			ret;
+
+	ASSERT(xfs_perag_initialised_agf(pag));
+
+	ret = pag->pagf_freeblks + pag->pagf_flcount + pag->pagf_btreeblks;
+	ret -= pag->pag_meta_resv.ar_reserved;
+	ret -= pag->pag_rmapbt_resv.ar_orig_reserved;
+	return ret;
+}
+
+/*
+ * Hide all the free space in this AG.  Caller must hold both the AGI and the
+ * AGF buffers or have otherwise prevented concurrent access.
+ */
+int
+xfs_ag_set_noalloc(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag_mount(pag);
+	int			error;
+
+	ASSERT(xfs_perag_initialised_agf(pag));
+	ASSERT(xfs_perag_initialised_agi(pag));
+
+	if (xfs_perag_prohibits_alloc(pag))
+		return 0;
+
+	error = xfs_dec_fdblocks(mp, xfs_ag_fdblocks(pag), false);
+	if (error)
+		return error;
+
+	trace_xfs_ag_set_noalloc(pag);
+	set_bit(XFS_AGSTATE_NOALLOC, &pag->pag_opstate);
+	return 0;
+}
+
+/*
+ * Unhide all the free space in this AG.  Caller must hold both the AGI and
+ * the AGF buffers or have otherwise prevented concurrent access.
+ */
+void
+xfs_ag_clear_noalloc(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag_mount(pag);
+
+	if (!xfs_perag_prohibits_alloc(pag))
+		return;
+
+	xfs_add_fdblocks(mp, xfs_ag_fdblocks(pag));
+
+	trace_xfs_ag_clear_noalloc(pag);
+	clear_bit(XFS_AGSTATE_NOALLOC, &pag->pag_opstate);
+}
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 1f24cfa2732172..e8fae59206d929 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -120,6 +120,7 @@ static inline xfs_agnumber_t pag_agno(const struct xfs_perag *pag)
 #define XFS_AGSTATE_PREFERS_METADATA	2
 #define XFS_AGSTATE_ALLOWS_INODES	3
 #define XFS_AGSTATE_AGFL_NEEDS_RESET	4
+#define XFS_AGSTATE_NOALLOC		5
 
 #define __XFS_AG_OPSTATE(name, NAME) \
 static inline bool xfs_perag_ ## name (struct xfs_perag *pag) \
@@ -132,6 +133,7 @@ __XFS_AG_OPSTATE(initialised_agi, AGI_INIT)
 __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
 __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
 __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
+__XFS_AG_OPSTATE(prohibits_alloc, NOALLOC)
 
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t orig_agcount,
 		xfs_agnumber_t new_agcount, xfs_rfsblock_t dcount,
@@ -164,6 +166,7 @@ xfs_perag_put(
 	xfs_group_put(pag_group(pag));
 }
 
+
 /* Active AG references */
 static inline struct xfs_perag *
 xfs_perag_grab(
@@ -208,6 +211,11 @@ xfs_perag_next(
 	return xfs_perag_next_from(mp, pag, 0);
 }
 
+/* Enable or disable allocation from an AG */
+xfs_extlen_t xfs_ag_fdblocks(struct xfs_perag *pag);
+int xfs_ag_set_noalloc(struct xfs_perag *pag);
+void xfs_ag_clear_noalloc(struct xfs_perag *pag);
+
 /*
  * Per-ag geometry infomation and validation
  */
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index fb79215a509d21..fda3d7614838e7 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -74,6 +74,13 @@ xfs_ag_resv_critical(
 	xfs_extlen_t			avail;
 	xfs_extlen_t			orig;
 
+	/*
+	 * Pretend we're critically low on reservations in this AG to scare
+	 * everyone else away.
+	 */
+	if (xfs_perag_prohibits_alloc(pag))
+		return true;
+
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
 		avail = pag->pagf_freeblks - pag->pag_rmapbt_resv.ar_reserved;
@@ -116,7 +123,12 @@ xfs_ag_resv_needed(
 		break;
 	case XFS_AG_RESV_METAFILE:
 	case XFS_AG_RESV_NONE:
-		/* empty */
+		/*
+		 * In noalloc mode, we pretend that all the free blocks in this
+		 * AG have been allocated.  Make this AG look full.
+		 */
+		if (xfs_perag_prohibits_alloc(pag))
+			len += xfs_ag_fdblocks(pag);
 		break;
 	default:
 		ASSERT(0);
@@ -344,6 +356,8 @@ xfs_ag_resv_alloc_extent(
 	xfs_extlen_t			len;
 	uint				field;
 
+	ASSERT(type != XFS_AG_RESV_NONE || !xfs_perag_prohibits_alloc(pag));
+
 	trace_xfs_ag_resv_alloc_extent(pag, type, args->len);
 
 	switch (type) {
@@ -401,7 +415,14 @@ xfs_ag_resv_free_extent(
 		ASSERT(0);
 		fallthrough;
 	case XFS_AG_RESV_NONE:
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
+		/*
+		 * Normally we put freed blocks back into fdblocks.  In noalloc
+		 * mode, however, we pretend that there are no fdblocks in the
+		 * AG, so don't put them back.
+		 */
+		if (!xfs_perag_prohibits_alloc(pag))
+			xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS,
+					(int64_t)len);
 		fallthrough;
 	case XFS_AG_RESV_IGNORE:
 		return;
@@ -414,6 +435,6 @@ xfs_ag_resv_free_extent(
 	/* Freeing into the reserved pool only requires on-disk update... */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, len);
 	/* ...but freeing beyond that requires in-core and on-disk update. */
-	if (len > leftover)
+	if (len > leftover && !xfs_perag_prohibits_alloc(pag))
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, len - leftover);
 }
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index f7258544848fcd..af69ed7733acd6 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -337,7 +337,8 @@ xchk_fscount_aggregate_agcounts(
 		 */
 		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
 		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
-
+		if (xfs_perag_prohibits_alloc(pag))
+			fsc->fdblocks -= xfs_ag_fdblocks(pag);
 	}
 	if (pag)
 		xfs_perag_rele(pag);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8dc2b738c911ee..150979c8333530 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -592,6 +592,14 @@ xfs_fs_unreserve_ag_blocks(
 	if (xfs_has_realtime(mp))
 		xfs_rt_resv_free(mp);
 
-	while ((pag = xfs_perag_next(mp, pag)))
+	while ((pag = xfs_perag_next(mp, pag))) {
+		/*
+		 * Bring the AG back online because our AG hiding only exists
+		 * in-core and we need the superblock to be written out with
+		 * the super fdblocks reflecting the AGF freeblks.  Do this
+		 * before adding the per-AG reservations back to fdblocks.
+		 */
+		xfs_ag_clear_noalloc(pag);
 		xfs_ag_resv_free(pag);
+	}
 }
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e1554f061376e5..099c30339e8f9d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -336,6 +336,7 @@ xfs_set_inode_alloc(
 		pag = xfs_perag_get(mp, index);
 		if (xfs_set_inode_alloc_perag(pag, ino, max_metadata))
 			maxagi++;
+		clear_bit(XFS_AGSTATE_NOALLOC, &pag->pag_opstate);
 		xfs_perag_put(pag);
 	}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0352f432421598..dc7ffc8f8e9dea 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4589,6 +4589,52 @@ DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_corrupt);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_unfixed_corruption);
 
+DECLARE_EVENT_CLASS(xfs_ag_noalloc_class,
+	TP_PROTO(struct xfs_perag *pag),
+	TP_ARGS(pag),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_extlen_t, freeblks)
+		__field(xfs_extlen_t, flcount)
+		__field(xfs_extlen_t, btreeblks)
+		__field(xfs_extlen_t, meta_resv)
+		__field(xfs_extlen_t, rmap_resv)
+
+		__field(unsigned long long, resblks)
+		__field(unsigned long long, resblks_avail)
+	),
+	TP_fast_assign(
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
+		__entry->freeblks = pag->pagf_freeblks;
+		__entry->flcount = pag->pagf_flcount;
+		__entry->btreeblks = pag->pagf_btreeblks;
+		__entry->meta_resv = pag->pag_meta_resv.ar_reserved;
+		__entry->rmap_resv = pag->pag_rmapbt_resv.ar_orig_reserved;
+
+		__entry->resblks = pag_mount(pag)->m_resblks[XC_FREE_BLOCKS].total;
+		__entry->resblks_avail = pag_mount(pag)->m_resblks[XC_FREE_BLOCKS].avail;
+	),
+	TP_printk("dev %d:%d agno 0x%x freeblks %u flcount %u btreeblks %u metaresv %u rmapresv %u resblks %llu resblks_avail %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->freeblks,
+		  __entry->flcount,
+		  __entry->btreeblks,
+		  __entry->meta_resv,
+		  __entry->rmap_resv,
+		  __entry->resblks,
+		  __entry->resblks_avail)
+);
+#define DEFINE_AG_NOALLOC_EVENT(name)	\
+DEFINE_EVENT(xfs_ag_noalloc_class, name,	\
+	TP_PROTO(struct xfs_perag *pag),	\
+	TP_ARGS(pag))
+
+DEFINE_AG_NOALLOC_EVENT(xfs_ag_set_noalloc);
+DEFINE_AG_NOALLOC_EVENT(xfs_ag_clear_noalloc);
+
 TRACE_EVENT(xfs_iwalk_ag_rec,
 	TP_PROTO(const struct xfs_perag *pag, \
 		 struct xfs_inobt_rec_incore *irec),

