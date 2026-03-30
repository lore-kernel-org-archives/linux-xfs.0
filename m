Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAF63822B7
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849292; cv=none; b=PVYXl+mIE1F4poL97+/rXm7w06ZpBxhejOMBsrifE78VEVUkfBm6yt4FH6N6srg3z+1RXsMc/spX7dC6unokQVZRUSlAmx3+9n6wMaQqWPScCyz+mgCjWcOjGbbCEZ8wWiBv5c2i0u+P7VkxVy9EZ4I4XLdK8WI6sOJojEoTjpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849292; c=relaxed/simple;
	bh=0BADEZdmi26+6EuNIn4N1CjGzi6TY409RMZg5eGC74E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjrVEGJAUQ3VinCDWtX3pyPHbFHoCsJ2jArV+J8SuDJK8vWWUHykMqHB2iICRckLVPVpx79O122pfm8DBrsoXhb4o7rGhQW0WD5WcGIl9PJeJFkKrew/qRS0Uj8YSL1eC81weVprEVsrZ+E30Vlc+CNvG3G6q/iyhivN+r9R3hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JOE4o24B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JOE4o24B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bLQTRUMPTOtBwWK9ziROQ0Xu7X0e31H/hCv3Ll8ImfU=; b=JOE4o24B5PZ337GGdZSBRKAdGA
	jt5UQnjzonV5HNlTK8fzJCcXop2JQl1h3QmfHbjuFeDTwsFHSTPnO0wsuOO7+F1e4uenKphNhNWko
	33IHa+4pKoNNG8w2Q6PsuidDYjM42QwOo8EQpb12DffY+7+7W2if1K1FIn+eUYENkGWCC7cRjP8Q0
	5gZUNe5Z5JN+GVVCmXNKpB6osE1NdgCspXsnuvnGCIPv7OSJdEITppHXE6WXn3iUq4rD1TbKzQz/E
	kHaXurXmf+4accrHj+pn7VFZIj2IsorpaBnLakd8v5yLxrMri9/V07dq/AwGhAXJL9n+NwVWqJf++
	7LhosCCQ==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75NP-0000000AeOO-2Uut;
	Mon, 30 Mar 2026 05:41:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: handle too many open zones when mounting
Date: Mon, 30 Mar 2026 07:40:58 +0200
Message-ID: <20260330054111.3855818-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330054111.3855818-1-hch@lst.de>
References: <20260330054111.3855818-1-hch@lst.de>
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
invalidated.  Add a loop to the mount code to find the conventional zones
with the most used space and "finish" them.

While we're at it, also error out if there are too many open sequential
zones, which can only happen when the user overrode the max open zones
limit (or with really buggy hardware reducing the limit, but not much
we can do about that).

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trace.h      |  1 +
 fs/xfs/xfs_zone_alloc.c | 74 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5e8190fe2be9..433f84252119 100644
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
index e9f1d9d08620..b0a6bc777c36 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1253,6 +1253,76 @@ xfs_report_zones(
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
+ * zone.
+ *
+ * If we are still over the limit when there is no conventional open zone left,
+ * the user manually overrode the max open zones limit and we should fail.
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
@@ -1294,6 +1364,10 @@ xfs_mount_zones(
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

