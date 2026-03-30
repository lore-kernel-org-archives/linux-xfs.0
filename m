Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4521EE7C6
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849578; cv=none; b=NCjC7DQ+Qa9cJOTv3V8d/5etlIouvDbJtTsHl+sEPG+4nA9qVXVWfLQph8qbIW7QG0KhAU7OoYh66Gj18QBXzyy2TaaZ9GoG6Y7lvIyLp2LS1yOV8bnnjGbeSvBNmu8EKc+aRMyo0gLz3TFB6zGLt0Q237/zYjGfpOF73kiRmTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849578; c=relaxed/simple;
	bh=c/GzFCg16/z1DPCbI+D89ZSD903857VsQhQ6apO88wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWBHo/yXrYxrzb/JQAvFBmztflrKsNH0hk+h+aUKVx0j8JLUAEr1KwzisWhrzUhfXgsR/X1c9ssoVJ0LwU8NSWD0p3Av+5fY4XP/9GVoAlEeOLyTs6wt+2rT1zQYUz/Tf+QgjnipAIMXMhOza+5h1znT3GqpxhsBxQ2ZBKMwlzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jCVx5J97; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jCVx5J97"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oxvYa5oNznPe7kx0ypBnpubkzj1GWGLh2e9LJGajlSQ=; b=jCVx5J97a+NSfBQcwKQNFvq4yV
	hSfTk4TzamsOCdnln7bPcujWoHwGfKJHC7Rw9XAZMDBkzCAZ2rfWZ/+Lz9C+2FwBXqz8Za+V3ZbKK
	PyhfLHRGxO03gsZCZwci9+P/m8tOprloCwA3B9Q89kj2TPnAx9VEPWZ9AlRNm9w6/joWR42n6KnYZ
	mWudXxqNBT6YmNIVnUADfm1ui6JAGMsTton6O62L37feXXJ1kd4FVAFJ2jybbmdI3kHAAnw/tGDOT
	r0vz/2sUtFG908xPffCfPWkk6k11VS55ETVMn92D8xSm8vyAfy6YpsygA66ucU59pMRu0Zs2ZaKry
	jAXDQ5Nw==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75S4-0000000AeX7-2EsJ;
	Mon, 30 Mar 2026 05:46:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: reduce special casing for the open GC zone
Date: Mon, 30 Mar 2026 07:44:17 +0200
Message-ID: <20260330054533.3856339-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330054533.3856339-1-hch@lst.de>
References: <20260330054533.3856339-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the open zone used for garbage collection is a special snow
flake, and it that has been a bit annoying for some further zoned XFS
work I've been doing.

Remove the zi_open_gc_field and instead track the open GC zone in the
zi_open_zones list together with the normal open zones, and keep an extra
pointer and a reference of in the GC thread's data structure.  This means
anything iterating over open zones just has to look at zi_open_zones, and
the life time rules are consistent.  It also helps to add support for
multiple open GC zones if we ever need them, and removes a bit of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 19 +++++++----
 fs/xfs/xfs_zone_gc.c    | 71 ++++++++++++++++++++++-------------------
 fs/xfs/xfs_zone_info.c  | 12 +++----
 fs/xfs/xfs_zone_priv.h  | 15 ++-------
 4 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 297a918bf28e..db27fdb3a7d3 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -174,16 +174,18 @@ xfs_open_zone_mark_full(
 	WRITE_ONCE(rtg->rtg_open_zone, NULL);
 
 	spin_lock(&zi->zi_open_zones_lock);
-	if (oz->oz_is_gc) {
-		ASSERT(current == zi->zi_gc_thread);
-		zi->zi_open_gc_zone = NULL;
-	} else {
+	if (oz->oz_is_gc)
+		zi->zi_nr_open_gc_zones--;
+	else
 		zi->zi_nr_open_zones--;
-		list_del_init(&oz->oz_entry);
-	}
+	list_del_init(&oz->oz_entry);
 	spin_unlock(&zi->zi_open_zones_lock);
 
-	wake_up_all(&zi->zi_zone_wait);
+	if (oz->oz_is_gc)
+		wake_up_process(zi->zi_gc_thread);
+	else
+		wake_up_all(&zi->zi_zone_wait);
+
 	if (used < rtg_blocks(rtg))
 		xfs_zone_account_reclaimable(rtg, rtg_blocks(rtg) - used);
 	xfs_open_zone_put(oz);
@@ -557,6 +559,9 @@ xfs_try_use_zone(
 	struct xfs_open_zone	*oz,
 	unsigned int		goodness)
 {
+	if (oz->oz_is_gc)
+		return false;
+
 	if (oz->oz_allocated == rtg_blocks(oz->oz_rtg))
 		return false;
 
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 24f20f99ae1a..8c184127b351 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -125,6 +125,7 @@ struct xfs_zone_gc_iter {
  */
 struct xfs_zone_gc_data {
 	struct xfs_mount		*mp;
+	struct xfs_open_zone		*oz;
 
 	/* bioset used to allocate the gc_bios */
 	struct bio_set			bio_set;
@@ -525,9 +526,10 @@ xfs_zone_gc_select_victim(
 }
 
 static int
-xfs_zone_gc_steal_open(
-	struct xfs_zone_info	*zi)
+xfs_zone_gc_steal_open_zone(
+	struct xfs_zone_gc_data	*data)
 {
+	struct xfs_zone_info	*zi = data->mp->m_zone_info;
 	struct xfs_open_zone	*oz, *found = NULL;
 
 	spin_lock(&zi->zi_open_zones_lock);
@@ -542,10 +544,12 @@ xfs_zone_gc_steal_open(
 
 	trace_xfs_zone_gc_target_stolen(found->oz_rtg);
 	found->oz_is_gc = true;
-	list_del_init(&found->oz_entry);
 	zi->zi_nr_open_zones--;
-	zi->zi_open_gc_zone = found;
+	zi->zi_nr_open_gc_zones++;
 	spin_unlock(&zi->zi_open_zones_lock);
+
+	atomic_inc(&found->oz_ref);
+	data->oz = found;
 	return 0;
 }
 
@@ -554,39 +558,43 @@ xfs_zone_gc_steal_open(
  */
 static bool
 xfs_zone_gc_select_target(
-	struct xfs_mount	*mp)
+	struct xfs_zone_gc_data	*data)
 {
-	struct xfs_zone_info	*zi = mp->m_zone_info;
-	struct xfs_open_zone	*oz = zi->zi_open_gc_zone;
+	struct xfs_zone_info	*zi = data->mp->m_zone_info;
 
-	if (oz) {
+	if (data->oz) {
 		/*
 		 * If we have space available, just keep using the existing
 		 * zone.
 		 */
-		if (oz->oz_allocated < rtg_blocks(oz->oz_rtg))
+		if (data->oz->oz_allocated < rtg_blocks(data->oz->oz_rtg))
 			return true;
 
 		/*
 		 * Wait for all writes to the current zone to finish before
 		 * picking a new one.
 		 */
-		if (oz->oz_written < rtg_blocks(oz->oz_rtg))
+		if (data->oz->oz_written < rtg_blocks(data->oz->oz_rtg))
 			return false;
+
+		xfs_open_zone_put(data->oz);
 	}
 
 	/*
 	 * Open a new zone when there is none currently in use.
 	 */
 	ASSERT(zi->zi_nr_open_zones <=
-		mp->m_max_open_zones - XFS_OPEN_GC_ZONES);
-	oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
-	if (oz)
-		trace_xfs_zone_gc_target_opened(oz->oz_rtg);
+		data->mp->m_max_open_zones - XFS_OPEN_GC_ZONES);
+	data->oz = xfs_open_zone(data->mp, WRITE_LIFE_NOT_SET, true);
+	if (!data->oz)
+		return false;
+	trace_xfs_zone_gc_target_opened(data->oz->oz_rtg);
+	atomic_inc(&data->oz->oz_ref);
 	spin_lock(&zi->zi_open_zones_lock);
-	zi->zi_open_gc_zone = oz;
+	zi->zi_nr_open_gc_zones++;
+	list_add_tail(&data->oz->oz_entry, &zi->zi_open_zones);
 	spin_unlock(&zi->zi_open_zones_lock);
-	return !!oz;
+	return true;
 }
 
 static void
@@ -609,7 +617,7 @@ xfs_zone_gc_alloc_blocks(
 	bool			*is_seq)
 {
 	struct xfs_mount	*mp = data->mp;
-	struct xfs_open_zone	*oz = mp->m_zone_info->zi_open_gc_zone;
+	struct xfs_open_zone	*oz = data->oz;
 
 	*count_fsb = min(*count_fsb, XFS_B_TO_FSB(mp, data->scratch_available));
 
@@ -683,7 +691,7 @@ xfs_zone_gc_can_start_chunk(
 			return false;
 	}
 
-	return xfs_zone_gc_select_target(data->mp);
+	return xfs_zone_gc_select_target(data);
 }
 
 static bool
@@ -728,7 +736,7 @@ xfs_zone_gc_start_chunk(
 	chunk->new_daddr = daddr;
 	chunk->is_seq = is_seq;
 	chunk->data = data;
-	chunk->oz = mp->m_zone_info->zi_open_gc_zone;
+	chunk->oz = data->oz;
 	chunk->victim_rtg = iter->victim_rtg;
 	atomic_inc(&rtg_group(chunk->victim_rtg)->xg_active_ref);
 	atomic_inc(&chunk->victim_rtg->rtg_gccount);
@@ -1134,6 +1142,8 @@ xfs_zoned_gcd(
 	}
 	xfs_clear_zonegc_running(mp);
 
+	if (data->oz)
+		xfs_open_zone_put(data->oz);
 	if (data->iter.victim_rtg)
 		xfs_rtgroup_rele(data->iter.victim_rtg);
 
@@ -1166,6 +1176,10 @@ xfs_zone_gc_mount(
 	struct xfs_zone_gc_data	*data;
 	int			error;
 
+	data = xfs_zone_gc_data_alloc(mp);
+	if (!data)
+		return -ENOMEM;
+
 	/*
 	 * If there are no free zones available for GC, or the number of open
 	 * zones has reached the open zone limit, pick the open zone with
@@ -1175,35 +1189,30 @@ xfs_zone_gc_mount(
 	 */
 	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE) ||
 	    zi->zi_nr_open_zones >= mp->m_max_open_zones) {
-		error = xfs_zone_gc_steal_open(zi);
+		error = xfs_zone_gc_steal_open_zone(data);
 		if (error) {
 			xfs_warn(mp, "unable to steal an open zone for gc");
-			return error;
+			goto out_free_gc_data;
 		}
 	}
 
-	data = xfs_zone_gc_data_alloc(mp);
-	if (!data) {
-		error = -ENOMEM;
-		goto out_put_gc_zone;
-	}
-
 	zi->zi_gc_thread = kthread_create(xfs_zoned_gcd, data,
 			"xfs-zone-gc/%s", mp->m_super->s_id);
 	if (IS_ERR(zi->zi_gc_thread)) {
 		xfs_warn(mp, "unable to create zone gc thread");
 		error = PTR_ERR(zi->zi_gc_thread);
-		goto out_free_gc_data;
+		goto out_put_oz;
 	}
 
 	/* xfs_zone_gc_start will unpark for rw mounts */
 	kthread_park(zi->zi_gc_thread);
 	return 0;
 
+out_put_oz:
+	if (data->oz)
+		xfs_open_zone_put(data->oz);
 out_free_gc_data:
 	kfree(data);
-out_put_gc_zone:
-	xfs_open_zone_put(zi->zi_open_gc_zone);
 	return error;
 }
 
@@ -1214,6 +1223,4 @@ xfs_zone_gc_unmount(
 	struct xfs_zone_info	*zi = mp->m_zone_info;
 
 	kthread_stop(zi->zi_gc_thread);
-	if (zi->zi_open_gc_zone)
-		xfs_open_zone_put(zi->zi_open_gc_zone);
 }
diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index 8e56181021b3..47b475e21af8 100644
--- a/fs/xfs/xfs_zone_info.c
+++ b/fs/xfs/xfs_zone_info.c
@@ -30,11 +30,12 @@ xfs_show_open_zone(
 	struct seq_file		*m,
 	struct xfs_open_zone	*oz)
 {
-	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s\n",
+	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s %s\n",
 		rtg_rgno(oz->oz_rtg),
 		oz->oz_allocated, oz->oz_written,
 		rtg_rmap(oz->oz_rtg)->i_used_blocks,
-		xfs_write_hint_to_str(oz->oz_write_hint));
+		xfs_write_hint_to_str(oz->oz_write_hint),
+		oz->oz_is_gc ? "(GC)" : "");
 }
 
 static void
@@ -58,9 +59,8 @@ xfs_show_full_zone_used_distribution(
 	spin_unlock(&zi->zi_used_buckets_lock);
 
 	full = mp->m_sb.sb_rgcount;
-	if (zi->zi_open_gc_zone)
-		full--;
 	full -= zi->zi_nr_open_zones;
+	full -= zi->zi_nr_open_gc_zones;
 	full -= atomic_read(&zi->zi_nr_free_zones);
 	full -= reclaimable;
 
@@ -104,10 +104,6 @@ xfs_zoned_show_stats(
 	seq_puts(m, "\topen zones:\n");
 	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
 		xfs_show_open_zone(m, oz);
-	if (zi->zi_open_gc_zone) {
-		seq_puts(m, "\topen gc zone:\n");
-		xfs_show_open_zone(m, zi->zi_open_gc_zone);
-	}
 	spin_unlock(&zi->zi_open_zones_lock);
 	seq_puts(m, "\tused blocks distribution (fully written zones):\n");
 	xfs_show_full_zone_used_distribution(m, mp);
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index 8fbf9a52964e..fcb57506d8e6 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -32,11 +32,7 @@ struct xfs_open_zone {
 	 */
 	enum rw_hint		oz_write_hint;
 
-	/*
-	 * Is this open zone used for garbage collection?  There can only be a
-	 * single open GC zone, which is pointed to by zi_open_gc_zone in
-	 * struct xfs_zone_info.  Constant over the life time of an open zone.
-	 */
+	/* Is this open zone used for garbage collection? */
 	bool			oz_is_gc;
 
 	/*
@@ -68,6 +64,7 @@ struct xfs_zone_info {
 	spinlock_t		zi_open_zones_lock;
 	struct list_head	zi_open_zones;
 	unsigned int		zi_nr_open_zones;
+	unsigned int		zi_nr_open_gc_zones;
 
 	/*
 	 * Free zone search cursor and number of free zones:
@@ -81,15 +78,9 @@ struct xfs_zone_info {
 	wait_queue_head_t	zi_zone_wait;
 
 	/*
-	 * Pointer to the GC thread, and the current open zone used by GC
-	 * (if any).
-	 *
-	 * zi_open_gc_zone is mostly private to the GC thread, but can be read
-	 * for debugging from other threads, in which case zi_open_zones_lock
-	 * must be taken to access it.
+	 * Pointer to the GC thread.
 	 */
 	struct task_struct      *zi_gc_thread;
-	struct xfs_open_zone	*zi_open_gc_zone;
 
 	/*
 	 * List of zones that need a reset:
-- 
2.47.3

