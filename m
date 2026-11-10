Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.71.154.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306964;
	b=IKSJshdsWXafZJjvDXiMqA4/qO78RHcmRA2yZvhTLIGTm5cSsNPElIuzflEc2IfNj9xb
	 dh1h53CZOKmcRInJThkxIKci2/aa4LZfxVGmhuN8KjqlvVYv9hVyzkjL94ToAcwtnJEp/
	 Yb9vHMYfA+4rSkvNPee0kHOKnLqHZU6ZGmAgJhgQi7E6DcsLyQT7gJHIJonBF0iZEqquq
	 mrNJ1LjnfY9E/vZYUypRbia+z9yzb/RBfuo7z2AJR/vT77kLbgdXRB1SooVqGDXo87Ctn
	 9TIzzWR7yKnyK7iSbSOWVUsuURjOj3f9Qb3CroAYU7y4TZFOInRb0Xl7tTjhNnCExRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306964;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6e7o1EkR30VfvXlPfo7CzRMchWJp0RXT00JTjeUVg+c=;
	b=OKrGZZZ89fJgNazLDwHUF6TluM37m9KrMkNwsRjIK6iXkPi0VkN8L3GlOfaD0Gjl9ZLK
	 dlsplJtmYYm1Pl8KnFbC50UsOQNgGWqkvNcTM78nr+iB/5EWKiJffOb5trwVKq+So79D0
	 FDzKE0WhuKMN/jvfc6h279rWjtWjff0usZyXvEDLGs54rJbG1qIg0q9Tz7yzfmkbV4ZSy
	 1otB5JltqfkSU49RBDzr5x4j0Tt14v60C+aPRBA6LDKdG3EPJPe2Ojf8rRmr2mRZO+EfM
	 RXcVReGZvsdwgxx3ptcZNsVtsIAriYntr3dpD0p85EXDA5o30pUZfb/DG2qjiUXZVDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=c3GQ9EWI;
	arc=none smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A29606A32E;
	Tue, 10 Nov 2026 10:36:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85A29606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=c3GQ9EWI
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794306963; x=1825842963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kFDeDWc0pHxcZKTMTkkfCytONpwbsLHWr+fa/nSX2B4=;
  b=c3GQ9EWI9Q0HuaXyZLrYb0BVSWRTKIhKJcRHDBq8wNFMGNy9L7qY4QU+
   VCKuXq/nQAnF4cEpCK9vtghCWnBFHUTNS3eRodAOXVGC24XqkZYXxmlsI
   AG7211o65Bf3XkGZ9k2uiGH6nWtANu2zg6Uaq6W/AcBOCgA4QGCLwF12m
   YkoD3xt6ye1M6iKlCbDSB73YaKOlHpPMTyvSmJGt/I2TOW6Z2wg9gl0NF
   6jl1t0BTk6pXuzOw6436KkYpzhnseyntfZzv+ycN518+dpiIJUxmoXS6z
   aBPQNzFqr4l5fUqkdE8h2V5vhN7Lukc8PAbe8umJw5IRG/rVPQu5siFLS
   g==;
X-CSE-ConnectionGUID: +C0ZOqajSwG2JFZUQQdU/g==
X-CSE-MsgGUID: vCZcak3RQ2GJnaclq5FRsw==
X-IronPort-AV: E=Sophos;i="6.27,205,1786982400"; 
   d="scan'208";a="158891399"
Received: from h199-255-45-14.hgst.com (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2026 18:36:03 +0800
X-CSE-ConnectionGUID: 5H/e3S42Tymk0MIktzJcJA==
X-CSE-MsgGUID: 8/50r5OVR8C1LXlZ3gsaPQ==
IronPort-SDR: 6af2f393_Tc8PJkFRJjk0NoN2hGlsXDwRXPsuz9dJ+jumQn7xTI/8GmV
 EUOHbWSfDzSFjw9LRbDH+0dUFC933NgnDrMk8hQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 02:36:03 -0800
X-CSE-ConnectionGUID: xvRA0vAOQUm2ySWGxTJCpg==
X-CSE-MsgGUID: qywj1dp7Qu+m6iigCqmM6g==
WDCIronportException: Internal
Received: from unknown (HELO gcv.wireless.wdc) ([10.224.5.251])
  by uls-op-esai1-o.wdc.com with ESMTP; 10 Nov 2026 02:36:00 -0800
From: Hans Holmberg <hans.holmberg@wdc.com>
To: brauner@kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	dgc@kernel.org,
	cem@kernel.org,
	jack@suse.cz,
	axboe@kernel.dk,
	kbusch@kernel.org
Cc: dlemoal@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [RFC 2/4] xfs: place zoned data by write stream in open zones
Date: Tue, 10 Nov 2026 11:35:38 +0100
Message-ID: <20261110103540.46876-3-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110103540.46876-1-hans.holmberg@wdc.com>
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
 <20261110103540.46876-1-hans.holmberg@wdc.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Colocate data assigned to the same stream to the same open zone.
Writers with a stream first look for an open zone dedicated to their
stream, and only open a new zone if none is found.  If the open zone
limit is reached, an open zone without stream or life time hint is
claimed for the stream, and only as a last resort data is co-located
with another stream.

Files with stream ids attached are excluded from the tight packing
heurustic - they are tightly packed by stream in stead.

Writers without a stream skip stream zones except for the last resort
pass, and a cached open zone is only reused if it matches the write
stream of the inode.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_zone_alloc.c | 125 +++++++++++++++++++++++++++-------------
 fs/xfs/xfs_zone_info.c  |   3 +-
 fs/xfs/xfs_zone_priv.h  |   7 +++
 3 files changed, 95 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 887f7f6d3307..8b2838239325 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -505,7 +505,8 @@ xfs_open_zone(
 static struct xfs_open_zone *
 xfs_try_open_zone(
 	struct xfs_mount	*mp,
-	enum rw_hint		write_hint)
+	enum rw_hint		write_hint,
+	u16			write_stream)
 		__releases(&mp->m_zone_info->zi_open_zones_lock)
 		__acquires(&mp->m_zone_info->zi_open_zones_lock)
 {
@@ -528,6 +529,7 @@ xfs_try_open_zone(
 		return NULL;
 	}
 
+	oz->oz_write_stream = write_stream;
 	atomic_inc(&oz->oz_ref);
 	list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
 
@@ -544,15 +546,18 @@ xfs_try_open_zone(
 	return oz;
 }
 
-enum xfs_zone_alloc_score {
+enum xfs_zone_alloc_mode {
 	/* Any open zone will do it, we're desperate */
 	XFS_ZONE_ALLOC_ANY	= 0,
 
-	/* It better fit somehow */
-	XFS_ZONE_ALLOC_OK	= 1,
+	/* It better fit with some write life time hint */
+	XFS_ZONE_ALLOC_OK_HINT	= 1,
+
+	/* Only reuse a zone if the hint fits really well. */
+	XFS_ZONE_ALLOC_GOOD_HINT	= 2,
 
-	/* Only reuse a zone if it fits really well. */
-	XFS_ZONE_ALLOC_GOOD	= 2,
+	/* Only reuse a zone dedicated to the same write stream. */
+	XFS_ZONE_ALLOC_STREAM	= 3,
 };
 
 /*
@@ -562,24 +567,24 @@ enum xfs_zone_alloc_score {
 static const unsigned int
 xfs_zoned_hint_score[WRITE_LIFE_HINT_NR][WRITE_LIFE_HINT_NR] = {
 	[WRITE_LIFE_NOT_SET]	= {
-		[WRITE_LIFE_NOT_SET]	= XFS_ZONE_ALLOC_OK,
+		[WRITE_LIFE_NOT_SET]	= XFS_ZONE_ALLOC_OK_HINT,
 	},
 	[WRITE_LIFE_NONE]	= {
-		[WRITE_LIFE_NONE]	= XFS_ZONE_ALLOC_OK,
+		[WRITE_LIFE_NONE]	= XFS_ZONE_ALLOC_OK_HINT,
 	},
 	[WRITE_LIFE_SHORT]	= {
-		[WRITE_LIFE_SHORT]	= XFS_ZONE_ALLOC_GOOD,
+		[WRITE_LIFE_SHORT]	= XFS_ZONE_ALLOC_GOOD_HINT,
 	},
 	[WRITE_LIFE_MEDIUM]	= {
-		[WRITE_LIFE_MEDIUM]	= XFS_ZONE_ALLOC_GOOD,
+		[WRITE_LIFE_MEDIUM]	= XFS_ZONE_ALLOC_GOOD_HINT,
 	},
 	[WRITE_LIFE_LONG]	= {
-		[WRITE_LIFE_LONG]	= XFS_ZONE_ALLOC_OK,
-		[WRITE_LIFE_EXTREME]	= XFS_ZONE_ALLOC_OK,
+		[WRITE_LIFE_LONG]	= XFS_ZONE_ALLOC_OK_HINT,
+		[WRITE_LIFE_EXTREME]	= XFS_ZONE_ALLOC_OK_HINT,
 	},
 	[WRITE_LIFE_EXTREME]	= {
-		[WRITE_LIFE_LONG]	= XFS_ZONE_ALLOC_OK,
-		[WRITE_LIFE_EXTREME]	= XFS_ZONE_ALLOC_OK,
+		[WRITE_LIFE_LONG]	= XFS_ZONE_ALLOC_OK_HINT,
+		[WRITE_LIFE_EXTREME]	= XFS_ZONE_ALLOC_OK_HINT,
 	},
 };
 
@@ -587,8 +592,9 @@ static bool
 xfs_try_use_zone(
 	struct xfs_zone_info	*zi,
 	enum rw_hint		file_hint,
+	u16			file_stream,
 	struct xfs_open_zone	*oz,
-	unsigned int		goodness)
+	unsigned int		mode)
 {
 	if (oz->oz_is_gc)
 		return false;
@@ -596,8 +602,17 @@ xfs_try_use_zone(
 	if (oz->oz_allocated == rtg_blocks(oz->oz_rtg))
 		return false;
 
-	if (xfs_zoned_hint_score[oz->oz_write_hint][file_hint] < goodness)
-		return false;
+	if (mode == XFS_ZONE_ALLOC_STREAM) {
+		if (oz->oz_write_stream != file_stream)
+			return false;
+	} else if (mode != XFS_ZONE_ALLOC_ANY) {
+		/* never co-locate with another write stream unless desperate */
+		if (oz->oz_write_stream != WRITE_STREAM_NOT_SET)
+			return false;
+		if (xfs_zoned_hint_score[oz->oz_write_hint][file_hint] <
+		    mode)
+			return false;
+	}
 
 	if (!atomic_inc_not_zero(&oz->oz_ref))
 		return false;
@@ -613,6 +628,14 @@ xfs_try_use_zone(
 	    oz->oz_write_hint == WRITE_LIFE_NOT_SET)
 		oz->oz_write_hint = file_hint;
 
+	/*
+	 * Dedicate a zone without a stream to the stream writing to it, so
+	 * that writers without a stream and other streams stay away from it.
+	 */
+	if (file_stream != WRITE_STREAM_NOT_SET &&
+	    oz->oz_write_stream == WRITE_STREAM_NOT_SET)
+		WRITE_ONCE(oz->oz_write_stream, file_stream);
+
 	/*
 	 * If we couldn't match by inode or life time we just pick the first
 	 * zone with enough space above.  For that we want the least busy zone
@@ -629,14 +652,15 @@ static struct xfs_open_zone *
 xfs_select_open_zone_lru(
 	struct xfs_zone_info	*zi,
 	enum rw_hint		file_hint,
-	unsigned int		goodness)
+	u16			file_stream,
+	unsigned int		mode)
 {
 	struct xfs_open_zone	*oz;
 
 	lockdep_assert_held(&zi->zi_open_zones_lock);
 
 	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
-		if (xfs_try_use_zone(zi, file_hint, oz, goodness))
+		if (xfs_try_use_zone(zi, file_hint, file_stream, oz, mode))
 			return oz;
 
 	cond_resched_lock(&zi->zi_open_zones_lock);
@@ -646,14 +670,16 @@ xfs_select_open_zone_lru(
 static struct xfs_open_zone *
 xfs_select_open_zone_mru(
 	struct xfs_zone_info	*zi,
-	enum rw_hint		file_hint)
+	enum rw_hint		file_hint,
+	u16			file_stream)
 {
 	struct xfs_open_zone	*oz;
 
 	lockdep_assert_held(&zi->zi_open_zones_lock);
 
 	list_for_each_entry_reverse(oz, &zi->zi_open_zones, oz_entry)
-		if (xfs_try_use_zone(zi, file_hint, oz, XFS_ZONE_ALLOC_OK))
+		if (xfs_try_use_zone(zi, file_hint, file_stream, oz,
+				XFS_ZONE_ALLOC_OK_HINT))
 			return oz;
 
 	cond_resched_lock(&zi->zi_open_zones_lock);
@@ -667,6 +693,11 @@ static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
 	return VFS_I(ip)->i_write_hint;
 }
 
+static inline u16 xfs_inode_write_stream(struct xfs_inode *ip)
+{
+	return READ_ONCE(VFS_I(ip)->i_write_stream);
+}
+
 /*
  * Try to tightly pack small files that are written back after they were closed
  * instead of trying to open new zones for them or spread them to the least
@@ -695,6 +726,7 @@ static struct xfs_open_zone *
 xfs_select_zone_nowait(
 	struct xfs_mount	*mp,
 	enum rw_hint		write_hint,
+	u16			write_stream,
 	bool			pack_tight)
 {
 	struct xfs_zone_info	*zi = mp->m_zone_info;
@@ -704,18 +736,20 @@ xfs_select_zone_nowait(
 		return NULL;
 
 	/*
+	 * Stream writers only reuse zones already dedicated to that stream.
 	 * Try to fill up open zones with matching temperature if available.  It
 	 * is better to try to co-locate data when this is favorable, so we can
 	 * activate empty zones when it is statistically better to separate
 	 * data.
 	 */
 	spin_lock(&zi->zi_open_zones_lock);
-	oz = xfs_select_open_zone_lru(zi, write_hint, XFS_ZONE_ALLOC_GOOD);
+	oz = xfs_select_open_zone_lru(zi, write_hint, write_stream,
+			write_stream ? XFS_ZONE_ALLOC_STREAM : XFS_ZONE_ALLOC_GOOD_HINT);
 	if (oz)
 		goto out_unlock;
 
-	if (pack_tight) {
-		oz = xfs_select_open_zone_mru(zi, write_hint);
+	if (pack_tight && !write_stream) {
+		oz = xfs_select_open_zone_mru(zi, write_hint, write_stream);
 		if (oz)
 			goto out_unlock;
 	}
@@ -724,21 +758,23 @@ xfs_select_zone_nowait(
 	 * See if we can open a new zone and use that so that data for different
 	 * files is mixed as little as possible.
 	 */
-	oz = xfs_try_open_zone(mp, write_hint);
+	oz = xfs_try_open_zone(mp, write_hint, write_stream);
 	if (oz)
 		goto out_unlock;
 
 	/*
 	 * Try to find a zone that is an ok match to colocate data with.
 	 */
-	oz = xfs_select_open_zone_lru(zi, write_hint, XFS_ZONE_ALLOC_OK);
+	oz = xfs_select_open_zone_lru(zi, write_hint, write_stream,
+			XFS_ZONE_ALLOC_OK_HINT);
 	if (oz)
 		goto out_unlock;
 
 	/*
-	 * Pick the least recently used zone, regardless of hint match
+	 * Pick the least recently used zone, regardless of hint/stream match
 	 */
-	oz = xfs_select_open_zone_lru(zi, write_hint, XFS_ZONE_ALLOC_ANY);
+	oz = xfs_select_open_zone_lru(zi, write_hint, write_stream,
+			XFS_ZONE_ALLOC_ANY);
 out_unlock:
 	spin_unlock(&zi->zi_open_zones_lock);
 	return oz;
@@ -748,19 +784,21 @@ static struct xfs_open_zone *
 xfs_select_zone(
 	struct xfs_mount	*mp,
 	enum rw_hint		write_hint,
+	u16			write_stream,
 	bool			pack_tight)
 {
 	struct xfs_zone_info	*zi = mp->m_zone_info;
 	DEFINE_WAIT		(wait);
 	struct xfs_open_zone	*oz;
 
-	oz = xfs_select_zone_nowait(mp, write_hint, pack_tight);
+	oz = xfs_select_zone_nowait(mp, write_hint, write_stream, pack_tight);
 	if (oz)
 		return oz;
 
 	for (;;) {
 		prepare_to_wait(&zi->zi_zone_wait, &wait, TASK_UNINTERRUPTIBLE);
-		oz = xfs_select_zone_nowait(mp, write_hint, pack_tight);
+		oz = xfs_select_zone_nowait(mp, write_hint, write_stream,
+				pack_tight);
 		if (oz || xfs_is_shutdown(mp))
 			break;
 		schedule();
@@ -817,7 +855,8 @@ xfs_mark_rtg_boundary(
  */
 static struct xfs_open_zone *
 xfs_get_cached_zone(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	u16			write_stream)
 {
 	struct xfs_open_zone	*oz;
 
@@ -850,6 +889,10 @@ xfs_get_cached_zone(
 
 	if (oz && !atomic_inc_not_zero(&oz->oz_ref))
 		oz = NULL;
+	if (oz && READ_ONCE(oz->oz_write_stream) != write_stream) {
+		xfs_open_zone_put(oz);
+		oz = NULL;
+	}
 out_unlock:
 	rcu_read_unlock();
 	return oz;
@@ -874,15 +917,17 @@ xfs_get_cached_zone(
 static struct xfs_open_zone *
 xfs_set_cached_zone(
 	struct xfs_inode	*ip,
-	struct xfs_open_zone	*oz)
+	struct xfs_open_zone	*oz,
+	u16			write_stream)
 {
 	struct xfs_open_zone	*old_oz;
 
 	/*
-	 * If the open zone cached in the inode still has free space, use that
-	 * instead of the new open zone just selected.  This can happen when
-	 * multiple threads race to perform zone selection for an inode.
-	 * io_uring worker threads seem to be good way to trigger this.
+	 * If the open zone cached in the inode still has free space and matches
+	 * its write stream, use that instead of the new open zone just selected.
+	 * This can happen when multiple threads race to perform zone selection
+	 * for an inode.  io_uring worker threads seem to be good way to trigger
+	 * this.
 	 *
 	 * We need to grab an extra reference to this open zone as the caller
 	 * owns a reference in addition to the i_private pointer.
@@ -890,6 +935,7 @@ xfs_set_cached_zone(
 	spin_lock(&ip->i_flags_lock);
 	old_oz = VFS_I(ip)->i_private;
 	if (old_oz && old_oz->oz_allocated < rtg_blocks(old_oz->oz_rtg) &&
+	    READ_ONCE(old_oz->oz_write_stream) == write_stream &&
 	    atomic_inc_not_zero(&old_oz->oz_ref)) {
 		spin_unlock(&ip->i_flags_lock);
 		xfs_open_zone_put(oz);
@@ -931,6 +977,7 @@ xfs_zone_alloc_and_submit(
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	enum rw_hint		write_hint = xfs_inode_write_hint(ip);
+	u16			write_stream = xfs_inode_write_stream(ip);
 	bool			pack_tight = xfs_zoned_pack_tight(ip);
 	unsigned int		alloc_len;
 	struct iomap_ioend	*split;
@@ -945,12 +992,12 @@ xfs_zone_alloc_and_submit(
 	 */
 	if (!*oz)
 select_zone:
-		*oz = xfs_get_cached_zone(ip);
+		*oz = xfs_get_cached_zone(ip, write_stream);
 	if (!*oz) {
-		*oz = xfs_select_zone(mp, write_hint, pack_tight);
+		*oz = xfs_select_zone(mp, write_hint, write_stream, pack_tight);
 		if (!*oz)
 			goto out_error;
-		*oz = xfs_set_cached_zone(ip, *oz);
+		*oz = xfs_set_cached_zone(ip, *oz, write_stream);
 	}
 
 	alloc_len = xfs_zone_alloc_blocks(*oz, XFS_B_TO_FSB(mp, ioend->io_size),
diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index 47b475e21af8..5ba21ec973ef 100644
--- a/fs/xfs/xfs_zone_info.c
+++ b/fs/xfs/xfs_zone_info.c
@@ -30,11 +30,12 @@ xfs_show_open_zone(
 	struct seq_file		*m,
 	struct xfs_open_zone	*oz)
 {
-	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s %s\n",
+	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s, stream %u %s\n",
 		rtg_rgno(oz->oz_rtg),
 		oz->oz_allocated, oz->oz_written,
 		rtg_rmap(oz->oz_rtg)->i_used_blocks,
 		xfs_write_hint_to_str(oz->oz_write_hint),
+		oz->oz_write_stream,
 		oz->oz_is_gc ? "(GC)" : "");
 }
 
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index 75518eaca05f..de78ab58aedc 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -34,6 +34,13 @@ struct xfs_open_zone {
 	 */
 	enum rw_hint		oz_write_hint;
 
+	/*
+	 * Write stream this zone is dedicated to, or WRITE_STREAM_NOT_SET.
+	 * Only ever changes from WRITE_STREAM_NOT_SET to a stream id, under
+	 * zi_open_zones_lock.
+	 */
+	u16			oz_write_stream;
+
 	/* Is this open zone used for garbage collection? */
 	bool			oz_is_gc;
 
-- 
2.43.0

