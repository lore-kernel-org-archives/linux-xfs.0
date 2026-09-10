Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C7947C112;
	Thu, 10 Sep 2026 11:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789040809; cv=none; b=cV1Ku7oVUvasXv8YBIFLxZdfCeF4J2a25VDK3/jdiBzoE5WMIpRW2UzOUk1vyoWfJegs27RkE9LZKEyQU4vF/Vmb9MeY4Zrqtw/lrVcn1/Dz4kwMXjCS3PvwoFeKej8zXvvFBCOy4SGRutF++bYQaQXum+J8niZB0TOfBKzqJ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789040809; c=relaxed/simple;
	bh=d7z6KPD6K9yAbT6rqth8+0jINVsF/Bf64K/NCCQDth4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NcaRyy2ZMkK1VvZ8bQ1ELq4Wh/dUC+NiaqiZL2P+M1hKxFYjvwDFIS0SIhR4etJrwTuHChhvGYCbzpNyD8L8oYOcMX2Z2i72+Kn51BAnHT4zQDWO+VhiATcLuoIuqyl5aDmbG/iD/c76aWeF+vtY71gbDjwjfIHgNz5eoiu2Pa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=AEcqfbDC; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="AEcqfbDC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789040802; x=1820576802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zIxMe7CUOIbyICiMyGkhisOqvvsyopgrlubg8GsVc3c=;
  b=AEcqfbDCDXAvt011rwBnjlhxM/xy9gfu1gvUpXPZXotAMAjJ9Myhu5HM
   nOLmFmTVnAnCR/mbrwijotmrd5la9u4SJq5zjGE8qLithggsmyZSOqaDj
   rbPoQ26MVEYRXneC29m5Cr39l4u5rLBJQ/ZOAMc9xgMeneq4NM7cI7MOC
   /qovnsQOaVGvSUZf7As3kazauQhjgKdaM/9HdyOJzTyUCdZ5ypaNn3gtp
   T5qfCbnrlq+pwlsbna2DOwBhsRGLhs9LqfscnZl3iSXaGWuZnO/qBtl8b
   ykPvVSmzksI8EH8T5tlNAKQ7RuGdVqf3g3Gq1/8QYrubGj8ZBvbXhjBHB
   A==;
X-CSE-ConnectionGUID: PrxB9U2pTCO3cOtOxIS8kQ==
X-CSE-MsgGUID: 71u9WAD7TGq5z4s2L10l2A==
X-IronPort-AV: E=Sophos;i="6.27,95,1787011200"; 
   d="scan'208";a="28190348"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 11:46:36 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:31293]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.113:2525] with esmtp (Farcaster)
 id 723b55c1-1dd1-4458-a7f0-829821daf3d6; Thu, 10 Sep 2026 11:46:36 +0000 (UTC)
X-Farcaster-Flow-ID: 723b55c1-1dd1-4458-a7f0-829821daf3d6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 10 Sep 2026 11:46:36 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Thu, 10 Sep 2026
 11:46:31 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <hch@infradead.org>, <hch@lst.de>,
	<jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <vbabka@suse.cz>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Thu, 10 Sep 2026 11:46:02 +0000
Message-ID: <20260910114602.926944-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Sat, 05 Sep 2026 17:42:39 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Is there anything particularly unusual about this test case?

It is a stock pgbench simple-update PostgreSQL workload on a large
instance (96 vCPUs), using standard PostgreSQL settings and with no huge
pages assigned to the database. We deliberately overprovision the
pgbench clients: 1024 clients over 96 threads. That keeps enough writers
in the buffered write path concurrently to hit the costly-order
allocation failure path continuously. The memory fragmentation comes from 
page tables: PostgreSQL spawns a new process per client, and those page
tables consume ~40% of memory, which significantly limits the page cache
and the free memory available.


> > Results (average of 3 runs, TPS):
> >
> >   Config                   Avg TPS      % vs Baseline
> >   baseline (no patch)       59,408       -
> >   With this patch          155,409      +161.6%
>
> Is this back to pre-5d8edfb900d5 performance?

Yes - fully recovered. Here is the summary, same host and workload
throughout, average of 3 runs:

  Config                                        Avg TPS   % vs baseline
  AL2023 stock 6.1 kernel                       136,942            n/a
  v7.3-rc1 baseline (no patch)                   59,408             -
  v7.3-rc1, 5d8edfb900d5 behaviour reverted     151,184        +154.5%
  v7.3-rc1 + v4                                 155,409        +161.6%

The 6.1 row predates 5d8edfb900d5 entirely. A different kernel version,
so not directly comparable, but it shows the performance this workload
used to get on this host.

A literal "git revert 5d8edfb900d5" does not apply to v7.3-rc1 -
iomap_write_iter() has been rewritten since - so the reverted row is a
one-line behavioural revert, forcing the write loop back to copying at
most PAGE_SIZE per iteration:

  -	size_t chunk = mapping_max_folio_size(mapping);
  +	size_t chunk = PAGE_SIZE;

which is what the pre-5d8edfb900d5 loop computed. That makes
iomap_get_folio() pass no order hint, so the path issues only order-0
allocations.


> AI review asked a few serious-looking questions:
> 	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it

Thanks for pointing that out. To address them, we can have something
like the patch below. Performance results are still similar to v4. Happy
to submit a formal v5 patch with it if you would like.

  Config                                        Avg TPS   % vs baseline
  v7.3-rc1 baseline (no patch)                   59,408             -
  v7.3-rc1 + v4                                 155,409        +161.6%
  v7.3-rc1 + proposed patch                     161,994        +172.7%

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


Thanks,
Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



