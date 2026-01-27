Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292892DC34E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769530037; cv=none; b=dfIHpg811R53GozT7WB+YLnKb4fDcrsV+X/O2kfNX+B/6k5YUfgBSz7jakI6XYrUrk35CiqM1r+mIs4yqwDUpfTfGFyqId3U/U9ERn2avuTBcZQh6PNphNzP0haabVtB/ZoX+WZnzriO6r+5iJdmKFa7HdNMrZH7ufjXWfuXbGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769530037; c=relaxed/simple;
	bh=7Y73zThY5PM5+qBSCYPluVK0fI1LQQUE2HChgRnxfdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MY4e4tdCb/iks/a1KmAURXjK9qXRXDJC+Jm6EtDu03U8iWAd8nIP8ba3TsBYaqAQJnEQ1ISkvo2f9hA7wQPb2Cqr6/08vXegGVwcp6e+N15AZ7qNDswExF6DdbQvAvY4q3mAA8/dWbhOMsbpG4T8Jxv6vA9cz1MpxEPQoZg6GP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PYs99NJU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PYs99NJU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HmXi24CVqn3Rfxo9dEgXGCpi5DH4bvOeRNhIlEL9Ei4=; b=PYs99NJU/Y0YMW7K4+MXzq6OUB
	LkH+Jx/gRc0/DEdhhWGDgm279d7JFJK7rC6Ec2nt7ibY6/7+TNEpE6145YiznyZWEvS3JyalJB+FX
	LDdB4sxzoPbPy5/Dl8zoxHLCmIzdf+fNHmBpdikkJm11OJCGbccGFULe7Xh8iBNUjGP9wrIuhxCYp
	4O5brljysfjSXEEFQteEO/sHyyLI6ixDXQ3yVZ0+0kYOIMroSi8VOFYmR2aptHzMaeM+aR7+/W2X6
	fW52odWmRrSN1w9T5tvNpt++Gvw3XB2mGAvgM3k+7kL5nJC9lsaBzrui74FWhVH46VFF1B3fE3jj8
	97gLC44g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklb1-0000000EbpX-1FAh;
	Tue, 27 Jan 2026 16:07:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Date: Tue, 27 Jan 2026 17:05:50 +0100
Message-ID: <20260127160619.330250-11-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127160619.330250-1-hch@lst.de>
References: <20260127160619.330250-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add counters of read, write and zone_reset operations as well as
GC written bytes to sysfs.  This way they can be easily used for
monitoring tools and test cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_stats.c   | 7 ++++++-
 fs/xfs/xfs_stats.h   | 6 ++++++
 fs/xfs/xfs_zone_gc.c | 7 +++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 9781222e0653..6d7f98afa31a 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -24,6 +24,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	uint64_t	xs_write_bytes = 0;
 	uint64_t	xs_read_bytes = 0;
 	uint64_t	defer_relog = 0;
+	uint64_t	xs_gc_write_bytes = 0;
 
 	static const struct xstats_entry {
 		char	*desc;
@@ -57,7 +58,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "rtrmapbt_mem",	xfsstats_offset(xs_rtrefcbt_2)	},
 		{ "rtrefcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
 		/* we print both series of quota information together */
-		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
+		{ "qm",			xfsstats_offset(xs_gc_read_calls)},
+		{ "zoned",		xfsstats_offset(__pad1)},
 	};
 
 	/* Loop over all stats groups */
@@ -77,6 +79,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
 		defer_relog += per_cpu_ptr(stats, i)->s.defer_relog;
+		xs_gc_write_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
 	}
 
 	len += scnprintf(buf + len, PATH_MAX-len, "xpc %llu %llu %llu\n",
@@ -89,6 +92,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 #else
 		0);
 #endif
+	len += scnprintf(buf + len, PATH_MAX-len, "gc xpc %llu\n",
+			xs_gc_write_bytes);
 
 	return len;
 }
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 15ba1abcf253..16dbbc0b72db 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -138,10 +138,16 @@ struct __xfsstats {
 	uint32_t		xs_qm_dqwants;
 	uint32_t		xs_qm_dquot;
 	uint32_t		xs_qm_dquot_unused;
+/* Zone GC counters */
+	uint32_t		xs_gc_read_calls;
+	uint32_t		xs_gc_write_calls;
+	uint32_t		xs_gc_zone_reset_calls;
+	uint32_t		__pad1;
 /* Extra precision counters */
 	uint64_t		xs_xstrat_bytes;
 	uint64_t		xs_write_bytes;
 	uint64_t		xs_read_bytes;
+	uint64_t		xs_gc_write_bytes;
 	uint64_t		defer_relog;
 };
 
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 570102184904..4bb647d3be41 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -712,6 +712,8 @@ xfs_zone_gc_start_chunk(
 	data->scratch_head = (data->scratch_head + len) % data->scratch_size;
 	data->scratch_available -= len;
 
+	XFS_STATS_INC(mp, xs_gc_read_calls);
+
 	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 	list_add_tail(&chunk->entry, &data->reading);
 	xfs_zone_gc_iter_advance(iter, irec.rm_blockcount);
@@ -815,6 +817,9 @@ xfs_zone_gc_write_chunk(
 		return;
 	}
 
+	XFS_STATS_INC(mp, xs_gc_write_calls);
+	XFS_STATS_ADD(mp, xs_gc_write_bytes, chunk->len);
+
 	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 	list_move_tail(&chunk->entry, &data->writing);
 
@@ -911,6 +916,8 @@ xfs_submit_zone_reset_bio(
 		return;
 	}
 
+	XFS_STATS_INC(mp, xs_gc_zone_reset_calls);
+
 	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
 	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
 		/*
-- 
2.47.3

