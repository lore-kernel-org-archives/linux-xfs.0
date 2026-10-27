Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.42.203.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793100462;
	b=l67669JslZeiQBNGnIrS+tE1af2x443JKxS06xajHGVl1rltEXzi6ngqOrhgiPsboOTv
	 wvWSa6KpD1O72ZZonE8S6ljKIAUtyeNzmXeVBL+vYVqQfhjJFvfwXZoe8bJot8ZLujfBc
	 MVz54GuPsJpfY4PPN+er8eAQ1x3PyO82LY18AU4dTWaqxrMdIgDachcp3r97b7UzzuMb6
	 smc42PAYv5AxV8LPLjAXh2v/x2PtK0g2x7NAu+HHjVse8TMMl3f3Q1xpMbjfzEwgBQH/r
	 p0xYqEifRAnFTYcPe8ZI+wucHudywrq6YoXH8+J68RaKadvI5WG0u6z1uRM/mpdNAKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793100462;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=5jvQLHxmHD9QuaB15UgfesZNnHvY5cJUMWmBuDVOQiE=;
	b=MrTEvTFNq0GEtaZok3QSx52cCN66tmdR9wN2A4x0ucVQFddO8u+hxhXA1zp2/JAbqZkH
	 fmsUz6A64LgG9fW1wMkpEXKMm1gXQ+BDS7Ux2V8S6s9AoVfIEMIOX6BnpST12qmf+mya2
	 eQXLBZ5kIizPgkPYkm1Xd58fjudwx6mNJq1Igyb52IfoUsK1oEDE9L8krSj3HRUIf06fo
	 Im7PTwfuRMobApAt0OIbomPvqFUzgddHJo/s3fK1MUpCkLPQVU4ILwwa6yp2Nt37uoIdA
	 6oO0O1RbBsQfvDWTrqIA/r9FkaAyUF1GyVudI8rX4kEjN8hvManw/Pp4f+m9ssIx2wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.it;
	spf=pass smtp.mailfrom=amazon.it;
	dkim=pass header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=gHXCpTgu;
	arc=none smtp.remote-ip=52.42.203.116
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6EE606A31E;
	Tue, 27 Oct 2026 11:27:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE6EE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=gHXCpTgu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1793100460; x=1824636460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5jvQLHxmHD9QuaB15UgfesZNnHvY5cJUMWmBuDVOQiE=;
  b=gHXCpTguIWsdl9d8RkVKtQwEt/9xUwZ2ucZ4pRRTKcCO8f6bLICZPUhq
   OuS/KxodjtA7Pxk+DCS4RccZTFV9uosn73pdAegrZKsizyaCOJRUkQgzv
   4NYab8apCot9ctI393RrrmuYBkpUsuOIf3wDAoUuKBja+9ZhrXI2Q9xAq
   4bs+oMf3aF/noUT9KWsGG19cOyUvOo1net/BGxjegbLa0lka5zjuSF972
   K2BwPwk7CUCHBmIpuOR6HNzZOArrejX91XULobUoD7RQtfj9hJrjUmxtb
   qEDh+h9L4m0vwKb2a7XxtgZxTBpYQxk4ct+ZgCFNOUIZoJLCY5B4CNHVC
   w==;
X-CSE-ConnectionGUID: YI+tlux6Rs2IrQWu3VD8mQ==
X-CSE-MsgGUID: F4IqMehCS3avyCB9/1DZ2A==
X-IronPort-AV: E=Sophos;i="6.27,181,1787011200"; 
   d="scan'208";a="32381748"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 11:27:37 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:23383]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.193:2525] with esmtp (Farcaster)
 id a8a19a35-cde8-4181-b3c0-7bc5fd266870; Tue, 27 Oct 2026 11:27:37 +0000 (UTC)
X-Farcaster-Flow-ID: a8a19a35-cde8-4181-b3c0-7bc5fd266870
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 27 Oct 2026 11:27:37 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 27 Oct 2026
 11:27:30 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <ryan.roberts@arm.com>, <abuehaze@amazon.com>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <dipietro.salvatore@gmail.com>, <rvvandan@amazon.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<linkinjeon@kernel.org>, <sj1557.seo@samsung.com>, <yuezhang.mo@sony.com>,
	<miklos@szeredi.hu>, <agruenba@redhat.com>, <djwong@kernel.org>,
	<hyc.lee@gmail.com>, <almaz.alexandrovich@paragon-software.com>,
	<cem@kernel.org>, <dlemoal@kernel.org>, <naohiro.aota@wdc.com>,
	<jth@kernel.org>, <willy@infradead.org>, <david@kernel.org>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <ritesh.list@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<exfat@lists.linux.dev>, <fuse-devel@lists.linux.dev>,
	<gfs2@lists.linux.dev>, <linux-xfs@vger.kernel.org>, <ntfs@lists.linux.dev>,
	<ntfs3@lists.linux.dev>, <stable@vger.kernel.org>
Subject: [PATCH 2/2] mm, iomap: account dirty at page granularity for per-block dirty folios
Date: Tue, 27 Oct 2026 11:27:02 +0000
Message-ID: <20261027112702.3747009-3-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261027112702.3747009-1-dipiets@amazon.it>
References: <20261027112702.3747009-1-dipiets@amazon.it>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The mm dirty counters (NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING,
WB_RECLAIMABLE) are charged per folio, which charges up to 512
pages for a single dirty 4 kB block of a 2 MB folio.  iomap knows
exactly which blocks are dirty and writeback only writes those
ranges, so balance_dirty_pages() ends up throttling writers
against a dirty count far larger than the data that actually
needs writeback.

Charge the counters per dirty page for folios carrying per-block
dirty state, using the infrastructure from the previous patch:
struct iomap_folio_state counts the pages holding a dirty block, and
each dirty bitmap change charges or discharges the difference.  The
charge survives folio_clear_dirty_for_io() and is dropped when
writeback or invalidation clears the blocks.  The monotonic
NR_DIRTIED / WB_DIRTIED / task_io totals are charged only for newly
dirtied data, and the dirty rate limiters stay per-folio.

Every iomap-based filesystem sets .accounted_dirty_pages alongside
.dirty_folio = iomap_dirty_folio.

On pgbench simple-update (1024 clients, XFS, 96-vCPU arm64,
10 iterations) on v7.3-rc7, the unpatched kernel charges 159 TB
of dirtied pages while writing 6 TB to the array, a factor of 27;
with this patch the dirtied pages charged match the data written.
Unpatched, nr_dirty is above dirty_threshold in ~17% of 5s samples
and its peak exceeds it in 9 of 10 iterations; patched, it never
reaches the threshold.

On v7.3-rc7, average throughput rises 46.8% (139.8k -> 205.2k tps)
and run-to-run variability drops from 23.60% to 3.98% coefficient
of variation.  The best iteration improves by 8% (199.4k -> 215.9k
tps); most of the gain comes from the worst iteration, up from 97.9k
to 191.5k tps, i.e. from throttling episodes that no longer happen.

Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improve performance")
Cc: stable@vger.kernel.org # v6.17+
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Reviewed-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
---
 fs/exfat/inode.c       |   1 +
 fs/fuse/file.c         |   1 +
 fs/gfs2/aops.c         |   1 +
 fs/iomap/buffered-io.c | 167 +++++++++++++++++++++++++++++++++++++++--
 fs/ntfs/aops.c         |   2 +
 fs/ntfs3/inode.c       |   2 +
 fs/xfs/xfs_aops.c      |   1 +
 fs/zonefs/file.c       |   1 +
 include/linux/iomap.h  |   1 +
 9 files changed, 171 insertions(+), 6 deletions(-)

diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index ccd13630187e..48704fe5d59b 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -302,6 +302,7 @@ static const struct address_space_operations exfat_aops = {
 	.readahead		= exfat_readahead,
 	.writepages		= exfat_writepages,
 	.dirty_folio		= iomap_dirty_folio,
+	.accounted_dirty_pages	= iomap_accounted_dirty_pages,
 	.bmap			= exfat_aop_bmap,
 	.migrate_folio		= filemap_migrate_folio,
 	.is_partially_uptodate	= iomap_is_partially_uptodate,
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9a36d0329e22..eb7179f854ee 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3101,6 +3101,7 @@ static const struct address_space_operations fuse_file_aops  = {
 	.writepages	= fuse_writepages,
 	.launder_folio	= fuse_launder_folio,
 	.dirty_folio	= iomap_dirty_folio,
+	.accounted_dirty_pages = iomap_accounted_dirty_pages,
 	.release_folio	= iomap_release_folio,
 	.invalidate_folio = iomap_invalidate_folio,
 	.is_partially_uptodate = iomap_is_partially_uptodate,
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 0a7b8076af3a..ea77af00b111 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -713,6 +713,7 @@ static const struct address_space_operations gfs2_aops = {
 	.read_folio = gfs2_read_folio,
 	.readahead = gfs2_readahead,
 	.dirty_folio = iomap_dirty_folio,
+	.accounted_dirty_pages = iomap_accounted_dirty_pages,
 	.release_folio = iomap_release_folio,
 	.invalidate_folio = iomap_invalidate_folio,
 	.bmap = gfs2_bmap,
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..75671b29f7cc 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -5,6 +5,8 @@
  */
 #include <linux/iomap.h>
 #include <linux/buffer_head.h>
+#include <linux/backing-dev.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/writeback.h>
 #include <linux/swap.h>
 #include <linux/migrate.h>
@@ -24,6 +26,13 @@ struct iomap_folio_state {
 	unsigned int		read_bytes_pending;
 	atomic_t		write_bytes_pending;
 
+	/*
+	 * Pages holding at least one dirty block, the unit the mm dirty counters
+	 * work in.  Maintained under @state_lock alongside the dirty bits below,
+	 * so it is what those counters were charged for.
+	 */
+	unsigned int		dirty_pages;
+
 	/*
 	 * Each block has two bits in this bitmap:
 	 * Bits [0..blocks_per_folio) has the uptodate status.
@@ -180,6 +189,89 @@ static unsigned iomap_find_dirty_range(struct folio *folio, u64 *range_start,
 	return range_end - *range_start;
 }
 
+/*
+ * Count pages in [first_blk, last_blk] holding at least one dirty block.  Callers
+ * take this before and after flipping the bitmap for an exact delta, so each page
+ * is scanned over its full block span to land in the same page in both counts.
+ * state_lock must be held.
+ */
+static unsigned int ifs_count_dirty_pages(struct folio *folio,
+		struct iomap_folio_state *ifs, unsigned int first_blk,
+		unsigned int last_blk)
+{
+	struct inode *inode = folio->mapping->host;
+	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
+	unsigned int blkbits = inode->i_blkbits;
+	size_t fsize = folio_size(folio);
+	size_t start = (size_t)first_blk << blkbits;
+	size_t end = min(((size_t)last_blk << blkbits) + (1UL << blkbits) - 1,
+			 fsize - 1);
+	unsigned long first_pg = start >> PAGE_SHIFT;
+	unsigned long last_pg = end >> PAGE_SHIFT;
+	unsigned int dirty_pages = 0;
+	unsigned long pg;
+
+	for (pg = first_pg; pg <= last_pg; pg++) {
+		size_t pg_start = pg << PAGE_SHIFT;
+		size_t pg_end = min(pg_start + PAGE_SIZE - 1, fsize - 1);
+		unsigned int b_lo = pg_start >> blkbits;
+		unsigned int b_hi = pg_end >> blkbits;
+		unsigned int b;
+
+		for (b = b_lo; b <= b_hi; b++) {
+			if (test_bit(b + blks_per_folio, ifs->state)) {
+				dirty_pages++;
+				break;
+			}
+		}
+	}
+	return dirty_pages;
+}
+
+/*
+ * Mirror folio_account_dirtied() in page-sized increments; @nr_pages is positive
+ * to charge and negative to discharge.
+ *
+ * The NR_DIRTIED/WB_DIRTIED/task_io totals are monotonic, so only @new_dirty data
+ * may charge them; writeback re-marks an already charged folio.
+ *
+ * Only the folio lock is held, not i_pages, hence the IRQ-safe stat helpers.
+ */
+static void iomap_account_dirty_pages(struct folio *folio, long nr_pages,
+		bool new_dirty)
+{
+	struct address_space *mapping = folio->mapping;
+	struct inode *inode = mapping->host;
+	struct wb_lock_cookie cookie = {};
+	struct bdi_writeback *wb;
+	bool dirtied = nr_pages > 0 && new_dirty;
+
+	if (!nr_pages || !mapping_can_writeback(mapping))
+		return;
+
+	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr_pages);
+	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr_pages);
+	if (dirtied)
+		node_stat_mod_folio(folio, NR_DIRTIED, nr_pages);
+
+	/* Pin the wb against a concurrent inode_do_switch_wbs(). */
+	inode_attach_wb(inode, folio);
+	wb = unlocked_inode_to_wb_begin(inode, &cookie);
+	wb_stat_mod(wb, WB_RECLAIMABLE, nr_pages);
+	if (folio_test_dropbehind(folio))
+		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr_pages);
+	if (dirtied)
+		wb_stat_mod(wb, WB_DIRTIED, nr_pages);
+	unlocked_inode_to_wb_end(inode, &cookie);
+
+	if (dirtied) {
+		task_io_account_write(nr_pages * PAGE_SIZE);
+	} else if (nr_pages < 0 && !folio_test_writeback(folio)) {
+		/* truncated or invalidated before reaching disk, so refund */
+		task_io_account_cancelled_write((-nr_pages) * PAGE_SIZE);
+	}
+}
+
 /*
  * Clear the per-block dirty bits for the range [@off, @off + @len) within a
  * folio.  The range is rounded inwards so that only blocks fully covered by
@@ -195,15 +287,22 @@ static void ifs_clear_range_dirty(struct folio *folio,
 	unsigned int first_blk = round_up(off, i_blocksize(inode)) >>
 				 inode->i_blkbits;
 	unsigned int last_blk = (off + len) >> inode->i_blkbits;
+	unsigned int before, after;
 	unsigned long flags;
 
 	if (first_blk >= last_blk)
 		return;
 
 	spin_lock_irqsave(&ifs->state_lock, flags);
+	before = ifs_count_dirty_pages(folio, ifs, first_blk, last_blk - 1);
 	bitmap_clear(ifs->state, first_blk + blks_per_folio,
 		     last_blk - first_blk);
+	after = ifs_count_dirty_pages(folio, ifs, first_blk, last_blk - 1);
+	ifs->dirty_pages -= before - after;
 	spin_unlock_irqrestore(&ifs->state_lock, flags);
+
+	/* Pages that lost their last dirty block, so before >= after. */
+	iomap_account_dirty_pages(folio, -(long)(before - after), false);
 }
 
 static void iomap_clear_range_dirty(struct folio *folio, size_t off, size_t len)
@@ -222,11 +321,13 @@ static void iomap_clear_range_dirty(struct folio *folio, size_t off, size_t len)
  * data loss when partial blocks are written.
  */
 static void ifs_set_range_dirty(struct folio *folio,
-		struct iomap_folio_state *ifs, size_t off, size_t len)
+		struct iomap_folio_state *ifs, size_t off, size_t len,
+		bool new_dirty)
 {
 	struct inode *inode = folio->mapping->host;
 	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
 	unsigned int first_blk, last_blk;
+	unsigned int before, after;
 	unsigned long flags;
 
 	if (!len)
@@ -235,9 +336,15 @@ static void ifs_set_range_dirty(struct folio *folio,
 	first_blk = off >> inode->i_blkbits;
 	last_blk = (off + len - 1) >> inode->i_blkbits;
 	spin_lock_irqsave(&ifs->state_lock, flags);
+	before = ifs_count_dirty_pages(folio, ifs, first_blk, last_blk);
 	bitmap_set(ifs->state, first_blk + blks_per_folio,
 		   last_blk - first_blk + 1);
+	after = ifs_count_dirty_pages(folio, ifs, first_blk, last_blk);
+	ifs->dirty_pages += after - before;
 	spin_unlock_irqrestore(&ifs->state_lock, flags);
+
+	/* Pages that gained their first dirty block, so after >= before. */
+	iomap_account_dirty_pages(folio, (long)(after - before), new_dirty);
 }
 
 static void iomap_set_range_dirty(struct folio *folio, size_t off, size_t len)
@@ -245,7 +352,20 @@ static void iomap_set_range_dirty(struct folio *folio, size_t off, size_t len)
 	struct iomap_folio_state *ifs = folio->private;
 
 	if (ifs)
-		ifs_set_range_dirty(folio, ifs, off, len);
+		ifs_set_range_dirty(folio, ifs, off, len, true);
+}
+
+/*
+ * Set the dirty bits for blocks that were already dirty, and already counted,
+ * before this folio had per-block state: the reclaimable counters still move,
+ * but the dirtied totals must not be charged twice.
+ */
+static void iomap_redirty_range(struct folio *folio, size_t off, size_t len)
+{
+	struct iomap_folio_state *ifs = folio->private;
+
+	if (ifs)
+		ifs_set_range_dirty(folio, ifs, off, len, false);
 }
 
 static struct iomap_folio_state *ifs_alloc(struct inode *inode,
@@ -276,9 +396,13 @@ static struct iomap_folio_state *ifs_alloc(struct inode *inode,
 	spin_lock_init(&ifs->state_lock);
 	if (folio_test_uptodate(folio))
 		bitmap_set(ifs->state, 0, nr_blocks);
-	if (folio_test_dirty(folio))
+	if (folio_test_dirty(folio)) {
 		bitmap_set(ifs->state, nr_blocks, nr_blocks);
+		ifs->dirty_pages = folio_nr_pages(folio);
+	}
 	folio_attach_private(folio, ifs);
+	/* The mm dirty counters are now charged per dirty page for this file. */
+	mapping_set_dirty_per_block(inode->i_mapping);
 
 	return ifs;
 }
@@ -839,6 +963,11 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len)
 	 */
 	if (offset == 0 && len == folio_size(folio)) {
 		WARN_ON_ONCE(folio_test_writeback(folio));
+		/*
+		 * Discharge while the bitmap is still attached; ifs_free() below
+		 * drops the state that records how many pages were charged.
+		 */
+		iomap_clear_range_dirty(folio, 0, folio_size(folio));
 		folio_cancel_dirty(folio);
 		ifs_free(folio);
 	} else {
@@ -854,10 +983,31 @@ bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio)
 
 	ifs_alloc(inode, folio, 0);
 	iomap_set_range_dirty(folio, 0, len);
-	return filemap_dirty_folio(mapping, folio);
+	return __filemap_dirty_folio(mapping, folio, folio->private);
 }
 EXPORT_SYMBOL_GPL(iomap_dirty_folio);
 
+/**
+ * iomap_accounted_dirty_pages - pages of @folio charged to the dirty counters
+ * @folio: folio to query
+ *
+ * For callers that discharge what iomap charged.  The caller must hold the folio
+ * lock, and @folio must have per-block state attached.
+ *
+ * Return: pages of @folio holding at least one dirty block, zero once they have
+ * been cleared, so a later discharge does not double count.
+ */
+long iomap_accounted_dirty_pages(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+
+	if (WARN_ON_ONCE(!ifs))
+		return 0;
+
+	return ifs->dirty_pages;
+}
+EXPORT_SYMBOL_GPL(iomap_accounted_dirty_pages);
+
 static void
 iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 {
@@ -1137,7 +1287,7 @@ static bool __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 		return false;
 	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
 	iomap_set_range_dirty(folio, offset_in_folio(folio, pos), copied);
-	filemap_dirty_folio(inode->i_mapping, folio);
+	__filemap_dirty_folio(inode->i_mapping, folio, folio->private);
 	return true;
 }
 
@@ -2001,8 +2151,13 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 
 	if (i_blocks_per_folio(inode, folio) > 1) {
 		if (!ifs) {
+			/*
+			 * Dirtied before it had per-block state, so charged
+			 * per-folio.  Re-mark the blocks for the walk below,
+			 * paired with the clear at the end of this function.
+			 */
 			ifs = ifs_alloc(inode, folio, 0);
-			iomap_set_range_dirty(folio, 0, end_pos - pos);
+			iomap_redirty_range(folio, 0, end_pos - pos);
 		}
 
 		iomap_writeback_init(inode, folio);
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 517d9a1563e7..d26ddd5ae118 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -308,6 +308,7 @@ const struct address_space_operations ntfs_aops = {
 	.readahead		= ntfs_readahead,
 	.writepages		= ntfs_writepages,
 	.dirty_folio		= iomap_dirty_folio,
+	.accounted_dirty_pages	= iomap_accounted_dirty_pages,
 	.bmap			= ntfs_bmap,
 	.migrate_folio		= filemap_migrate_folio,
 	.is_partially_uptodate	= iomap_is_partially_uptodate,
@@ -322,6 +323,7 @@ const struct address_space_operations ntfs_mft_aops = {
 	.readahead		= ntfs_readahead,
 	.writepages		= ntfs_mft_writepages,
 	.dirty_folio		= iomap_dirty_folio,
+	.accounted_dirty_pages	= iomap_accounted_dirty_pages,
 	.bmap			= ntfs_bmap,
 	.migrate_folio		= filemap_migrate_folio,
 	.is_partially_uptodate	= iomap_is_partially_uptodate,
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 4ac26c80bd34..509570091e48 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -2301,6 +2301,7 @@ const struct address_space_operations ntfs_aops = {
 	.writepages	= ntfs_writepages,
 	.bmap		= ntfs_bmap,
 	.dirty_folio	= iomap_dirty_folio,
+	.accounted_dirty_pages = iomap_accounted_dirty_pages,
 	.migrate_folio	= filemap_migrate_folio,
 	.release_folio	= iomap_release_folio,
 	.invalidate_folio = iomap_invalidate_folio,
@@ -2309,6 +2310,7 @@ const struct address_space_operations ntfs_aops = {
 const struct address_space_operations ntfs_aops_cmpr = {
 	.read_folio	= ntfs_read_folio,
 	.dirty_folio	= iomap_dirty_folio,
+	.accounted_dirty_pages = iomap_accounted_dirty_pages,
 	.release_folio	= iomap_release_folio,
 	.invalidate_folio = iomap_invalidate_folio,
 };
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8b6119776fb3..869248241f3b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -682,6 +682,7 @@ const struct address_space_operations xfs_address_space_operations = {
 	.readahead		= xfs_vm_readahead,
 	.writepages		= xfs_vm_writepages,
 	.dirty_folio		= iomap_dirty_folio,
+	.accounted_dirty_pages	= iomap_accounted_dirty_pages,
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
 	.bmap			= xfs_vm_bmap,
diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 5b34849be7a2..9847ce9cd68b 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -192,6 +192,7 @@ const struct address_space_operations zonefs_file_aops = {
 	.readahead		= zonefs_readahead,
 	.writepages		= zonefs_writepages,
 	.dirty_folio		= iomap_dirty_folio,
+	.accounted_dirty_pages	= iomap_accounted_dirty_pages,
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
 	.migrate_folio		= filemap_migrate_folio,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bc7ae6327dbf..fbf6480ac928 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -444,6 +444,7 @@ bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
 void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
 void iomap_folio_mark_uptodate(struct folio *folio);
+long iomap_accounted_dirty_pages(struct folio *folio);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops,
 		const struct iomap_write_ops *write_ops);
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



