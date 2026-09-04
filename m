Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40652495022;
	Fri,  4 Sep 2026 11:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523031; cv=none; b=FPO7BX4xrt3YBHK9HIeNJgwUR91nvBsVaIMY9rZMIFQMJo3I0Y+7HoUZeWY4mQ6I8ZZvDAlONdtqyT5xaucrz+UOnRA010rc0mfsgVCjNo2sU1jfHSDmZkyuJrzzOPkX5z8Yw8PJs23+mOYGuxi3X7CJClqgwS3gThkWD8oUlwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523031; c=relaxed/simple;
	bh=KCaZ/7WPMv1EdIHUVBFLlhu9macY3vqtcdBoHCcEwpU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uTM8zBAoPYos05GuTFMp9UEgRBYMkeoGhS0Lj7L4OtPvCW9k/dKX5L0wRgHgRUgM2rPapHjMjFP0fOPriy56jTqzscOtaykyYFRlFegA5cbl55vyLT1/lDJJ/U1WTXFn1Qu6rzP3kHW4dyCB0WUA3lpq87wssMCYloamJcnd+LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=fxr57ki3; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="fxr57ki3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1788523028; x=1820059028;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SOjD2ZTgpTZf/InCnmcmr36L5a0mZycSlAjIYBy93Ps=;
  b=fxr57ki3c516dtzG+fuseZO5S6xSjMpG5UdTBPTK4X19gu0zl82BZnZC
   z06PQwn8jnR7F2P0pzy20JJOGBmKv72Ca8++l0MbDfbZwKLxwugbBzTJa
   akzgqHM4R8YRbZcBcKzZqbWFthCVCITyBlkOHo8tnKZtzd4NrAy2ZPggA
   acYY0uTPZ77AxRo8zpDk3fEZfQ2B4D/LQB2uUNdsDrreThQ2jRrZ/U/6m
   CJpDqcItlgVwVRbmjKPGP3Rnluu45PqKUsdjvHG04E4mev7mK3MkEAOUB
   kBn4gBuZ0OGOHRgwQqt6LngTRqqWFYSimMjpQ3svuDPcf99yMOXUyjzH5
   w==;
X-CSE-ConnectionGUID: iAXNTirhSJaOs9v4vT772A==
X-CSE-MsgGUID: O4XTqRyDTUOIEtI3JKf8Ig==
X-IronPort-AV: E=Sophos;i="6.25,262,1779148800"; 
   d="scan'208";a="27847546"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 11:57:03 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:15535]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.115:2525] with esmtp (Farcaster)
 id b4a5571f-f245-4ceb-b67a-51094f9b8089; Fri, 4 Sep 2026 11:57:02 +0000 (UTC)
X-Farcaster-Flow-ID: b4a5571f-f245-4ceb-b67a-51094f9b8089
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 4 Sep 2026 11:57:02 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 4 Sep 2026
 11:56:57 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-kernel@vger.kernel.org>, <hch@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dgc@kernel.org>,
	<dipietro.salvatore@gmail.com>, <dipiets@amazon.it>, <djwong@kernel.org>,
	<hannes@cmpxchg.org>, <jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <mhocko@suse.com>,
	<ritesh.list@gmail.com>, <rvvandan@amazon.com>, <stable@vger.kernel.org>,
	<surenb@google.com>, <vbabka@kernel.org>, <willy@infradead.org>,
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand
	<david@redhat.com>, Christoph Hellwig <hch@lst.de>, Brendan Jackman
	<brendan.jackman@linux.dev>
Subject: [PATCH v4] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 4 Sep 2026 11:56:28 +0000
Message-ID: <20260904115629.3993331-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write
path.  When memory is fragmented, each failed costly-order allocation
enters __alloc_pages_slowpath() which runs direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct compaction is too expensive for hot
allocation paths that have fallbacks to smaller allocations.
__filemap_get_folio_mpol() already marks higher-order allocations with
__GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
failure.  However, the page allocator still attempts full direct
compaction for costly orders with __GFP_NORETRY, which is unnecessarily
aggressive when the caller will simply retry at a lower order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.
This makes the entire slowpath treat the request as non-blocking: no
direct reclaim, no direct compaction and no drain_all_pages() IPI
across every CPU. kswapd (and in turn kcompactd) is still woken further
down for background defragmentation, so compaction keeps working for
long-term system health while being removed from the latency-critical
direct allocation path.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                   Avg TPS      % vs Baseline
  baseline (no patch)       59,408       -
  With this patch          155,409      +161.6%

Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
v4: Clear __GFP_DIRECT_RECLAIM early in the slowpath and exempt
    __GFP_THISNODE so THP attempt keeps using direct compaction
v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
v1: Avoid compaction in iomap folio allocation

 mm/page_alloc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..542c2ec31061 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4784,10 +4784,10 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
-	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	bool can_direct_reclaim;
+	bool can_compact;
+	bool nofail;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
@@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	bool can_retry_reserves = true;
 	unsigned long alloc_start_time = jiffies;
 
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
+	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
+	    !(gfp_mask & __GFP_THISNODE))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
+	nofail = gfp_mask & __GFP_NOFAIL;
+
 	if (unlikely(nofail)) {
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



