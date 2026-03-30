Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7FB3845C9
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849575; cv=none; b=aPCEgru7YD7yr/pg3uidCeJCbYZERP/rgmNpDbMFtfPbeJ5gxuvGKp4mX15U5cJiUfbJ/doCMNVk7pSS18tiARncaqAZb0zZ8SyEl1muARlNBr0OkIVRQGpBd9DTFzaa5BAq6MKH7pTwLHJ1WQFbVCCilHHGS46Su0lRNFKtIio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849575; c=relaxed/simple;
	bh=YRWZwk65xIadSWshTPle9zZ3rOQ/479eP2NOQJczR6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZNXmarqp+WEZ3UvNwi/8TqFrwSB8+bXKRjmPZtwXGammFDXe11VuT9fxm9OaAD6YvjmJn5jq8APCKYtAC5kzA3lSqOfqtHgwDN44i2niv6VzFlh0phFEPttmeXsY41eIYBDI5onaGZcioGSMfG05CYyBo72GZoRhkoPxYr/dlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JnpOFs+p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JnpOFs+p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DWIu6zmGamgXOdNLvoSATBuUpDAP9ch4cnlnUeFAn98=; b=JnpOFs+p1woGxPsk3YSzCA+7XR
	SyejsZLgAf1HLyM1P+aOQyfSXcSUfacOaSEwug+2suMlXhqhyLP8DW1GMS43ZeWT8EWGD+ZCKLxHz
	TzaNra1ccZsHVqkoH5GboJo8SLeI6FKSETD/aRMEq7XsUjCw1mlVK/tlEykG/TH8vIC/L4p9wdYYh
	Cscbest/ksDp+ErQv2PGVSXgK09JOy4VevmKzGiHN05y+sDdk1RdHxEE1GPAppNuY6P8AtJoUV6HM
	GwFZcFPBk9ZcC8hCtjWshJmr8zosq2ky/yD0XhSTT2iIKC78nE1c1++tZxD0ubdIBVGDITjMLGyL4
	C77FhoyQ==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75S1-0000000AeWy-2vJx;
	Mon, 30 Mar 2026 05:46:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] xfs: streamline GC zone selection
Date: Mon, 30 Mar 2026 07:44:16 +0200
Message-ID: <20260330054533.3856339-7-hch@lst.de>
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

Currently picking of the GC target zone is done a bit odd, both in the
main "can we start new GC cycles" routine and in the low-level block
allocator for GC.  This was mostly done to work around the rules for
when code in a waitqueue wait loop can sleep.

But there is a trick to check if the process state has been set to
running to discover if the wait loop has to be retried all this becomes
much simpler.  So we can just select a GC zone just before writing,
and bail out of starting new work if we can't find usable zone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 95 +++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 6ce5a0708a9b..24f20f99ae1a 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -383,9 +383,6 @@ xfs_zone_gc_iter_irec(
 	struct xfs_rmap_irec	*irec;
 	int			error;
 
-	if (!iter->victim_rtg)
-		return false;
-
 retry:
 	if (iter->rec_idx == iter->rec_count) {
 		error = xfs_zone_gc_query(mp, iter);
@@ -555,7 +552,7 @@ xfs_zone_gc_steal_open(
 /*
  * Ensure we have a valid open zone to write to.
  */
-static struct xfs_open_zone *
+static bool
 xfs_zone_gc_select_target(
 	struct xfs_mount	*mp)
 {
@@ -568,14 +565,14 @@ xfs_zone_gc_select_target(
 		 * zone.
 		 */
 		if (oz->oz_allocated < rtg_blocks(oz->oz_rtg))
-			return oz;
+			return true;
 
 		/*
 		 * Wait for all writes to the current zone to finish before
 		 * picking a new one.
 		 */
 		if (oz->oz_written < rtg_blocks(oz->oz_rtg))
-			return NULL;
+			return false;
 	}
 
 	/*
@@ -589,7 +586,7 @@ xfs_zone_gc_select_target(
 	spin_lock(&zi->zi_open_zones_lock);
 	zi->zi_open_gc_zone = oz;
 	spin_unlock(&zi->zi_open_zones_lock);
-	return oz;
+	return !!oz;
 }
 
 static void
@@ -604,7 +601,7 @@ xfs_zone_gc_end_io(
 	wake_up_process(data->mp->m_zone_info->zi_gc_thread);
 }
 
-static struct xfs_open_zone *
+static bool
 xfs_zone_gc_alloc_blocks(
 	struct xfs_zone_gc_data	*data,
 	xfs_extlen_t		*count_fsb,
@@ -612,11 +609,7 @@ xfs_zone_gc_alloc_blocks(
 	bool			*is_seq)
 {
 	struct xfs_mount	*mp = data->mp;
-	struct xfs_open_zone	*oz;
-
-	oz = xfs_zone_gc_select_target(mp);
-	if (!oz)
-		return NULL;
+	struct xfs_open_zone	*oz = mp->m_zone_info->zi_open_gc_zone;
 
 	*count_fsb = min(*count_fsb, XFS_B_TO_FSB(mp, data->scratch_available));
 
@@ -638,7 +631,7 @@ xfs_zone_gc_alloc_blocks(
 	spin_unlock(&mp->m_sb_lock);
 
 	if (!*count_fsb)
-		return NULL;
+		return false;
 
 	*daddr = xfs_gbno_to_daddr(rtg_group(oz->oz_rtg), 0);
 	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *daddr);
@@ -646,7 +639,7 @@ xfs_zone_gc_alloc_blocks(
 		*daddr += XFS_FSB_TO_BB(mp, oz->oz_allocated);
 	oz->oz_allocated += *count_fsb;
 	atomic_inc(&oz->oz_ref);
-	return oz;
+	return true;
 }
 
 static void
@@ -671,6 +664,28 @@ xfs_zone_gc_add_data(
 	} while (len);
 }
 
+static bool
+xfs_zone_gc_can_start_chunk(
+	struct xfs_zone_gc_data	*data)
+{
+
+	if (xfs_is_shutdown(data->mp))
+		return false;
+	if (!data->scratch_available)
+		return false;
+
+	if (!data->iter.victim_rtg) {
+		if (kthread_should_stop() || kthread_should_park())
+			return false;
+		if (!xfs_zoned_need_gc(data->mp))
+			return false;
+		if (!xfs_zone_gc_select_victim(data))
+			return false;
+	}
+
+	return xfs_zone_gc_select_target(data->mp);
+}
+
 static bool
 xfs_zone_gc_start_chunk(
 	struct xfs_zone_gc_data	*data)
@@ -678,7 +693,6 @@ xfs_zone_gc_start_chunk(
 	struct xfs_zone_gc_iter	*iter = &data->iter;
 	struct xfs_mount	*mp = data->mp;
 	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
-	struct xfs_open_zone	*oz;
 	struct xfs_rmap_irec	irec;
 	struct xfs_gc_bio	*chunk;
 	struct xfs_inode	*ip;
@@ -687,14 +701,15 @@ xfs_zone_gc_start_chunk(
 	unsigned int		len;
 	bool			is_seq;
 
-	if (xfs_is_shutdown(mp))
+	if (!xfs_zone_gc_can_start_chunk(data))
 		return false;
 
+	set_current_state(TASK_RUNNING);
 	if (!xfs_zone_gc_iter_irec(mp, iter, &irec, &ip))
 		return false;
-	oz = xfs_zone_gc_alloc_blocks(data, &irec.rm_blockcount, &daddr,
-			&is_seq);
-	if (!oz) {
+
+	if (!xfs_zone_gc_alloc_blocks(data, &irec.rm_blockcount, &daddr,
+			&is_seq)) {
 		xfs_irele(ip);
 		return false;
 	}
@@ -713,7 +728,7 @@ xfs_zone_gc_start_chunk(
 	chunk->new_daddr = daddr;
 	chunk->is_seq = is_seq;
 	chunk->data = data;
-	chunk->oz = oz;
+	chunk->oz = mp->m_zone_info->zi_open_gc_zone;
 	chunk->victim_rtg = iter->victim_rtg;
 	atomic_inc(&rtg_group(chunk->victim_rtg)->xg_active_ref);
 	atomic_inc(&chunk->victim_rtg->rtg_gccount);
@@ -1007,33 +1022,6 @@ xfs_zone_gc_reset_zones(
 	} while (next);
 }
 
-static bool
-xfs_zone_gc_should_start_new_work(
-	struct xfs_zone_gc_data	*data)
-{
-	struct xfs_open_zone	*oz;
-
-	if (xfs_is_shutdown(data->mp))
-		return false;
-	if (!data->scratch_available)
-		return false;
-
-	oz = xfs_zone_gc_select_target(data->mp);
-	if (!oz || oz->oz_allocated == rtg_blocks(oz->oz_rtg))
-		return false;
-
-	if (!data->iter.victim_rtg) {
-		if (kthread_should_stop() || kthread_should_park())
-			return false;
-		if (!xfs_zoned_need_gc(data->mp))
-			return false;
-		if (!xfs_zone_gc_select_victim(data))
-			return false;
-	}
-
-	return true;
-}
-
 /*
  * Handle the work to read and write data for GC and to reset the zones,
  * including handling all completions.
@@ -1083,13 +1071,10 @@ xfs_zone_gc_handle_work(
 	}
 	blk_finish_plug(&plug);
 
-	if (xfs_zone_gc_should_start_new_work(data)) {
-		set_current_state(TASK_RUNNING);
-		blk_start_plug(&plug);
-		while (xfs_zone_gc_start_chunk(data))
-			;
-		blk_finish_plug(&plug);
-	}
+	blk_start_plug(&plug);
+	while (xfs_zone_gc_start_chunk(data))
+		;
+	blk_finish_plug(&plug);
 }
 
 /*
-- 
2.47.3

