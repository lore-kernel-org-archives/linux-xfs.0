Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C17D35EDB2
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 15:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526643; cv=none; b=Q+Ivuv7xyCS0u01K9kchZHmnsfbOF+XxO5NQ4MnirZKSVG9CtGpZt0uZhfeEhBxFY3a5KxNYoKcNsS5BjL0iDRskwC6R3LgBGDfTerhzxxZ3xvV/ffndaETKM/xqISKlncllBzQ1eJ+3QyaOByBBX91GANnD+fTcl7egVf92C1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526643; c=relaxed/simple;
	bh=m1FL1DhFhA9/xR2dkCKPeSbdZlTGgnxn2MQcxCCwM1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqMlI+BW2FxXwyn6ny/a+0aWJq4eHDZn018TPCzgH9XOBxuHLY+Oi8FJ4C0c56GAkFvwFMX9ZJZ6aZGOIr0XkUjgAzlqrxVcbJ7ZNh+JdEdnKBrkTGwddy+NvAbAtr2Mj6f6+nOgJTsk/pdzXhl+CLWXZAaycuXEYgGfGW4Euck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZpPyTTyw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZpPyTTyw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3DO+NSHGfxxq6aLgLh+YJJE7ayYzUI8ZNHL5NOZkHPY=; b=ZpPyTTyw/DroAxscohw1Owg2zu
	uByDfkWZuz7j6K16Rwh7G7z68NNaBbvcqASsSDJ4Kj9MQpWhQkD1Uyem8g3EO7rjBl4aOaJHryG32
	9DA0hkZKKzSwfg/dOftVGuF1cxnoMnM+lqxlWbirxS5HV9P1I9ipZWAnszFJv2BwGmwN+fx3d3RlG
	YYVy8p6J+/9sps/4NPFaw/8gCWrqBrU4AnJqxQZB2ZA4dprxBSBDziefM7ZJZspOrVbWFhmgv35NT
	zzztp+1ew9dmbDE2Legrr0+qmBavC8uD58DQX4uwb+PLmBUTSo/04AIsTiWMuGlwaMIPW6fpXfUFe
	yEaKBnGQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkkiD-0000000EVXJ-1gKl;
	Tue, 27 Jan 2026 15:10:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chris Mason <clm@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: use a seprate member to track space availabe in the GC scatch buffer
Date: Tue, 27 Jan 2026 16:10:20 +0100
Message-ID: <20260127151026.299341-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127151026.299341-1-hch@lst.de>
References: <20260127151026.299341-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When scratch_head wraps back to 0 and scratch_tail is also 0 because no
I/O has completed yet, the ring buffer could be mistaken for empty.

Fix this by introducing a separate scratch_available member in
struct xfs_zone_gc_data.  This actually ends up simplifying the code as
well.

Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index dfa6653210c7..8c08e5519bff 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -131,10 +131,13 @@ struct xfs_zone_gc_data {
 	/*
 	 * Scratchpad to buffer GC data, organized as a ring buffer over
 	 * discontiguous folios.  scratch_head is where the buffer is filled,
-	 * and scratch_tail tracks the buffer space freed.
+	 * scratch_tail tracks the buffer space freed, and scratch_available
+	 * counts the space available in the ring buffer between the head and
+	 * the tail.
 	 */
 	struct folio			*scratch_folios[XFS_GC_NR_BUFS];
 	unsigned int			scratch_size;
+	unsigned int			scratch_available;
 	unsigned int			scratch_head;
 	unsigned int			scratch_tail;
 
@@ -212,6 +215,7 @@ xfs_zone_gc_data_alloc(
 			goto out_free_scratch;
 	}
 	data->scratch_size = XFS_GC_BUF_SIZE * XFS_GC_NR_BUFS;
+	data->scratch_available = data->scratch_size;
 	INIT_LIST_HEAD(&data->reading);
 	INIT_LIST_HEAD(&data->writing);
 	INIT_LIST_HEAD(&data->resetting);
@@ -574,18 +578,6 @@ xfs_zone_gc_ensure_target(
 	return oz;
 }
 
-static unsigned int
-xfs_zone_gc_scratch_available(
-	struct xfs_zone_gc_data	*data)
-{
-	if (!data->scratch_tail)
-		return data->scratch_size - data->scratch_head;
-
-	if (!data->scratch_head)
-		return data->scratch_tail;
-	return (data->scratch_size - data->scratch_head) + data->scratch_tail;
-}
-
 static bool
 xfs_zone_gc_space_available(
 	struct xfs_zone_gc_data	*data)
@@ -596,7 +588,7 @@ xfs_zone_gc_space_available(
 	if (!oz)
 		return false;
 	return oz->oz_allocated < rtg_blocks(oz->oz_rtg) &&
-		xfs_zone_gc_scratch_available(data);
+		data->scratch_available;
 }
 
 static void
@@ -625,8 +617,7 @@ xfs_zone_gc_alloc_blocks(
 	if (!oz)
 		return NULL;
 
-	*count_fsb = min(*count_fsb,
-		XFS_B_TO_FSB(mp, xfs_zone_gc_scratch_available(data)));
+	*count_fsb = min(*count_fsb, XFS_B_TO_FSB(mp, data->scratch_available));
 
 	/*
 	 * Directly allocate GC blocks from the reserved pool.
@@ -730,6 +721,7 @@ xfs_zone_gc_start_chunk(
 	bio->bi_end_io = xfs_zone_gc_end_io;
 	xfs_zone_gc_add_data(chunk);
 	data->scratch_head = (data->scratch_head + len) % data->scratch_size;
+	data->scratch_available -= len;
 
 	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 	list_add_tail(&chunk->entry, &data->reading);
@@ -862,6 +854,7 @@ xfs_zone_gc_finish_chunk(
 
 	data->scratch_tail =
 		(data->scratch_tail + chunk->len) % data->scratch_size;
+	data->scratch_available += chunk->len;
 
 	/*
 	 * Cycle through the iolock and wait for direct I/O and layouts to
-- 
2.47.3

