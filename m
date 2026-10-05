Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D3D47F2F8
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791201632; cv=none; b=QWSz8dPCwMi90YTV+yHdsl6FNsLJlotjAAktaWfV1SnbX3y5leTKBeHnBxlanLKiuBv8HBO9nIP+jgd1LEWseNGPuzKg8Hz6VxtycQbjuFlCYV47Si+kyvmUgrNx3eNDdjtvgA12F4K/zfmlyzLkZNLAtjvwo+nrDwJVOcx8mLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791201632; c=relaxed/simple;
	bh=I5vvkYFbbOnfIa14ePcepb+UyqhN//IYBgBKQ56qHjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UdLVsrV5SrhROYiouycYrHgH8g5GuFFnNTHasZ7pQjWwFWTNukPafZ8gl1bNE2cIuqRWzYQ2I9EQmZ02E9byB/pJ2UxmI6BDh0Pg0slmeBVj25XMZnoMAfCK+x0NBhKgGF5Gd8v7YYq5EYAGR/h/XNr1wNKBG2D8yQxmxHEukPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rOrpwn4g; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rOrpwn4g"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791201630; x=1822737630;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I5vvkYFbbOnfIa14ePcepb+UyqhN//IYBgBKQ56qHjA=;
  b=rOrpwn4g3xLFu51woH2qeyuVN/2ue99QdCxpiYBkgxESNUZlLft923Jb
   f3MlFElEPrxL+V9seqhlQYVCpuyZEjNEAaTxGqB5lHbl6/Gq9zpyk2HGN
   hu6ymucMk7VM6Sp/HFmFoZE42aifdk2qVsfUEmB7AMdy1nqxOleTqON53
   5ey8rp6HLnNDGEmaR9QTYHiB3FCN2eo9cLsyMHeUO5EBP3ojz5YIwrRTb
   s+vDp7R+CP2HHR+rNulRrZO9ZoITfObal1lCU0saOIML5a4yuMDq8IUel
   ty+U05eCfXetKKhFOXxZp6/ZmYDMZ9Hi1e3Js2mB2JopPaIANfp/ky9V+
   g==;
X-CSE-ConnectionGUID: uWYyvE8aSji2qZfVvUSJOg==
X-CSE-MsgGUID: goo/vwOKQPi71H7FeqklWA==
X-IronPort-AV: E=Sophos;i="6.27,141,1786982400"; 
   d="scan'208";a="157174134"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Oct 2026 19:59:21 +0800
X-CSE-ConnectionGUID: ZtWViXlNRXa54HUmYJJpqw==
X-CSE-MsgGUID: aGmVfOrzTRSo7sxgLXf37Q==
IronPort-SDR: 6ac39119_R4gjLKvYzDibbScQ5SfU8RBOS8uvaNj8Vlc7YmG70sdu3qL
 4ME12lVXwxkznKvGSx2XpyNfZjU+dYPU2bWBFcQ==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Oct 2026 04:59:21 -0700
X-CSE-ConnectionGUID: biK2vFJdSlmCfkD2AYRbyA==
X-CSE-MsgGUID: tWMk7PIPTOO2kszScnI9IQ==
WDCIronportException: Internal
Received: from 5cg21742s3.ad.shared (HELO gcv.wireless.wdc) ([10.224.5.153])
  by uls-op-esai2-o.wdc.com with ESMTP; 05 Oct 2026 04:59:19 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2] xfs: don't let racing writers consume the free zones reserved for GC
Date: Mon,  5 Oct 2026 13:59:17 +0200
Message-ID: <20261005115917.36378-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_try_open_zone() checks the free zone count to avoid grabbing zones
required for GC forward progress, but does so without decreasing the
counter, letting multiple user writers through to call xfs_open_zone()
and collectively gobble up all free zones, stalling gc and eventually
leading to user threads getting stuck waiting for free space.

Fold the check and the accounting into a single atomic claim in
xfs_open_zone() instead.  The free zone count is decremented before the
zone is looked up and given back if none could be grabbed, so the reserve
can no longer be raced away.  User allocations only claim a zone if that
leaves the reserve behind, while GC just needs one free zone and thus can
still use the zones that are kept for it. Also add a warning if we end
up not finding a free zone in the xarray, as this should never happen.

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

Changes since v1:
- Add a WARN_ON_ONCE when no free zone is found despite a successful claim

 fs/xfs/libxfs/xfs_zones.h |  6 ++++++
 fs/xfs/xfs_zone_alloc.c   | 36 ++++++++++++++++++++++++++++++++----
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
index c16089c9a652..1391d99b31de 100644
--- a/fs/xfs/libxfs/xfs_zones.h
+++ b/fs/xfs/libxfs/xfs_zones.h
@@ -30,6 +30,12 @@ struct blk_zone;
 #define XFS_OPEN_GC_ZONES	1U
 #define XFS_MIN_OPEN_ZONES	(XFS_OPEN_GC_ZONES + 1U)
 
+/*
+ * Never open a zone for user data unless this many zones are free, so that GC
+ * can always open the target zone it needs to make forward progress.
+ */
+#define XFS_MIN_FREE_GC_ZONES	(XFS_GC_ZONES - XFS_OPEN_GC_ZONES)
+
 /*
  * For zoned devices that do not have a limit on the number of open zones, and
  * for regular devices using the zoned allocator, use the most common SMR disks
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 28c1e48909fa..be434eeccab2 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -437,6 +437,26 @@ xfs_init_open_zone(
 	return oz;
 }
 
+/*
+ * Claim one of the free zones. User allocations may not dip into the pool
+ * reserved for guaranteeing GC forward progress.
+ */
+static bool
+xfs_claim_free_zone(
+	struct xfs_zone_info	*zi,
+	bool			is_gc)
+{
+	int			min_free = is_gc ? 1 : XFS_MIN_FREE_GC_ZONES;
+	int			free = atomic_read(&zi->zi_nr_free_zones);
+
+	do {
+		if (free < min_free)
+			return false;
+	} while (!atomic_try_cmpxchg(&zi->zi_nr_free_zones, &free, free - 1));
+
+	return true;
+}
+
 /*
  * Find a completely free zone, open it, and return a reference.
  */
@@ -450,6 +470,9 @@ xfs_open_zone(
 	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, 0);
 	struct xfs_group	*xg;
 
+	if (!xfs_claim_free_zone(zi, is_gc))
+		return NULL;
+
 	/*
 	 * Pick the free zone with lowest index. Zones in the beginning of the
 	 * address space typically provides higher bandwidth than those at the
@@ -460,11 +483,19 @@ xfs_open_zone(
 		if (atomic_inc_not_zero(&xg->xg_active_ref))
 			goto found;
 	xas_unlock(&xas);
+
+	/*
+	 * We should not end up here as we claimed a free zone before looking
+	 * through the free zone list. The free zone counter and the number
+	 * of zones marked as free must be out of sync.
+	 */
+	WARN_ON_ONCE(1);
+
+	atomic_inc(&zi->zi_nr_free_zones);
 	return NULL;
 
 found:
 	xas_clear_mark(&xas, XFS_RTG_FREE);
-	atomic_dec(&zi->zi_nr_free_zones);
 	xas_unlock(&xas);
 
 	set_current_state(TASK_RUNNING);
@@ -483,9 +514,6 @@ xfs_try_open_zone(
 
 	if (zi->zi_nr_open_zones >= mp->m_max_open_zones - XFS_OPEN_GC_ZONES)
 		return NULL;
-	if (atomic_read(&zi->zi_nr_free_zones) <
-	    XFS_GC_ZONES - XFS_OPEN_GC_ZONES)
-		return NULL;
 
 	/*
 	 * Increment the open zone count to reserve our slot before dropping
-- 
2.43.0

