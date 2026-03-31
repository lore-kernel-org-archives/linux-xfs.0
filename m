Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82529405AD2
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970894; cv=none; b=fg/ih1aM6khkQQjXx6oSLJYx++Eh9JulT+PCqwgPLMHu1MLowPeq8IQ0glKLRxJlMSTB9av5/L+kmIIhdNucPUmyraegxoACaP/uCMz8Su6483MnQ1SYeVkxXAXmbqrNGC2nEv6RTIcw4g0x0sNqKNxs6jGgC5W8UKGqDjTBqvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970894; c=relaxed/simple;
	bh=S3g0mN7baehHSNasOcNT4V/KbeNTJj1Etjpb97Sus+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjuy80KzJJgxbNh/iHnshYVgJj3pZbBa3qWz8BHUEjQo68Pvso+yBX6INGCtjiZyGGDxpzIGRgsDOoyljASgF2dkjANEijG5LeJ+UzoT5+9rFTphzKIFOosaiOlcdLr9ZmCBABpCFrH3ECFrkCIgt+5GuI+bSUHTeiwqOu77QfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pdRIgJrD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pdRIgJrD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=svRJkjbPq7C3OyJY78J7sowEiFVPfv8NrRKa5lY+X3o=; b=pdRIgJrDewnIbtO28YfN1mDpcF
	qny50848DW0qGrLScMGIESHBtr7nrsywe0nv3aHiRcSGilUousHM/feASvSigMtC5Zu0FcsSTZ+nM
	FZE+hKfq9V9YJVBrAr3HvtbZAf8joS73ka8Owcc5U+NKxPQlscizJARRLZrTHs+RmkFDJmlccqBc+
	kq4UztckxjmKgk8oo35Zx6XHrlOdMvxPslJisllj2IWGx85OhMGFJRby9BMh0bjUaPO26z223cWlI
	etodYWKwVHNHnqMWvU1JVPaxe9bEWi/5Ny9FUiQ36snZFaqnyEE6Zy5tVRa2S3I48UedWHiDmKQvv
	N6O1Sp/w==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7b0m-0000000DBEn-38Nk;
	Tue, 31 Mar 2026 15:28:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 5/9] xfs: refactor GC zone selection helpers
Date: Tue, 31 Mar 2026 17:27:27 +0200
Message-ID: <20260331152751.4048218-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152751.4048218-1-hch@lst.de>
References: <20260331152751.4048218-1-hch@lst.de>
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
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_zone_gc.c | 45 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index cd4f52af295e..0f62051b0acc 100644
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

