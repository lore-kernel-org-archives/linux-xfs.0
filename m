Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE94C385512
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849572; cv=none; b=p0bIMOMzfayi2OQXPb3lUzcKX2NhK59DC0NVihJG2Kr5byOgGRmhEGtzCTX3xlcrWfSJniNMyrfl63Mi4U53EXy5iOm2UTT4GPWcJxTGWsQRwg6e2WNkUQ35VXxdukQKVKjnui+hKIDwiuqfm0ilzLtHWKZYL2gzrgN4b9RbA/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849572; c=relaxed/simple;
	bh=hFRcP1uKTeKYDpV/aMRrF/4Dy3DSLs6XyED5MU8o09M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/wRz4wG3IbXy08lX6wEKDkksgbq2SG+HJtrUDktPGAnGYcAQROBcKH4Lk87zr5tim8+RT2XYi8Kmk8ol6KjNl59dBolnYefSxtEcZugI6CmmGnZ+bGZ7vAL7W3CWKRWbhzYR6SO9ddNPyd9XZu78bnGSZVzolJgg3aQatELyTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xj1/Z/wk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xj1/Z/wk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7L7TP/9OZnnzF51oNsNev9tqnN7YgpLUe4b2wsOqCl4=; b=xj1/Z/wkLP41toB3OkkCB57CFj
	kcoxekeQqwtquFJE0Icw2FBkHpdDxFUMlw1ZA0BK4D6YAkVOzn4qjzOjqfmSnzNxbr/vm54gYI/D6
	4Fs+FQHZRi5y09q88u4Qx/MAu7ycGE9ca1BDLLQ8Esz24sgDz/K3KybxhgkZmVkmBp1oOppFwSnUo
	Yq1Nt3sTb/CObqbIU2MfvXosoJgoQYFYbSwwRLWzqxyZoDSGuFartYAttRVE8m016AP2tS/IcAAZI
	/7ZxG8A3c9ZwRSan/Je6pwKXTZaBGOJpJGAZovISeVXLhDgmynJ4hRM8nRENw947HJ51E6XY0XJQL
	LxDG/c6Q==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75Ry-0000000AeWr-0T7t;
	Mon, 30 Mar 2026 05:46:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: refactor GC zone selection helpers
Date: Mon, 30 Mar 2026 07:44:15 +0200
Message-ID: <20260330054533.3856339-6-hch@lst.de>
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

Merge xfs_zone_gc_ensure_target into xfs_zone_gc_select_target
to keep all zone selection code together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 45 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 3723f5293a64..6ce5a0708a9b 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -552,6 +552,9 @@ xfs_zone_gc_steal_open(
 	return 0;
 }
 
+/*
+ * Ensure we have a valid open zone to write to.
+ */
 static struct xfs_open_zone *
 xfs_zone_gc_select_target(
 	struct xfs_mount	*mp)
@@ -559,12 +562,25 @@ xfs_zone_gc_select_target(
 	struct xfs_zone_info	*zi = mp->m_zone_info;
 	struct xfs_open_zone	*oz = zi->zi_open_gc_zone;
 
+	if (oz) {
+		/*
+		 * If we have space available, just keep using the existing
+		 * zone.
+		 */
+		if (oz->oz_allocated < rtg_blocks(oz->oz_rtg))
+			return oz;
+
+		/*
+		 * Wait for all writes to the current zone to finish before
+		 * picking a new one.
+		 */
+		if (oz->oz_written < rtg_blocks(oz->oz_rtg))
+			return NULL;
+	}
+
 	/*
-	 * We need to wait for pending writes to finish.
+	 * Open a new zone when there is none currently in use.
 	 */
-	if (oz && oz->oz_written < rtg_blocks(oz->oz_rtg))
-		return NULL;
-
 	ASSERT(zi->zi_nr_open_zones <=
 		mp->m_max_open_zones - XFS_OPEN_GC_ZONES);
 	oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
@@ -576,23 +592,6 @@ xfs_zone_gc_select_target(
 	return oz;
 }
 
-/*
- * Ensure we have a valid open zone to write the GC data to.
- *
- * If the current target zone has space keep writing to it, else first wait for
- * all pending writes and then pick a new one.
- */
-static struct xfs_open_zone *
-xfs_zone_gc_ensure_target(
-	struct xfs_mount	*mp)
-{
-	struct xfs_open_zone	*oz = mp->m_zone_info->zi_open_gc_zone;
-
-	if (!oz || oz->oz_allocated == rtg_blocks(oz->oz_rtg))
-		return xfs_zone_gc_select_target(mp);
-	return oz;
-}
-
 static void
 xfs_zone_gc_end_io(
 	struct bio		*bio)
@@ -615,7 +614,7 @@ xfs_zone_gc_alloc_blocks(
 	struct xfs_mount	*mp = data->mp;
 	struct xfs_open_zone	*oz;
 
-	oz = xfs_zone_gc_ensure_target(mp);
+	oz = xfs_zone_gc_select_target(mp);
 	if (!oz)
 		return NULL;
 
@@ -1019,7 +1018,7 @@ xfs_zone_gc_should_start_new_work(
 	if (!data->scratch_available)
 		return false;
 
-	oz = xfs_zone_gc_ensure_target(data->mp);
+	oz = xfs_zone_gc_select_target(data->mp);
 	if (!oz || oz->oz_allocated == rtg_blocks(oz->oz_rtg))
 		return false;
 
-- 
2.47.3

