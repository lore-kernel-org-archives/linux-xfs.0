Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20CD3E49CD
	for <linux-xfs@vger.kernel.org>; Sun, 27 Sep 2026 12:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790513349; cv=none; b=cORrBQDM0WwlTNOfkRQQptGcfLf0K319iFK0AR3q+P9kCq2S8xo5ys7NoyGnfg6KXTrtHlparv7WKh9rNbqbSZPDypMbKfe23td46lSkW5DQHIsCXg4p3sc3jdNKaQp3lj8gi7BlQHJnxDqhc0flVWlJu0cvlkpOTAVrXxzNeqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790513349; c=relaxed/simple;
	bh=wyIpiiOXFv1Em1NdZMHqYmCOoFZ+Xv6bl+o4MtQMHNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k24kgHLAr8SmsXx3OlXp4ogL3Wes8/ODyoLb4p/htLqMQX5HBmTc/u+SoyjvbdLRCQyCUDsBkVDlq8O/4z1IGqmitAyowGyd8TPNZ0se1DqWzVsHnH1hNgTVLsb8ej+jtPG1wuQOqJwwOgFBWxS7HCeaLodtoCXt0smRFiyD3y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TfiueacP; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TfiueacP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790513348; x=1822049348;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wyIpiiOXFv1Em1NdZMHqYmCOoFZ+Xv6bl+o4MtQMHNk=;
  b=TfiueacPA+b4jXkzQjcvAD8EjimbY9HDo6nXX8J0fCZggpc+UFtyeIQl
   TvzqtFC/QpmTsbitYSRuGpdm62ZMpc5pCUQ/z9+nw0ziahfYBpbi/ekuV
   FA7x/HZdJYj2e5mXwJPPZjkcERFsHuCxm8VhPY9Mlbn7kA8T4Yr2SfXQF
   Ni6Sb5rvDBFPuna3nQVuEDg/G+Iw001XCFje7lXNXUahTBjx16pl2zeHu
   IjOp0zxw8kb1d3qCSjavDIFd2ITuoHCFkIw24LQQ29Flwp65n2Pms1mJ9
   YSBsqkqph00k4wlu3rGvO8P5I5UpLBHxVecAKPs3aBWHRy3pmG18uFLFD
   Q==;
X-CSE-ConnectionGUID: GZXWAymLSuCHUzNtCeMLOw==
X-CSE-MsgGUID: cEKpmqGwRAqeZrkrxV+9Aw==
X-IronPort-AV: E=Sophos;i="6.27,126,1786982400"; 
   d="scan'208";a="156674581"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2026 20:49:01 +0800
X-CSE-ConnectionGUID: Pu5opZ9ORISMlDbmZzSRhA==
X-CSE-MsgGUID: Tx1KFNAiQ6ea7DBlwsZFaw==
IronPort-SDR: 6ab910bc_uu0T9MwuCkfxbSE+Y/0OJqt/YhExDNgosWmM81UlizbXV8a
 pADVpjQiWNIyXgC01C8Fr0y7dhZK8zpvF3e9ATw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2026 05:49:00 -0700
X-CSE-ConnectionGUID: Hwak0QwZRHyaGCBkI5WMvw==
X-CSE-MsgGUID: NK+X7XwlRrykoh1yapTHmA==
WDCIronportException: Internal
Received: from c02g55gsml85.ad.shared (HELO gcv.wdc.com) ([10.224.5.130])
  by uls-op-esai1-o.wdc.com with ESMTP; 27 Sep 2026 05:48:58 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH] xfs: don't let racing writers consume the free zones reserved for GC
Date: Sun, 27 Sep 2026 14:48:41 +0200
Message-ID: <20260927124841.31314-1-hans.holmberg@wdc.com>
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
and collectivly gobble up all free zones, stalling gc and eventually
leading to user threads getting stuck waiting for free space.

Fold the check and the accounting into a single atomic claim in
xfs_open_zone() instead.  The free zone count is decremented before the
zone is looked up and given back if none could be grabbed, so the reserve
can no longer be raced away.  User allocations only claim a zone if that
leaves the reserve behind, while GC just needs one free zone and thus can
still use the zones that are kept for it.

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

Darrick: Maybe this is the bug you saw [1] when writers got stuck
waitig for gc? (generic/476)

[1] https://lore.kernel.org/linux-xfs/20260925193722.GP2705364@frogsfrogsfrogs/

I have only been able to reproduce this issue in combination with other
patches, but the issue has been there since the start.

 fs/xfs/libxfs/xfs_zones.h |  6 ++++++
 fs/xfs/xfs_zone_alloc.c   | 29 +++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

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
index 28c1e48909fa..45bc77b1677b 100644
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
@@ -460,11 +483,12 @@ xfs_open_zone(
 		if (atomic_inc_not_zero(&xg->xg_active_ref))
 			goto found;
 	xas_unlock(&xas);
+
+	atomic_inc(&zi->zi_nr_free_zones);
 	return NULL;
 
 found:
 	xas_clear_mark(&xas, XFS_RTG_FREE);
-	atomic_dec(&zi->zi_nr_free_zones);
 	xas_unlock(&xas);
 
 	set_current_state(TASK_RUNNING);
@@ -483,9 +507,6 @@ xfs_try_open_zone(
 
 	if (zi->zi_nr_open_zones >= mp->m_max_open_zones - XFS_OPEN_GC_ZONES)
 		return NULL;
-	if (atomic_read(&zi->zi_nr_free_zones) <
-	    XFS_GC_ZONES - XFS_OPEN_GC_ZONES)
-		return NULL;
 
 	/*
 	 * Increment the open zone count to reserve our slot before dropping
-- 
2.43.0

