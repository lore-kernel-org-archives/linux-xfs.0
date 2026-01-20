Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF173B8D4D
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768899582; cv=none; b=AdOT17runx713VKhFAx+QZzu+jFLSq9YvTh9TW9PUNx430XJj16H4bsUPj+Nnn2LxYfMqZ8cphNnl1KUOOIOvzAADuTFs6Nb/ji8gR70z1QQQOfrzmZ1gtyRguO/4Z8z5UPjo5FqeFQo6v/jQBWpYxaEpBIO2zk5jXbXLy7LV2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768899582; c=relaxed/simple;
	bh=frkIWxWwHmOR7sP+JQ/HlaoGphHGwMj/5LAifVYO19s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r33W8UrwL+u3brjhM3eTwjoScklkZpFY3H2XhdsGFpcmVt4CXKYwRfgUPONaIA50dT77+TGtsU4F4M0k5pAs9vR+73tHep0/v2yUAi84DL4cTSpnuHZhFTMU7uwZpPEPJ8mJwPBQ49lhHf8AYa01mrNOMHZpdkVCTj4p3SkPm9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=m2pl7N0v; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="m2pl7N0v"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1768899579; x=1800435579;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=frkIWxWwHmOR7sP+JQ/HlaoGphHGwMj/5LAifVYO19s=;
  b=m2pl7N0vGbNr6gaQbApTEmAwvT1yw5WINA+dSLuUJn4pRtzaFFmMJZd8
   sh5ZFfTkPcANLaFmoWzqSBiG1XjlkmvbSd0ndyhNbVO7GFpnqH5hM0kTI
   aeoMVcLgyEnkilA/9mbN4N37ryrJkSDCk5pmTXqe6ayHY/np/c8MjY6DQ
   RIzYbmqccrZJe6kYRWYFzN/e++4UwaIgOnwqpJqizdA05we0ITGPXsJjB
   DL4pv9xTEczvlFuH04GSQsVQXyngXwvfDYrE9mxzoXhGy9NuyLaX/uwyv
   sEj13v6lB+xc02gMW8lDSjx4Tt3HiKZqHeyun1lQl7IETeDstf6F3H6QH
   g==;
X-CSE-ConnectionGUID: UszLOPctR2SfQ1RlqJH1Wg==
X-CSE-MsgGUID: 3s3OEuGoRHaunwQYoPFG8Q==
X-IronPort-AV: E=Sophos;i="6.21,240,1763395200"; 
   d="scan'208";a="139798825"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jan 2026 16:59:32 +0800
IronPort-SDR: 696f43f5_I6oQUJul9atHzJawAP0pCNs7u++yBqAwOqpXi6X5o86i5K6
 133/LuZir8L56trbdm9lg/UNfdOjln6g93+sQ2Q==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jan 2026 00:59:33 -0800
WDCIronportException: Internal
Received: from b8vpy33.ad.shared (HELO gcv.wdc.com) ([10.224.20.2])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Jan 2026 00:59:30 -0800
From: Hans Holmberg <hans.holmberg@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	dlemoal@kernel.org,
	johannes.thumshirn@wdc.com,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH] xfs: always allocate the free zone with the lowest index
Date: Tue, 20 Jan 2026 09:57:46 +0100
Message-ID: <20260120085746.29980-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zones in the beginning of the address space are typically mapped to
higer bandwidth tracks on HDDs than those at the end of the address
space. So, in stead of allocating zones "round robin" across the whole
address space, always allocate the zone with the lowest index.

This increases average write bandwidth for overwrite workloads
when less than the full capacity is being used. At ~50% utilization
this improves bandwidth for a random file overwrite benchmark
with 128MiB files and 256MiB zone capacity by 30%.

Running the same benchmark with small 2-8 MiB files at 67% capacity
shows no significant difference in performance. Due to heavy
fragmentation the whole zone range is in use, greatly limiting the 
number of free zones with high bw.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

 fs/xfs/xfs_zone_alloc.c | 47 +++++++++++++++--------------------------
 fs/xfs/xfs_zone_priv.h  |  1 -
 2 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index bbcf21704ea0..d6c97026f733 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -408,31 +408,6 @@ xfs_zone_free_blocks(
 	return 0;
 }
 
-static struct xfs_group *
-xfs_find_free_zone(
-	struct xfs_mount	*mp,
-	unsigned long		start,
-	unsigned long		end)
-{
-	struct xfs_zone_info	*zi = mp->m_zone_info;
-	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, start);
-	struct xfs_group	*xg;
-
-	xas_lock(&xas);
-	xas_for_each_marked(&xas, xg, end, XFS_RTG_FREE)
-		if (atomic_inc_not_zero(&xg->xg_active_ref))
-			goto found;
-	xas_unlock(&xas);
-	return NULL;
-
-found:
-	xas_clear_mark(&xas, XFS_RTG_FREE);
-	atomic_dec(&zi->zi_nr_free_zones);
-	zi->zi_free_zone_cursor = xg->xg_gno;
-	xas_unlock(&xas);
-	return xg;
-}
-
 static struct xfs_open_zone *
 xfs_init_open_zone(
 	struct xfs_rtgroup	*rtg,
@@ -472,13 +447,25 @@ xfs_open_zone(
 	bool			is_gc)
 {
 	struct xfs_zone_info	*zi = mp->m_zone_info;
+	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, 0);
 	struct xfs_group	*xg;
 
-	xg = xfs_find_free_zone(mp, zi->zi_free_zone_cursor, ULONG_MAX);
-	if (!xg)
-		xg = xfs_find_free_zone(mp, 0, zi->zi_free_zone_cursor);
-	if (!xg)
-		return NULL;
+	/*
+	 * Pick the free zone with lowest index. Zones in the beginning of the
+	 * address space typically provides higher bandwidth than those at the
+	 * end of the address space on HDDs.
+	 */
+	xas_lock(&xas);
+	xas_for_each_marked(&xas, xg, ULONG_MAX, XFS_RTG_FREE)
+		if (atomic_inc_not_zero(&xg->xg_active_ref))
+			goto found;
+	xas_unlock(&xas);
+	return NULL;
+
+found:
+	xas_clear_mark(&xas, XFS_RTG_FREE);
+	atomic_dec(&zi->zi_nr_free_zones);
+	xas_unlock(&xas);
 
 	set_current_state(TASK_RUNNING);
 	return xfs_init_open_zone(to_rtg(xg), 0, write_hint, is_gc);
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index ce7f0e2f4598..8fbf9a52964e 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -72,7 +72,6 @@ struct xfs_zone_info {
 	/*
 	 * Free zone search cursor and number of free zones:
 	 */
-	unsigned long		zi_free_zone_cursor;
 	atomic_t		zi_nr_free_zones;
 
 	/*
-- 
2.40.1

