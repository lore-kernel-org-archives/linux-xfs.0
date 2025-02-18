Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445EB22AE5D
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866324; cv=none; b=dpsj6D7oKTF3TVy7r1Co4ghqhESCiWAZ4QrLqZj3nHB+/3ascPcW8qjpJ10UUCruNiCzFcpXcMRQ6vHtUngziCLbyvtkBlPpKLroU5wcrWmED2EB1PwRmZwRxA8Dd61pzWugFYjGT3aVe4RakQgllCBe7dLPDTTrnXAjyZVujG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866324; c=relaxed/simple;
	bh=4ABWUzF5F4MOYLOtg4rociMOpiVU30aZh0b2VOLlDxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CU1mrYaDe/g6tmeTZ1hJl5Y5rVwvjffgMJxyhyQTx+oDwieVObeUQj9Mq9YbgjQ7mjp8fKdMkTNBkG4USPKLbZAu2MzNbSgWGIZeS2RzfxaBgmeIJ8AleI7zMLM/zrqltYQ+UGacbpqEAqvSJ45kXVurFPJo+gkZ9iUj3mn/hnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ppPUp5db; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ppPUp5db"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=agNJAcdx6E9XZ2A6ka+s9b7+3xF/x6nCj67OuYolhfM=; b=ppPUp5dbDZJ5dwslZl25y/l4aV
	7tMZi6pcNf3PndwRP9yuVViCpBfTToDExG+Eq+jpjLJkQJQslrqxNChfgSf2jdMk7cDpR7kj/OTQm
	57fk1LJd+wb4TjlypzTMY+gdKm8R+r3658uUeKkY6oUEm1Bn21LaomaSQp6D4/I5DuzBWRhYKndqv
	2u2/qG3snbEJ4XK7yexKtN1nS7H5YWs2bRX90n2nQJuEqoP/Dd1zMO2Jj7JD4jwvwad3nWqm7CKS0
	6J309S7G2sHJGsgBdMrmxWF84puxcVjd1nlQoHsK9v4bk+GHMuwjtnUq58QBQBDZ299tJ6v1043j2
	Obp4O4Og==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIi1-00000007CGw-2LH1;
	Tue, 18 Feb 2025 08:12:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/45] xfs: generalize the freespace and reserved blocks handling
Date: Tue, 18 Feb 2025 09:10:05 +0100
Message-ID: <20250218081153.3889537-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_{add,dec}_freecounter already handles the block and RT extent
percpu counters, but it currently hardcodes the passed in counter.

Add a freecounter abstraction that uses an enum to designate the counter
and add wrappers that hide the actual percpu_counters.  This will allow
expanding the reserved block handling to the RT extent counter in the
next step, and also prepares for adding yet another such counter that
can share the code.  Both these additions will be needed for the zoned
allocator.

Also switch the flooring of the frextents counter to 0 in statfs for the
rthinherit case to a manual min_t call to match the handling of the
fdblocks counter for normal file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c       |  2 +-
 fs/xfs/libxfs/xfs_metafile.c     |  2 +-
 fs/xfs/libxfs/xfs_sb.c           |  8 ++--
 fs/xfs/libxfs/xfs_types.h        | 17 ++++++++
 fs/xfs/scrub/fscounters.c        | 11 ++---
 fs/xfs/scrub/fscounters_repair.c |  4 +-
 fs/xfs/scrub/newbt.c             |  2 +-
 fs/xfs/xfs_fsops.c               |  6 +--
 fs/xfs/xfs_icache.c              |  4 +-
 fs/xfs/xfs_ioctl.c               |  6 +--
 fs/xfs/xfs_iomap.c               |  9 ++--
 fs/xfs/xfs_mount.c               | 37 +++++++++++++----
 fs/xfs/xfs_mount.h               | 70 ++++++++++++++++++++++++--------
 fs/xfs/xfs_rtalloc.c             |  2 +-
 fs/xfs/xfs_super.c               | 42 ++++++++++---------
 fs/xfs/xfs_trace.h               |  2 +-
 16 files changed, 151 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f3a840a425f5..57513ba19d6a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1927,7 +1927,7 @@ xfs_dialloc(
 	 * that we can immediately allocate, but then we allow allocation on the
 	 * second pass if we fail to find an AG with free inodes in it.
 	 */
-	if (percpu_counter_read_positive(&mp->m_fdblocks) <
+	if (xfs_estimate_freecounter(mp, XC_FREE_BLOCKS) <
 			mp->m_low_space[XFS_LOWSP_1_PCNT]) {
 		ok_alloc = false;
 		low_space = true;
diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index 2f5f554a36d4..7625e694eb8d 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -95,7 +95,7 @@ xfs_metafile_resv_can_cover(
 	 * There aren't enough blocks left in the inode's reservation, but it
 	 * isn't critical unless there also isn't enough free space.
 	 */
-	return __percpu_counter_compare(&ip->i_mount->m_fdblocks,
+	return xfs_compare_freecounter(ip->i_mount, XC_FREE_BLOCKS,
 			rhs - ip->i_delayed_blks, 2048) >= 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 3dc5f5dba162..3fdd20df961c 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1265,8 +1265,7 @@ xfs_log_sb(
 		mp->m_sb.sb_ifree = min_t(uint64_t,
 				percpu_counter_sum_positive(&mp->m_ifree),
 				mp->m_sb.sb_icount);
-		mp->m_sb.sb_fdblocks =
-				percpu_counter_sum_positive(&mp->m_fdblocks);
+		mp->m_sb.sb_fdblocks = xfs_sum_freecounter(mp, XC_FREE_BLOCKS);
 	}
 
 	/*
@@ -1275,9 +1274,10 @@ xfs_log_sb(
 	 * we handle nearly-lockless reservations, so we must use the _positive
 	 * variant here to avoid writing out nonsense frextents.
 	 */
-	if (xfs_has_rtgroups(mp))
+	if (xfs_has_rtgroups(mp)) {
 		mp->m_sb.sb_frextents =
-				percpu_counter_sum_positive(&mp->m_frextents);
+				xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
+	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index ca2401c1facd..76f3c31573ec 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -233,6 +233,23 @@ enum xfs_group_type {
 	{ XG_TYPE_AG,	"ag" }, \
 	{ XG_TYPE_RTG,	"rtg" }
 
+enum xfs_free_counter {
+	/*
+	 * Number of free blocks on the data device.
+	 */
+	XC_FREE_BLOCKS,
+
+	/*
+	 * Number of free RT extents on the RT device.
+	 */
+	XC_FREE_RTEXTENTS,
+	XC_FREE_NR,
+};
+
+#define XFS_FREECOUNTER_STR \
+	{ XC_FREE_BLOCKS,		"blocks" }, \
+	{ XC_FREE_RTEXTENTS,		"rtextents" }
+
 /*
  * Type verifier functions
  */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index ca23cf4db6c5..207a238de429 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -513,8 +513,8 @@ xchk_fscounters(
 	/* Snapshot the percpu counters. */
 	icount = percpu_counter_sum(&mp->m_icount);
 	ifree = percpu_counter_sum(&mp->m_ifree);
-	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
-	frextents = percpu_counter_sum(&mp->m_frextents);
+	fdblocks = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS);
+	frextents = xfs_sum_freecounter_raw(mp, XC_FREE_RTEXTENTS);
 
 	/* No negative values, please! */
 	if (icount < 0 || ifree < 0)
@@ -589,15 +589,16 @@ xchk_fscounters(
 			try_again = true;
 	}
 
-	if (!xchk_fscount_within_range(sc, fdblocks, &mp->m_fdblocks,
-			fsc->fdblocks)) {
+	if (!xchk_fscount_within_range(sc, fdblocks,
+			&mp->m_free[XC_FREE_BLOCKS].count, fsc->fdblocks)) {
 		if (fsc->frozen)
 			xchk_set_corrupt(sc);
 		else
 			try_again = true;
 	}
 
-	if (!xchk_fscount_within_range(sc, frextents, &mp->m_frextents,
+	if (!xchk_fscount_within_range(sc, frextents,
+			&mp->m_free[XC_FREE_RTEXTENTS].count,
 			fsc->frextents - fsc->frextents_delayed)) {
 		if (fsc->frozen)
 			xchk_set_corrupt(sc);
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
index cda13447a373..8fb0db78489e 100644
--- a/fs/xfs/scrub/fscounters_repair.c
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -64,7 +64,7 @@ xrep_fscounters(
 
 	percpu_counter_set(&mp->m_icount, fsc->icount);
 	percpu_counter_set(&mp->m_ifree, fsc->ifree);
-	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
+	xfs_set_freecounter(mp, XC_FREE_BLOCKS, fsc->fdblocks);
 
 	/*
 	 * Online repair is only supported on v5 file systems, which require
@@ -74,7 +74,7 @@ xrep_fscounters(
 	 * track of the delalloc reservations separately, as they are are
 	 * subtracted from m_frextents, but not included in sb_frextents.
 	 */
-	percpu_counter_set(&mp->m_frextents,
+	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
 		fsc->frextents - fsc->frextents_delayed);
 	if (!xfs_has_rtgroups(mp))
 		mp->m_sb.sb_frextents = fsc->frextents;
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index ac38f5843090..1588ce971cb8 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -62,7 +62,7 @@ xrep_newbt_estimate_slack(
 		free = sc->sa.pag->pagf_freeblks;
 		sz = xfs_ag_block_count(sc->mp, pag_agno(sc->sa.pag));
 	} else {
-		free = percpu_counter_sum(&sc->mp->m_fdblocks);
+		free = xfs_sum_freecounter_raw(sc->mp, XC_FREE_BLOCKS);
 		sz = sc->mp->m_sb.sb_dblocks;
 	}
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 455298503d01..58249f37a7ad 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -409,7 +409,7 @@ xfs_reserve_blocks(
 
 	/*
 	 * If the request is larger than the current reservation, reserve the
-	 * blocks before we update the reserve counters. Sample m_fdblocks and
+	 * blocks before we update the reserve counters. Sample m_free and
 	 * perform a partial reservation if the request exceeds free space.
 	 *
 	 * The code below estimates how many blocks it can request from
@@ -419,8 +419,8 @@ xfs_reserve_blocks(
 	 * space to fill it because mod_fdblocks will refill an undersized
 	 * reserve when it can.
 	 */
-	free = percpu_counter_sum(&mp->m_fdblocks) -
-						xfs_fdblocks_unavailable(mp);
+	free = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS) -
+		xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS);
 	delta = request - mp->m_resblks;
 	mp->m_resblks = request;
 	if (delta > 0 && free > 0) {
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7b6c026d01a1..c9ded501e89b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2076,7 +2076,7 @@ xfs_inodegc_want_queue_rt_file(
 	if (!XFS_IS_REALTIME_INODE(ip))
 		return false;
 
-	if (__percpu_counter_compare(&mp->m_frextents,
+	if (xfs_compare_freecounter(mp, XC_FREE_RTEXTENTS,
 				mp->m_low_rtexts[XFS_LOWSP_5_PCNT],
 				XFS_FDBLOCKS_BATCH) < 0)
 		return true;
@@ -2104,7 +2104,7 @@ xfs_inodegc_want_queue_work(
 	if (items > mp->m_ino_geo.inodes_per_cluster)
 		return true;
 
-	if (__percpu_counter_compare(&mp->m_fdblocks,
+	if (xfs_compare_freecounter(mp, XC_FREE_BLOCKS,
 				mp->m_low_space[XFS_LOWSP_5_PCNT],
 				XFS_FDBLOCKS_BATCH) < 0)
 		return true;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ed85322507dd..0418aad2db91 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1155,9 +1155,9 @@ xfs_ioctl_fs_counts(
 	struct xfs_fsop_counts	out = {
 		.allocino = percpu_counter_read_positive(&mp->m_icount),
 		.freeino  = percpu_counter_read_positive(&mp->m_ifree),
-		.freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
-				xfs_fdblocks_unavailable(mp),
-		.freertx  = percpu_counter_read_positive(&mp->m_frextents),
+		.freedata = xfs_estimate_freecounter(mp, XC_FREE_BLOCKS) -
+				xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS),
+		.freertx  = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS),
 	};
 
 	if (copy_to_user(uarg, &out, sizeof(out)))
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 46acf727cbe7..c669b93bb2d1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -431,13 +431,14 @@ xfs_quota_calc_throttle(
 
 static int64_t
 xfs_iomap_freesp(
-	struct percpu_counter	*counter,
+	struct xfs_mount	*mp,
+	unsigned int		idx,
 	uint64_t		low_space[XFS_LOWSP_MAX],
 	int			*shift)
 {
 	int64_t			freesp;
 
-	freesp = percpu_counter_read_positive(counter);
+	freesp = xfs_estimate_freecounter(mp, idx);
 	if (freesp < low_space[XFS_LOWSP_5_PCNT]) {
 		*shift = 2;
 		if (freesp < low_space[XFS_LOWSP_4_PCNT])
@@ -536,10 +537,10 @@ xfs_iomap_prealloc_size(
 
 	if (unlikely(XFS_IS_REALTIME_INODE(ip)))
 		freesp = xfs_rtbxlen_to_blen(mp,
-				xfs_iomap_freesp(&mp->m_frextents,
+				xfs_iomap_freesp(mp, XC_FREE_RTEXTENTS,
 					mp->m_low_rtexts, &shift));
 	else
-		freesp = xfs_iomap_freesp(&mp->m_fdblocks, mp->m_low_space,
+		freesp = xfs_iomap_freesp(mp, XC_FREE_BLOCKS, mp->m_low_space,
 				&shift);
 
 	/*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0598e9db488c..ee97a927bc3b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1223,13 +1223,31 @@ xfs_fs_writable(
 	return true;
 }
 
+/*
+ * Estimate the amount of free space that is not available to userspace and is
+ * not explicitly reserved from the incore fdblocks.  This includes:
+ *
+ * - The minimum number of blocks needed to support splitting a bmap btree
+ * - The blocks currently in use by the freespace btrees because they record
+ *   the actual blocks that will fill per-AG metadata space reservations
+ */
+uint64_t
+xfs_freecounter_unavailable(
+	struct xfs_mount	*mp,
+	enum xfs_free_counter	ctr)
+{
+	if (ctr != XC_FREE_BLOCKS)
+		return 0;
+	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+}
+
 void
 xfs_add_freecounter(
 	struct xfs_mount	*mp,
-	struct percpu_counter	*counter,
+	enum xfs_free_counter	ctr,
 	uint64_t		delta)
 {
-	bool			has_resv_pool = (counter == &mp->m_fdblocks);
+	bool			has_resv_pool = (ctr == XC_FREE_BLOCKS);
 	uint64_t		res_used;
 
 	/*
@@ -1237,7 +1255,7 @@ xfs_add_freecounter(
 	 * Most of the time the pool is full.
 	 */
 	if (!has_resv_pool || mp->m_resblks == mp->m_resblks_avail) {
-		percpu_counter_add(counter, delta);
+		percpu_counter_add(&mp->m_free[ctr].count, delta);
 		return;
 	}
 
@@ -1248,24 +1266,27 @@ xfs_add_freecounter(
 	} else {
 		delta -= res_used;
 		mp->m_resblks_avail = mp->m_resblks;
-		percpu_counter_add(counter, delta);
+		percpu_counter_add(&mp->m_free[ctr].count, delta);
 	}
 	spin_unlock(&mp->m_sb_lock);
 }
 
+
+/* Adjust in-core free blocks or RT extents. */
 int
 xfs_dec_freecounter(
 	struct xfs_mount	*mp,
-	struct percpu_counter	*counter,
+	enum xfs_free_counter	ctr,
 	uint64_t		delta,
 	bool			rsvd)
 {
+	struct percpu_counter	*counter = &mp->m_free[ctr].count;
 	uint64_t		set_aside = 0;
 	s32			batch;
 	bool			has_resv_pool;
 
-	ASSERT(counter == &mp->m_fdblocks || counter == &mp->m_frextents);
-	has_resv_pool = (counter == &mp->m_fdblocks);
+	ASSERT(ctr < XC_FREE_NR);
+	has_resv_pool = (ctr == XC_FREE_BLOCKS);
 	if (rsvd)
 		ASSERT(has_resv_pool);
 
@@ -1295,7 +1316,7 @@ xfs_dec_freecounter(
 	 * slightly premature -ENOSPC.
 	 */
 	if (has_resv_pool)
-		set_aside = xfs_fdblocks_unavailable(mp);
+		set_aside = xfs_freecounter_unavailable(mp, ctr);
 	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
 	if (__percpu_counter_compare(counter, set_aside,
 			XFS_FDBLOCKS_BATCH) < 0) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fbed172d6770..7f3265d669bc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -105,6 +105,11 @@ struct xfs_groups {
 	uint64_t		blkmask;
 };
 
+struct xfs_freecounter {
+	/* free blocks for general use: */
+	struct percpu_counter	count;
+};
+
 /*
  * The struct xfsmount layout is optimised to separate read-mostly variables
  * from variables that are frequently modified. We put the read-mostly variables
@@ -222,8 +227,8 @@ typedef struct xfs_mount {
 	spinlock_t ____cacheline_aligned m_sb_lock; /* sb counter lock */
 	struct percpu_counter	m_icount;	/* allocated inodes counter */
 	struct percpu_counter	m_ifree;	/* free inodes counter */
-	struct percpu_counter	m_fdblocks;	/* free block counter */
-	struct percpu_counter	m_frextents;	/* free rt extent counter */
+
+	struct xfs_freecounter	m_free[XC_FREE_NR];
 
 	/*
 	 * Count of data device blocks reserved for delayed allocations,
@@ -646,45 +651,74 @@ extern void	xfs_unmountfs(xfs_mount_t *);
  */
 #define XFS_FDBLOCKS_BATCH	1024
 
+uint64_t xfs_freecounter_unavailable(struct xfs_mount *mp,
+		enum xfs_free_counter ctr);
+
 /*
- * Estimate the amount of free space that is not available to userspace and is
- * not explicitly reserved from the incore fdblocks.  This includes:
- *
- * - The minimum number of blocks needed to support splitting a bmap btree
- * - The blocks currently in use by the freespace btrees because they record
- *   the actual blocks that will fill per-AG metadata space reservations
+ * Sum up the freecount, but never return negative values.
  */
-static inline uint64_t
-xfs_fdblocks_unavailable(
-	struct xfs_mount	*mp)
+static inline s64 xfs_sum_freecounter(struct xfs_mount *mp,
+		enum xfs_free_counter ctr)
+{
+	return percpu_counter_sum_positive(&mp->m_free[ctr].count);
+}
+
+/*
+ * Same as above, but does return negative values.  Mostly useful for
+ * special cases like repair and tracing.
+ */
+static inline s64 xfs_sum_freecounter_raw(struct xfs_mount *mp,
+		enum xfs_free_counter ctr)
+{
+	return percpu_counter_sum(&mp->m_free[ctr].count);
+}
+
+/*
+ * This just provides and estimate without the cpu-local updates, use
+ * xfs_sum_freecounter for the exact value.
+ */
+static inline s64 xfs_estimate_freecounter(struct xfs_mount *mp,
+		enum xfs_free_counter ctr)
+{
+	return percpu_counter_read_positive(&mp->m_free[ctr].count);
+}
+
+static inline int xfs_compare_freecounter(struct xfs_mount *mp,
+		enum xfs_free_counter ctr, s64 rhs, s32 batch)
+{
+	return __percpu_counter_compare(&mp->m_free[ctr].count, rhs, batch);
+}
+
+static inline void xfs_set_freecounter(struct xfs_mount *mp,
+		enum xfs_free_counter ctr, uint64_t val)
 {
-	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+	percpu_counter_set(&mp->m_free[ctr].count, val);
 }
 
-int xfs_dec_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
+int xfs_dec_freecounter(struct xfs_mount *mp, enum xfs_free_counter ctr,
 		uint64_t delta, bool rsvd);
-void xfs_add_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
+void xfs_add_freecounter(struct xfs_mount *mp, enum xfs_free_counter ctr,
 		uint64_t delta);
 
 static inline int xfs_dec_fdblocks(struct xfs_mount *mp, uint64_t delta,
 		bool reserved)
 {
-	return xfs_dec_freecounter(mp, &mp->m_fdblocks, delta, reserved);
+	return xfs_dec_freecounter(mp, XC_FREE_BLOCKS, delta, reserved);
 }
 
 static inline void xfs_add_fdblocks(struct xfs_mount *mp, uint64_t delta)
 {
-	xfs_add_freecounter(mp, &mp->m_fdblocks, delta);
+	xfs_add_freecounter(mp, XC_FREE_BLOCKS, delta);
 }
 
 static inline int xfs_dec_frextents(struct xfs_mount *mp, uint64_t delta)
 {
-	return xfs_dec_freecounter(mp, &mp->m_frextents, delta, false);
+	return xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, delta, false);
 }
 
 static inline void xfs_add_frextents(struct xfs_mount *mp, uint64_t delta)
 {
-	xfs_add_freecounter(mp, &mp->m_frextents, delta);
+	xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, delta);
 }
 
 extern int	xfs_readsb(xfs_mount_t *, int);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d8e6d073d64d..489aab923c9b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1519,7 +1519,7 @@ xfs_rtalloc_reinit_frextents(
 	spin_lock(&mp->m_sb_lock);
 	mp->m_sb.sb_frextents = val;
 	spin_unlock(&mp->m_sb_lock);
-	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
+	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS, mp->m_sb.sb_frextents);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0055066fb1d9..b08d28a895cb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -834,10 +834,12 @@ xfs_statfs_data(
 	struct kstatfs		*st)
 {
 	int64_t			fdblocks =
-		percpu_counter_sum(&mp->m_fdblocks);
+		xfs_sum_freecounter(mp, XC_FREE_BLOCKS);
 
 	/* make sure st->f_bfree does not underflow */
-	st->f_bfree = max(0LL, fdblocks - xfs_fdblocks_unavailable(mp));
+	st->f_bfree = max(0LL,
+		fdblocks - xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS));
+
 	/*
 	 * sb_dblocks can change during growfs, but nothing cares about reporting
 	 * the old or new value during growfs.
@@ -856,7 +858,7 @@ xfs_statfs_rt(
 	struct kstatfs		*st)
 {
 	st->f_bfree = xfs_rtbxlen_to_blen(mp,
-			percpu_counter_sum_positive(&mp->m_frextents));
+			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
 	st->f_blocks = mp->m_sb.sb_rblocks;
 }
 
@@ -1065,7 +1067,8 @@ static int
 xfs_init_percpu_counters(
 	struct xfs_mount	*mp)
 {
-	int		error;
+	int			error;
+	int			i;
 
 	error = percpu_counter_init(&mp->m_icount, 0, GFP_KERNEL);
 	if (error)
@@ -1075,30 +1078,29 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_icount;
 
-	error = percpu_counter_init(&mp->m_fdblocks, 0, GFP_KERNEL);
-	if (error)
-		goto free_ifree;
-
 	error = percpu_counter_init(&mp->m_delalloc_blks, 0, GFP_KERNEL);
 	if (error)
-		goto free_fdblocks;
+		goto free_ifree;
 
 	error = percpu_counter_init(&mp->m_delalloc_rtextents, 0, GFP_KERNEL);
 	if (error)
 		goto free_delalloc;
 
-	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
-	if (error)
-		goto free_delalloc_rt;
+	for (i = 0; i < XC_FREE_NR; i++) {
+		error = percpu_counter_init(&mp->m_free[i].count, 0,
+				GFP_KERNEL);
+		if (error)
+			goto free_freecounters;
+	}
 
 	return 0;
 
-free_delalloc_rt:
+free_freecounters:
+	while (--i > 0)
+		percpu_counter_destroy(&mp->m_free[i].count);
 	percpu_counter_destroy(&mp->m_delalloc_rtextents);
 free_delalloc:
 	percpu_counter_destroy(&mp->m_delalloc_blks);
-free_fdblocks:
-	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
 	percpu_counter_destroy(&mp->m_ifree);
 free_icount:
@@ -1112,24 +1114,26 @@ xfs_reinit_percpu_counters(
 {
 	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
 	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
-	percpu_counter_set(&mp->m_fdblocks, mp->m_sb.sb_fdblocks);
-	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
+	xfs_set_freecounter(mp, XC_FREE_BLOCKS, mp->m_sb.sb_fdblocks);
+	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS, mp->m_sb.sb_frextents);
 }
 
 static void
 xfs_destroy_percpu_counters(
 	struct xfs_mount	*mp)
 {
+	enum xfs_free_counter	i;
+
+	for (i = 0; i < XC_FREE_NR; i++)
+		percpu_counter_destroy(&mp->m_free[i].count);
 	percpu_counter_destroy(&mp->m_icount);
 	percpu_counter_destroy(&mp->m_ifree);
-	percpu_counter_destroy(&mp->m_fdblocks);
 	ASSERT(xfs_is_shutdown(mp) ||
 	       percpu_counter_sum(&mp->m_delalloc_rtextents) == 0);
 	percpu_counter_destroy(&mp->m_delalloc_rtextents);
 	ASSERT(xfs_is_shutdown(mp) ||
 	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
 	percpu_counter_destroy(&mp->m_delalloc_blks);
-	percpu_counter_destroy(&mp->m_frextents);
 }
 
 static int
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b29462363b81..7fdcb519cf2f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5621,7 +5621,7 @@ DECLARE_EVENT_CLASS(xfs_metafile_resv_class,
 
 		__entry->dev = mp->m_super->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->freeblks = percpu_counter_sum(&mp->m_fdblocks);
+		__entry->freeblks = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS);
 		__entry->reserved = ip->i_delayed_blks;
 		__entry->asked = ip->i_meta_resv_asked;
 		__entry->used = ip->i_nblocks;
-- 
2.45.2

