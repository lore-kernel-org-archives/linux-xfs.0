Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE196146A66;
	Fri, 10 Jul 2026 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694092; cv=none; b=eUPjrw1YENmxkVewbAcmTnSzIhi3fgAESNkLz00yEP66m+3p4KUSTLKe0GwOD4QzyYyqBEr+r3OA5ksPl1Vbp4J1M69HEBa1YEEqBONhYmciHi0P9myhSFBddf/gEqF/ssSkfg2kDUKG7+kuljZt91vlPgBxLLtump2f4DmiB2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694092; c=relaxed/simple;
	bh=hohyGIudVV76Azp7eoofb46r2GHVhkLAECsSkc2AAvQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BvuGy497wDID5Cv/69dS3U2JIH5Jqk5fwrBb+r4NZWsbfqjAgLJgjPDF2q+Kp1Yrjg4k4mD0YOPTss3KPcZ0ArunpiKVSZGYSRm5wTzAZ1nCaGejaNAJUvHjicXBDF+dP9ZM6SW78Wr3w4KckAuuj7bBDCryxFbhSW6G+NN5E60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=oDoZdjfY; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="oDoZdjfY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1783694090; x=1815230090;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=17wN6bI8K7p4bpbOPomGtPmEnN2JA1DpTrObaGoec0I=;
  b=oDoZdjfYHpnodHF/Bpz4JclbU87AuVjYb6iVpdxb5Qp4DuFWidmFBqNV
   DC1lEH5ZO1lKVLTLHu/Y0cyUlDe7iAIN5qeMkqII8G0bx9UqqOiIjXraz
   Qezu2KBIrn+K5iRMZybQaoWu+GER5r0Pb2hVFKnsuQNFUfKZ9Mm8Yk/4K
   qS0bHsnVn1TVvQBJ2DgyHSZ1N8Ffs1kr89YXvy39orw6fVgzDajQDQJo8
   Q5hXE1EcUcX8WHClF/JJHC0/bbzCt2C0bmYEBPCxK6QUnWCQeXoMCWlO0
   KtvTf4C6ud5iCGLTzg631NSYqP6Gs+kP1DVg/GCduV29hnGgFioEKWCd9
   A==;
X-CSE-ConnectionGUID: qoQZ4hc2TiOj5y7MNgzhAg==
X-CSE-MsgGUID: GJ86N9zrRr6DpC/VgnKiDg==
X-IronPort-AV: E=Sophos;i="6.25,154,1779148800"; 
   d="scan'208";a="23425232"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 14:34:48 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:26245]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.115:2525] with esmtp (Farcaster)
 id 120982db-2d0e-4772-9af7-73c84f425e33; Fri, 10 Jul 2026 14:34:47 +0000 (UTC)
X-Farcaster-Flow-ID: 120982db-2d0e-4772-9af7-73c84f425e33
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 10 Jul 2026 14:34:47 +0000
Received: from cdd-dev.amazon.com (172.22.139.101) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 10 Jul 2026 14:34:47 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-mm@kvack.org>, <hch@infradead.org>, <willy@infradead.org>,
	<ritesh.list@gmail.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<dgc@kernel.org>, <vbabka@suse.cz>, <djwong@kernel.org>,
	<brauner@kernel.org>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<abuehaze@amazon.com>, <dipietro.salvatore@gmail.com>,
	<stable@vger.kernel.org>, Vlastimil Babka <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Brendan
 Jackman" <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>
Subject: [PATCH v3] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 10 Jul 2026 14:34:37 +0000
Message-ID: <20260710143437.12379-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D033UWC003.ant.amazon.com (10.13.139.217) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write
path.  When memory is fragmented, each failed costly-order allocation
enters __alloc_pages_slowpath() which runs direct compaction and
drain_all_pages(), causing a 0.45x throughput drop on PostgreSQL
pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct compaction is too expensive for hot
allocation paths that have fallbacks to smaller allocations.
__filemap_get_folio_mpol() already marks higher-order allocations with
__GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
failure.  However, the page allocator still attempts full direct
compaction for costly orders with __GFP_NORETRY, which is unnecessarily
aggressive when the caller will simply retry at a lower order.

For costly-order allocations with __GFP_NORETRY, skip direct compaction
but wake kcompactd on the preferred node so that background compaction
can defragment memory for future allocations, and return failure
immediately so the caller can fall back.

This keeps compaction working for long-term system health while
removing it from the latency-critical direct allocation path.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    next-20260707
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                   Avg TPS      % vs Baseline
  baseline (no patch)       70,389.24    -
  With this patch          154,977.02   +120.17%


Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
v1: Avoid compaction in iomap folio allocation

 mm/page_alloc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a63733dac659..2d02703d8f0f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4883,6 +4883,26 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	/* If allocation has taken excessively long, warn about it */
 	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
 
+	/*
+	 * Costly allocations with __GFP_NORETRY are opportunistic - Don't
+	 * stall on direct compaction or reclaim; instead, kick
+	 * kcompactd on the preferred node so large pages may become
+	 * available for future allocations and let the caller fall back now.
+	 *
+	 * Direct compaction is way too costly for hot allocation paths on
+	 * large systems: each attempt calls drain_all_pages() which IPIs
+	 * every CPU.  Only wake kcompactd on the local node to avoid
+	 * cross-NUMA interference with unrelated workloads.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY)) {
+		struct zone *preferred_zone = ac->preferred_zoneref->zone;
+
+		if (preferred_zone)
+			wakeup_kcompactd(preferred_zone->zone_pgdat, order,
+					 ac->highest_zoneidx);
+		goto nopage;
+	}
+
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
 		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
-- 
2.47.3




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



