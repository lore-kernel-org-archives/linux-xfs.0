Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBED0348896;
	Fri, 11 Sep 2026 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789136499; cv=none; b=FwMPe3/YcTRTe1UZ1H/uL5rFlrqM6Lb6KmR51LdHQfSNNpXIOanRNQHhjuiT3SRXKCVZVdczzKHqyZbCwJHk9FS3IHsQjsoDz9cmJ7ozTA8Vw/Ds6TeGgTSeP8dUrz4UN++fDSjI4TBAsFfG7tRwuPcvnXEtp1B/NfGcZMumikw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789136499; c=relaxed/simple;
	bh=VUEzRwZBbW36v01xG0o83cDpXLNyNmfI9HXo44wIdn4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QHM+ExN9vJVlqjbuhzy6P3tJmOnGrhKxj4ajVreKaoybMzRyINs2XukvN60LnHbPpWxnm0X7n9ofpo1cNEhFHVMhRIOz4eOe9nPnY5MeAu21hfTj+oHYHKexr3v3ogc5fynrJcY7jZGeH0Zjcs7aCYy1HXZZ25Q/MgBzuKhm0S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=OYDx4bVs; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="OYDx4bVs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789136498; x=1820672498;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gptPpxw0wFk91egaNInUnptSeER0SPdng9bGfnf/tP4=;
  b=OYDx4bVs8WPzmf1ZCTC6WZ+uu1YRP/M2lVFUTIXC98/4zFEUwY87NTPz
   0oHsa6QWY9tk0WxX3HAunbKkUdyvNCTnfEsbc68imQ5NiJHWTAlEo+TZH
   RI+nMjmcSMjNsfrAyw/FFU3q+9FXBo1wZhZWIhbyDrB3+jWaMx2wu5oXi
   HBcRAnZMAc8Ebu5BThQ5YRSUc2V4m9qPLajoF4z9czcgoeMiZqgJR73L7
   KwDQDaWx2u3Gru/UmNIZuDunnAEcYkAF85WJ6qRUcSNyZLq0YwXrQcotx
   Kiqq/IFyPGUdHkcu3dVYFuCvOCnORLHgYv4dEMIYAbZLC5u44OjUd/qDz
   w==;
X-CSE-ConnectionGUID: I7XG1V8IQNGYo35kGCunpg==
X-CSE-MsgGUID: TOfcsjxZS1+qduGqGhMONw==
X-IronPort-AV: E=Sophos;i="6.27,97,1787011200"; 
   d="scan'208";a="28340119"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 14:21:35 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:24846]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.198:2525] with esmtp (Farcaster)
 id 15edf2e1-39ad-4826-a4a7-d73e88fdd306; Fri, 11 Sep 2026 14:21:35 +0000 (UTC)
X-Farcaster-Flow-ID: 15edf2e1-39ad-4826-a4a7-d73e88fdd306
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 11 Sep 2026 14:21:34 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 11 Sep 2026
 14:21:30 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-kernel@vger.kernel.org>
CC: <hch@infradead.org>, <abuehaze@amazon.com>, <akpm@linux-foundation.org>,
	<alisaidi@amazon.com>, <blakgeof@amazon.com>, <brauner@kernel.org>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>, Vlastimil Babka
	<vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Christoph Hellwig
	<hch@lst.de>, Brendan Jackman <brendan.jackman@linux.dev>
Subject: [PATCH v5] mm/page_alloc: avoid direct compaction for costly  __GFP_NORETRY allocations
Date: Fri, 11 Sep 2026 14:21:02 +0000
Message-ID: <20260911142102.2294202-1-dipiets@amazon.it>
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

For costly-order allocations with __GFP_NORETRY, suppress direct reclaim
for the whole slowpath by computing can_direct_reclaim (and hence
can_compact) as false.  The !can_direct_reclaim check near the top of
the slowpath then short-circuits to nopage: no direct reclaim, no direct
compaction and no drain_all_pages() IPI across every CPU.  kswapd (and
in turn kcompactd) is still woken further down for background
defragmentation, so compaction keeps working for long-term system health
while being removed from the latency-critical direct allocation path.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
must-not-fail allocation is never made to fail.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):
  Config                                       Avg TPS   % vs baseline
  AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
  v7.3-rc1 baseline (no patch)                  59,408             -
  v7.3-rc1 + this patch                        161,994       +172.7%

The patch fully recovers the pre-5d8edfb900d5 performance, bringing
throughput back above the pre-regression level and well clear of the
~59k baseline.  The AL2023 6.1 row runs a kernel that predates commit
5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not
directly comparable, but it shows the pre-regression level and confirms
that the ~59k baseline is the anomaly and not the norm.


Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
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
Cc: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
v5: Derive the decision into a local flag instead of mutating gfp_mask
v4: Clear __GFP_DIRECT_RECLAIM early in the slowpath and exempt
    __GFP_THISNODE so THP attempt keeps using direct compaction
v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
v1: Avoid compaction in iomap folio allocation

 mm/page_alloc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..be8b0d72a2db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4784,10 +4784,22 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback to a lower order,
+	 * so don't stall them in direct reclaim or direct compaction.  Exempt
+	 * __GFP_THISNODE (the THP attempt from alloc_pages_mpol() needs direct
+	 * compaction) and __GFP_NOFAIL (must not be made to fail).  Don't
+	 * clear __GFP_DIRECT_RECLAIM from gfp_mask instead: that would also
+	 * change the alloc_flags derived by alloc_flags_slowpath().
+	 */
+	const bool costly_noretry = costly_order &&
+		(gfp_mask & __GFP_NORETRY) &&
+		!(gfp_mask & (__GFP_THISNODE | __GFP_NOFAIL));
+	bool can_direct_reclaim = !costly_noretry &&
+		(gfp_mask & __GFP_DIRECT_RECLAIM);
 	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
-	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



