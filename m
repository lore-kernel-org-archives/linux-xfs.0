Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716DB408226
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970788; cv=none; b=uBwYzqcaJkDvvzrIIZ1BsH4IYIp0QgAQJuz0K76ktTgFqFItSYULMhsDnQAMD4RPpBiw6ZG/LuMMr/Ev550leiQUyBYZ+fOBKQVH3u6cFHH/mtmfPq+MnlLkMr6wBi/3y2jiXpFnxIEUKzwFc0nTFSuLVM2jByi7uuj5CTqrAZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970788; c=relaxed/simple;
	bh=MvnSLhslWGrP1lrAwcf58a6/Y8e24XIVrbLmfjgZpqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHC6InekVheDLWxh5rpGul6h2saVbZcaxFriloPUSRPtOS4VMWX3FOINrphtU+xeHMRqTktUiOB+9z/apk+Be3YvGBIkDdB5o6+2Wj4dr1qvmthCYkdRgO0VZichu8VNlJU5XdQc81gHjXVWvZg1qyJESq8wE88O6o3AA9Gmhpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o7T9nP9m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o7T9nP9m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0YAuqth3DE8FiQqxoQSa1tGMbyj/B2mobcoL0kIEgS0=; b=o7T9nP9myZtly0F8eQIqnwP1bf
	96c/MMLlCKvJ0xKHF8zockRMsAWX3IrPXHivmv4Zdmgy97eOtt6Z0eA/le5HJvOhe3uNp70zqv5EZ
	aBCwnX5/wA/wvcfIF9nUi0f9n5AHszZiU/V9EwVCATuU0tgwwJS89TwpKOqY88ojiP9/TkXJmFb/q
	H2XT13/qFpHwVzhXZmMbs4e9ChoFWuDVCOSaI5R5FQRszfpgEcCU3AIxt3JnIQO+mhXj2OkM5+/Jz
	11r8fhDiTz12JFzPTNwT0CG2G7plVkipw8FPV03crYz4zKz164I/V9Bn/2KlSlWI/Hlair7jxGDxr
	ZAZpCw5g==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7az4-0000000DAy5-2r95;
	Tue, 31 Mar 2026 15:26:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: handle too many open zones when mounting
Date: Tue, 31 Mar 2026 17:26:06 +0200
Message-ID: <20260331152617.4047908-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152617.4047908-1-hch@lst.de>
References: <20260331152617.4047908-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When running on conventional zones or devices, the zoned allocator does
not have a real write pointer, but instead fakes it up at mount time
based on the last block recorded in the rmap.  This can create spurious
"open" zones when the last written blocks in a conventional zone are
invalidated.  Add a loop to the mount code to find the conventional zone
with the highest used block in the rmap tree and "finish" it until we
are below the open zones limit.

While we're at it, also error out if there are too many open sequential
zones, which can only happen when the user overrode the max open zones
limit (or with really buggy hardware reducing the limit, but not much
we can do about that).

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_trace.h      |  1 +
 fs/xfs/xfs_zone_alloc.c | 75 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 60d1e605dfa5..c5ad26a1d7bb 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -461,6 +461,7 @@ DEFINE_EVENT(xfs_zone_alloc_class, name,			\
 DEFINE_ZONE_ALLOC_EVENT(xfs_zone_record_blocks);
 DEFINE_ZONE_ALLOC_EVENT(xfs_zone_skip_blocks);
 DEFINE_ZONE_ALLOC_EVENT(xfs_zone_alloc_blocks);
+DEFINE_ZONE_ALLOC_EVENT(xfs_zone_spurious_open);
 
 TRACE_EVENT(xfs_zone_gc_select_victim,
 	TP_PROTO(struct xfs_rtgroup *rtg, unsigned int bucket),
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index e9f1d9d08620..5f8b6cbeebfd 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1253,6 +1253,77 @@ xfs_report_zones(
 	return 0;
 }
 
+static inline bool
+xfs_zone_is_conv(
+	struct xfs_rtgroup	*rtg)
+{
+	return !bdev_zone_is_seq(rtg_mount(rtg)->m_rtdev_targp->bt_bdev,
+			xfs_gbno_to_daddr(rtg_group(rtg), 0));
+}
+
+static struct xfs_open_zone *
+xfs_find_fullest_conventional_open_zone(
+	struct xfs_mount	*mp)
+{
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	struct xfs_open_zone	*found = NULL, *oz;
+
+	spin_lock(&zi->zi_open_zones_lock);
+	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry) {
+		if (!xfs_zone_is_conv(oz->oz_rtg))
+			continue;
+		if (!found || oz->oz_allocated > found->oz_allocated)
+			found = oz;
+	}
+	spin_unlock(&zi->zi_open_zones_lock);
+
+	return found;
+}
+
+/*
+ * Find the fullest conventional zones and remove them from the open zone pool
+ * until we are at the open zone limit.
+ *
+ * We can end up with spurious "open" zones when the last blocks in a fully
+ * written zone were invalidate as there is no write pointer for conventional
+ * zones.
+ *
+ * If we are still over the limit when there is no conventional open zone left,
+ * the user overrode the max open zones limit using the max_open_zones mount
+ * option we should fail.
+ */
+static int
+xfs_finish_spurious_open_zones(
+	struct xfs_mount	*mp,
+	struct xfs_init_zones	*iz)
+{
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+
+	while (zi->zi_nr_open_zones > mp->m_max_open_zones) {
+		struct xfs_open_zone	*oz;
+		xfs_filblks_t		adjust;
+
+		oz = xfs_find_fullest_conventional_open_zone(mp);
+		if (!oz) {
+			xfs_err(mp,
+"too many open zones for max_open_zones limit (%u/%u)",
+			zi->zi_nr_open_zones, mp->m_max_open_zones);
+			return -EINVAL;
+		}
+
+		xfs_rtgroup_lock(oz->oz_rtg, XFS_RTGLOCK_RMAP);
+		adjust = rtg_blocks(oz->oz_rtg) - oz->oz_written;
+		trace_xfs_zone_spurious_open(oz, oz->oz_written, adjust);
+		oz->oz_written = rtg_blocks(oz->oz_rtg);
+		xfs_open_zone_mark_full(oz);
+		xfs_rtgroup_unlock(oz->oz_rtg, XFS_RTGLOCK_RMAP);
+		iz->available -= adjust;
+		iz->reclaimable += adjust;
+	}
+
+	return 0;
+}
+
 int
 xfs_mount_zones(
 	struct xfs_mount	*mp)
@@ -1294,6 +1365,10 @@ xfs_mount_zones(
 	if (error)
 		goto out_free_zone_info;
 
+	error = xfs_finish_spurious_open_zones(mp, &iz);
+	if (error)
+		goto out_free_zone_info;
+
 	xfs_set_freecounter(mp, XC_FREE_RTAVAILABLE, iz.available);
 	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
 			iz.available + iz.reclaimable);
-- 
2.47.3

