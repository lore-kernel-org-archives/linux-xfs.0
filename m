Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3BA2DA77E
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750459; cv=none; b=skGs94UZbYc1dHhFpe29suK0B3yqQ5ui3OT9mKv3CvMmylAlbYJqKn7MuUGZRtYpNYm7hH/cjiZ3x7Uv5sQ6iA0IPhnVqp/uhNe65aqMHugTWMV35AG0j+VgaeQzFBZUFjy9SVQaGwAXa6scW/gktTyUHgusyrlQWkjC0sUb1VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750459; c=relaxed/simple;
	bh=aQ8U89uWnW+f7VTXnJ1aUSXovvRdWhZX8VLvxcttHdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlvPEv2FAcY3Kn5Y5gAjwyjAI9lb+FF54vtDonibJH3c5eygA0mq2WHiN7CN1Rb5c0Bk91hBg03bOw+RmAkS2TN1+3ort+9UzfRxFeFPnAYpoNxeSqx9zmz4n5RWOuIoArE+kBk3ZUwx0NHWX/Q+IUZ3iu5uW9R8c5dWLrR66WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RnpDg4pR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RnpDg4pR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VfSQ1XnYPX19YOdlbRhGhOtg44KfuO0i5gU4vR0po1g=; b=RnpDg4pRW13Gi9LThNCM1hfbR4
	QEHE82JALAd4gQznJXtm/wTBdQFBXvSnJpmcTEFxxbDhL1osEcB5ORuW8yXlwMEK/aRaL9AjwcdAZ
	9fkct5TURS9MEQJbrdcuyBtDYhZWM6o52Z7TmH/tL8RS/blFNDsPca3314L6o8kT1rBolkFdgt3L0
	Dr2b9RGk8bFQTTq8/cJ4bF/tq6b3Ge5IVk9nPRYsnKtGcACk6BSnAEkVTz8AtfeXQW9tQyuAyApqk
	AoaUJJ4qBnfuXluLTlBLmtU29vO3wnJg9G7gxOXA/807rOsTC/pgKylMdFCIsxrpreEplte0dy13f
	FKqTr/Hg==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgwD-000000013Jd-1o2B;
	Fri, 30 Jan 2026 05:20:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 11/11] xfs: add sysfs stats for zoned GC
Date: Fri, 30 Jan 2026 06:19:26 +0100
Message-ID: <20260130052012.171568-12-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_stats.c   | 6 +++++-
 fs/xfs/xfs_stats.h   | 6 ++++++
 fs/xfs/xfs_zone_gc.c | 7 +++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 3fe1f5412537..017db0361cd8 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -24,6 +24,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	uint64_t	xs_write_bytes = 0;
 	uint64_t	xs_read_bytes = 0;
 	uint64_t	xs_defer_relog = 0;
+	uint64_t	xs_gc_bytes = 0;
 
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
 		xs_defer_relog += per_cpu_ptr(stats, i)->s.xs_defer_relog;
+		xs_gc_bytes += per_cpu_ptr(stats, i)->s.xs_gc_bytes;
 	}
 
 	len += scnprintf(buf + len, PATH_MAX-len, "xpc %llu %llu %llu\n",
@@ -89,6 +92,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 #else
 		0);
 #endif
+	len += scnprintf(buf + len, PATH_MAX-len, "gc xpc %llu\n", xs_gc_bytes);
 
 	return len;
 }
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index d86c6ce35010..153d2381d0a8 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -138,11 +138,17 @@ struct __xfsstats {
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
 	uint64_t		xs_defer_relog;
+	uint64_t		xs_gc_bytes;
 };
 
 #define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 570102184904..1f1f9fc973af 100644
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
+	XFS_STATS_ADD(mp, xs_gc_bytes, chunk->len);
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

