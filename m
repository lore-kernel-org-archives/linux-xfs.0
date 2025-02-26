Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9D8237168
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596248; cv=none; b=jrIkKB/p9n9R4rrTRqnMMrjjPe0/tz4Ej8Q5GaHTM0M9QzZRwUDd4LsB8bLW1Vq07TCKxE7JVp5kgjCcyDkxslsbdiOVtHD0svaGMoloVgOC39zEyR7EiXNIv/iXyvtdKNLeDow7Ac8719AeTHf48qoIgAF/CIn2qgFPlbuQi4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596248; c=relaxed/simple;
	bh=I8zUDyd3gnrRPivVIR2UUrrhHxGGdCrVW+FoizIoJDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNjWWyKUcw7qR3BPlOKakV4a2bpe/PrUqnhjHd3ym9j1xyMX4VEobZux03aj5wd6CL0H8PIyydTKIFBciWEnKml+O1zB0XUjpz0TDkaSjBYy/q5zAsxxBFIbK6TUhH9QqfVbbKBck9JRiuqbulwwA5ZE5hMYL4xFzxkDX4BhYYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=haSrWbfJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="haSrWbfJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iF1yJvfXi8MdX//kx6bX10SSyqzYXk361GAg0YHAqj4=; b=haSrWbfJO804DpCysI7UO+Ed/V
	+CnSP5FbMJQ6QBKWkJ7RRdL5531967hiWSuVA29cI45gpqHx2bCRBUCbkFqzOI88Eih16plx+zWYf
	bhBvrY6/Xd7w6kQr5SuWn6KOV0hHzUAOrF3g73aeo+Q/hkxapIaGXvSdEfWtubSXfySeWEK9PmXD9
	RZshh8OALyplqt1hu/WWb8JT5D3mJTH3jXcJRlxj0RAlilTqdtsPB3hqyVc5BS1MaAbP5IhfL5hKl
	ppKCmGdU6z96/IyTww7zNwTNtju1KPEtF0auAgwb1pg1HfYGg9zyOTnbvX/vpUYwowOfRLP9i1VH7
	+SOUR5MA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMaz-000000053rE-16m8;
	Wed, 26 Feb 2025 18:57:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/44] xfs: support reserved blocks for the rt extent counter
Date: Wed, 26 Feb 2025 10:56:35 -0800
Message-ID: <20250226185723.518867-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The zoned space allocator will need reserved RT extents for garbage
collection and zeroing of partial blocks.  Move the resblks related
fields into the freecounter array so that they can be used for all
counters.

Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/fscounters.c |  2 +-
 fs/xfs/xfs_fsops.c        | 25 ++++++++------
 fs/xfs/xfs_fsops.h        |  3 +-
 fs/xfs/xfs_ioctl.c        |  6 ++--
 fs/xfs/xfs_mount.c        | 70 ++++++++++++++++++++++-----------------
 fs/xfs/xfs_mount.h        | 15 ++++++---
 fs/xfs/xfs_super.c        | 32 +++++++++++-------
 7 files changed, 91 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 207a238de429..9dd893ece188 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -350,7 +350,7 @@ xchk_fscount_aggregate_agcounts(
 	 * The global incore space reservation is taken from the incore
 	 * counters, so leave that out of the computation.
 	 */
-	fsc->fdblocks -= mp->m_resblks_avail;
+	fsc->fdblocks -= mp->m_free[XC_FREE_BLOCKS].res_avail;
 
 	/*
 	 * Delayed allocation reservations are taken out of the incore counters
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 58249f37a7ad..f055aebe4c7a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -366,6 +366,7 @@ xfs_growfs_log(
 int
 xfs_reserve_blocks(
 	struct xfs_mount	*mp,
+	enum xfs_free_counter	ctr,
 	uint64_t		request)
 {
 	int64_t			lcounter, delta;
@@ -373,6 +374,8 @@ xfs_reserve_blocks(
 	int64_t			free;
 	int			error = 0;
 
+	ASSERT(ctr < XC_FREE_NR);
+
 	/*
 	 * With per-cpu counters, this becomes an interesting problem. we need
 	 * to work out if we are freeing or allocation blocks first, then we can
@@ -391,16 +394,16 @@ xfs_reserve_blocks(
 	 * counters directly since we shouldn't have any problems unreserving
 	 * space.
 	 */
-	if (mp->m_resblks > request) {
-		lcounter = mp->m_resblks_avail - request;
+	if (mp->m_free[ctr].res_total > request) {
+		lcounter = mp->m_free[ctr].res_avail - request;
 		if (lcounter > 0) {		/* release unused blocks */
 			fdblks_delta = lcounter;
-			mp->m_resblks_avail -= lcounter;
+			mp->m_free[ctr].res_avail -= lcounter;
 		}
-		mp->m_resblks = request;
+		mp->m_free[ctr].res_total = request;
 		if (fdblks_delta) {
 			spin_unlock(&mp->m_sb_lock);
-			xfs_add_fdblocks(mp, fdblks_delta);
+			xfs_add_freecounter(mp, ctr, fdblks_delta);
 			spin_lock(&mp->m_sb_lock);
 		}
 
@@ -419,10 +422,10 @@ xfs_reserve_blocks(
 	 * space to fill it because mod_fdblocks will refill an undersized
 	 * reserve when it can.
 	 */
-	free = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS) -
-		xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS);
-	delta = request - mp->m_resblks;
-	mp->m_resblks = request;
+	free = xfs_sum_freecounter_raw(mp, ctr) -
+		xfs_freecounter_unavailable(mp, ctr);
+	delta = request - mp->m_free[ctr].res_total;
+	mp->m_free[ctr].res_total = request;
 	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
@@ -436,9 +439,9 @@ xfs_reserve_blocks(
 		 */
 		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
-		error = xfs_dec_fdblocks(mp, fdblks_delta, 0);
+		error = xfs_dec_freecounter(mp, ctr, fdblks_delta, 0);
 		if (!error)
-			xfs_add_fdblocks(mp, fdblks_delta);
+			xfs_add_freecounter(mp, ctr, fdblks_delta);
 		spin_lock(&mp->m_sb_lock);
 	}
 out:
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 3e2f73bcf831..9d23c361ef56 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -8,7 +8,8 @@
 
 int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
 int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
-int xfs_reserve_blocks(struct xfs_mount *mp, uint64_t request);
+int xfs_reserve_blocks(struct xfs_mount *mp, enum xfs_free_counter cnt,
+		uint64_t request);
 int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
 
 int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0418aad2db91..d250f7f74e3b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1131,15 +1131,15 @@ xfs_ioctl_getset_resblocks(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_reserve_blocks(mp, fsop.resblks);
+		error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS, fsop.resblks);
 		mnt_drop_write_file(filp);
 		if (error)
 			return error;
 	}
 
 	spin_lock(&mp->m_sb_lock);
-	fsop.resblks = mp->m_resblks;
-	fsop.resblks_avail = mp->m_resblks_avail;
+	fsop.resblks = mp->m_free[XC_FREE_BLOCKS].res_total;
+	fsop.resblks_avail = mp->m_free[XC_FREE_BLOCKS].res_avail;
 	spin_unlock(&mp->m_sb_lock);
 
 	if (copy_to_user(arg, &fsop, sizeof(fsop)))
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ee97a927bc3b..097e7315ba66 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -464,11 +464,21 @@ xfs_mount_reset_sbqflags(
 	return xfs_sync_sb(mp, false);
 }
 
+static const char *const xfs_free_pool_name[] = {
+	[XC_FREE_BLOCKS]	= "free blocks",
+	[XC_FREE_RTEXTENTS]	= "free rt extents",
+};
+
 uint64_t
-xfs_default_resblks(xfs_mount_t *mp)
+xfs_default_resblks(
+	struct xfs_mount	*mp,
+	enum xfs_free_counter	ctr)
 {
 	uint64_t resblks;
 
+	if (ctr == XC_FREE_RTEXTENTS)
+		return 0;
+
 	/*
 	 * We default to 5% or 8192 fsbs of space reserved, whichever is
 	 * smaller.  This is intended to cover concurrent allocation
@@ -681,6 +691,7 @@ xfs_mountfs(
 	uint			quotamount = 0;
 	uint			quotaflags = 0;
 	int			error = 0;
+	int			i;
 
 	xfs_sb_mount_common(mp, sbp);
 
@@ -1049,17 +1060,21 @@ xfs_mountfs(
 	 * privileged transactions. This is needed so that transaction
 	 * space required for critical operations can dip into this pool
 	 * when at ENOSPC. This is needed for operations like create with
-	 * attr, unwritten extent conversion at ENOSPC, etc. Data allocations
-	 * are not allowed to use this reserved space.
+	 * attr, unwritten extent conversion at ENOSPC, garbage collection
+	 * etc. Data allocations are not allowed to use this reserved space.
 	 *
 	 * This may drive us straight to ENOSPC on mount, but that implies
 	 * we were already there on the last unmount. Warn if this occurs.
 	 */
 	if (!xfs_is_readonly(mp)) {
-		error = xfs_reserve_blocks(mp, xfs_default_resblks(mp));
-		if (error)
-			xfs_warn(mp,
-	"Unable to allocate reserve blocks. Continuing without reserve pool.");
+		for (i = 0; i < XC_FREE_NR; i++) {
+			error = xfs_reserve_blocks(mp, i,
+					xfs_default_resblks(mp, i));
+			if (error)
+				xfs_warn(mp,
+"Unable to allocate reserve blocks. Continuing without reserve pool for %s.",
+					xfs_free_pool_name[i]);
+		}
 
 		/* Reserve AG blocks for future btree expansion. */
 		error = xfs_fs_reserve_ag_blocks(mp);
@@ -1176,7 +1191,7 @@ xfs_unmountfs(
 	 * we only every apply deltas to the superblock and hence the incore
 	 * value does not matter....
 	 */
-	error = xfs_reserve_blocks(mp, 0);
+	error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS, 0);
 	if (error)
 		xfs_warn(mp, "Unable to free reserved block pool. "
 				"Freespace may not be correct on next mount.");
@@ -1247,26 +1262,26 @@ xfs_add_freecounter(
 	enum xfs_free_counter	ctr,
 	uint64_t		delta)
 {
-	bool			has_resv_pool = (ctr == XC_FREE_BLOCKS);
+	struct xfs_freecounter	*counter = &mp->m_free[ctr];
 	uint64_t		res_used;
 
 	/*
 	 * If the reserve pool is depleted, put blocks back into it first.
 	 * Most of the time the pool is full.
 	 */
-	if (!has_resv_pool || mp->m_resblks == mp->m_resblks_avail) {
-		percpu_counter_add(&mp->m_free[ctr].count, delta);
+	if (likely(counter->res_avail == counter->res_total)) {
+		percpu_counter_add(&counter->count, delta);
 		return;
 	}
 
 	spin_lock(&mp->m_sb_lock);
-	res_used = mp->m_resblks - mp->m_resblks_avail;
+	res_used = counter->res_total - counter->res_avail;
 	if (res_used > delta) {
-		mp->m_resblks_avail += delta;
+		counter->res_avail += delta;
 	} else {
 		delta -= res_used;
-		mp->m_resblks_avail = mp->m_resblks;
-		percpu_counter_add(&mp->m_free[ctr].count, delta);
+		counter->res_avail = counter->res_total;
+		percpu_counter_add(&counter->count, delta);
 	}
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -1280,15 +1295,10 @@ xfs_dec_freecounter(
 	uint64_t		delta,
 	bool			rsvd)
 {
-	struct percpu_counter	*counter = &mp->m_free[ctr].count;
-	uint64_t		set_aside = 0;
+	struct xfs_freecounter	*counter = &mp->m_free[ctr];
 	s32			batch;
-	bool			has_resv_pool;
 
 	ASSERT(ctr < XC_FREE_NR);
-	has_resv_pool = (ctr == XC_FREE_BLOCKS);
-	if (rsvd)
-		ASSERT(has_resv_pool);
 
 	/*
 	 * Taking blocks away, need to be more accurate the closer we
@@ -1298,7 +1308,7 @@ xfs_dec_freecounter(
 	 * then make everything serialise as we are real close to
 	 * ENOSPC.
 	 */
-	if (__percpu_counter_compare(counter, 2 * XFS_FDBLOCKS_BATCH,
+	if (__percpu_counter_compare(&counter->count, 2 * XFS_FDBLOCKS_BATCH,
 				     XFS_FDBLOCKS_BATCH) < 0)
 		batch = 1;
 	else
@@ -1315,25 +1325,25 @@ xfs_dec_freecounter(
 	 * problems (i.e. transaction abort, pagecache discards, etc.) than
 	 * slightly premature -ENOSPC.
 	 */
-	if (has_resv_pool)
-		set_aside = xfs_freecounter_unavailable(mp, ctr);
-	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
-	if (__percpu_counter_compare(counter, set_aside,
+	percpu_counter_add_batch(&counter->count, -((int64_t)delta), batch);
+	if (__percpu_counter_compare(&counter->count,
+			xfs_freecounter_unavailable(mp, ctr),
 			XFS_FDBLOCKS_BATCH) < 0) {
 		/*
 		 * Lock up the sb for dipping into reserves before releasing the
 		 * space that took us to ENOSPC.
 		 */
 		spin_lock(&mp->m_sb_lock);
-		percpu_counter_add(counter, delta);
+		percpu_counter_add(&counter->count, delta);
 		if (!rsvd)
 			goto fdblocks_enospc;
-		if (delta > mp->m_resblks_avail) {
-			xfs_warn_once(mp,
+		if (delta > counter->res_avail) {
+			if (ctr == XC_FREE_BLOCKS)
+				xfs_warn_once(mp,
 "Reserve blocks depleted! Consider increasing reserve pool size.");
 			goto fdblocks_enospc;
 		}
-		mp->m_resblks_avail -= delta;
+		counter->res_avail -= delta;
 		spin_unlock(&mp->m_sb_lock);
 	}
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7f3265d669bc..579eaf09157d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -108,6 +108,15 @@ struct xfs_groups {
 struct xfs_freecounter {
 	/* free blocks for general use: */
 	struct percpu_counter	count;
+
+	/* total reserved blocks: */
+	uint64_t		res_total;
+
+	/* available reserved blocks: */
+	uint64_t		res_avail;
+
+	/* reserved blks @ remount,ro: */
+	uint64_t		res_saved;
 };
 
 /*
@@ -250,9 +259,6 @@ typedef struct xfs_mount {
 	atomic64_t		m_allocbt_blks;
 
 	struct xfs_groups	m_groups[XG_TYPE_MAX];
-	uint64_t		m_resblks;	/* total reserved blocks */
-	uint64_t		m_resblks_avail;/* available reserved blocks */
-	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct dentry		*m_debugfs;	/* debugfs parent */
 	struct xfs_kobj		m_kobj;
@@ -638,7 +644,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 }
 
 extern void	xfs_uuid_table_free(void);
-extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
+uint64_t	xfs_default_resblks(struct xfs_mount *mp,
+			enum xfs_free_counter ctr);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b08d28a895cb..366837e71eeb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -924,24 +924,32 @@ xfs_fs_statfs(
 }
 
 STATIC void
-xfs_save_resvblks(struct xfs_mount *mp)
+xfs_save_resvblks(
+	struct xfs_mount	*mp)
 {
-	mp->m_resblks_save = mp->m_resblks;
-	xfs_reserve_blocks(mp, 0);
+	enum xfs_free_counter	i;
+
+	for (i = 0; i < XC_FREE_NR; i++) {
+		mp->m_free[i].res_saved = mp->m_free[i].res_total;
+		xfs_reserve_blocks(mp, i, 0);
+	}
 }
 
 STATIC void
-xfs_restore_resvblks(struct xfs_mount *mp)
+xfs_restore_resvblks(
+	struct xfs_mount	*mp)
 {
-	uint64_t resblks;
-
-	if (mp->m_resblks_save) {
-		resblks = mp->m_resblks_save;
-		mp->m_resblks_save = 0;
-	} else
-		resblks = xfs_default_resblks(mp);
+	uint64_t		resblks;
+	enum xfs_free_counter	i;
 
-	xfs_reserve_blocks(mp, resblks);
+	for (i = 0; i < XC_FREE_NR; i++) {
+		if (mp->m_free[i].res_saved) {
+			resblks = mp->m_free[i].res_saved;
+			mp->m_free[i].res_saved = 0;
+		} else
+			resblks = xfs_default_resblks(mp, i);
+		xfs_reserve_blocks(mp, i, resblks);
+	}
 }
 
 /*
-- 
2.45.2

