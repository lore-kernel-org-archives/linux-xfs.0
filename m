Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AB125393B
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 03:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760673137; cv=none; b=QU4mM2qt80i6k70qfBsVwXiuMRWq7YnFYZ//5CUjiEaWBE6cp4DDe4qjebvHSRPKGVylu2KHBeRTewYDO7NV9oRO+n0ozyXhx+iiTZKrbsLtJk4AS1rH+p5unz4KvdxxHbelTn8DpGQbPTD+RLsWpfgkPAPiqlPlowYg8gYNv9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760673137; c=relaxed/simple;
	bh=NN3HJGGcynnqzMkV2YIWCH3LbyYjdrW7tcRmH8YuNd8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dFi7lzSugp6ZvL3ALZtnsOtPna05jOshwKFay1M9lfemq2RUg7I9xNHVrL7nGPK/aZ83QshxE8P3Ag8omzN+9bu0wPVUQgDl75K1Drsb8xkap1F6WLGqSqdpYRwQsdXKVLw+CVm28EHWfgK7gyyTpBJ03L6FDGkgZ18C561PWaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CJGD1S5X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CJGD1S5X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=13VlzSEyfpuUBvUJ+/icYgg7dSmhyeTsUxx2XH/NrUs=; b=CJGD1S5XfrohBks6cJtpZ6OwKl
	4sO32HbYTtLQlpZtVxN0QEt6bkglRc4pkXFETf03z25bySOB4tKHJ9VNww+O2kqcSIBshVRhZAQM9
	kjyqm7b4q1BU1bhN+1tbmvkUMmEZ/LCp27ls0MsNLdZeqOmhlbKgeFpJyID9eBYtdilyldlEDXvnN
	RnO3pi5Cv8TPBSpMIvNH3Fdi4V1PyZaFkL1loOO9oN4hlDfiOG8SJfdoMjnbjKUSBr2Ld6Co7uKCd
	BqhsoBs5UMEtUEJHZqDryhPScq2uKfl4fvvERlbp3otaLoiqdc1ONNKkhRextRyQFtVIZhm+1L5X+
	N2gD5Ibw==;
Received: from 5-226-109-134.static.ip.netia.com.pl ([5.226.109.134] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bVn-00000006UCZ-0uc0;
	Fri, 17 Oct 2025 03:52:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: cache open zone in inode->i_private
Date: Fri, 17 Oct 2025 05:51:47 +0200
Message-ID: <20251017035212.651929-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The MRU cache for open zones is unfortunately still not ideal, as it can
time out pretty easily when doing heavy I/O to hard disks using up most
or all open zones.  One option would be to just increase the timeout,
but while looking into that I realized we're just better off caching it
indefinitely as there is no real downside to that once we don't hold a
reference to the cache open zone.

So switch the open zone to RCU freeing, and then stash the last used
open zone into inode->i_private.  This helps to significantly reduce
fragmentation by keeping I/O localized to zones for workloads that
write using many open files to HDD.

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Changes since v1:
 - keep the is_gc assert and update the comment for it

 fs/xfs/xfs_mount.h      |   1 -
 fs/xfs/xfs_super.c      |   6 ++
 fs/xfs/xfs_zone_alloc.c | 123 +++++++++++++---------------------------
 fs/xfs/xfs_zone_priv.h  |   2 +
 4 files changed, 46 insertions(+), 86 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f046d1215b04..b871dfde372b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -236,7 +236,6 @@ typedef struct xfs_mount {
 	bool			m_update_sb;	/* sb needs update in mount */
 	unsigned int		m_max_open_zones;
 	unsigned int		m_zonegc_low_space;
-	struct xfs_mru_cache	*m_zone_cache;  /* Inode to open zone cache */
 
 	/* max_atomic_write mount option value */
 	unsigned long long	m_awu_max_bytes;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e85a156dc17d..464ae1e657d9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -786,6 +786,12 @@ xfs_fs_evict_inode(
 
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
+
+	if (IS_ENABLED(CONFIG_XFS_RT) &&
+	    S_ISREG(inode->i_mode) && inode->i_private) {
+		xfs_open_zone_put(inode->i_private);
+		inode->i_private = NULL;
+	}
 }
 
 static void
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index c342595acc3e..e4b2aadaf765 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -26,14 +26,22 @@
 #include "xfs_trace.h"
 #include "xfs_mru_cache.h"
 
+static void
+xfs_open_zone_free_rcu(
+	struct callback_head	*cb)
+{
+	struct xfs_open_zone	*oz = container_of(cb, typeof(*oz), oz_rcu);
+
+	xfs_rtgroup_rele(oz->oz_rtg);
+	kfree(oz);
+}
+
 void
 xfs_open_zone_put(
 	struct xfs_open_zone	*oz)
 {
-	if (atomic_dec_and_test(&oz->oz_ref)) {
-		xfs_rtgroup_rele(oz->oz_rtg);
-		kfree(oz);
-	}
+	if (atomic_dec_and_test(&oz->oz_ref))
+		call_rcu(&oz->oz_rcu, xfs_open_zone_free_rcu);
 }
 
 static inline uint32_t
@@ -745,98 +753,47 @@ xfs_mark_rtg_boundary(
 		ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
 }
 
-/*
- * Cache the last zone written to for an inode so that it is considered first
- * for subsequent writes.
- */
-struct xfs_zone_cache_item {
-	struct xfs_mru_cache_elem	mru;
-	struct xfs_open_zone		*oz;
-};
-
-static inline struct xfs_zone_cache_item *
-xfs_zone_cache_item(struct xfs_mru_cache_elem *mru)
-{
-	return container_of(mru, struct xfs_zone_cache_item, mru);
-}
-
-static void
-xfs_zone_cache_free_func(
-	void				*data,
-	struct xfs_mru_cache_elem	*mru)
-{
-	struct xfs_zone_cache_item	*item = xfs_zone_cache_item(mru);
-
-	xfs_open_zone_put(item->oz);
-	kfree(item);
-}
-
 /*
  * Check if we have a cached last open zone available for the inode and
  * if yes return a reference to it.
  */
 static struct xfs_open_zone *
-xfs_cached_zone(
-	struct xfs_mount		*mp,
-	struct xfs_inode		*ip)
+xfs_get_cached_zone(
+	struct xfs_inode	*ip)
 {
-	struct xfs_mru_cache_elem	*mru;
-	struct xfs_open_zone		*oz;
+	struct xfs_open_zone	*oz;
 
-	mru = xfs_mru_cache_lookup(mp->m_zone_cache, ip->i_ino);
-	if (!mru)
-		return NULL;
-	oz = xfs_zone_cache_item(mru)->oz;
+	rcu_read_lock();
+	oz = VFS_I(ip)->i_private;
 	if (oz) {
 		/*
 		 * GC only steals open zones at mount time, so no GC zones
 		 * should end up in the cache.
 		 */
 		ASSERT(!oz->oz_is_gc);
-		ASSERT(atomic_read(&oz->oz_ref) > 0);
-		atomic_inc(&oz->oz_ref);
+		if (!atomic_inc_not_zero(&oz->oz_ref))
+			oz = NULL;
 	}
-	xfs_mru_cache_done(mp->m_zone_cache);
+	rcu_read_unlock();
+
 	return oz;
 }
 
 /*
- * Update the last used zone cache for a given inode.
- *
- * The caller must have a reference on the open zone.
+ * Try to stash our zone in the inode so that is is reused for future
+ * allocations.
  */
 static void
-xfs_zone_cache_create_association(
-	struct xfs_inode		*ip,
-	struct xfs_open_zone		*oz)
+xfs_set_cached_zone(
+	struct xfs_inode	*ip,
+	struct xfs_open_zone	*oz)
 {
-	struct xfs_mount		*mp = ip->i_mount;
-	struct xfs_zone_cache_item	*item = NULL;
-	struct xfs_mru_cache_elem	*mru;
+	struct xfs_open_zone	*old_oz;
 
-	ASSERT(atomic_read(&oz->oz_ref) > 0);
 	atomic_inc(&oz->oz_ref);
-
-	mru = xfs_mru_cache_lookup(mp->m_zone_cache, ip->i_ino);
-	if (mru) {
-		/*
-		 * If we have an association already, update it to point to the
-		 * new zone.
-		 */
-		item = xfs_zone_cache_item(mru);
-		xfs_open_zone_put(item->oz);
-		item->oz = oz;
-		xfs_mru_cache_done(mp->m_zone_cache);
-		return;
-	}
-
-	item = kmalloc(sizeof(*item), GFP_KERNEL);
-	if (!item) {
-		xfs_open_zone_put(oz);
-		return;
-	}
-	item->oz = oz;
-	xfs_mru_cache_insert(mp->m_zone_cache, ip->i_ino, &item->mru);
+	old_oz = xchg(&VFS_I(ip)->i_private, oz);
+	if (old_oz)
+		xfs_open_zone_put(old_oz);
 }
 
 static void
@@ -880,15 +837,14 @@ xfs_zone_alloc_and_submit(
 	 * the inode is still associated with a zone and use that if so.
 	 */
 	if (!*oz)
-		*oz = xfs_cached_zone(mp, ip);
+		*oz = xfs_get_cached_zone(ip);
 
 	if (!*oz) {
 select_zone:
 		*oz = xfs_select_zone(mp, write_hint, pack_tight);
 		if (!*oz)
 			goto out_error;
-
-		xfs_zone_cache_create_association(ip, *oz);
+		xfs_set_cached_zone(ip, *oz);
 	}
 
 	alloc_len = xfs_zone_alloc_blocks(*oz, XFS_B_TO_FSB(mp, ioend->io_size),
@@ -966,6 +922,12 @@ xfs_free_open_zones(
 		xfs_open_zone_put(oz);
 	}
 	spin_unlock(&zi->zi_open_zones_lock);
+
+	/*
+	 * Wait for all open zones to be freed so that they drop the group
+	 * references:
+	 */
+	rcu_barrier();
 }
 
 struct xfs_init_zones {
@@ -1303,14 +1265,6 @@ xfs_mount_zones(
 	error = xfs_zone_gc_mount(mp);
 	if (error)
 		goto out_free_zone_info;
-
-	/*
-	 * Set up a mru cache to track inode to open zone for data placement
-	 * purposes. The magic values for group count and life time is the
-	 * same as the defaults for file streams, which seems sane enough.
-	 */
-	xfs_mru_cache_create(&mp->m_zone_cache, mp,
-			5000, 10, xfs_zone_cache_free_func);
 	return 0;
 
 out_free_zone_info:
@@ -1324,5 +1278,4 @@ xfs_unmount_zones(
 {
 	xfs_zone_gc_unmount(mp);
 	xfs_free_zone_info(mp->m_zone_info);
-	xfs_mru_cache_destroy(mp->m_zone_cache);
 }
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index 35e6de3d25ed..4322e26dd99a 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -44,6 +44,8 @@ struct xfs_open_zone {
 	 * the life time of an open zone.
 	 */
 	struct xfs_rtgroup	*oz_rtg;
+
+	struct rcu_head		oz_rcu;
 };
 
 /*
-- 
2.47.3

