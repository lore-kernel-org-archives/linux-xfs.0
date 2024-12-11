Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076641F2360
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907517; cv=none; b=Rv7NjK1BeFaQ9qKrc9AOJ5GCXeWf/q9HzfZnocitmSXEIrPhJarXh9DKR7J7dD0gCnsKe48WX6XVo0WHZtAvqD7Rq7eT/C805cF1+fNm5hyc6PJanqLAPgqY7tkgvBC/Wea/B1ABUoLualsJMLMYuTc2t3sXbtTRj+rzOqGP6MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907517; c=relaxed/simple;
	bh=PdtW5JkPVu/OJ14lXeYiDmi8ALAYxMXriU3To9wO07g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwyYqWJ+jEizVdpsZ5cD/Loqi+RyiEG2prE6qraDRfIQNLKPk8K+UPFFa0jY8IGEWRV1v42AjWytdGgXtLQsaemWDCpKDS+Q8a/jVxclYsyq0Kfxz0fYU9iqeGvwnC0kkeGP1K8vKMoGkkjBRvLSoXXzvp9ygC7oWGT2jylKF+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0TSZEeEn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0TSZEeEn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=byYaZUb4hKrTDXu5YpFsZ1mg/3Rh8/ZdjLePDlwxWTo=; b=0TSZEeEn+4goUF//KDFhhTo9wD
	yAR4bg3kkso/SzYJEVzisuddks9vRNDISp9a/BYwOy7NS7SoXe0g/U5iRHHg2JztmmtV5ajC1hODH
	KMVoPkODVoHSej2/9D0eMjXmK/rqzJprnJDheCq5GEaD24aXlBCDXOTQ3dZ9NQ8v49PwLokPPEuMR
	5xlS/HzS5A+TqF9VoiljhSMlE7Jpq6d8prCFeHgl4mCcln+PG+z7O4jhsyuXSOSbIpUFu/6lfc+a+
	hoXCQPoE8BbNf5eigiAt0T2udzfCIdYsGC/xWfUlSP8jvT3V883HPfKMb5vMZlXINvODCzShrb4Dx
	E6LzymEA==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIYF-0000000EJWN-1NzM;
	Wed, 11 Dec 2024 08:58:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 41/43] xfs: support write life time based data placement
Date: Wed, 11 Dec 2024 09:55:06 +0100
Message-ID: <20241211085636.1380516-42-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Hans Holmberg <hans.holmberg@wdc.com>

Add a file write life time data placement allocation scheme that aims to
minimize fragmentation and thereby to do two things:

 a) separate file data to different zones when possible.
 b) colocate file data of similar life times when feasible.

To get best results, average file sizes should align with the zone
capacity that is reported through the XFS_IOC_FSGEOMETRY ioctl.

For RocksDB using leveled compaction, the lifetime hints can improve
throughput for overwrite workloads at 80% file system utilization by
~10%.

Lifetime hints can be disabled using the nolifetime mount option.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.h      |   2 +
 fs/xfs/xfs_super.c      |  10 ++++
 fs/xfs/xfs_zone_alloc.c | 126 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_zone_gc.c    |   2 +-
 fs/xfs/xfs_zone_priv.h  |   9 ++-
 5 files changed, 134 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ec8612c8b71d..748b7a7da407 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -365,6 +365,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
 
 /* Mount features */
+#define XFS_FEAT_NOLIFETIME	(1ULL << 47)	/* disable lifetime hints */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
 #define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
 #define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
@@ -420,6 +421,7 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(zoned, ZONED)
+__XFS_HAS_FEAT(nolifetime, NOLIFETIME)
 
 static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e24f6a608b91..d2f2fa26c487 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -111,6 +111,7 @@ enum {
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
 	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_max_open_zones,
+	Opt_lifetime, Opt_nolifetime,
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
@@ -156,6 +157,8 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("dax",		Opt_dax),
 	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
 	fsparam_u32("max_open_zones",	Opt_max_open_zones),
+	fsparam_flag("lifetime",	Opt_lifetime),
+	fsparam_flag("nolifetime",	Opt_nolifetime),
 	{}
 };
 
@@ -184,6 +187,7 @@ xfs_fs_show_options(
 		{ XFS_FEAT_LARGE_IOSIZE,	",largeio" },
 		{ XFS_FEAT_DAX_ALWAYS,		",dax=always" },
 		{ XFS_FEAT_DAX_NEVER,		",dax=never" },
+		{ XFS_FEAT_NOLIFETIME,		",nolifetime" },
 		{ 0, NULL }
 	};
 	struct xfs_mount	*mp = XFS_M(root->d_sb);
@@ -1463,6 +1467,12 @@ xfs_fs_parse_param(
 	case Opt_max_open_zones:
 		parsing_mp->m_max_open_zones = result.uint_32;
 		return 0;
+	case Opt_lifetime:
+		parsing_mp->m_features &= ~XFS_FEAT_NOLIFETIME;
+		return 0;
+	case Opt_nolifetime:
+		parsing_mp->m_features |= XFS_FEAT_NOLIFETIME;
+		return 0;
 	default:
 		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 291cf39a5989..2f362da0d31c 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -381,6 +381,7 @@ static struct xfs_open_zone *
 xfs_init_open_zone(
 	struct xfs_rtgroup	*rtg,
 	xfs_rgblock_t		write_pointer,
+	enum rw_hint		write_hint,
 	bool			is_gc)
 {
 	struct xfs_open_zone	*oz;
@@ -391,6 +392,7 @@ xfs_init_open_zone(
 	oz->oz_rtg = rtg;
 	oz->oz_write_pointer = write_pointer;
 	oz->oz_written = write_pointer;
+	oz->oz_write_hint = write_hint;
 	oz->oz_is_gc = is_gc;
 
 	/*
@@ -407,6 +409,7 @@ xfs_init_open_zone(
 struct xfs_open_zone *
 xfs_open_zone(
 	struct xfs_mount	*mp,
+	enum rw_hint		write_hint,
 	bool			is_gc)
 {
 	struct xfs_zone_info	*zi = mp->m_zone_info;
@@ -422,7 +425,7 @@ xfs_open_zone(
 	xfs_group_clear_mark(xg, XFS_RTG_FREE);
 	atomic_dec(&zi->zi_nr_free_zones);
 	zi->zi_free_zone_cursor = xg->xg_gno;
-	return xfs_init_open_zone(to_rtg(xg), 0, is_gc);
+	return xfs_init_open_zone(to_rtg(xg), 0, write_hint, is_gc);
 }
 
 /*
@@ -434,7 +437,8 @@ xfs_open_zone(
  */
 static struct xfs_open_zone *
 xfs_activate_zone(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	enum rw_hint		write_hint)
 {
 	struct xfs_zone_info	*zi = mp->m_zone_info;
 	struct xfs_open_zone	*oz;
@@ -443,7 +447,7 @@ xfs_activate_zone(
 	    XFS_GC_ZONES - XFS_OPEN_GC_ZONES)
 		return NULL;
 
-	oz = xfs_open_zone(mp, false);
+	oz = xfs_open_zone(mp, write_hint, false);
 	if (!oz)
 		return NULL;
 
@@ -460,16 +464,78 @@ xfs_activate_zone(
 	return oz;
 }
 
+/*
+ * For data with short or medium lifetime, try to colocated it into an
+ * already open zone with a matching temperature.
+ */
+static bool
+xfs_colocate_eagerly(
+	enum rw_hint		file_hint)
+{
+	switch (file_hint) {
+	case WRITE_LIFE_MEDIUM:
+	case WRITE_LIFE_SHORT:
+	case WRITE_LIFE_NONE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool
+xfs_good_hint_match(
+	struct xfs_open_zone	*oz,
+	enum rw_hint		file_hint)
+{
+	switch (oz->oz_write_hint) {
+	case WRITE_LIFE_LONG:
+	case WRITE_LIFE_EXTREME:
+		/* colocate long and extreme */
+		if (file_hint == WRITE_LIFE_LONG ||
+		    file_hint == WRITE_LIFE_EXTREME)
+			return true;
+		break;
+	case WRITE_LIFE_MEDIUM:
+		/* colocate medium with medium */
+		if (file_hint == WRITE_LIFE_MEDIUM)
+			return true;
+		break;
+	case WRITE_LIFE_SHORT:
+	case WRITE_LIFE_NONE:
+	case WRITE_LIFE_NOT_SET:
+		/* colocate short and none */
+		if (file_hint <= WRITE_LIFE_SHORT)
+			return true;
+		break;
+	}
+	return false;
+}
+
 static bool
 xfs_try_use_zone(
 	struct xfs_zone_info	*zi,
-	struct xfs_open_zone	*oz)
+	enum rw_hint		file_hint,
+	struct xfs_open_zone	*oz,
+	bool			lowspace)
 {
 	if (oz->oz_write_pointer == rtg_blocks(oz->oz_rtg))
 		return false;
+	if (!lowspace && !xfs_good_hint_match(oz, file_hint))
+		return false;
 	if (!atomic_inc_not_zero(&oz->oz_ref))
 		return false;
 
+	/*
+	 * If we have a hint set for the data, use that for the zone even if
+	 * some data was written already without any hint set, but don't change
+	 * the temperature after that as that would make little sense without
+	 * tracking per-temperature class written block counts, which is
+	 * probably overkill anyway.
+	 */
+	if (file_hint != WRITE_LIFE_NOT_SET &&
+	    oz->oz_write_hint == WRITE_LIFE_NOT_SET)
+		oz->oz_write_hint = file_hint;
+
 	/*
 	 * If we couldn't match by inode or life time we just pick the first
 	 * zone with enough space above.  For that we want the least busy zone
@@ -484,28 +550,38 @@ xfs_try_use_zone(
 
 static struct xfs_open_zone *
 xfs_select_open_zone_lru(
-	struct xfs_zone_info	*zi)
+	struct xfs_zone_info	*zi,
+	enum rw_hint		file_hint,
+	bool			lowspace)
 {
 	struct xfs_open_zone	*oz;
 
 	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
-		if (xfs_try_use_zone(zi, oz))
+		if (xfs_try_use_zone(zi, file_hint, oz, lowspace))
 			return oz;
 	return NULL;
 }
 
 static struct xfs_open_zone *
 xfs_select_open_zone_mru(
-	struct xfs_zone_info	*zi)
+	struct xfs_zone_info	*zi,
+	enum rw_hint		file_hint)
 {
 	struct xfs_open_zone	*oz;
 
 	list_for_each_entry_reverse(oz, &zi->zi_open_zones, oz_entry)
-		if (xfs_try_use_zone(zi, oz))
+		if (xfs_try_use_zone(zi, file_hint, oz, false))
 			return oz;
 	return NULL;
 }
 
+static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
+{
+	if (xfs_has_nolifetime(ip->i_mount))
+		return WRITE_LIFE_NOT_SET;
+	return VFS_I(ip)->i_write_hint;
+}
+
 /*
  * Try to pack inodes that are written back after they were closed tight instead
  * of trying to open new zones for them or spread them to the least recently
@@ -535,10 +611,19 @@ xfs_select_zone_nowait(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_zone_info	*zi = mp->m_zone_info;
+	enum rw_hint		write_hint = xfs_inode_write_hint(ip);
 	struct xfs_open_zone	*oz = NULL;
 
-	if (xfs_zoned_pack_tight(ip))
-		oz = xfs_select_open_zone_mru(zi);
+	/*
+	 * Try to fill up open zones with matching temperature if available.  It
+	 * is better to try to co-locate data when this is favorable, so we can
+	 * activate empty zones when it is statistically better to separate
+	 * data.
+	 */
+	if (xfs_colocate_eagerly(write_hint))
+		oz = xfs_select_open_zone_lru(zi, write_hint, false);
+	else if (xfs_zoned_pack_tight(ip))
+		oz = xfs_select_open_zone_mru(zi, write_hint);
 	if (oz)
 		return oz;
 
@@ -546,12 +631,26 @@ xfs_select_zone_nowait(
 	 * If we are below the open limit try to activate a zone.
 	 */
 	if (zi->zi_nr_open_zones < mp->m_max_open_zones - XFS_OPEN_GC_ZONES) {
-		oz = xfs_activate_zone(mp);
+		oz = xfs_activate_zone(mp, write_hint);
 		if (oz)
 			return oz;
 	}
 
-	return xfs_select_open_zone_lru(zi);
+	/*
+	 * Try to colocate cold data with other cold data if we failed to open a
+	 * new zone for it.
+	 */
+	if (write_hint != WRITE_LIFE_NOT_SET &&
+	    !xfs_colocate_eagerly(write_hint)) {
+		oz = xfs_select_open_zone_lru(zi, write_hint, false);
+		if (oz)
+			return oz;
+	}
+
+	oz = xfs_select_open_zone_lru(zi, WRITE_LIFE_NOT_SET, false);
+	if (oz)
+		return oz;
+	return xfs_select_open_zone_lru(zi, WRITE_LIFE_NOT_SET, true);
 }
 
 static struct xfs_open_zone *
@@ -801,7 +900,8 @@ xfs_init_zone(
 		struct xfs_open_zone *oz;
 
 		atomic_inc(&rtg_group(rtg)->xg_active_ref);
-		oz = xfs_init_open_zone(rtg, write_pointer, false);
+		oz = xfs_init_open_zone(rtg, write_pointer, WRITE_LIFE_NOT_SET,
+				false);
 		list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
 		zi->zi_nr_open_zones++;
 
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 085d7001935e..e9b2c8ed5e9f 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -489,7 +489,7 @@ xfs_select_gc_zone(
 		if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE))
 			oz = xfs_steal_open_zone_for_gc(zi);
 		else
-			oz = xfs_open_zone(mp, true);
+			oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
 		spin_unlock(&zi->zi_zone_list_lock);
 
 		if (oz)
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index 0b720026e54a..eb7187e09551 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -26,6 +26,12 @@ struct xfs_open_zone {
 	xfs_rgblock_t		oz_write_pointer;
 	xfs_rgblock_t		oz_written;
 
+	/*
+	 * Write hint (data temperature) assigned to this zone, or
+	 * WRITE_LIFE_NOT_SET if none was set.
+	 */
+	enum rw_hint		oz_write_hint;
+
 	/*
 	 * Is this open zone used for garbage collection?  There can only be a
 	 * single open GC zone, which is pointed to by zi_open_gc_zone in
@@ -80,7 +86,8 @@ struct xfs_zone_info {
 	struct xfs_group	*zi_reset_list;
 };
 
-struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp, bool is_gc);
+struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp,
+		enum rw_hint write_hint, bool is_gc);
 
 int xfs_zone_reset_sync(struct xfs_rtgroup *rtg);
 bool xfs_zoned_need_gc(struct xfs_mount *mp);
-- 
2.45.2

