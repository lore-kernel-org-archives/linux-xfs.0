Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57A926FD84
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 06:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760509775; cv=none; b=m7z6bbVSzb0dPWQChdbyK/cmvBrW65PC0SJF2dPQbT+ktGImvJRxXsD9mw8tDxNxvjj/R2UbsvcWYxvs/sZGBZdwTclAT1t+yjE8erz2dkW4SikwpdHuYSeqD89IXZcRveEqvzZTmh3oA4tV1N8BzcOCdY4kCVMIHKt7PJjHG4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760509775; c=relaxed/simple;
	bh=4lTcE3HGMbm4hIzWQiVOiRkgCaURzJaZjg9FLCEDmic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SnEB3ccsKLYWHtcyA6XnrBFKL7QSaMnoQ1OLEJKpMoGcrfyAPHJAErQFqyZq9R+8Kaek2Z2e/aWmNcHASINKEy/wK6p/741Nf/HZYJngoDCqT1ZVEi05Lh9/ZgIg5iAFdTIf1bLhSMruU3EzyjZdPpvfRcnMV5pLxgDk/u4nJBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xG0EphKV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xG0EphKV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=VW0C5A0Bdr8S4rJJqKk2V0SfzYQbg4QN6e+m7AvPGws=; b=xG0EphKVi+5F1lzQumHuzSko6H
	UiIbGj3tkB5t38ytGAVAab3981I6cJD6plS9OidTfka97xBQldbY8PdWvwG27zN4IHjhiUSGwVOp/
	oy1SpstOxfMPR4ZBsR02hX/rolmUhPdFR/ktMfaKE8Um8beqeYBHhGfvNng3DO0YR1ae6FGBJTlc4
	A2AFsvGhR7lyMWwPdZAYWWorYRnm1d6O7/EFUV7cXPOXe9+pk2bu9G+jcklDLg28rWH5NzBQF38fg
	zDxtCnpRTD7uKBltvbX774IEV8o1Gg7x6/vmnrUaF44Jp4/fl+08FN3+tIpu8dUInC0MAYIAUX6UU
	OezgtK6g==;
Received: from [38.87.93.141] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8v0v-00000000bSv-0HyD;
	Wed, 15 Oct 2025 06:29:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: avoid busy loops in GCD
Date: Wed, 15 Oct 2025 15:29:30 +0900
Message-ID: <20251015062930.60765-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When GCD has no new work to handle, but read, write or reset commands
are outstanding, it currently busy loops, which is a bit suboptimal,
and can lead to softlockup warnings in case of stuck commands.

Change the code so that the task state is only set to running when work
is performed, which looks a bit tricky due to the design of the
reading/writing/resetting lists that contain both in-flight and finished
commands.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 81 +++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 064cd1a857a0..109877d9a6bf 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -491,21 +491,6 @@ xfs_zone_gc_select_victim(
 	struct xfs_rtgroup	*victim_rtg = NULL;
 	unsigned int		bucket;
 
-	if (xfs_is_shutdown(mp))
-		return false;
-
-	if (iter->victim_rtg)
-		return true;
-
-	/*
-	 * Don't start new work if we are asked to stop or park.
-	 */
-	if (kthread_should_stop() || kthread_should_park())
-		return false;
-
-	if (!xfs_zoned_need_gc(mp))
-		return false;
-
 	spin_lock(&zi->zi_used_buckets_lock);
 	for (bucket = 0; bucket < XFS_ZONE_USED_BUCKETS; bucket++) {
 		victim_rtg = xfs_zone_gc_pick_victim_from(mp, bucket);
@@ -975,6 +960,27 @@ xfs_zone_gc_reset_zones(
 	} while (next);
 }
 
+static bool
+xfs_zone_gc_should_start_new_work(
+	struct xfs_zone_gc_data	*data)
+{
+	if (xfs_is_shutdown(data->mp))
+		return false;
+	if (!xfs_zone_gc_space_available(data))
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
+	return true;
+}
+
 /*
  * Handle the work to read and write data for GC and to reset the zones,
  * including handling all completions.
@@ -982,7 +988,7 @@ xfs_zone_gc_reset_zones(
  * Note that the order of the chunks is preserved so that we don't undo the
  * optimal order established by xfs_zone_gc_query().
  */
-static bool
+static void
 xfs_zone_gc_handle_work(
 	struct xfs_zone_gc_data	*data)
 {
@@ -996,30 +1002,22 @@ xfs_zone_gc_handle_work(
 	zi->zi_reset_list = NULL;
 	spin_unlock(&zi->zi_reset_list_lock);
 
-	if (!xfs_zone_gc_select_victim(data) ||
-	    !xfs_zone_gc_space_available(data)) {
-		if (list_empty(&data->reading) &&
-		    list_empty(&data->writing) &&
-		    list_empty(&data->resetting) &&
-		    !reset_list)
-			return false;
-	}
-
-	__set_current_state(TASK_RUNNING);
-	try_to_freeze();
-
-	if (reset_list)
+	if (reset_list) {
+		set_current_state(TASK_RUNNING);
 		xfs_zone_gc_reset_zones(data, reset_list);
+	}
 
 	list_for_each_entry_safe(chunk, next, &data->resetting, entry) {
 		if (READ_ONCE(chunk->state) != XFS_GC_BIO_DONE)
 			break;
+		set_current_state(TASK_RUNNING);
 		xfs_zone_gc_finish_reset(chunk);
 	}
 
 	list_for_each_entry_safe(chunk, next, &data->writing, entry) {
 		if (READ_ONCE(chunk->state) != XFS_GC_BIO_DONE)
 			break;
+		set_current_state(TASK_RUNNING);
 		xfs_zone_gc_finish_chunk(chunk);
 	}
 
@@ -1027,15 +1025,18 @@ xfs_zone_gc_handle_work(
 	list_for_each_entry_safe(chunk, next, &data->reading, entry) {
 		if (READ_ONCE(chunk->state) != XFS_GC_BIO_DONE)
 			break;
+		set_current_state(TASK_RUNNING);
 		xfs_zone_gc_write_chunk(chunk);
 	}
 	blk_finish_plug(&plug);
 
-	blk_start_plug(&plug);
-	while (xfs_zone_gc_start_chunk(data))
-		;
-	blk_finish_plug(&plug);
-	return true;
+	if (xfs_zone_gc_should_start_new_work(data)) {
+		set_current_state(TASK_RUNNING);
+		blk_start_plug(&plug);
+		while (xfs_zone_gc_start_chunk(data))
+			;
+		blk_finish_plug(&plug);
+	}
 }
 
 /*
@@ -1059,8 +1060,18 @@ xfs_zoned_gcd(
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
 		xfs_set_zonegc_running(mp);
-		if (xfs_zone_gc_handle_work(data))
+
+		xfs_zone_gc_handle_work(data);
+
+		/*
+		 * Only sleep if nothing set the state to running.  Else check for
+		 * work again as someone might have queued up more work and woken
+		 * us in the meantime.
+		 */
+		if (get_current_state() == TASK_RUNNING) {
+			try_to_freeze();
 			continue;
+		}
 
 		if (list_empty(&data->reading) &&
 		    list_empty(&data->writing) &&
-- 
2.47.3

